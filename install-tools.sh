#!/usr/bin/env bash
#
# Installs the OPC UA specification tools on a Linux machine that has nothing on it yet: the
# .NET SDK, the native libraries they need, and then the tools themselves from nuget.org.
#
#     ./install-tools.sh
#
# Two tools are published, and by default both are installed:
#
#   Opc.Ua.SpecificationPublisher   markdown + UANodeSet -> NISO STS XML, and the browsable
#                                   HTML edition. Cross-platform; needs no Office.
#   Opc.Ua.SpecificationValidator   Word .docx -> NISO STS XML, validation of an STS document's
#                                   tables against its NodeSets, and NodeSet documentation
#                                   update. Its Word-driven verbs need Windows; validate and
#                                   update-nodeset read XML and run anywhere.
#
# Written for Linux Mint first, which is Ubuntu underneath, so anything apt-based should work.
# The one distro-specific part is install_packages(); adding dnf or pacman is a case there and
# nothing else. On Windows use install-tools.ps1 instead.
#
# Safe to run twice. Everything it does is checked first, and an installed tool is updated
# rather than reinstalled, so a second run on a machine that is already set up reports what it
# found and changes nothing else.
#
# What it trusts, since installing a toolchain is exactly where that matters:
#
#   * https://dot.net/v1/dotnet-install.sh   Microsoft's own installer script, over TLS
#   * https://api.nuget.org                  the packages, from the public feed
#   * your distribution's apt repositories   for the native libraries
#
# No third-party PPA is added and no repository key is installed. Deliberately: the usual
# advice for .NET on Ubuntu is to add packages.microsoft.com, and on Mint that means telling
# apt that Mint is really Ubuntu 24.04 - a claim that is true until the day it is not, at
# which point apt is holding a key for a distribution you are not running. Microsoft's script
# installs under your home directory, needs no root, and is removed by deleting a folder.

set -euo pipefail

readonly PUBLISHER_PACKAGE="OPCFoundation.Opc.Ua.SpecificationPublisher"
readonly PUBLISHER_COMMAND="Opc.Ua.SpecificationPublisher"
readonly VALIDATOR_PACKAGE="OPCFoundation.Opc.Ua.SpecificationValidator"
readonly VALIDATOR_COMMAND="Opc.Ua.SpecificationValidator"

readonly DOTNET_CHANNEL="10.0"
readonly INSTALLER_URL="https://dot.net/v1/dotnet-install.sh"

DOTNET_ROOT="${DOTNET_ROOT:-$HOME/.dotnet}"
WANT_PUBLISHER=1
WANT_VALIDATOR=1
PUBLISHER_VERSION=""
VALIDATOR_VERSION=""
ASSUME_YES=0

# ---------------------------------------------------------------------------------------------

readonly BOLD=$'\033[1m' RED=$'\033[31m' GREEN=$'\033[32m' YELLOW=$'\033[33m' RESET=$'\033[0m'

log()  { printf '%s==>%s %s\n' "$BOLD" "$RESET" "$*"; }
ok()   { printf '  %s%s%s\n' "$GREEN" "$*" "$RESET"; }
warn() { printf '  %s%s%s\n' "$YELLOW" "$*" "$RESET" >&2; }
die()  { printf '%serror:%s %s\n' "$RED" "$RESET" "$*" >&2; exit 1; }

usage() {
    cat <<EOF
Installs the OPC UA specification tools and everything they need.

  ./install-tools.sh [options]

  --tool <which>            publisher, validator, or both. Default both.
  --publisher-version <v>   install this version instead of the newest stable. A preview has
                            to be named in full, because NuGet excludes prereleases otherwise:
                            --publisher-version 1.0.36-preview-gdf34f48627
  --validator-version <v>   the same, for the validator.
  --dotnet-root <dir>       where to put the SDK if one has to be installed. Default ~/.dotnet,
                            or \$DOTNET_ROOT if you have already set it.
  --yes                     do not ask before installing apt packages.
  --help                    this.
EOF
}

select_tools() {
    case "$1" in
        publisher) WANT_PUBLISHER=1; WANT_VALIDATOR=0 ;;
        validator) WANT_PUBLISHER=0; WANT_VALIDATOR=1 ;;
        both|all)  WANT_PUBLISHER=1; WANT_VALIDATOR=1 ;;
        *)         die "--tool takes publisher, validator or both, not '$1'" ;;
    esac
}

