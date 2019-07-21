---
title: Authentication and access control
description: Q has built-in authentication via the -U and -u command line options. Access control is very flexible, through hooking the message interface .z.pg, .z.ps, and validating the input before execution.
keywords: access, authentication, control, kdb+, q
---
# Authentication and access control





Q has built-in authentication via the [`-U`](../basics/cmdline.md#-u-usr-pwd) and [`-u`](../basics/cmdline.md#-u-usr-pwd-local) command line options.

Access control is very flexible, through hooking the message interface [`.z.pg`](../ref/dotz.md#zpg-get "get"), [`.z.ps`](../ref/dotz.md#zps-set "set"), and validating the input before execution.

```q
q)allowedFns:(`func1;`func2;`func3;+;-) / list of allowed function/ops to call
q)checkFn:{if[not x in allowedFns;'(-3!x)," not allowed"];}
q)validatePT:{if[0h=t:type x;if[(not 0h=type first x)&1=count first x;checkFn first x;];.z.s each x where 0h=type each x;];}
q).z.pg:{if[10h=type x;x:parse x;];validatePT x;eval x}

q)checkFn[+]
q)checkFn[*]
'not allowed
q)validatePT parse"func1[2+3]"
```

Watch out: ticker plants, and other high-volume message sources such as feed handlers, will most likely be inserting data via `.z.ps`. To cater for such high volumes, the handles of those processes should be used to avoid the overhead of these validation checks. That is, feeds and tickerplants could be viewed as trusted processes.

Typically, client processes connect to a gateway, and execute canned functions on that gateway, which in turn issues queries to RDBS and HDBS, joining and returning data to the client. Hence the gateways can have open access, restricted by IP, user, and validation checks. RDBS/HDBS could then be closed access, restricted by IP address/user only.

This can easily be extended to group/role permissioning.

<i class="far fa-hand-point-right"></i> 
[Using `.z`](using-dotz.md) for some concrete examples, such as `controlaccess.q`
