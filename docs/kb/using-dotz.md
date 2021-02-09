---
title: Using modified .z functions to trace, monitor and control execution – Knowledge Base – kdb+ and q documentation
description: Some techniques for debugging q programs
keywords: control, debug, dotz, execution, kdb+, monitor, q, trace
---
# Using modified `.z` functions to trace, monitor and control execution



Every client interaction with a kdb+ server is handled by one of the `p`? functions you’ll find in the system namespace `.z`. These functions have reasonable, simple defaults that work fine right out of the box. What we’re doing here is taking advantage of the fact that they’re just functions, allowing you to overwrite them with your own custom code to show or modify what’s happening.

The utility scripts in 
:fontawesome-brands-github: 
[github.com/simongarland/dotz](https://github.com/simongarland/dotz) 
are _examples_ of how to do this, and these files are described in detail below.

In all of the examples the code to wrap up existing definitions looks complicated. The reason is that these are general scripts and so a combination of them could be loaded into applications with pre-existing custom `.z.p`? definitions. The wrapping code protects these definitions, but in a particular application you can probably simply replace or extend existing definitions rather than wrapping them.


## Take it for a spin

The simplest way to get a feeling for what’s going on is to try it out. Start up two kdb+ sessions, load `traceusage.q` into one of them – and then talk to it from the other server. Watch the output in the `traceusage` session.

Vanilla server session:

```q
q)h:hopen 5001
q)h
3
q)h"2+2 3"
4 5
q)h"2 3 4+2 3"
'length
q)hclose h
```

`traceusage` server session:

```bash
$ q traceusage.q -p 5001
…
```

```q
 2008.05.09 12:38:10.367 ms:0.002003799 m+:0K pw a:localhost u: w:4 (`simon;"***")
 2008.05.09 12:38:10.370 ms:0.003025343 m+:0K po a:localhost u:simon w:4 4
 2008.05.09 12:38:17.151 ms:0.02098095 m+:0K pg a:localhost u:simon w:4 2+2 3
*2008.05.09 12:38:25.438 (error:length) pg a:localhost u:simon w:4 2 3 4+2 3
 2008.05.09 12:38:33.246 ms:0.002986053 m+:0K pc a:192.168.1.34 u:simon w:0 4
