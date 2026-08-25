<#
.SYNOPSIS
    Installs the OPC UA specification tools on Windows: the .NET SDK if it is missing, and then
    the tools themselves from nuget.org.

.DESCRIPTION
    The Windows counterpart of install-tools.sh. Two tools are published, and by default both are
    installed:

        Opc.Ua.SpecificationPublisher
            markdown + UANodeSet -> NISO STS XML, and the browsable HTML edition.
            Cross-platform; needs no Office.

        Opc.Ua.SpecificationValidator
            Word .docx -> NISO STS XML, validation of an STS document's tables against its
            NodeSets, and NodeSet documentation update. Its preprocess, convert and
            convert-validate verbs drive Microsoft Word through COM, so they need Word
            installed; validate and update-nodeset read XML and need nothing.

    Safe to run twice. Everything it does is checked first, and an installed tool is updated
    rather than reinstalled, so a second run on a machine that is already set up reports what it
    found and changes nothing else.

    What it trusts, since installing a toolchain is exactly where that matters:

        https://dot.net/v1/dotnet-install.ps1   Microsoft's own installer script, over TLS
        https://api.nuget.org                   the packages, from the public feed

    Nothing here needs an elevated prompt. The SDK, if one has to be installed, goes under your
    user profile and is removed by deleting a folder; the tools go where every .NET global tool
    goes.

.PARAMETER Tool
    Which tools to install: Publisher, Validator or Both. Default Both.

.PARAMETER PublisherVersion
    Install this version of the publisher instead of the newest stable. A preview has to be named
    in full, because NuGet excludes prereleases otherwise:

        -PublisherVersion 1.0.36-preview-gdf34f48627

.PARAMETER ValidatorVersion
    The same, for the validator.

.PARAMETER DotnetRoot
    Where to put the SDK if one has to be installed. Defaults to %USERPROFILE%\.dotnet, or
    $env:DOTNET_ROOT if you have already set it. Ignored when a .NET 10 SDK is already present.

.EXAMPLE
    .\install-tools.ps1

    Installs or updates both tools.

.EXAMPLE
    .\install-tools.ps1 -Tool Validator

    The validator only.

.EXAMPLE
    .\install-tools.ps1 -Tool Publisher -PublisherVersion 1.0.36-preview-gdf34f48627

    Pins a preview build.

.NOTES
    If PowerShell refuses to run this at all, it is the execution policy rather than anything
    here. Run it for the one process:

        powershell -ExecutionPolicy Bypass -File .\install-tools.ps1
#>
[CmdletBinding()]
param(
    [ValidateSet('Publisher', 'Validator', 'Both')]
    [string]$Tool = 'Both',

    [string]$PublisherVersion,

    [string]$ValidatorVersion,

    [string]$DotnetRoot
)

$ErrorActionPreference = 'Stop'

$PublisherPackage = 'OPCFoundation.Opc.Ua.SpecificationPublisher'
$PublisherCommand = 'Opc.Ua.SpecificationPublisher'
$ValidatorPackage = 'OPCFoundation.Opc.Ua.SpecificationValidator'
$ValidatorCommand = 'Opc.Ua.SpecificationValidator'

$DotnetChannel = '10.0'
$InstallerUrl = 'https://dot.net/v1/dotnet-install.ps1'

# Where a .NET global tool is put, and therefore where the tools will be found. Fixed by the SDK
# rather than by anything here, which is why it is not a parameter.
$ToolsDir = Join-Path $env:USERPROFILE '.dotnet\tools'

if (-not $DotnetRoot) {
    if ($env:DOTNET_ROOT) { $DotnetRoot = $env:DOTNET_ROOT }
    else { $DotnetRoot = Join-Path $env:USERPROFILE '.dotnet' }
}

$WantPublisher = ($Tool -eq 'Publisher' -or $Tool -eq 'Both')
$WantValidator = ($Tool -eq 'Validator' -or $Tool -eq 'Both')

# ------------------------------------------------------------------------------------------------

function Write-Step { param([string]$Message) Write-Host "==> $Message" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Message) Write-Host "  $Message" -ForegroundColor Green }
function Write-Warn { param([string]$Message) Write-Host "  $Message" -ForegroundColor Yellow }

# ------------------------------------------------------------------------------------------------
# The SDK.

