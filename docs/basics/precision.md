---
title: Precision
description: Precision of floats is a tricky issue since floats (doubles in other languages) are actually binary rational approximations to real numbers. 
keywords: comparison, float, precision, tolerance
---
# Precision




## Float precision

Precision of floats is a tricky issue since floats (_doubles_ in other languages) are actually binary rational approximations to real numbers. Whenever you are concerned with precision, set `\P 0` before doing anything else, so that you can see what’s really going on.

Due to the finite accuracy of the binary representation of floating-point numbers, the last decimal digit of a float is not reliable. This is not peculiar to kdb+.

```q
q)\P 0
q)1%3
0.33333333333333331
```

Efficient algorithms for complex calculations such as log and sine introduce imprecision. Moreover, even basic calculations raise issues of rounding. The IEEE floating-point spec addresses many such issues, but the topic is complex.

Q takes this into account in its implementation of the equality operator `=`, which should actually be read as “tolerantly equal.” Roughly speaking, this means that the difference is relatively small compared to some acceptable representation error. This makes the following hold:

```q
q)r7:1%7
q)sum 7#r7
0.99999999999999978
q)1.0=sum 7#r7
1b
```

Only zero is tolerantly equal to zero and you can test any two numbers for intolerant equality with `0=x-y`. Thus, we find:

```q
q)0=1.0-sum 7#r7
0b
```

The following example appears inconsistent with this:

```q
q)r3:1%3
q)1=r3+r3+r3
1b
q)0=1-r3+r3+r3
1b
```

It is not. The quantity `r3+r3+r3` is exactly 1.0. This is part of the IEEE spec, not q, and seems to be related to rounding conventions for binary floating point operations.

The `=` operator uses tolerant equality semantics. [Not all primitives do.](#use)

```q
q)96.100000000000009 = 96.099999999999994
1b
q)0=96.100000000000009-96.099999999999994
0b
q)deltas 96.100000000000009 96.099999999999994
96.100000000000009 -1.4210854715202004e-014
q)differ 96.100000000000009 96.099999999999994
10b
q)96.100000000000009 96.099999999999994 ? 96.099999999999994
1
q)group 96.100000000000009 96.099999999999994
96.100000000000009| 0
96.099999999999994| 1
```

!!! note "Not transitive"

    Tolerant equality does not obey transitivity:

    <pre><code class="language-q">
    q)a:96.099999999999994
    q)b:96.10000000001
    q)c:96.10000000002
    q)a
    96.099999999999994
    q)b
    96.100000000009999
    q)c
    96.100000000020003
    q)a=b
    1b
    q)b=c
    1b
    q)a=c
    0b
    </code></pre>

The moral of this story is that we should think of floats as being “fuzzy” real values and never use them as keys or where precise equality is required – e.g., in `group` or `?`.