```

(On non-Windows OSs the error line will be in glorious 1980s style color.)


## The gory details

What the individual files do, and how to use them.


### The toolkit

The “tools” you have to work with are the `p`? functions from `.z`: [`.z.po`](../ref/dotz.md#zpo-open "open"), [`.z.pc`](../ref/dotz.md#zpc-close "close"), [`.z.pw`](../ref/dotz.md#zpw-validate-user "validate user"), [`.z.pg`](../ref/dotz.md#zpg-get "get"), [`.z.ps`](../ref/dotz.md#zpg-set "set"), [`.z.ph`](../ref/dotz.md#zph-http-get "HTTP get"), [`.z.pp`](../ref/dotz.md#zpp-http-post "HTTP post") and [`.z.exit`](../ref/dotz.md#zexit-action-on-exit "action on exit"). Combined with the `.z` variables [`.z.a`](../ref/dotz.md#za-ip-address "IP address"), [`.z.u`](../ref/dotz.md#zu-user-id "user ID") and [`.z.w`](../ref/dotz.md#zw-handle "handle") which are always set to the values of the _client_ during execution of the `.z.p`? function. Depending on how the function is called, additional information may be provided as arguments to the `.z.p`? functions (user ID and password for `.z.pw`, browser environment for `.z.ph` and `.z.pp`).

By default, execution is done using [`value`](../ref/value.md) so strings or symbol argument lists can be tested in a console. 

:fontawesome-regular-hand-point-right: 
_Q for Mortals_: [§11.6 Interprocess Communication](/q4m3/11_IO/#116-interprocess-communication)


### `saveorig.q`

This script just saves original values of things like `.z.pg` so you can revert to original definitions without having to restart the task. This is made a little more complicated by the way some of the default definitions aren’t materialised in the user workspace. For example by default `.z.pg` is just `{value x}` but that’s run in the kdb+ executable. The default values are created explicitly if need be.

```q
.dotz.exit.ORIG:.z.exit:@[.:;`.z.exit;{;}];
.dotz.pg.ORIG:.z.pg:@[.:;`.z.pg;{.:}];
.dotz.ps.ORIG:.z.ps:@[.:;`.z.ps;{.:}];
…
```

Other functions and variables shared between multiple scripts (such as debug output level `.debug.LEVEL`, or the `.z.a` IP address &lt;-&gt; hostname cache `.dotz.IPA`) are defined here too. Although it would be simpler to embed this setup code in each script, allowing them to be standalone, one tires of the cut’n’paste forays required by every tiny change.

!!! note

    After the various state variables have been defined the script `saveorig.custom.q` is loaded, if found, allowing you to customise the setup without needing to have a modified version of the saveorig script.

Again, for production use you should rip out the unneeded definitions.


## Tracing execution

Tracing execution of the various callbacks is the simplest application. It can be as simple as just sprinkling `0N!` statements around the functions, or as complicated as logging to an external file. As these are samples they also track the use of `.z.pi` – but that can get tiresome if you’re debugging from a console. In that case just zap the custom `.z.pi` definition with:

```q
q)\x .z.pi
```

The variable `.usage.LEVEL` can be set to control how much is output. By default (2) it displays all messages, a value of 1 will display only errors and a value of 0 will temporarily disable logging. In the examples below, the sample session is a simple `hopen`, `get "2+2"`, `get "2 3+3 4 5"` then `hclose`. 

### `dumpusage.q`

The simplest file of all, it just puts in `0N!` to display the input and the results. It’s fine for debugging a simple conversation with a single client – but not informative enough for more complex setups.

```q
dotz$ q dumpusage.q -p 5001
…
q)"***"
`simon
1b
4
4
"2+2"
4
"2 3+3 4 5"
4
4
```


### `traceusage.q`

Dumps formatted output to the console, and on non-Windows consoles it will color errors and expensive calls. The definition of what’s expensive can be set by `.usage.EXPENSIVE` (in milliseconds).

```q
dotz$ q traceusage.q -p 5001
…
q)
 2008.05.13 11:42:56.290 ms:0.002003799 m+:0K pw a:localhost u: w:4 (`simon;"***")
 2008.05.13 11:42:56.319 ms:0.003968307 m+:0K po a:localhost u:simon w:4 4
 2008.05.13 11:43:00.866 ms:0.0159911 m+:0K pg a:localhost u:simon w:4 2+2
*2008.05.13 11:43:08.818 (error:length) pg a:localhost u:simon w:4 2 3+3 4 5
 2008.05.13 11:43:13.986 ms:0.004007597 m+:0K pc a:192.168.1.34 u:simon w:0 4
```


### `lastusage.q`

When debugging it’s sometimes more helpful to be able to grab the last request that came in rather than just looking at a trace of what happened. This set of custom callbacks stores the last calls in namespace `.last`, allowing you to fetch the data and retry the request directly in your session.

```q
dotz$ q lastusage.q -p 5001
…
q).last
    | ::
pw  | ``when`u`w`a`x`y`z`r!(::;2008.05.13T11:44:36.655;`;4;2130706433;{[x;y]1b};`simon;"";1b)
zcmd| `pc
po  | ``when`u`w`a`x`y`r!(::;2008.05.13T11:44:36.655;`simon;4;2130706433;::;4;4)
pg  | ``when`u`w`a`x`y`r!(::;2008.05.13T11:44:40.951;`simon;4;2130706433;.:;"2+2";4)
pc  | ``when`u`w`a`x`y`r!(::;2008.05.13T11:44:52.111;`simon;0;-1062731486;::;4;4)
q).last.pg
    | ::
when| 2008.05.13T11:44:40.951
u   | `simon
w   | 4
a   | 2130706433
x   | .:
y   | "2+2"
r   | 4
q)value .last.pg.y
4
```


### `monitorusage.q`

