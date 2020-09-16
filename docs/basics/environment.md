---
title: Environment | Basics | kdb+ and q documentation
description: Environment variables in kdb+ and q keywords for getting and setting them. 
---
# Environment 



_Environment variables in the operating system, and q keywords for getting and setting them_

## Variables

Kdb+ refers to the following environment variables.

`QHOME` 

: folder searched for `q.k` and unqualified script names

: defaults to `$HOME/q` (LInux, macOS) or `C:\q` (Windows)

`QLIC` 

: folder searched for `k4.lic` or `kc.lic` license key file

: defaults to `QHOME`

`QINIT`

: additional file loaded after `q.k` has initialized, executed in the default namespace

: defaults to `$QHOME/q.q`.

`LINES`, `COLUMNS`

: used to set [`\c`](syscmds.md#c-console-size)

: default to 25 and 80


## Keywords

[`getenv`](../ref/getenv.md)

: Get the value of an environment variable

[`gtime`](../ref/gtime.md)

: UTC equivalent of local timestamp

[`ltime`](../ref/gtime.md#ltime)

: Local equivalent of UTC timestamp

[`setenv`](../ref/getenv.md#setenv)

: Set the value of an environment variable

----

:fontawesome-solid-hand-point-right: 
environment sections in namespaces
[`.Q`](../ref/dotq.md),
[`.z`](../ref/dotz.md) 
