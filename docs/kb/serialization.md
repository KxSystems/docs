---
title: Serialization examples | Knowledge Base | kdb+ and q documentation
description: TCP/IP is used for communicating between processes. The protocol is extremely simple, as is the message format.
---
# :fontawesome-solid-handshake: Serialization examples



## Integer of value 1

```q
q)-8!1
0x010000000d000000fa01000000
```

bytes | semantics
------|-------------
0x01  | architecture used for encoding the message, big endian (0) or little endian (1)
00    | message type (0 – async, 1 – sync, 2 – response)
0000
0d000000 | msg length (13)
fa | type of item following (-6, meaning a 4-byte integer follows)
01000000 | the 4-byte int value (1)


## Integer vector

```q
q)-8!enlist 1
0x010000001200000006000100000001000000
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
12000000 | message length
06 | type (int vector)
00 | attributes (00 – none, 01 – `s`, 02 – `u`, 03 – `p`, 04 – `g`)
01000000 | vector length (1)
01000000 | the item, a 4 byte integer (1)


## Byte vector

```q
q)-8!`byte$til 5
0x01000000130000000400050000000001020304
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
13000000 | message length
04 | type (byte vector)
00 | attributes
05000000 | vector length (5)
0001020304 | the 5 bytes


## General list

```q
q)-8!`byte$enlist til 5
0x01000000190000000000010000000400050000000001020304
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
19000000 | message length
00 | type (list)
00 | attributes
01000000 | list length (1)
04 | type (byte vector)
00 | attributes
05000000 | vector length (5)
0001020304 | the 5 bytes

## Dictionary with atom values

```q
q)-8!`a`b!2 3
0x0100000021000000630b0002000000610062000600020000000200000003000000
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
21000000 | message length
63 | type (99 – dict)
0b | type (11 – symbol vector)
00 | attributes
02000000 | vector length
6100 | null terminated symbol (`` `a``)
6200 | null terminated symbol (`` `b``)
06 | type (6 – integer vector)
00 | attributes
02000000 | vector length
02000000 | 1st item (2)
03000000 | 2nd item (3)

## Sorted dictionary with atom values

```q
q)-8!`s#`a`b!2 3
0x01000000210000007f0b0102000000610062000600020000000200000003000000
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
21000000 | message length
7f | type (127 – sorted dict)
0b | type (11 – symbol vector)
01 | attributes (`` `s#``)
02000000 | vector length
6100 | null terminated symbol (`` `a``)
6200 | null terminated symbol (`` `b``)
06 | type (6 – integer vector)
00 | attributes
02000000 | vector length
02000000 | 1st item (2)
03000000 | 2nd item (3)


## Dictionary with vector values

```q
q)-8!`a`b!enlist each 2 3
0x010000002d000000630b0002000000610062000000020000000600010000000200000006000100000003000000
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
2d000000 | message length
63 | type (99 – dict)
0b | type (11 – symbol vector)
00 | attributes
02000000 | vector length (2)
6100 | null terminated symbol (`` `a``)
6200 | null terminated symbol (`` `b``)
00 | type (0 – list)
00 | attributes
02000000 | list length (2)
06 | type (6 – int vector)
00 | attributes
01000000 | vector length (1)
02000000 | 1st item (2)
06 | type (6 – int vector)
00 | attributes
01000000 | vector length (1)
03000000 | 1st item (3)

## Table

Note the relation to the previous example.

