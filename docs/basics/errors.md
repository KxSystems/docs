---
title: Errors | Basics | kdb+ and q documentation
description: Errors signalled by the interpreter, and what triggers them
---

# :fontawesome-solid-bomb: Errors 



## Runtime errors

<table class="kx-ruled kx-shrunk kx-tight" markdown="1">
<thead markdown="1">
<tr markdown="1"><th markdown="1">error</th><th markdown="1">example</th><th markdown="1">explanation</th></tr>
</thead>
<tbody markdown="1">
<tr markdown="1"><td markdown="1">access</td> <td markdown="1"/> <td markdown="1">Tried to read files above directory, run system commands or failed usr/pwd</td> </tr>
<tr markdown="1"><td markdown="1">accp</td> <td markdown="1"/> <td markdown="1">Tried to accept an incoming TCP/IP connection but failed to do so</td> </tr>
<tr markdown="1"><td markdown="1">adict</td> <td markdown="1" class="nowrap">`d[::]:x`</td> <td markdown="1">Blocked assignment (`'nyi`)</td> </tr>
<tr markdown="1"><td markdown="1">arch</td> <td markdown="1" class="nowrap">`:test set til 100`<br/>``-17!`:test``</td> <td markdown="1">Tried to load file of wrong endian format</td> </tr>
<tr markdown="1"><td markdown="1">assign</td> <td markdown="1" class="nowrap">`cos:12`</td> <td markdown="1">Tried to redefine a reserved word</td> </tr>
<tr markdown="1"><td markdown="1">bad lambda</td> <td markdown="1" class="nowrap">`h{select x by x from x}`</td> <td markdown="1">lambda from an older version of kdb+ over IPC that no longer parses</td> </tr>
<tr markdown="1"><td markdown="1">badtail</td> <td markdown="1"/> <td markdown="1">Incomplete transaction at end of file, get good (count;length) with ``-11!(-2;`:file)``</td> </tr>
<tr markdown="1"><td markdown="1">binary mismatch</td> <td markdown="1"/> <td markdown="1">Wrong process for [code profiler](../kb/profiler.md)</td> </tr>
<tr markdown="1"><td markdown="1">can't </td> <td markdown="1"/> <td markdown="1">Only commercially licensed kdb+ instances can encrypt code in a script</td> </tr>
<tr markdown="1"><td markdown="1">cast</td> <td markdown="1" class="nowrap">``s:`a`b; c:`s$`a`e``</td> <td markdown="1">Value not in enumeration</td> </tr>
<tr markdown="1"><td markdown="1">close</td> <td markdown="1"/> <td markdown="1">content-length header missing from HTTP response</td> </tr>
<tr markdown="1"><td markdown="1">con</td> <td markdown="1"/> <td markdown="1">qcon client is not supported when kdb+ is in [multithreaded input mode](../kb/multithreaded-input.md)</td> </tr>
<tr markdown="1"><td markdown="1">cond</td> <td markdown="1"/> <td markdown="1">Even number of arguments to `$` (until V3.6 2018.12.06)</td> </tr>
<tr markdown="1"><td markdown="1">conn</td> <td markdown="1"/> <td markdown="1">Too many connections (1022 max)</td> </tr>
<tr markdown="1"><td markdown="1">Could not initialize ssl</td><td markdown="1"/><td markdown="1">[`(-26!)[]`](internal.md#-26x-ssl) found SSL/TLS not enabled</td></tr>
<tr markdown="1"><td markdown="1">d8</td><td markdown="1"/><td markdown="1">The log had a partial transaction at the end but q couldn’t truncate the file</td></tr>
<tr markdown="1"><td markdown="1">decompression error at block _b_ in _f_</td> <td markdown="1"/> <td markdown="1">Error signalled by underlying decompression routine</td> </tr>
<tr markdown="1"><td markdown="1">domain</td> <td markdown="1" class="nowrap">`til -1`</td> <td markdown="1">Out of domain</td> </tr>
<tr markdown="1"><td markdown="1">dup</td> <td markdown="1" class="nowrap">`` `a`b xasc flip`a`b`a!()``</td> <td markdown="1">Duplicate column in table (since V3.6 2019.02.19)</td> </tr>
<tr markdown="1"><td markdown="1">dup names for cols/groups</td> <td markdown="1" class="nowrap">`select a,a by a from t`</td> <td markdown="1">Name collision (since V4.0 2020.03.17)</td> </tr>
<tr markdown="1"><td markdown="1">elim</td> <td markdown="1" class="nowrap">``((-58?`3) set\:(),`a)$`a``</td> <td markdown="1">Too many enumerations (max: 57)</td> </tr>
<tr markdown="1"><td markdown="1">enable secondary threads via cmd line -s only</td> <td markdown="1" class="nowrap">`\s 4`</td> <td markdown="1">Command line enabled processes for parallel processing</td> </tr>
<tr markdown="1"><td markdown="1">encryption lib unavailable</td> <td markdown="1" class="nowrap">``-36!(`:kf;"pwd")``</td> <td markdown="1">Failed to load OpenSSL libraries</td> </tr>
<tr markdown="1"><td markdown="1">expected response</td> <td markdown="1"/> <td markdown="1">One-shot request did not receive response</td> </tr>
<tr markdown="1"><td markdown="1">failed to load TLS certificates</td><td markdown="1"/><td markdown="1">Started kdb+ [with `-E 1` or `-E 2`](cmdline.md#-e-tls-server-mode) but without SSL/TLS enabled</td> </tr>
<tr markdown="1"><td markdown="1">from</td> <td markdown="1" class="nowrap">`select price trade`</td> <td markdown="1">Badly formed select statement</td> </tr>
<!-- <tr markdown="1"><td markdown="1">glim</td> <td markdown="1"/> <td markdown="1">`` `g#`` limit (99 prior to V3.2, now unlimited</td> </tr> -->
<tr markdown="1"><td markdown="1">hop</td><td markdown="1"/><td markdown="1">Request to `hopen` a handle fails; includes message from OS</td> </tr>
<tr markdown="1"><td markdown="1">hwr</td><td markdown="1"/><td markdown="1">Handle write error, can't write inside a [`peach`](peach.md)</td> </tr>
<tr markdown="1"><td markdown="1">IJS</td> <td markdown="1" class="nowrap">`"D=\001"0:"0=hello\0011=world"`</td> <td markdown="1">[Key type](../ref/file-text.md#key-value-pairs) is not `I`, `J`, or `S`.</td> </tr>
<tr markdown="1"><td markdown="1">insert</td> <td markdown="1" class="nowrap">``t:([k:0 1]a:2 3);`t insert(0;3)``</td> <td markdown="1">Tried to [`insert`](../ref/insert.md) a record with an existing key into a keyed table</td> </tr>
<tr markdown="1"><td markdown="1">invalid</td> <td markdown="1" class="nowrap">`q -e 3`</td> <td markdown="1">Invalid command-line option value</td> </tr>
<tr markdown="1"><td markdown="1">invalid password</td> <td markdown="1" class="nowrap">``-36!(`:kf;"pwd")``</td> <td markdown="1">Invalid keyfile password</td> </tr>
<tr markdown="1"><td markdown="1">\l</td> <td markdown="1"/> <td markdown="1">Not a [data file](syscmds.md#l-load-file-or-directory)</td> </tr>
<tr markdown="1"><td markdown="1">length</td> <td markdown="1" class="nowrap">`()+til 1`</td> <td markdown="1">Arguments do not [conform](conformable.md)</td> </tr>
<tr markdown="1">
<td markdown="1">limit</td>
<td markdown="1" class="nowrap">`0W#2`</td>
<td markdown="1">
    Tried to generate a list longer than <span class="nowrap">2<sup>40</sup>-1</span>, 
    or serialized object is &gt; 1TB, 
    or `'type` if trying to serialize a nested object which has &gt; 2 billion elements,
    or :fontawesome-regular-hand-point-right: [Parse errors](#parse-errors)
</td>
</tr>
<tr markdown="1"><td markdown="1">load</td> <td markdown="1"/> <td markdown="1">Not a [data file](../ref/load.md)</td> </tr>
<tr markdown="1"><td markdown="1">loop</td> <td markdown="1" class="nowrap">`a::b::a`</td> <td markdown="1">Dependency loop</td> </tr>
<tr markdown="1"><td markdown="1">main thread only</td> <td markdown="1" class="nowrap">``-36!(`:kf;"pwd")``</td> <td markdown="1">Not executed from main thread</td> </tr>
<tr markdown="1"><td markdown="1">mismatch</td> <td markdown="1" class="nowrap">`([]a:til 4),([]b:til 3)`</td> <td markdown="1">Columns that can't be aligned for R,R or K,K</td> </tr>
<tr markdown="1"><td markdown="1">mlim</td> <td markdown="1"/> <td markdown="1">Too many nested columns in [splayed tables](../kb/splayed-tables.md). (Prior to V3.0, limited to 999; from V3.0, 251; from V3.3, 65530)</td> </tr>
<tr markdown="1"><td markdown="1">mq</td> <td markdown="1"/> <td markdown="1">Multi-threading not allowed</td> </tr>
<tr markdown="1"><td markdown="1">name&nbsp;too&nbsp;long</td> <td markdown="1"/> <td markdown="1">Filepath ≥100 chars (until V3.6 2018.09.26)</td> </tr>
<tr markdown="1"><td markdown="1">need zlib to compress</td> <td markdown="1"/> <td markdown="1">zlib not available</td> </tr>
<tr markdown="1"><td markdown="1">noamend</td> <td markdown="1" class="nowrap">`t:([]a:1 2 3)`<br />``n:`a`b`c``<br />``update b:{`n?`d;:`n?`d}[]``<br/>`` from `t``</td> <td markdown="1">Cannot change global state from within an amend</td> </tr>
<tr markdown="1"><td markdown="1">no append to zipped enums</td> <td markdown="1" class="nowrap">V2:<br/>`.z.zd:17 2 6`<br/>`` `:sym?`a`b``<br/>V3:<br/>`` `:sym?`c``</td> <td markdown="1">Cannot append to zipped enum (from V3.0)</td> </tr>
<tr markdown="1">
<td markdown="1">no `` `g#``</td>
<td markdown="1" class="nowrap">``{`g#x}peach 2#enlist 0 1``</td>
<td markdown="1">A thread other than the main q thread has attempted to add a group [attribute](syntax.md#attributes) to a vector. Seen with [`peach`](peach.md)+secondary threads or multithreaded input queue</td>
</tr>
 <tr markdown="1">
<td markdown="1">noupdate</td>
<td markdown="1" class="nowrap">`{a::x}peach 0 1`</td>
<td markdown="1">
Updates blocked by the [`-b` cmd line arg](cmdline.md#-b-blocked), 
or [`reval`](../ref/eval.md#reval) code or a thread other than the main thread has attempted to update a global variable 
when in [`peach`](peach.md)+secondary threads or multithreaded input queue. 
Update not allowed when using [negative port number](syscmds.md#p-listening-port).
</td>
</tr>
<tr markdown="1"><td markdown="1">nosocket</td> <td markdown="1" class="nowrap">Can only open or use sockets in main thread.</td> </tr>
<tr markdown="1"><td markdown="1">nyi</td> <td markdown="1" class="nowrap">`"a"like"**"`</td> <td markdown="1">Not yet implemented: it probably makes sense, but it’s not defined nor implemented, and needs more thinking about as the language evolves</td> </tr>
<tr markdown="1"><td markdown="1">os</td> <td markdown="1">`\foo bar`</td> <td markdown="1">Operating-system error or [license error](#license-errors)</td> </tr>
<tr markdown="1"><td markdown="1">par</td> <td markdown="1"/> <td markdown="1">Unsupported operation on a partitioned table or component thereof</td> </tr>
<tr markdown="1"><td markdown="1">parse</td> <td markdown="1"/> <td markdown="1">Invalid [syntax](syntax.md); bad IPC header; or bad binary data in file</td> </tr>
<tr markdown="1"><td markdown="1">part</td> <td markdown="1"/> <td markdown="1">Something wrong with the partitions in the HDB; or [`med`](../ref/med.md) applied over partitions or segments</td> </tr> 
<tr markdown="1"><td markdown="1">path too long</td> <td markdown="1">``(`$":",1000#"a") set 1 2 3``</td> <td markdown="1">File path ≥255 chars (100 before V3.6 2018.09.26)</td> </tr> 
<tr markdown="1"><td markdown="1">PKCS5_PBKDF2_HMAC</td> <td markdown="1" class="nowrap">``-36!(`:kf;"pwd")``</td> <td markdown="1">Library invocation failed</td> </tr>
<!-- <tr markdown="1"><td markdown="1">pl</td> <td markdown="1"/> <td markdown="1">[`peach`](peach.md) can’t handle parallel lambdas (V2.3 only)</td> </tr> -->
<tr markdown="1"><td markdown="1">pwuid</td> <td markdown="1"/> <td markdown="1">OS is missing libraries for `getpwuid`. (Most likely 32-bit app on 64-bit OS. Try to [install ia32-libs](../learn/install.md#step-2-put-kdb-in-qhome).)</td> </tr>
<tr markdown="1"><td markdown="1">Q7</td><td markdown="1"/><td markdown="1">nyi op on file nested array</td></tr>
<tr markdown="1"><td markdown="1">rank</td> <td markdown="1" class="nowrap">`+[2;3;4]`</td> <td markdown="1">Invalid [rank](glossary.md#rank)</td> </tr> 
<tr markdown="1"><td markdown="1">rb</td> <td markdown="1"/> <td markdown="1">Encountered a problem while doing a blocking read</td> </tr> 
<tr markdown="1"><td markdown="1">restricted</td> <td markdown="1">`0"2+3"`</td> <td markdown="1">in a kdb+ process which was started with [`-b` cmd line](cmdline.md#-b-blocked). Also for a kdb+ process using the username:password authentication file, or the `-b` cmd line option, `\x` cannot be used to reset handlers to their default. e.g. `\x .z.pg`</td> </tr> 
<tr markdown="1"><td markdown="1">s-fail</td> <td markdown="1" class="nowrap">`` `s#3 2``</td> <td markdown="1">Invalid attempt to set sorted [attribute](../ref/set-attribute.md). Also encountered with `` `s#enums`` when loading a database (`\l db`) and enum target is not already loaded.</td> </tr>
<tr markdown="1"><td markdown="1">splay</td> <td markdown="1"/> <td markdown="1">nyi op on [splayed table](../kb/splayed-tables.md)</td> </tr>
<tr markdown="1">
<td markdown="1">stack</td>
<td markdown="1" class="nowrap">`{.z.s[]}[]`</td>
<td markdown="1">Ran out of stack space. Consider using [Converge `\` `/`](../ref/accumulators.md#unary-values) instead of recursion.</td>
</tr>
<tr markdown="1"><td markdown="1">step</td> <td markdown="1" class="nowrap">``d:`s#`a`b!1 2;`d upsert `c`d!3 4``</td> <td markdown="1">Tried to upsert a step dictionary in place</td> </tr>
<tr markdown="1"><td markdown="1">stop</td> <td markdown="1"/> <td markdown="1">User interrupt (Ctrl-c) or [time limit (`-T`)](cmdline.md#-t-timeout)</td> </tr>
<tr markdown="1"><td markdown="1">stype</td> <td markdown="1" class="nowrap">`'42`</td> <td markdown="1">Invalid [type](datatypes.md) used for [Signal](../ref/signal.md)</td> </tr>
<tr markdown="1"><td markdown="1">sys</td> <td markdown="1">`{system "ls"}peach 0 1`</td> <td markdown="1">Using system call from thread other than main thread</td> </tr>
<tr markdown="1"><td markdown="1">threadview</td> <td markdown="1"/> <td markdown="1">Trying to calc a [view](../learn/views.md) in a thread other than main thread. A view can be calculated in the main thread only. The cached result can be used from other threads.</td> </tr>
<tr markdown="1"><td markdown="1">timeout</td><td markdown="1"/><td markdown="1">Request to `hopen` a handle fails on a timeout; includes message from OS</td> </tr>
<tr markdown="1"><td markdown="1">TLS not enabled</td><td markdown="1"/><td markdown="1">Received a TLS connection request, but kdb+ not [started with `-E 1` or `-E 2`](cmdline.md#-e-tls-server-mode)</td></tr>
<tr markdown="1"><td markdown="1">too many syms</td><td markdown="1"/><td markdown="1">Kdb+ currently allows for ~1.4B interned symbols in the pool and will exit with this error when this threshold is reached</td> </tr>
<tr markdown="1"><td markdown="1">trunc</td> <td markdown="1"/> <td markdown="1">The log had a partial transaction at the end but q couldn’t truncate the file</td> </tr>
<tr markdown="1"><td markdown="1">type</td> <td markdown="1" class="nowrap">`til 2.2`</td> <td markdown="1">Wrong [type](datatypes.md). Also see `'limit`</td> </tr>
<tr markdown="1"><td markdown="1">type/attr error amending file</td> <td markdown="1"/> <td markdown="1">Direct update on disk for this type or attribute is not allowed</td> </tr>
<tr markdown="1"><td markdown="1">u-fail</td> <td markdown="1" class="nowrap">`` `u#2 2``</td> <td markdown="1">Invalid attempt to set unique or parted [attribute](../ref/set-attribute.md)</td> </tr>
<tr markdown="1"><td markdown="1">unmappable</td> <td markdown="1">``t:([]sym:`a`b;a:(();()))``<br/>``.Q.dpft[`:thdb;.z.d;`sym;`t]``</td> <td markdown="1">When saving partitioned data each column must be mappable. `()` and `("";"";"")` are OK</td> </tr>
<tr markdown="1"><td markdown="1">unrecognized key format</td> <td markdown="1" class="nowrap">``-36!(`:kf;"pwd")``</td> <td markdown="1">Master keyfile format not recognized</td> </tr>
<tr markdown="1"><td markdown="1">upd</td> <td markdown="1"/> <td markdown="1">Function `upd` is undefined (sometimes encountered during ``-11!`:logfile``) _or_ [license error](#license-errors)</td> </tr>
<tr markdown="1"><td markdown="1">utf8</td> <td markdown="1"/> <td markdown="1">The websocket requires that text is UTF-8 encoded</td> </tr>
<tr markdown="1"><td markdown="1">value</td> <td markdown="1"/> <td markdown="1">No value</td> </tr>
<tr markdown="1"><td markdown="1">vd1</td> <td markdown="1"/> <td markdown="1">Attempted multithread update</td> </tr>
<tr markdown="1"><td markdown="1">view</td> <td markdown="1"/> <td markdown="1">Tried to re-assign a [view](../learn/views.md) to something else</td> </tr>
<tr markdown="1"><td markdown="1">-w abort</td> <td markdown="1"/> <td markdown="1">[`malloc`](https://en.wikipedia.org/wiki/C_dynamic_memory_allocation) hit [`-w` limit](cmdline.md#-w-workspace) or [`\w` limit](syscmds.md#w-workspace)</td> </tr>
<tr markdown="1"><td markdown="1">-w init via cmd line</td> <td markdown="1"/> <td markdown="1">Trying to allocate memory with [`\w`](syscmds.md#w-workspace) without `-w` on command line</td> </tr>
<tr markdown="1">
<td markdown="1">wsfull</td>
<td markdown="1" class="nowrap">`999999999#0`</td>
<td markdown="1">[`malloc`](https://en.wikipedia.org/wiki/C_dynamic_memory_allocation) failed, or ran out of swap (or addressability on 32-bit). The params also reported are intended to help Kx diagnose when assisting clients, and are subject to change.</td>
</tr> 
<tr markdown="1"><td markdown="1">wsm</td> <td markdown="1" class="nowrap">`010b wsum 010b`</td> <td markdown="1">Alias for nyi for `wsum` prior to V3.2</td> </tr>
<tr markdown="1"><td markdown="1">XXX</td> <td markdown="1" class="nowrap">`delete x from system "d";x`</td> <td markdown="1">Value error (`XXX` undefined)</td> </tr>
</tbody>
</table>


## System errors

From file ops and [IPC](ipc.md)

<table class="kx-ruled kx-shrunk kx-tight" markdown="1">
<thead markdown="1">
<tr markdown="1"><th markdown="1">error</th><th markdown="1">explanation</th></tr>
</thead>
<tbody markdown="1">
<tr markdown="1"><td markdown="1">Bad CPU Type</td><td markdown="1">Tried to run 32-bit interpreter in macOS 10.15+</td></tr>
<tr markdown="1"><td markdown="1">`XXX:YYY`</td><td markdown="1">`XXX` is from kdb+, `YYY` from the OS</td></tr>
</tbody>
</table>

`XXX` from addr, close, conn, p(from `-p`), snd, rcv or (invalid) filename, e.g. ``read0`:invalidname.txt``



## Parse errors
On execute or load

<table class="kx-ruled kx-shrunk kx-tight" markdown="1">
<thead markdown="1">
<tr markdown="1"><th markdown="1">error</th><th markdown="1">example</th><th markdown="1">explanation</th></tr>
</thead>
<tbody markdown="1">
<tr markdown="1"> <td markdown="1" class="nowrap">`[({])}"`</td> <td markdown="1" class="nowrap">`"hello`</td> <td markdown="1">Open `([{` or `"`</td> </tr>
<tr markdown="1"> <td markdown="1">branch</td> <td markdown="1" class="nowrap">`a:"1;",65024#"0;"`<br/>`value "{if[",a,"]}"`</td> <td markdown="1">A branch (`if`;`do`;`while`;`$[.;.;.]`) more than 65025 byte codes away (255 before V3.6 2017.09.26)</td> </tr>
<tr markdown="1"> <td markdown="1">char</td> <td markdown="1" class="nowrap">`value "\000"`</td> <td markdown="1">Invalid character (watch out for non-breaking spaces in copied expressions)</td> </tr>
<tr markdown="1"> <td markdown="1">globals</td> <td markdown="1" class="nowrap">`a:"::a"sv string til 111;`<br/>`value"{a",a,"::0}"`</td> <td markdown="1">Too many [global variables](function-notation.md#variables-and-constants)</td> </tr>
<tr markdown="1"> 
    <td markdown="1">limit</td> 
    <td markdown="1" class="nowrap">`a:";"sv string 2+til 241;`<br/>`value"{",a,"}"`</td> 
    <td markdown="1">
        Too many [constants](function-notation.md#variables-and-constants),
        or :fontawesome-regular-hand-point-right: [limit error](#runtime-errors)
    </td> 
</tr>
<tr markdown="1"> 
    <td markdown="1">locals</td> 
    <td markdown="1" class="nowrap">`a:":a"sv string til 111;`<br/>`value"{a",a,":0}"`</td>
    <td markdown="1">
        Too many [local variables](function-notation.md#variables-and-constants)
    </td> 
</tr>
<tr markdown="1"> <td markdown="1">params</td> <td markdown="1" class="nowrap">`f:{[a;b;c;d;e;f;g;h;e]}`</td> <td markdown="1">Too many parameters (8 max)</td> </tr>
</tbody>
</table>


## License errors
On launch

<table class="kx-ruled kx-shrunk kx-tight" markdown="1">
<thead markdown="1">
<tr markdown="1"><th markdown="1">error</th><th markdown="1">explanation</th></tr>
</thead>
<tbody markdown="1">
<tr markdown="1"> <td markdown="1">{timestamp} couldn't connect to license daemon</td> <td markdown="1">Could not connect to Kx license server ([kdb+ On Demand](../learn/licensing.md#licensing-server-for-kdb-on-demand))</td> </tr>
<tr markdown="1"> <td markdown="1">cores</td> <td markdown="1">The license is for [fewer cores than available](../kb/cpu-affinity.md)</td> </tr>
<tr markdown="1"> <td markdown="1">cpu</td> <td markdown="1">The license is for fewer CPUs than available</td> </tr>
<tr markdown="1"> <td markdown="1">exp</td> <td markdown="1">License expiry date is prior to system date</td> </tr>
<tr markdown="1">
<td markdown="1">host</td>
<td markdown="1">
The hostname reported by the OS does not match the hostname or hostname-pattern in the license. 
If you see `255.255.255.255` in the kdb+ banner, the machine almost certainly cannot resolve its hostname to an IP address, 
which will cause a `'host` error.
</td>
</tr>
<tr markdown="1">
<td markdown="1">k4.lic</td>
<td markdown="1">
`k4.lic` file not found, check contents of environment variables 
[`QHOME`../learn/install.md#step-2-put-kdb-in-qhome) and 
[`QLIC`](../learn/licensing.md#keeping-the-license-key-file-elsewhere)
</td>
</tr>
<tr markdown="1"> <td markdown="1">os</td><td markdown="1">Wrong OS or operating-system error (if runtime error)</td> </tr>
<tr markdown="1"> <td markdown="1">srv</td><td markdown="1">Client-only license in server mode</td> </tr>
<tr markdown="1"> <td markdown="1">upd</td><td markdown="1">Version of kdb+ more recent than update date, _or_ the function `upd` is undefined (sometimes encountered during ``-11!`:logfile``)</td> </tr>
<tr markdown="1"> <td markdown="1">user</td><td markdown="1">Unlicensed user</td> </tr>
<tr markdown="1"> <td markdown="1">wha</td><td markdown="1">System date is prior to kdb+ version date</td> </tr>
<tr markdown="1"> <td markdown="1">wrong q.k version</td><td markdown="1">`q` and `q.k` versions do not match</td> </tr>
</tbody>
</table>

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


