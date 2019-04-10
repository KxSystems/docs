---
title: Dictionaries & tables
keywords: dictionary, group, kdb+, q, sort, table
---

# Dictionaries and tables




!!! warning "Duplicate keys or columns"

    Avoid duplicating keys in a dictionary or (column names in a) table.
    
    Q does not reject duplicate keys, but operations on dictionaries and tables with duplicate keys are **undefined**. 


[`!` Dict](../ref/dict.md)

:  Make a dictionary from two lists

[`group`](../ref/group.md) 

: Group table entries by key values, return a dictionary

[`ungroup`](../ref/ungroup.md)

: Normalize a table of same-length lists

[`xasc`](../ref/asc.md#xasc)

: Sort a table in ascending order

[`xcol`](../ref/cols.md#xcol)

: Rename table columns

[`xcols`](../ref/cols.md#xcols)

: Re-order table columns

[`xdesc`](../ref/desc.md#xdesc)

: Sort a table in descending order

[`xgroup`](../ref/xgroup.md)

: Group a table by values in selected columns

[`xkey`](../ref/keys.md#xkey)

: Set specified columns as primary keys of a table


<i class="far fa-hand-point-right"></i>
Reference: Apply, Index, Trap: [Step dictionaries](../ref/apply.md#step-dictionaries)