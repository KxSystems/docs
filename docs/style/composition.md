---
author: Stevan Apter
keywords: compose, composition, each, kdb+, over, q, style
---

# Compose out eaches




Learn to spot expressions with sequential Eaches such as this one:

```q
first each reverse each v        / first of each reverse of each v
```

and replace them with function compositions like this:

```q
'[first;reverse] each v          / last of each v
```

Combine [Compose](../ref/compose.md) with [`over`](../ref/accumulators.md) to join longer sequences of functions:

```q
('[;] over (upper;first;reverse)) each v
```

In general, seek to replace patterns like 

```q
f each g each … h each v
```

with any of (the forms are equivalent)

```q
('[;] over (f;g;…;h)) each v
(('[;]/) (f;g;…;h)) each v
'[;]/[(f;g;…;h)] each v
'[;]/[(f;g;…;h)]'[v]
```

Here’s another example:

```q
q)reverse each ,':[1 2 3 4]
  1
1 2
2 3
3 4
q)'[reverse;,]':[1 2 3 4]
  1
1 2
2 3
3 4
```

Compositions are faster than sequential Eaches (one iteration replaces many), and easier to read – and code!

```q
0<('[type;key]) each paths         / dictionaries in lists of paths
```

