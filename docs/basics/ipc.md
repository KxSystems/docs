---
title: Interprocess communication
description: TCP/IP is used for communicating between processes. The protocol is extremely simple, as is the message format.
keywords: communication, interprocess, ipc, kdb+, message, process, protocol, q
---
# Interprocess communication




<i class="far fa-hand-point-right"></i>
Knowledge Base: [Interprocess communications](../kb/ipc.md)

TCP/IP is used for communicating between processes. The protocol is extremely simple, as is the message format. 

!!! tip "TCP/IP message format" 

    One can see what a TCP/IP message looks like by using `-8!object`, which generates the byte vector for the serialization of the object.

    This information is provided for debugging and troubleshooting only.


## Handshake

After a client has opened a socket to the server, it sends a null-terminated ASCII string `"username:password\N"` where `\N` is a single byte (0…3) which represents the client’s capability with respect to compression, timestamp|timespan and UUID, e.g. `"myname:mypassword\3"`. 
(Since 2012.05.29.) 

- If the server rejects the credentials, it closes the connection immediately. 
- If the server accepts the credentials, it sends a single-byte response which represents the common capability. 

Kdb+ recognizes these capability bytes:

- `0`: (V2.5) no compression, no timestamp, no timespan, no UUID
- `1..2`: (V2.6-2.8) compression, timestamp, timespan
- `3`: (V3.0) compression, timestamp, timespan, UUID


## Compression

For releases since 2012.05.29, kdb+ and the C-API will compress an outgoing message if

- Uncompressed serialized data has a length greater than 2000 bytes
- Connection is not `localhost`
- Size of compressed data is less than &frac12; the size of uncompressed data

The compression/decompression algorithms are proprietary and implemented as the `z` and `u` methods in `c.java`. The message validator does not validate the integrity of compressed messages.


## Serialization examples

### Integer of value 1

```q
q)-8!1
0x010000000d000000fa01000000
```
We can break this down as

- `0x01`: architecture used for encoding the message, big endian (0) or little endian (1)
- `00`: message type (0 – async, 1 – sync, 2 – response)
- `0000`
- `0d000000`: msg length (13)
- `fa`: type of item following (-6, meaning a 4-byte integer follows)
- `01000000`: the 4-byte int value (1)


### Integer vector

```q
q)-8!enlist 1
0x010000001200000006000100000001000000
```

- `0x01`: little endian
- `000000`
- `12000000`: message length
- `06`: type (int vector)
- `00`: attributes (00 – none, 01 – `s`, 02 – `u`, 03 – `p`, 04 – `g`)
- `01000000`: vector length (1)
- `01000000`: the item, a 4 byte integer (1)


### Byte vector

```q
q)-8!`byte$til 5
0x01000000130000000400050000000001020304
```

- `0x01`: little endian
- `000000`
- `13000000`: message length
- `04`: type (byte vector)
- `00`: attributes
- `05000000`: vector length (5)
- `0001020304`: the 5 bytes


### General list

```q
q)-8!`byte$enlist til 5
0x01000000190000000000010000000400050000000001020304
```

- `0x01`: little endian
- `000000`
- `19000000`: message length
- `00`: type (list)
- `00`: attributes
- `01000000`: list length (1)
- `04`: type (byte vector)
- `00`: attributes
- `05000000`: vector length (5)
- `0001020304`: the 5 bytes

### Dictionary with atom values

```q
q)-8!`a`b!2 3
0x0100000021000000630b0002000000610062000600020000000200000003000000
```

- `0x01`: little endian
- `000000`
- `21000000`: message length
- `63`: type (99 – dict)
- `0b`: type (11 – symbol vector)
- `00`: attributes
- `02000000`: vector length
- `6100`: null terminated symbol (`` `a ``)
- `6200`: null terminated symbol (`` `b ``)
- `06`: type (6 – integer vector)
- `00`: attributes
- `02000000`: vector length
- `02000000`: 1st item (2)
- `03000000`: 2nd item (3)

