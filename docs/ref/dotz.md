---
title: the .z namespace | Reference | kdb+ and q documentation
description: The .z namespace contains objects that return or set system information, and callbacks for IPC.
author: Stephen Taylor
keywords: callbacks, environment, kdb+, q
---
# :fontawesome-regular-clock: The `.z` namespace



_Environment and callbacks_

<div markdown="1" class="typewriter">
Environment                        Callbacks
 [.z.a    IP address](#za-ip-address)                 [.z.ac    HTTP auth from cookie](#zac-http-auth-from-cookie)
 [.z.b    dependencies](#zb-dependencies)               [.z.bm    msg validator](#zbm-msg-validator)
 [.z.c    cores](#zc-cores)                      [.z.exit  action on exit](#zexit-action-on-exit)
 [.z.D/d  date shortcuts](#zt-zt-zd-zd-timedate-shortcuts)             [.z.pc    close](#zpc-close)
 [.z.e    TLS connection status](#ze-tls-connection-status)      [.z.pd    peach handles](#zpd-peach-handles)
 [.z.ex   failed primitive](#zex-failed-primitive)           [.z.pg    get](#zpg-get)
 [.z.ey   arg to failed primitive](#zey-argument-to-failed-primitive)    [.z.ph    HTTP get](#zph-http-get)
 [.z.f    file](#zf-file)                       [.z.pi    input](#zpi-input)
 [.z.H    active sockets](#zh-active-sockets)             [.z.po    open](#zpo-open)
 [.z.h    host](#zh-host)                       [.z.pp    HTTP post](#zpp-http-post)
 [.z.i    PID](#zi-pid)                        [.z.pq    qcon](#zpq-qcon)
 [.z.K    version](#zk-version)                    [.z.ps    set](#zps-set)
 [.z.k    release date](#zk-release-date)               [.z.pw    validate user](#zpw-validate-user)
 [.z.l    license](#zl-license)                    [.z.ts    timer](#zts-timer)
 [.z.N/n  local/UTC timespan](#zn-local-timespan)         [.z.vs    value set](#zvs-value-set)
 [.z.o    OS version](#zo-os-version)                 [.z.wc    WebSocket close](#zwc-websocket-close)
 [.z.P/p  local/UTC timestamp](#zp-local-timestamp)        [.z.wo    WebSocket open](#zwo-websocket-open)
 [.z.pm   HTTP options](#zpm-http-options)               [.z.ws    WebSockets](#zws-websockets)
 [.z.q    quiet mode](#zq-quiet-mode)
 [.z.s    self](#zs-self)
 [.z.T/t  time shortcuts](#zt-zt-zd-zd-timedate-shortcuts)
 [.z.u    user ID](#zu-user-id)
 [.z.W/w  handles/handle](#zw-handles)
 [.z.X/x  raw/parsed command line](#zx-raw-command-line)
 [.z.Z/z  local/UTC datetime](#zz-local-datetime)
 [.z.zd   zip defaults](#zzd-zip-defaults)
</div>

The `.z` [namespace](../basics/namespaces.md) contains environment variables and functions, and hooks for callbacks.
??? warning "The `.z` namespace is reserved for use by Kx, as are all single-letter namespaces."

    Consider all undocumented functions in the namespace as exposed infrastructure – and do not use them.

??? tip "By default, callbacks are not defined in the session" 

    After they have been assigned, you can restore the default using [`\x`](../basics/syscmds.md#x-expunge) to delete the definition that was made.

:fontawesome-solid-graduation-cap:
[Callbacks](../kb/callbacks.md),
[Using `.z`](../kb/using-dotz.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals:_ 
[§11.6 Interprocess Communication](/q4m3/11_IO/#116-interprocess-communication)





## `.z.a` (IP address)

The IP address as a 32-bit integer

```q
q).z.a
-1062731737i
```

It can be split into components as follows:

```q
q)"i"$0x0 vs .z.a
127 0 0 1
```

!!! warning "Callbacks"

    When invoked inside a `.z.p*` callback via a TCP/IP connection, it is the IP address of the client session, not the current session.

    When invoked via a Unix Domain Socket, it is 0.


## `.z.ac` (HTTP auth from cookie)

```txt
.z.ac:(requestText;requestHeaderAsDictionary)
```

Lets you define custom code to extract Single Sign On (SSO) token cookies from the HTTP header and verify it, decoding and returning the username, or instructing what action to take.

```q
q).z.ac:{mySSOAuthenticator x[1]`Authorization}
```

where allowed return values are

```q
(0;"")              / return default 401
(1;"username")      / authenticated username (.z.u becomes this)
(2;"response text") / send raw response text to client
```

and `mySSOAuthenticator` is your custom code that authenticates against your SSO library.

Note that if `.z.ac` is defined, `.z.pw` will _not_ be called for HTTP connections for authentication.

:fontawesome-solid-hand-point-right:
[`.z.pw` password check](#zpw-validate-user)


## `.z.b` (dependencies)

The dependency dictionary.

```q
q)a::x+y
q)b::x+1
q).z.b
x| `a`b
y| ,`a
```

:fontawesome-solid-book-open:
[`\b`](../basics/syscmds.md#b-views)


## `.z.bm` (msg validator)

```txt
.z.bm:x
```

Where `x` is a unary function.

Kdb+ before V2.7 was sensitive to being fed malformed data structures, sometimes resulting in a crash, but now validates incoming IPC messages to check that data structures are well formed, reporting `'badmsg` and disconnecting senders of malformed data structures. The raw message is captured for analysis via the callback `.z.bm`. The sequence upon receiving such a message is

1.  calls `.z.bm` with a 2-item list: `(handle;msgBytes)`
2.  close the handle and call `.z.pc`
3.  signals `'badmsg`

E.g. with the callback defined

```q
q).z.bm:{`msg set (.z.p;x);}
```

after a bad msg has been received, the global var `msg` will contain the timestamp, the handle and the full message. Note that this check validates only the data structures, it cannot validate the data itself.


## `.z.c` (cores)

The number of physical cores.


## `.z.e` (TLS connection status)

TLS connection status.

```q
q)0N!h".z.e";
`CIPHER`PROTOCOL!`AES128-GCM-SHA256`TLSV1.2
```

Since V3.4 2016.05.16.


## `.z.ex` (failed primitive)

In a [debugger](../basics/debug.md#debugger) session, `.z.ex` is set to the failed primitive.

Since V3.5 2017.03.15.


## `.z.exit` (action on exit)

```txt
.z.exit:f
```

Where `f` is a unary function, `f` is called with the exit parameter as the argument just before exiting the kdb+ session.

The exit parameter is the argument to the [`exit`](exit.md) function, or 0 if manual exit with [`\\` quit](../basics/syscmds.md#quit)

!!! important "The handler cannot cancel the exit."

`.z.exit` can be unset with `\x .z.exit`, which restores the default behavior.

The default behavior is equivalent to setting `.z.exit` to `{}`, i.e. do nothing.

```q
q).z.exit
'.z.exit
q).z.exit:{0N!x}
q)\\
0
os>..

q).z.exit:{0N!x}
q)exit 42
42
os>..

q).z.exit:{0N!x}
q)exit 0
0
```

```bash
os>..
```

If the exit behavior has an error (disk full for example if exit tries to save the current state), the session is suspended and exits after completion or manual exit from the suspension.

```q
q).z.exit:{`thiswontwork+x}
q)\\
{`thiswontwork+x}
'type
+
`thiswontwork
0
q))x
0

q))'`up
'up
```

```bash
os>..
```

:fontawesome-solid-hand-point-right:
[`.z.pc` port close](#zpc-close)
<br>
:fontawesome-solid-book:
[`exit`](exit.md)
<br>
:fontawesome-solid-book-open:
[`\\` quit](../basics/syscmds.md#quit)


## `.z.ey` (argument to failed primitive)

In a [debugger](../basics/debug.md#debugger) session, `.z.ey` is set to the argument to failed primitive.

Since V3.5 2017.03.15.


## `.z.f` (file)

Name of the q script as a symbol.

```q
$ q test.q
q).z.f
`test.q
```

:fontawesome-solid-hand-point-right:
[`.z.x` argv](#zx-argv)


## `.z.H` (active sockets)

Active sockets as a list. (A low-cost method.)

Since v4.0 2020.06.01.

```q
q).z.H~key .z.W
1b
```

:fontawesome-solid-book-open:
[`-38!` socket table](../basics/internal.md#-38x-socket-table)


## `.z.h` (host)

The host name as a symbol

```q
q).z.h
`demo.kx.com
```

On Linux this should return the same as the shell command `hostname`. If you require a fully qualified domain name, and the `hostname` command returns a hostname only (with no domain name), this should be resolved by your system administrators. Often this can be traced to the ordering of entries in `/etc/hosts`, e.g.

Non-working `/etc/host` looks like :

```txt
127.0.0.1      localhost.localdomain localhost
192.168.1.1  myhost.mydomain.com myhost
```

Working one has this ordering :

```txt
127.0.0.1      localhost.localdomain localhost
192.168.1.1  myhost myhost.mydomain.com
```

One solution seems to be to flip around the entries, i.e. so the entries should be

```txt
ip hostname fqdn
```

A workaround from within kdb+ is

```q
q).Q.host .z.a
```


## `.z.i` (PID)

The process ID as an integer.

```q
q).z.i
23219
```


## `.z.K` (version)

The major version number, as a float, of the version of kdb+ being used.
(A test version of 2.4t is reported as 2.4)

```q
q).z.K
2.4
q).z.k
2006.10.30
```

:fontawesome-solid-hand-point-right:
[`.z.k` release date](#zk-release-date)


## `.z.k` (release date)

Date on which the version of kdb+ being used was released.

```q
q).z.k
2006.10.30
q)
```

This value is checked against `.Q.k` as part of the startup to make sure that the executable and the version of q.k being used are compatible.

:fontawesome-solid-hand-point-right:
[`.z.K` version](#zk-version)


## `.z.l` (license)

License information as a list of strings; `()` for non-commercial 32-bit versions.

```q
q)`maxCoresAllowed`expiryDate`updateDate`````bannerText`!.z.l
maxCoresAllowed| ""
expiryDate     | "2021.05.27"
updateDate     | "2021.05.27"
               | ,"1"
               | ,"1"
               | ,"1"
               | ,"0"
bannerText     | "stephen@kx.com #59875"
               | ,"0"
```

`bannerText` is the custom text displayed at startup, and always contains the license number as the last token.


## `.z.N` (local timespan)

System local time as timespan in nanoseconds.
<!-- (V2.6 upwards.) -->

```q
q).z.N
0D23:30:10.827156000
```


## `.z.n` (UTC timespan)

System UTC time as timespan in nanoseconds.
<!-- (V2.6 upwards.) -->

```q
q).z.n
0D23:30:10.827156000
```


## `.z.o` (OS version)

Kdb+ operating system version as a symbol.

```q
q).z.o
`w32
```

Values for V3.5+ are shown below in bold type.

os               | 32-bit  | 64-bit
-----------------|---------|--------
Linux            | **l32** | **l64**
macOS            | **m32** | **m64**
Solaris          | s32     | s64
Solaris on Intel | **v32** | **v64**
Windows          | **w32** | **w64**

Note this is the version of the kdb+ executable, NOT the OS itself. 
You might run both 32-bit and 64-bit versions of kdb+ on the same machine to support older external interfaces.


## `.z.P` (local timestamp)

System localtime timestamp in nanoseconds.
<!-- (Since V2.6.) -->

```q
q).z.P
2018.04.30D10:18:31.932126000
```


## `.z.p` (UTC timestamp)

UTC timestamp in nanoseconds.
<!-- (Since V2.6.) -->

```q
q).z.p
2018.04.30D09:18:38.117667000
```


## `.z.pc` (close)

```txt
.z.pc:f
```

Where `f` is a unary function, `.z.pc` is called _after_ a connection has been closed.

As the connection has been closed by the time `f` is called there are strictly no remote values that can be put into [`.z.a`](#za-ip-address), [`.z.u`](#zu-user-id) or [`.z.w`](#zw-handle) – so the local values are returned.

To allow you to clean up things like tables of users keyed by handle, the handle that _was_ being used is passed as a parameter to `.z.pc`

```q
KDB+ 2.3 2007.03.27 Copyright (C) 1993-2007 Kx Systems
l64/ 8cpu 16026MB simon ...

q).z.pc
'.z.pc
q).z.pc:{0N!(.z.a;.z.u;.z.w;x);x}
q)\p 2021
q)(2130706433;`simon;0;4)

q).z.a
2130706433
q).z.u
`simon
q).z.w
0
q)
```

!!! info "`.z.pc` is not called by `hclose`."


## `.z.pd` (peach handles)

```txt
.z.pd: x
```

Where q has been [started with secondary processes for use in parallel processing](../basics/cmdline.md#-s-secondarys),  `x` is

-    an int vector of handles to secondary processes
-    a function that returns a list of handles to those secondary processes

For evaluating the function passed to `peach` or `':`, kdb+ gets the handles to the secondary processes by calling [`.z.pd[]`](#zpd-peach-handles).

??? danger "The processes with these handles must not be used for other messaging."

    Each Parallel will close them if it receives anything other than a response message.

```q
q)/open connections to 4 processes on the localhost
q).z.pd:`u#hopen each 20000+til 4
```

The int vector (returned by) `x` _must_ have the [unique attribute](set-attribute.md) set.

A more comprehensive setup might be

```q
q).z.pd:{n:abs system"s";$[n=count handles;handles;[hclose each handles;:handles::`u#hopen each 20000+til n]]}
q).z.pc:{handles::`u#handles except x;}
q)handles:`u#`int$();
```

Note that (since V3.1) the worker processes are not started automatically by kdb+.

:fontawesome-graduation-cap:
[Load balancing](../kb/load-balancing.md)


## `.z.pg` (get)

```txt
.z.pg:f
```

Where `f` is a unary function, called with the object that is passed to the q session via a synchronous request. The return value, if any, is returned to the calling task.

`.z.pg` can be unset with `\x .z.pg`, which restores the default behavior.

The default behavior is equivalent to setting `.z.pg` to [`value`](value.md) and executes in the root context.

:fontawesome-solid-hand-point-right:
[`.z.ps`](#zps-set)


## `.z.ph` (HTTP get)

```txt
.z.ph:f
```

Where `f` is a unary function, it is evaluated when a synchronous HTTP request is received by the kdb+ session.

`.z.ph` is passed a single argument, a 2-item list `(requestText;requestHeaderAsDictionary)`:

- `requestText` is parsed in `.z.ph` – detecting special cases like requests for CSV, XLS output – and the result is returned to the calling task. Since V3.6 and V3.5 2019.11.13 [`.h.val`](doth.md#hval-value) is called instead of `value`, allowing users to interpose their own valuation code.
- `requestHeaderAsDictionary` contains information such as the user agent and can be used to return content optimized for particular browsers.

```q
q)\c 43 75
q).last.ph
    | ::
when| 2007.08.16T12:20:32.681
u   | `
w   | 5
a   | 2130706433
x   | k){$[~#x:uh x:$[@x;x;*x];fram[$.z.f;x]("?";"?",*x:$."\\v");"?"=*x;..
y   | (,"?";`Accept-Language`Accept-Encoding`Cookie`Referer`User-Agent`A..
r   | "<html><head><style>a{text-decoration:none}a:link{color:024C7E}a:v..
q).last.ph.y
,"?"
`Accept-Language`Accept-Encoding`Cookie`Referer`User-Agent`Accept`Connec..
q).last.ph.y 0
,"?"
q).last.ph.y 1
Accept-Language| "en-us"
Accept-Encoding| "gzip, deflate"
Cookie         | "defaultsymbol=AAPL"
Referer        | "http://localhost:5001/"
User-Agent     | "Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-us) Appl..
Accept         | "text/xml,application/xml,application/xhtml+xml,text/ht..
Connection     | "keep-alive"
Host           | "localhost:5001"
```

:fontawesome-solid-hand-point-right:
[`.z.pp` port post](#zpp-http-post)
<br>
:fontawesome-solid-book:
[`.h` namespace](doth.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.7.1 HTTP Connections](/q4m3/11_IO/#1171-http-connections)


## `.z.pi` (input)

```txt
.z.pi:f
```

Where `f` is a unary function, it is evaluated as the default handler for input.

As this is called on every line of input it can be used to log all console input, or even to modify the output. For example, if you prefer the more compact [V2.3 way of formatting tables](../releases/ChangesIn2.4.md#zpi), you can reset the output handler.

```q
q)aa:([]a:1 2 3;b:11 22 33)
q)aa
a b
----
1 11
2 22
3 33
q).z.pi:{0N!value x;}
q)aa
+`a`b!(1 2 3;11 22 33)
q)
```

To return to the default display, just delete your custom handler

```q
q)\x .z.pi
```



## `.z.pm` (HTTP options)

```txt
.z.pm:f
```

HTTP OPTIONS method are passed to `f` as a 3-list:

```q
(OPTIONS;requestText;requestHeaderDict)
```



## `.z.po` (open)

```txt
.z.po:f
```

Where `f` is a unary function, `.z.po` is evaluated when a connection to a kdb+ session has been initialized, i.e. after it’s been validated against any `-u/-U` file and `.z.pw` checks.

Its argument is the handle and is typically used to build a dictionary of handles to session information like the value of `.z.a`, `.z.u`

:fontawesome-solid-hand-point-right:
[`.z.pc` port close](#zpc-close),
[`.z.pw` validate user](#zpw-validate-user)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.6 Interprocess Communication](/q4m3/11_IO/#116-interprocess-communication)


## `.z.pp` (HTTP post)

```txt
.z.pp:f
```

Where `f` is a unary function, `.z.pp` is evaluated when an HTTP POST request is received in the kdb+ session.

There is no default implementation, but an example would be that it calls [`value`](value.md) on the first item of its argument and returns the result to the calling task.

See `.z.ph` for details of the argument.

:fontawesome-solid-book:
[`.h` namespace](doth.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.7.1 HTTP Connections](/q4m3/11_IO/#1171-http-connections)


## `.z.pq` (qcon)

```txt
.z.pq:f
```

Remote connections using the ‘qcon’ text protocol are routed to `.z.pq`, which defaults to calling `.z.pi`. (Since V3.5+3.6 2019.01.31.)

This allows a user to handle remote qcon connections (via `.z.pq`) without defining special handling for console processing (via `.z.pi`).

:fontawesome-solid-graduation-cap:
[Firewalling](../kb/firewalling.md) for locking down message handlers


## `.z.ps` (set)

```txt
.z.ps:f
```

Where `f` is a nary function, `.z.ps` is evaluated with the object that is passed to this kdb+ session via an asynchronous request. The return value is discarded.

`.z.ps` can be unset with `\x .z.ps`, which restores the default behavior.

The default behavior is equivalent to setting `.z.ps` to [`value`](value.md).

Note that `.z.ps` is used in preference to `.z.pg` when messages are sent to the local process using handle 0.

```q
q).z.ps:{[x]0N!(`zps;x);value x}
q).z.pg:{[x]0N!(`zpg;x);value x}
q)0 "2+2"
(`zps;"2+2")
4
```

:fontawesome-solid-hand-point-right:
[`.z.pg`](#zpg-get)


## `.z.pw` (validate user)

```txt
.z.pw:f
```

Where `f` is a binary function, `.z.pw` is evaluated _after_ the `-u/-U` checks, and _before_ `.z.po` when opening a new connection to a kdb+ session.

The arguments are the user ID (as a symbol) and password (as a string) to be verified; the result is a boolean atom.

As `.z.pw` is simply a function it can be used to implement rules such as “ordinary users can sign on only between 0800 and 1800 on weekdays” or can go out to external resources like an LDAP directory.

If `.z.pw` returns `0b` the task attempting to establish the connection will get an `'access` error.

The default definition is `{[user;pswd]1b}`

:fontawesome-solid-hand-point-right:
[`.z.po` port open](#zpo-open)
<br>
:fontawesome-solid-book:
[Changes in 2.4](../releases/ChangesIn2.4.md#zpw)


## `.z.q` (quiet mode)

`1b` if Quiet Mode is set, else `0b`.

:fontawesome-solid-book-open:
[Command-line option `-q`](../basics/cmdline.md#-q-quiet-mode)


## `.z.s` (self)

A reference to the current function.

```q
q){.z.s}[]
{.z.s}
```

Can be used to generate recursive function calls.

```q
q)fact:{$[x<=0;1;x*.z.s x-1]}
q)fact[5]
120
```

Note this is purely an example; there are other ways to achieve the same result.


## `.z.ts` (timer)

```txt
.z.ts:f
```

Where `f` is a unary function, `.z.ts` is evaluated on intervals of the timer variable set by system command `\t`.

```q
q)/ set the timer to 1000 milliseconds
q)\t 1000
q)/ argument x is the timestamp scheduled for the callback
q)/ .z.ts is called once per second and returns the timestamp
q).z.ts:{0N!x}
q)2010.12.16D17:12:12.849442000
2010.12.16D17:12:13.849442000
2010.12.16D17:12:14.849442000
2010.12.16D17:12:15.849442000
2010.12.16D17:12:16.849442000
```

When kdb+ has completed executing a script passed as a command-line argument, and if there are no open sockets nor a console, kdb+ will exit. The timer alone is not enough to stop the process exiting – it must have an event source which is a file descriptor (socket, console, or some plugin registering a file descriptor and callback via the C API `sd1` function).

:fontawesome-solid-book-open:
[`\t`](../basics/syscmds.md#t-timer)


## `.z.u` (user ID)

User ID, as a symbol, associated with the current handle.

```q
q).z.u
`demo
```

For

-   handle 0 (console) returns the userid under which the process is running.
-   handles > 0 returns either:
    -   on the server end of a connection, the userid as passed to `hopen` by the client
    -   on the client end of a connection, the null symbol `` ` ``

```q
q).z.u                  / console is handle 0
`charlie
q)0".z.u"               / explicitly using handle 0
`charlie
q)h:hopen`:localhost:5000:geoffrey:geffspasswd
q)h".z.u"               / server side .z.u is as passed by the client to hopen
`geoffrey
q)h({.z.w".z.u"};::)    / client side returns null symbol
`
```


## `.z.vs` (value set)

```txt
.z.vs:f
```

Where `f` is a binary function, `.z.vs` is evaluated _after_ a value is set globally in the default namespace (e.g. `a`, `a.b`): `x` is the symbol of the variable that is being modified and `y` is the index. This is not triggered for function-local variables, nor globals that are not in the default namespace (e.g. those prefixed with a dot such as .a.b) .

The following example sets `.z.vs` to display the symbol, the index and the value of the variable.

```q
q).z.vs:{0N!(x;y;value x)}
q)m:(1 2;3 4)
(`m;();(1 2;3 4))
q)m[1;1]:0
(`m;1 1;(1 2;3 0))
```


## `.z.W` (handles)

Dictionary of IPC handles with the number of bytes waiting in their output queues.
<!-- (Since V2.5 2008.12.31.) In V2.6 this was changed to a list of bytes per handle, see [Changes in V2.6](../releases/ChangesIn2.6.md#zw) -->

```q
q)h:hopen ...
q)h
3
q)neg[h]({};til 1000000); neg[h]({};til 10); .z.W
3| 4000030 70
q)sum each .z.W
3| 0
```


## `.z.w` (handle)

Connection handle; 0 for current session console.

```q
q).z.w
0i
```

!!! warning "Inside a `.z.p`* callback it returns the handle of the client session, not the current session."


## `.z.wc` (websocket close)

```txt
.z.wc:f
```

Where `f` is a unary function, `.z.wc` is evaluated _after_ a websocket connection has been closed.
(Since V3.3t 2014.11.26.)

As the connection has been closed by the time `.z.wc` is called there are strictly no remote values that can be put into `.z.a`, `.z.u` or `.z.w` so the local values are returned.

To allow you to clean up things like tables of users keyed by handle the handle that _was_ being used is passed as a parameter to `.z.wc`.

:fontawesome-solid-hand-point-right:
[`.z.po` port open](#zpo-open),
[`.z.pc` port close](#zpc-close),
[`.z.pw` validate user](#zpw-validate-user)


## `.z.wo` (websocket open)

```txt
.z.wo:f
```

Where `f` is a unary function, `.z.wo` is evaluated when a websocket connection to a kdb+ session has been initialized, i.e. _after_ it's been validated against any `-u`/`-U` file and `.z.pw` checks.
(Since V3.3t 2014.11.26)

The argument is the handle and is typically used to build a dictionary of handles to session information like the value of `.z.a`, `.z.u`.

:fontawesome-solid-hand-point-right:
[`.z.wc` websocket close](#zwc-websocket-close),
[`.z.po` port open](#zpo-open),
[`.z.pc` port close](#zpc-close),
[`.z.pw` validate user](#zpw-validate-user)


## `.z.ws` (websockets)

```txt
z.ws:f
```

Where `f` is a unary function, `.z.ws` is evaluated on a message arriving at a websocket. If the incoming message is a text message the argument is a string; if a binary message, a byte vector.

Sending a websocket message is limited to async messages only (sync is `'nyi`). A string will be sent as a text message; a byte vector as a binary message.

