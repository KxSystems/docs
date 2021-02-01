---
title: Firewalling | Knowledge Base | kdb+ and q documentation
description: How to protect a kdb+ process with a firewall
keywords: firewall, ipc, iptables, kdb+, q
---
# Firewalling



_Tips for securing your application_

Run kdb+ as a separate (non-root) user. If you need it to run on port 80, use [authbind](https://en.wikipedia.org/wiki/Authbind) or [iptables redirect](https://www.frozentux.net/iptables-tutorial/chunkyhtml/x4529.html).

Do not allow that user to write to any directory or files. If you need file access, arbitrate it via IPC with another kdb+ process. Pay attention to how that process will return values via [`.z.pg`](../ref/dotz.md#zpg-get "get") or [`.z.ps`](../ref/dotz.md#zps-set "set") or similar.

Firewall _all_ ports inbound and outbound except ones explicitly used. 

!!! tip "Use [iptables owner match](https://www.frozentux.net/iptables-tutorial/chunkyhtml/x2702.html#OWNERMATCH)"

For any backend kdb+ processes, restrict them to `localhost` or a protected network (e.g. `iptables --pol ipsec`)

Set process limits with [ulimit](http://tldp.org/LDP/solrhe/Securing-Optimizing-Linux-RH-Edition-v1.3/x4733.html) no larger than you need them.

Restrict input by defining at least:

```q
.z.pc:{}
.z.pg:{}
.z.ph:{}
.z.pi:{}
.z.pm:{}
.z.po:{}
.z.pp:{}
.z.pq:{}
.z.ps:{}
```

:fontawesome-regular-hand-point-right:
[Namespace `.z.`](../ref/dotz.md)

To allow certain IPC calls, implement only the ones you want. A denylist for functions is tricky because some otherwise useful functions may have a mode that accesses the disk which may cause information leak (e.g. [key](../ref/key.md)). It is much easier to use an allowlist. 

As IPC functions either receive a [parse tree](../basics/parsetrees.md) or a string (that you could [parse](../ref/parse.md) yourself), check the type of the input e.g. `x:$[10h=type x;parse x;x]`

If you use WebSockets, define:
```q
.z.wc:{a[.z.a]-:1}
.z.wo:{$[2<;a[.z.a]+:1;hclose .z.w;1]}
```

When handling untrusted input, consider designing your application to wrap public entrypoints with [`reval`](../ref/eval.md#reval).

Pay attention to the fact that each WebSocket client can open up a _lot_ of connections (200 on Mozilla, 256 for Chrome), so limit using [`.z.a`](../ref/dotz.md#za-ip-address "IP address").

Log connections and consider using [fail2ban](http://www.fail2ban.org/wiki/index.php/Main_Page) to block suspicious traffic.

---
:fontawesome-solid-graduation-cap:
[Callbacks](../kb/callbacks.md),
[Using `.z`](../kb/using-dotz.md)
<br>
:fontawesome-regular-map:
[Permissions with kdb+](../wp/permissions/index.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals:_ 
[§11.6 Interprocess Communication](/q4m3/11_IO/#116-interprocess-communication)
