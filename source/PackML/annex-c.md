## DataType {#anx-informative-datatype annex=informative}


### Mapping of elementary data types {#anx-mapping-of-elementary-data-types}


The mapping of IEC 61131-3 elementary data types to OPC UA data types is formally defined in OPC 30000 (PLCOpen companion specification). <xref ref-type="table" rid="tbl_71_mapping-iec-61131-3-elementary-data-types-to-opc-ua-built-in">Table 71</xref> is copied from that specification as a reference, any differences with OPC 30000 indicate that this specification is out of date.

*Table - Mapping IEC 61131-3 elementary data types to OPC UA built in data types* {#tbl-mapping-iec-61131-3-elementary-data-types-to-opc-ua-built-in}
| IEC 61131-3 elementary data types	| OPC UA built in data types	| Comment |
| --- | --- | --- | 
| BOOL	| Boolean	| A one bit value (true or false). |
| SINT	| SByte	| An 8 bit signed integer value. |
| USINT	| Byte	| An 8 bit unsigned integer value. |
| INT	| Int16	| A 16 bit signed integer value. |
| UINT	| UInt16	| A 16 bit unsigned integer value. |
| DINT	| Int32	| A 32 bit signed integer value. |
| UDINT	| UInt32	| A 32 bit unsigned integer value. |
| LINT	| Int64	| A 64 bit signed integer value. |
| ULINT	| UInt64	| A 64 bit unsigned integer value. |
| BYTE	| Byte	| The PLC open specific OPC UA simple data type BYTE is derived from the built in data type Byte. It describes that the type is used as bit string of length 8. |
| WORD	| UInt16	| The PLC open specific OPC UA simple data type WORD is derived from the built in data type UInt16. It describes that the type is used as bit string of length 16 |
| DWORD	| UInt32	| The PLC open specific OPC UA simple data type DWORD is derived from the built in data type UInt32. It describes that the type is used as bit string of length 32 |
| LWORD	| UInt64	| The PLC open specific OPC UA simple data type LWORD is derived from the built in data type UInt64. It describes that the type is used as bit string of length 64 |
| REAL	| Float	| OPC UA definition: An IEEE-754 single precision (32 bit) floating point value. IEC 61131-3 definition: Real (32 bit) with a range of values as defined in IEC 60559 for the basic single width floating-point format. Both standards are identical. |
| LREAL	| Double	| OPC UA definition: An IEEE-754 double precision (64 bit) floating point value. IEC 61131-3 definition: Long real (64 bit) with a range of values as defined in IEC 60559 for the basic double width floating-point format. Both standards are identical. |
| STRING	| String	| The PLC open specific OPC UA simple data type STRING is derived from the built in data type String. It describes that the type is used as a variable-length single-byte character string. |
| CHAR	| Byte	| The PLC open specific OPC UA simple data type CHAR is derived from the built in data type Byte. It describes that the type is used as single-byte character |
| WSTRING	| String	| OPC UA definition: A sequence of UTF8 characters. IEC 61131-3 definition: Variable-length double-byte character string |
| WCHAR	| UInt16	| The PLC open specific OPC UA simple data type WCHAR is derived from the built in data type UInt16. It describes that the type is used as double-byte character. |
| DT | DATE_AND_TIME	| DateTime	OPC UA definition: A 64-bit signed integer which represents the number of 100 nanosecond intervals since January 1, 1601.  IEC 61131-3 definition: Date and time of day. |
| DATE	| DateTime	| The PLC open specific OPC UA simple data type DATE is derived from the built in data type DateTime. It describes that the type is used as a date only. |
| TOD TIME_OF_DAY	| DateTime	| The PLC open specific OPC UA simple data type TOD is derived from the built in data type DateTime. It describes that the type is used as time of day only. |
| TIME	| Double  | The OPC UA simple data type Duration is derived from the built in data type Double. It describes that the type is used as interval of time in milliseconds. |



### Mapping of generic data types {#anx-mapping-of-generic-data-types}

The mapping of IEC 61131-3 generic data types to OPC UA *DataTypes* is formally defined in OPC 30000 (PLCOpen companion specification). <xref ref-type="table" rid="tbl_72_mapping-iec-61131-3-generic-data-types-to-opc-ua-data-types">Table 72</xref>. is copied from that specification as a reference, any differences with OPC 30000 indicate that this specification is out of date. This mapping definition is defined for completeness but is normally not used in an OPC UA *AddressSpace*.

*Table - Mapping IEC 61131-3 generic data types to OPC UA data types* {#tbl-mapping-iec-61131-3-generic-data-types-to-opc-ua-data-types}
| IEC 61131-3 generic data types	| OPC UA data types	| Description |
| --- | --- | --- | 
| ANY	| BaseDataType	| This abstract OPC UA DataType defines a value that can have any valid OPC UA DataType. |
| ANY_DERIVED	| BaseDataType	 | "" |
| ANY_ELEMENTARY	| BaseDataType	 | "" |
| ANY_MAGNITUDE	| BaseDataType	 | "" |
| ANY_NUM	| Number	| This abstract OPC UA DataType defines a number value that can have any of the OPC UA Number subtypes. | 
| ANY_REAL	| Number	 | "" |
| ANY_INT	| Number	 | "" |
| ANY_BIT	| Number	 | "" |
| ANY_STRING	| String	| This OPC UA Built-in DataType defines a Unicode character string that should exclude control characters that are not whitespaces (0x00 - 0x08, 0x0E-0x1F or 0x7F). |
| ANY_DATE	| DateTime	| This OPC UA Built-in DataType defines a Gregorian calendar date. It is a 64-bit signed integer which represents the number of 100 nanosecond intervals since January 1, 1601. |

### Mapping of derived data types {#anx-mapping-of-derived-data-types}

#### Mapping of enumerated data types {#anx-mapping-of-enumerated-data-types}

Both OPC UA and IEC 61131-3 allow the definition of enumerations on a data type or on a variable instance.

In OPC UA the enumerated *DataTypes* are defined as subtypes of *Enumeration*. The data has an *EnumStrings Property* that contains the possible string values. The value is transferred as integer on the wire where the integer defines the index into the *EnumStrings* array. The index is zero based and has no gaps. Another option is to provide the possible string values in the *Property EnumValues*. This option is used if individual integer values are assigned to the string. The used option depends on the way the string enumeration is defined in the *Controller* program. If integer values are assigned to the string values the *Property EnumValues* is used to represent the enumeration values. If the integer value is zero based and has no gaps the *EnumStrings Property* should be used since the processing on the client side is more efficient.

The definition on a variable instance is using the MultiStateDiscreteType Variable Type which defines also the *EnumStrings* or the *EnumValues Property* containing the enumeration values as string array.

Example for an enumerated data type declaration in IEC 61131-3:
```
TYPE 
  ANALOG_SIGNAL_TYPE : (SINGLE_ENDED, DIFFERENTIAL); 
END_TYPE
```

Example for use of an enumeration in a *Ctrl Variable* instantiation in IEC 61131-3:
```
VAR 
  Y : (Red, Yellow, Green); 
END_VAR
```

#### Mapping of array data types {#anx-mapping-of-array-data-types}

OPC UA provides the information if a value is an array in the *Variable* *Attributes* *ValueRank* and *ArrayDimensions*. Every data type can be exposed as array. Arrays can have multiple dimensions. The dimension is defined through the *Attribute* *ValueRank*. Arrays can have variable or fixed lengths. The length of each dimension is defined by the *Attribute* *ArrayDimensions*. The array index starts with zero.

IEC 61131-3 allows the declaration of array data types with one or multiple dimensions and an index range instead of a length.

OPC UA has no standard concept for defining special array data types or exposing index ranges.

Example for an array data type declaration in IEC 61131-3:
```
TYPE 
  ANALOG_16_INPUT_DATA : ARRAY [1..16] OF INT ; 
END_TYPE
```

Example for use of an array in a *Ctrl Variable* instantiation in IEC 61131-3:
```
 VAR 
  MyArray : ARRAY [1..16] OF INT; 
END_VAR
```