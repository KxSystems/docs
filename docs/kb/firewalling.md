Run q as a separate (non-root) user. If you need it to run on port 80, use [authbind](https://en.wikipedia.org/wiki/Authbind) or [iptables redirect](https://www.frozentux.net/iptables-tutorial/chunkyhtml/x4529.html)

Do not allow that user to write to any directory or files. If you need file access, arbitrate it via IPC with another q process. Pay attention to how that process will return values via [.z.pg](/basics/dotz/#zpg-get "get") or [.z.ps](/basics/dotz/#zps-set "set") or similar.

Firewall _all_ ports inbound and outbound except ones explicitly used. 

!!! tip
    Use [iptables owner match](https://www.frozentux.net/iptables-tutorial/chunkyhtml/x2702.html#OWNERMATCH). 

For any backend q processes, restrict them to localhost or a protected network (e.g. `iptables --pol ipsec`)

Set process limits with [ulimit](http://tldp.org/LDP/solrhe/Securing-Optimizing-Linux-RH-Edition-v1.3/x4733.html) no larger than you need them.

Restrict input by defining at least:

- [.z.pg](/basics/dotz/#zpg-get "get"):{}
- [.z.ph](/basics/dotz/#zph-http-get "HTTP get"):{}
- [.z.pi](/basics/dotz/#zpi-input "input"):{}
- [.z.pm](/basics/dotz/#zpm-http-options "HTTP options"):{}
- [.z.po](/basics/dotz/#zpo-open "open"):{}
- [.z.pp](/basics/dotz/#zpp-http-post "HTTP post"):{}
- [.z.ps](/basics/dotz/#zps-set "set"):{}

If you want to allow certain IPC calls, implement only the ones you want. Trying to blacklist functions is tricky because some otherwise useful functions may have a mode that accesses the disk which may cause information leak (e.g. [key](/basics/metadata/#key)). It is much easier to use a whitelist approach. Whitepaper [Permissions with kdb+](/wp/permissions_with_kdb.pdf) has some suggestions here.

As IPC functions either receive a [parse tree](/basics/parsetrees/) or a string (that you could [parse](/basics/parsetrees/#parse) yourself), make sure you check the type of the input e.g. `x:$[10h=type x;parse x;x]`

If you use WebSockets, define:

- [`.z.wc`](/basics/dotz/#zwc-websocket-close "WebSocket close")`:{a[` [`.z.a`](/basics/dotz/#za-ip-address "IP address")`]-:1}`
- [`.z.wo`](/basics/dotz/#zwo-websocket-open "open")`:{$[2<;a[`[`.z.a`](/basics/dotz/#za-ip-address "IP address")`]+:1;hclose` [`.z.w`](/basics/dotz/#zw-handle)`;1]}`

When handling untrusted input, consider designing your application to wrap public entrypoints with [reval](/basics/parsetrees/#reval).

Pay attention to the fact that each WebSocket client can open up a _lot_ of connections (200 on Mozilla, 256 for Chrome), so limit using [`.z.a`](/basics/dotz/#za-ip-address "IP address").

Log connections and consider using [fail2ban](http://www.fail2ban.org/wiki/index.php/Main_Page) to block suspicious traffic.
