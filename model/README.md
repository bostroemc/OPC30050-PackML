# model

Every specification's UANodeSet, and `dependencies/` for the upstream ones they borrow from.

The model is the **repository's**, not any one specification's. A part borrows types from the
siblings it is published with, and NodeSets resolve by `ModelUri` rather than by which directory
they sit in — so which folder a NodeSet is in decides only the order it is found, never what it
means.

Put your own NodeSet here:

```
model/Opc.Ua.<Subject>.NodeSet2.xml
```

and name it from that specification's `manifest.json`, relative to the repository:

```json
  "model": {
    "nodeset": "model/Opc.Ua.<Subject>.NodeSet2.xml",
    "generated": false
  }
```

Its `ModelUri` must match `identity.namespaceUri` in the same manifest.

## Dependencies

`dependencies/` holds the upstream NodeSets this model requires — DI, Machinery, and whatever
else it builds on. They are **committed**, not fetched at build time, so CI has exactly what the
author had and a build never reaches the network.

Fetch them once and commit what lands:

```
dotnet Opc.Ua.SpecificationPublisher fetch-dependencies
```

A missing dependency is an error rather than something a build quietly resolves differently on
another machine. A specification that defines no model omits the `model` block from its manifest
entirely; `build` then reports `model: none`.
