---
title: A tour of kdb+ and the q programming language
author: Stephen Taylor
date: February 2020
description: A mountain tour of kdb+ and the q programming language, with links to explore topics in depth
---
# A mountain tour of kdb+ and the q programming language


![Mountain walk](img/GettyImages-914651812.jpg)


## `TL;DR`

-   Kdb+ is an in-memory, column-store database optimized for time series. It has a tiny footprint and is seriously quick.
-   The q vector-programming language is built into kdb+. It supports SQL-style queries.
-   Q expressions are interpreted in a REPL.
-   Tables, dictionaries and functions are first-class objects.. 
-   Kdb+ persists objects as files. A large table is stored as a directory of column files.
-   Explicit loops are rare. Iteration over lists is implicit in most operators; otherwise mostly handled by special iteration operators. 
-   Parallelization is implicit: operators use multithreading where it helps. 
-   Interprocess communication is baked in and startlingly simple.

:fontawesome-regular-hand-point-right:
[Start the tour](index.md)