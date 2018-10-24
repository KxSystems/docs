---
hero: Interfaces
title: Java API for kdb+
author: Peter Lyness
date: May 2018
keywords: API, Java, interface, connection
---

# Java API for kdb+


The Java programming language has been consistently popular for two decades, and is important in many development environments. Its longevity, and the compatibility of code between versions and operating systems, leaves the landscape of Java applications in many industries very much divided between new offerings and long-established legacy code.

Financial technology is no exception. 
Competition in this risk-averse domain drives it to push against boundaries. 
Production systems inevitably mix contemporary and legacy code. 
Because of this, developers need tools for communication and integration.
Implementation risks must be kept to a strict minimum.
Kx technology is well-equipped for this issue.
By design kdb+’s communication with external processes is kept simple, and reinforced with interface libraries for other languages.

The Java API for kdb+ is a Java library. 
It fits easily in any Java application as an interface to kdb+ processes. 
As with any API, potential use cases are many. 
To introduce kdb+ gradually into a wider system, such an interface is essential for any interaction with Java processes, upstream or downstream. 
The straightforward implementation keeps changes to legacy code lightweight, reducing the risk of wider system issues arising as kdb+ processes are introduced.

This paper illustrates how the Java API for kdb+ can be used to enable a Java program to interact with a kdb+ process. 
It first explores the API itself: how it is structured, and how it might
be included in a development project. 
Examples are then provided for core use cases for the API in a standard setup. 
Particular consideration is given to how the API facilitates subscription and publication to a kdb+ tickerplant process, a core component of any kdb+ tick-capture system.

The examples presented here form a set of practical templates complementary to the [primary source of information](/interfaces/java-client-for-q) on code.kx.com.
These templates can be combined and adapted to apply kdb+ across a
broad range of problem domains. They are available on <i class="fa fa-github"></i> [GitHub](https://github.com/kxcontrib/java-for-kdb-examples).

