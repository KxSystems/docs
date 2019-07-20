---
title: System commands
description: System commands control the q environment. 
keywords: command, kdb+, q, system
---
# System commands





System commands control the q environment. They have the form:

```txt
\cmd [p]
```

for some command `cmd`, and optional parameter list `p`.  

<i class="far fa-hand-point-right"></i> 
[`.Q.opt`](../ref/dotq.md#qopt-command-parameters) (command parameters), 
[`.Q.x`](../ref/dotq.md#qx-non-command-parameters) (non-command parameters)

Commands with optional parameters that set values, will show the current values if the parameters are elided.

Some system commands have equivalent command-line parameters.

!!! tip "`system`"

    The [`system`](../ref/system.md) keyword executes a string representation of a system command – and allows its result to be captured.

```txt
\   abort                       \s       number of slaves
\a  tables                      \S       random seed
\b  views                       \t       timer
\B  pending views               \T       timeout
\c  console size                \ts      time and space
\cd change directory            \u       reload user password file
\C  HTTP size                   \v       variables
\d  directory                   \w       workspace
\e  error trap clients          \W       week offset
\f  functions                   \x       expunge
\g  garbage collection mode     \z       date parsing
\l  load file or directory      \1 & \2  redirect
\o  offset from UTC             \_       hide q code
\p  listening port              \        terminate
\P  precision                   \        toggle q/k
\r  replication master          \\       quit
\r  rename                      
```


## `\` (abort)

At the debugger’s `q))` prompt clears one level from the execution stack and (eventually) returns to the interactive session.

```q
q)f:{g[]}
q)g:{'`xyz}
q)f[]
{g[]}
'xyz
@
{'`xyz}
::
q))\
q)
```

<i class="far fa-hand-point-right"></i> 
[Debugging](debug.md)


!!! warning "At the session’s `q)` prompt"

    toggles in an out of the k interpreter.
    (Don’t go there.)


## `\a` (tables)

Syntax: `\a [namespace]`

Lists tables in `namespace`; default: current namespace.

```q
q)\a
`symbol$()
q)aa:bb:23
q)\a
`symbol$()
q)tt:([]dd:12 34)
q)\a
,`tt
q).nn.vv:([]uu:12 45)
q)\a
,`tt
q)\a .n
'.n
q)\a .nn
,`vv
q)\d .nn
q.nn)\a
,`vv
q.nn)vv
uu
--
12
45
q.nn)
```


## `\b` (views)

Syntax: `\b [namespace]`

Lists dependencies (views) in `namespace`. 
Defaults to current namespace.

```q
q)a::x+y
q)b::x+1
q)\b
`s#`a`b
```

