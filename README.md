# Overview

This is a temporary repository to hold the markdown source for the JWG revising the OPC UA PackML companion specification: OPC 30050.

Group members may contribute to the paper by submitting pull requests.  Known open points are listed in the Issues section.  If you are working on a particular issue, please indicate it in the comments so that we are not duplicating our efforts. 

This repo is based on the official companion specification template supplied by OPC Foundation and, when properly implemented, will produced documentation meeting the OPC Foundation's rigorous standards.

## Recommended tooling

- Visual Studio Code: https://code.visualstudio.com/

- See below for the official build tools supplied by OPC Foundation.


## Pull requests

See guide here: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request

Please try to keep changes relatively small or well-grouped (e.g. corrected spellings in section 6.2.)


## Sample output

The current Word document associated with the repo may be found in ./artifacts/OPC-30050.docx.  The document is automatically updated after each successful change (push) to the repository's main branch.


## Markdown

For a primer on basic Markdown syntax, see: https://www.markdownguide.org/basic-syntax/

See AUTHORING.md for information on additional conventions required by the tooling.

## Options

If you prefer to work in Word, please send an edited Word document to me directly and I can manually incorporate your work into the repository.  Like standard pull requests, please feed me changes in reasonably small chunks.



# OPC UA Companion Specification — working-group template

The starting point for a working-group repository whose **source of truth is markdown plus a
UANodeSet**, not a Word document. Use this template to create your repository, then run one
command to bring in everything the tool maintains.

```
 markdown + NodeSet ──► STS XML ──► online reference · search · RAG export · Word rendering
                    └─► source map ─► every clause in the rendering links back to the line it was written on
```

Everything downstream is built from the STS XML, so nothing downstream knows or cares how the
document was authored. The Word path is not deprecated — it is the other supported workflow,
selected per specification by `sourceOfTruth` in its `manifest.json` — but it is not what this
template sets up.

## Start here

**1. Fork this repository**

**2. Install the tools.** Two are published: the **publisher**, which is what this repository is
built with, and the **validator**, which converts a Word specification into this format and checks
a built document against its NodeSets. On macOS, or on a Windows machine that already has the
.NET 10 SDK:

```bash
dotnet tool install --global OPCFoundation.Opc.Ua.SpecificationPublisher
dotnet tool install --global OPCFoundation.Opc.Ua.SpecificationValidator
```

On a machine with nothing on it yet, [`install-tools.ps1`](install-tools.ps1) on Windows and
[`install-tools.sh`](install-tools.sh) on Linux install the .NET SDK, the native libraries the tools
need and then both tools. Neither needs an administrator or a root prompt, the Linux one adds no
third-party package repository, and both are safe to run twice — an installed tool is updated
rather than reinstalled, so the same command is also how you upgrade. `-Tool` and `--tool` narrow
a run to one of the two.

The validator's Word-driven verbs drive Microsoft Word through COM and so need Windows with Word
installed; its `validate` and `update-nodeset` verbs read XML and run anywhere.

**3. Bring in everything the tool maintains.**

```bash
Opc.Ua.SpecificationPublisher upgrade            # what it would write
Opc.Ua.SpecificationPublisher upgrade --write    # write it, then read the diff
```

That writes the GitHub Actions workflow, the ignore and attribute files, the markdownlint
configuration and the pull-request template, refreshes `AUTHORING.md` and `skills/` to this
version's copies, and writes `.config/dotnet-tools.json` pinning the version that wrote them.
Commit the result.

**Everything it writes is owned by the tool, not by this template.** Those files ship inside the
tool, so an improvement to the workflow or the authoring contract reaches every repository on its
next `upgrade` — not just the ones created after it. That is the one thing a GitHub template
cannot do on its own: a repository generated from a template is a copy with no link back.

`AUTHORING.md` and `skills/` are the exception that proves it. They are **also** in this template,
because an agent opened in a fresh clone needs them before step 3 can possibly have run — but
they are still the tool's, and the first `upgrade` replaces them with the running version's
copies. Do not treat the copies here as authoritative; treat them as enough to get started.

**4. Fill in your specification.** Rename `source/ExampleSpec/` and replace every `<PLACEHOLDER>`
in it. Then:

```bash
Opc.Ua.SpecificationPublisher build       # markdown + NodeSet -> STS XML
Opc.Ua.SpecificationPublisher publish     # STS -> the browsable rendering and the .docx
```

Both write under `_work/` by default, which is gitignored, so rebuilding locally does not dirty
what is committed. The workflow names `artifacts/` and `docs/` explicitly.

**5. Turn on GitHub Pages**, from `main` and the `/docs` folder. The workflow rebuilds and
commits `artifacts/` and `docs/` on every push to `main`, so what is published is never behind
what is in the repository.

## What is in this template

Only what a working group **authors**. Everything else arrives from `upgrade`.

