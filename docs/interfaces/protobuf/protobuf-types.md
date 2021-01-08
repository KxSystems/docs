---
title: Datatype mappings | Protobuf | Interfaces | Documentation for kdb+ and q
author: Conor McCarthy
description: Datatype mappings between kdb+ and Protobuf
date: September 2020
---
# Type mapping between kdb+ and Protobuf 

:fontawesome-brands-github:
[KxSystems/protobufkdb](https://github.com/KxSystems/protobufkdb)




We describe how q numeric and string types are represented in Protobuf, how Protobuf structures are mapped to q.

## Protobuf/q mapping

A Protobuf message is composed of a number of fields where each field can be scalar, repeated scalar, sub-message, repeated sub-message, enum or map. For example:

```protobuf
message MyMessage {
  int32 scalar_int = 1;
  repeated double repeated_double = 2;
  MyMessage sub_message = 3;
  repeated MyMessage repeated_msg = 4;
  enum EnumType {
    ZERO = 0;
    ONE = 1;
  }
  EnumType enum_field = 5;
  map<int64, string> int_str = 6;
}
```

A Protobuf message is represented in q using a mixed list with length equal to the number of fields in the message. The fields are iterated in the order they are declared in the message definition, which may differ from the field number tags.

The q type used for each list item depends on the field type:

```txt
field type            kdb+ structure        
--------------------------------------------
Scalar                Atom                  
Repeated scalar       Simple list           
Sub-message           Mixed list            
Repeated Sub-message  List of mixed lists   
Enum                  Integer of enum value 
Map                   Dictionary            
```

Where on serialization you do not wish to explicitly set a field, a generic null `(::)` can be specified in the mixed list for that field’s value.  

Furthermore, an additional `::` can be included at the end of the mixed list (past the number of message fields).  Such `::` field values are ignored and this can be used to prevent q from changing the message’s mixed list to a simple list, e.g. where all fields have the same q type. (Parsing will return a mixed list without the additional trailing `::` since it is being created directly, outside of q.)


### Scalar fields

Scalar fields are represented as q atoms with their type mapping based on the underlying C++ representation.

```txt
scalar                    C++        kdb+
----------------------------------------------
int32, sint32, sfixed32   int32      -6h       
uint32, fixed32           int32      -6h       
int64, sint64, sfixed64   int64      -7h       
uint64, fixed64           int64      -7h       
double                    double     -9h       
float                     float      -8h       
bool                      bool       -1h       
enum                      int32      -6h       
string                    string     10h      
bytes                     string     4h
```

When parsing from Protobuf to kdb+, for any field which has not been explicity set in the encoded message, Protobuf will return the default value for that field type which is then populated as usual into the corresponding q element.

Similarly when serializing from q to Protobuf, any q element set to its field-specific default value is equivalent to not explicitly setting that field in the encoded message. It is necessary to pad unspecified message fields with their default value or `::` in q in order to maintain the one-to-one positional mapping between any given message field and its corresponding q element.


### Repeated fields

Repeated fields are represented as singularly typed q lists with the underlying q type based on the repeated type:

```txt
repeated                  C++        kdb+
-----------------------------------------
int32, sint32, sfixed32   int32      6h       
uint32, fixed32           int32      6h       
int64, sint64, sfixed64   int64      7h       
uint64, fixed64           int64      7h       
double                    double     9h       
float                     float      8h       
bool                      bool       1h       
enum                      int32      6h       
string                    string     0h (of 10h)     
bytes                     string     0h (of 4h) 
```


### Map fields

Protobuf maps are represented as kdb+ dictionaries with keys and values defined as follows

!!! warning "The Protobuf wire format and map iteration ordering of map items is not deterministic"

    You cannot rely upon it to return a particular dictionary ordering on conversion to q.


**Protobuf map keys** can only be integer, boolean or string types and are therefore limited to the following type mappings.

```txt
map-key                   C++        kdb+
-----------------------------------------
int32, sint32, sfixed32   int32      6h        
uint32, fixed32           int32      6h        
int64, sint64, sfixed64   int64      7h        
uint64, fixed64           int64      7h        
bool                      bool       1h        
string                    string     11h       
```

**Protobuf map values** can be any type other than repeated fields or maps and therefore are defined by the following type mapping.

```txt
map-value                 C++              kdb+
-----------------------------------------------
int32, sint32, sfixed32   int32            6h  
uint32, fixed32           int32            6h  
int64, sint64, sfixed64   int64            7h  
uint64, fixed64           int64            7h  
double                    double           9h  
float                     float            8h  
bool                      bool             1h  
enum                      int32            6h  
string                    string           0h (of 10h)     
bytes                     string           0h (of 4h)  
message                   [message class]  0h  
```


### Oneof fields

Oneof fields are similar to regular fields except all the fields in a oneof share memory, and at most one field can be set at the same time. Setting any member of the oneof automatically clears all the other members.

The q representation of a oneof field is therefore dependent on whether that field is currently the active member of the oneof:

```txt
Oneof field state  kdb+ representation 
---------------------------------------
Set                As per regular field
Unset              Empty mixed list    
```

!!! tip "When serializing from kdb+ to Protobuf it is possible to specify values for multiple oneof fields"

    This is valid usage of oneof and does not produce an error; rather the oneof will be set to the value of the last specified field.


### `KdbTypeSpecifier` field option

To support the use of the q temporal types and GUIDs which do not have an equivalent representation in Protobuf, a field option extension is provided in `src/kdb_type_specifier.proto` (for compiled in message definitions) and `proto/kdb_type_specified.proto` (for dynamically imported message definitions). This allows a q-specific context to be applied to fields, map-keys and map-values:

```protobuf
syntax = "proto2";

import "google/protobuf/descriptor.proto";

enum KdbTypeSpecifier {
    DEFAULT     = 0;
    TIMESTAMP   = 1;
    MONTH       = 2;
    DATE        = 3;
    DATETIME    = 4;
    TIMESPAN    = 5;
    MINUTE      = 6;
    SECOND      = 7;
    TIME        = 8;
    GUID        = 9;

    // Internal use only
    // Must be at the end since it is used to determine the enum size for lookup arrays
    KDBTYPE_LEN = 10;
}

message MapKdbTypeSpecifier {
    optional KdbTypeSpecifier key_type   = 1;
    optional KdbTypeSpecifier value_type = 2;
}

extend google.protobuf.FieldOptions {
    optional KdbTypeSpecifier    kdb_type        = 756866;
    optional MapKdbTypeSpecifier map_kdb_type    = 756867;
}
```

??? detail "Protobuf versions"

  	For the purpose of compatibility across different versions of Protobuf the above has been defined in proto2. 
    This definition is equally valid in proto3.

To apply a `KdbTypeSpecifier` to a field, import `kdb_type_specifier.proto` into your `.proto` file, then specify the `KdbTypeSpecifier` field option. 
For example:

```protobuf
syntax = "proto3";

import "kdb_type_specifier.proto";

message SpecifierExample {
    int32           date        = 1 [(kdb_type) = DATE]; // Scalar
    repeated int32  time        = 2 [(kdb_type) = TIME]; // Repeated
    map<string, int64>  guid_timespan  = 3 [(map_kdb_type).key_type = GUID,         // Map-key
                                            (map_kdb_type).value_type = TIMESPAN];  // Map-value
}
```

The following is the mapping between the `KdbTypeSpecifier` and associated q types.

```txt
KdbTypeSpecifier  kdb+ type
---------------------------
GUID              2h       
TIMESTAMP         12h      
MONTH             13h      
DATE              14h      
DATETIME          15h      
TIMESPAN          16h      
MINUTE            17h      
SECOND            18h      
TIME              19h      
```

`KdbTypeSpecifier=DEFAULT` is equivalent to the specifier not being present, i.e. the q type is determined from the Proto field type.

The `KdbTypeSpecifier` must be compatible with the defined Proto field type. The following outlines the compatible combinations of types:

```txt
KdbTypeSpecifier  Compatible Field Type                   
----------------------------------------------------------
GUID              string, bytes                           
TIMESTAMP         int64, sint64, sfixed64, uint64, fixed64
MONTH             int32, sint32, sfixed32, uint32, fixed32
DATE              int32, sint32, sfixed32, uint32, fixed32
DATETIME          double                                  
TIMESPAN          int64, sint64, sfixed64, uint64, fixed64
MINUTE            int32, sint32, sfixed32, uint32, fixed32
SECOND            int32, sint32, sfixed32, uint32, fixed32
TIME              int32, sint32, sfixed32, uint32, fixed32
```


## Type checking

When serializing from q to Protobuf, the q structure must conform to the mappings above with respect to that particular message definition. This is important both in terms of the type of each message field (scalar, repeated, map, etc.) and the Proto type specified to represent that field (int32, double, string, etc.)

The interface will type-check each field as appropriate and return an error if a mismatch is detected detailing:

1.  The type of failure
2.  The message/field where it occurred
3.  The expected q type
4.  The received q type

For example:

```q
q).protobufkdb.displayMessageSchema[`ScalarExample]
message ScalarExample {
  int32 scalar_int32 = 1;
  double scalar_double = 2;
  string scalar_string = 3;
}

