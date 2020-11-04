---
title: Protobufkdb | Interfaces | Documentation for kdb+ and q
description: Protobuf/Google Protocol Buffers is a flexible data-interchange mechanism for serializing/deserializing structured data wherever programs or services have to store or exchange data via interfaces 
---

# Protobufkdb

:fontawesome-brands-github: 
[KxSystems/protobufkdb](https://github.com/KxSystems/protobufkdb)

Protobuf/Google Protocol Buffers is a flexible data-interchange mechanism for serializing/deserializing structured data wherever programs or services have to store or exchange data via interfaces while maintaining a high degree of language interoperability.  The binary-encoded format used to represent the data is considerably more efficient, both in terms of raw processing speed and compact data size, than other encodings such as JSON or XML.

Protocol Buffers is supported across a wide variety of programming languages (including C++, C#, Java and Python), enabling communication between separate applications and platforms though a simple common structured schema.  Using this schema, the protocol buffer’s compiler generates source code in the language of choice, which is used to serialize and deserialize the binary encoded data.  This substantially reduces the boilerplate code which is otherwise required to convert between the messaging data format and your language's native structures.

:fontawesome-brands-google:
[Google developers’ page](https://developers.google.com/protocol-buffers/)


## Protobuf/kdb+ Integration

This interface allows a user to serialize/deserialize Protobuf messages from a kdb+ session via reference to loaded schema files. This interface supports two methods of loading a schema file which have associated pros and cons:

Incorporate the schema into a shared library at compile time

: This is the most performant form of loading a schema file although it is inflexible.

Load a schema file from a kdb+ session dynamically

: This is an extremely flexible option giving the option to modify schema files without re-compiling the library. This option is approximately 10% to 20% less performant than the compiled version.

In addition to this a user can also assign serialized data to a kdb+ variable or save it to a file. Similarly you can deserialize Protobuf data from a kdb+ variable or a file.

:fontawesome-solid-hand-point-right:
[Function reference](reference.md), [example implementations](examples.md)


## Install Protobufkdb

:fontawesome-brands-github: 
[Installation guide](https://github.com/KxSystems/protobufkdb#installation)


## Status

The interface is currently available under an Apache 2.0 licence as a beta release and is supported on a best-efforts basis by the Fusion team. 
This interface is currently in active development, with additional functionality to be released on an ongoing basis.

:fontawesome-brands-github: 
[Issues and feature requests](https://github.com/KxSystems/protobufkdb/issues) 
<br>
:fontawesome-brands-github: 
[Guide to contributing](https://github.com/KxSystems/protobufkdb/blob/master/CONTRIBUTING.md)