while [ $# -gt 0 ]; do
    case "$1" in
        --tool)              select_tools "${2:-}"; shift 2 ;;
        --publisher-version) PUBLISHER_VERSION="${2:-}"; [ -n "$PUBLISHER_VERSION" ] || die "--publisher-version needs a value"; shift 2 ;;
        --validator-version) VALIDATOR_VERSION="${2:-}"; [ -n "$VALIDATOR_VERSION" ] || die "--validator-version needs a value"; shift 2 ;;
        # The name this option had when the script installed the publisher and nothing else.
        --tool-version)      PUBLISHER_VERSION="${2:-}"; [ -n "$PUBLISHER_VERSION" ] || die "--tool-version needs a value"; shift 2 ;;
        --dotnet-root)       DOTNET_ROOT="${2:-}"; [ -n "$DOTNET_ROOT" ] || die "--dotnet-root needs a value"; shift 2 ;;
        --yes|-y)            ASSUME_YES=1; shift ;;
        --help|-h)           usage; exit 0 ;;
        *)                   usage >&2; die "unknown option '$1'" ;;
    esac
done

# Running this under sudo would install the SDK into root's home and the tools into root's PATH,
# so it would appear to work and then be missing the moment you were yourself again. Nothing
# here needs root except apt, which is asked for on its own when the time comes.
if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
    die "do not run this with sudo - it would install into /root. Run it as yourself; it will ask for sudo only to install system packages."
fi

# How to become root for apt, if at all. Already root - a container, or a CI image - means no
# sudo is needed and often none is installed, so calling it unconditionally would fail on the
# one kind of machine where it was never required.
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    SUDO=""    # checked again only if packages actually turn out to be missing
fi

# ---------------------------------------------------------------------------------------------
# Native libraries.

# What is actually required is a set of shared libraries, and the packages that carry them are
# renamed from time to time - Ubuntu 24.04 renamed libssl3 to libssl3t64 for the 64-bit time_t
# transition, so asking dpkg whether "libssl3" is installed answers no on a machine where
# libssl.so.3 is present and working. Asking the dynamic linker instead is both the real
# question and one that survives a rename, and the package name is then needed only when the
# library is genuinely absent.
#
# soname:package - the package is the apt name to install if the soname is missing.
readonly REQUIRED_LIBRARIES=(
    "libssl.so.3:libssl3"
    "libstdc++.so.6:libstdc++6"
    "libz.so.1:zlib1g"
    "libfontconfig.so.1:libfontconfig1"
)

have_soname() {
    ldconfig -p 2>/dev/null | grep -qF "$1"
}

