---
# SPDX-FileCopyrightText: Copyright (C) <YEAR> OPC Federation AISBL
# SPDX-License-Identifier: LicenseRef-OPC-Specification-1.15
# License: https://opcfoundation.org/license/specifications/1.15/
---

<!-- The authored prose. Everything not here is generated from manifest.json, profiles.json
     and the NodeSet - see AUTHORING.md, which `upgrade --write` puts at the repository root.

     Headings carry no numbers. Numbering comes from document order, so inserting a clause
     renumbers everything after it and nothing goes stale. Every heading needs an anchor,
     because that is what cross-references bind to.

     The `{clause}` directives below ask for a generated clause where you want it. Clauses 1,
     2 and 3 are always produced; the rest appear only where they are asked for. -->

## Scope {#sec-scope}

This document specifies [WHAT THIS COMPANION SPECIFICATION COVERS].

<!-- One or two paragraphs. What the information model describes, what kind of system it
     applies to, and what it is for. This is the only clause of the front matter you write. -->

**OPC Foundation**

OPC is the interoperability standard for the secure and reliable exchange of data and information in the industrial automation space and in other industries. It is platform independent and ensures the seamless flow of information among devices from multiple vendors. The OPC Foundation is responsible for the development and maintenance of this standard.

OPC UA is a platform independent service-oriented architecture that integrates all the functionality of the individual OPC Classic specifications into one extensible framework. This multi-layered approach accomplishes the original design specification goals of:

* Platform independence: from an embedded microcontroller to cloud-based infrastructure
* Secure: encryption, authentication, authorisation, and auditing
* Extensible: ability to add new features including transports without affecting existing applications
* Comprehensive information modelling capabilities: for defining any model from simple to complex 

**Other Organization**

[INFORMATION ABOUT OTHER ORGANIZATION CONTRIBUTING TO THE SPECIFICATION]

<!-- 2 Normative references - from normativeReferences in manifest.json -->

<!-- 3 Terms, definitions and abbreviations -->

<!-- 3.1 Overview - filled from identity in manifest.json -->

<!-- 3.2 Terms and definitions - from terms in manifest.json. 
     If no terms, delete the directive below. -->
```{clause}
kind: terms
```

<!-- 3.3 Abbreviations - from abbreviations in manifest.json -->

```{include editor-guidelines}
```

## General information {#sec-general-information}

[Explain the domain to a reader who knows OPC UA but not this industry.]

## Use cases {#sec-use-cases}

### [First use case] {#sec-first-use-case}

[What a user wants to be able to do, and what the model has to carry for them to do it.]

### [Second use case] {#sec-second-use-case}

[What a user wants to be able to do, and what the model has to carry for them to do it.]

## Information Model overview {#sec-information-model-overview}

[An overview of the model elements and how they relate to each other.]

<!-- a figure showing the relationships between the major elements -->
```{figure}
id: fig-information-model-overview
caption: Information Model overview
source: figures/information-model-overview.drawio.svg
```

<!-- Draw it in draw.io and save as .drawio.svg - the picture and its editable source in one
     file, so nothing in the pipeline ever renders a diagram. Drag the shapes out of the OPC UA
     palette, source/figures/uashapes-library.drawio.xml, which you import once; the shapes and
     arrowheads are normative and are not drawn by hand. -->

```{include model}
```

<!-- `objecttypes` is a key in the manifest's `markdown` block, and the manifest names the
     file. Everything in object-types.md - its heading and all - is read in here, at the
     heading levels it was written with, so a part can hold several clauses rather than one.
     It is still one document - anchors declared there are cited from here and back.

     Where the include sits decides the depth: this one is at the top of the document, so the
     part opens at ##. Under a ## heading it would open at ###. -->

```{clause}
kind: profiles
```

```{clause}
kind: namespaces
```

```{clause}
kind: annex-a
```
