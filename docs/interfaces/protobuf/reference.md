---
title: Function reference | Protobuf | Interfaces | Documentation for kdb+ and q
description: Protobuf/Protocol Buffers kdb+ interface function reference
---
# Protobuf/Protocol Buffers function reference



_Functions exposed in the `.protobufkdb` namespace allow you to generate and parse Protobuf messages_

:fontawesome-brands-github:
[KxSystems/protobufkdb](https://github.com/KxSystems/protobufkdb)

<div markdown="1" class="typewriter">
.protobufkdb.   **Protobuf/Protocol Buffers interface**


Library information
  [version](#protobufkdbversion)                         Return the libprotobuf version as an integer
  [versionStr](#protobufkdbversionstr)                      Return the libprotobuf version as a string

Import schema
  [addProtoImportPath](#protobufkdbaddprotoimportpath)              Add a path from which to import proto schema files
  [importProtoFile](#protobufkdbimportprotofile)                 Import a proto schema file
  [listImportedMessageTypes](#protobufkdblistimportedmessagetypes)        List successfully imported message schemas

Inspect schema
  [displayMessageSchema](#protobufkdbdisplaymessageschema)            Display the schema definition of the message
  [getMessageFields](#protobufkdbgetmessagefields)                Get the list of message fields

Serialize/parse using list
  [serializeArrayFromList](#protobufkdbserializearrayfromlist)          Serialize from a kdb+ mixed list object to a string
  [serializeArrayArenaFromList](#protobufkdbserializearrayarenafromlist)     Serialize from a kdb+ mixed list object to a string, 
                                  using a Google Arena for the intermediate message
  [parseArrayToList](#protobufkdbparsearraytolist)                Parse from a string to a kdb+ mixed list object
  [parseArrayArenaToList](#protobufkdbparsearrayarenatolist)           Parse from a string to a kdb+ mixed list object, using 
                                  a Google Arena for the intermediate message

Serialize/parse using dictionary
  [serializeArrayFromDict](#protobufkdbserializearrayfromdict)          Serialize from a kdb+ dictionary to a string
  [serializeArrayArenaFromDict](#protobufkdbserializearrayarenafromdict)     Serialize from a kdb+ dictionary to a string, using 
                                  a Google Arena for the intermediate message
  [parseArrayToDict](#protobufkdbparsearraytodict)                Parse from a string to a kdb+ dictionary
  [parseArrayArenaToDict](#protobufkdbparsearrayarenatodict)           Parse from a string to a kdb+ dictionary, using 
                                  a Google Arena for the intermediate message

Save/load using list
  [saveMessageFromList](#protobufkdbsavemessagefromlist)             Serialize from a kdb+ mixed list object to a file
  [loadMessageToList](#protobufkdbloadmessagetolist)               Parse from a file to a kdb+ mixed list object

Save/load using dictionary
  [saveMessageFromDict](#protobufkdbsavemessagefromdict)             Serialize from a kdb+ dictionary to a file
  [loadMessageToDict](#protobufkdbloadmessagetodict)               Parse from a file to a kdb+ dictionary

Debugging
  [parseArrayDebug](#protobufkdbparsearraydebug)                 Parse from a string and display debugging
  [loadMessageDebug](#protobufkdbloadmessagedebug)                Parse from a file and display debugging



</div>


??? detail "Message types"

    Where a function takes a `message_type` parameter to specify the name of the message to be be processed, the interface first looks for that message type in the compiled messages. 
    
    If that fails it then searches the imported message definitions.  Only if the message type is not found in either is an error returned.


## `addProtoImportPath`

_Add an import path_


```txt
.protobufkdb.addProtoImportPath[import_path]
```

Where `import_path` is a path (absolute or relative) as a string

1.  adds it as a path to be searched when dynamically importing `.proto` file definitions
1.  returns generic null

Establishes virtual file system mappings such that the import locations appear under the current directory, similar to the `PATH` environment variable.  Can be called more than once to specify multiple import locations.

Where your `.proto` file definition imports other `.proto` files (including recursively), these must also be available on the import paths.  

??? detail "Importing Google's .proto files"

    The regular `.proto` files provided by Google are available in the install package (either when downloaded or built from source) under the `proto` subdirectory.
    
    For examples `kdb_type_specifier.proto` imports `google/protobuf/descriptor.proto` which is available in the `proto` subdirectory.

```q
// successful execution
q).protobufkdb.addProtoImportPath["../proto"]

// incorrect data format provided as input
q).protobufkdb.addProtoImportPath[enlist 1f]
'"Specify import path"
```


## `displayMessageSchema`

_Display the Proto schema of a specified message_

```txt
.protobufkdb.displayMessageSchema[message_type]
```

Where `message_type` is the name of a message type as a string, 

1.  prints schema format to stdout 
1.  returns generic null

`message_type` must match a message name in its `.proto` definition.

??? warning "For use only in debugging"

    The schema is generated by the libprotobuf `DebugString()` functionality and displayed on stdout to preserve formatting and indentation.

```q
q).protobufkdb.displayMessageSchema[`ScalarExampleDynamic]
message ScalarExampleDynamic {
  int32 scalar_int32 = 1;
  double scalar_double = 2;
  string scalar_string = 3;
}
```


## `getMessageFields`

_Get the list of message fields_

```txt
.protobufkdb.getMessageFields[message_type]
```

Where `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition

returns the symbol list of message fields in the order they are declared in the message definition.

```q
q).protobufkdb.getMessageFields[`ScalarExampleDynamic]
`scalar_int32`scalar_double`scalar_string
```


## `importProtoFile`

_Import a `.proto` file definition_


```txt
.protobufkdb.importProtoFile[filename]
```

Where `filename` is the name of a `.proto` file as a string

1.  dynamically imports the file definition into the interface
1.  returns generic null

Success allows the message types defined in the file to be parsed and serialized by the interface.

Signalled errors contain errors and warnings which occurred in parsing the file.

!!! warning "The filename may not include a path." 

    Define directory search locations beforehand with `.protobufkdb.addProtoImportPath`.

```q
// successful function invocation
q).protobufkdb.importProtoFile["examples_dynamic.proto"]

// proto file does not exist
q).protobufkdb.importProtoFile["not_a_file.proto"]
'Error: not_a_file.proto:-1:0: File not found.

  [0]  .protobufkdb.importProtoFile["not_a_file.proto"]
       ^
```


## `listImportedMessageTypes`

_List imported message types_

```txt
.protobufkdb.listImportedMessageTypes[]
```

Returns successfully imported message types as a symbol list.

!!! detail "The list does not contain message types compiled into the interface."

```q
q).protobufkdb.listImportedMessageTypes[]
`ScalarExampleDynamic`RepeatedExampleDynamic`SubMessageExampleDynamic`MapExam..
```


## `loadMessageDebug`

_Parse from a Protobuf message file and display the debugging_

```txt
.protobufkdb.loadMessageDebug[message_type;file_name]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `file_name` is the name of a file (string or symbol)

the function

1.  prints debugging information to stdout 
1.  returns generic null

??? warning "For use only in debugging"

    The debugging is generated by the libprotobuf `DebugString()` functionality and displayed on stdout to preserve formatting and indentation.

```q
q)data
1    2
10   20
"s1" "s2"
q).protobufkdb.saveMessageFromList[`RepeatedExampleDynamic;`trivial_message_file;data]
q).protobufkdb.loadMessageDebug[`RepeatedExampleDynamic;`trivial_message_file]
rep_int32: 1
rep_int32: 2
rep_double: 10
rep_double: 20
rep_string: "s1"
rep_string: "s2"
```


## `loadMessageToDict`

_Parse from a Protobuf message file to a kdb+ dictionary_

```txt
.protobufkdb.loadMessageToDict[message_type;file_name]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `file_name` is the name of a file (string or symbol)

returns a dictionary from field name symbols to field values parsed from `file_name`.

```q
q)data
rep_int32 | 1    2
rep_double| 10   20
rep_string| "s1" "s2"
q).protobufkdb.saveMessageFromDict[`RepeatedExampleDynamic;`trivial_message_file;data]
q).protobufkdb.loadMessageToDict[`RepeatedExampleDynamic;`trivial_message_file]
rep_int32 | 1    2
rep_double| 10   20
rep_string| "s1" "s2"
```


## `loadMessageToList`

_Parse from a Protobuf message file to a kdb+ mixed list object_

```txt
.protobufkdb.loadMessageToList[message_type;file_name]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `file_name` is the name of a file (string or symbol)

returns a kdb+ mixed list object parsed from `file_name`.

```q
q)data
1    2
10   20
"s1" "s2"
q).protobufkdb.saveMessageFromList[`RepeatedExampleDynamic;`trivial_message_file;data]
q).protobufkdb.loadMessageToList[`RepeatedExampleDynamic;`trivial_message_file]
1    2
10   20
"s1" "s2"
```


## `parseArrayArenaToDict`

_Parse from a Protobuf message string to a kdb+ dictionary, using a Google Arena for the intermediate message_

```txt
.protobufkdb.parseArrayArenaToDict[message_type;char_array]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `char_array` is the serialized Protobuf message (string)

the function

1.  parses the string as a Protobuf message, which it creates on a Google Arena
2.  returns the message as a kdb+ dictionary from field name symbols to field values

!!! detail "Identical to `parseArrayToDict` except the intermediate Protobuf message is created on a Google Arena"

    Can improve memory allocation performance for large messages with deep repeated fields/map.
    
    :fontawesome-brands-google:
    [Google Arenas](https://developers.google.com/protocol-buffers/docs/reference/arenas)

```q
q)fields:.protobufkdb.getMessageFields[`RepeatedExampleDynamic]
q)data:fields!(1 2i;10 20f;("s1";"s2"))
q)array:.protobufkdb.serializeArrayFromDict[`RepeatedExampleDynamic;data]
q)array
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
q).protobufkdb.parseArrayArenaToDict[`RepeatedExampleDynamic;array]
rep_int32 | 1    2
rep_double| 10   20
rep_string| "s1" "s2"
```


## `parseArrayArenaToList`

_Parse from a Protobuf message string to a kdb+ mixed list object, using a Google Arena for the intermediate message_

```txt
.protobufkdb.parseArrayArenaToList[message_type;char_array]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `char_array` is the serialized Protobuf message (string)

the function

1.  parses the string as a Protobuf message, which it creates on a Google Arena
2.  returns the message as a kdb+ mixed list object

!!! detail "Identical to `parseArrayToList` except the intermediate Protobuf message is created on a Google Arena"

    Can improve memory allocation performance for large messages with deep repeated fields/map.
    
    :fontawesome-brands-google:
    [Google Arenas](https://developers.google.com/protocol-buffers/docs/reference/arenas)

```q
q)data:(1 2i;10 20f;("s1";"s2"))
q)array:.protobufkdb.serializeArrayFromList[`RepeatedExampleDynamic;data]
q)array
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
q).protobufkdb.parseArrayArenaToList[`RepeatedExampleDynamic;array]
1    2
10   20
"s1" "s2"
```


## `parseArrayDebug`

_Parse from a Protobuf message string and display the debugging_

```txt
.protobufkdb.parseArrayDebug[message_type;char_array]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `char_array` is the serialized Protobuf message (string)

the function

1.  prints debugging information to stdout 
1.  returns generic null

??? warning "For use only in debugging"

    The debugging is generated by the libprotobuf `DebugString()` functionality and displayed on stdout to preserve formatting and indentation.

```q
q)data:(1 2i;10 20f;("s1";"s2"))
q)array:.protobufkdb.serializeArrayFromList[`RepeatedExampleDynamic;data]
q).protobufkdb.parseArrayDebug[`RepeatedExampleDynamic;array]
rep_int32: 1
rep_int32: 2
rep_double: 10
rep_double: 20
rep_string: "s1"
rep_string: "s2"
```


## `parseArrayToDict`

_Parse from a Protobuf message string to a kdb+ dictionary_

```txt
.protobufkdb.parseArrayToDict[message_type;char_array]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `char_array` is the serialized Protobuf message (string)

returns the message as a kdb+ dictionary from field name symbols to field values.

```q
q)fields:.protobufkdb.getMessageFields[`RepeatedExampleDynamic]
q)data:fields!(1 2i;10 20f;("s1";"s2"))
q)array:.protobufkdb.serializeArrayFromDict[`RepeatedExampleDynamic;data]
q)array
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
q).protobufkdb.parseArrayToDict[`RepeatedExampleDynamic;array]
rep_int32 | 1    2
rep_double| 10   20
rep_string| "s1" "s2"
```


## `parseArrayToList`

_Parse from a Protobuf message string to a kdb+ mixed list object_

```txt
.protobufkdb.parseArrayToList[message_type;char_array]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `char_array` is the serialized Protobuf message (string)

returns the message as a kdb+ mixed list object.

```q
q)data:(1 2i;10 20f;("s1";"s2"))
q)array:.protobufkdb.serializeArrayFromList[`RepeatedExampleDynamic;data]
q)array
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
q).protobufkdb.parseArrayToList[`RepeatedExampleDynamic;array]
1    2
10   20
"s1" "s2"
```


## `saveMessageFromDict`

_Serialize from a kdb+ dictionary to a Protobuf message file_

```txt
.protobufkdb.saveMessageFromDict[message_type;file_name;msg_in]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `file_name` is the name of a file (string or symbol)
-   `msg_in` is a kdb+ dictionary from field name symbols to field values

the function 

1.  converts `msg_in` to a Protobuf message of `message_type`, serializes it, and writes it to `file_name`
2.  returns generic null

```q
q)data
rep_int32 | 1    2
rep_double| 10   20
rep_string| "s1" "s2"
q).protobufkdb.saveMessageFromDict[`RepeatedExampleDynamic;`trivial_message_file;data]
```


## `saveMessageFromList`

_Serialize from a kdb+ mixed list object to a Protobuf message file_

```txt
.protobufkdb.saveMessageFromList[message_type;file_name;msg_in]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `file_name` is the name of a file (string or symbol)
-   `msg_in` is a kdb+ mixed list object 

the function 

1.  converts `msg_in` to a Protobuf message of `message_type`, serializes it, and writes it to `file_name`
2.  returns generic null

```q
q)data
1    2
10   20
"s1" "s2"
q).protobufkdb.saveMessageFromList[`RepeatedExampleDynamic;`trivial_message_file;data]
```


## `serializeArrayArenaFromDict`

_Serialize from a kdb+ dictionary to a Protobuf message string, using a Google Arena for the intermediate message_

```txt
.protobufkdb.serializeArrayArenaFromDict[message_type;msg_in]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `msg_in` is a kdb+ dictionary from field name symbols to field values

the function

1.  serializes `msg_in` as a Protobuf message and creates it on a Google Arena
2.  returns the serialized Protobuf message as a string

!!! detail "Identical to `serializeArrayFromDict` except the intermediate Protobuf message is created on a Google Arena"

    Can improve memory allocation performance for large messages with deep repeated fields/map.
    
    :fontawesome-brands-google:
    [Google Arenas](https://developers.google.com/protocol-buffers/docs/reference/arenas)

```q
q)fields:.protobufkdb.getMessageFields[`RepeatedExampleDynamic]
q)data:fields!(1 2i;10 20f;("s1";"s2"))
q).protobufkdb.serializeArrayArenaFromDict[`RepeatedExampleDynamic;data]
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
```


## `serializeArrayArenaFromList`

_Serialize from a kdb+ mixed list object to a Protobuf message string, using a Google Arena for the intermediate message_

```txt
.protobufkdb.serializeArrayArenaFromList[message_type;msg_in]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `msg_in` is a kdb+ mixed list object 

the function

1.  serializes `msg_in` as a Protobuf message and creates it on a Google Arena
2.  returns the serialized Protobuf message as a string

!!! detail "Identical to `serializeArrayFromList` except the Protobuf message is created on a Google Arena"

    Can improve memory allocation performance for large messages with deep repeated fields/map.
    
    :fontawesome-brands-google:
    [Google Arenas](https://developers.google.com/protocol-buffers/docs/reference/arenas)

```q
q)data:(1 2i;10 20f;("s1";"s2"))
q).protobufkdb.serializeArrayArenaFromList[`RepeatedExampleDynamic;data]
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
```


## `serializeArrayFromDict`

_Serialize from a kdb+ dictionary to a Protobuf message string_

```txt
.protobufkdb.serializeArrayFromDict[message_type; msg_in]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `msg_in` is a kdb+ dictionary from field name symbols to field values

returns the serialized Protobuf message as a string.

```q
q)fields:.protobufkdb.getMessageFields[`RepeatedExampleDynamic]
q)data:fields!(1 2i;10 20f;("s1";"s2"))
q).protobufkdb.serializeArrayFromDict[`RepeatedExampleDynamic;data]
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
```


## `serializeArrayFromList`

_Serialize from a kdb+ mixed list object to a Protobuf message string_

```txt
.protobufkdb.serializeArrayFromList[message_type; msg_in]
```

Where

-   `message_type` is a message type (string or symbol) matching a message name in the `.proto` definition
-   `msg_in` is a kdb+ mixed list object 

returns the serialized Protobuf message as a string.

```q
q)data:(1 2i;10 20f;("s1";"s2"))
q).protobufkdb.serializeArrayFromList[`RepeatedExampleDynamic;data]
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
```


## `version`

_Library version (integer) used by the interface_

```txt
.protobufkdb.version[]
```

returns the version of the `libprotobuf` shared object used by the interface, as an integer.

```q
q).protobufkdb.version[]
3012003i
```


## `versionStr`

_Library version (string) used by the interface_

```txt
.protobufkdb.versionStr[]
```

returns the version of the `libprotobuf` shared object used by the interface, as a string.

```q
q).protobufkdb.versionStr[]
"libprotobuf v3.12.3"
```

