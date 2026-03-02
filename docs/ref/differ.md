---
title: differ – Reference – KDB-X and q documentation
description: differ is a q keyword that flags where items of a list change value.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: diff, differ, KDB-X, item, list, q
---
# `differ`

_Find where list items change value_

```syntax
differ x    differ[x]
```

Returns a boolean list indicating where consecutive pairs of items in `x` differ.
It applies to all data types.

`differ` is a uniform function.
The first item of the result is always `1b`.

```txt
    r[i]=1b                 for i=0
    r[i]=not A[i]~A[i-1]    otherwise
```

```q
q)differ`IBM`IBM`MSFT`CSCO`CSCO
10110b
q)differ 1 3 3 4 5 6 6
1101110b
q)differ (7;`a;`a;09:34)
1101b
```

!!! tip

    Combine with [Cut (`_`)](cut.md) to split a table with multiple dates into a list of tables with distinct dates.

    ```q
    q)d:2009.10.01+asc 100?30
    q)s:100?`IBM`MSFT`CSCO
    q)t:([]date:d;sym:s;price:100?100f;size:100?1000)
    q)i:where differ t[`date]    / indices where dates differ
    q)tlist:i _ t                / list of tables with one date per table
    q)tlist 0
    date       sym  price    size
    -----------------------------
    2009.10.01 IBM  37.95179 710
    2009.10.01 CSCO 52.908   594
    2009.10.01 MSFT 32.87258 250
    2009.10.01 CSCO 75.15704 592
    q)tlist 1
    date       sym  price   size
    ----------------------------
    2009.10.02 MSFT 18.9035 26
    2009.10.02 CSCO 12.7531 760
    ```

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  B B B B B B B B B B B B B B B B B B
```

`differ` is a [multithreaded primitive](mt-primitives.md).

??? warning "Binary use deprecated"

    As of V3.6 the keyword is [variadic](../basics/variadic.md). 
    Binary application is deprecated and may disappear in future versions.
    The keyword cannot be applied infix. 

    For a binary version, use Match Each Prior: `~:'`.

---

[Comparison](comparison.md)
