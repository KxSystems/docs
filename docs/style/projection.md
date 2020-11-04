---
author: Stevan Apter
keywords: kdb+, q, style
---

# Projection


Never elide semicolons in a projection.

If `f` is a rank-3 function, the seven possible projections should be written:

```q
f[;;]      / not f[]
f[;;c]
f[;b;]     / not f[;b]
f[;b;c]
f[a;;]     / not f[a]
f[a;;c]
f[a;b;]    / not f[a;b]
```


**Write projections in full.**

