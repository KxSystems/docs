# `inv`



_Matrix inverse_

Syntax: `inv x`, `inv[x]`

Returns the inverse of non-singular float matrix `x`.

```q
q)a:3 3#2 4 8 3 5 6 0 7 1f
q)inv a
-0.4512195  0.6341463  -0.195122
-0.03658537 0.02439024 0.1463415
0.2560976   -0.1707317 -0.02439024
q)a mmu inv a
1             -2.664535e-15 5.828671e-16
-2.664535e-15 1             -1.19349e-15
3.885781e-16  -4.163336e-16 1
q)1=a mmu inv a
100b
010b
001b
```


<i class="far fa-hand-point-right"></i>
Basics: [Math](../basics/math.md)