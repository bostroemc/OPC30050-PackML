# figures

Not a specification's figures — those live in `source/<spec>/figures/`. This directory holds
the one thing every specification in the repository shares: the OPC UA notation.

`uashapes-library.drawio.xml` is a draw.io **shape library**. It carries the eight NodeClasses
and the eleven reference types as a palette, converted from the OPC Foundation's Visio master.
You import it once and drag shapes out of it.

**The draw.io desktop app or the web editor.** *File ▸ Open Library from ▸ Device*, and choose
this file. It appears at the top of the shapes panel, above Scratchpad, and stays open until
you close it.

**VS Code.** Add it through the shapes panel of the Draw.io Integration extension the same way.
The extension's `hediet.vscode-drawio.customLibraries` setting would load it automatically and
this repository deliberately ships no such setting: it resolves `${workspaceFolder}` to the
first folder VS Code has open, and when that is not this repository the extension reads a file
that is not there, does not guard the read, and comes up with a **blank editor** and no message
saying why. Put it in your own settings if you want it. See `AUTHORING.md` for the snippet.

## Why it is imported rather than copied from

The shapes are compiled stencils. Where the notation used to be draw.io keywords a person could
read off a diagram and type — `shape=hexagon`, `ellipse`, `rounded=1` — a shape's geometry is
now a blob inside its style. Nothing is transcribable, so the palette is the only way to get a
correct shape and there is no near-miss: a box either is the notation's box or it is one you
drew that looks like it. The validator compares figures against this same file, which is why an
author who drags from the palette cannot fail the shape rule.

## It belongs to the tool

`Opc.Ua.SpecificationPublisher upgrade` writes this file, exactly as it writes `AUTHORING.md`
and the workflow. A correction to the notation then arrives with a tool release instead of
being a file somebody has to re-import in every repository.

Edit it and it becomes yours: `upgrade` stops refreshing it and the validator reports once
(`OPC019`) that this repository draws with a notation that is not the published one. Delete it
and run `upgrade --write` to take the tool's copy back.