The default definition is to echo the message back to the client, i.e. `{neg[.z.w]x}`

:fontawesome-solid-book-open:
[Interprocess communication ](../basics/ipc.md)
<br>
:fontawesome-solid-graduation-cap:
[WebSockets](../kb/websockets.md)
<br>
:fontawesome-regular-map:
[Kdb+ and WebSockets](../wp/websockets/index.md)


## `.z.X` (raw command line)

```txt
.z.X
```

Returns a list of strings of the raw, unfiltered command line with which kdb+ was invoked, including the name under which q was invoked, as well as single-letter arguments.
(Since V3.3 2015.02.12)

```bash
$ q somefile.q -customarg 42 -p localhost:17200
```

```q
KDB+ 3.4 2016.09.22 Copyright (C) 1993-2016 Kx Systems
m64/ 4()core 8192MB ...
q).z.X
,"q"
"somefile.q"
"-customarg"
"42"
"-p"
"localhost:17200"
```


## `.z.x` (argv)

Command-line arguments as a list of strings

```q
$ q test.q -P 0 -abc 123
q).z.x
("-abc";"123")
```

Note that the script name and the single-letter options used by q itself are not included.

Command-line options can be converted to a dictionary using the convenient `.Q.opt` function.

```bash
$ q -abc 123 -xyz 321
```

