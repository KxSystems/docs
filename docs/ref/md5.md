---
title: md5 – message Digest Algorithm 5 hash | Reference | kdb+ and q documentation
description: md5 is a q keyword that returns the Message Digest (MD5 hash) of a string.
author: Stephen Taylor
---
# `md5`

_Message Digest hash_


```txt
md5 x    md5[x]
```

Where `x` is a string, returns as a bytestream its [MD5 (Message-Digest algorithm 5)](https://en.wikipedia.org/wiki/MD5) hash.

```q
q)md5 "this is a not so secret message"
0x6cf192c1938b79012c323fa30e62787e
```

MD5 is a widely used, Internet standard (RFC 1321), hash function that computes a 128-bit hash, commonly used to check the integrity of files. It is not recommended for serious cryptographic protection, for which strong hashes should be used.


----

:fontawesome-solid-book-open:
[Strings](../basics/by-topic.md#strings)