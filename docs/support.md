---
title: Support for kdb+ | kdb+ and q documentation
description: We are proud to provide industry-acclaimed support for our customers, typically responding to technical inquiries within minutes, and offering solutions within the day.
author: Stephen Taylor
---
# :fontawesome-solid-life-ring: Support



We are proud to provide industry-acclaimed support for our customers, starting with free, onsite evaluations for qualified prospects with application requirements well-suited for KX technology.

We pride ourselves on being highly responsive to customer needs, typically responding to technical inquiries within minutes, and offering solutions within the day; these are responses from knowledgeable staff who are familiar with the code at a very deep level, not scripted responses from an outsourced support center.

Beyond this, we offer a full ecosystem of resources – of both the material and the human variety – that enhances the experiences of our customers.


## :fontawesome-solid-handshake: Sales inquiries

Write to sales@kx.com or visit our [Contact page](https://kx.com/about-kx/#contact-us).


## :fontawesome-regular-comments: kdb+ Topicbox

If you work at a company that has licensed kdb+, you can join the [k4 Topicbox group](https://k4.topicbox.com/groups/k4?subscription_form=e1ca20f8-95f6-11e8-8090-9973fa3f0106).


## :fontawesome-solid-hands-helping: Designated Contacts

Licensed customers designate to KX staff members whom they have authorized to deal with kdb+ licenses, downloads and bug reports. Designated Contacts can reach us at the following addresses.

topic                               | address
------------------------------------|---------------------
Software download                   | downloadadmin@kx.com
License request                     | licadmin@kx.com
Urgent license request              | failover@kx.com
Suspected bug, unexpected behavior  | tech@kx.com


## :fontawesome-solid-life-ring: Technical support

If you work at a company that has licensed kdb+, please refer to your internal support team, your Designated Contact, or the kdb+ Listbox.


## :fontawesome-solid-bug: Reporting bugs

!!! important "Licensed customers of KX should report bugs in KX products to the email group <tech@kx.com>."

Other application errors or programming assistance requests should be referred to your company’s internal support groups or via the [community support channels](https://kx.com/connect-with-us/#support).

When reporting a bug please don’t just email one person directly. They may be unavailable and your report would go unseen; in any case that person would automatically forward it to <tech@kx.com>.

Include in the bug report:

-   the exact version of kdb+ being used. Including the **start-up banner** is the simplest way to do this:

    <pre><code class="language-txt">
    KDB+ 3.5t 2017.02.28 Copyright (C) 1993-2017 Kx Systems
    m32/ 4()core 8192MB sjt mint.local 192.168.0.39 NONEXPIRE
    </code></pre>

    If you aren’t using the latest version of kdb+, please confirm that the problem still occurs in the latest version (from [downloads.kx.com](http://downloads.kx.com)) – the problem may already have been reported and fixed.

-   information about the **OS being used**, machine configuration and file system (if relevant).
-   details of any **external code** (DLLs, user-written primitives) loaded into the problem session.
If external code is being loaded into the session verify that the problem still occurs when it is _not_ loaded.
-   every KX customer has a designated **technical contact** –  please copy them on the email.
-   if appropriate, include **contact details**, and information about when it’s convenient to contact you.
-   detailed list of steps to be taken to **reproduce the error**. Try to isolate the problem to a few lines of q and a tiny sample of data.

!!! danger "Don’t send complete applications, or commercially sensitive code or data!"

Don’t send **core-dumps** unless requested: they are typically meaningful only on the machine where they were generated. If you know how to generate a **backtrace** from a core-dump, please do send us the backtrace.


:fontawesome-solid-globe: [How to Report Bugs Effectively](https://www.chiark.greenend.org.uk/~sgtatham/bugs.html)

----
:fontawesome-solid-user-friends: 
[Community](community.md):
Users of the Personal Edition support each other 