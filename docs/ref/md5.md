---
title: md5
description: md5 is a q keyword that returns the Message Digest (MD5 hash) of a string.
author: Stephen Taylor
keywords: cryptography, hash, kdb+, md5, q, string
---
# `md5`

_Message Digest hash_



Syntax `md5 x`, `md5[x]` 

Returns the [MD5 (Message-Digest algorithm 5)](https://en.wikipedia.org/wiki/MD5) of string `x`. 

MD5 is a widely used, Internet standard (RFC 1321), hash function that computes a 128-bit hash, commonly used to check the integrity of files. It is not recommended for serious cryptographic protection, for which strong hashes should be used.
```q
q)md5 "this is a not so secret message"
0x6cf192c1938b79012c323fa30e62787e
```


<i class="far fa-hand-point-right"></i> 
Basics: [Strings](../basics/strings.md)