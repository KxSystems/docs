---
title: Sorting functions
description: Operators and keywords for sorting lists
author: Stephen Taylor
keywords: asc, ascending, desc, descending, grade, group, iasc, idesc, kdb+, q, rank, sort, xgroup, xrank
---
# Sorting functions



Operators and keywords for sorting lists.

function                        | semantics
--------------------------------|------------------------
[`asc`](../ref/asc.md)          | Sort ascending 
[`desc`](../ref/desc.md#desc)   | Sort descending
[`group`](../ref/group.md)      | Group a list by values
[`iasc`](../ref/asc.md#iasc)    | Grade ascending 
[`idesc`](../ref/desc.md#idesc) | Grade descending
[`rank`](../ref/rank.md)        | Position in sorted list
[`xgroup`](../ref/xgroup.md)    | Group table by values of selected column/s
[`xrank`](../ref/xrank.md)      | Group by value
[`xasc`](../ref/asc.md#xasc)    | Sort table ascending
[`xdesc`](../ref/desc.md#xdesc) | Sort table descending


!!! warning "Duplicate keys or column names"

    Duplicate keys in a dictionary or duplicate column names in a table will cause sorts, grades, and groups to return unpredictable results.


!!! warning "Compressed columns on disk"

    Re-sorting compressed data on disk decompresses it. 


<i class="far fa-hand-point-right"></i> 
[Dictionaries & tables](dictsandtables.md)

