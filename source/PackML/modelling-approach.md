---
# SPDX-FileCopyrightText: Copyright (C) <YEAR> OPC Federation AISBL
# SPDX-License-Identifier: LicenseRef-OPC-Specification-1.15
# License: https://opcfoundation.org/license/specifications/1.15/
---

## Modelling Approach of PackML {#sec-modelling-approach-of-packml}

The modelling approach for generating an UA model from the PackML specification follows the following general concepts / suggestions.

In PackML a number of standard tag names and standard values are defined, OPC UA defines standard types from which any number of instances can be created. Each instance will contain the same items as defined in the type, allowing easy access for *Clients*.

When possible OPC UA constructs will be used to represent parallel PackML concepts including:
    
    - *StateMachines* to reflect the state of the system
    - *Methods* to issue commands to the *Server*
    - *DataTypes*


### OPC UA Notation {#sec-opc-ua-notation}

This standard uses the *ModellingRules* *OptionalPlaceholder* and *MandatoryPlaceholder* to define instance declarations, and defines a rule that the BrowseName of instance declarations having an *OptionalPlaceholder* or *MandatoryPlaceholder* *ModellingRule* be enclosed in angle brackets (<>). Originally, this rule is defined in OPC 10000-3 as a recommendation. This naming rule is also used in the description of a table. The *BrowseName* of a *Node* that has *OptionalPlaceholder* or *MandatoryPlaceholder* *ModellingRule* are described with angle brackets, which denotes that the name is not fixed. For example, *BrowseName* of *Property* is described as <PropertyName> in graphical notation and tables results in a *Property* that can have any name.