# The tools target net10.0, and a tool can only be installed by an SDK that understands its target
# framework: an older SDK fails with "Settings file 'DotnetToolSettings.xml' was not found in the
# package", which is true only in the sense that it cannot read the folder it is in. So this looks
# for a 10.x SDK rather than for any dotnet at all.
function Find-Sdk10 {
    $candidates = New-Object System.Collections.Generic.List[string]

    $onPath = Get-Command dotnet -CommandType Application -ErrorAction SilentlyContinue |
              Select-Object -First 1
    if ($onPath) { $candidates.Add($onPath.Source) }
    $candidates.Add((Join-Path $DotnetRoot 'dotnet.exe'))
    $candidates.Add((Join-Path $env:ProgramFiles 'dotnet\dotnet.exe'))

    foreach ($candidate in $candidates) {
        if (-not $candidate -or -not (Test-Path -LiteralPath $candidate)) { continue }
        try {
            # A dotnet that is on PATH but broken - a half-removed install, a stub from an
            # uninstalled SDK - throws here rather than answering, and is simply not a candidate.
            $sdks = & $candidate --list-sdks 2>$null
        } catch {
            continue
        }
        if ($LASTEXITCODE -ne 0) { continue }
        if ($sdks | Where-Object { $_ -like '10.*' }) { return $candidate }
    }
    return $null
}

function Install-Dotnet {
    Write-Step "Installing the .NET $DotnetChannel SDK into $DotnetRoot"

    # Windows PowerShell 5.1 still defaults to TLS 1.0 for Invoke-WebRequest, which dot.net has
    # not accepted for years. Set for this process only.
    [Net.ServicePointManager]::SecurityProtocol =
        [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    $script = Join-Path $env:TEMP "dotnet-install-$PID.ps1"
    try {
        # -UseBasicParsing because the parsed form needs Internet Explorer's engine, which is not
        # present on a current Windows and is not wanted for downloading a file in any case.
        Invoke-WebRequest -Uri $InstallerUrl -OutFile $script -UseBasicParsing

        # A proxy or a captive portal returns a login page with a 200, and the failure that causes
        # is a PowerShell parse error from the middle of some HTML. Cheap to rule out.
        $head = Get-Content -LiteralPath $script -TotalCount 40 -ErrorAction Stop
        if (($head -join "`n") -notmatch '(?im)^\s*(<#|#|\[CmdletBinding|param\s*\()') {
            throw "$InstallerUrl did not return a PowerShell script - check whether something is intercepting HTTPS."
        }

        & $script -Channel $DotnetChannel -InstallDir $DotnetRoot -NoPath
        if ($LASTEXITCODE -ne 0) { throw "the .NET installer exited with $LASTEXITCODE." }
    } finally {
        Remove-Item -LiteralPath $script -Force -ErrorAction SilentlyContinue
    }

    Write-Ok "installed $(& (Join-Path $DotnetRoot 'dotnet.exe') --version)"
}

# ------------------------------------------------------------------------------------------------
# The tools.

$script:Dotnet = $null

# `dotnet tool list` prints a table whose first column keeps whatever case the package was
# published with, so the comparison is on a lowercased copy of it.
function Get-InstalledToolVersion {
    param([string]$Package)

    $wanted = $Package.ToLowerInvariant()
    foreach ($line in (& $script:Dotnet tool list --global)) {
        $columns = ($line.Trim() -split '\s+')
        if ($columns.Count -ge 2 -and $columns[0].ToLowerInvariant() -eq $wanted) {
            return $columns[1]
        }
    }
    return $null
}

function Install-SpecificationTool {
    param(
        [string]$Package,
        [string]$Command,
        [string]$Version
    )

    $versionArgs = @()
    if ($Version) { $versionArgs = @('--version', $Version) }

    if (Get-InstalledToolVersion -Package $Package) {
        # update rather than install: install fails outright when the tool is already there, and
        # this script has to be safe to re-run. An already-current tool is left alone and still
        # exits 0, which is what makes the second run a no-op rather than a reinstall.
        Write-Step "Updating $Package"
        & $script:Dotnet tool update --global @versionArgs $Package
    } else {
        Write-Step "Installing $Package"
        & $script:Dotnet tool install --global @versionArgs $Package
    }
    if ($LASTEXITCODE -ne 0) { throw "dotnet tool install/update failed for $Package." }

    # Not merely "did dotnet exit 0". A tool whose framework is missing installs perfectly well and
    # then fails on first use, which is a far worse place to find out.
    $exe = Join-Path $ToolsDir "$Command.exe"
    if (-not (Test-Path -LiteralPath $exe)) { throw "$Package installed but $exe is not there." }
    & $exe --help | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "$Command installed but would not run." }

    Write-Ok "$Command $(Get-InstalledToolVersion -Package $Package) is ready"
}