# Which packages are named here depends on the distribution, so this is the one function to
# change when adding one. Everything after it is distro-neutral.
install_packages() {
    local missing=("$@")

    if [ ${#missing[@]} -eq 0 ]; then
        ok "everything .NET and the tools need is already here"
        return 0
    fi

    command -v apt-get >/dev/null 2>&1 || {
        warn "not an apt-based system - install these yourself and re-run: ${missing[*]}"
        return 0
    }

    log "Installing system packages: ${missing[*]}"

    if [ "$(id -u)" -ne 0 ] && [ -z "$SUDO" ]; then
        die "these need to be installed and sudo is not available: apt-get install ${missing[*]}"
    fi

    if [ "$ASSUME_YES" -eq 0 ] && [ -t 0 ]; then
        read -r -p "  install these with apt? [Y/n] " reply
        case "$reply" in [nN]*) die "declined - the tools will not run without them" ;; esac
    fi

    $SUDO apt-get update -qq

    # Only now, because resolving the name reads the package lists and on a machine that has
    # never run apt-get update they are empty - which does not fail, it just finds nothing, and
    # the install then succeeds without the one library .NET cannot start without.
    local resolved=()
    for pkg in "${missing[@]}"; do
        if [ "$pkg" = "$ICU_PLACEHOLDER" ]; then
            local name
            name="$(libicu_candidate)"
            [ -n "$name" ] || die "no libicu package found in the apt sources - .NET cannot start without one"
            resolved+=("$name")
        else
            resolved+=("$pkg")
        fi
    done

    # `env` rather than a VAR=value prefix: sudo scrubs the environment it is given, so the
    # prefix form would be dropped and apt would stop on the first configuration prompt.
    $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y "${resolved[@]}"
    ok "installed ${resolved[*]}"
}

# libicu carries its version in the package name - libicu70 on Mint 21, libicu74 on Mint 22 -
# so it is asked for by this stand-in and resolved against the apt sources once they are known
# to be current. Hardcoding a number would make this script wrong on the next Mint release.
readonly ICU_PLACEHOLDER="libicu(any version)"

libicu_candidate() {
    apt-cache search --names-only '^libicu[0-9]+$' 2>/dev/null |
        awk '{print $1}' | sort -V | tail -n 1
}

native_prerequisites() {
    log "Checking native libraries"

    local missing=()

    # curl to fetch anything at all, and the certificate bundle it verifies against.
    command -v curl >/dev/null 2>&1 || missing+=(curl)
    [ -e /etc/ssl/certs/ca-certificates.crt ] || missing+=(ca-certificates)

    local entry
    for entry in "${REQUIRED_LIBRARIES[@]}"; do
        have_soname "${entry%%:*}" || missing+=("${entry#*:}")
    done

    # .NET will not start at all without ICU unless it is told to run without globalization,
    # which is not a trade worth making silently in a tool that formats dates and sorts text.
    have_soname "libicuuc.so" || missing+=("$ICU_PLACEHOLDER")

    install_packages "${missing[@]}"
}

# ---------------------------------------------------------------------------------------------
# The SDK.

# The tools target net10.0, and a tool can only be installed by an SDK that understands its
# target framework: an older SDK fails with "Settings file 'DotnetToolSettings.xml' was not
# found in the package", which is true only in the sense that it cannot read the folder it is
# in. So this looks for a 10.x SDK rather than for any dotnet at all.
find_sdk_10() {
    local candidate
    for candidate in "$(command -v dotnet || true)" "$DOTNET_ROOT/dotnet" /usr/share/dotnet/dotnet; do
        [ -n "$candidate" ] && [ -x "$candidate" ] || continue
        if "$candidate" --list-sdks 2>/dev/null | grep -q '^10\.'; then
            printf '%s' "$candidate"
            return 0
        fi
    done
    return 1
}

install_dotnet() {
    log "Installing the .NET $DOTNET_CHANNEL SDK into $DOTNET_ROOT"

    local script
    script="$(mktemp)"
    # shellcheck disable=SC2064
    trap "rm -f '$script'" RETURN

    curl -fsSL --proto '=https' --tlsv1.2 "$INSTALLER_URL" -o "$script" \
        || die "could not download $INSTALLER_URL"

    # A proxy or a captive portal returns a login page with a 200, and the failure that causes
    # is a shell error from the middle of some HTML. Cheap to rule out.
    head -n 1 "$script" | grep -q '^#!' \
        || die "$INSTALLER_URL did not return a shell script - check whether something is intercepting HTTPS"

    bash "$script" --channel "$DOTNET_CHANNEL" --install-dir "$DOTNET_ROOT" --no-path
    ok "installed $("$DOTNET_ROOT/dotnet" --version)"
}

# ---------------------------------------------------------------------------------------------
# The tools.

DOTNET=""

# `dotnet tool list` prints a table whose first column keeps whatever case the package was
# published with, so the comparison is on a lowercased copy of it.
tool_installed() {
    local wanted
    wanted="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
    "$DOTNET" tool list --global | awk '{print tolower($1)}' | grep -qx "$wanted"
}

# The version column of that same table, for reporting what a run ended up with.
installed_version() {
    local wanted
    wanted="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
    "$DOTNET" tool list --global | awk -v id="$wanted" 'tolower($1) == id { print $2; exit }'
}

install_tool() {
    local package="$1" command="$2" version="$3"

    local -a version_args=()
    [ -n "$version" ] && version_args=(--version "$version")

    if tool_installed "$package"; then
        # update rather than install: install fails outright when the tool is already there,
        # and this script has to be safe to re-run. An already-current tool is left alone and
        # still exits 0, which is what makes the second run a no-op rather than a reinstall.
        log "Updating $package"
        "$DOTNET" tool update --global "${version_args[@]}" "$package"
    else
        log "Installing $package"
        "$DOTNET" tool install --global "${version_args[@]}" "$package"
    fi

    # Not merely "did dotnet exit 0". A tool whose framework is missing installs perfectly well
    # and then fails on first use, which is a far worse place to find out.
    "$HOME/.dotnet/tools/$command" --help >/dev/null \
        || die "$command installed but would not run"
    ok "$command $(installed_version "$package") is ready"
}

# ---------------------------------------------------------------------------------------------
# PATH, for this run and for the next login.

# Written to .profile rather than .bashrc because DOTNET_ROOT should be set for anything you
# start, not only for interactive bash - a desktop launcher and an editor's terminal both read
# the login environment and neither sources .bashrc. Guarded by markers so a second run
# replaces the block instead of appending another copy.
persist_environment() {
    local profile="$HOME/.profile"
    local begin='# >>> OPC UA specification tool >>>'
    local end='# <<< OPC UA specification tool <<<'

    [ -f "$profile" ] || touch "$profile"

    if grep -qF "$begin" "$profile"; then
        # sed over a temp file rather than -i: -i is a GNU extension and this is the one place
        # a mistake would corrupt a file the user did not ask us to touch.
        local trimmed
        trimmed="$(mktemp)"
        sed "/^${begin}$/,/^${end}$/d" "$profile" > "$trimmed"
        cat "$trimmed" > "$profile"
        rm -f "$trimmed"
    fi

    cat >> "$profile" <<EOF
$begin
export DOTNET_ROOT="$DOTNET_ROOT"
export PATH="\$DOTNET_ROOT:\$HOME/.dotnet/tools:\$PATH"
$end
EOF
    ok "recorded DOTNET_ROOT and PATH in $profile"
}

# ---------------------------------------------------------------------------------------------

main() {
    native_prerequisites

    log "Looking for a .NET $DOTNET_CHANNEL SDK"
    if DOTNET="$(find_sdk_10)"; then
        ok "found $("$DOTNET" --version) at $DOTNET"
        # An SDK that came from the distribution lives outside DOTNET_ROOT, and pointing
        # DOTNET_ROOT at a directory that does not hold it breaks every later run.
        DOTNET_ROOT="$(cd "$(dirname "$DOTNET")" && pwd)"
    else
        install_dotnet
        DOTNET="$DOTNET_ROOT/dotnet"
    fi

    # For the rest of this script. persist_environment does the same for every future shell.
    export DOTNET_ROOT
    export PATH="$DOTNET_ROOT:$HOME/.dotnet/tools:$PATH"

    # First run of the SDK prints a banner and writes a sentinel; getting that out of the way
    # here keeps it out of the middle of the install output.
    export DOTNET_NOLOGO=1
    export DOTNET_CLI_TELEMETRY_OPTOUT="${DOTNET_CLI_TELEMETRY_OPTOUT:-1}"

    if [ "$WANT_PUBLISHER" -eq 1 ]; then
        install_tool "$PUBLISHER_PACKAGE" "$PUBLISHER_COMMAND" "$PUBLISHER_VERSION"
    fi
    if [ "$WANT_VALIDATOR" -eq 1 ]; then
        install_tool "$VALIDATOR_PACKAGE" "$VALIDATOR_COMMAND" "$VALIDATOR_VERSION"
    fi

    persist_environment

    cat <<EOF

Open a new terminal, or run this once in this one:

    . ~/.profile
EOF

    if [ "$WANT_PUBLISHER" -eq 1 ]; then
        cat <<EOF

Then, in a specification repository:

    $PUBLISHER_COMMAND upgrade --write
    $PUBLISHER_COMMAND build
    $PUBLISHER_COMMAND publish
EOF
    fi

    if [ "$WANT_VALIDATOR" -eq 1 ]; then
        cat <<EOF

The validator checks a built document against the NodeSets it describes:

    $VALIDATOR_COMMAND validate <spec.xml> <primary.NodeSet2.xml> --dependency-dir model/dependencies

Its Word-driven verbs - preprocess, convert and convert-validate - drive Microsoft Word
through COM and run only on Windows. On this machine, use validate and update-nodeset.
EOF
    fi

    cat <<EOF

The command names are capitalised exactly as above - Linux file names are case sensitive, so
'opc.ua.specificationpublisher' will not find it.
EOF
}

main "$@"
