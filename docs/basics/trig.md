`acos`
------

Syntax: `acos x` (unary, atomic)

Returns the [arccosine](https://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Basic_properties) of `x`; that is, the value whose cosine is `x`. The result is in radians and lies between 0 and &pi;. (The range is approximate due to rounding errors).

Null is returned if the argument is not between -1 and 1.
```q
q)acos -0.4
1.982313
```


`asin`
------

Syntax: `asin x` (unary, atomic)

Returns the [arcsine](https://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Basic_properties) of `x`; that is, the value whose sine is `x`. The result is in radians and lies between $-\frac{\pi}{2}$ and $\frac{\pi}{2}$. (The range is approximate due to rounding errors).

Null is returned if the argument is not between -1 and 1.
```q
q)asin 0.8
0.9272952
```


`atan`
------

Syntax: `atan x` (unary, atomic) 

Returns the [arctangent](https://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Basic_properties) of `x`; that is, the value whose tangent is `x`. The result is in radians and lies between $-{\pi}{2}$ and ${\pi}{2}$. The range is approximate due to rounding errors.
```q
q)atan 0.5
0.4636476
q)atan 42
1.546991
```


`cos`
-----

Syntax: `cos x` (unary, atomic) 

Returns the [cosine](https://en.wikipedia.org/wiki/Trigonometric_functions#cosine) of `x`, taken to be in radians. The result is between `-1` and `1`, or null if the argument is null or infinity.
```q
q)cos 0.2
0.9800666
q)min cos 10000?3.14159265
-1f
q)max cos 10000?3.14159265
1f
```


`sin`
-----

Syntax: `sin x`

Returns the [sine](https://en.wikipedia.org/wiki/Sine) of `x`, taken to be in radians. The result is between `-1` and `1`, or null if the argument is null or infinity.
```q
q)sin 0.5
0.4794255
q)sin 1%0
0n
```


`tan`
-----

Syntax: `tan x` (unary, atomic) 

Returns the [tangent](https://en.wikipedia.org/wiki/Tangent) of `x`, taken to be in radians. Integer arguments are promoted to floating point. Null is returned if the argument is null or infinity.
```q
q)tan 0 0.5 1 1.5707963 2 0w
0 0.5463025 1.557408 3.732054e+07 -2.18504 0n
```