### Sorted dictionary with atom values

```q
q)-8!`s#`a`b!2 3
0x01000000210000007f0b0102000000610062000600020000000200000003000000
```

- `0x01`: little endian
- `000000`
- `21000000`: message length
- `7f`: type (127 – sorted dict)
- `0b`: type (11 – symbol vector)
- `01`: attributes (`` `s# ``)
- `02000000`: vector length
- `6100`: null terminated symbol (`` `a ``)
- `6200`: null terminated symbol (`` `b ``)
- `06`: type (6 – integer vector)
- `00`: attributes
- `02000000`: vector length
- `02000000`: 1st item (2)
- `03000000`: 2nd item (3)


### Dictionary with vector values

```q
q)-8!`a`b!enlist each 2 3
0x010000002d000000630b0002000000610062000000020000000600010000000200000006000100000003000000
```

- `0x01`: little endian
- `000000`
- `2d000000`: message length
- `63`: type (99 – dict)
- `0b`: type (11 – symbol vector)
- `00`: attributes
- `02000000`: vector length (2)
- `6100`: null terminated symbol (`` `a ``)
- `6200`: null terminated symbol (`` `b ``)
- `00`: type (0 – list)
- `00`: attributes
- `02000000`: list length (2)
- `06`: type (6 – int vector)
- `00`: attributes
- `01000000`: vector length (1)
- `02000000`: 1st item (2)
- `06`: type (6 – int vector)
- `00`: attributes
- `01000000`: vector length (1)
- `03000000`: 1st item (3)

### Table

Note the relation to the previous example.

```q
q)-8!'(flip`a`b!enlist each 2 3;([]a:enlist 2;b:enlist 3))
0x010000002f0000006200630b0002000000610062000000020000000600010000000200000006000100000003000000
0x010000002f0000006200630b0002000000610062000000020000000600010000000200000006000100000003000000
```

- `0x01`: little endian
- `000000`
- `2f000000`: message length
- `62`: type (98 – table)
- `00`: attributes
- `63`: type (99 – dict)
- `0b`: type (11 – symbol vector)
- `00`: attributes
- `02000000`: vector length (2)
- `6100`: null terminated symbol (`` `a ``)
- `6200`: null terminated symbol (`` `b ``)
- `00`: type (0 – list)
- `00`: attributes
- `02000000`: list length (2)
- `06`: type (6 – int vector)
- `00`: attributes
- `01000000`: vector length (1)
- `02000000`: 1st item (2)
- `06`: type (6 – int vector)
- `00`: attributes
- `01000000`: vector length (1)
- `03000000`: 1st item (3)

### Sorted table

Note the relation to the previous example.

```q
q)-8!`s#([]a:enlist 2;b:enlist 3)
0x010000002f0000006201630b0002000000610062000000020000000603010000000200000006000100000003000000
```

- `0x01`: little endian
- `000000`
- `2f000000`: message length
- `62`: type (98 – table)
- `01`: attributes (`` `s# ``)
- `63`: type (99 – dict)
- `0b`: type (11 – symbol vector)
- `00`: attributes
- `02000000`: vector length (2)
- `6100`: null terminated symbol (`` `a ``)
- `6200`: null terminated symbol (`` `b ``)
- `00`: type (0 – list)
- `00`: attributes
- `02000000`: list length (2)
- `06`: type (6 – int vector)
- `03`: attributes (`` `p# ``)
- `01000000`: vector length (1)
- `02000000`: 1st item (2)
- `06`: type (6 – int vector)
- `00`: attributes
- `01000000`: vector length (1)
- `03000000`: 1st item (3)


### Keyed table

```q
q)-8!([a:enlist 2]b:enlist 3)
0x010000003f000000636200630b00010000006100000001000000060001000000020000006200630b0001000000620000000100000006000100000003000000
```

- `0x01`: little endian
- `000000`
- `3f000000`: message length
- `63`: type (99 – dict)
- `62`: type (98 – table)
- `00`: attributes
- `63`: type (99 – dict)
- `0b`: type (11 – symbol vector)
- `00`: attributes
- `01000000`: vector length (1)
- `6100`: null terminated symbol (`` `a ``)
- `00`: type (0 – list)
- `00`: attributes
- `01000000`: vector length (1)
- `06`: type (6 – int vector)
- `00`: attributes
- `01000000`: vector length (1)
- `02000000`: 1st item (2)
- `62`: type (98 – table)
- `00`: attributes
- `63`: type (99 – dict)
- `0b`: type (11 – symbol vector)
- `00`: attributes
- `01000000`: vector length (1)
- `6200`: null terminated symbol (`` `b ``)
- `00`: type (0 – list)
- `00`: attributes
- `01000000`: vector length (1)
- `06`: type (6 – int vector)
- `00`: attributes
- `01000000`: vector length (1)
- `03000000`: 1st item (3)


### Sorted keyed table

Note the relation to the previous example.

```q
q)-8!`s#([a:enlist 2]b:enlist 3)
0x010000003f0000007f6201630b00010000006100000001000000060001000000020000006200630b0001000000620000000100000006000100000003000000
```

