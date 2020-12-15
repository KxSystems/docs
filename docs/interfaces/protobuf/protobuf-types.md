---
title: Datatype mappings | Protobuf | Interfaces | Documentation for kdb+ and q
author: Conor McCarthy
description: Datatype mappings between kdb+ and Protobuf
date: September 2020
---
# Type mapping between kdb+ and Protobuf 

:fontawesome-brands-github:
[KxSystems/protobufkdb](https://github.com/KxSystems/protobufkdb)




We describe how kdb+ numeric and string types are represented in Protobuf, how Protobuf structures are mapped to kdb+.

## Protobuf/kdb+ mapping

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

A Protobuf message is represented in kdb+ using a mixed list with length equal to the number of fields in the message. The fields are iterated in the order they are declared in the message definition (which may be different to the field number tags).

The kdb+ type used for each list item depends on the field type:

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


### Scalar fields

Scalar fields are represented as kdb+ atoms with their type mapping based on the underlying C++ representation

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
string, bytes             string     -11h      
```

When parsing from Protobuf to kdb+, for any field which has not been explicity set in the encoded message, Protobuf will return the default value for that field type which is then populated as usual into the corresponding kdb+ element.

Similarly when serialising from kdb+ to Protobuf, any kdb+ element set to its field-specific default value is equivalent to not explicitly setting that field in the encoded message. It is necessary to pad unspecified message fields with their default value in kdb+ in order to maintain the one-to-one mapping between any given message field and its corresponding kdb+ element.


### Repeated Fields

Repeated fields are represented as singularly typed kdb+ lists with the underlying kdb+ type based on the repeated type:

```txt
scalar                    C++        kdb+
-----------------------------------------
int32, sint32, sfixed32   int32      6h       
uint32, fixed32           int32      6h       
int64, sint64, sfixed64   int64      7h       
uint64, fixed64           int64      7h       
double                    double     9h       
float                     float      8h       
bool                      bool       1h       
enum                      int32      6h       
string, bytes             string     11h      
```


### Map fields

Protobuf maps are represented as kdb+ dictionaries with keys and values defined as follows

!!! Warning "The Protobuf wire format and map iteration ordering of map items is not deterministic"

    You cannot rely upon it to return a particular dictionary ordering on conversion to kdb+.


**Protobuf map keys** can only be integer, boolean or string types and are therefore limited to the following type mappings

```txt
map-key                   C++        kdb+
-----------------------------------------
int32, sint32, sfixed32   int32      6h        
uint32, fixed32           int32      6h        
int64, sint64, sfixed64   int64      7h        
uint64, fixed64           int64      7h        
bool                      bool       1h        
string, bytes             string     11h       
```

**Protobuf map values** can be any type other than repeated fields or maps and therefore are defined by the following type mapping

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
string, bytes             string           11h 
message                   [message class]  0h  
```


### Oneof Fields

Oneof fields are similar to regular fields except all the fields in a oneof share memory, and at most one field can be set at the same time. Setting any member of the oneof automatically clears all the other members.

The kdb+ representation of a oneof field is therefore dependent on whether that field is currently the active member of the oneof:

```txt
Oneof field state  kdb+ representation 
---------------------------------------
Set                As per regular field
Unset              Empty mixed list    
```

!!! tip "When serializing from kdb+ to Protobuf it is possible to specify values for multiple oneof fields"

    This is valid usage of oneof and does not produce an error; rather the oneof will be set to the value of the last specified field.


### `KdbTypeSpecifier` field option

To support the use of the kdb+ temporal types and GUIDs which do not have an equivalent representation in Protobuf, a field option extension is provided in `src/kdb_type_specifier.proto` (for compiled in message definitions) and `proto/kdb_type_specified.proto` (for dynamically imported message definitions). This allows a kdb+ specific context to be applied to fields, map-keys and map-values:

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

  	For the purpose of compatibility across different versions of Protobuf the above has been defined in proto2, this definition is equally valid in proto3.

In order to apply a `KdbTypeSpecifier` to a field you must import `kdb_type_specifier.proto` into your `.proto` file, then specify the `KdbTypeSpecifier` field option as, for example:

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

The following is the mapping between the `KdbTypeSpecifier` and associated kdb+ types.

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

`KdbTypeSpecifier=DEFAULT` is equivalent to the specifier not being present, i.e. the kdb+ type is determined from the Proto field type.

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

When serialising from kdb+ to Protobuf, the kdb+ structure must conform to the mappings above with respect to that particular message definition. This is important both in terms of the type of each message field (scalar, repeated, map, etc.) and the Proto type specified to represent that field (int32, double, string, etc.)

The interface will type check each field as appropriate and return an error if a mismatch is detected detailing:

1.  The type of failure
2.  The message/field where it occurred
3.  The expected kdb+ type
4.  The received kdb+ type

For example:

```q
q).protobufkdb.displayMessageSchema[`ScalarExample]
message ScalarExample {
  int32 scalar_int32 = 1;
  double scalar_double = 2;
  string scalar_string = 3;
}

// Correct function invocation
q)array:.protobufkdb.serializeArray[`ScalarExample;(12i;55f;`str)]

q)array:.protobufkdb.serializeArray[`ScalarExample;(12i;55f;`str;1)]
'Incorrect number of fields, message: 'ScalarExample', expected: 3, received: 4
  [0]  array:.protobufkdb.serializeArray[`ScalarExample;(12i;55f;`str;1)]
             ^

q)array:.protobufkdb.serializeArray[`ScalarExample;(12j;55f;`str)]
'Invalid scalar type, field: 'ScalarExample.scalar_int32', expected: -6, received: -7
  [0]  array:.protobufkdb.serializeArray[`ScalarExample;(12j;55f;`str)]
             ^

q)array:.protobufkdb.serializeArray[`ScalarExample;(enlist 12i;55f;`str)]
'Invalid scalar type, field: 'ScalarExample.scalar_int32', expected: -6, received: 6
  [0]  array:.protobufkdb.serializeArray[`ScalarExample;(enlist 12i;55f;`str)]
             ^
``` 
