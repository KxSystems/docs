---
title: Logging, recovery and replication – Knowledge Base – kdb+ and q documentation
description: Software or hardware problems can cause a kdb+ server process to fail, possibly resulting in loss of data not saved to disk at the time of the failure. A kdb+ server can use logging of updates to avoid data loss when failures occur; note that the message is logged only if it changes the state of the process’ data.
keywords: kdb+, log, logging, q, replication, recovery
---
# Using log files: logging, recovery and replication

## Overview

Software or hardware problems can cause a kdb+ server process to fail, possibly resulting in loss of data if not saved to disk at the time of the failure. A kdb+ server can use logging updates to avoid data loss when failures occur.

!!! warning "This should not be confused with a file that logs human readable warnings, errors, etc. It refers to a log of instructions to regain state."

## Automatic handling

### Overview

The automatic log file creation requires little developer work, but without the advantages of the finer level of control that [manual log creation](#manual-handling) provides.

Automatic logging captures a message only if it changes the state of the process’ data.

### Creating a log file

!!! detail "Applies only to globals in the default namespace"

    This is not triggered for function-local variables, nor globals that are not in the default namespace, e.g. those prefixed with a dot such as `.a.b`.

    This is the same restriction that applies to [`.z.vs`](../ref/dotz.md#zvs-value-set).

Logging is enabled by using the [`-l`](../basics/cmdline.md#-l-log-updates) or [`-L`](../basics/cmdline.md#-l-log-sync) command-line arguments.

This example requires a file `trade.q` containing instructions to create a trade table:
```q
trade:([]time:`time$();sym:`symbol$();price:`float$();size:`int$())
```

Start kdb+, loading `trade.q` while enabling recording to `trade.log` (note: this also uses `-p 5001` to allow client connections to port 5001):

```bash
$ q trade -l -p 5001
```

Now update messages from clients are logged. For instance:

```q
q)/ this is a client
q)h:hopen `:localhost:5001
q)h "insert[`trade](10:30:01.000; `intel; 88.5; 1625)"
```

In the server instance, run `count trade` to check the trade table is now populated with one row.
Assume that the kdb+ server process dies. If we now restart it with logging on, the updates logged to disk are not lost:

```q
q)count trade
1
```

!!! warning "Updates done locally in the server process are logged to disk only if they are sent as messages to self"

    The syntax for this uses `0` as the handle:

    ```q
    // in server
    0 ("insert";`trade; (10:30:01.000; `intel; 88.5; 1625))
    ```


### Check-pointing / rolling

A logging server uses a `.log` file and a `.qdb` data file. The command [`\l`](../basics/syscmds.md#l-load-file-or-directory) checkpoints the `.qdb` file and empties the log file.

However, the checkpoint is path-dependent. Consider the following:

```bash
/tmp/qtest$ q qtest -l
q)
```

A listing of the current directory gives:

```bash
q)\ls
"qtest.log"
```

The system command `\l` can be used to roll the log file. 
The current log file will be renamed with the `qdb` extension and a new log file will be created.

```q
q)\l
q)\ls
"qtest.log"
"qtest.qdb"
```

However, if there is a change of directory within the q session then the `*.qdb` checkpoint file is placed in the latter directory. For instance:

```bash
/tmp/qtest$ q qtest -l
```

```q
q)\cd ../newqdir
q)\l
```

results in

```bash
/tmp/qtest$ ls
qtest.log
/tmp/qtest$ cd ../newqdir
/tmp/newqdir$ ls
qtest.qdb
```

The simplest solution is to provide a full path to the log file at invocation.

```bash
/tmp/qtest$ q /tmp/testlog -l
```

```q
q).z.f
/tmp/testlog
q)\cd ../newqdir
q)\l
```

results in

```bash
/tmp/qtest$ ls
. testlog.log testlog.qdb
/tmp/qtest$ ls ../newqdir
.
```


### File read order

When you type

```bash
q logTest -l
```

this reads the data file (`.qdb`), log file, and the q script file `logTest.q`, if present. If any of the three files exists (`.q`, `.qdb`, and `.log`), they should all be in the same directory.


### Logging options

The [`-l`](../basics/cmdline.md#-l-log-updates) option is recommended if you trust (or duplicate) the machine where the server is running. The [`-L`](../basics/cmdline.md#-l-log-sync) option involves an actual disk write (assuming hardware write-cache is disabled).

Another option is to use no logging. This is used with test, read-only, read-mostly, trusted, duplicated or cache databases.


### Errors and rollbacks

If either message handler ([`.z.pg`](../ref/dotz.md#zpg-get) or [`.z.ps`](../ref/dotz.md#zps-set)) throws any error, and the state was changed during that message processing, this will cause a rollback.


### Replication

Given a logging q process listening on port 5000, e.g. started with

```bash
q test -l -p 5000
```

an additional kdb+ process can replicate that logging process via the [`-r`](../basics/cmdline.md#-r-replicate) command line parameter

```bash
q -r :localhost:5000:username:password
```

if starting these processes from different directories, be sure to specify the absolute path for the logging process, e.g.

```bash
q /mylogs/test -l -p 5000
```

the replicating process will receive this information when it connects. 

On start-up, the replicating process connects to the logging process, gets the log filename and record count, opens the log file, plays back that count of records from the log file, and continues to receive updates via [TCP/IP](../basics/ipc.md). Each record is executed via `value`.

If the replicating process loses its connection to the logging process, you can detect that with [`.z.pc`](../ref/dotz.md#zpc-close). To resubscribe to the logging process, restart the replicating process.

Currently, only a single replicating process can subscribe to the primary process. If another kdb+ process attempts to replicate from the primary, the previous replicating process will no longer receive updates. If you need multiple replicating processes, you might like to consider [kdb+tick](../learn/startingkdb/tick.md).


## Manual handling

### Overview

Function calls and the contents of the their parameters can be recorded to a log file, which can then be replayed by a process. This is often used for data recovery.

This technique is often used to allow a developer more control over log file naming conventions, what to log, log file locations and the ability to add logic around the log file lifecycle.

### Creating a log file

A log file can be initialized using [`set`](../ref/get.md#set).

```q
q)logfile:hsym `$"qlog";
q)logfile set ();
q)logfilehandle:hopen logfile;
```

