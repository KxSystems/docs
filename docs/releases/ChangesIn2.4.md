---
title: New features in the 2.4 release of kdb+ – Releases – kdb+ and q documentation
description: New features in the 2.4 release of kdb+
author: Charles Skelton
---
# New features in the 2.4 release of kdb+





**Detailed change list / release notes**
Commercially licensed users may obtain the detailed change list / release notes from <http://kxdownloads.com>

## General info

This release builds on the existing V2.3. The non upward-compatible changes (NUC) are the change to `.z.ph` (which only impacts people who've written their own HTTP handler), the additional `.z.pc` close event when closing stdin, and the removal of the `hopen` shortcut of just ``hopen`:port``. All other code should run without change.


## Multi-threaded input

Although 2.3 used multithreading to farm out queries to multiple partitions using the number of threads set via the `-s` parameter, the input queue was still single-threaded. In 2.4 it is possible to multithread that queue as well. Starting a kdb+ task with a positive `-p` parameter like before preserves the single-threaded behavior.

```q
q .. -p 5001 / single-threaded input queue as before
```

if, however a negative port number is given the input queue is multithreaded

```q
q .. -p -5001 / multithreaded input queue
```

The number of secondary processes set with `-s` are still dedicated to running queries over the partitions in parallel. However the number of threads used to handle the input queue is not user-settable. For now, each query gets an own thread – later it is probably going to change to a pool of threads, one per CPU.

## `hopen`

The shortcut syntax of `` hopen`:port`` has been removed, with 2.4 the host section must also be provided. The hostname can be elided, but the colon must be there.

```q
hopen`:localhost:5001 / ok
hopen`::5001 /ok
hopen`:5001 / NOT ok, it will have opened a file handle to file "5001"!
```

The alternative shortcut of supplying solely the (integer) portnumber is still valid.

```q
hopen 5001 / open port 5001 on local machine
```


## `.z.pw`

`z.pw` adds an extra callback when a connection is being opened to a kdb+ session.

Previously userid and password were checked if a userid:password file had been specified with the `-u` or `-U` parameter. The checking happened outside of the user's session in the q executable. Only if that check was passed did the connect get created and a handle passed into the "user space" as a parameter to `.z.po`.

Now after the `-u` or `-U` check has been done (if specified on the command line) the userid and password are passed to `.z.pw` allowing a function to be run to perform custom validation – for example to check aganst an LDAP server. If `.z.pw` returns a `1b` the login can proceed and the next stop will be `.z.po`, if it returns a `0b` the user attempting to open the connection will get an access error.

## `.z.pi`

`.z.pi` has been extended to handle console input as well as remote client input (like with qcon). This allows validating console input, or replacing the default display (`.Q.s value x`) with a home-knitted version.

to get the old (2.3 and earlier) display reset `.z.pi`

```q
.z.pi:{0N!value x;}
```

to return to the default display execute `\x .z.pi`


## `.z.pc`

In addition to the close events previously handled `.z.pc` is now also called when stdin is "closed" by redirecting it to `/dev/null`. In this case the handle provided to `.z.pc` will be 0 (the current console)

## `\x`

By default, callbacks like `.z.po` are not defined in the session, which makes it awkward to revert to the default behavior after modifying them – for example when debugging or tracing. `\x` allows deleting their definitions to force default behavior.

## `.Q` `.q` visibility

In 2.3 the display of the definitions of functions in `.q` and `.Q` was supressed. People complained… so the display is back.

## `.z.ts` delay
-----------

Before 2.4 the timer event would next happen _n_ milliseconds after completion of the execution of the timer's code. In 2.4 the event fires every _n_ milliseconds.

## `.z.i`

Process PID

## `.z.t`, `.z.d`

Shorthand for `` `time$.z.z``, similarly `.z.d` &lt;–&gt; `` `date$.z.z ``, `.z.T` &lt;–&gt; `` `time$.z.Z ``, `.z.D` &lt;–&gt; `` `date$.z.Z ``

## 1066 and all that

The valid year range has been expanded to 1710-2290

## `\b`, `\B` and `.z.b`

Extended support for tracking dependencies.

`\b` lists all dependencies (views)

`\B` lists all dependencies that have been invalidated

`.z.b` lists dependencies and the values they depend on

```q
q)a
11
q)b
12 13 14
q)a:99
q)b
100 101 102
q)\b
,`b
q)\B
`symbol$()
q)a:22
q)\B
,`b
q)b
23 24 25
q)\B
`symbol$()
q).z.b
a| b
q)
```

