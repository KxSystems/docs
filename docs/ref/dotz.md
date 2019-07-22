---
title: the .z namespace
description: The .z namespace contains objects that return or set system information, and callbacks for IPC.
author: Stephen Taylor
keywords: callbacks, environment, kdb+, q
---
# The .z namespace





The `.z` [namespace](../basics/namespaces.md) contains environment variables and functions, and hooks for callbacks. 

!!! warning "Reserved"

    The `.Q` namespace is reserved for use by Kx, as are all single-letter namespaces. 

    Consider all undocumented functions in the namespace as exposed infrastructure – and do not use them. 

```txt
System information                Callbacks
 .z.a    IP address                .z.ac    HTTP auth from cookie
 .z.b    dependencies              .z.bm    msg validator
 .z.c    cores                     .z.exit  action on exit
 .z.D/d  date shortcuts            .z.pc    close
 .z.e    TLS connection status     .z.pd    peach handles
 .z.ex   failed primitive          .z pg    get
 .z.ey   arg to failed primitive   .z.ph    HTTP get
 .z.f    file                      .z.pi    input
 .z.h    host                      .z.po    open
 .z.i    PID                       .z.pp    HTTP post
 .z.K    version                   .z.pq    qcon
 .z.k    release date              .z.ps    set
 .z.l    license                   .z.pw    validate user
 .z.N/n  local/UTC timespan        .z.ts    timer
 .z.o    OS version                .z.vs    value set
 .z.P/p  local/UTC timestamp       .z.wc    WebSocket close
 .z.pm   HTTP options              .z.wo    WebSocket open
 .z.q    quiet mode                .z.ws    WebSocket
 .z.s    self
 .z.T/t  time shortcuts
 .z.u    user ID
 .z.W/w  handles/handle
 .z.X/x  raw/parsed command line 
 .z.Z/z  local/UTC datetime
 .z.zd   zip defaults
```


!!! tip "Resetting callback defaults"

    By default, callbacks are not defined in the session. After they have been assigned, you can restore the default using [`\x`](../basics/syscmds.md#x-expunge) to delete the definition that was made.

<i class="far fa-hand-point-right"></i> 
Knowledge Base: [Callbacks](../kb/callbacks.md), 
[Using `.z`](../kb/using-dotz.md)  
_Q for Mortals:_ [§11.6 Interprocess Communication](/q4m3/11_IO/#116-interprocess-communication)




## `.z.a` (IP address)

Syntax: `.z.a`

Returns the IP address as a 32-bit integer

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

    When called inside a `.z.p?` callback it is the IP address of the client session, not the current session.


## `.z.ac` (HTTP auth from cookie)

_HTTP authenticate from cookie_ 

Syntax: `z.ac:x`

Where `x` is a 2-item list `(requestText;requestHeaderAsDictionary)`
allows users to define custom code to extract Single Sign On (SSO) token cookies from the HTTP header and verify it, decoding and returning the username, or instructing what action to take.

```q
q).z.ac:{mySSOAuthenticator x[1]`Authorization}
```

where allowed return values are

```q
(0;"") / return default 401
(1;"username") / authenticated username (.z.u becomes this)
(2;"response text") / send raw response text to client
```

and `mySSOAuthenticator` is your custom code that authenticates against your SSO library.

Note that if `.z.ac` is defined, `.z.pw` will _not_ be called for HTTP connections for authentication.

<i class="far fa-hand-point-right"></i> 
[`.z.pw` password check](#zpw-validate-user)


## `.z.b` (dependencies)

Syntax: `z.b`

Returns the dependency dictionary.

```q
q)a::x+y
q)b::x+1
q).z.b
x| `a`b
y| ,`a
```

