---
title: eval, reval
description: eval and reval are q keywords that evaluate parse trees.
author: Stephen Taylor
keywords: eval, kdb+, q, reval
---
# `eval`, `reval`

_Evaluate a parse tree_




## eval

Syntax: `eval x`, `eval[x]`

Where `x` is a parse tree, returns the result of evaluating it. 

The `eval` function is the complement of [`parse`](parse.md) and can be used to evaluate the parse trees it returns. (Also parse trees constructed explicitly.)

```q
q)parse "2+3"
+
2
3
q)eval parse "2+3"
5
q)eval (+;2;3)      / constructed explicitly
5
```





## `reval`


Syntax: `reval x`, `reval[x]`

The `reval` function is similar to [`eval`](eval.md), and behaves as if the [command-line option `-b`](../basics/cmdline.md#-b-blocked) were active during evaluation.

An example usage is inside the message handler [`.z.pg`,](dotz.md#zpg-get) useful for access control, here blocking sync messages from updating:

```q
q).z.pg:{reval(value;enlist x)} / define in process listening on port 5000
q)h:hopen 5000 / from another process on same host
q)h"a:4"
'noupdate: `. `a
```

!!! tip "Partitioned databases"

    For partitioned databases, q caches the count for a table, and this count cannot be updated from within a `reval` expression or from a slave thread. Thus to avoid `'noupdate` on queries on partitioned tables you should put `count table` in your startup script.


<i class="far fa-hand-point-right"></i>
Basics: [Internal function `-6!`](../basics/internal.md#-6x-eval)

