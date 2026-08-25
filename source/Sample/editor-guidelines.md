---
# SPDX-FileCopyrightText: Copyright (C) <YEAR> OPC Federation AISBL
# SPDX-License-Identifier: LicenseRef-OPC-Specification-1.15
# License: https://opcfoundation.org/license/specifications/1.15/
---

## Editing Guidelines {#sec-editingguidelines}

<!-- This section provides overall guidelines for editors. Please delete before publication. -->

### Overview {#sec-editingguidelines-overview}

Working groups have to choose between using Word as their primary tool or GitHub. The decision is made by the working group for each specification that they are responsible for. Some working groups may continue to use Word as their primary tool for older specifications but adopt GitHub as the basis for new work.

The Word approach is more suitable for Working Groups with less technical SMEs (Subject Matter Experts) as members because it is single tool integrated into Teams which is the primary collaboration platform.

The GitHub approach is more suited to Working Groups with programmers who are already familar with Git and GitHub and are confortable use command line tools as part of the editing process. The GitHub approach also makes it easier to leverage LLMs during the specification development process.

### Word Documents {#sec-editingguidelines-word}

All Working Groups are required to provide a Word document version of their specification that complies with the IEC requirements. The tools provided by the OPC Foundation will generate this document automatically from a GitHub repo that follows the OPC Foundation document template. 

The auto-generated Word documents can also be distributed to reviewers, however, editors will have manually integrate feedback into the GitHub source files (possibily with LLM assistance).

### Figures {#sec-editingguidelines-figure}

All figures must be developed with a tool that allows the IEC to edit the diagrams. Providing static images exported from bespoke tools is not acceptable.

Figures may be created as Visio or Powerpoint files. When using a Word document as the master, these files are embedded in the Word document as OLE objects. When using GitHub as the master, the OPC Foundation provides a tool that converts the Visio or Powerpoint files to SVG files.

When using GitHub as the master, the recommended format is drawio because there are many good open source editors for this format. Files with the extension 'drawio.svg' can edited using drawio tools but are saved as SVG. Editors that produce formats other than drawio should not be used even if they support SVG export.

In rare cases, figures will be pictures of real equipment or copies of figures from other sources that cannot be edited. These figures can be image files (PNG, JPG).

### Headings {#sec-editingguidelines-headings}

This guideline is applied for all OPC UA parts following the IEC guidelines:

* The first letter is capitalized.
* For headers that consist of multiple words, all other words are all lower case with the exception of proper nouns, like terms or type names.

This applies to section, table, and figure headers.

### References {#sec-editingguidelines-references}

Forward HasSubtype References are not added to Type definitions.
