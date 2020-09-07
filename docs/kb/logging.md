---
title: Logging, recovery and replication – Knowledge Base – kdb+ and q documentation
description: Software or hardware problems can cause a kdb+ server process to fail, possibly resulting in loss of data not saved to disk at the time of the failure. A kdb+ server can use logging of updates to avoid data loss when failures occur; note that the message is logged only if it changes the state of the process’ data.
keywords: kdb+, log, logging, q, replication
---
# Logging, recovery and replication





Software or hardware problems can cause a kdb+ server process to fail, possibly resulting in loss of data not saved to disk at the time of the failure. A kdb+ server can use logging of updates to avoid data loss when failures occur; note that the message is logged only if it changes the state of the process’ data.

Logging is enabled by using the [`-l` or `-L` command-line arguments](../basics/cmdline.md#-l-log-updates).

```bash
$ q logTest -l
```

```q
q)\p 5001
q)\l trade.q
```

Now update messages from clients are logged. For instance:

```q
q)/ this is a client
q)h: hopen `:localhost:5001
q)h "insert[`trade](10:30:01; `intel; 88.5; 1625)"
q)h "last trade"
time | 10:30:01.000
sym  | `intel
price| 88.5
size | 1625
```

Assume that the kdb+ server process dies. If we now restart it with logging on, the updates logged to disk are not lost:

```bash
$ q logTest -l
```

```q
q)last trade
time | 10:30:01.000
sym  | `intel
price| 88.5
size | 1625
```
??? warning "Updates done locally in the server process are logged to disk only if they are sent as messages to self"

    The syntax for this uses `0` as the handle:

    <pre><code class="language-q">
    q) // in server
    q)0 ("insert";\`trade; (10:30:01.000; \`intel; 88.5; 1625))
    </code></pre>


## Checkpointing

A logging server uses a `.log` file and a `.qdb` data file. The command

```q
q)\l
```

checkpoints the `.qdb` file and empties the log file.

However, the checkpoint is path-dependent. Consider the following:

```bash
/tmp/qtest$ q qtest -l
q)
```

A listing of the directory gives:

```bash
/tmp/qtest$ ls
qtest.log
```

Back in q:

```q
q)\l
```

yields

```bash
/tmp/qtest$ $ls
qtest.log
qtest.qdb
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
$/tmp/qtest$ q /tmp/testlog -l
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


## Files

When you type

```bash
$ q logTest -l
```

this reads the data file (`.qdb`), log file, and the q script file `logTest.q`, if present. If any of the three files exists (`.q`, `.qdb`, and `.log`), they should all be in the same directory.


## Logging options

The `-l` option is recommended if you trust (or duplicate) the machine where the server is running. The `-L` option involves an actual disk write (assuming hardware write-cache is disabled).

Another option is to use no logging. This is used with test, read-only, read-mostly, trusted, duplicated or cache databases.


## Errors and rollbacks

If either message handler (`.z.pg` or `.z.ps`) throws any error, and the state was changed during that message processing, this will cause a rollback.


## Replication

Given a logging q process listening on port 5000, e.g. started with

```bash
$ q test -l -p 5000
```

a single kdb+ process can replicate that logging process via

```bash
$ q -r :localhost:5000:username:password
```

if starting these processes from different directories, be sure to specify the absolute path for the logging process, e.g.

```bash
$ q /mylogs/test -l -p 5000
```

the replicating process will receive this information when it connects. 

On start-up, the replicating process connects to the logging process, gets the log filename and record count, opens the log file, plays back that count of records from the log file, and continues to receive updates via [TCP/IP](../basics/ipc.md). Each record is executed via `value`.

If the replicating process loses its connection to the logging process, you can detect that with `.z.pc`. To resubscribe to the logging process, restart the replicating process.

Currently, only a single replicating process can subscribe to the primary process. If another kdb+ process attempts to replicate from the primary, the previous replicating process will no longer receive updates. If you need multiple replicating processes, you might like to consider [kdb+tick](../learn/startingkdb/tick.md).


---

:fontawesome-solid-street-view:
_Q for Mortals_
[§13.2.6 Logging `-l` and `-L`](/q4m3/13_Commands_and_System_Variables/#1326-logging-l-and-l)
<br>
:fontawesome-brands-github: 
[prodrive11/log4q](https://github.com/prodrive11/log4q)
A concise implementation of logger for q applications