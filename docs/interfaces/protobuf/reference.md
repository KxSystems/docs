---
title: Function reference | Protobuf | Interfaces | Documentation for kdb+ and q
keywords: protobuf, protocol buffers, api, fusion, interface, q
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
---
# Protobuf/Protocol Buffers function reference

:fontawesome-brands-github: 
[KxSystems/protobufkdb](https://github.com/KxSystems/protobufkdb)
<br>

The following functions are those exposed in the `.protobufkdb` namespace allowing users to generate and parse Protobuf messages.

<pre markdown="1" class="language-txt">
.protobufkdb   **Protobuf/Protocol Buffers interface**

Library Information
  [version](#protobufkdbversion)          Returns the libprotobuf version as an integer
  [versionStr](#protobufkdbversionstr)       Returns the libprotobuf version as a char array

Import Schema
  [addProtoImportPath](#protobufkdbaddprotoimportpath)        Add a search path from which to import proto/schema files
  [importProtoFile](#protobufkdbimportprotofile)           Import the specified file
  [listImportedMessageTypes](#protobufkdblistimportedmessagetypes)  List all successfully imported message schemas

Inspect Schema
  [displayMessageSchema](#protobufkdbdisplaymessageschema)      Display the schema definistion of the message

Serialize / Deserialize
  [parseArray](#protobufkdbparsearray)            Deserialize encoded Protobuf character array to a specified schema
  [parseArrayArena](#protobufkdbparsearrayarena)       Deserialize encoded Protobuf character array with the 
                        specified schema creating an intermediate Protobuf message on google arena
  [serializeArray](#protobufkdbserializearray)        Serialize kdb+ object with the specified schema
  [serializeArrayArena](#protobufkdbserializearrayarena)   Serialize kdb+ object with the specified schema 
                        creating an intermediate Protobuf message on google arena

Save / Load
  [loadMessage](#protobufkdbloadmessage)    Load the specified file and deserialize contents to a kdb+ object
  [saveMessage](#protobufkdbsavemessage)    Serialize kdb+ object with the specified message and save it to the specified file
</pre>

## Library Information

### .protobufkdb.version

_The version of libprotobuf being used by the interface_

Syntax: `.protobufkdb.version[]`

returns an integer representation of the `libprotobuf` shared object used by the interface

```q
q).protobufkdb.version[]
3012003i
```

### .protobufkdb.versionStr

_The version of libprotobuf being used by the interface in a human readable format_

Syntax: `.protobufkdb.versionStr[]`

returns a string providing a human readable representation of the `libprotobuf` shared object used by the interface

```q
q).protobufkdb.versionStr[]
"libprotobuf v3.12.3"
```

## Import Schema

### .protobufkdb.addProtoImportPath

_Adds a path to be searched when dynamically importing `.proto` file definitions.  Can be called more than once to specify multiple import locations._

Syntax: `.protobufkdb.addProtoImportPath[import_path]`

Where:

- `import_path` is a string containing the path to be searched for `.proto` file definitions.  Can be absolute or relative.

returns generic null on successful execution, otherwise return appropriate error

```q
// successful execution
q).protobufkdb.addProtoImportPath["../proto"]

// incorrect data format provided as input
q).protobufkdb.addProtoImportPath[enlist 1f]
'"Specify import path"
```

### .protobufkdb.importProtoFile

_Dynamically import a `.proto` file definition into the interface, allowing the message types defined in that file to be parsed and serialised by the interface._

Syntax: `.protobufkdb.importProtoFile[filename]`

Where:

- `filename` is a string containing the name of the `.proto` file to be imported.  This must not contain any directory specifiers. Directory search locations should be set up beforehand using `.protobufkdb.addProtoImportPath` function

returns generic null on successful execution, otherwise return error containing information on the errors and warnings which occurred if the file fails to parse.

```q
// successful function invocation
q).protobufkdb.importProtoFile["examples_dynamic.proto"]

// proto file does not exist
q).protobufkdb.importProtoFile["not_a_file.proto"]
'Import error: File not found.
File: 'not_a_file.proto', line: -1, column: 0

  [0]  .protobufkdb.importProtoFile["not_a_file.proto"]
       ^
```

### .protobufkdb.listImportedMessageTypes

_Retrieve a list of message types which have been successfully imported._

Syntax: `.protobufkdb.listImportedMessageTypes[]`

returns symbol list of the successfully imported message types.

!!!Note
	 The list does not contain message types which have been compiled into the interface.

```q
q).protobufkdb.listImportedMessageTypes[]
`ScalarExampleDynamic`RepeatedExampleDynamic`SubMessageExampleDynamic`MapExam..
```

## Inspect Schema

### .protobufkdb.displayMessageSchema

_Displays the proto schema of the specified message to console._

Syntax: `.protobufkdb.displayMessageSchema[message_type]`

Where: 

- `message_type` is a string containing the name of the message type.  Must be the same as the message name in its .proto definition.

returns generic null on invocation and prints schema format to stdout.

!!!Warning
	This function is intended for debugging use only. The schema is generated by the libprotobuf `DebugString()` functionality and displayed on stdout to preserve the formatting and indentation.

```q
q).protobufkdb.displayMessageSchema[`ScalarExampleDynamic]
message ScalarExampleDynamic {
  int32 scalar_int32 = 1;
  double scalar_double = 2;
  string scalar_string = 3;
}
```

## Serialize / Deserialize

### .protobufkdb.parseArray

_Parse a proto-serialized char array into a Protobuf message, then converts that into a corresponding kdb object._

Syntax: `.protobufkdb.parseArray[message_type;char_array]`

Where:

- `message_type` is a string/symbol denoting the message type.  Must be the same as the message name outlined in the .proto definition.
- `char_array` is a kdb+ char array containing the serialized Protobuf message.

returns a kdb+ object corresponding to a supplied serialized Protobuf message.

```q
q)data:(1 2i;10 20f;`s1`s2)
q)array:.protobufkdb.serializeArray[`RepeatedExampleDynamic;data]
q)array
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
q).protobufkdb.parseArray[`RepeatedExampleDynamic;array]
1  2 
10 20
s1 s2
```

### .protobufkdb.parseArrayArena

_Identical to `.protobufkdb.parseArray[]` except the intermediate Protobuf message is created on a google arena (can help improves memory allocation performance for large messages with deep repeated fields/map - see [here](https://developers.google.com/protocol-buffers/docs/reference/arenas))._

Syntax: `.protobufkdb.parseArrayArena[message_type;char_array]`

Where:

- `message_type` is a string/symbol denoting the message type.  Must be the same as the message name outlined in the .proto definition.
- `char_array` is a kdb char+ array containing the serialized Protobuf message.

returns a kdb+ object corresponding to a supplied serialized Protobuf message.

```q
q)data:(1 2i;10 20f;`s1`s2)
q)array:.protobufkdb.serializeArray[`RepeatedExampleDynamic;data]
q)array
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
q).protobufkdb.parseArrayArena[`RepeatedExampleDynamic;array]
1  2 
10 20
s1 s2
```

### .protobufkdb.serializeArray

_Convert a kdb+ object to a Protobuf message and serialize this into a char array representation_

Syntax: `.protobufkdb.serializeArray[message_type; msg_in]`

Where:

- `message_type` is a string/symbol denoting the message type.  Must be the same as the message name outlined in the .proto definition.
- `msg_in` is the kdb+ object to be converted.

returns kdb+ char array containing the serialized Protobuf message contents

```q
q)data:(1 2i;10 20f;`s1`s2)
q).protobufkdb.serializeArray[`RepeatedExampleDynamic;data]
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
```

### .protobufkdb.serializeArrayArena

_Identical to `.protobufkdb.serializeArray[]` except the intermediate Protobuf message is created on a google arena (can help improves memory allocation performance for large messages with deep repeated/map fields - see [here](https://developers.google.com/protocol-buffers/docs/reference/arenas))._

Syntax: `.protobufkdb.serializeArrayArena[message_type;msg_in]`

Where:

- `message_type`  is a string/symbol denoting the message type.  Must be the same as the message name outlined in the .proto definition.
- `msg_in` is the kdb+ object to be converted.

returns kdb+ char array containing the serialized Protobuf message contents

```q
q)data:(1 2i;10 20f;`s1`s2)
q).protobufkdb.serializeArrayArena[`RepeatedExampleDynamic;data]
"\n\002\001\002\022\020\000\000\000\000\000\000$@\000\000\000\000\000\0004@\0..
```

## Save / Load

### .protobufkdb.loadMessage

_Parse a proto-serialized stream from a specified file to a Protobuf message and convert this into a corresponding kdb+ object._

Syntax: `.protobufkdb.loadMessage[message_type;file_name]`

Where:

- `message_type` is a string/symbol denoting the message type.  Must be the same as the message name outlined in the .proto definition.
- `file_name` is a string/symbol containing the name of the file to read from.

returns a kdb+ object corresponding to a contents of the proto file.

```q
q)data
1  2 
10 20
s1 s2
q).protobufkdb.saveMessage[`RepeatedExampleDynamic;`trivial_message_file;data]
q).protobufkdb.loadMessage[`RepeatedExampleDynamic;`trivial_message_file]
1  2
10 20
s1 s2
```

### .protobufkdb.saveMessage

_Convert a kdb object to a Protobuf message, serializes it, then write the result to the specified file._

Syntax: `.protobufkdb.saveMessage[message_type;file_name;msg_in]`

Where:

- `message_type` is a string/symbol denoting the message type.  Must be the same as the message name outlined in the .proto definition.
- `file_name` is a string/symbol containing the name of the file to read from.
- `msg_in` is the kdb+ object to be converted.

returns generic null on sucessful execution.

```q
q)data
1  2 
10 20
s1 s2
q).protobufkdb.saveMessage[`RepeatedExampleDynamic;`trivial_message_file;data]
```
