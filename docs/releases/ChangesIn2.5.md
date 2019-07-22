---
title: Changes in 2.5
description: Changes to V2.5 of kdb+ from the previous version
author: Charles Skelton
---
# Changes in 2.5



Below is a summary of changes from V2.4. Commercially licensed users may obtain the detailed change list / release notes from (http://downloads.kx.com)


## Production release date

2008.12.15

## `.z.W`

New feature in 2.5 2008.12.31

`.z.W` returns a dictionary of IPC handles with the number of bytes waiting in their output queues.

e.g.
```q
q)h:hopen ...
q)h
4
q)(neg h)({};til 1000000);.z.W
4| 4000030
q).z.W
4| 0
```

## Changes to casting

`` `$"" `` is a single

`` `$() `` is a list (in 2.4 it was a single)

e.g.

in 2.4

```q
q)`something ^ `$.z.x 0
`something
```

in 2.5

```q
q)`something ^ `$.z.x 0
`symbol$()
```

overcome change with e.g.

```q
(`$.z.x)0
```