| Path | What it is |
|---|---|
| `source/<spec>/manifest.json` | that specification's identity, and the content of the clauses that are generated rather than authored |
| `source/<spec>/spec.md` | the authored prose |
| `source/<spec>/object-types.md` | a clause broken out into its own file, named by the manifest and asked for by `source=` on its heading |
| `source/<spec>/profiles.json` | the Conformance Units and Profiles this document defines |
| `source/<spec>/figures/` | its figures, as `.drawio.svg` in the normative OPC UA notation |
| `legal.md` | names the co-publisher, if any — **tool-owned**, refreshed by `upgrade`; see [Before you publish](#before-you-publish) |
| `source/agreement-of-use.md` | shared front matter — the same in front of every part. Not authored: `upgrade --write` downloads it from the OPC Foundation, keyed by `legal.md` |
| `source/reference/` | OPC 20018, OPC 20019 and OPC 20020 — the documents that define the boilerplate, migrated from their Word masters. Not companion specifications; see [its README](source/reference/README.md) |
| `source/figures/uashapes-library.drawio.xml` | the OPC UA notation as a draw.io shape palette, imported once and dragged from by every specification here — **tool-owned**, refreshed by `upgrade` |
| `source/logo-left.jpg` | the OPC Foundation logo, on the left of the cover. Not authored, same as the Agreement of Use above |
| `model/` | every part's UANodeSet, and `dependencies/` for the upstream ones |
| `tools/office-to-svg.ps1` | renders Visio and PowerPoint drawings to the SVG the document embeds, for a group whose figures live in Office |
| `install-tools.sh`, `install-tools.ps1` | Linux and Windows bootstrap for the publisher and the validator, here rather than shipped by the tool because they are what install the tool |
| `AUTHORING.md` | the authoring contract — **tool-owned**, here so it is readable before the first `upgrade` |
| `skills/` | agent instructions: authoring in this repository, and migrating a Word specification into it — **tool-owned**, here for the same reason |

A repository publishes **as many specifications as its working group publishes together**. One is
a directory under `source/` with a `manifest.json` in it; a directory with no files in it only
groups others. Nothing lists them — adding a specification is adding a directory, and every verb
runs over all of them unless `--spec` narrows it.

Three anchors are worth stating plainly, because they are what make a second specification
nothing more than a second directory:

- a **specification's** own paths (`markdown.main`, `figures`, `profiles`) are relative to its
  manifest, so it can be moved or copied without editing it;
- the **model** is the repository's, because a part borrows types from the siblings it is
  published with, and NodeSets resolve by `ModelUri` rather than by which directory they sit in;
- the **artifacts** are the repository's and flat, because everything downstream consumes an STS
  by document number, not by where its source happened to live.

## Before you publish

`source/agreement-of-use.md` and the cover logos are not authored here and are not yours to edit —
`upgrade --write` downloads them from the OPC Foundation's shared repository of partner agreements
and overwrites whatever is on disk, every time it runs. Editing them by hand accomplishes nothing
beyond the next `upgrade --write`.

What is yours to set is `legal.md`, at the repository root. Publishing under the OPC Foundation
alone needs nothing — leave its "Partner organization:" line blank, or delete the file, and the
Foundation's own text and logo are what gets fetched. Publishing jointly with another
organization — VDMA, VDW, and so on — needs that organization's name on that line, matching a
folder in the Foundation's shared repository; the joint text and both logos are fetched instead.
Run `upgrade --write` again after changing it.

A failed fetch — no network, or a name `legal.md` gives that has no folder upstream — is reported
and does not stop the rest of `upgrade`; it is simply retried on the next `upgrade --write`.

## What is authored, and what is generated

Most of the published document is not in its `spec.md`. Normative references, clause 3 and its
Conventions subclause, Profiles and Conformance Units, Namespaces, Annex A, and the entire
NodeIds.csv are generated — from that specification's `manifest.json`, from `profiles.json` and
from the model. A clause a working group cannot edit is a clause it cannot get wrong.

Clauses 1, 2 and 3 are always there: you write Scope, and the tool writes 2 and 3 whether or not
you ask. Everything else generated is optional and appears where you ask for it:

````markdown
```{clause}
kind: profiles
```
````

`AUTHORING.md` — written by `upgrade` — is the authoring contract and describes the dialect in
full.

## Getting from the rendering back to the source

Every clause, table and figure in the published page carries a 📝 beside its heading. It opens
what was written to produce it — and where it goes is worked out **when you open the page, not
when it was built**, so one file serves both places:

| Reading the page | The 📝 opens |
|---|---|
| from your checkout (`file://`) | the markdown file in your editor, at the line |
| on the published site (`https://`) | the source on GitHub, at the line, pinned to the commit that build read |
| anywhere else, or with no scripting | the markdown file itself, as a plain relative link |

The third row is the `href` actually written into the HTML; the first two are upgrades the page
applies to itself as it loads. Nothing is baked in, so no one's directory layout ends up in a
published file — and cloning the repository and opening `docs/index.html` gives you links into
*your* copy.

VS Code needs nothing installed: the browser hands `vscode://file/…` to the OS, which is the
same mechanism as `mailto:`. `--editor` selects `vscode-insiders`, `vscodium` or `cursor`
instead. Visual Studio has no URL scheme of its own and is not among them. `--no-source-links`
turns the whole thing off.

**A generated clause has one too**, pointing at whatever decides what it says: clause 2 at
`normativeReferences` in the manifest, the Conformance Units clause at `conformanceUnits` in
`profiles.json`, a Facet's subclause at that Facet's own entry. The tooltip names the file. Every
heading carries a 📝, because a clause without one is indistinguishable from a feature that has
stopped working.

### The mapping file

The links come from a map `build` writes beside the STS — `artifacts/<doc>.stsmap.json`, the way
a `.pdb` sits beside an assembly. It exists because `build` reads the markdown and `publish`
reads only the XML, deliberately, and the line numbers have to cross between them. **Nothing was
added to the STS itself**: the interchange format describes the specification, not the repository
its source happens to live in.

```json
{
  "schema": 1,
  "tool": "Opc.Ua.SpecificationPublisher/1.0.43",
  "sts":  { "path": "artifacts/OPC-40702.xml", "sha256": "c758ce6d…" },
  "repo": { "origin": "https://github.com/…", "ref": "5da8f84…", "dirty": false },
  "map":  {
    "sec_5-2-1": { "file": "source/OCT-MSS/object-types.md", "line": 412, "endLine": 468 },
    "tbl_14":    { "file": "source/OCT-MSS/object-types.md", "line": 431, "endLine": 447 },
    "sec_2":     { "file": "source/OCT-MSS/manifest.json", "line": 88, "generated": true }
  }
}
```

**It is a general-purpose artifact and other tools are welcome to it.** The keys are the ids the
elements carry in the STS *and* in the HTML — `sec_5-2-1`, `tbl_14`, `fig_7` — so anything
holding one can find where it was written without parsing markdown or guessing. A review bot
annotating the right line, a RAG export citing a range rather than a document, an editor
extension jumping from a clause number to its source: all of it needs the same join, and this is
it.

Three things to know before consuming it:

- **Check `sts.sha256` before you trust it.** That is the whole reason the stamp is there. A map
  applied to an STS it was not built from gives every line number a plausible, wrong answer, and
  nothing about the result looks broken.
- **Keys are the *numbered* ids, not the anchors you wrote.** Numbering replaces `{#sec-scope}`
  with `sec_1` and keeps the anchor only as a cross-reference alias.
- **`generated: true` means the file is what produces the clause, not where its text is** — a
  manifest property or a `{clause}` directive. `endLine` is absent when an element begins in one
  file and ends in another, because a range across two files names lines that do not exist.

It is **not committed** — `.gitignore` excludes it, because it churns on every line anyone
inserts and the published HTML already carries what a reader needs. It is written on every
`build`, so any tool running in the working tree after one will find it. If something downstream
genuinely needs it in the repository, deleting the `*.stsmap.json` line from `.gitignore` is the
whole change.

## Keeping in step

Every repository pins the tool, and **every verb that reads the repository refuses to run unless
the pin matches the tool you are running**. So after updating the tool, `upgrade` comes first:

```bash
dotnet tool update OPCFoundation.Opc.Ua.SpecificationPublisher
Opc.Ua.SpecificationPublisher upgrade --write
```

That refusal is deliberate. It means no reader in the tool has to cope with a layout an earlier
version produced, so a repository is always the shape the build expects. CI is unaffected —
`dotnet tool restore` installs the pinned version, so the pin matches by construction.

A tool-owned file you edit becomes **yours**: it is left alone from then on, said so once, and
never refreshed again. Delete it and run `upgrade --write` to take the tool's copy back.

## Working on it

```bash
dotnet tool restore                                            # exactly the pinned version

dotnet Opc.Ua.SpecificationPublisher build                     # markdown + NodeSet -> STS XML + source map
dotnet Opc.Ua.SpecificationPublisher publish                   # STS -> browsable HTML + .docx
dotnet Opc.Ua.SpecificationPublisher update --write            # bring the markdown in line with the model
dotnet Opc.Ua.SpecificationPublisher build --spec <ShortName>  # just the one you are editing

dotnet Opc.Ua.SpecificationPublisher publish --editor cursor   # a different editor for the 📝 links
dotnet Opc.Ua.SpecificationPublisher publish --no-source-links # no 📝 links at all
```

CI runs those exact commands, not equivalents. Nothing here needs Node, Python, a browser or
Microsoft Office, and it runs on Windows, macOS and Linux alike.

> **There is no rule checking yet.** The `validate` verb is not written, so the authoring rules
> in `AUTHORING.md` are enforced by review rather than by CI. `build` still fails on anything it
> cannot carry into the STS, which catches most of what goes wrong; the rest is a reviewer's job
> for now.