If the monitoring is to be left running for a long time scrolling back through the console is not a sensible way to look for problems. This script logs all requests to a local table `USAGE`, allowing you to analyse the data. As the data is stored in an in-memory table it’s of course lost when you exit unless you choose to do something with `.z.exit`.

```q
dotz$ q monitorusage.q -p 5001
…
q)USAGE
date time ms mdelta zcmd ipa u w cmd ok error
---------------------------------------------
q)USAGE
date       time         ms          mdelta zcmd ipa          u     w cmd                ok error
-------------------------------------------------------------------------------------------------
2008.05.13 11:48:19.360 0.2459958   0      pi   192.168.1.34 simon 0 "USAGE"            1
2008.05.13 11:48:31.728 0.002003799 0      pw   localhost          4 "(`simon;\"***\")" 1
2008.05.13 11:48:31.729 0           0      po   localhost    simon 4 ,"4"               1
2008.05.13 11:48:36.360 0.0159911   0      pg   localhost    simon 4 "2+2"              1
2008.05.13 11:48:41.920 0           0      pg   localhost    simon 4 "2 3+3 4 5"        0  length
2008.05.13 11:48:46.512 0.003025343 0      pc   192.168.1.34 simon 0 ,"4"               1
q)
```


### `logusage.q` and `loadusage.q`

Finally, the all-singing all-dancing version. This script logs all requests directly to an external logfile – using the same log mechanism as kdb+tick. This allows logging to be left running for days without having to worry about tables growing – and will ensure that the logging data is safe even if the session terminates unexpectedly. Use `loadusage.q` to load the logged data into a session as a table (same schema as that from `monitorusage.q` except hostname added).

```q
dotz$ q logusage.q -p 5001
…
q)'type
q)\\ / nothing to see here..
dotz$ q loadusage.q
…
q)USAGE
date       time         ms           mdelta zcmd ipa          host      u     w cmd            ok error
--------------------------------------------------------------------------------------------------------
2008.05.13 13:01:42.694 0.002003799  0      pw   127.0.0.1    localhost       5 (`simon;"***") 1
2008.05.13 13:01:42.695 0.0009822543 0      po   127.0.0.1    localhost simon 5 5              1
2008.05.13 13:01:46.198 0.0159911    0      pg   127.0.0.1    localhost simon 5 2+2            1
2008.05.13 13:01:57.350 0            0      pg   127.0.0.1    localhost simon 5 2 3+3 4 5      0  length
2008.05.13 13:02:00.901 0.004007597  0      pc   192.168.1.34           simon 0 5              1
q)q)select from USAGE where not ok
date       time         ms mdelta zcmd ipa       host      u     w cmd       ok error
--------------------------------------------------------------------------------------
2008.05.13 11:50:55.988 0  0      pg   127.0.0.1 localhost simon 5 2 3+3 4 5 0  length
q)
```


## Slamming the doors

Another important use for modified `.z.p`? callbacks is to control access to a q session. Q contains some very coarse access controls settable by command-line options – particularly [`-u`](../basics/cmdline.md#-u-usr-pwd-local) or [`-U`](../basics/cmdline.md#-u-usr-pwd) to enforce password-controlled access (with MD5 passwords), [`-b`](../basics/cmdline.md#-b-blocked) to enforce read-only access and [`-T`](../basics/cmdline.md#-t-timeout) to set a maximum CPU time per single client call.

The password control in `-u` and `-U` is all done in the kdb+ executable, so completely outside user control. However as soon as the initial check (if any) has been done control is passed to `z.pw`, which can say if a connection is to be allowed. This can be via some session internal table or function, or can go outside to something like a central single-signon server.


### `blockusage.q`

Use this script simply to block all client interaction: it just sets `.z.pw` to always return false, i.e. no connection is allowed for supplied user ID and password.


### `controlaccess.q` and `loadinvalidaccess.q`

There are so many ways to control access that this script is way too complicated for immediate use as it stands – just pick an interesting subset.

It shows how to control access via

-   a user table – splitting users into superusers (who can do anything), powerusers (who can run ad-hoc queries, but can’t do things like shutdown the session) and defaultusers (who can only use a speciic list of pre-defined commands).
-   the client’s server – with name matching a set of wildcards
-   a list of valid commands
-   a command validator which parses input

Invalid access attempts are logged, and the logfile can be loaded into a table and queried with `loadinvalidaccess.q`


## Tracking clients and servers

Q provides a a list of handles in use with the keys of `.z.W`. These clients provide more background information about what's “behind” the handles by extending `.z.po` and `.z.pc`.


### `trackclients.q`

Tracking of clients can be automated using this script, `.z.po` and `.z.pc` maintain the list automatically.

By default, the table of clients just uses information provided by `.z.po` like `.z.u` and `.z.w`, but if `.clients.INTRUSIVE` is set, the server will ask the clients for more details like their q versions, number of secondary processes etc.

Output from a session where a client did three `hopen 5001`s, and one `hclose`.

```q
dotz$ q trackclients.q -p 5001
…
q)CLIENTS
w| ipa       u     a          poz                     pcz
-| --------------------------------------------------------------------------
4| localhost simon 2130706433 2008.05.13T13:37:14.176
5| localhost simon 2130706433 2008.05.13T13:37:15.007
 | localhost simon 2130706433 2008.05.13T13:37:15.735 2008.05.13T13:37:26.359
q)
```


### `trackservers.q`

Giving client applications the ability to track servers simplifies application design – no need to hardcode server+port settings, or to handle servers becoming unavailable.

Unlike `trackclients.q` you do have to add server records manually, although `.z.pc` handles them going away. You can either add a new server using a function like `.servers.addnh` (`nh` is name, hpup) or add a server record for an existing open handle using `.servers.addw`.

Servers can be public or private – a private server is not handed on to other users who request a list of current servers (the simplest way of setting up a new session, no central “handle server” to be maintained).

By default servers that disappear are retried regularly.

```bash
$ q trackservers.q
```

```q
q).servers.addw hopen`:welly3:2018
3
q).servers.addw hopen`:welly3:2017
4
q)SERVERS
name     hpup            w hits private lastz
---------------------------------------------------------------
servers  :192.168.1.34:0 0 0    1       2008.05.13T13:44:10.337
taq2007  :welly3:2018    3 0    0       2008.05.13T13:45:00.761
lava2006 :welly3:2017    4 0    0       2008.05.13T13:45:05.400
q)SERVERS
name     hpup            w hits private lastz
---------------------------------------------------------------
servers  :192.168.1.34:0 0 0    1       2008.05.13T13:44:10.337
taq2007  :welly3:2018    3 0    0       2008.05.13T13:45:00.761
lava2006 :welly3:2017    4 0    0       2008.05.13T13:45:05.400
q).servers.handlefor`lava2006
4
q).servers.handlefor`lava2007
'lava2007.not.available
q)SERVERS
name     hpup            w hits private lastz
---------------------------------------------------------------
servers  :192.168.1.34:0 0 0    1       2008.05.13T13:44:10.337
taq2007  :welly3:2018    3 0    0       2008.05.13T13:45:00.761
lava2006 :welly3:2017    4 1    0       2008.05.13T13:45:44.824
q)
```

