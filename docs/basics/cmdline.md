---
title: Command line options | Basics | kdb+ and q documentation
description: Command-line syntax for invoking q and list of the command-line options
author: Stephen Taylor
keywords: command, file, kdb+, line, option, q
---
# :fontawesome-solid-terminal: Command line




The command line for invoking kdb+ has the form:

<div markdown="1" class="typewriter">
q [[file](#file)] [-option [parameters] … ]

Options:
 [-b blocked](#-b-blocked)                    [-q quiet mode](#-q-quiet-mode)
 [-c console size](#-c-console-size)               [-r replicate](#-r-replicate)
 [-C HTTP size](#-c-http-size)                  [-s secondary threads](#-s-secondary-threads)
 [-e error traps](#-e-error-traps)                [-t timer ticks](#-t-timer-ticks)
 [-E TLS Server Mode](#-e-tls-server-mode)            [-T timeout](#-t-timeout)
 [-g garbage collection](#-g-garbage-collection)         [-u disable syscmds](#-u-disable-syscmds)
 [-l log updates](#-l-log-updates)                [-u usr-pwd local](#-u-usr-pwd-local)
 [-L log sync](#-l-log-sync)                   [-U usr-pwd](#-u-usr-pwd)
 [-m memory domain](#-m-memory-domain)              [-w workspace](#-w-workspace)
 [-o UTC offset](#-o-utc-offset)                 [-W start week](#-w-start-week)
 [-p listening port](#-p-listening-port)             [-z date format](#-z-date-format)
 [-P display precision](#-p-display-precision)                                            
</div>

:fontawesome-solid-book:
[`.z.x`](../ref/dotz.md#zx-argv) (argv),
[`.z.X`](../ref/dotz.md#zx-raw-command-line) (raw command line)


## file

This is either the script to load (\*.q, \*.k, \*.s), or a file or a directory.

```bash
$ q sp.q
KDB+ 3.5t 2017.02.28 Copyright (C) 1993-2017 Kx Systems
m32/ 4()core 8192MB sjt mint.local 192.168.0.39 NONEXPIRE
```

```q
+`p`city!(`p$`p1`p2`p3`p4`p5`p6`p1`p2;`london`london`london`london`london`lon..
(`s#+(,`color)!,`s#`blue`green`red)!+(,`qty)!,900 1000 1200
+`s`p`qty!(`s$`s1`s1`s1`s2`s3`s4;`p$`p1`p4`p6`p2`p2`p4;300 200 100 400 200 300)
q)
```

!!! warning "Operating systems may create hidden files, such as `.DS_Store`, that block loading of a directory."


## `-b` (blocked)

```txt
-b
```

Block write-access to a kdb+ database, for any handle context ([`.z.w`](../ref/dotz.md#zw-handle)) other than 0.

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

```txt
-c r c
```

Set console maximum rows and columns, default 25 80.

:fontawesome-solid-book-open:
[`\c` system command](syscmds.md#c-console-size) for detail


## `-C` (HTTP size)

```txt
-C r c
```

Set HTTP display maximum rows and columns.

:fontawesome-solid-book-open:
[`\C` system command](syscmds.md#c-http-size) for detail



## `-e` (error traps)

```txt
-e [0|1|2]
```

Sets error-trapping mode.
The default is 0 (off).

:fontawesome-solid-book-open:
[`\e` system command](syscmds.md#e-error-trap-clients) for detail



## `-E` (TLS Server Mode)

```txt
-E 0        / plain
-E 1        / plain & TLS
-E 2        / TLS only
```

Since V3.4.

:fontawesome-solid-book-open:
[`\E` system command](syscmds.md#e-tls-server-mode)
<br>
:fontawesome-solid-graduation-cap:
[SSL/TLS](../kb/ssl.md#tls-server-mode)


## `-g` (garbage collection)

```txt
-g 0        / deferred (default)
-g 1        / immediate
```

Sets garbage-collection mode.

:fontawesome-solid-book-open:
[`\g` system command](syscmds.md#g-garbage-collection-mode) for detail



## `-l` (log updates)

```txt
-l
```

Log updates to filesystem.

:fontawesome-solid-graduation-cap:
[Logging](../kb/logging.md)


## `-L` (log sync)

```txt
-L
```

As `-l`, but sync logging.

:fontawesome-solid-graduation-cap:
[Logging](../kb/logging.md)


## `-m` (memory-domain)

```txt
-m path
```

Memory can be backed by a filesystem, allowing use of DAX-enabled filesystems (e.g. AppDirect) as a non-persistent memory extension for kdb+.

This command-line option directs kdb+ to use the filesystem path specified as a separate memory domain. This splits every thread’s heap into two:

```txt
domain description
--------------------------------------------------------------------------
0      regular anonymous memory, active and used for all allocs by default
1      filesystem-backed memory
```

The [`.m` namespace](../ref/dotm.md) is reserved for objects in memory domain 1, however names from other namespaces can reference them too, e.g. `a:.m.a:1 2 3`



## `-o` (UTC offset)

```txt
-o N
```

Sets local time offset as `N` hours from UTC, or minutes if `abs[N]>23`
(Affects [`.z.Z`](../ref/dotz.md#zz-local-datetime))

:fontawesome-solid-book-open:
[`\o` system command](syscmds.md#o-offset-from-utc) for detail


## `-p` (listening port)

_Set listening port_

```txt
-p [rp,][hostname:](portnumber|servicename)
```

See 
:fontawesome-solid-book-open:
[Listening port](listening-port.md) for detail.

:fontawesome-solid-book:
[`hopen`](../ref/hopen.md)
<br>
:fontawesome-solid-book-open:
[`\p` system command](syscmds.md#p-listening-port)
<br>
:fontawesome-solid-graduation-cap:
[Multithreaded input mode](../kb/multithreaded-input.md),
[Changes in 3.5](../releases/ChangesIn3.5.md#socket-sharding)
<br>
:fontawesome-regular-map:
[Socket sharding with kdb+ and Linux](../wp/socket-sharding/index.md)



## `-P` (display precision)

```txt
-P N
```

Display precision for floating-point numbers, i.e. the number of digits shown.

:fontawesome-solid-book-open:
[`\P` system command](syscmds.md#p-precision) for detail


## `-q` (quiet mode)

```txt
-q
```

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

:fontawesome-solid-book:
[`.z.q`](../ref/dotz.md#zq-quiet-mode) (quiet mode)


## `-r` (replicate)

```txt
-r :host:port[:user[:password]]
```

Replicate from `:host:port`.

:fontawesome-solid-book-open:
[`\r` system command](syscmds.md#r-replication-master)


## `-s` (secondary threads)

```txt
-s N
```

Number of secondary threads or processes available for parallel processing.

:fontawesome-solid-book-open:
[`\s` system command](syscmds.md#s-number-of-secondary-threads) for detail



## `-t` (timer ticks)

```txt
-t N
```

Period in milliseconds between timer ticks. Default is 0, for no timer.

:fontawesome-solid-book-open:
[`\t` system command](syscmds.md#t-timer) for detail


## `-T` (timeout)

```txt
-T N
```

Timeout in seconds for client queries, i.e. maximum time a client call will execute. Default is 0, for no timeout.

:fontawesome-solid-book-open:
[`\T` system command](syscmds.md#t-timeout) for detail


## `-u` (disable syscmds)
## `-u` (usr-pwd local)
## `-U` (usr-pwd)

```txt
-u 1        / blocks system functions and file access
-U file     / sets password file, blocks \x
-u file     / both the above
```

`-u 1` disables 

-   system commands from a remote (signals `'access`), including exit via `"\\"` 
-   access to files outside the current directory for any handle context ([`.z.w`](../ref/dotz.md#zw-handle)) other than 0

??? danger "Only a simple protection against “wrong” queries"

    For example, setting a system command in `.z.ts` and starting the timer still works. The right system command could for example expose a terminal, so the user running the database could be fully impersonated and compromised from then on.

`-U file`

-   sets a password file
-   disables [`\x`](syscmds.md#x-expunge) (even on the local console)

The password file is a text file with one credential on each line.
(No trailing blank line/s.)

```txt
user1:password1
user2:password2
```

The password can be

-   plain text
-   an MD5 hash of the password
-   an SHA-1 hash of the password (since V4.0 2020.03.17)

```q
q)raze string md5 "this is my password"
"210d53992dff432ec1b1a9698af9da16"
q)raze string -33!"mypassword" / -33! calculates sha1
"91dfd9ddb4198affc5c194cd8ce6d338fde470e2"
```

:fontawesome-solid-book-open:
Internal function [`-33!`](internal.md#-33x-sha-1-hash)

`-u file` combines the above, i.e. `-u file` is equivalent to `-u 1 -U file`.


## `-w` (workspace)

```txt
-w N
```

Workspace limit in MB for the heap per thread. Default is 0: no limit.

:fontawesome-solid-book-open:
[`\w` system command](syscmds.md#w-workspace) for detail
Reference: [`.Q.w`](../ref/dotq.md#qw-memory-stats)

**Domain-local**
Since V4.0 2020.03.17 this command is no longer thread-local, but [memory domain-local](../ref/dotm.md): it sets the limit for domain 0.


!!! tip "Other ways to limit resources"

    On Linux systems, administrators might prefer [cgroups](https://en.wikipedia.org/wiki/Cgroups) as a way of limiting resources.

    On Unix systems, memory usage can be constrained using `ulimit`, e.g. <pre><code class="language-bash"> $ ulimit -v 262144 </code></pre>limits virtual address space to 256MB.


## `-W` (start week)

```txt
-W N
```

Set the start-of-week offset, where 0 is Saturday. The default is 2, i.e Monday.

:fontawesome-solid-book-open:
[`\W` system command](syscmds.md#w-week-offset) for detail


## `-z` (date format)

```txt
-z [0|1]
```

Set the format for `"D"$` date parsing: 0 for mm/dd/yyyy and 1 for dd/mm/yyyy.

:fontawesome-solid-book-open:
[`\z` system command](syscmds.md#z-date-parsing)


[![](../img/xkcd.tar.png)](https://xkcd.com/1168/)
_xkcd.com_
