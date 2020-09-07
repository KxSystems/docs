---
title: System commands in q | Basics | kdb+ and q documentation
description: System commands control the q environment.
keywords: command, kdb+, q, system
---
# :fontawesome-solid-bullhorn: System commands





<pre markdown="1" class="language-txt">
[\a  tables](#a-tables)                           [\s       number of secondary threadss](#s-number-of-secondary-threads)
[\b  views](#b-views)                            [\S       random seed](#s-random-seed)
[\B  pending views](#b-pending-views)                    [\t       timer](#t-timer)
[\c  console size](#c-console-size)                     [\T       timeout](#t-timeout)
[\cd change directory](#cd-change-directory)                 [\ts      time and space](#ts-time-and-space)
[\C  HTTP size](#c-http-size)                        [\u       reload user password file](#u-reload-user-password-file)
[\d  directory](#d-directory)                        [\v       variables](#v-variables)
[\e  error trap clients](#e-error-trap-clients)               [\w       workspace](#w-workspace)
[\E  TLS server mode](#e-tls-server-mode)                  [\W       week offset](#w-week-offset)
[\f  functions](#f-functions)                        [\x       expunge](#x-expunge)
[\g  garbage collection mode](#g-garbage-collection-mode)          [\z       date parsing](#z-date-parsing)
[\l  load file or directory](#l-load-file-or-directory)           [\1 & \2  redirect](#1-2-redirect)
[\o  offset from UTC](#o-offset-from-utc)                  [\\_       hide q code](#_-hide-q-code)
[\p  listening port](#p-listening-port)                   [\\        terminate](#terminate)
[\P  precision](#p-precision)                        [\\        toggle q/k](#toggle-qk)
[\r  replication master](#r-replication-primary)               [\\\\       quit](#quit)
[\r  rename](#r-rename)                                              
</pre>

System commands control the q environment. They have the form:

<pre markdown="1" class="language-txt">
\cmd [_p_]
</pre>

for some command `cmd`, and optional parameter list _`p`_.

Commands with optional parameters that set values, will show the current values if the parameters are omitted.

Some system commands have equivalent command-line parameters.

!!! tip "The [`system`](../ref/system.md) keyword executes a string representation of a system command and returns its result."


## `\a` (tables)

<pre markdown="1" class="language-txt">
\a [_namespace_]
</pre>

Lists tables in _namespace_; default: current namespace.

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

<pre markdown="1" class="language-txt">
\b [_namespace_]
</pre>

Lists dependencies (views) in _namespace_.
Defaults to current namespace.

```q
q)a::x+y
q)b::x+1
q)\b
`s#`a`b
```

:fontawesome-solid-book:
[`.z.b`](../ref/dotz.md#zb-dependencies)
<br>
:fontawesome-solid-graduation-cap:
[Views](../learn/views.md)


## `\B` (pending views)

<pre markdown="1" class="language-txt">
\B [_namespace_]
</pre>

Lists pending dependencies (views) in _namespace_, i.e. dependencies not yet referenced, or not referenced after their referents have changed.
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

<pre markdown="1" class="language-txt">
\c [_size_]
</pre>

Show or set console maximum rows and columns.
_size_ is a pair of integers: rows and columns.
The default `25 80`; values are coerced to the range \[10,2000\].

These settings determine when q truncates output with `..`

!!! tip "You do not usually need to set this"

    If the environment variables `LINES` and `COLUMNS` are found they’ll be taken as the default value. See Bash documentation for `shopt` parameter `checkwinsize` to make sure they’re reset as needed.

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

:fontawesome-solid-book-open:
[`-c` command-line option](cmdline.md#-c-console-size)




## `\C` (HTTP size)

<pre markdown="1" class="language-txt">
\C [_size_]
</pre>

Show or set HTTP display maximum rows and columns.
_size_ is a pair of integers: rows and columns.
The default is `36 2000`; values are coerced to the range \[10,2000\].

:fontawesome-solid-book-open:
[`-C` command-line option](cmdline.md#-c-http-size)


## `\cd` (change directory)

<pre markdown="1" class="language-txt">
\cd [_name_]
</pre>

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

<pre markdown="1" class="language-txt">
\d [_namespace_]
</pre>

Sets the current namespace (also known as directory or context). The namespace can be empty, and a new namespace is created when an object is defined in it. The q session prompt indicates the current namespace.

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

:fontawesome-solid-street-view:
_Q for Mortals_
[§12.7 Working in a Context](/q4m3/12_Workspace_Organization/#127-working-in-a-context)


## `\e` (error trap clients)

<pre markdown="1" class="language-txt">
\e [_mode_]
</pre>

This enables error trapping for client requests. The default mode is 0 (off).

mode | behavior
:---:|---------
0    | When a client request has an error, by default the server clears the stack. Appropriate for production use as it enables the server to continue processing other client requests.
1    | The server suspends on an error, and does not process other requests until the stack is cleared. Appropriate for development: enables debugging on the server.
2    | Dumps stack to stderr for untrapped errors during request from a remote. (Since V3.5 2016.10.03)

:fontawesome-solid-book-open:
[Command-line option `-e`](cmdline.md#-e-error-traps)


## `\E` (TLS server mode)

```txt
\E
```

Displays TLS server mode as an int:

```txt
0i   plain
1i   plain and TLS
2i   TLS only
```

:fontawesome-solid-book-open:
[Command-line option `-E`](cmdline.md#-e-tls-server-mode) to set the mode


## `\f` (functions)

<pre markdown="1" class="language-txt">
\f [_namespace_]
</pre>

Lists functions in _namespace_, default current namespace.

```q
q)f:g:h:{x+2*y}
q)\f
`f`g`h
q)\f .h
`cd`code`data`eb`ec`ed`es`estr`fram`ha`hb`hc`he`hn`hp`hr`ht`hta`htac`htc`html`http`hu`hu..
q){x where x like"ht??"}system"f .h"
`htac`html`http
```


## `\g` (garbage collection mode)

<pre markdown="1" class="language-txt">
\g [_mode_]
</pre>

Show or set garbage-collection mode.
The default mode is 0.

B | mode      | behavior
--|-----------|------------------------------------------------------
0 | deferred  | returns memory to the OS when either `.Q.gc[]` is called or an allocation fails, hence has a performance advantage, but can be more difficult to dimension or manage memory requirements.
1 | immediate | returns (certain types of) memory to the OS as soon as no longer referenced; has an associated performance overhead.

:fontawesome-solid-book-open:
[Command-line option `-g`](cmdline.md#-g-garbage-collection)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§13.1.10 Garbage Collection `\g`](/q4m3/13_Commands_and_System_Variables/#13110-garbage-collection-g)


## `\l` (load file or directory)

<pre markdown="1" class="language-txt">
\l _name_
\l .
</pre>

Where _name_ is the name of a 

-   q script, executes the script
-   serialized object, deserializes it into memory as variable `name`
-   directory of a splayed table, maps the table to variable `name`, without loading any columns into memory
-   directory and the value of one of the permitted partition types, the most recent partition directory is inspected for splayed directories and each such directory mapped into memory with the name of the splayed directory
-   directory containing a kdb+ database, recursively loads whatever it finds there: serialized objects, scripts, splayed tables, etc.

**Current directory** When a directory is opened, it becomes the  current directory. 

**Reload current directory** You can reload the current database with `\l .`. This will ignore scripts and reload only data. 

**Never mind the dollars** If a file or directory under the path being loaded has a dollar-sign suffix then it is ignored. e.g. `db/tickdata/myfile$` and `db/tickdata/mydir$` would be ignored on `\l db/tickdata` or on `\l .` if `db/tickdata` is the current directory.

```q
q)\l sp.q            / load sp.q script
...
q)\a                 / tables defined in sp.q
`p`s`sp
q)\l db/tickdata     / load the data found in db/tickdata
q)\a                 / with tables quote and trade
`p`quote`s`sp`trade
```

!!! danger "Operating systems may create hidden files, such as `DS_Store`, that block `\l` on a directory."

:fontawesome-solid-book:
[`load`](../ref/load.md),
[`.Q.l`](../ref/dotq.md#ql-load) (load)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§10.3 Scripts](/q4m3/10_Execution_Control/#103-scripts)


## `\o` (offset from UTC)

<pre markdown="1" class="language-txt">
\o [_n_]
</pre>

Show or set the local time offset, as integer _n_ hours from UTC, or as minutes if `abs[n]>23`.
The initial value of `0N` means the machine’s offset is used.

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

:fontawesome-solid-book-open:
[Command-line option `-o`](cmdline.md#-o-utc-offset)


## `\p` (listening port)

_Show or set listening port_

<pre markdown="1" class="language-txt">
\p [_rp_,][_hostname_:][_portnumber_|_servicename_]
</pre>

See 
:fontawesome-solid-book-open:
[Listening port](listening-port.md) for detail.

:fontawesome-solid-book:
[`hopen`](../ref/hopen.md)
<br>
:fontawesome-solid-book-open:
[`-p` command-line option ](cmdline.md#-p-listening-port)
<br>
:fontawesome-solid-graduation-cap:
[Multithreaded input mode](../kb/multithreaded-input.md),
[Changes in 3.5](../releases/ChangesIn3.5.md#socket-sharding)
<br>
:fontawesome-regular-map:
[Socket sharding with kdb+ and Linux](../wp/socket-sharding/index.md)


## `\P` (precision)

<pre markdown="1" class="language-txt">
\P [_n_]
</pre>

Show or set display precision for floating-point numbers, i.e. the number of digits shown.

The default value of _n_ is 7 and possible values are integers in the range \[0,17\].
A value of 0 means use maximum precision.
This is used when exporting to CSV files.

```bash
$ q
```

```q
q)\P                       / default
7i
q)reciprocal 7             / 7 digits shown
0.1428571
q)123456789                / integers shown in full
123456789
q)123456789f               / floats shown to 7 significant digits
1.234568e+08

q)\P 3
q)1%3
0.333

q)\P 10
q)1%3
0.3333333333
```

??? tip "Use `.Q.fmt` and `.q.f` to format numbers to given width and precision"

    <pre><code class="language-q">
    q).Q.fmt[8;6]a            / format to width 8, 6 decimal places
    "0.142857"
    q).Q.f[2;]each 9.996 34.3445 7817047037.90  / format to 2 decimal places
    "10.00"
    "34.34"
    "7817047037.90"
    </code></pre>

:fontawesome-solid-book:
[`.Q.f`](../ref/dotq.md#qf-format),
[`.Q.fmt`](../ref/dotq.md#qfmt-format)
<br>
:fontawesome-solid-book-open:
[Precision](precision.md),
[`-P` command-line option](cmdline.md#-p-display-precision),
[`-27!` internal function](internal.md#-27xy-format)
<br>
:fontawesome-solid-globe:
[What Every Computer Scientist Should Know About Floating-Point Arithmetic](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html)



## `\r` (replication primary)

```txt
\r
```

This should not be executed manually otherwise it can disrupt replication. It is executed automatically by the replicating process on the primary process, and returns the log file name and log file count.

:fontawesome-solid-book-open:
[`-r` command-line option](cmdline.md#-r-replicate)


## `\r` (rename)

<pre markdown="1" class="language-txt">
\r _src dst_
</pre>

Rename file _`src`_ to _`dst`_. 

It is equivalent to the Unix `mv` command, or the windows `move` command (except that it will not rename to a different disk drive).


## `\s` (number of secondary threads)

```txt
\s [N]
```

Show or , where `N` is an integer, set the number of secondary threads available for parallel processing, within the limit set by the [`-s` command-line option](cmdline.md#-s-secondary-threads).
`N` is an integer.

Since V3.5 2017.05.02, secondary threads can be adjusted dynamically up to the maximum specified on the command line. A negative `N` indicates processes should be used, instead of threads.

```q
q)0N!("current secondary threads";system"s");system"s 4";0N!("current,max secondary threads";system"s";system"s 0N"); / q -s 8
("current secondary threads";0i)
("current,max secondary threads";4i;8i)
q)system"s 0" / disable secondary threads
q)system"s 0N" / show max secondary threads
8i
```

```txt
N    parallel processing uses
------------------------------------
>0   N threads
<0   processes with handles in .z.pd
```

For processes:

-   `peach` or `':` will call [`.z.pd`](../ref/dotz.md#zpd-peach-handles) for a list of handles to the processes, which must have been started previously
-   the absolute value of `-N` in the command line is ignored

:fontawesome-solid-book-open:
[`-s` command-line option](cmdline.md#-s-secondary-threads),
[Parallel processing](peach.md)


## `\S` (random seed)

```txt
\S [n]
```

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
    The rng in a secondary thread is assigned a seed based on the secondary thread number.

    In multithreaded input mode, the seed is based on the socket descriptor.
    
    Instances started on ports 20000 through 20099 (secondary threads, used with e.g. `q -s -4` have the main thread’s default seed based on the port number.


## `\t` (timer)

```txt
\t [ [N|[:n ]e] ]
```

This command has two different uses, according to the parameter.
If the parameter is omitted, it shows the number of milliseconds between timer ticks: 0 means the timer is off.

`N` (integer)

: Set the number of milliseconds between timer ticks. If 0, the timer is disabled, otherwise the timer is enabled and the first tick given. On each tick, the function assigned to [`.z.ts`](../ref/dotz.md#zts-timer) is executed.

: This usage corresponds to the [`-t` command-line option](cmdline.md#-t-timer-ticks)

`[:n] e` (expression)

: A q expression `e` (other than a single integer) is executed and the execution time shown in milliseconds. Since V3.0 2011.11.22, if `n` is specified, `e` is executed `n` times.

```q
q)/Show or set timer ticks
q)\t                           / default off
0
q).z.ts:{show`second$.z.N}
q)\t 1000                      / tick each second
q)13:12:52
13:12:53
13:12:54
\t 0                           / turn off

q)/Time an expression
q)\t log til 100000            / milliseconds for log of first 100000 numbers
3
q)\t:100 log til 100000        / timing for 100 repetitions
186
```

!!! warning "Actual timer tick frequency"

    The actual timer tick frequency is determined by the timing granularity supported by the underlying operating system. This can be considerably different from a millisecond.


## `\T` (timeout)

```txt
\T [n]
```

Show or set the client execution timeout, as `n` (integer) number of seconds a client call will execute before timing out.
The default is 0: no timeout.
Note this is in seconds, not milliseconds like `\t`.

:fontawesome-solid-book-open:
[`-T` command-line option](cmdline.md#-t-timeout)



## `\ts` (time and space)

```txt
\ts[:n] exp
```

Executes the expression `exp` and shows the execution time in milliseconds and the space used in bytes.

```q
q)\ts log til 100000
7 2621568
```

Since 3.1 2014.02.07

```q
q)\ts:10000 log til 1000           /same as \ts do[10000; log til 1000]
329 24672
```


## `\u` (reload user password file)

```txt
\u
```

When q is invoked with the `-u` parameter specifying a user password file, then `\u` will reload the password file. This allows updates to the password file while the server is running.

:fontawesome-solid-book-open:
[`-u` command-line option](cmdline.md#-u-usr-pwd-local)


## `\v` (variables)

```txt
\v [namespace]
```

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

To expunge `a` from the default namespace

```q
delete a from `.
```