Adding servers with user supplied name with `.servers.addnh`:

```q
q).servers.addnh[`taq;`::5001]
3
q).servers.addnh[`taq;`::5001]
5
q).servers.addnh[`taq;`::5001]
6
q).servers.addnh[`taq;`::5001]
7
q)SERVERS
name     hpup            w hits private lastz
---------------------------------------------------------------
servers  :192.168.1.34:0 0 0    1       2008.05.13T13:44:10.337
taq2007  :welly3:2018    3 0    0       2008.05.13T13:45:00.761
lava2006 :welly3:2017    4 1    0       2008.05.13T13:45:44.824
taq      ::5001          3 0    0       2008.05.13T13:50:03.777
taq      ::5001          5 0    0       2008.05.13T13:50:05.513
taq      ::5001          6 0    0       2008.05.13T13:50:06.848
taq      ::5001          7 0    0       2008.05.13T13:50:07.640
q).servers.handlefor`taq
3
q).servers.handlefor`taq
5
q).servers.handlefor`taq
6
q).servers.handlefor`taq
7
q).servers.handlefor`taq
3
```


## Running on other servers

The default Q IPC allows you to easily submit synchronous or asynchronous requests. Combined with a list of all available servers from `trackservers.q` above you can deal with most simple requests.


### `remotetasks.q`

This script provides an extra way of dealing with a lot of data requests. It allows you to submit synchronous or asynchronous requests, locally or remotely – and collects all the results in a local table `TASKS`. So, for example, if you had to run a few hundred queries to be able to build a report and you had 10 server sessions available to query you’d simply submit all 100 queries and either pick up results as they drift in, or wait until all are complete.

You can additionally allocate requests to a request group to make it easy to check when a complete group has completed.

Here’s an example session using two servers on 5001 and 5002. First create the server table entries.

```q
q).servers.addnh[`hh;`::5001]
5
q).servers.addnh[`hh;`::5002]
6
q).servers.addnh[`hh;`::5002]
7
q)SERVERS
name    hpup            w hits private lastz
--------------------------------------------------------------
servers :192.168.1.34:0 0 0    1       2008.05.13T18:37:41.087
hh      ::5001          5 0    0       2008.05.13T18:38:59.455
hh      ::5002          6 0    0       2008.05.13T18:39:03.886
hh      ::5002          7 0    0       2008.05.13T18:39:05.390
```

Submit a few tasks:

```q
q).tasks.rxa[.servers.handlefor`hh;"max til 10"]
10001
q).tasks.rxa[.servers.handlefor`hh;"max til 10"]
10002
q).tasks.rxa[.servers.handlefor`hh;"max til 10"]
10003
q)TASKS
nr   | grp   startz                  endz                    w ipa       status   expr         result
-----| ----------------------------------------------------------------------------------------------
10001| 20001 2008.05.13T18:41:43.057 2008.05.13T18:41:43.058 5 localhost complete "max til 10" 9
10002| 20002 2008.05.13T18:41:46.138 2008.05.13T18:41:46.138 6 localhost complete "max til 10" 9
10003| 20003 2008.05.13T18:41:47.009 2008.05.13T18:41:47.010 7 localhost complete "max til 10" 9
q).tasks.results 10002
10002| 9
q).tasks.results .tasks.completed[]
10001| 9
10002| 9
10003| 9
```

and one invalid task:

```q
q).tasks.rxa[.servers.handlefor`hh;"17+`this"]
10004
q).tasks.failed[]
,10004
q).tasks.results 10004
q).tasks.status 10004
10004| fail
q)TASKS
nr   | grp   startz                  endz                    w ipa       status   expr         result
-----| ----------------------------------------------------------------------------------------------
10001| 20001 2008.05.13T18:41:43.057 2008.05.13T18:41:43.058 5 localhost complete "max til 10" 9
10002| 20002 2008.05.13T18:41:46.138 2008.05.13T18:41:46.138 6 localhost complete "max til 10" 9
10003| 20003 2008.05.13T18:41:47.009 2008.05.13T18:41:47.010 7 localhost complete "max til 10" 9
10004| 20004 2008.05.13T18:44:05.229 2008.05.13T18:44:05.229 5 localhost fail     "17+`this"   "type"
q)
```


## Utilities


### `hutil.q`


!!! note "Production usage"

    All these utility files should be treated as examples. For any particular case they probably have too many options and should be cut down to do just what you want. The access control script is the most obvious case - it probably has far too many options/checks going on.

## :fontawesome-regular-hand-point-right: Further reading

-   [Namespace `.z`](../ref/dotz.md ".z namespace")
-   [Changes in V2.4](../releases/ChangesIn2.4.md)
-   _Q for Mortals_: [§11.6 Interprocess Communication](/q4m3/11_IO/#116-interprocess-communication)
-   [Authentication and access](authentication.md)