<i class="far fa-hand-point-right"></i> 
[`.z.b`](../ref/dotz.md#zb-dependencies).


## `\B` (pending views)

Syntax: `\B [namespace]`

Lists pending dependencies (views) in `namespace`, i.e. dependencies not yet referenced, or not referenced after their referents have changed. 
Defaults to current namespace.

```q
q)a::x+1          / a depends on x
q)\B              / the dependency is pending
,`a
q)x:10
q)\B              / still pending after x is defined
,`a
q)a               / use a
11
q)\B              / no longer pending
`symbol$()
```


## `\c` (console size)

Syntax: `\c`

Syntax: `\c [h,w]`

Sets console height and width. This is the same as the [`-c` command line parameter](cmdline.md#-c-console-size).

These settings determine when q elides output with `..`

!!! note 

    You usually don’t need to set this. If the environment variables `LINES` and `COLUMNS` are found they’ll be taken as the default value. See Bash documentation for `shopt` parameter `checkwinsize` to make sure they’re reset as needed.

```q
q)\c
45 160
q)\c 5 5
q)\c
10 10
q)til each 20+til 10
0 1 2 3..
0 1 2 3..
0 1 2 3..
0 1 2 3..
0 1 2 3..
0 1 2 3..
0 1 2 3..
..
```

<i class="far fa-hand-point-right"></i>
[`-c`](cmdline.md#-c-console-size)



## `\C` (HTTP size)

Syntax: `\C [h,w]`

Sets the HTTP height and width. This is the same as [command-line option `-C`](cmdline.md#-c-http-size). 

<i class="far fa-hand-point-right"></i>
[`-C`](cmdline.md#-c-http-size)


## `\cd` (change directory)

Syntax: `\cd [name]` 

Changes the current directory.
```q
~/q$ q
KDB+ 2.6 2010.05.10 Copyright (C) 1993-2010 Kx Systems
..
q)\cd
"/home/guest/q"
q)\cd /home/guest/dev
q)\cd
"/home/guest/dev"
```


## `\d` (directory)

Syntax: `\d [namespace]`

Sets the current namespace (also known as directory or context). The namespace can be empty, and a new namespace is created when an object is defined in it. The prompt indicates the current namespace. 

```q
q)\d                  / default namespace
`.
q)\d .o               / change to .o
q.o)\f
`Cols`Columns`FG`Fkey`Gkey`Key`Special..
q.o)\d .              / return to default
q)key`                / lists namespaces other than .z
`q`Q`o`h
q)\d .s               / change to non-existent namespace
q.s)key`              / not yet created
`q`Q`o`h
q.s)a:1               / create object, also creates namespace
q.s)key`
`q`Q`o`h`s
```


## `\e` (error trap clients)

Syntax: `\e [0|1]`

This enables error trapping for client requests. The default is 0 (off).

When a client request has an error, by default the server clears the stack. This is appropriate for production use as it enables the server to continue processing other client requests.

For development, you can set `\e 1` to enable debugging on the server. In this case, the server suspends on an error, and does not process other requests until the stack is cleared.

<i class="far fa-hand-point-right"></i>
[`-e`](cmdline.md#-e-error-traps)


## `\f` (functions)

Syntax: `\f [namespace]`

Lists functions in the given namespace, default current namespace.

```q
q)f:g:h:{x+2*y}
q)\f
`f`g`h
q)\f .h
`cd`code`data`eb`ec`ed`es`estr`fram`ha`hb`hc`he`hn`hp`hr`ht`hta`htac`htc`html`http`hu`hug`hy`jx`nbr`pre`td`text`uh`xd`xmp`xs`xt
q){x where x like"ht??"}system"f .h"
`htac`html`http
```


## `\g` (garbage collection mode)

Syntax: `\g [mode]`

Since V2.7 2011.02.04. Switch garbage collection between immediate (1) and deferred (0) modes. 

<i class="far fa-hand-point-right"></i> 
[`-g` command-line option](cmdline.md#-g-garbage-collection)


## `\l` (load file or directory)

Syntax: `\l name`

The parameter can be a script filename or a directory. A script is loaded, and a directory database is opened. When q opens a directory, it changes its current directory to it. This allows reloading the current database using `\l .`. If the directory is specified as `.`, any scripts in that directory will be ignored; this is to allow (re)loading of data only. 

If a file or directory under the path being loaded has a dollar-sign suffix then it is also ignored. e.g. `db/tickdata/myfile$` and `db/tickdata/mydir$` would be ignored on `\l db/tickdata` or on `\l .` if `db/tickdata` is the current directory.

```q
q)\l sp.q            / load sp.q script
...
q)\a                 / tables defined in sp.q
`p`s`sp
q)\l db/tickdata     / load the data found in db/tickdata
q)\a                 / with tables quote and trade
`p`quote`s`sp`trade
```

