---
title: Command line
description: Command-line syntax for invoking q and list of the command-line options
author: Stephen Taylor
keywords: command, file, kdb+, line, option, q
---
# Command line




The command line for invoking kdb+ has the form:

```txt
q [file] [-b] [-c r c] [-C r c] [-e 0|1] [-E 0|1|2] [-g 0|1] [-l] [-L][-o N] 
    [-p port|servicename|host:port|host:servicename] 
    [-P N] [-q] [-r :H:P] [-s N] [-t N] [-T N] [-u|U F] [-w N] [-W N] 
    [-z 0|1]
```

<i class="far fa-hand-point-right"></i> 
[`.z.x`](../ref/dotz.md#zx-argv) (argv), 
[`.z.X`](../ref/dotz.md#zx-raw-command-line) (raw command line) 


```txt
Options:
 -b blocked                 -q quiet mode
 -c console size            -r replicate
 -C HTTP size               -s slaves
 -e error traps             -t timer ticks
 -E TLS Server Mode         -T timeout
 -g garbage collection      -u disable syscmds
 -l log updates             -u usr-pwd local
 -L log sync                -U usr-pwd
 -o UTC offset              -w memory
 -p listening port          -W start week
 -p multithread port        -z date format
 -P display precision        
```


## file
  
This is either the script to load (\*.q, \*.k, \*.s), or a file or directory

```bash
$q sp.q
KDB+ 3.5t 2017.02.28 Copyright (C) 1993-2017 Kx Systems
m32/ 4()core 8192MB sjt mint.local 192.168.0.39 NONEXPIRE
```

```q
+`p`city!(`p$`p1`p2`p3`p4`p5`p6`p1`p2;`london`london`london`london`london`lon..
(`s#+(,`color)!,`s#`blue`green`red)!+(,`qty)!,900 1000 1200
+`s`p`qty!(`s$`s1`s1`s1`s2`s3`s4;`p$`p1`p4`p6`p2`p2`p4;300 200 100 400 200 300)
q)
```


## `-b` (blocked)

Syntax: `-b`
  
Block client write-access to a kdb+ database. 

```bash
~/q$ q -b
```

```q
q)aa:([]bb:til 4)
q)\p 5001
q)
```

and in another task

```q
q)h:hopen 5001
q)h"count aa"
4
q)h"aa:10#aa"
'noupdate
q)
```

Use `\_` to check if client write-access is blocked:

```q
~/q$ q -b
..
q)\_
1
```



## `-c` (console size)

Syntax: `-c r c`
  
Console maximum rows and columns, default 25 80.

These settings determine when q elides output with `..`

!!! note

    You usually don’t need to set this, if the environment variables `LINES` and `COLUMNS` are found they’ll be taken as the default value. See Bash documentation for `shopt` parameter `checkwinsize` to make sure they are reset as needed.

```bash
..$ q -c 10 20
```

```q
q)til each 20+til 10
0 1 2 3 4 5 6 7 8..
0 1 2 3 4 5 6 7 8..
0 1 2 3 4 5 6 7 8..
0 1 2 3 4 5 6 7 8..
0 1 2 3 4 5 6 7 8..
0 1 2 3 4 5 6 7 8..
0 1 2 3 4 5 6 7 8..
..
```

<i class="far fa-hand-point-right"></i> 
[`\c` system command](syscmds.md#c-console-size)  
[Gnu Shopt documentation](http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html)


## `-C` (HTTP size)

Syntax: `-C r c`
  
HTTP display maximum rows and columns, default 36 2000

The defaults are 36&times;2000, and values are coerced to the range \[10,2000\].

<i class="far fa-hand-point-right"></i> 
[`\C` system command](syscmds.md#c-http-size)  
[Gnu Shopt documentation](http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html)



## `-e` (error traps)

Syntax: `-e B`
  
Enable client error trapping


## `-E` (TLS Server Mode)

Syntax: `-E x` (since V3.4)

x   | mode
--- | ----
0   | plain
1   | plain & TLS
2   | TLS only

<i class="far fa-hand-point-right"></i> 
Knowledge Base: [SSL/TLS](../kb/ssl.md#tls-server-mode)


## `-g` (garbage collection)

Syntax: `-g B`
  
Allow switching of garbage collect to immediate(1) mode instead of deferred(0).

-   Immediate mode will return (certain types of) memory to the OS as soon as no longer referenced and has an associated overhead.
-   Deferred mode will return memory to the OS when either `.Q.gc[]` is called or an allocation fails, hence deferred mode has a performance advantage, but can be more difficult to dimension/manage memory requirements.

Immediate mode is the V2.5/2.6 default, deferred is the V2.7 default.
To use immediate mode, invoke as `q -g 1`. (Since V2.7 2011.02.04.)


## `-l` (log updates)

Syntax: `-l`
  
Log updates to filesystem  
<i class="far fa-hand-point-right"></i> 
Knowledge Base: [Logging](../kb/logging.md)


## `-L` (log sync)

Syntax: `-L`
  
As `-l`, but sync logging  
<i class="far fa-hand-point-right"></i> 
Knowledge Base: [Logging](../kb/logging.md)


## `-o` (UTC offset)

Syntax: `-o N`
  
Offset hours from UTC, or minutes if `abs[N]>23` (Affects [`.z.Z`](../ref/dotz.md#zz-local-datetime))


## `-p` (listening port)

Syntax: `-p [hostname:][portnumber|servicename]`

kdb+ will listen to `portnumber` or the port number of `servicename` on all interfaces, or on `hostname` only if specified. 
The port must be available and the process must have permission for the port.

The default is 0 (no listening port). 

<i class="far fa-hand-point-right"></i>
[Listening port](listening-port.md) for details  
Reference: [`hopen`](../ref/handles.md#hopen)  
Command-line option: [`-e`](cmdline.md#-e-tls-server-mode)  
System command: [`\p`](syscmds.md#p-listening-port)  
Knowledge Base: [Multithreaded input mode](../kb/multithreaded-input.md)



## `-P` (display precision)

Syntax: `-P N`
  
Display precision for floating point numbers, where `N` is the _display_ precision for floats and reals, i.e. `N` is the number of significant digits shown in output.
The default value is 7 and possible values are in the range \[0,17\]. A precision of 0 means use maximum precision. 
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
q)\\
```

