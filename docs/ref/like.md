---
title: like – matches patterns | Reference | kdb+ and q documentation
description: like is a q keyword that matches text to a pattern.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `like`

_Whether text matches a pattern_

```syntax
x like y    like[x;y]
```

Where

- `x` is a symbol or string
- `y` is a pattern as a string

returns a boolean: whether `x` matches the pattern of `y`.

```q
q)`quick like "qu?ck"
1b
q)`brown like "br[ao]wn"
1b
q)`quickly like "quick*"
1b
```

Absent [pattern characters](regex.md) in `y`, `like` is equivalent to `{y~string x}`.

```q
q)`quick like "quick"
1b
q)`quick like "quickish"
0b
```

## Implicit iteration

`like` applies to lists of strings or symbols; and to dictionaries with them as values.

```q
q)`brawn`brown like "br[^o]wn"
10b

q)(`a`b`c!`quick`brown`fox)like "brown"
a| 0
b| 1
c| 0
```

----

[`ss`, `ssr`](ss.md),
<br>

[Regular expressions in q](regex.md),
[Strings](by-topic.md#strings)
<br>

[Using regular expressions](regex.md)
