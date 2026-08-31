---
# SPDX-FileCopyrightText: Copyright (C) <YEAR> OPC Federation AISBL
# SPDX-License-Identifier: LicenseRef-OPC-Specification-1.15
# License: https://opcfoundation.org/license/specifications/1.15/
---

## OPC UA ObjectTypes {#sec-opc-ua-objecttypes}

<!-- The ObjectTypes clause, broken out of spec.md because in a specification with sixty types
     it is the only clause anyone is editing. spec.md reads it in with `{include objecttypes}`;
     the heading above is this file's own, which is why a part can hold several clauses if that
     is what suits the prose.

     One subclause per type. Prose first, then the definition table bound to the type with
     `defines=`. The table is authored, not generated: node tables make editorial choices the
     model cannot express. Binding it is what lets the validator report where the table and
     the model disagree instead of the tool overwriting your work.

     A cell spanning the rest of its row is written as one cell followed by empty ones -
     markdown has no column spans, and the converter turns the run back into a span.

     The three tables under one caption - Attribute, References, Conformance Units - share one
     caption and one number. Separate them with a blank line; do not caption them separately.

     A blank line does not end that run, so an uncaptioned table that is a table of its own -
     the Editor Note below - is preceded by `---` on a line of its own. The break prints
     nothing; an empty paragraph, which is the other way to end the run, doubles the space. -->

### SomeType {#sec-sometype}

[What this type represents, and when a Server would expose one. One or two paragraphs.]

