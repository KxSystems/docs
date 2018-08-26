Comparison tolerance is the precision with which two numbers are determined to be equal. It applies only where one or the other is a finite floating-point number, i.e. types real, float, and datetime (see [Dates](#Dates) below). It allows for the fact that such numbers may be approximations to the exact values, see [Float Precision and Equality](float-precision). For any other numbers, comparisons are done exactly.

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


## Use

Comparison tolerance is used by:
  
`=` `<` `>` `~`

`differ` `within`

And prior to V3.0
  
`floor` `ceiling`

It is _not_ used by other verbs that have tests for equality:
  
`?`

`distinct` `except` `group` `in` `inter` `union` `xgroup`

sort functions: `asc` `desc` `iasc` `idesc` `rank` `xasc` `xdesc`


## Examples
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
q)floor b
1
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


## Dates

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
Other temporal types, including the new timestamp and timespan types in V2.6, are based on int or long. These do not use comparison tolerance, and are therefore appropriate for database keys.

<i class="far fa-hand-point-right"></i> [Float Precision and Equality](float-precision)
