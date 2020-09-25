---
title: ratios between successive items of a list | Reference | kdb+ and q documentation
description: ratios is a q keyword that returns the ratios between successive items of a list.
author: Stephen Taylor
---
# `ratios`






_Ratios between items_

```txt
  ratios y     ratios[y]
x ratios y     ratios[x;y]
```

Where

-   `x` is a numeric atom
-   `y` is a numeric list

returns the ratios of consecutive pairs of items of numeric list `y`.

`ratios` is an aggregate function.


Where applied as:

- a binary function, the result is
<pre><code class="language-txt">(%[y 0;x];%[y 1;y 0];%[y 2;y 1];…;%[y n-1;y n-2])</code></pre>
<pre><code class="language-q">q)ratios[5;1 2 4 6 7 10]
0.2 2 2 1.5 1.166667 1.428571
</code></pre>

- a unary function, `y[0]` replaces the `x` in the binary application.
<pre><code class="language-q">q)ratios 1 2 4 6 7 10
1 2 2 1.5 1.166667 1.428571
</code></pre>

Example: a query to get returns on prices:

```q
q)update ret:ratios price by sym from trade
q)select log ratios price from trade
```


----
:fontawesome-solid-book:
[Each Prior](maps.md#each-prior),
[`differ`](differ.md),
[Divide](divide.md)
<br>
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)


