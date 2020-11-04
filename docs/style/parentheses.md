---
author: Stevan Apter
keywords: kdb+, q, style
---

# Parentheses


Avoid unnecessary parentheses. The grammar of q is simple and there is no precedence order for the primitives. For example, the expression to multiply `a` by the sum of `b` and `c`:

```q
a*b+c
```

should not be written

```q
a*(b+c)
```

**Redundant parentheses are visual red herrings.**

Although extra parentheses are useful as training wheels, most q programmers eventually internalize the preferred method of reading q, which is _left to right_. To encounter a parenthesized expression is to assume that the parentheses are necessary.