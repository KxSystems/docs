---
author: Stevan Apter
keywords: kdb+, q, style
---

# What’s in a script?


<!-- FIXME
Omitted parts refer to K. 
Is what’s left worth keeping?
 -->

A script template used by one programmer consists of the following sections:

```q
\l subscript.q          / load subscripts
…

\e 1                    / global state-settings
…

\d .chunk               / carve out a chunk of the tree

foo:{                   / define functions
…

Var:…                   / define variables
```
