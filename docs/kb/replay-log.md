---
title: Replay a logfile with kdb+ | Knowledge Base | kdb+ and q documentation
description: How to replay a logfile in kdb+ with streaming execute
author: Stephen Taylor
date: Decemeber 2019
---
# Replaying log files



Streaming-execute over a file is used (for example in kdb+tick) to replay logfiles in a memory-efficient manner.

<i class="fas fa-book-open"></i>
[`-11!` streaming execute](../basics/internal.md#-11-streaming-execute)

A logfile is just a list of lists, and each list is read in turn and evaluated by [`.z.ps`](../ref/dotz.md#zps-set) (which defaults to [`value`](../ref/value.md)).

Here, for demonstration purposes, we manually create a logfile, and play it back through `-11!`. This is functionally equivalent to doing ``value each get `:logfile`` but uses far less memory.

```q
q)`:logfile.2013.12.03 set () / create a new,empty log file
`:logfile.2013.12.03
q)h:hopen `:logfile.2013.12.03 / open it
q)h enlist(`f;`a;10) / append a record
3i
q)h enlist(`f;`b;20) / append a record
3i
q)hclose h / close the file
q)/Define the function that is referenced in those records
q)f:{0N!(x;y)}
q)-11!`:logfile.2013.12.03 / playback the logfile
(`a;10)
(`b;20)
2
q)/ DO NOT DO THIS ON LARGE LOGFILES!!!!
q)/This is the whole purpose of -11!x.
q)value each get `:logfile.2013.12.03
(`a;10)
(`b;20)
`a 10
`b 20
```

If successful, the number of chunks executed is returned. If the end of the file is corrupt a `badtail` error is signalled. In the event that the log file references an undefined function, the function name is signalled as an error. This can be confusing if the missing function name is `upd`, as it does not reflect the same situation as the license expiry `upd` error. e.g.

```q
/ Continuing the above example
q)delete f from `.
`.
q)/function f no longer defined, so it signals an error
q)-11!`:logfile.2013.12.03
'f
```

<i class="fab fa-github"></i> [github.com/simongarland/tickrecover/rescuelog.q](https://github.com/simongarland/tickrecover/blob/master/rescuelog.q) for examples of usage



## Replay part of a file

Streaming-execute the first `n` chunks of logfile `x`, return the number of chunks if successful: `-11!(n;x)`.

It is possible to use the above to playback `n` records from record `M` onwards.

Firstly create a sample log file, which contains 1000 records as
`((`f;0);(`f;1);(`f;2);..;(`f;999))`.

```q
q)`:log set();h:hopen`:log;i:0;do[1000;h enlist(`f;i);i+:1];hclose h;
```

Then define function `f` to just print its arg, skip the first `M` records. If [`.z.ps`](../ref/dotz.md#zps-set) is defined, `-11!` calls it for each record.

```q
q)m:0;M:750;f:0N!;.z.ps:{m+:1;if[m>M;value x;];};-11!(M+5-1;`:log)
750
751
752
753
754
```


## Size of a logfile

Given a valid logfile `x`, `-11(-2;x)` returns the number of chunks.

Given an invalid logfile, returns the number of valid chunks and length of the valid part.

```q
q)logfile:`:good.log / a non-corrupted logfile
q)-11!(-2;logfile)
26
q)logfile:`:broken.log / a manually corrupted logfile
q)/define a dummy upd file as components are of the form (`upd;data)
q)upd:{[x;y]}
q)-11!logfile
'badtail
q)-11!(-1;logfile)
'badtail
q)hcount logfile
39623j
q)-11!(-2;logfile)
26
35634j
q)/ 26 valid chunks until position 35634 (out of 39623)
q)-11!(26;logfile)
26
```

