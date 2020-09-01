---
title: Errors | Basics | kdb+ and q documentation
description: Errors signalled by the interpreter, and what triggers them
---

# :fontawesome-solid-bomb: Errors 



## Runtime errors

<table class="kx-ruled kx-shrunk kx-tight" markdown="1">
<thead>
<tr><th>error</th><th>example</th><th>explanation</th></tr>
</thead>
<tbody>
<tr><td>access</td> <td/> <td>Attempt to read files above directory, run system commands or failed usr/pwd</td> </tr>
<tr><td>accp</td> <td/> <td>Tried to accept an incoming TCP/IP connection but failed to do so</td> </tr>
<tr><td>adict</td> <td class="nowrap">`d[::]:x`</td> <td>Blocked assignment (`'nyi`)</td> </tr>
<tr><td>arch</td> <td class="nowrap">`:test set til 100`<br/>``-17!`:test``</td> <td>Attempt to load file of wrong endian format</td> </tr>
<tr><td>assign</td> <td class="nowrap">`cos:12`</td> <td>Attempt to redefine a reserved word</td> </tr>
<tr><td>bad lambda</td> <td class="nowrap">`h{select x by x from x}`</td> <td>lambda from an older version of kdb+ over IPC that no longer parses</td> </tr>
<tr><td>badtail</td> <td/> <td>Incomplete transaction at end of file, get good (count;length) with ``-11!(-2;`:file)``</td> </tr>
<tr><td>binary mismatch</td> <td/> <td>Wrong process for [code profiler](../kb/profiler.md)</td> </tr>
<tr><td>can't </td> <td/> <td>Only commercially licensed kdb+ instances can encrypt code in a script</td> </tr>
<tr><td>cast</td> <td class="nowrap">``s:`a`b; c:`s$`a`e``</td> <td>Value not in enumeration</td> </tr>
<tr><td>close</td> <td/> <td>content-length header missing from HTTP response</td> </tr>
<tr><td>con</td> <td/> <td>qcon client is not supported when kdb+ is in [multithreaded input mode](../kb/multithreaded-input.md)</td> </tr>
<tr><td>cond</td> <td/> <td>Even number of arguments to `$` (until V3.6 2018.12.06)</td> </tr>
<tr><td>conn</td> <td/> <td>Too many connections (1022 max)</td> </tr>
<tr><td>Could not initialize ssl</td><td/><td>[`(-26!)[]`](internal.md#-26x-ssl) found SSL/TLS not enabled</td></tr>
<tr><td>d8</td><td/><td>The log had a partial transaction at the end but q couldn’t truncate the file</td></tr>
<tr><td>decompression error at block _b_ in _f_</td> <td/> <td>Error signalled by underlying decompression routine</td> </tr>
<tr><td>domain</td> <td class="nowrap">`til -1`</td> <td>Out of domain</td> </tr>
<tr><td>dup</td> <td class="nowrap">`` `a`b xasc flip`a`b`a!()``</td> <td>Duplicate column in table (since V3.6 2019.02.19)</td> </tr>
<tr><td>dup names for cols/groups</td> <td class="nowrap">`select a,a by a from t`</td> <td>Name collision (since V4.0 2020.03.17)</td> </tr>
<tr><td>elim</td> <td class="nowrap">``((-58?`3) set\:(),`a)$`a``</td> <td>Too many enumerations (max: 57)</td> </tr>
<tr><td>enable secondary threads via cmd line -s only</td> <td class="nowrap">`\s 4`</td> <td>Command line enabled processes for parallel processing</td> </tr>
<tr><td>encryption lib unavailable</td> <td class="nowrap">``-36!(`:kf;"pwd")``</td> <td>Failed to load OpenSSL libraries</td> </tr>
<tr><td>expected response</td> <td/> <td>One-shot request did not receive response</td> </tr>
<tr><td>failed to load TLS certificates</td><td/><td>Started kdb+ [with `-E 1` or `-E 2`](cmdline.md#-e-tls-server-mode) but without SSL/TLS enabled</td> </tr>
<tr><td>from</td> <td class="nowrap">`select price trade`</td> <td>Badly formed select statement</td> </tr>
<tr><td>glim</td> <td/> <td>`` `g#`` limit (99 prior to V3.2, now unlimited</td> </tr>
<tr><td>hop</td><td/><td>Request to `hopen` a handle fails; includes message from OS</td> </tr>
<tr><td>hwr</td><td/><td>Handle write error, can't write inside a [`peach`](peach.md)</td> </tr>
<tr><td>IJS</td> <td class="nowrap">`"D=\001"0:"0=hello\0011=world"`</td> <td>[Key type](../ref/file-text.md#key-value-pairs) is not `I`, `J`, or `S`.</td> </tr>
<tr><td>insert</td> <td class="nowrap">``t:([k:0 1]a:2 3);`t insert(0;3)``</td> <td>Attempt to [`insert`](../ref/insert.md) a record with an existing key into a keyed table</td> </tr>
<tr><td>invalid</td> <td class="nowrap">`q -e 3`</td> <td>Invalid command-line option value</td> </tr>
<tr><td>invalid password</td> <td class="nowrap">``-36!(`:kf;"pwd")``</td> <td>Invalid keyfile password</td> </tr>
<tr><td>\l</td> <td/> <td>Not a [data file](syscmds.md#l-load-file-or-directory)</td> </tr>
<tr><td>length</td> <td class="nowrap">`()+til 1`</td> <td>Incompatible lengths</td> </tr>
<tr>
<td>limit</td>
<td class="nowrap">`0W#2`</td>
<td>
    Tried to generate a list longer than <span class="nowrap">2<sup>40</sup>-1</span>, 
    or serialized object is &gt; 1TB, 
    or `'type` if trying to serialize a nested object which has &gt; 2 billion elements,
    or :fontawesome-regular-hand-point-right: [Parse errors](#parse-errors)
</td>
</tr>
<tr><td>load</td> <td/> <td>Not a [data file](../ref/load.md)</td> </tr>
<tr><td>loop</td> <td class="nowrap">`a::a`</td> <td>Dependency loop</td> </tr>
<tr><td>main thread only</td> <td class="nowrap">``-36!(`:kf;"pwd")``</td> <td>Not executed from main thread</td> </tr>
<tr><td>mismatch</td> <td class="nowrap">`([]a:til 4),([]b:til 3)`</td> <td>Columns that can't be aligned for R,R or K,K</td> </tr>
<tr><td>Mlim</td> <td/> <td>Too many nested columns in [splayed tables](../kb/splayed-tables.md). (Prior to V3.0, limited to 999; from V3.0, 251; from V3.3, 65530)</td> </tr>
<tr><td>mq</td> <td/> <td>Multi-threading not allowed</td> </tr>
<tr><td>name&nbsp;too&nbsp;long</td> <td/> <td>Filepath ≥100 chars (until V3.6 2018.09.26)</td> </tr>
<tr><td>need zlib to compress</td> <td/> <td>zlib not available</td> </tr>
<tr><td>noamend</td> <td class="nowrap">`t:([]a:1 2 3)`<br />``n:`a`b`c``<br />``update b:{`n?`d;:`n?`d}[]``<br/>`` from `t``</td> <td>Cannot change global state from within an amend</td> </tr>
<tr><td>no append to zipped enums</td> <td class="nowrap">V2:<br/>`.z.zd:17 2 6`<br/>`` `:sym?`a`b``<br/>V3:<br/>`` `:sym?`c``</td> <td>Cannot append to zipped enum (from V3.0)</td> </tr>
<tr>
<td>no `` `g#``</td>
<td class="nowrap">``{`g#x}peach 2#enlist 0 1``</td>
<td>A thread other than the main q thread has attempted to add a group [attribute](syntax.md#attributes) to a vector. Seen with [`peach`](peach.md)+secondary threads or multithreaded input queue</td>
</tr>
 <tr>
<td>noupdate</td>
<td class="nowrap">`{a::x}peach 0 1`</td>
<td>
Updates blocked by the [`-b` cmd line arg](cmdline.md#-b-blocked), 
or [`reval`](../ref/eval.md#reval) code or a thread other than the main thread has attempted to update a global variable 
when in [`peach`](peach.md)+secondary threads or multithreaded input queue. 
Update not allowed when using [negative port number](syscmds.md#p-listening-port).
</td>
</tr>
<tr><td>nosocket</td> <td class="nowrap">Can only open or use sockets in main thread.</td> </tr>
<tr><td>nyi</td> <td class="nowrap">`"a"like"**"`</td> <td>Not yet implemented: it probably makes sense, but it’s not defined nor implemented, and needs more thinking about as the language evolves</td> </tr>
<tr><td>os</td> <td>`\foo bar`</td> <td>Operating-system error or [license error](#license-errors)</td> </tr>
<tr><td>par</td> <td/> <td>Unsupported operation on a partitioned table or component thereof</td> </tr>
<tr><td>parse</td> <td/> <td>Invalid [syntax](syntax.md); bad IPC header; or bad binary data in file</td> </tr>
<tr><td>part</td> <td/> <td>Something wrong with the partitions in the HDB; or [`med`](../ref/med.md) applied over partitions or segments</td> </tr> 
<tr><td>path too long</td> <td>``(`$":",1000#"a") set 1 2 3``</td> <td>File path ≥255 chars (100 before V3.6 2018.09.26)</td> </tr> 
<tr><td>PKCS5_PBKDF2_HMAC</td> <td class="nowrap">``-36!(`:kf;"pwd")``</td> <td>Library invocation failed</td> </tr>
<tr><td>pl</td> <td/> <td>[`peach`](peach.md) can’t handle parallel lambdas (V2.3 only)</td> </tr>
<tr><td>pwuid</td> <td/> <td>OS is missing libraries for `getpwuid`. (Most likely 32-bit app on 64-bit OS. Try to [install ia32-libs](../learn/install.md#step-2-put-kdb-in-qhome).)</td> </tr>
<tr><td>Q7</td><td/><td>nyi op on file nested array</td></tr>
<tr><td>rank</td> <td class="nowrap">`+[2;3;4]`</td> <td>Invalid [rank](glossary.md#rank)</td> </tr> 
<tr><td>rb</td> <td/> <td>Encountered a problem while doing a blocking read</td> </tr> 
<tr><td>restricted</td> <td>`0"2+3"`</td> <td>in a kdb+ process which was started with [`-b` cmd line](cmdline.md#-b-blocked). Also for a kdb+ process using the username:password authentication file, or the `-b` cmd line option, `\x` cannot be used to reset handlers to their default. e.g. `\x .z.pg`</td> </tr> 
<tr><td>s-fail</td> <td class="nowrap">`` `s#3 2``</td> <td>Invalid attempt to set sorted [attribute](../ref/set-attribute.md). Also encountered with `` `s#enums`` when loading a database (`\l db`) and enum target is not already loaded.</td> </tr>
<tr><td>splay</td> <td/> <td>nyi op on [splayed table](../kb/splayed-tables.md)</td> </tr>
<tr>
<td>stack</td>
<td class="nowrap">`{.z.s[]}[]`</td>
<td>Ran out of stack space. Consider using [Converge `\` `/`](../ref/accumulators.md#unary-values) instead of recursion.</td>
</tr>
<tr><td>step</td> <td class="nowrap">``d:`s#`a`b!1 2;`d upsert `c`d!3 4``</td> <td>Attempt to upsert a step dictionary in place</td> </tr>
<tr><td>stop</td> <td/> <td>User interrupt (Ctrl-c) or [time limit (`-T`)](cmdline.md#-t-timeout)</td> </tr>
<tr><td>stype</td> <td class="nowrap">`'42`</td> <td>Invalid [type](datatypes.md) used for [Signal](../ref/signal.md)</td> </tr>
<tr><td>sys</td> <td>`{system "ls"}peach 0 1`</td> <td>Using system call from thread other than main thread</td> </tr>
<tr><td>threadview</td> <td/> <td>Trying to calc a [view](../learn/views.md) in a thread other than main thread. A view can be calculated in the main thread only. The cached result can be used from other threads.</td> </tr>
<tr><td>timeout</td><td/><td>Request to `hopen` a handle fails on a timeout; includes message from OS</td> </tr>
<tr><td>TLS not enabled</td><td/><td>Received a TLS connection request, but kdb+ not [started with `-E 1` or `-E 2`](cmdline.md#-e-tls-server-mode)</td></tr>
<tr><td>too many syms</td><td/><td>Kdb+ currently allows for ~1.4B interned symbols in the pool and will exit with this error when this threshold is reached</td> </tr>
<tr><td>trunc</td> <td/> <td>The log had a partial transaction at the end but q couldn’t truncate the file</td> </tr>
<tr><td>type</td> <td class="nowrap">`til 2.2`</td> <td>Wrong [type](datatypes.md). Also see `'limit`</td> </tr>
<tr><td>type/attr error amending file</td> <td/> <td>Direct update on disk for this type or attribute is not allowed</td> </tr>
<tr><td>u-fail</td> <td class="nowrap">`` `u#2 2``</td> <td>Invalid attempt to set unique or parted [attribute](../ref/set-attribute.md)</td> </tr>
<tr><td>unmappable</td> <td>``t:([]sym:`a`b;a:(();()))``<br/>``.Q.dpft[`:thdb;.z.d;`sym;`t]``</td> <td>When saving partitioned data each column must be mappable. `()` and `("";"";"")` are OK</td> </tr>
<tr><td>unrecognized key format</td> <td class="nowrap">``-36!(`:kf;"pwd")``</td> <td>Master keyfile format not recognized</td> </tr>
<tr><td>upd</td> <td/> <td>Function `upd` is undefined (sometimes encountered during ``-11!`:logfile``) _or_ [license error](#license-errors)</td> </tr>
<tr><td>utf8</td> <td/> <td>The websocket requires that text is UTF-8 encoded</td> </tr>
<tr><td>value</td> <td/> <td>No value</td> </tr>
<tr><td>vd1</td> <td/> <td>Attempted multithread update</td> </tr>
<tr><td>view</td> <td/> <td>Tried to re-assign a [view](../learn/views.md) to something else</td> </tr>
<tr><td>-w abort</td> <td/> <td>[`malloc`](https://en.wikipedia.org/wiki/C_dynamic_memory_allocation) hit [`-w` limit](cmdline.md#-w-workspace) or [`\w` limit](syscmds.md#w-workspace)</td> </tr>
<tr><td>-w init via cmd line</td> <td/> <td>Trying to allocate memory with [`\w`](syscmds.md#w-workspace) without `-w` on command line</td> </tr>
<tr>
<td>wsfull</td>
<td class="nowrap">`999999999#0`</td>
<td>[`malloc`](https://en.wikipedia.org/wiki/C_dynamic_memory_allocation) failed, or ran out of swap (or addressability on 32-bit). The params also reported are intended to help Kx diagnose when assisting clients, and are subject to change.</td>
</tr> 
<tr><td>wsm</td> <td class="nowrap">`010b wsum 010b`</td> <td>Alias for nyi for `wsum` prior to V3.2</td> </tr>
<tr><td>XXX</td> <td class="nowrap">`delete x from system "d";x`</td> <td>Value error (`XXX` undefined)</td> </tr>
</tbody>
</table>


## System errors

From file ops and [IPC](ipc.md)

<table class="kx-ruled kx-shrunk kx-tight" markdown="1">
<thead>
<tr><th>error</th><th>explanation</th></tr>
</thead>
<tbody>
<tr><td>Bad CPU Type</td><td>Tried to run 32-bit interpreter in macOS 10.15+</td></tr>
<tr><td>`XXX:YYY`</td><td>`XXX` is from kdb+, `YYY` from the OS</td></tr>
</tbody>
</table>

`XXX` from addr, close, conn, p(from `-p`), snd, rcv or (invalid) filename, e.g. ``read0`:invalidname.txt``



## Parse errors
On execute or load

<table class="kx-ruled kx-shrunk kx-tight" markdown="1">
<thead>
<tr><th>error</th><th>example</th><th>explanation</th></tr>
</thead>
<tbody>
<tr> <td class="nowrap">`[({])}"`</td> <td class="nowrap">`"hello`</td> <td>Open `([{` or `"`</td> </tr>
<tr> <td>branch</td> <td class="nowrap">`a:"1;",65024#"0;"`<br/>`value "{if[",a,"]}"`</td> <td>A branch (`if`;`do`;`while`;`$[.;.;.]`) more than 65025 byte codes away (255 before V3.6 2017.09.26)</td> </tr>
<tr> <td>char</td> <td class="nowrap">`value "\000"`</td> <td>Invalid character</td> </tr>
<tr> <td>globals</td> <td class="nowrap">`a:"::a"sv string til 111;`<br/>`value"{a",a,"::0}"`</td> <td>Too many [global variables](function-notation.md#variables-and-constants)</td> </tr>
<tr> 
    <td>limit</td> 
    <td class="nowrap">`a:";"sv string 2+til 241;`<br/>`value"{",a,"}"`</td> 
    <td>
        Too many [constants](function-notation.md#variables-and-constants),
        or :fontawesome-regular-hand-point-right: [limit error](#runtime-errors)
    </td> 
</tr>
<tr> 
    <td>locals</td> 
    <td class="nowrap">`a:":a"sv string til 111;`<br/>`value"{a",a,":0}"`</td>
    <td>
        Too many [local variables](function-notation.md#variables-and-constants)
    </td> 
</tr>
<tr> <td>params</td> <td class="nowrap">`f:{[a;b;c;d;e;f;g;h;e]}`</td> <td>Too many parameters (8 max)</td> </tr>
</tbody>
</table>


## License errors
On launch

<table class="kx-ruled kx-shrunk kx-tight" markdown="1">
<thead>
<tr><th>error</th><th>explanation</th></tr>
</thead>
<tbody>
<tr> <td>{timestamp} couldn't connect to license daemon</td> <td>Could not connect to Kx license server ([kdb+ On Demand](../learn/licensing.md#licensing-server-for-kdb-on-demand))</td> </tr>
<tr> <td>cores</td> <td>The license is for [fewer cores than available](../kb/cpu-affinity.md)</td> </tr>
<tr> <td>cpu</td> <td>The license is for fewer CPUs than available</td> </tr>
<tr> <td>exp</td> <td>License expiry date is prior to system date</td> </tr>
<tr>
<td>host</td>
<td>
The hostname reported by the OS does not match the hostname or hostname-pattern in the license. 
If you see `255.255.255.255` in the kdb+ banner, the machine almost certainly cannot resolve its hostname to an IP address, 
which will cause a `'host` error.
</td>
</tr>
<tr>
<td>k4.lic</td>
<td>
`k4.lic` file not found, check contents of environment variables 
[`QHOME`../learn/install.md#step-2-put-kdb-in-qhome) and 
[`QLIC`](../learn/licensing.md#keeping-the-license-key-file-elsewhere)
</td>
</tr>
<tr> <td>os</td><td>Wrong OS or operating-system error (if runtime error)</td> </tr>
<tr> <td>srv</td><td>Client-only license in server mode</td> </tr>
<tr> <td>upd</td><td>Version of kdb+ more recent than update date, _or_ the function `upd` is undefined (sometimes encountered during ``-11!`:logfile``)</td> </tr>
<tr> <td>user</td><td>Unlicensed user</td> </tr>
<tr> <td>wha</td><td>System date is prior to kdb+ version date</td> </tr>
<tr> <td>wrong q.k version</td><td>`q` and `q.k` versions do not match</td> </tr>
</tbody>
</table>

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