The *SomeType* *ObjectType* is defined in [](#tbl-sometype-definition).

*Table - SomeType Definition* {#tbl-sometype-definition defines=SomeType}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:SomeType |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |
| Subtype of the 0:BaseObjectType defined in [](#ref-uapart5) |  |  |  |  |  |
| 0:HasComponent | Object | 1:SomeAlarm |  | 0:AlarmConditionType | O |
| 0:HasComponent | Object | 1:SomeState |  | 1:SomeStateMachineType | M |
| 0:HasProperty | Variable | 1:SomeProperty1 | 0:String | 0:PropertyType | M |
| 0:HasProperty | Variable | 1:SomeProperty2 | 0:Int32 | 0:PropertyType | M |
| 0:HasComponent | Variable | 1:SomeMeasurement | 0:Number | 1:SomeVariableType | O |
| 0:HasComponent | Variable | 1:SomeNumericArray | 0:Int32[] | 0:BaseDataVariableType | O |
| 0:HasComponent | Variable | 1:SomeStructureArray | 1:SomeStructure[] | 0:BaseDataVariableType | O |
| 0:HasComponent | Variable | 1:SomeEnumeration | 1:SomeEnumeration | 0:BaseDataVariableType | O |
| 0:HasComponent | Method | 1:SomeMethod |  |  | M |

| **Conformance Units** |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| Some Base |  |  |  |  |  |
| Some Measurements |  |  |  |  |  |
| Some Arrays |  |  |  |  |  |

---
| **Editor Note** - DESCRIBING NODES |
| --- |
| Each of child node defined in the table should have text describing what it for and what semantics apply. In some cases, the nodes are defined completely in other sections so only a brief summary is needed here. |

The *SomeProperty1* *Property* [describe its purpose].

The *SomeProperty2* *Property* [describe its purpose].

The *SomeMeasurement* *Variable* [describe its purpose].

The *SomeNumericArray* *Variable* [describe its purpose].

The *SomeStructureArray* *Variable* [describe its purpose].

The *SomeMethod* *Method* [describe its purpose].

The *SomeAlarm* *Alarm* [describe its purpose].

---
| **Editor Note** - SPECIFYING CONFORMANCE UNITS |
| --- |
| The ConformanceUnits listed in the table are the primary ConformanceUnits used to test the capabilities provided by a Node. ConformanceUnits which indirectly require the Node are not listed.<br>For example, a ConformanceUnit testing a subtype of a ObjectType does not need to be listed since a supertype is automatically included if a subtype is included.<br>If there are no suitable ConformanceUnits then the Node may not be needed or there are missing ConformanceUnits.<br>The OPC Foundation tooling used to validate the specification during the release process automatically adds the ConformanceUnits listed to the Category element for the Node definition in the UANodeSet. Therefore, editors do not have to add these Category elements manually into the UANodeSet.|

The components of the *SomeType* *ObjectType* have additional references which are defined in [](#tbl-sometype-additional-references).

*Table - SomeType Additional References* {#tbl-sometype-additional-references}

| **SourceBrowsePath** | **Reference Type** | **Is Forward** | **TargetBrowsePath** |
| --- | --- | --- | --- |
| 1:SomeProperty1 | 0:HasDictionaryEntry | True | 3:0112/2///61987#ABN613#001 | 
| 1:SomeMeasurement<br>0:EngineeringUnits | 0:HasQuantity | True | 0:Quantities<br>1:Speed |
| 1:SomeMeasurement | 0:HasCondition | True | 1:SomeAlarm |

---
| **Editor Note** - SPECIFYING ADDITIONAL REFERENCES |
| --- |
| [](#tbl-sometype-definition) allows you to define ObjectTypes. You add InstanceDeclarations, which can be based on complex TypeDefinitions (such as AnalogItemType). The complex structure of those TypeDefinitions does not need to be further defined, as it is already done by their TypeDefinitions. However, if you want to add additional References, you can use a table format as shown in [](#tbl-sometype-additional-references). This format allows you to add References from those InstanceDeclarations to any other Node. |

---
| **Editor Note** - SPECIFYING DICTIONARY REFERENCES |
| --- |
| When making use of dictionary references (see [](#ref-uapart19)) the following rules apply:<br>- DictionaryEntries from a TypeDefinition shall be referenced directly (see [](#tbl-sometype-definition));<br>- DictionaryEntries from InstanceDeclarations shall be referenced by using an Additional References table for the TypeDefinition (see [](#tbl-sometype-additional-references)).<br>When using IRDIs or URIs:<br>- use the well-defined namespace (see [](#ref-uapart19)) and include this in Table 40. This template already contains as example the IRDI namespace;<br>- create an additional NodeSet file for this namespace containing only the DictionaryEntries your specification is referencing, no additional organizational structure;<br>- use the URI or IRDI as the BrowseName and add a prefixed for the NamespaceIndex (see examples above).|

The components of the *SomeType* *ObjectType* have additional subcomponents  which are defined in [](#tbl-sometype-additional-subcomponents).

*Table - SomeType Additional Subcomponents* {#tbl-sometype-additional-subcomponents}

| **BrowsePath** | **Reference** | **NodeClass** | **BrowseName** | **DataType** | **TypeDefinition** | **Others** |
| --- | --- | --- | --- | --- | --- | --- |
| 1:SomeAlarm | 0:HasComponent | Object | 1:SomeParameters | | 0:BaseObjectType | M | 
| 1:SomeMeasurement | 0:HasProperty | Variable | 0:AllowNulls | 0:Boolean | 0:PropertyType | O | 
| 1:SomeAlarm<br>1:SomeParameters | 0:HasComponent | Variable | 1:MaxNumberOfPorts | 0:Byte | 0:BaseDataVariableType | M | 
| 1:SomeAlarm<br>1:SomeParameters | 0:HasComponent | Variable | 1:LocationTag | 0:String | 0:BaseDataVariableType | M | 
| 1:SomeAlarm<br>1:SomeParameters<br>1:LocationTag | 0:HasProperty | Variable | 0:MaxStringLength | 0:UInt32 | 0:PropertyType | Os |

---
| **Editor Note** - SPECIFYING ADDITIONAL SUBCOMPONENTS |
| --- |
| [](#tbl-sometype-definition) allows you to define ObjectTypes. You add InstanceDeclarations, which can be based on complex TypeDefinitions (such as AnalogItemType). The complex structure of those TypeDefinitions does not need to be further defined, as it is already done by their TypeDefinitions. However, if you want to add additional subcomponents, you can use a table format as shown in [](#tbl-sometype-additional-subcomponents). This format allows you to add instances to those InstanceDeclarations. |


The child Nodes of the *SomeType* *ObjectType* have additional Attribute values defined in [](#tbl-attribute-values-for-child-nodes).

*Table - Attribute Values for Child Nodes* {#tbl-attribute-values-for-child-nodes}

| **BrowsePath** | **Value Attribute** | **Description Attribute** |
| --- | --- | --- |
| 1:SomeMeasurement | 5.7 | This is a description for SomeMeasurement. | 
| 1:SomeAlarm<br>1:SomeParameters<br>1:LocationTag | "Building 2" | This is a description for LocationTag. | 
| 1:SomeMeasurement<br>0:EURange | High: 1000<br>Low: 0 | This is the EURange for SomeMeasurement. | 
| 1:SomeMeasurement<br>0:EngineeringUnits | NamespaceUri: urn:someunits.org:2026-08:definitions<br>UnitId: 1234<br>DisplayName: Fidgets<br>Description: Number of Fidgets |  | 
| 1:SomeAlarm |  | This is a description for SomeAlarm. | 
| 1:SomeNumericArray | [0,1,2] |  | 
| 1:SomeStructureArray | [{ "SP1": 12.34, "SP2": 25.25, "SomeVector": { "X": 100, "Y": 200, "Z": 300 }}, { "SP1": 25.99,"SP2": 90.15, "SomeVector": { "X": 300, "Y": 200, "Z": 100 }}] | | 

### SomeMethod {#sec-somemethod type=SomeType method=SomeMethod}

[An overview of the Method]

**Signature**  
```
SomeMethod (
  [in]  0:String InArg1,
  [in]  0:Double InArg2,
  [out] 0:UInt32 OutArg1,
  [out] 0:Int32  SomeStatus);
```

*Table - SomeMethod Method Arguments* {#tbl-somemethod-method-arguments}

| **Argument** | **Description** |
| --- | --- |
| InArg1 | Some description of InArg1. |
| InArg2 | Some description of InArg2. |
| OutArg1 | Some description of OutArg2. |
| SomeStatus | Some description of SomeStatus. |

[Additional discussion of the arguments and how they are used.]

**Method Result Codes (defined in Call Service)**  

| **Result Code** | **Description** |
| --- | --- |
| Bad_UserAccessDenied | See [](#ref-uapart4) for a general description. |

The *SomeMethod* *Method* is defined in [](#tbl-somemethod-definition).

*Table - SomeMethod Definition* {#tbl-somemethod-definition defines=SomeMethod}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:SomeMethod |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |
| 0:HasProperty | Variable | 0:InputArguments | 0:Argument[] | 0:PropertyType | M |
| 0:HasProperty | Variable | 0:OutputArguments | 0:Argument[] | 0:PropertyType | M |

### SomeInstance {#sec-someinstance}

[What this instance represents and how it is used]

Its representation in the AddressSpace is defined in [](#tbl-someinstance-definition).

*Table - SomeInstance Definition* {#tbl-someinstance-definition}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:SomeInstance |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |
| 0:OrganizedBy the 0:Objects object defined in [](#ref-uapart5) |  |  |  |  |  |
| 0:HasTypeDefinition | ObjectType | 1:SomeType |  |  |  |

### SomeStateMachineType {#sec-somestatemachinetype}
---
| **Editor Note** - STATEMACHINE |
| --- |
| This section gives an example of how a StateMachine is defined using the table formats used in the temple. This allows the validator to check the correctness of the StateMachine in the Spec with the NodeSet-File. |

[What this type represents, and when a Server would define one. One or two paragraphs.]

The *SomeStateMachineType* *ObjectType* is defined in [](#tbl-somestatemachinetype-definition).

*Table - SomeStateMachineType Definition* {#tbl-somestatemachinetype-definition defines=SomeStateMachineType}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:SomeStateMachineType |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |
| Subtype of the 0:FiniteStateMachineType defined in [](#ref-uapart5) |  |  |  |  |  |
| 0:HasComponent | Object | 1:Idle |  | 0:InitialStateType |  |
| 0:HasComponent | Object | 1:Working |  | 0:StateType |  |
| 0:HasComponent | Object | 1:FromIdleToWorking |  | 0:TransitionType |  |
| 0:HasComponent | Object | 1:FromWorkingToIdle |  | 0:TransitionType |  |
| 0:HasComponent | Method | 1:Start |  |  | M |
| 0:HasComponent | Method | 1:Stop |  |  | M |

| **Conformance Units** |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| Some Base |  |  |  |  |  |

The components of the *SomeStateMachineType* *ObjectType* have additional references which are defined in  [](#tbl-somestatemachinetype-additional-references).

*Table - SomeStateMachineType Additional References* {#tbl-somestatemachinetype-additional-references}

| **SourceBrowsePath** | **Reference Type** | **Is Forward** | **TargetBrowsePath** |
| --- | --- | --- | --- |
| 1:FromIdleToWorking | 0:FromState | True | 1:Idle | 
|  | 0:ToState | True | 1:Working | 
|  | 0:HasCause | True | 1:Start | 
| 1:FromWorkingToIdle | 0:FromState | True | 1:Working | 
|  | 0:ToState | True | 1:Idle | 
|  | 0:HasCause | True | 1:Stop | 
|  | 0:HasEffect | True | 0:SystemEventType | 

The component Variables of the *SomeStateMachineType* have additional *Attributes* defined in  [](#tbl-somestatemachinetype-attribute-values-for-child-nodes).

*Table - SomeStateMachineType Attribute Values for Child Nodes* {#tbl-somestatemachinetype-attribute-values-for-child-nodes}

| **BrowsePath** | **Value Attribute** |
| --- | --- | --- |
| 1:Idle<br>0:StateNumber | 1 |
| 1:Working<br>0:StateNumber | 2 |
| 1:FromIdleToWorking<br>0:TransitionNumber | 1 |
| 1:FromWorkingToIdle<br>0:TransitionNumber | 2 |

### Start {#sec-start type=SomeStateMachineType method=Start}

[An overview of the Method]

**Signature**  
```
Start ();
```

*Table - Start Method Arguments* {#tbl-start-method-arguments}

| **Argument** | **Description** |
| --- | --- |

[Additional discussion of the arguments and how they are used.]

**Method Result Codes (defined in Call Service)**  

| **Result Code** | **Description** |
| --- | --- |
| Bad_UserAccessDenied | See [](#ref-uapart4) for a general description. |

The *Start* *Method* is defined in [](#tbl-start-definition).

*Table - Start Definition* {#tbl-start-definition defines=Start}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:Start |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |

### Stop {#sec-stop type=SomeStateMachineType method=Stop}

[An overview of the Method]

**Signature**  
```
Stop ();
```

*Table - Stop Method Arguments* {#tbl-stop-method-arguments}

| **Argument** | **Description** |
| --- | --- |

[Additional discussion of the arguments and how they are used.]

**Method Result Codes (defined in Call Service)**  

| **Result Code** | **Description** |
| --- | --- |
| Bad_UserAccessDenied | See [](#ref-uapart4) for a general description. |

The *Stop* *Method* is defined in [](#tbl-stop-definition).

*Table - Stop Definition* {#tbl-stop-definition defines=Start}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:Start |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |

### SomeEventType {#sec-someeventtype}

[What this type represents, and when a Server would define one. One or two paragraphs.]

The *SomeEventType* *EventType* is defined in [](#tbl-someeventtype-definition).

*Table - SomeEventType Definition* {#tbl-someeventtype-definition defines=SomeEventType}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:SomeEventType |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |
| Subtype of the 0:SystemEventType defined in [](#ref-uapart5) |  |  |  |  |  |
| 0:HasProperty | Variable | 1:SomeEventField | 0:String | 0:PropertyType | M |

| **Conformance Units** |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| Some Base |  |  |  |  |  |

This *EventType* inherits all *Properties* of the *SystemEventType*.

[Addition descriptions of additional properties.]

## OPC UA VariableTypes {#sec-opcua-variabletypes}

### SomeVariableType {#sec-somevariabletype}

[What this type represents, and when a Server would define one. One or two paragraphs.]

The *SomeVariableType* *VariableType* is defined in [](#tbl-somevariabletype-definition).

*Table - SomeVariableType Definition* {#tbl-somevariabletype-definition defines=SomeVariableType}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:SomeVariableType |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |
| Subtype of the 0:AnalogItemType defined in [](#ref-uapart5) |  |  |  |  |  |
| 0:HasProperty | Variable | 1:SomeVar1 | 0:UtcTime | 0:PropertyType | M |
| 0:HasProperty | Variable | 1:SomeVar2 | 0:UtcTime | 0:PropertyType | M |

| **Conformance Units** |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| Some Measurements |  |  |  |  |  |

[Addition descriptions of additional properties.]

## OPC UA DataTypes {#sec-opcua-datatypes}

### SomeStructure {#sec-somestructure}

[What this DataType represents and how it is used]

The *SomeStructure* *DataType* is defined in [](#tbl-somestructure-structure).

*Table - SomeStructure Structure* {#tbl-somestructure-structure datatype=SomeStructure}

| **Name** | **Type** | **Description** | **AllowSubtypes** |
| --- | --- | --- | --- |
| SomeStructure | 0:Structure | Subtype of the 0:Structure defined in [](#ref-uapart5) |  |
|   SP1 | 0:Double | Setpoint 1 |  |
|   SP2 | 0:Double | Setpoint 2 |  |
|   SomeVector | 0:Vector |  | Yes |

Its representation in the AddressSpace is defined in [](#tbl-somestructure-definition).

*Table - SomeStructure Definition* {#tbl-somestructure-definition defines=SomeStructure}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:SomeStructure |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |
| Subtype of the 0:Structure defined in [](#ref-uapart5) |  |  |  |  |  |

| **Conformance Units** |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| Some Measurements |  |  |  |  |  |
| Some Arrays |  |  |  |  |  |

### SomeUnion {#sec-someunion}

[What this DataType represents and how it is used]

The *SomeUnion* *DataType* is defined in [](#tbl-someunion-structure).

*Table - SomeUnion Structure* {#tbl-someunion-structure datatype=SomeUnion}

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| SomeUnion | 0:Union | Subtype of the 0:Union defined in [](#ref-uapart5) |
|   Choice1 | 0:String | First choice. |
|   Choice2 | 1:SomeStructure | Second choice. |
|   Choice3 | 1:SomeEnumeration | Third choice. |

Its representation in the AddressSpace is defined in [](#tbl-someunion-definition).

*Table - SomeUnion Definition* {#tbl-someunion-definition defines=SomeUnion}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:SomeUnion |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |
| Subtype of the 0:Union defined in [](#ref-uapart5) |  |  |  |  |  |

| **Conformance Units** |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| Some Measurements |  |  |  |  |  |

### SomeEnumeration {#sec-someenumeration}

[What this DataType represents and how it is used]

The *SomeEnumeration* *DataType* is defined in [](#tbl-someenumeration-values).

*Table - SomeEnumeration Values* {#tbl-someenumeration-values datatype=SomeEnumeration}

| **Name** | **Value** | **Description** |
| --- | --- | --- |
| ValueName1 | 0 | Description for ValueName1. |
| ValueName2 | 1 | Description for ValueName2. |
| ValueName3 | 2 | Description for ValueName3. |

Its representation in the AddressSpace is defined in [](#tbl-someenumeration-definition).

*Table - SomeEnumeration Definition* {#tbl-someenumeration-definition defines=SomeEnumeration}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:SomeEnumeration |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |
| Subtype of the 0:Enumeration defined in [](#ref-uapart5) |  |  |  |  |  |

| **Conformance Units** |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| Some Measurements |  |  |  |  |  |

### SomeOptionSet {#sec-someoptionset}

[What this DataType represents and how it is used]

The *SomeOptionSet* *DataType* is defined in [](#tbl-someoptionset-values).

*Table - SomeOptionSet Values* {#tbl-someoptionset-values datatype=SomeOptionSet}

| **Name** | **Bit** | **Description** |
| --- | --- | --- |
| SomeOption1 | 0 | This flag is SomeOption1. |
| SomeOption2 | 1 | This flag is SomeOption2. |
| SomeOption3 | 2 | This flag is SomeOption3. |

Its representation in the AddressSpace is defined in [](#tbl-someoptionset-definition).

*Table - SomeOptionSet Definition* {#tbl-someoptionset-definition defines=SomeOptionSet}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:SomeOptionSet |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |
| Subtype of the 0:UInt32 defined in [](#ref-uapart5) |  |  |  |  |  |

| **Conformance Units** |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| Some Measurements |  |  |  |  |  |

## OPC UA ReferenceTypes {#sec-opcua-referencetypes}

### HasSomeRelation {#sec-hassomerelation}

[What this ReferenceType represents and how it is used]

Its representation in the AddressSpace is defined in [](#tbl-hassomerelation-definition).

*Table - HasSomeRelation Definition* {#tbl-hassomerelation-definition defines=HasSomeRelation}

| **Attribute** | **Value** |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| BrowseName | 1:HasSomeRelation |  |  |  |  |
| IsAbstract | False |  |  |  |  |

| **References** | **Node Class** | **BrowseName** | **DataType** | **TypeDefinition** | **Other** |
| --- | --- | --- | --- | --- | --- |
| Subtype of the 0:NonHierarchicalReferences defined in [](#ref-uapart5) |  |  |  |  |  |

| **Conformance Units** |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| Some Base |  |  |  |  |  |
