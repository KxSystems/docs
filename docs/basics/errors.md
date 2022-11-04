---
title: Errors | Basics | kdb+ and q documentation
description: Errors signalled by the interpreter, and what triggers them
---

# :fontawesome-solid-bomb: Errors



## Runtime errors

<style>dt {color:#F23A66}</style>

access

:   Tried to read files above directory, run system commands or failed usr/pwd</td> </tr>

accp

:   Tried to accept an incoming TCP/IP connection but failed to do so

adict

:   E.g. `d[::]:x`

:   Blocked assignment (`'nyi`)

arch

:   E.g.
    ```q
    `:test set til 100
    -17!`:test
    ```

    Tried to load file of wrong endian format

assign

:   E.g. `cos:12`

    Tried to redefine a reserved word

bad lambda

:   E.g. `h{select x by x from x}`

    lambda from an older version of kdb+ over IPC that no longer parses

badtail

:   Incomplete transaction at end of file, get good (count;length) with ``-11!(-2;`:file)``

binary mismatch

:   Wrong process for [code profiler](../kb/profiler.md)

can't

:   Only commercially licensed kdb+ instances can encrypt code in a script

cast

:   E.g. ``s:`a`b; c:`s$`a`e``

    Value not in enumeration

close

:   (1) content-length header missing from HTTP response

    (2) handle: n – handle was closed by the remote while a msg was expected

con

:   qcon client is not supported when kdb+ is in [multithreaded input mode](../kb/multithreaded-input.md)

cond

:   Even number of arguments to `$` (until V3.6 2018.12.06)

conn

:   Too many connections (1022 max)

Could not initialize ssl

:   [`(-26!)[]`](internal.md#-26x-ssl) found SSL/TLS not enabled

d8

:   The log had a partial transaction at the end but q couldn’t truncate the file

decompression error at block [b] in 

:   Error signalled by underlying decompression routine

domain

:   E.g. `til -1`

    Out of domain

dup

:   E.g. `` `a`b xasc flip`a`b`a!()``

    Duplicate column in table (since V3.6 2019.02.19)

dup names for cols/groups

:   E.g. `select a,a by a from t`

    Name collision (since V4.0 2020.03.17)

elim

:   E.g. ``((-58?`3) set\:(),`a)$`a``

    Too many enumerations (max: 57)

empty

: The paths listed in `par.txt` do not contain any partitions or are inaccessible.

enable secondary threads via cmd line -s only

:   E.g. `\s 4`

    Command line enabled processes for parallel processing

encryption lib unavailable

:   E.g. ``-36!(`:kf;"pwd")``

    Failed to load OpenSSL libraries

expected response

:   One-shot request did not receive response

failed to load TLS certificates

:   Started kdb+ [with `-E 1` or `-E 2`](cmdline.md#-e-tls-server-mode) but without SSL/TLS enabled

from

:   E.g. `select price trade`

    Badly formed select query

hop

:   Request to `hopen` a handle fails; includes message from OS

hwr

:   Handle write error, can’t write inside a [`peach`](peach.md)

IJS

:   E.g. `"D=\001"0:"0=hello\0011=world"`

    [Key type](../ref/file-text.md#key-value-pairs) is not `I`, `J`, or `S`.

insert

:   E.g. ``t:([k:0 1]a:2 3);`t insert(0;3)``

    Tried to [`insert`](../ref/insert.md) a record with an existing key into a keyed table

invalid

:   E.g. `q -e 3`

    Invalid command-line option value

invalid password

:   E.g. ``-36!(`:kf;"pwd")``

    Invalid keyfile password

\l

:   Not a [data file](syscmds.md#l-load-file-or-directory)

length

:   E.g. `()+til 1`

    Arguments do not [conform](conformable.md)

limit

:   E.g.`0W#2`

    Tried to generate a list longer than <span>2<sup>40</sup>-1</span>,
    or serialized object is &gt; 1TB,
    or `'type` if trying to serialize a nested object which has &gt; 2 billion elements,
    or :fontawesome-regular-hand-point-right: [Parse errors](#parse-errors)

load

:   Not a [data file](../ref/load.md)

loop

:   E.g. `a::b::a`

:   Dependency loop

main thread only

:   E.g. ``-36!(`:kf;"pwd")``

:   Not executed from main thread

mismatch

:   E.g. `([]a:til 4),([]b:til 3)`

:   Columns that can’t be aligned for `R,R` or `K,K`

mlim

:   Too many nested columns in [splayed tables](../kb/splayed-tables.md).
    (Prior to V3.0, limited to 999; from V3.0, 251; from V3.3, 65530)

mq

:   Multi-threading not allowed

name too long

:   Filepath ≥100 chars (until V3.6 2018.09.26)

need zlib to compress

:   zlib not available

noamend

:   E.g.
    ```q
    t:([]a:1 2 3)
    n:`a`b`c
    update b:{`n?`d;:`n?`d}[] from `t
    ```

:   Cannot change global state from within an amend

no append to zipped enums

:   E.g. `` `:sym?`c``

:   Cannot append to zipped enum (from V3.0)

no `` `g#``

:   E.g. ``{`g#x}peach 2#enlist 0 1``

:    A thread other than the main q thread has attempted to add a group [attribute](syntax.md#attributes) to a vector.
    Seen with [`peach`](peach.md)+secondary threads or multithreaded input queue

noupdate

:   E.g. `{a::x}peach 0 1`

:    Updates blocked by the [`-b` cmd line arg](cmdline.md#-b-blocked),
    or [`reval`](../ref/eval.md#reval) code or a thread other than the main thread has attempted to update a global variable
    when in [`peach`](peach.md)+secondary threads or multithreaded input queue.
    Update not allowed when using [negative port number](syscmds.md#p-listening-port).

nosocket

:   Can only open or use sockets in main thread.

nyi

:   E.g. `"a"like"**"`

:   Not yet implemented: it probably makes sense, but it’s not defined nor implemented, and needs more thinking about as the language evolves

os

:   E.g. `\foo bar`

:   Operating-system error or [license error](#license-errors)

par

:   Unsupported operation on a partitioned table or component thereof

parse

:   Invalid [syntax](syntax.md); bad IPC header; or bad binary data in file

part

:   Something wrong with the partitions in the HDB; or [`med`](../ref/med.md) applied over partitions or segments

path too long

:   E.g. ``(`$":",1000#"a") set 1 2 3``

:   File path ≥255 chars (100 before V3.6 2018.09.26)

PKCS5_PBKDF2_HMAC

:   E.g. ``-36!(`:kf;"pwd")``

:    Library invocation failed

pwuid

:   OS is missing libraries for `getpwuid`.
    (Most likely 32-bit app on 64-bit OS. Try to [install ia32-libs](../learn/install.md#step-2-put-kdb-in-qhome).)

Q7

:   nyi op on file nested array

rank

:   E.g. `+[2;3;4]`

:   Invalid [rank](glossary.md#rank)

rb

:   Encountered a problem while doing a blocking read

restricted

:   E.g. `0"2+3"` in a kdb+ process which was started with [`-b` cmd line](cmdline.md#-b-blocked).

:   Also for a kdb+ process using the username:password authentication file,
    or the `-b` cmd line option, `\x` cannot be used to reset handlers to their default.
    e.g. `\x .z.pg`

s-fail

:   E.g. `` `s#3 2``

:   Invalid attempt to set sorted [attribute](../ref/set-attribute.md).
    Also encountered with `` `s#enums`` when loading a database (`\l db`) and enum target is not already loaded.

splay

:   nyi op on [splayed table](../kb/splayed-tables.md)

stack

:   E.g. `{.z.s[]}[]`

:   Ran out of stack space.
    Consider using [Converge `\` `/`](../ref/accumulators.md#unary-values) instead of recursion.

step

:   E.g. ``d:`s#`a`b!1 2;`d upsert `c`d!3 4``

    Tried to upsert a step dictionary in place

stop

:   User interrupt (Ctrl-c) or [time limit (`-T`)](cmdline.md#-t-timeout)

stype

:   E.g. `'42`

:   Invalid [type](datatypes.md) used for [Signal](../ref/signal.md)

sys

:   E.g. `{system "ls"}peach 0 1`

:   Using system call from thread other than main thread

threadview

:   Trying to calc a [view](../learn/views.md) in a thread other than main thread. A view can be calculated in the main thread only. The cached result can be used from other threads.

timeout

:   Request to `hopen` a handle fails on a timeout; includes message from OS

TLS not enabled

:   Received a TLS connection request, but kdb+ not [started with `-E 1` or `-E 2`](cmdline.md#-e-tls-server-mode)

too many syms

:   Kdb+ currently allows for about 1.4B interned symbols in the pool
    and will exit with this error when this threshold is reached


trunc

:   The log had a partial transaction at the end but q couldn’t truncate the file

type

:   E.g. `til 2.2`

:   Wrong [type](datatypes.md). Also see `limit`

type/attr error amending file

:   Direct update on disk for this type or attribute is not allowed

u-fail

:   E.g. `` `u#2 2``

:   Invalid attempt to set unique or parted [attribute](../ref/set-attribute.md)

unmappable

:   E.g.
    ```q
    t:([]sym:`a`b;a:(();()))
    .Q.dpft[`:thdb;.z.d;`sym;`t]
    ```

:   When saving partitioned data each column must be mappable. `()` and `("";"";"")` are OK

unrecognized key format

:   E.g. ``-36!(`:kf;"pwd")``

:   Master keyfile format not recognized

upd

:   Function `upd` is undefined (sometimes encountered during ``-11!`:logfile``) _or_ [license error](#license-errors)

utf8

:   The websocket requires that text is UTF-8 encoded

value

:   No value

vd1

:   Attempted multithread update

view

:   Tried to re-assign a [view](../learn/views.md) to something else

-w abort

:   [`malloc`](https://en.wikipedia.org/wiki/C_dynamic_memory_allocation) hit [`-w` limit](cmdline.md#-w-workspace) or [`\w` limit](syscmds.md#w-workspace)

-w init via cmd line

:   Trying to allocate memory with [`\w`](syscmds.md#w-workspace) without `-w` on command line

wsfull

:   E.g. `999999999#0`

:   [`malloc`](https://en.wikipedia.org/wiki/C_dynamic_memory_allocation) failed, or ran out of swap (or addressability on 32-bit).
    The params also reported are intended to help KX diagnose when assisting clients, and are subject to change.

wsm

:   E.g. `010b wsum 010b`

:   Alias for `nyi` for `wsum` prior to V3.2

XXX

:   E.g. `delete x from system "d";x`

:   Value error (`XXX` undefined)



## System errors

From file ops and [IPC](ipc.md)

error        | explanation
-------------|------------
Bad CPU Type | Tried to run 32-bit interpreter in macOS 10.15+
`XXX:YYY`    | `XXX` is from kdb+, `YYY` from the OS

`XXX` from addr, close, conn, p(from `-p`), snd, rcv or (invalid) filename, e.g. ``read0`:invalidname.txt``



## Parse errors
On execute or load

error | example / explanation
------|----------------------
`[({])}"` | `"hello`<br><br>Open `([{` or `"`
branch | `a:"1;",65024#"0;"`<br/>`value "{if[",a,"]}"`<br><br>A branch (`if`;`do`;`while`;`$[.;.;.]`) more than 65025 byte codes away<br>(255 before V3.6 2017.09.26)
char | `value "\000"`<br><br>Invalid character (watch out for non-breaking spaces in copied expressions)
globals | `a:"::a"sv string til 111;`<br/>`value"{a",a,"::0}"`<br><br>Too many [global variables](function-notation.md#variables-and-constants)
limit | `a:";"sv string 2+til 241;`<br/>`value"{",a,"}"`<br><br>Too many [constants](function-notation.md#variables-and-constants), or :fontawesome-regular-hand-point-right: [limit error](#runtime-errors)
locals | `a:":a"sv string til 111;`<br/>`value"{a",a,":0}"`<br><br>Too many [local variables](function-notation.md#variables-and-constants)
params | `f:{[a;b;c;d;e;f;g;h;e]}`<br><br>Too many parameters (8 max)


## License errors
On launch

error | explanation
------|------------
{timestamp} couldn't connect to license daemon | Could not connect to KX license server ([kdb+ On Demand](../learn/licensing.md#licensing-server-for-kdb-on-demand))
cores | The license is for [fewer cores than available](../kb/cpu-affinity.md)
cpu | The license is for fewer CPUs than available
exp | License expiry date is prior to system date
host | The hostname reported by the OS does not match the hostname or hostname-pattern in the license.<br><br>If you see `255.255.255.255` in the kdb+ banner, the machine almost certainly cannot resolve its hostname to an IP address, which will cause a `host` error.
k4.lic | `k4.lic` file not found, check contents of environment variables [`QHOME`](../learn/install.md#step-2-put-kdb-in-qhome) and [`QLIC`](../learn/licensing.md#keeping-the-license-key-file-elsewhere)
os | Wrong OS or operating-system error (if runtime error)
srv | Client-only license in server mode
upd | Version of kdb+ more recent than update date, _or_ the function `upd` is undefined (sometimes encountered during ``-11!`:logfile``)
user | Unlicensed user
wha | System date is prior to kdb+ version date
wrong q.k version | `q` and `q.k` versions do not match


License-related errors are reported with the prefix `licence error: ` since V4.0 2019.10.22.

:fontawesome-solid-graduation-cap:
[Licensing](../learn/licensing.md)


## Handling errors

Use system command [`\` (abort)](syscmds.md#terminate) to clear one level off the execution stack.

Keyword [`exit`](../ref/exit.md) terminates the kdb+ process.

Use hook [`.z.exit`](../ref/dotz.md#zexit-action-on-exit) to set a callback on process exit.

Use [Signal](../ref/signal.md) to signal errors.

Use [Trap and Trap At](../ref/apply.md#trap) to trap errors.

:fontawesome-solid-book-open:
[Debugging](debug.md)


<!-- :fontawesome-regular-hand-point-right: Simon’s list :fontawesome-brands-github: [simongarland/help/texts/errors.txt](https://github.com/simongarland/help/blob/master/texts/errors.txt) -->