```bash
$ q -P 3
```

```q
q)1%3
0.333
q)\\
```

```bash
$ q -P 10
```

```q
q)1%3
0.3333333333
q)\\
```

!!! tip "`.Q.fmt` and `.q.f`"

    Use `.Q.fmt` to format numbers to given width and precision.
    <pre><code class="language-q">
    q).Q.fmt[8;6]a            / format to width 8, 6 decimal places
    "0.142857"
    </code></pre>

    Use `.Q.f` to format numbers to given precision after the decimal.

    <pre><code class="language-q">
    q).Q.f[2;]each 9.996 34.3445 7817047037.90  / format to 2 decimal places
    "10.00"
    "34.34"
    "7817047037.90"
    </code></pre>

<i class="far fa-hand-point-right"></i> 
[Precision](precision.md), 
[`\P`](syscmds.md#p-precision), 
[`.Q.f`](../ref/dotq.md#qf-format), 
[`.Q.fmt`](../ref/dotq.md#qfmt-format) 

<i class="far fa-hand-point-right"></i> 
[What Every Computer Scientist Should Know About Floating-Point Arithmetic](http://docs.sun.com/source/806-3568/ncg_goldberg.html)


## `-q` (quiet mode)

Syntax: `-q`
  
Quiet, i.e. no startup banner text or session prompts. Typically used where no console is required.

```bash
~/q$ q
KDB+ 3.5t 2017.02.28 Copyright (C) 1993-2017 Kx Systems
…
```

```q
q)2+2
4
q)
```

and with `-q`

```bash
~/q$ q -q
```

```q
2+2
4
```

<i class="far fa-hand-point-right"></i>
[`.z.q`](../ref/dotz.md#zq-quiet-mode) (quiet mode) 


## `-r` (replicate)
  
Syntax: `-r :H:P[:user[:password]]`
  
Replicate from :host:port


## `-s` (slaves)
  
Syntax: `-s N`
  
Slave threads or processes for parallel processing

N        | parallel processing uses
---------|-------------------------
positive | `N` threads
negative | processes with handles in `.z.pd`

For processes:

-   `peach` or `':` will call [`.z.pd`](../ref/dotz.md#zpd-peach-handles) for a list of handles to the processes, which must have been started previously
-   the absolute value of `-N` in the command line is ignored. 

<i class="far fa-hand-point-right"></i> 
[`\s`](syscmds.md#s-number-of-slaves), 
[Parallel processing](peach.md)


## `-t` (timer ticks)

Syntax: `-t N`
  
Timer in milliseconds between timer ticks. Default is 0, for no timer.


## `-T` (timeout)

Syntax: `-T N`
  
Timeout in seconds for client queries, i.e. maximum time a client call will execute. Default is 0, for no timeout.


## `-u` (disable syscmds)

Syntax: `-u 1`
  
Disables system commands from a remote (signals `'access`). As such, this includes disabling exit via `"\\"` from a remote.

!!! warning "Weak protection"

This option offers only a simple protection against “wrong” queries.

For example, setting a system command in `.z.ts` and starting the timer still works. The right system command could for example expose a terminal, so the user running the database could be fully impersonated and compromised from then on.


## `-u` (usr-pwd local)

Syntax: `-u file`
  
Sets a password file; no access above start directory

The password file is a text file with one credential on each line. 
(No trailing blank line/s.)
```txt
user1:password1
user2:password2
```
The password can be plain text, or an MD5 hash of the password.
```q
q)raze string md5 "this is my password"
"210d53992dff432ec1b1a9698af9da16"
```


## `-U` (usr-pwd)

Syntax: `-U F`
  
As `-u`, but no access restrictions


## `-w` (memory)

Syntax: `-w N`
  
Workspace limit in MB for the heap per thread. Default is 0: no limit. 

As reported by system command [`\w`](syscmds.md#w-workspace) and utility [`.Q.w`](../ref/dotq.md#qw-memory-stats).

!!! tip "Other ways to limit resources"
    On Linux systems, administrators might prefer [cgroups](https://en.wikipedia.org/wiki/Cgroups) as a way of limiting resources.

    On Unix systems, memory usage can be constrained using `ulimit`, e.g.<pre><code class="language-bash">$ ulimit -v 262144</code></pre>limits virtual address space to 256MB.


## `-W` (start week)

Syntax: `-W N`
  
Start of week as an offset from Saturday. Default is 2, meaning that Monday is the start of week.


## `-z` (date format)

Syntax: `-z B`
  
Format used for `"D"$` date parsing. 0 is MM/DD/YYYY (default) and 1 is DD/MM/YYYY.

[![](../img/xkcd.tar.png)](https://xkcd.com/1168/)  
_xkcd.com_