For those interested in investigating these issues in depth, we recommend the excellent exposition by David Goldberg [“What Every Computer Scientist Should Know about Floating Point Arithmetic’](http://docs.sun.com/source/806-3568/ncg_goldberg.html).


### Q SIMD sum

The l64 builds of kdb+ now have a faster SIMD [`sum`](../ref/sum.md) implementation using SSE. With the above paragraph in mind, it is easy to see why the results of the older and newer implementation may not match.

Consider the task of calculating the sum of `1e-10*til 10000000`.

The SIMD code is equivalent to the following (`\P 0`):

```q
q){x+y}over{x+y}over 0N 8#1e-10*til 10000000
4999.9995000000017
```

While the older, “direct” code yields:

```q
q){x+y}over 1e-10*til 10000000
4999.9994999999635
```

The observed difference is due to the fact that the order of addition is different, and floating-point addition is not associative.

Worth noting is that the left-to-right order is not in some way “more correct” than others, seeing as even reversing the order of the elements yields different results:

```q
q){x+y}over reverse 1e-10*til 10000000
4999.9995000000026
```

If you need to sum numbers with most precision, you can look into implementing a suitable algorithm, like the ones discussed in [“Accurate floating point summation”](http://www.cs.berkeley.edu/~demmel/AccurateSummation.pdf) by Demmel et al.


## Comparison tolerance 

Comparison tolerance is the precision with which two numbers are determined to be equal. It applies only where one or the other is a finite floating-point number, i.e. types real, float, and datetime (see [Dates](#dates) below). It allows for the fact that such numbers may be approximations to the exact values. For any other numbers, comparisons are done exactly.

Formally, there is a _comparison tolerance_ `t` such that if `x` or `y` is a finite floating-point number, then `x=y` is 1 if the magnitude of `x-y` does not exceed `t` times the larger of the magnitudes of `x` and `y`. `t` is set to 2<sup>-43</sup>, and cannot be changed. In practice, the implementation is an efficient approximation to this test.

Note that a non-zero value cannot equal 0, since for any non-zero `x`, the magnitude of `x` is greater than `t` times the magnitude of `x`. Thus `0=a-b` tests for strict equality between `a` and `b`.

Comparison tolerance is not transitive, and can cause problems for _find_ and `distinct`. Thus, floats should not be used for database keys.

For example:

```q
q)t:2 xexp -43   / comparison tolerance

q)a:1e12
q)a=a-1          / a is not equal to a-1
0b
q)t*a            / 1 is greater than t*a
0.1136868

q)a:1e13
q)a=a-1          / a equals a-1
1b
q)t*a            / 1 is less than t*a
1.136868
q)0=a-(a-1)      / a is not strictly equal to a-1
0b
```

To see how this works, first set the print precision so that all digits of floating-point numbers are displayed.  

<i class="far fa-hand-point-right"></i> 
[`\P` Precision](syscmds.md#p-precision)

```q
\P 18
```

The result of the following computation is mathematically 1.0, but the computed value is different because the addend 0.001 cannot be represented exactly as a floating-point number.

```q
q)x: 0                  / initialize x to 0
q)do[1000;x+:.001]      / increment x one thousand times by 0.001
q)x                     / the resulting x is not quite 1.000
1.0000000000000007
q)x=1                   / does x equal 1?
1b
```

However, the expression `x = 1` has the value `1b`, and `x` is said to be tolerantly equal to 1:

```q
q)x=1                   / does x equal 1?
1b
```

Moreover, two distinct floating-point values `x` and `y` for which `x = y` is 1 are said to be _tolerantly equal_. No non-zero value is tolerantly equal to 0. Formally, there is a system constant $E$ called the _comparison tolerance_ such that two non-zero values $a$ and $b$ are tolerantly equal if:

$|a-b| ≤ E × max(|a|, |b|)$

but in practice the implementation is an efficient approximation to this test. Note that according to this inequality, no non-zero value is tolerantly equal to 0. That is, if `a=0` is 1 then `a` must be 0. To see this, substitute 0 for b in the above inequality and it becomes:

$| a | ≤ E ×| a |$ 

which, since $E$ is less than 1, can hold only if `a` is 0.


### Use

Besides Equal, comparison tolerance is used in the operators 

<!-- Following list from K2 Reference Manual
Find, Floor, `in`, More, Less, Match, and the iterators Converge, Do and While.
 -->  

`=` `<` `<=` `>=` `>` `~`

`differ` `within`

And prior to V3.0
  
`floor` `ceiling`

It is also used by the iterators [Converge, Do and While](../ref/accumulators.md#unary-values).

It is _not_ used by other keywords that have tests for equality:
  
`?`

`distinct` `except` `group` `in` `inter` `union` `xgroup`

Sort keywords: `asc` `desc` `iasc` `idesc` `rank` `xasc` `xdesc`


### Examples

```q
q)a:1f
q)b:a-10 xexp -13
```

In the following examples, `b` is treated equal to `a`, i.e. equal to `1`:

```q
q)a=b
1b
q)a~b
1b
q)a>b
0b
q)floor b /before V3.0, returned 1
0
```

In the following examples, `b` is treated not equal to `a`:

```q
q)(a,a)?b
2
q)(a,a) except b
1 1f
q)distinct a,b
1 0.99999999999989997
q)group a,b
1                  | 0
0.99999999999989997| 1
q)iasc a,b
1 0
```


### Dates

The datetime type is based on float, and hence uses comparison tolerance, for example:

```q
q)a:2000.01.02 + sum 1000#1%86400     / add 1000 seconds to a date
q)a
2000.01.02T00:16:40.000
q)b:2000.01.02T00:16:40.000           / enter same datetime
q)a=b                                 / values are tolerantly equal
1b
q)0=a-b                               / but not strictly equal
0b
```

Other temporal types, including the new timestamp and timespan types in V2.6, are based on int or long. 
These do not use comparison tolerance, and are therefore appropriate for database keys.

<i class="far fa-hand-point-right"></i> 
[Comparison](comparison.md), 
[Match](../ref/match.md), [`differ`](../ref/differ.md)