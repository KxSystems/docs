---
title: Environment
description: Environment variables in kdb+ and q keywords for getting and setting them. 
keywords: environment, kdb+, q, variable
---
# Environment 



Environment variables in kdb+ and q keywords for getting and setting them. 

## Variables

Kdb+ refers to the following environment variables.

`QHOME` 

: `$HOME` folder searched for `q.k` and unqualified script names

`QLIC` 

: `$HOME` folder searched for `k4.lic` or `kc.lic` license key file

`QINIT`

: `q.q` additional file loaded after `q.k` has initialised

`LINES`, `COLUMNS`

: supplied by OS, used to set [`\c`](syscmds.md#c-console-size)


## Keywords

[`getenv`](../ref/getenv.md)

: Get the value of an environment variable

[`gtime`](../ref/gtime.md)

: UTC equivalent of local timestamp

[`ltime`](../ref/gtime.md#ltime)

: Local equivalent of UTC timestamp

[`setenv`](../ref/getenv.md#setenv)

: Set the value of an environment variable



<i class="far fa-hand-point-right"></i> 
environment sections in namespaces
[`.Q`](../ref/dotq.md),
[`.z`](../ref/dotz.md) 