```q
q).Q.opt .z.x
abc| "123"
xyz| "321"
```

Defaults and types can be provided with `.Q.def`.

```bash
$ q -abc 123 -xyz 321
```

```q
q).Q.def[`abc`xyz`efg!(1;2.;`a)].Q.opt .z.x
abc| 123
xyz| 321f
efg| `a
q)\\
```

```bash
$ q -abc 123 -xyz 321 -efg foo
```

```q
q).Q.def[`abc`xyz`efg!(1;2.;`a)].Q.opt .z.x
abc| 123
xyz| 321f
efg| `foo
```

:fontawesome-solid-hand-point-right:
[`.z.f` file](#zf-file)


## `.z.Z` (local datetime)

Local time as a datetime atom.

```q
q).z.Z
2006.11.13T21:16:14.601
```

The offset from UTC is fetched from the OS: kdb+ does not have its own time-offset database.

Which avoids problems like [this](https://it.slashdot.org/story/07/02/25/2038217/software-bug-halts-f-22-flight).


## `.z.z` (UTC datetime)

UTC time as a datetime atom.

```q
q).z.z
2006.11.13T21:16:14.601
```
??? detail "`z.z` calls `gettimeofday` and so has microsecond precision"

    Unfortunately shoved into a 64-bit float.


## `.z.zd` (zip defaults)

```txt
.z.zd:(lbs;alg;lvl)
```

Integers `lbs`, `alg`, and `lvl` are [compression parameters](../kb/file-compression.md#compression-parameters).
They set default values for logical block size, compression algorithm and compression level that apply when saving to files with no file extension.

```q
q).z.zd:17 2 6        / set zip defaults
q)\x .z.zd            / clear zip defaults
```

:fontawesome-solid-book:
[`set`](get.md#set)
<br>
:fontawesome-solid-database:
[File compression](../kb/file-compression.md)
<br>
:fontawesome-regular-map:
[Compression in kdb+](../wp/compress/index.md)


## `.z.T` `.z.t` `.z.D` `.z.d` (time/date shortcuts)

Shorthand forms:

```txt
.z.T  `time$.z.Z     .z.D  `date$.z.Z
.z.t  `time$.z.z     .z.d  `date$.z.z
```