:fontawesome-solid-street-view: 
_Q for Mortals_
[§12.5 Expunging from a Context](/q4m3/12_Workspace_Organization/#125-expunging-from-a-context)


## `\w` (workspace)

```txt
\w [0|1|n]
```

With no parameter, returns current memory usage, as a list of 6 long integers.

```txt
0   number of bytes allocated
1   bytes available in heap
2   maximum heap size so far
3   limit on thread heap size, from -w command-line option
4   mapped bytes
5   physical memory
```

```q
q)\w
168144 67108864 67108864 0 0 8589934592
```

`\w 0` and `\w 1` return a pair of longs:

```txt
0   number of internalized symbols
1   corresponding memory usage
```

```q
q)\w 0
577 25436
```

The utility [`.Q.w`](../ref/dotq.md#qw-memory-stats) formats all this information.


**Run-time increase**
Since 2017.11.06, `\w` allows the workspace limit to be increased at run-time, if it was initialized via the
[`-w` command-line option](cmdline.md#-w-workspace).
E.g. `system "w 128"` sets the `-w` limit to the larger of 128 MB and the current setting and returns it.

If the system tries to allocate more memory than allowed, it signals `-w abort` and terminates with exit code 1. 

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

**Domain-local**
Since V4.0 2020.03.17 returns information for the [current memory domain](../ref/dotm.md) only.

```q
q)value each ("\\d .m";"\\w";"\\d .";"\\w")
::
353968 67108864 67108864 0 0 8589934592
::
354032 67108864 67108864 0 0 8589934592
```

:fontawesome-solid-book-open:
[`-w` command-line option](cmdline.md#-w-workspace)<br>
:fontawesome-solid-book:
[`.m` namespace](../ref/dotm.md)


## `\W` (week offset)

```txt
\W [n]
```

Show or set the start-of-week offset `n`, where 0 is Saturday. The default is 2, i.e Monday.

:fontawesome-solid-book-open:
[`-W` command-line option](cmdline.md#-w-start-week)


## `\x` (expunge)

```txt
\x .z.p*
```

By default, callbacks like `.z.po` are not defined in the session. After they have been assigned, you can restore the default using `\x` to delete the definition that was made.

```q
q).z.pi                       / default has no user defined function
'.z.pi
q).z.pi:{">",.Q.s value x}    / assign function
q)2+3
>5
q)\x .z.pi                    / restore default
```

??? warning "Works only for `.z.p*` variables defined in k before `q.k` is loaded"

    For example, as `.z.ph` is defined in `q.k`, there is no default for it to be reset to.


## `\z` (date parsing)

```txt
\z [0|1]
```

Show or set the format for `"D"$` date parsing. `B` is 0 for mm/dd/yyyy and 1 for dd/mm/yyyy.

```q
q)\z
0
q)"D"$"06/01/2010"
2010.06.01
q)\z 1
q)"D"$"06/01/2010"
2010.01.06
```

:fontawesome-solid-book-open:
[`-z` command-line option](cmdline.md#-z-date-format)


## `\1` & `\2` (redirect)

```txt
\[1|2] filename
```

`\1` and `\2` let you redirect stdout and stderr to files from within the q session. The files and intermediate directories are created if necessary.

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

```txt
\_ [scriptname]
```

This command has two different uses depending on whether a parameter is given.

If no parameter, then `\_` checks if client write-access is blocked.

```q
q)\_
0b
```

:fontawesome-solid-book-open:
[`-b` command-line option](cmdline.md#-b-blocked)

If a parameter is given, it should be a scriptname and `\_ f.q` makes a runtime script `f.q_`. The q code loaded from a runtime script cannot be viewed or serialized.

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

:fontawesome-solid-book-open:
[Debugging](debug.md)


!!! warning "Without a suspension, `\` toggles in an out of the k interpreter."

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
```


## `\` (toggle q/k)

In the interactive session `\` toggles between the q and k interpreters.

```q
q)\
  \
  !5                  / this is k
0 1 2 3 4
  \
q)
```

!!! warning "The k programming language is exposed infrastructure."

:fontawesome-solid-book-open:
[Exposed infrastructure](exposed-infrastructure.md)


## `\\` (quit)

```txt
\\
```

-   In the interactive session type `\\` at the prompt to quit the session.
-   Inside a function, use `value"\\\\"` or `exit 0` for the same result.

:fontawesome-regular-hand-point-right:
[`exit`](../ref/exit.md),
[`value`](../ref/value.md),
[`.z.exit`](../ref/dotz.md#zexit-action-on-exit)

!!! tip "Final comments"

    The text following `\\` and white space is ignored by q. This is often useful in scripts where `\\` can be followed by comments or usage examples.


## Interrupt and terminate

Ctl-c signals an interrupt to the interpreter. 

Some operations are coded so tightly the interrupt might not be registered. 

Ctl-z will kill the q session. Nothing in memory is saved. 


## OS commands

If an expression begins with `\` but is not recognized as a system command, then it is executed as an OS command.

!!! danger "Typos can get passed to the OS"

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

> When you are run `rm -r /` you are have of many problem, but Big Data is not of one of them. — [:fontawesome-brands-twitter: DevOps Borat](https://twitter.com/devops_borat)



