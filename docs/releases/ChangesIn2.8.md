---
title: Changes in 2.8
description: Changes to V2.8 of kdb+ from the previous version
author: Charles Skelton
---
# Changes in 2.8



Below is a summary of changes from V2.7. Commercially licensed users may obtain the detailed change list / release notes from (http://downloads.kx.com)


## Production release date

2011.11.21


## Streaming File Compression

Built-in file compression was added in V2.7, however the compression required that the file existed on disk before it could compress it. This is enhanced in V2.8 which allows files to be compressed as they are written. This is achieved through the overriding of "set", in that the LHS target of set can be a list describing the file or splay target, with the compression parameters. For example

```q
(`:ztest;17;2;6) set asc 10000?`3
(`:zsplay/;17;2;6) set .Q.en[`:.;([]sym:asc 10000?`3;time:.z.p+til 10000;price:10000?1000.;size:10000?100)]
```

Kdb+ compressed files/splays can also be appended to. e.g.

```q
q)(`:zippedTest;17;2;6) set 100000?10;`:zippedTest upsert 100000?10;-21!`:zippedTest
```

'compress new files' mode – active if `.z.zd` (ZIP defaults) present and valid. `.z.zd` can be set to an int vector of `(blockSize;algo;zipLevel)` to apply to all new files which do not have a file extension. .e.g

```q
q).z.zd:(17;2;6);`:zfile set asc 10000?`3
```

`-19!x` and ``(`:file;size;algo;level) set x`` take precedence over `.z.zd`

To reset to not compress new files, use `\x`, e.g.
```q
q)\x .z.zd
```

## Mac OSX multithreaded

OSX build now supports multithreaded modes (slave threads, `peach`, multithreaded input)

## Improved MMU performance

e.g.

```q
q)\t x$flip x:380 70000#1.0
```
