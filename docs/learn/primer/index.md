---
title: Introduction | Q language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Introduction to the kdb+ database and q language, used for Dennis Sasha’s college classes
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Q language primer



![Manhattan panorama](img/manhattan.jpg)
<!-- GettyImages-1168983656.jpg -->

This primer is aimed at new developers with a technical background, an interest in data science, and prior acquaintance with [Python](https://python.org).

[Kdb+](https://kx.com) is a high-performance, in-memory, column-store database widely used in demanding applications.
Q is the programming language built into it.
It provides expressability and a powerful SQL dialect. 



## How to use this 

We present the essential features of q through simple examples. Please read the examples and the surrounding commentary carefully. Try to execute the queries in your head as you read. 

If the result of an expression is unclear to you, first confirm in your q session that it is correct¹. Execute and study parts of the expression. Try variations to test your understanding. Consult the [Reference](../../ref/index.md). 

Interprocess communication, file input/output, interaction with other languages, performance issues, and a few other topics, are dealt with in the appendix. 


## Getting started

Once you download q, you should be able to start the environment by typing the single letter `q` on a line by itself and hitting return.

<i class="fas fa-graduation-cap"></i>
[Installing kdb+](../install/index.md)

!!! info "Editor’s note"

    Adapted from [Dennis Shasha](mailto:shasha@cs.nyu.edu)’s [_Kdb+ Database and Language Primer_](https://legaldocumentation.kx.com/q/d/a/primer.htm) (2004) written for his CS course at New York University.

¹ And tell the [Librarian](milto:librarian@kx.com) if it is not.

---
<i class="far fa-hand-point-right"></i>
[Datatypes](datatypes.md)