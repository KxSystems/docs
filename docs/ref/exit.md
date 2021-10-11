---
title: exit – Reference – kdb+ and q documentation
description: exit is a control word that terminates a kdb+ process with a specified exit code.
author: Stephen Taylor
---
# `exit`




_Terminate kdb+_

```syntax
exit x    exit[x]
```

Control word. 
Where `x` is a positive integer, terminates the kdb+ process with `x` as the exit code.

```q
q)exit 0        / typical successful exit status
..

q)exit 42
```
```bash
$ echo $?
42
```

!!! warning "No confirmation is requested from the console."

Exit is blocked during [`reval`](eval.md#reval) or with [`-u` on the command line](../basics/cmdline.md#-u-disable-syscmds). (Since V4.1t 2021-07-12.)

----

:fontawesome-solid-book: 
[`.z.exit`](dotz.md#zexit-action-on-exit) (action on exit) 
<br>
:fontawesome-solid-book-open: 
[Controlling evaluation](../basics/control.md), 
[Debugging](../basics/debug.md)

