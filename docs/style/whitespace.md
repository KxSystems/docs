---
author: Stevan Apter
keywords: kdb+, q, style, whitespace
---

# Spaced-out code


Q requires spaces in certain contexts and disallows them in others. The rules are simple and are spelled out in the Syntax article below. Otherwise you are free to deploy whitespace in the service of readability. 

:fontawesome-regular-hand-point-right: 
Basics: [Syntax](../basics/syntax.md)

Some programmers favor whitespace around all primitives and punctuation.

```q
quote1: { { x | -1 rotate x } @ { x <> y}\ "`" = x }
```

Some use whitespace only around primitives.

```q
quote2: {{x | -1 rotate x} @ {x <> y}\ "`" = x}
```

Others avoid cosmetic whitespace altogether.

```q
quote3:{{x|-1 rotate x}@{x<>y}\"`"=x}
```

A practice we countenance allocates whitespace grudgingly, using blanks to nudge the eye.

```q
quote4:{{x|-1 rotate x} @ {x<>y}\ "`"=x}
```

Advocates of the last approach argue that it is easier to see the structure of a complex expression when it is presented in dense form.

```q
f@g\z
```

The practice we recommend accepts a single blank only following the statement separator (semicolon).

```q
a:b+c; f:e+f
```

Otherwise, use no whitespace, or

**Only as much whitespace as makes syntactic structure salient.**