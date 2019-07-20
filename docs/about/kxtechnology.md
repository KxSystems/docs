---
title: Kx technology
description: The Kx Systems technology consists of kdb+, the database; q, an analytic and query language for kdb+ users; k, the programming language used to implement both kdb+ and q. This reference documents q – the main language for working with kdb+. The kdb+ database and q language were introduced in 2003 as part of a 64-bit rewrite of the earlier kdb database. The underlying k language and databases have been developed since 1993.
author: Stephen Taylor
keywords: bug, error, k, kdb+, q, report, technology
---

# Kx technology

<div class="kx-zero">
<img src="../../img/hieroglyphics.png" style="width: 100%"/>
</div>

> I can’t understand why people are frightened of new ideas. I’m frightened of the old ones.  
— _John Cage_




The Kx Systems technology consists of:

-   kdb+ – the database
-   q – an analytic and query language for kdb+ users
-   k – the programming language used to implement both kdb+ and q

This reference documents q – the main language for working with kdb+.

The kdb+ database and q language were introduced in 2003 as part of a 64-bit rewrite of the earlier kdb database. The underlying k language and databases have been developed since 1993.


## Reporting bugs in Kx products

Licensed customers of Kx should report bugs in Kx products to the email group <tech@kx.com>.

Other application errors or programming assistance requests should be referred to your company’s internal support groups or via the [community support channels](https://kx.com/connect-with-us/#support).

When reporting a bug please don’t just email one person directly. They may be unavailable and your report would go unseen; in any case that person would automatically forward it to <tech@kx.com>.

When sending the bug report please ensure that you include the following information:

-   the exact version of kdb+ being used. Including the start-up banner is the simplest way to do this:

    <pre><code class="language-txt">
    KDB+ 3.5t 2017.02.28 Copyright (C) 1993-2017 Kx Systems
    m32/ 4()core 8192MB sjt mint.local 192.168.0.39 NONEXPIRE
    </code></pre>

    If you aren’t using the latest version of kdb+, please confirm that the problem still occurs in the latest version (from [kxdownloads.com](http://kxdownloads.com)) – the problem may already have been reported and fixed.

-   information about the **OS being used**, machine configuration and file system (if relevant).
-   details of any **external code** (DLLs, user-written primitives) loaded into the problem session.  
If external code is being loaded into the session verify that the problem still occurs when it is _not_ loaded.
-   every Kx customer has a designated **technical contact** –  please copy them on the email.
-   if appropriate, include **contact details**, and information about when it’s convenient to contact you.
-   detailed list of steps to be taken to **reproduce the error**. Try to isolate the problem to a few lines of q and a tiny sample of data.  

Don’t send complete applications, or commercially sensitive code or data!  

Don’t send core-dumps unless requested, they’re typically meaningful only on the machine where they were generated. If you know how to generate a backtrace from a core-dump, please do send us the backtrace.


<i class="far fa-hand-point-right"></i> [Simon Tatham, How to Report Bugs Effectively](http://www.chiark.greenend.org.uk/~sgtatham/bugs.html)
