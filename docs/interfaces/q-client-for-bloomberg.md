---
title: Q client for Bloomberg
description: A Linux-based feed handler for Bloomberg
keywords: api, bloomberg, interface, kdb+, library, q
---
# ![Bloomberg](img/bloomberg.png) Q client for Bloomberg




Marshall Wace has kindly contributed a Linux-based Bloomberg Feed Handler, written by Sufian Al-Qasem & Attila Vrabecz, using the [Bloomberg Open Api](http://www.openbloomberg.com/open-api/). 

<i class="fab fa-github"></i> 
[KxSystems/cookbook/bloomberg](https://github.com/KxSystems/cookbook/tree/master/bloomberg)


## Design notes

Bloomberg uses an event-driven model whereby they push EVENT objects to consumers – SUMMARY, TRADE and QUOTE. The C code in `bloomberg.c` handles the connectivity to the Bloomberg appliance (hosted on client’s site) and also does the conversion from an EVENT object to a dictionary (Bloomberg mnemonic &lt;&gt; Value pair) which is then processed on the q main thread via the following:

```q
Update:{@[value;x;-1“Update: '”,string[x 0]," ",]}
```

The Bloomberg API calls back on a separate thread and copies a pointer to that object onto a lock-free queue; `eventfd` is then used to create a K struct (a dictionary representation of the EVENT) on the q main thread and process. A function is defined for every EVENT type (Authorize/SessionStarted/MarketDataEvent/etc …) which carries out the desired behaviour in q.

Tested with Bloomberg Open API 3.6.2.0 and 3.7.5.1. Uses <http://www.liblfds.org>