# ------------------------------------------------------------------------------------------------
# PATH, for this run and for the next shell.

# User scope only. Reading the machine PATH and writing it back into the user's is a classic way to
# turn a helpful installer into a broken login, so the machine variables are never touched.
function Add-ToUserPath {
    param([string]$Directory)

    $current = [Environment]::GetEnvironmentVariable('PATH', 'User')
    if (-not $current) { $current = '' }

    $entries = $current -split ';' | Where-Object { $_ }
    foreach ($entry in $entries) {
        if ($entry.TrimEnd('\') -ieq $Directory.TrimEnd('\')) { return $false }
    }

    $updated = if ($current) { "$Directory;$current" } else { $Directory }
    [Environment]::SetEnvironmentVariable('PATH', $updated, 'User')
    return $true
}

function Save-Environment {
    $changed = @()

    if ([Environment]::GetEnvironmentVariable('DOTNET_ROOT', 'User') -ne $DotnetRoot) {
        [Environment]::SetEnvironmentVariable('DOTNET_ROOT', $DotnetRoot, 'User')
        $changed += 'DOTNET_ROOT'
    }
    if (Add-ToUserPath -Directory $DotnetRoot) { $changed += $DotnetRoot }
    if (Add-ToUserPath -Directory $ToolsDir)   { $changed += $ToolsDir }

    if ($changed.Count -gt 0) {
        Write-Ok "recorded in your user environment: $($changed -join ', ')"
    } else {
        Write-Ok 'your user environment already points at the SDK and the tools'
    }
}

# ------------------------------------------------------------------------------------------------

function Test-WordInstalled {
    try {
        return $null -ne [Type]::GetTypeFromProgID('Word.Application')
    } catch {
        return $false
    }
}

# ------------------------------------------------------------------------------------------------

Write-Step "Looking for a .NET $DotnetChannel SDK"
$found = Find-Sdk10
if ($found) {
    Write-Ok "found $(& $found --version) at $found"
    # An SDK installed by Visual Studio or by the standalone installer lives outside the default
    # DotnetRoot, and pointing DOTNET_ROOT at a directory that does not hold it breaks every later
    # run.
    $DotnetRoot = Split-Path -Parent $found
    $script:Dotnet = $found
} else {
    Install-Dotnet
    $script:Dotnet = Join-Path $DotnetRoot 'dotnet.exe'
}

# For the rest of this script. Save-Environment does the same for every future shell.
$env:DOTNET_ROOT = $DotnetRoot
$env:PATH = "$DotnetRoot;$ToolsDir;$env:PATH"

# First run of the SDK prints a banner and writes a sentinel; getting that out of the way here
# keeps it out of the middle of the install output.
$env:DOTNET_NOLOGO = '1'
if (-not $env:DOTNET_CLI_TELEMETRY_OPTOUT) { $env:DOTNET_CLI_TELEMETRY_OPTOUT = '1' }

if ($WantPublisher) {
    Install-SpecificationTool -Package $PublisherPackage -Command $PublisherCommand -Version $PublisherVersion
}
if ($WantValidator) {
    Install-SpecificationTool -Package $ValidatorPackage -Command $ValidatorCommand -Version $ValidatorVersion
}

Save-Environment

Write-Host ''
Write-Host 'Open a new terminal so the PATH change takes effect, or run this once in this one:'
Write-Host ''
Write-Host "    `$env:PATH = `"$ToolsDir;`$env:PATH`""

if ($WantPublisher) {
    Write-Host ''
    Write-Host 'Then, in a specification repository:'
    Write-Host ''
    Write-Host "    $PublisherCommand upgrade --write"
    Write-Host "    $PublisherCommand build"
    Write-Host "    $PublisherCommand publish"
}

if ($WantValidator) {
    Write-Host ''
    Write-Host 'The validator checks a built document against the NodeSets it describes:'
    Write-Host ''
    Write-Host "    $ValidatorCommand validate <spec.xml> <primary.NodeSet2.xml> --dependency-dir model/dependencies"

    if (-not (Test-WordInstalled)) {
        Write-Host ''
        Write-Warn 'Microsoft Word is not registered on this machine, so the validator can validate'
        Write-Warn 'and update NodeSets but cannot run preprocess, convert or convert-validate -'
        Write-Warn 'those drive Word through COM to read the .docx.'
    }
}