- `0x01`: little endian
- `000000`
- `3f000000`: message length
- `7f`: type (127 – sorted dict)
- `62`: type (98 – table)
- `01`: attributes (`` `s# ``)
- `63`: type (99 – dict)
- `0b`: type (11 – symbol vector)
- `00`: attributes
- `01000000`: vector length (1)
- `6100`: null terminated symbol (`` `a ``)
- `00`: type (0 – list)
- `00`: attributes
- `01000000`: vector length (1)
- `06`: type (6 – int vector)
- `00`: attributes
- `01000000`: vector length (1)
- `02000000`: 1st item (2)
- `62`: type (98 – table)
- `00`: attributes
- `63`: type (99 – dict)
- `0b`: type (11 – symbol vector)
- `00`: attributes
- `01000000`: vector length (1)
- `6200`: null terminated symbol (`` `b ``)
- `00`: type (0 – list)
- `00`: attributes
- `01000000`: vector length (1)
- `06`: type (6 – int vector)
- `00`: attributes
- `01000000`: vector length (1)
- `03000000`: 1st item (3)


### Function

```q
q)-8!{x+y}
0x010000001500000064000a00050000007b782b797d
```

- `0x01`: little endian
- `000000`
- `15000000`: message length
- `64`: type (100 – lamda)
- `00`: null terminated context (root)
- `0a`: type (10 – char vector)
- `00`: attributes
- `05000000`: vector length
- `7b782b797d`: {x+y}


### Function in a non-root context

```q
q)\d .d
q.d)test:{x+y}
q.d)-8!test
0x01000000160000006464000a00050000007b782b797d
```

- `0x01`: little endian
- `000000`
- `16000000`: message length
- `64`: type (100 – lambda)
- `6400`: null terminated context (.d)
- `0a`: type (10 – char vector)
- `00`: attributes
- `05000000`: length (5)
- `7b782b797d`: {x+y}


## Notes

1.  <i class="fab fa-github"></i> [KxSystems/kdb/c/kx/c.java](https://github.com/KxSystems/kdb/blob/master/c/kx/c.java), <i class="fab fa-github"></i> [KxSystems/kdb/c/c.cs](https://github.com/KxSystems/kdb/blob/master/c/c.cs) etc., are simply (de)serializers for these structures. 

1.  Enumerations are automatically converted to values before sending through IPC.

<i class="far fa-hand-point-right"></i> 
[`.h` namespace](../ref/doth.md) for markup,  
[`.z` namespace](../ref/dotz.md) for callback functions,   
[`.Q.addr`](../ref/dotq.md#qaddr-ip-address) (IP address),  
[`.Q.hg`](../ref/dotq.md#qhg-http-get) (HTTP get),  
[`.Q.host`](../ref/dotq.md#qhost-hostname) (hostname),  
[`.Q.hp`](../ref/dotq.md#qhp-http-post) (HTTP post)




