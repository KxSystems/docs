---
title: Environment
keywords: environment, kdb+, q, variable
---

# Environment 




Kdb+ refers to the following environment variables.

`QHOME` 

: `$HOME` folder searched for `q.k` and unqualified script names

`QLIC` 

: `$HOME` folder searched for `k4.lic` or `kc.lic` license key file

`QINIT`

: `q.q` additional file loaded after `q.k` has initialised

`LINES`, `COLUMNS`

: supplied by OS, used to set [`\c`](syscmds.md#c-console-size)

<i class="far fa-hand-point-right"></i> 
[`.Q` namespace](../ref/dotq.md),
[`.z` namespace](../ref/dotz.md) 
for other environment values