!!!note "`logfile set ();` is equivalent to `.[logfile;();:;()];`"

A check for a pre-existing log file can be achieved using [`get`](../ref/get.md#get). 
The script can now be written to initialize a new log file if it does not exist, otherwise it will opened for appending.

```q
q)logfile:hsym `$"qlog";
q)if[not type key logfile;logfile set()]
q)logfilehandle:hopen logfile;
```

Close the log file when finished logging any messages.

```q
q)hclose logfilehandle
```

### Log writting

To record events/messages to a log, append a list consisting of a function name followed by any parameters used. 

A tickerplant uses this concept to record all messages sent to its clients so they can use the log to recover. It records calling a function `upd` passing the parameters of a table name and the table content to append.

For example, calling a function called `upd` with two parameters, x and y, can be recorded to a file file as follows:
```q
q)logfilehandle enlist (`upd;x;y)
```
When a kdb+ process plays back this log, a function called `upd` is called with the value of the two parameters. Multiple function calls can be logged also:

```q
q)logfilehandle ((`func1;param1);(`func2;param1;param2))
```

As [log replay](#replaying-log-files) calls [`value`](../ref/value.md) to execute, you can also log q code as a string, for example

```q
logfilehandle enlist "upd[22;33]"
```

Function calls that are used to updating data are typically written, without logging the function definition. 
This has the disadvantage of requiring that the recoverying process defines the functions (e.g. by loading a q script) prior to replaying the log. 
The advantages can outweight the disadvantages by allowing for bugs fixes within the function or temporarily assigning the function to a different definition prior to playback, 
to provide despoke logic for data sourced from a log file.

### Log rolling

A kdb+ process can run 24/7, but a log file may only be relevant for a specific timeframe or event. 
For example, the default tickerplant creates a new log for each day. 
You should ensure the current log is closed and a new log created on each event. 
A decision must be taken on whether to retain the old files or delete them, taking into account disk usage and what other processes may require them.

A naming convention should be used to aid distinction between current log files and any old log files required for retention.
The [`z`](../ref/dotz.md) namespace provides various functions for system information such as current date, time, etc. 
The below example demonstrates naming a log file after the current date:
```q
q)logfile:hsym `$"qlog_",string .z.D;
```

## Replaying log files

Streaming-execute over a file is used (for example in kdb+tick) to replay a log file in a memory-efficient manner.

:fontawesome-solid-book-open:
[`-11!` streaming execute](../basics/internal.md#-11-streaming-execute)

A logfile is essentially a list of lists and each list is read in turn and evaluated by [`.z.ps`](../ref/dotz.md#zps-set) (which defaults to [`value`](../ref/value.md)).

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

If successful, the number of chunks executed is returned. 

If the end of the file is corrupt, a `badtail` error is signalled, which may be partially [recovered](#replay-from-corrupt-logs).

In the event that the log file references an undefined function, the function name is signalled as an error. This can be confusing if the missing function name is `upd`, as it does not reflect the same situation as the license expiry `upd` error. For example:.

```q
/ Continuing the above example
q)delete f from `.
`.
q)/function f no longer defined, so it signals an error
q)-11!`:logfile.2013.12.03
'f
```


### Replay part of a file

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


### Replay from corrupt logs

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
39623
q)-11!(-2;logfile)
26
35634
q)/ 26 valid chunks until position 35634 (out of 39623)
q)-11!(26;logfile)
26
```

### Replacing a corrupt log

It can be  more efficient to [replay from a corrupt file](##replay-from-corrupt-logs) (due to disk usage), than to directly take the good chunks from a bad log to create a new log.

The knowledge of how to create a log file, and how to replay part of a log file can be combined to convert a file that was previously giving the `badtail` error.
Note that this does not fix the corrupted section, only removes the corrupted section from the file.

The following example shows converting a `bad.log` into a `good.log` by temporarly overriding [`.z.ps`](../ref/dotz.md#zps-set) which is called for each valid chunk (as defined by [`-11!`](../basics/internal.md#-11-streaming-execute)). 
It resets `.z.ts` to the system default after processing using [`\x`](../basics/syscmds/#x-expunge).

```q
goodfile:hsym `:good.log;
goodfile set ();
goodfilehandle:hopen goodfile;

chunks:first -11!(-2;`:bad.log);

.z.ps:{goodfilehandle enlist x};
-11!(chunks;`:bad.log);
system"x .z.ps";

hclose goodfilehandle;
```

Alternatively, generic system tools can be used like the unix `head` command. For example, given that ``-11!(-2;`:bad.log)`` returns 2879 bytes.
```bash
head -c 2879 bad.log > good.log
```

:fontawesome-brands-github: [github.com/simongarland/tickrecover/rescuelog.q](https://github.com/simongarland/tickrecover/blob/master/rescuelog.q) contains some helper functions for recovering data from logs.

---

:fontawesome-solid-street-view:
_Q for Mortals_
[§13.2.6 Logging `-l` and `-L`](/q4m3/13_Commands_and_System_Variables/#1326-logging-l-and-l)
<br>
:fontawesome-brands-github: 
[prodrive11/log4q](https://github.com/prodrive11/log4q)
A concise implementation of logger for q applications