// Correct function invocation
q)array:.protobufkdb.serializeArrayFromList[`ScalarExample;(12i;55f;"str")]

q)array:.protobufkdb.serializeArrayFromList[`ScalarExample;(12i;55f)]
'Incorrect number of fields, message: 'ScalarExample', expected: 3, received: 2
  [0]  array:.protobufkdb.serializeArrayFromList[`ScalarExample;(12i;55f)]
             ^

q)array:.protobufkdb.serializeArrayFromList[`ScalarExample;(12j;55f;"str")]
'Invalid scalar type, field: 'ScalarExample.scalar_int32', expected: -6, received: -7
  [0]  array:.protobufkdb.serializeArrayFromList[`ScalarExample;(12j;55f;"str")]
             ^

q)array:.protobufkdb.serializeArrayFromList[`ScalarExample;(enlist 12i;55f;"str")]
'Invalid scalar type, field: 'ScalarExample.scalar_int32', expected: -6, received: 6
  [0]  array:.protobufkdb.serializeArrayFromList[`ScalarExample;(enlist 12i;55f;"str")]
             ^
```


## Representing messages as q dictionaries

As described above, protobufkdb represents a message in q as a mixed list of field values in field-positional order. This more closely ties in with how protobuf serializes messages, and is recommended for performance reasons.

However, you may prefer the q mapping for messages to be a dictionary from symbol field names to a mixed list of field values, similarly to how JSON is represented.  This style is supported through separate APIs for both the parsing and serialization functions.

Rather than the field-positional order:

-   Each field name is looked up in the message and its corresponding field value applied
-   Any message fields without a field name/value pair in the dictionary are not explicitly set
-   Where is field value is set to the generic null (`::`) that field name/value pair is ignored
-   Where a field name is specified (and its value is not `::`) but that field is not present is the message, a type-check error is returned

In addition the dictionary style is used recursively when fields contain other messages:

```txt
field type            kdb+ structure        
------------------------------------------------------------------------------------
Sub-message           Field name dictionary            
Repeated sub-message  List of field name dictionaries or a flip table   
Map to message        Map-value is a list of field name dictionaries or a flip table       
```

All other field types use the same q mapping for the field value as is used by the mixed-list message style.