<i class="far fa-hand-point-right"></i> 
[`\b`](../basics/syscmds.md#b-views)


## `.z.bm` (msg validator)

Syntax: `z.bm:x`

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

Syntax: `.z.c`

Returns number of physical cores. 


## `.z.e` (TLS connection status)

Syntax: `.z.e`

TLS connection status now reported via `.z.e`

```q
q)0N!h".z.e";
`CIPHER`PROTOCOL!`AES128-GCM-SHA256`TLSV1.2
```

Since V3.4 2016.05.16.


## `.z.ex` (failed primitive)

Syntax: `.z.ex`

In a [debugger](../basics/debug.md#debugger) session, `.z.ex` is set to the failed primitive.

Since V3.5 2017.03.15.


## `.z.exit` (action on exit)

Syntax: `z.exit:f`

Where `f` is a unary function, `f` is called with the exit parameter as the argument just before exiting the kdb+ session.

The exit parameter is the argument to the [`exit`](exit.md) function, or 0 if manual exit with [`\\` quit](../basics/syscmds.md#quit)

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

If the exit behaviour has an error (disk full for example if exit tries to save the current state), the session is suspended and exits after completion or manual exit from the suspension.

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
<i class="far fa-hand-point-right"></i> 
[`.z.pc` port close](#zpc-close)  
[`exit`](exit.md)
Basics: [`\\` quit](../basics/syscmds.md#quit)


## `.z.ey` (argument to failed primitive)

Syntax: `.z.ey`

In a [debugger](../basics/debug.md#debugger) session, `.z.ey` is set to the argument to failed primitive.

Since V3.5 2017.03.15.


## `.z.f` (file)

Syntax: `.z.f`

Returns the name of the q script as a symbol.

```q
$ q test.q
q).z.f
`test.q
```

<i class="far fa-hand-point-right"></i> 
[`.z.x` argv](#zx-argv)


## `.z.h` (host)

Syntax: `.z.h`

Returns the host name as a symbol

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

Syntax: `.z.i`

Returns the process ID as an integer.

```q
q).z.i
23219
```


## `.z.K` (version)

Syntax: `.z.K`

Returns as a float the major version number of the version of kdb+ being used (so a test version of 2.4t will be reported as 2.4)

```q
q).z.K
2.4
q).z.k
2006.10.30
```

<i class="far fa-hand-point-right"></i> 
[`.z.k` release date](#zk-release-date)


## `.z.k` (release date)

Syntax: `.z.k`

Returns the date on which the version of kdb+ being used was released.

```q
q).z.k
2006.10.30
q)
```

This value is checked against `.Q.k` as part of the startup to make sure that the executable and the version of q.k being used are compatible.

<i class="far fa-hand-point-right"></i> 
[`.z.K` version](#zk-version)


## `.z.l` (license)

Syntax: `.z.l`

Returns the license information as a list of strings; `()` for PLAY mode (non-commercial 32-bit versions 2.5 onwards).

```q
q).z.l
("8";"2007.09.01";"2007.09.01";,"1";,"1";,"1";,"0";"text #4NNNN")
```

The important fields are `(maxCoresAllowed;expiryDate;updateDate;…;bannerText)`.

`bannerText` is the custom text displayed at startup, and always contains the license number as the last token.


## `.z.N` (local timespan)

Syntax: `.z.N`

Returns system local time as timespan in nanoseconds.
(V2.6 upwards.)

```q
q).z.N
0D23:30:10.827156000
```


## `.z.n` (UTC timespan)

Syntax: `.z.n`

Returns system UTC time as timespan in nanoseconds.
(V2.6 upwards.)

```q
q).z.n
0D23:30:10.827156000
```


## `.z.o` (OS version)

Syntax: `.z.o`

Returns the kdb+ operating system version as a symbol.

```q
q).z.o
`w32
```

Values for V3.5 are shown below in bold type.

os               | 32-bit  | 64-bit
-----------------|---------|--------
Linux            | **l32** | **l64**
macOS            | **m32** | **m64**
Solaris          | s32     | s64
Solaris on Intel | **v32** | **v64**
Windows          | **w32** | **w64**

Note this is the version of the kdb+ executable, NOT the OS itself. You may be running both 32-bit and 64-bit versions of kdb+ on the same machine to support older external interfaces.