<i class="far fa-hand-point-right"></i> 
[`.Q.l`](../ref/dotq.md#ql-load) (load)


## `\o` (offset from UTC)

Syntax: `\o [n]`

Sets the local time offset, as hours from UTC, or as minutes if `abs[n]>23`. Initially, the value is `0N`, meaning that the machine’s offset is used.

```q
q)\o
0N
q).z.p                        / UTC
2010.05.31D23:45:52.086467000
q).z.P                        / local time is UTC + 8
2010.06.01D07:45:53.830469000
q)\o -5                       / set local time as UTC - 5
q).z.P
2010.05.31D18:45:58.470468000
q)\o 390                      / set local time as UTC + 6:30
q).z.P
2010.06.01D06:16:06.603981000
```

This corresponds to the `-o` command line parameter.

<i class="far fa-hand-point-right"></i>
[`-o`](cmdline.md#-o-utc-offset)


## `\p` (listening port)

Syntax: `\p [hostname:][portnumber|servicename]`

kdb+ will listen to `portnumber` or the port number of `servicename` on all interfaces, or on `hostname` only if specified. 
The port must be available and the process must have permission for the port.

The default is 0 (no listening port). 

<i class="far fa-hand-point-right"></i>
[Listening port](listening-port.md) for details  
Reference: [`hopen`](../ref/handles.md#hopen)  
Command-line options: [`-e`](cmdline.md#-e-tls-server-mode), 
[`-p`](cmdline.md#-p-listening-port)  
Knowledge Base: [Multithreaded input mode](../kb/multithreaded-input.md)


## `\P` (precision)

Syntax: `\P [n]`

Sets display precision for floating point numbers, i.e. the number of digits shown. 

<i class="far fa-hand-point-right"></i> 
[`-P` command-line option](cmdline.md#-p-display-precision)


## `\r` (replication master)

Syntax: `\r`

This should not be executed manually otherwise it can disrupt replication. It is executed automatically by the replicating process on the master process, and returns the log file name and log file count. 

<i class="far fa-hand-point-right"></i> 
[`-r` command-line option](cmdline.md#-r-replicate)


## `\r` (rename)

Syntax: `\r src dst`

This renames file `src` to `dst`. It is equivalent to the Unix `mv` command, or the windows `move` command (except that it will not rename to a different disk drive).


## `\s` (number of slaves)

Syntax: `\s`

This queries or limits the number of slaves, set with the [`-s` command line  option](cmdline.md#-s-slaves).

As of V3.5 2017.05.02, slave threads can be adjusted dynamically up to the maximum specified on the command line. A negative number indicates that processes should be used, instead of threads.

```q
q)0N!("current slave threads";system"s");system"s 4";0N!("current,max slave threads";system"s";system"s 0N"); / q -s 8
("current slave threads";0i)
("current,max slave threads";4i;8i)
q)system"s 0" / disable slave threads
q)system"s 0N" / show max slave threads
8i
```

<i class="far fa-hand-point-right"></i>
[`-s`](cmdline.md#-s-slaves)


## `\S` (random seed)

Syntax: `\S [n]`

Where `n` is

-   omitted: display the last value to which the random seed was initialized
-   `0N`: display the current value of the random seed (since V3.6)
-   non-zero integer: re-initialize the seed to `n`

Note that `\S` displays the last value to which the seed was initialized: it is not updated as the random-number generator (rng) is used.

```q
q)\S                       / default
-314159i         
q)5?10         
8 1 9 5 4         
q)5?10         
6 6 1 8 5         
q)\S -314159               / restore default seed
q)5?10                     / same random numbers generated
8 1 9 5 4         
q)\S                       / seed is not updated
-314159         
q)x:system "S 0N"          / current value of seed
q)r:10?10
q)system "S ",string x     / re-initialize seed
q)r~10?10
1b
```

Allows user to save and restore state of the rng. 
(Since V3.6 2017.09.26.)

```q
q)x:system"S 0N";r:10?10;system"S ",string x;r~10?10
```

!!! note "Thread-local"

    Since V3.1 2013.08.19 random-number generation (rng) is thread-local.
    `\S 1234` sets the seed for the rng for the main thread only.
    The rng in a slave thread is assigned a seed based on the slave thread number.

    In multithreaded input mode, the seed is based on the socket descriptor.
    Instances started on ports 20000 through 20099 (slave procs, used with e.g. `q -s -4` have the main thread’s default seed based on the port number.


## `\t` (timer)

Syntax: `\t [p]`

This command has two different uses depending on the parameter given.

An integer parameter is the number of milliseconds between timer ticks. If 0, the timer is turned off, otherwise the timer is turned on and the first tick given. On each tick, the function assigned to 
[`.z.ts`](../ref/dotz.md#zts-timer) 
is executed.

```q
q)\t                           / default off
0
q).z.ts:{show`second$.z.N}
q)\t 1000                      / tick each second
q)13:12:52
13:12:53
13:12:54
\t 0                           / turn off
```

A parameter of a q expression other than a single integer is executed and the execution time shown in milliseconds.

```q
q)\t log til 100000            / milliseconds for log of first 100000 numbers
3
q)\t do[100;log til 100000]    / timing for 100 repetitions
196
q)\t:100 log til 100000    / timing for 100 repetitions, new syntax of "\t:n expr" since 3.0 2011.11.22
186
```

The tick timer usage corresponds to the `-t` command line parameter. 

<i class="far fa-hand-point-right"></i>
[`-t`](cmdline.md#-t-timer-ticks)


## `\T` (timeout)

Syntax: `\T [n]`

This sets the client execution timeout, as the integer number of seconds a client call will execute before timing out, default 0 (no timeout). Note this is in seconds, not milliseconds like `\t`.

This corresponds to the `-T` command line parameter.

<i class="far fa-hand-point-right"></i>
[`-T`]](cmdline.md#-t-timeout)



## `\ts` (time and space)

Syntax: `\ts exp`

Executes the expression and shows the execution time in milliseconds and the space used in bytes.

```q
q)\ts log til 100000
7 2621568j
```

Since 3.1 2014.02.07

```q
q)\ts:10000 log til 1000           /same as \ts do[10000; log til 1000]
329 24672
```


## `\u` (reload user password file)

Syntax: `\u`

When q is invoked with the `-u` parameter specifying a user password file, then `\u` will reload the password file. This allows updates to the password file while the server is running.

<i class="far fa-hand-point-right"></i>
[`-u`](cmdline.md#-u-usr-pwd-local)


## `\v` (variables)

Syntax: `\v [namespace]`

Lists the variables in the given namespace, default current namespace.

```q
q)a:1+b:2
q)\v
`a`b
q)\v .h
`HOME`br`c0`c1`logo`sa`sb`sc`tx`ty
q){x where x like"????"}system"v .h"
`HOME`logo
```

!!! tip "Expunging variables"

    To expunge `a` from the workspace root, ``delete a from `.``  
    <i class="far fa-hand-point-right"></i> _Q for Mortals_: [§12.5 Expunging from a Context](/q4m3/12_Workspace_Organization/#125-expunging-from-a-context)


## `\w` (workspace)

Syntax: `\w [0|1|n]`

If there is no parameter, returns current memory usage, as a list of 6 long integers.

index | meaning
:----:|--------
0     | number of bytes allocated
1     | bytes available in heap
2     | maximum heap size so far
3     | limit on thread heap size, given in [`-w` command-line parameter](cmdline.md#-w-memory)
4     | mapped bytes
5     | physical memory

```q
q)\w
168144 67108864 67108864 0 0 8589934592
```
  
`\w 0` or `\w 1` returns a pair.
  
index | meaning
:----:|--------
0     | number of internalized symbols
1     | corresponding memory usage

```q
q)\w 0
577 25436
```

The utility [`.Q.w`](../ref/dotq.md#qw-memory-stats) formats all this information.


**Run-time increase** 
Since 2017.11.06, `\w` allows the workspace limit to be increased at run-time, if it was initialized via the 
[`-w` command-line option](cmdline.md#-w-memory). 
E.g. `system "w 128"` sets the `-w` limit to the larger of 128 MB and the current setting and returns it. 

Specifying too large a number will fall back to the same behavior as `\w 0` or `\w 1`.

```q
q)\w
339168 67108864 67108864 104857600 0 8589934592
q)\w 0
651 28009
q)\w 128
134217728
q)\w 1000000000
1048576000000000
q)\w 1000000000000
651 28009
```

If the workspace limit has not been set by the command-line option `-w`, an error is signalled.

```q
q)\w 3
'-w init via cmd line
```

<i class="far fa-hand-point-right"></i>
[`-w`](cmdline.md#-w-memory)


## `\W` (week offset)

Syntax: `\W [n]`

Specifies the start of week offset, where 0 is Saturday. The default is 2 = Monday.

This corresponds to the `-W` command line parameter.

<i class="far fa-hand-point-right"></i>
[`-W`](cmdline.md#-w-start-week)


## `\x` (expunge)

Syntax: `\x .z.p\*`

By default, callbacks like `.z.po` are not defined in the session. After they have been assigned, you can restore the default using `\x` to delete the definition that was made.

```q
q).z.pi                       / default has no user defined function
'.z.pi
q).z.pi:{">",.Q.s value x}    / assign function
q)2+3
>5
q)\x .z.pi                    / restore default
```

N.B. This works only for `.z.p*` variables defined in k before q.k is loaded. e.g. as `.z.ph` is defined in `q.k`, there is no default for it to be reset to.


## `\z` (date parsing)

Syntax: `\z [0|1]`

Specifies the format for date parsing. 0 is "mm/dd/yyyy" and 1 is "dd/mm/yyyy".

```q
q)\z
0
q)"D"$"06/01/2010"
2010.06.01
q)\z 1
q)"D"$"06/01/2010"
2010.01.06
```

<i class="far fa-hand-point-right"></i>
[`-z`](cmdline.md#-z-date-format)


## `\1` & `\2` (redirect)

Syntax: `\1 filename`  
Syntax: `\2 filename` 

`\1` and `\2` allow redirecting stdout and stderr to files from within the q session. The files and intermediate directories are created if necessary.

```bash
~/q$ rm -f t1.txt t2.txt
~/q$ l64/q
KDB+ 2.6 2010.05.10 Copyright (C) 1993-2010 Kx Systems
...
```

```q
q)\1 t1.txt              / stdout
q)\2 t2.txt              / stderr
til 10
2 + "hello"
\\
```

```bash
~/q$ cat t1.txt          / entry in stdout
0 1 2 3 4 5 6 7 8 9
~/q$ cat t2.txt          / entry in stderr
q)q)'type
```

On macOS and Linux `\1 /dev/stdin` returns output to the default. 


## `\_` (hide q code)

Syntax: `\_ [scriptname]`

This command has two different uses depending on whether a parameter is given.

If no parameter, then `\_` checks if client write access is blocked. 

```q
q)\_
0b
```

<i class="far fa-hand-point-right"></i> 
[`-b` command-line option](cmdline.md#-b-blocked)

If a parameter is given, it should be a scriptname and `\_ f.q` makes a runtime script `f.q_`. The q code cannot be viewed or serialized.

```q
q)`:t1.q 0:enlist "a:123;f:{x+2*y}"
q)\_ t1.q               / create locked script
`t1.q_
q)\l t1.q_              / can be loaded as usual
q)a                     / definitions are correct
123
q)f[10;1 2 3]
12 14 16
q)f                     / q code is not displayed
locked
q)-8!f                  / or serialized
'type
  [0]  -8!f
         ^
q)read0`:t1.q
"a:123;f:{x+2*y}"
q)read0`:t1.q_          / file contents are scrambled
"'\374E\331\207'\262\355"
"S\014%\210\0273\245"
```


## `\` (terminate)

If there is a suspension, this exits one level of the suspension. Otherwise, it toggles between q and k mode. (To switch languages from inside a suspension, type "`\`".)

```q
q){1+x}"hello"
{1+x}
'type
+
1
"hello"
q))\                         / clear suspension (only one level)
q)\                          / toggle to k mode
  !5
0 1 2 3 4
  \                          / toggle to q mode
q)
```


## `\` (toggle q/k) 

In the interactive session `\` toggles between the q and k interpreters.

```q
q)\
  \
q)
```


## `\\` (quit)

Syntax: `\\`

-   In the interactive session type `\\` at the prompt to quit the session. 
-   Inside a function, use `value"\\\\"` or `exit 0` for the same result. 

<i class="far fa-hand-point-right"></i> 
[`exit`](../ref/exit.md), 
[`value`](../ref/value.md), 
[`.z.exit`](../ref/dotz.md#zexit-action-on-exit)

!!! tip "Final comments"

    The text following `\\` and white space is ignored by q. This is often useful in scripts where `\\` can be followed by comments or usage examples.



## OS Commands

If an expression begins with `\` but is not recognized as a system command, then it is executed as an OS command.

```q
q)\ls                 / usual ls command
"help.q"
"k4.lic"
"l64"
"odbc.k"
"profile.q"
"q.k"
..
```

!!! warning "Typos can get passed to the OS."

> When you are run `rm -r /` you are have of many problem, but Big Data is not of one of them. — [<i class="fab fa-twitter"></i> DevOps Borat](https://twitter.com/devops_borat)