```q
q)-8!'(flip`a`b!enlist each 2 3;([]a:enlist 2;b:enlist 3))
0x010000002f0000006200630b0002000000610062000000020000000600010000000200000006000100000003000000
0x010000002f0000006200630b0002000000610062000000020000000600010000000200000006000100000003000000
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
2f000000 | message length
62 | type (98 – table)
00 | attributes
63 | type (99 – dict)
0b | type (11 – symbol vector)
00 | attributes
02000000 | vector length (2)
6100 | null terminated symbol (`` `a``)
6200 | null terminated symbol (`` `b``)
00 | type (0 – list)
00 | attributes
02000000 | list length (2)
06 | type (6 – int vector)
00 | attributes
01000000 | vector length (1)
02000000 | 1st item (2)
06 | type (6 – int vector)
00 | attributes
01000000 | vector length (1)
03000000 | 1st item (3)

## Sorted table

Note the relation to the previous example.

```q
q)-8!`s#([]a:enlist 2;b:enlist 3)
0x010000002f0000006201630b0002000000610062000000020000000603010000000200000006000100000003000000
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
2f000000 | message length
62 | type (98 – table)
01 | attributes (`` `s#``)
63 | type (99 – dict)
0b | type (11 – symbol vector)
00 | attributes
02000000 | vector length (2)
6100 | null terminated symbol (`` `a``)
6200 | null terminated symbol (`` `b``)
00 | type (0 – list)
00 | attributes
02000000 | list length (2)
06 | type (6 – int vector)
03 | attributes (`` `p#``)
01000000 | vector length (1)
02000000 | 1st item (2)
06 | type (6 – int vector)
00 | attributes
01000000 | vector length (1)
03000000 | 1st item (3)


## Keyed table

```q
q)-8!([a:enlist 2]b:enlist 3)
0x010000003f000000636200630b00010000006100000001000000060001000000020000006200630b0001000000620000000100000006000100000003000000
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
3f000000 | message length
63 | type (99 – dict)
62 | type (98 – table)
00 | attributes
63 | type (99 – dict)
0b | type (11 – symbol vector)
00 | attributes
01000000 | vector length (1)
6100 | null terminated symbol (`` `a``)
00 | type (0 – list)
00 | attributes
01000000 | vector length (1)
06 | type (6 – int vector)
00 | attributes
01000000 | vector length (1)
02000000 | 1st item (2)
62 | type (98 – table)
00 | attributes
63 | type (99 – dict)
0b | type (11 – symbol vector)
00 | attributes
01000000 | vector length (1)
6200 | null terminated symbol (`` `b``)
00 | type (0 – list)
00 | attributes
01000000 | vector length (1)
06 | type (6 – int vector)
00 | attributes
01000000 | vector length (1)
03000000 | 1st item (3)


## Sorted keyed table

Note the relation to the previous example.

```q
q)-8!`s#([a:enlist 2]b:enlist 3)
0x010000003f0000007f6201630b00010000006100000001000000060001000000020000006200630b0001000000620000000100000006000100000003000000
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
3f000000 | message length
7f | type (127 – sorted dict)
62 | type (98 – table)
01 | attributes (`` `s#``)
63 | type (99 – dict)
0b | type (11 – symbol vector)
00 | attributes
01000000 | vector length (1)
6100 | null terminated symbol (`` `a``)
00 | type (0 – list)
00 | attributes
01000000 | vector length (1)
06 | type (6 – int vector)
00 | attributes
01000000 | vector length (1)
02000000 | 1st item (2)
62 | type (98 – table)
00 | attributes
63 | type (99 – dict)
0b | type (11 – symbol vector)
00 | attributes
01000000 | vector length (1)
6200 | null terminated symbol (`` `b``)
00 | type (0 – list)
00 | attributes
01000000 | vector length (1)
06 | type (6 – int vector)
00 | attributes
01000000 | vector length (1)
03000000 | 1st item (3)


## Function

```q
q)-8!{x+y}
0x010000001500000064000a00050000007b782b797d
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
15000000 | message length
64 | type (100 – lamda)
00 | null terminated context (root)
0a | type (10 – char vector)
00 | attributes
05000000 | vector length
7b782b797d | {x+y}


## Function in a non-root context

```q
q)\d .d
q.d)test:{x+y}
q.d)-8!test
0x01000000160000006464000a00050000007b782b797d
```

bytes | semantics
------|-------------
0x01 | little endian
000000 | 
16000000 | message length
64 | type (100 – lambda)
6400 | null terminated context (`.d`)
0a | type (10 – char vector)
00 | attributes
05000000 | length (5)
7b782b797d | {x+y}


!!! note "Enumerations are automatically converted to values before sending through IPC."

----
:fontawesome-solid-book-open:
[Interprocess communication](../basics/ipc.md)