## `.z.P` (local timestamp)

Syntax: `.z.P`

Returns system localtime timestamp in nanoseconds. 
(Since V2.6.)

```q
q).z.P
2018.04.30D10:18:31.932126000
```


## `.z.p` (UTC timestamp)

Syntax: `.z.p`

Returns UTC timestamp in nanoseconds. 
(Since V2.6.)

```q
q).z.p
2018.04.30D09:18:38.117667000
```


## `.z.pc` (close)

Syntax: `.z.pc:f`

Where `f` is a unary function, `.z.pc` is called _after_ a connection has been closed.

As the connection has been closed by the time `f` is called there are strictly no remote values that can be put into .z.a, .z.u or .z.w – so the local values are returned.

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


## `.z.pd` (peach handles)

Syntax: `.z.pd: x`

Where q has been [started with slave processes for use in parallel processing](../basics/cmdline.md#-s-slaves),  `x` is 

-    an int vector of handles to slave processes
-    a function that returns a list of handles to those slave processes

For evaluating the function passed to `peach` or `':`, kdb+ gets the handles to the slave processes by calling [`.z.pd[]`](#zpd-peach-handles). 

!!! warning "Slaves to peach"

    The processes with these handles must not be used for other messaging; Parallel Each will close them if it receives anything other than a response message.

```q
q)/open connections to 4 processes on the localhost 
q).z.pd:`u#hopen each 20000+til 4
```

The int vector (returned by) `x` _must_ have the `` `u`` attribute set.

A more comprehensive setup might be

```q
q).z.pd:{n:abs system"s";$[n=count handles;handles;[hclose each handles;:handles::`u#hopen each 20000+til n]]}
q).z.pc:{handles::`u#handles except x;}
q)handles:`u#`int$();
```

Note that (since V3.1) the worker processes are not started automatically by kdb+.

<i class="far fa-hand-point-right"></i> 
Knowledge Base: [Load balancing](../kb/load-balancing.md)


## `.z.pg` (get)

Syntax: `.z.pg:f`

Where `f` is a unary function, called with the object that is passed to the q session via a synchronous request. The return value, if any, is returned to the calling task.

`.z.pg` can be unset with `\x .z.pg`, which restores the default behavior.

The default behavior is equivalent to setting `.z.pg` to [`value`](value.md) and executes in the root context.

<i class="far fa-hand-point-right"></i> 
[`.z.ps`](#zps-set)


## `.z.ph` (HTTP get)

Syntax: `.z.ph:f`

Where `f` is a unary function, it is evaluated when a synchronous HTTP request is received by the kdb+ session.

`.z.ph` is passed a single argument, a 2-item list `(requestText;requestHeaderAsDictionary)`:

- `requestText` is parsed in `.z.ph` – detecting special cases like requests for CSV, XLS output – and the result is returned to the calling task.
- `requestHeaderAsDictionary` contains information such as the user agent and can be used to return content optimised for particular browsers

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

<i class="far fa-hand-point-right"></i> 
[`.z.pp` port post](#zpp-http-post)  
[`.h` namespace](doth.md)


## `.z.pi` (input)

Syntax: `.z.pi:f`

Where `f` is a unary function, it is evaluated as the default handler for input.

As this is called on every line of input it can be used to log all console input, or even to modify the output. For example, if you prefer the more compact V2.3 way of formatting tables, you can reset the output handler.

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

<i class="far fa-hand-point-right"></i> 
Releases: [Changes in V2.4](../releases/ChangesIn2.4.md#zpi)


## `.z.pm` (HTTP options)

Pass HTTP OPTIONS method through to `.z.pm` as (`` `OPTIONS;requestText;requestHeaderDict)``

==FIXME==


## `.z.po` (open)

Syntax: `.z.po:f`

Where `f` is a unary function, `.z.po` is evaluated when a connection to a kdb+ session has been initialized, i.e. after it’s been validated against any `-u/-U` file and `.z.pw` checks.

Its argument is the handle and is typically used to build a dictionary of handles to session information like the value of `.z.a`, `.z.u`

<i class="far fa-hand-point-right"></i> 
[`.z.pc` port close](#zpc-close), 
[`.z.pw` validate user](#zpw-validate-user)


## `.z.pp` (HTTP post)

Syntax: `.z.pp:f`

Where `f` is a unary function, `.z.pp` is evaluated when an HTTP POST request is received in the kdb+ session.

There is no default implementation, but an example would be that it calls [`value`](value.md) on the first item of its argument and returns the result to the calling task.

See `.z.ph` for details of the argument.

<i class="far fa-hand-point-right"></i> 
[`.h` namespace](doth.md)


## `.z.pq` (qcon)

Syntax: `.z.pq:f`

Since V3.5+3.6 2019.01.31, remote connections using the "qcon" text protocol are routed to `.z.pq`, which defaults to calling `.z.pi`.

This allows a user to handle remote qcon connections (via `.z.pq`) without defining special handling for console processing (via `.z.pi`).

<i class="far fa-hand-point-right"></i> 
Knowledge Base: 
[Firewalling](../kb/firewalling.md) for locking down message handlers.


## `.z.ps` (set)

Syntax: `.z.ps:f`

Where `f` is a unary function, `.z.ps` is evaluated with the object that is passed to this kdb+ session via an asynchronous request. The return value is discarded.

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

<i class="far fa-hand-point-right"></i> 
[`.z.pg`](#zpg-get)


## `.z.pw` (validate user)

Syntax: `.z.pw:f`

Where `f` is a unary function, `.z.pw` is evaluated _after_ the `-u/-U` checks, and _before_ `.z.po` when opening a new connection to a kdb+ session.

The parameters are the user ID (as a symbol) and password (as a string) to be verified, the result is a boolean atom.

As `.z.pw` is simply a function it can be used to implement rules such as “ordinary users can sign on only between 0800 and 1800 on weekdays” or can go out to external resources like an LDAP directory.

If `.z.pw` returns `0b` the task attempting to establish the connection will get an `'access` error.

The default definition is `{[user;pswd]1b}`

<i class="far fa-hand-point-right"></i> 
[`.z.po` port open](#zpo-open),  
Releases: [Changes in 2.4](../releases/ChangesIn2.4.md#zpw)


## `.z.q` (quiet mode)

Syntax: `.z.q`

Returns `1b` if Quiet Mode is set, else `0b`.

<i class="far fa-hand-point-right"></i>
[Command-line option `-q`](../basics/cmdline.md#-q-quiet-mode)


## `.z.s` (self)

Syntax: `.z.s`

Returns the current function.

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


## `.z.ts` (timer )

Syntax: `.z.ts:f`

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

<i class="far fa-hand-point-right"></i> 
[`\t`](../basics/syscmds.md#t-timer)


## `.z.u` (user ID)

Syntax: `.z.u`

Returns the userid associated with the current handle.

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

Syntax: `.z.vs:f`

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

Syntax: `.z.W`

Returns a dictionary of IPC handles with the number of bytes waiting in their output queues.
(Since V2.5 2008.12.31.) In V2.6 this was changed to a list of bytes per handle, see [Changes in V2.6](../releases/ChangesIn2.6.md#zw)

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

Syntax: `.z.w`

Returns the connection handle, 0 for current session console. 

```q
q).z.w
0i
```

!!! warning "Callbacks" 

    When called inside a `.z.p?` callback it is the handle of the client session, not the current session.


## `.z.wc` (websocket close)

Syntax: `.z.wc:f`

Where `f` is a unary function, `.z.wc` is evaluated _after_ a websocket connection has been closed. 
(Since V3.3t 2014.11.26.)

As the connection has been closed by the time `.z.wc` is called there are strictly no remote values that can be put into `.z.a`, `.z.u` or `.z.w` so the local values are returned.

To allow you to clean up things like tables of users keyed by handle the handle that _was_ being used is passed as a parameter to `.z.wc`.

<i class="far fa-hand-point-right"></i> 
[`.z.po` port open](#zpo-open), 
[`.z.pc` port close](#zpc-close), 
[`.z.pw` validate user](#zpw-validate-user)


## `.z.wo` (websocket open)

Syntax: `.z.wo:f`

Where `f` is a unary function, `.z.wo` is evaluated when a websocket connection to a kdb+ session has been initialized, i.e. _after_ it's been validated against any `-u`/`-U` file and `.z.pw` checks.
(Since V3.3t 2014.11.26)

The argument is the handle and is typically used to build a dictionary of handles to session information like the value of `.z.a`, `.z.u`.

<i class="far fa-hand-point-right"></i> 
[`.z.wc` websocket close](#zwc-websocket-close), 
[`.z.po` port open](#zpo-open), 
[`.z.pc` port close](#zpc-close), 
[`.z.pw` validate user](#zpw-validate-user)


## `.z.ws` (websockets)

Syntax: `z.ws:f`

Where `f` is a unary function, `.z.ws` is evaluated on a message arriving at a websocket. If the incoming message is a text message the argument is a string; if a binary message, a byte vector.

Sending a websocket message is limited to async messages only (sync is `'nyi`). A string will be sent as a text message; a byte vector as a binary message.

The default definition is to echo the message back to the client, i.e. `{neg[.z.w]x}`


## `.z.X` (raw command line)

Syntax: `.z.X`

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

Syntax: `.z.x`

Returns the command line arguments as a list of strings

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

<i class="far fa-hand-point-right"></i> 
[`.z.f` file](#zf-file)


## `.z.Z` (local datetime)

Syntax: `.z.Z`

Returns local time as a datetime atom.

```q
q).z.Z
2006.11.13T21:16:14.601
```

The offset from UTC is fetched from the OS: kdb+ does not have its own time-offset database. 

Which avoids problems like [this](http://it.slashdot.org/article.pl?sid=07/02/25/2038217).


## `.z.z` (UTC datetime)

Syntax: `.z.z`

Returns UTC time as a datetime atom.

```q
q).z.Z
2006.11.13T21:16:14.601
```

!!! note "Precision"

    `z.z` calls `gettimeofday` and so has microsecond precision. (Unfortunately shoved into a 64-bit float.)


## `.z.zd` (zip defaults)

Syntax: `.z.zd:x`

Where `x` is an int vector of default parameters for logical block size, compression algorithm and compression level that apply when saving to files with no file extension.

```q
q).z.zd:17 2 6        / set zip defaults
q)\x .z.zd            / unset 
```

<i class="far fa-hand-point-right"></i> 
Knowledge Base: [File compression](../kb/file-compression.md)

Logical block size

: A power of 2 between 12 and 20: pageSize or allocation granularity to 1MB

: PageSize for AMD64 is 4kB, SPARC is 8kB. Windows seems to have a default allocation granularity of 64kB. 

: When choosing the logical block size, consider the minimum of all the platforms that will access the files directly – otherwise you may encounter `disk compression - bad logicalBlockSize`. Note this value affects both compression speed and compression ratio: larger blocks can be slower and better compressed.

Compression algorithm

: One of:

    + 0: none
    + 1: q IPC
    + 2: `gzip`
    + 3: [snappy](http://google.github.io/snappy) (since V3.4)
    + 4: lz4hc (since V3.6)

Compression level

: For `gzip`, an integer between 0 and 9; otherwise 0.


## `.z.T` `.z.t` `.z.D` `.z.d` (time/date shortcuts)

Shorthand forms:
<table class="kx-compact" markdown="1">
<tr><td>`.z.T`</td><td>`` `time$.z.Z``</td><td>`.z.D`</td><td>`` `date$.z.Z``</td></tr>
<tr><td>`.z.t`</td><td>`` `time$.z.z``</td><td>`.z.d`</td><td>`` `date$.z.z``</td></tr>
</table>








