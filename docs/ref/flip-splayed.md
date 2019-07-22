---
title: Flip Splayed or Partitioned
description: Flip Splayed or Partitioned is a q operator that returns the flip of a splayed orpartitioned table.
author: Stephen Taylor
keywords: flip, flip splayed, kdb+, partitioned, q, splayed, table
---
# `!` Flip Splayed or Partitioned




Syntax: `x!y`, `![x;y]`

Where `x` is a symbol list and `y` is

-   an **hsym symbol atom** denoting a **splayed** table
-   a **non-hsym symbol atom** denoting a **partitioned** table

returns the flip of `y`.


<i class="far fa-hand-point-right"></i>
Basics: [Dictionaries & tables](../basics/dictsandtables.md)