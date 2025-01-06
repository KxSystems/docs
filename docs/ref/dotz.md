---
title: the .z namespace | Reference | kdb+ and q documentation
description: The .z namespace contains objects that return or set system information, and callbacks for IPC.
author: Stephen Taylor
keywords: callbacks, environment, kdb+, q
---
# :fontawesome-regular-clock: The `.z` namespace



_Environment and callbacks_

<div markdown="1" class="typewriter">
Environment                              Callbacks
 [.z.a    IP address](#za-ip-address)                       [.z.bm    msg validator](#zbm-msg-validator)
 [.z.b    view dependencies](#zb-view-dependencies)                [.z.exit  action on exit](#zexit-action-on-exit)
 [.z.c    cores](#zc-cores)                            [.z.pc    close](#zpc-close)
 [.z.f    file](#zf-file)                             [.z.pd    peach handles](#zpd-peach-handles)
 [.z.h    host](#zh-host)                             [.z.pg    get](#zpg-get)
 [.z.i    PID](#zi-pid)                              [.z.pi    input](#zpi-input)
 [.z.K    version](#zk-version)                          [.z.po    open](#zpo-open)
 [.z.k    release date](#zk-release-date)                     [.z.pq    qcon](#zpq-qcon)
 [.z.l    license](#zl-license)                          [.z.r     blocked](#zr-blocked)
 [.z.o    OS version](#zo-os-version)                       [.z.ps    set](#zps-set)
 [.z.q    quiet mode](#zq-quiet-mode)                       [.z.pw    validate user](#zpw-validate-user)
 [.z.s    self](#zs-self)                             [.z.ts    timer](#zts-timer)
 [.z.u    user ID](#zu-user-id)                          [.z.vs    value set](#zvs-value-set)
 [.z.X/x  raw/parsed command line](#zx-raw-command-line)
                                         Callbacks (HTTP)
Environment (Compression/Encryption)      [.z.ac    HTTP auth](#zac-http-auth)
 [.z.zd   compression/encryption defaults](#zzd-compressionencryption-defaults)  [.z.ph    HTTP get](#zph-http-get)
                                          [.z.pm    HTTP methods](#zpm-http-methods)
Environment (Connections)                 [.z.pp    HTTP post](#zpp-http-post)
 [.z.e    TLS connection status](#ze-tls-connection-status)
 [.z.H    active sockets](#zh-active-sockets)                  Callbacks (WebSockets)
 [.z.W/w  handles/handle](#zw-handles)                   [.z.wc    WebSocket close](#zwc-websocket-close)
                                          [.z.wo    WebSocket open](#zwo-websocket-open)
Environment (Debug)                       [.z.ws    WebSockets](#zws-websockets)
 [.z.ex   failed primitive](#zex-failed-primitive)
 [.z.ey   arg to failed primitive](#zey-argument-to-failed-primitive)

Environment (Time/Date)
 [.z.D/d  date shortcuts](#zt-zt-zd-zd-timedate-shortcuts)
 [.z.N/n  local/UTC timespan](#zn-local-timespan)
 [.z.P/p  local/UTC timestamp](#zp-local-timestamp)
 [.z.T/t  time shortcuts](#zt-zt-zd-zd-timedate-shortcuts)
 [.z.Z/z  local/UTC datetime](#zz-local-datetime)
</div>

The `.z` [namespace](../basics/namespaces.md) contains environment variables and functions, and hooks for callbacks.
!!! warning "The `.z` namespace is reserved for use by KX, as are all single-letter namespaces."

    Consider all undocumented functions in the namespace as exposed infrastructure – and do not use them.

!!! tip "By default, callbacks are not defined in the session"

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
-1408172030i
```

Note its relationship to [`.z.h`](#zh-host) for the hostname, converted to an int using [`.Q.addr`](dotq.md#host-ip-to-hostname).
```q
q).Q.addr .z.h
-1408172030i
```

It can be split into components as follows:

```q
q)"i"$0x0 vs .z.a
172 17 0 2i
```

When invoked inside a `.z.p*` callback via a TCP/IP connection, it is the IP address of the client session, not the current session. For example, connecting from a remote machine:

```q
q)h:hopen myhost:1234
q)h"\"i\"$0x0 vs .z.a"
192 168 65 1i
```
or from same machine:
```q
q)h:hopen 1234
q)h"\"i\"$0x0 vs .z.a"
127 0 0 1i
```

When invoked via a Unix Domain Socket, it is 0.
```q
q)h:hopen `:unix://1234
q)h".z.a"
0i
```

:fontawesome-solid-hand-point-right:
[`.z.h`](#zh-host) (host), [`.Q.host`](dotq.md#host-ip-to-hostname) (IP to hostname)

## `.z.ac` (HTTP auth)

```syntax
.z.ac:(requestText;requestHeaderAsDictionary)
```

Lets you define custom code to authorize/authenticate an HTTP request.
e.g. inspect HTTP headers representing oauth tokens, cookies, etc. 
Your custom code can then return different values based on what is discovered.

`.z.ac` is a unary function, whose single parameter is a two-element list providing the request text and header.

!!! note "If .z.ac is not defined, it uses basic access authentication as per `(4;"")` below"

The function should return a two-element list. The list of possible return values is:

* User not authorized/authenticated
```q
(0;"")
```
User not authorized. Client is sent default 401 HTTP unauthorized response.
An HTTP callback to handle the request will not be called.
* User authorized/authenticated
```q
(1;"username")
```
The provided username is used to set [`.z.u`](#zu-user-id). 
The relevant HTTP callback to handle this request will be allowed.
* User not authorized/authenticated (custom response)
```q
(2;"response text")
```
The custom response to be sent should be provided in the "response text" section.
The response text should be comprised of a valid HTTP response message, for example a 401 response with a customised message.
An HTTP callback to handle the original request is not called.
* Fallback to basic authentication
```q
(4;"")
```
Fallback to [basic access authentication](https://en.wikipedia.org/wiki/Basic_access_authentication#Client_side), where the username/password are base64 decoded and processed via the [`-u`](../ba
sics/cmdline.md#-u-usr-pwd-local)/[`-U`](../basics/cmdline.md#-u-usr-pwd) file and [`.z.pw`](#zpw-validate-user) (if defined).
If the user is not permitted, the client is sent a default 401 HTTP unauthorized response. Since V4.0 2021.07.12.

:fontawesome-solid-graduation-cap:[HTTP](../kb/http.md)

[](){#zb-dependencies}
## `.z.b` (view dependencies)

The dependency dictionary.

```q
q)a::x+y
q)b::x+1
q).z.b
x| `a`b
y| ,`a
```

:fontawesome-solid-book-open:
[`\b`](../basics/syscmds.md#b-views) (views)
<br>
:fontawesome-solid-graduation-cap:
[Views](../learn/views.md)


## `.z.bm` (msg validator)

```syntax
.z.bm:x
```

Where `x` is a unary function.

kdb+ before V2.7 was sensitive to being fed malformed data structures, sometimes resulting in a crash, but now validates incoming IPC messages to check that data structures are well formed, reporting `'badmsg` and disconnecting senders of malformed data structures. The raw message is captured for analysis via the callback `.z.bm`. The sequence upon receiving such a message is

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

TLS details used with a connection handle. Returns an empty dictionary if the connection is not TLS enabled. E.g. where `h` is a connection handle.

```q
q)h".z.e"
CIPHER  | `AES128-GCM-SHA256
PROTOCOL| `TLSv1.2
CERT    | `SUBJECT`ISSUER`SERIALNUMBER`NOTVALIDBEFORE`NOTVALIDAFTER`VERIFIED`VERIFYERROR!("/C=US/ST=New York/L=Brooklyn/O=Example Brooklyn Company/CN=myname.com";"/C=US/ST=New York/L=Brooklyn/O=Example Brooklyn Company/CN=examplebrooklyn.com";,"1";"Jul  6 10:08:57 2021 GMT";"May 15 10:08:57 2031 GMT";1b;0)
```

Since V3.4 2016.05.16. `CERT` details of `VERIFIED`,`VERIFYERROR` available since 4.1t 2024.02.07.

:fontawesome-solid-hand-point-right:
[`-26!` TLS settings](../basics/internal.md#-26x-ssl)


## `.z.ex` (failed primitive)

In a [debugger](../basics/debug.md#debugger) session, `.z.ex` is set to the failed primitive.

Since V3.5 2017.03.15.

:fontawesome-solid-hand-point-right:
[`.z.ey`](#zey-argument-to-failed-primitive) (argument to failed primitive)


## `.z.exit` (action on exit)

```syntax
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
[`.z.pc`](#zpc-close) (port close)
<br>
:fontawesome-solid-book:
[`exit`](exit.md)
<br>
:fontawesome-solid-book-open:
[`\\` quit](../basics/syscmds.md#quit)


## `.z.ey` (argument to failed primitive)

In a [debugger](../basics/debug.md#debugger) session, `.z.ey` is set to the argument to failed primitive.

Since V3.5 2017.03.15.

:fontawesome-solid-hand-point-right:
[`.z.ex`](#zex-failed-primitive) (failed primitive)


## `.z.f` (file)

Name of the q script as a symbol.

```q
$ q test.q
q).z.f
`test.q
```

:fontawesome-solid-hand-point-right:
[`.z.x`](#zx-argv) (argv)


## `.z.H` (active sockets)

Active sockets as a list (a low-cost method). Since v4.0 2020.06.01.

List has [sorted attribute](set-attribute.md#sorted) applied since v4.1 2024.07.08.

```q
q).z.H~key .z.W
1b
```

:fontawesome-solid-hand-point-right:
[`.z.W`](#zw-handles) (handles), [`.z.w`](#zw-handle) (handle), [`-38!`](../basics/internal.md#-38x-socket-table) (socket table)


## `.z.h` (host)

The host name as a symbol

```q
q).z.h
`demo.kx.com
```

On Linux this should return the same as the shell command `hostname`. If you require a fully qualified domain name, and the `hostname` command returns a hostname only (with no domain name), this should be resolved by your system administrators. Often this can be traced to the ordering of entries in `/etc/hosts`, e.g.

Non-working `/etc/host` looks like :

```txt
127.0.0.1    localhost.localdomain localhost
192.168.1.1  myhost.mydomain.com myhost
```

Working one has this ordering :

```txt
127.0.0.1    localhost.localdomain localhost
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

:fontawesome-solid-hand-point-right:
[`.z.a`](#za-ip-address) (IP address), [`.Q.addr`](dotq.md#addr-iphost-as-int) (IP/host as int)

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
[`.z.k`](#zk-release-date) (release date)


## `.z.k` (release date)

Date on which the version of kdb+ being used was released.

```q
q).z.k
2006.10.30
q)
```

This value is checked against `.Q.k` as part of the startup to make sure that the executable and the version of q.k being used are compatible.

:fontawesome-solid-hand-point-right:
[`.z.K`](#zk-version) (version)


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

:fontawesome-solid-hand-point-right:
[`.z.n`](#zn-utc-timespan) (UTC timespan), [`.z.P`](#zp-local-timestamp) (local timestamp), [`.z.p`](#zp-utc-timestamp) (UTC timestamp), [`.z.Z`](#zz-local-datetime) (local datetime), [`.z.z`](#zz-utc-datetime) (UTC datetime)


## `.z.n` (UTC timespan)

System UTC time as timespan in nanoseconds.
<!-- (V2.6 upwards.) -->

```q
q).z.n
0D23:30:10.827156000
```

!!! note "Changes since 4.1t 2021.03.30,4.0 2022.07.01"

    Linux clock source returns a nanosecond precision timespan

:fontawesome-solid-hand-point-right:
[`.z.n`](#zn-local-timespan) (local timespan), [`.z.P`](#zp-local-timestamp) (local timestamp), [`.z.p`](#zp-utc-timestamp) (UTC timestamp), [`.z.Z`](#zz-local-datetime) (local datetime), [`.z.z`](#zz-utc-datetime) (UTC datetime)

## `.z.o` (OS version)

kdb+ operating system version as a symbol.

```q
q).z.o
`w32
```

Values for V3.5+ are shown below in bold type.

os               | 32-bit  | 64-bit
-----------------|---------|--------
Linux            | **l32** | **l64**
Linux on ARM     |         | **l64** (reports **l64arm** since 4.1t 2022.09.02)
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

:fontawesome-solid-hand-point-right:
[`.z.p`](#zp-utc-timestamp) (UTC timestamp), [`.z.N`](#zn-local-timespan) (local timespan), [`.z.n`](#zn-utc-timespan) (UTC timespan), [`.z.Z`](#zz-local-datetime) (local datetime), [`.z.z`](#zz-utc-datetime) (UTC datetime)


## `.z.p` (UTC timestamp)

UTC timestamp in nanoseconds.

```q
q).z.p
2018.04.30D09:18:38.117667000
```

!!! note "Changes since 4.1t 2021.03.30,4.0 2022.07.01"

    Linux clock source returns a nanosecond precision timestamp

:fontawesome-solid-hand-point-right:
[`.z.P`](#zp-local-timestamp) (local timestamp), [`.z.N`](#zn-local-timespan) (local timespan), [`.z.n`](#zn-utc-timespan) (UTC timespan), [`.z.Z`](#zz-local-datetime) (local datetime), [`.z.z`](#zz-utc-datetime) (UTC datetime)

## `.z.pc` (close)

```syntax
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

:fontawesome-solid-hand-point-right:
[`.z.po`](#zpo-open) (port open)


## `.z.pd` (peach handles)

```syntax
.z.pd: x
```

Where q has been [started with secondary processes for use in parallel processing](../basics/cmdline.md#-s-secondarys),  `x` is

-    an int vector of handles to secondary processes
-    a function that returns a list of handles to those secondary processes

For evaluating the function passed to `peach` or `':`, kdb+ gets the handles to the secondary processes by calling [`.z.pd[]`](#zpd-peach-handles).

!!! danger "The processes with these handles must not be used for other messaging."

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

!!! warning "Disabled in V4.1t"

    Using handles within peach is not supported e.g.

        q)H:hopen each 4#4000;{x""}peach H
        3 4 5 6i

    One-shot IPC requests can be used within `peach` instead.


:fontawesome-solid-graduation-cap:
[Load balancing](../kb/load-balancing.md)


## `.z.pg` (get)

```syntax
.z.pg:f
```

Where `f` is a unary function, called with the object that is passed to the q session via a synchronous request. The return value, if any, is returned to the calling task.

`.z.pg` can be unset with `\x .z.pg`, which restores the default behavior.

The default behavior is equivalent to setting `.z.pg` to [`value`](value.md) and executes in the root context.

:fontawesome-solid-hand-point-right:
[`.z.ps`](#zps-set) (set)


## `.z.ph` (HTTP get)

```syntax
.z.ph:f
```

Where `f` is a unary function, it is evaluated when a synchronous HTTP request is received by the kdb+ session.

`.z.ph` is passed a single argument, a 2-item list `(requestText;requestHeaderAsDictionary)`:

- `requestText` is parsed in `.z.ph` – detecting special cases like requests for CSV, XLS output – and the result is returned to the calling task.
- `requestHeaderAsDictionary` contains a dictionary of [HTTP header](https://en.wikipedia.org/wiki/List_of_HTTP_header_fields) names and values as sent by the client. This can be used to return content optimized for particular browsers.

The function returns a string representation of an HTTP response message e.g. [HTTP/1.1 response message format](https://en.wikipedia.org/wiki/HTTP#HTTP/1.1_response_messages).

Since V3.6 and V3.5 2019.11.13, the default implementation calls [`.h.val`](doth.md#hval-value) instead of [`value`](value.md), allowing users to interpose their own valuation code. It is called with `requestText` as the argument.

:fontawesome-solid-hand-point-right:
[`.z.pp`](#zpp-http-post) (HTTP post), [`.z.pm`](#zpm-http-methods) (HTTP methods), [`.z.ac`](#zac-http-auth) (HTTP auth)
<br>
:fontawesome-solid-book:
[`.h` namespace](doth.md)
<br>
:fontawesome-solid-graduation-cap:
[HTTP](../kb/http.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.7.1 HTTP Connections](/q4m3/11_IO/#1171-http-connections)


## `.z.pi` (input)

```syntax
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



## `.z.pm` (HTTP methods)

```syntax
.z.pm:f
```

Where f is a unary function, .z.pm is evaluated when the following HTTP request methods are received in the kdb+ session.

-   OPTIONS
-   PATCH (since V4.1t 2021.03.30)
-   PUT (since V4.1t 2021.03.30)
-   DELETE (since V4.1t 2021.03.30)

Each method is passed to `f` as a 3-item list e.g.

```q
(`OPTIONS;requestText;requestHeaderDict)
```

For the POST method use [.z.pp](#zpp-http-post), and for GET use [.z.ph](#zph-http-get).

:fontawesome-solid-hand-point-right:
[`.z.ph`](#zph-http-get) (HTTP get), [`.z.pp`](#zpp-http-post) (HTTP post), [`.z.ac`](#zac-http-auth) (HTTP auth)
<br>
:fontawesome-solid-graduation-cap:[HTTP](../kb/http.md)


## `.z.po` (open)

```syntax
.z.po:f
```

Where `f` is a unary function, `.z.po` is evaluated when a connection to a kdb+ session has been initialized, i.e. after it’s been validated against any [`-u`](../basics/cmdline.md#-u-usr-pwd-local)/[`-U`](../basics/cmdline.md#-u-usr-pwd) file and `.z.pw` checks.

Its argument is the handle and is typically used to build a dictionary of handles to session information like the value of `.z.a`, `.z.u`

:fontawesome-solid-hand-point-right:
[`.z.pc`](#zpc-close) (port close),
[`.z.pw`](#zpw-validate-user) (validate user)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.6 Interprocess Communication](/q4m3/11_IO/#116-interprocess-communication)


## `.z.pp` (HTTP post)

```syntax
.z.pp:f
```

Where `f` is a unary function, `.z.pp` is evaluated when an HTTP POST request is received in the kdb+ session.

There is no default implementation, but an example would be that it calls [`value`](value.md) on the first item of its argument and returns the result to the calling task.

See [`.z.ph`](#zph-http-get) for details of the argument and return value.

Allows empty requests since 4.1t 2021.03.30 (previously signalled `length` error).

:fontawesome-solid-hand-point-right:
[`.z.ph`](#zph-http-get) (HTTP get), [`.z.pm`](#zpm-http-methods) (HTTP methods), [`.z.ac`](#zac-http-auth) (HTTP auth)
<br>
:fontawesome-solid-book:
[`.h` namespace](doth.md)
<br>
:fontawesome-solid-graduation-cap:
[HTTP](../kb/http.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.7.1 HTTP Connections](/q4m3/11_IO/#1171-http-connections)


## `.z.pq` (qcon)

```syntax
.z.pq:f
```

Remote connections using the ‘qcon’ text protocol are routed to `.z.pq`, which defaults to calling `.z.pi`. (Since V3.5+3.6 2019.01.31.)

This allows a user to handle remote qcon connections (via `.z.pq`) without defining special handling for console processing (via `.z.pi`).

:fontawesome-solid-graduation-cap:
[Firewalling](../kb/firewalling.md) for locking down message handlers


## `.z.ps` (set)

```syntax
.z.ps:f
```

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

:fontawesome-solid-hand-point-right:
[`.z.pg`](#zpg-get) (get)


## `.z.pw` (validate user)

```syntax
.z.pw:f
```

Where `f` is a binary function, `.z.pw` is evaluated _after_ the [`-u`](../basics/cmdline.md#-u-usr-pwd-local)/[`-U`](../basics/cmdline.md#-u-usr-pwd) checks, and _before_ `.z.po` when opening a new connection to a kdb+ session.

The arguments are the user ID (as a symbol) and password (as a string) to be verified; the result is a boolean atom.

As `.z.pw` is simply a function it can be used to implement rules such as “ordinary users can sign on only between 0800 and 1800 on weekdays” or can go out to external resources like an LDAP directory.

If `.z.pw` returns `0b` the task attempting to establish the connection will get an `'access` error.

The default definition is `{[user;pswd]1b}`

:fontawesome-solid-hand-point-right:
[`.z.po`](#zpo-open) (port open)
<br>
:fontawesome-solid-book:
[Changes in 2.4](../releases/ChangesIn2.4.md#zpw)


## `.z.q` (quiet mode)

`1b` if Quiet Mode is set, else `0b`.

:fontawesome-solid-book-open:
[Command-line option `-q`](../basics/cmdline.md#-q-quiet-mode)


## `.z.r` (blocked)

A boolean, indicating whether an update in the current context would be blocked.

Returns `1b`

-   in `reval`
-   where the [`-b` command-line option](../basics/cmdline.md#-b-blocked) has been set
-   in a thread other than the main event thread

Since V4.1t 2021.04.16.


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

```syntax
.z.ts:f
```

Where `f` is a unary function, `.z.ts` is evaluated on intervals of the timer variable set by system command `\t`. The timestamp is returned as Greenwich Mean Time (GMT).

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

```syntax
.z.vs:f
```

Where `f` is a binary function, `.z.vs` is evaluated _after_ a value is set globally in the default namespace (e.g. `a`, `a.b`).

For function `f[x;y]`, `x` is the symbol of the modified variable and `y` is the index. 

!!! detail "Applies only to globals in the default namespace"

    This is not triggered for function-local variables, nor globals that are not in the default namespace, e.g. those prefixed with a dot such as `.a.b`.

    This is the same restriction that applies to [logging](../kb/logging.md).

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

```q
q)h:hopen ...
q)h
3
q)neg[h]({};til 1000000); neg[h]({};til 10); .z.W
3| 8000030 110
q)neg[h]({};til 1000000); neg[h]({};til 10); sum each .z.W 
3| 8000140
```

Since 4.1 2023.09.15, this returns `handles!bytes` as `I!J`, instead of the former `handles!list` of individual msg sizes. Use `sum each .z.W` if writing code targeting 4.0 and 4.1

```q
q)h:hopen ...
q)h
6i
q)neg[h]({};til 1000000); neg[h]({};til 10); .z.W
6| 8000140
q)neg[h]({};til 1000000); neg[h]({};til 10); sum each .z.W
6| 8000140
```

Querying known handles can also be performed using [`-38!`](../basics/internal.md#-38x-socket-table), which can be more performant than using `.z.W` to return the entire dataset of handles.
```q
q)h:hopen 5000
q)neg[h]"11+1111111";.z.W h
24
q)neg[h]"11+1111111";(-38!h)`m
24
```

:fontawesome-solid-hand-point-right:
[`.z.H`](#zh-active-sockets) (active sockets), [`.z.w`](#zw-handle) (handle), [`-38!`](../basics/internal.md#-38x-socket-table) (socket table)


## `.z.w` (handle)

Connection handle; 0 for current session console.

```q
q).z.w
0i
```

!!! warning "Inside a `.z.p`* callback it returns the handle of the client session, not the current session."

:fontawesome-solid-hand-point-right:
[`.z.H`](#zh-active-sockets) (active sockets), [`.z.W`](#zw-handles) (handles), [`-38!`](../basics/internal.md#-38x-socket-table) (socket table)


## `.z.wc` (websocket close)

```syntax
.z.wc:f
```

Where

-   `f` is a unary function
-   `h` is the handle to a websocket connection to a kdb+ session

`f[h]` is evaluated _after_ a websocket connection has been closed.
(Since V3.3t 2014.11.26.)

As the connection has been closed by the time `.z.wc` is called, there are strictly no remote values that can be put into `.z.a`, `.z.u` or `.z.w` so the local values are returned.

This allows you to clean up things like tables of users keyed by handle.

:fontawesome-solid-hand-point-right:
[`.z.wo`](#zwo-websocket-open) (websocket open),
[`.z.ws`](#zws-websockets) (websockets),
[`.z.ac`](#zac-http-auth) (HTTP auth)


## `.z.wo` (websocket open)

```syntax
.z.wo:f
```

Where

-   `f` is a unary function
-   `h` is the handle to a websocket connection to a kdb+ session

`f[h]` is evaluated when the connection has been initialized, i.e. _after_ it has been validated against any `-u`/`-U` file and `.z.pw` checks.
(Since V3.3t 2014.11.26)

The handle argument is typically used by `f` to build a dictionary of handles to session information such as the value of `.z.a`, `.z.u`.

:fontawesome-solid-hand-point-right:
[`.z.wc`](#zwc-websocket-close) (websocket close),
[`.z.ws`](#zws-websockets) (websockets),
[`.z.ac`](#zac-http-auth) (HTTP auth)


## `.z.ws` (websockets)

```syntax
z.ws:f
```

Where `f` is a unary function, it is evaluated on a message arriving at a websocket. If the incoming message is a text message the argument is a string; if a binary message, a byte vector.

Sending a websocket message is limited to async messages only (sync is `'nyi`). A string will be sent as a text message; a byte vector as a binary message.

:fontawesome-solid-hand-point-right:
[`.z.wo`](#zwo-websocket-open) (websocket open),
[`.z.wc`](#zwc-websocket-close) (websocket close),
[`.z.ac`](#zac-http-auth) (HTTP auth)
<br>
:fontawesome-solid-graduation-cap:
[WebSockets](../kb/websockets.md)


## `.z.X` (raw command line)

```syntax
.z.X
```

Returns a list of strings of the raw, unfiltered command line with which kdb+ was invoked, including the name under which q was invoked, as well as single-letter arguments.
(Since V3.3 2015.02.12)

```bash
$ q somefile.q -customarg 42 -p localhost:17200
```

```q
KDB+ 3.4 2016.09.22 Copyright (C) 1993-2016 KX Systems
m64/ 4()core 8192MB ...
q).z.X
,"q"
"somefile.q"
"-customarg"
"42"
"-p"
"localhost:17200"
```

:fontawesome-solid-hand-point-right:
[`.z.x`](#zx-argv) (argv), [`.z.f`](#zf-file) (file), [`.z.q`](#zq-quiet-mode) (quiet mode), [`.Q.opt`](dotq.md#opt-command-parameters) (command parameters), [`.Q.def`](dotq.md#def-command-defaults) (command defaults), [`.Q.x`](dotq.md#x-non-command-parameters) (non-command parameters)


## `.z.x` (argv)

Command-line arguments as a list of strings

```q
$ q test.q -P 0 -abc 123
q).z.x
"-abc"
"123"
```

!!! Note "The script name and the single-letter options used by q itself are not included."

Command-line options can be converted to a dictionary using the convenient [`.Q.opt`](dotq.md#opt-command-parameters) function.

:fontawesome-solid-hand-point-right:
[`.z.X`](#zx-raw-command-line) (raw command line), [`.z.f`](#zf-file) (file), [`.z.q`](#zq-quiet-mode) (quiet mode), [`.Q.opt`](dotq.md#opt-command-parameters) (command parameters), [`.Q.def`](dotq.md#def-command-defaults) (command defaults), [`.Q.x`](dotq.md#x-non-command-parameters) (non-command parameters)


## `.z.Z` (local datetime)

Local time as a datetime atom.

```q
q).z.Z
2006.11.13T21:16:14.601
```

The offset from UTC is fetched from the OS: kdb+ does not have its own time-offset database.

Which avoids problems like [this](https://it.slashdot.org/story/07/02/25/2038217/software-bug-halts-f-22-flight).

:fontawesome-solid-hand-point-right:
[`.z.z`](#zz-utc-datetime) (UTC datetime), [`.z.P`](#zp-local-timestamp) (local timestamp), [`.z.p`](#zp-utc-timestamp) (UTC timestamp), [`.z.N`](#zn-local-timespan) (local timespan), [`.z.n`](#zn-utc-timespan) (UTC timespan)

## `.z.z` (UTC datetime)

UTC time as a datetime atom.

```q
q).z.z
2006.11.13T21:16:14.601
```
!!! detail "`z.z` calls `gettimeofday` and so has microsecond precision"

:fontawesome-solid-hand-point-right:
[`.z.Z`](#zz-local-datetime) (local datetime), [`.z.P`](#zp-local-timestamp) (local timestamp), [`.z.p`](#zp-utc-timestamp) (UTC timestamp), [`.z.N`](#zn-local-timespan) (local timespan), [`.z.n`](#zn-utc-timespan) (UTC timespan)


[](){#zzd-zip-defaults}
## `.z.zd` (compression/encryption defaults)

```syntax
.z.zd:(lbs;alg;lvl)
```

Integers `lbs`, `alg`, and `lvl` are [compression parameters](../kb/file-compression.md#compression-parameters) and/or [encryption parameters](../kb/dare.md#encryption).
They set default values for logical block size, compression/encryption algorithm and compression level that apply when saving to files with no file extension.
Encryption available since 4.0 2019.12.12.

```q
q).z.zd:17 2 6        / set zip defaults
q)\x .z.zd            / clear zip defaults
```

:fontawesome-solid-hand-point-right:
[`-21!x`](../basics/internal.md#-21x-compressionencryption-stats) (compression/encryption stats), [`set`](get.md#set) (per file/dir compression)

:fontawesome-solid-database:
[File compression](../kb/file-compression.md)
<br>
:fontawesome-regular-map:
[Compression in kdb+](../wp/compress/index.md)
<br>
:fontawesome-solid-database:
[Data at rest encryption (DARE)](../kb/dare.md)


## `.z.T` `.z.t` `.z.D` `.z.d` (time/date shortcuts)

Shorthand forms:

```syntax
.z.T  `time$.z.Z     .z.D  `date$.z.Z
.z.t  `time$.z.z     .z.d  `date$.z.z
```

:fontawesome-solid-hand-point-right:
[`.z.Z`](#zz-local-datetime) (local datetime), [`.z.z`](#zz-utc-datetime) (UTC datetime)


---
:fontawesome-solid-graduation-cap:
[Callbacks](../kb/callbacks.md),
[Using `.z`](../kb/using-dotz.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals:_
[§11.6 Interprocess Communication](/q4m3/11_IO/#116-interprocess-communication)