## `-11!`file

`-11!` (used to replay logfiles) has been made more robust when dealing with corrupt files.

Previously it would have crashed and exited on encountering corrupt records, now it will truncate the file to remove the invalid records and only process valid items.

Rather than the individual cells being executed directly `.z.ps` is called on each allowing easier customisation of log loaders.

## `inetd`

Run a kdb+ server under `inetd`, see Knowledge Base: [inetd/xinetd](../kb/inetd.md)

## `-b`

Block client access to a kdb+ database. The ability to write directly to disk allows an incorrectly written query to create havoc with a database. If the kdb+ server is started with the `-b` flag, all client writes are disabled.

Note: this functionality was incorrectly assigned to the `-z` startup parameter for a while during the 2.4 test cycle


## `-q`

Start up kdb+ in quiet mode – don't display the startup banner and license information.

Makes it easier to process the output from a q session if redirecting it as part of a larger application


## `\1` filename & `\2` filename

`\1` and `\2` allow redirecting stdin and stdout to files from within the q session. The filename and any intermediate directories are created if needed

## clients `\a` `\f` `\w` `\b`

When the `-u` or `-U` client restrictions are in place the list of valid commands for a client has been reduced to `\a`, `\f`, `\w` and `\b.`


## Maintain group attribute for append and update

The `` `g# `` attribute is maintained in places where in 2.3 it would have been cleared.

```q
n:100000
/ this has .5% change of sym
x:+(n?100*n;n?`3;n?100)
/id sym size
t:([o:`u#!0]s:`g#0#`;z:0)
\t .[`t;();,;]'x
```


## `` `s# `` validated

Before 2.4 the data being "decorated" with the `` `s# `` flag was not validated – so it was possible to flag as sorted a list that actually wasn't – causing problems when using primitives that depend on order like `bin`. Now an error will be signalled if data is incorrectly flagged.

```q
q)`s#1 2 3
`s#1 2 3
q)`s#1 2 3 3
`s#1 2 3 3
q)`s#1 2 3 3 2
'fail
q)
```

In the case of tables it just checks the first column.


## Month, year and int partition columns all virtual

Before 2.4 only the date column in a database partitioned by date was virtual. With 2.4 the year, month or int columns in databases partitioned by year, month or int respectively are treated the same way

## Repeated partitions

With 2.4 it is possible to have the same named partition on multiple partitions (as defined in `par.txt`) allowing, for example, splitting symbols by A-M on drive0, N-Z on drive1. Aggregations are handled correctly.

## Skip leading `#!`

When loading a script file that starts with `#!`, the first line is skipped.


## `\c` automated

On OSs that support it the values passed to `\c` (console width and height) are taken from the system variables `$LINES` and `$COLUMNS`


## No limit on stdin

Before 2.4 there was a limit of 999 characters on stdin/console – with 2.4 there is no limit


## mlim and glim increased to 1024

The maximum number of simultaneously mapped nested columns (**mlim**) and the maximum number of active `` `g# `` indices (**glim**) have been increased to 1024. 


## `mcount` and friends null-aware

Windowed functions like `mcount`, `mavg` have been made consistently aware of null values

```q
q)3 mcount 1 1 1 1 1 1
1 2 3 3 3 3
q)3 mcount 1 1 0N 1 1 1
1 2 2 2 2 3
```

## `.z.ph` and `.z.pp` changed

Previously kdb+ stripped the header information from incoming HTTP requests before passing it on to the user via `.z.ph` or `.z.pp`.

Unfortunately that meant useful information like the client's browser or preferred languages was being discarded.

With 2.4 the header information is passed back as a dictionary in addition to the body text as before.

This is a change in behavior, but will only affect those who have customised `.z.ph` or `.z.pp` directly. The previous value is now the first item of a 2-item list, the new header dictionary is the second item.


## Scalars

General speedups to the code to handle scalar values


## `abs` is primitive


## `\r` old new

unix mv (rename)

## splay `upsert`

With 2.4, the `upsert` function appends splayed tables on disk. Note that keyed tables cannot be splayed, so splayed upsert is the same as `insert`.

```q
q)`:x/ upsert ([]a:til 3)
`:x/
q)count get`:x
3
q)`:x/ upsert ([]a:til 3)
`:x/
q)count get`:x
6
```
