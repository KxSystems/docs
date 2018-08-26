# `xexp`

Syntax: `x xexp y`, `xexp[x;y]` (infix or prefix, binary, atomic)

_Raise to the power_: for numerics, returns x<sup>y</sup>.
```q
q)2 xexp 8
256f
q)9 xexp 0.5
3f
q)1.5 xexp -4.2 0 0.1 0n 0w
0.1821448 1 1.04138 0n 0w
```

!!! Note
    The calculation is performed as `exp y * log x`. Note that if `y` is integer, this is not identical to `prd y#x`.
    <pre><code class="language-q">
    q)\P 0
    q)prd 3#2
    8
    q)2 xexp 3
    7.9999999999999982
    q)exp 3 * log 2
    7.9999999999999982
    </code></pre>


## Domain and range
```
xexp| b g x h i j e f c s p m d z n u v t
----| -----------------------------------
b   | f . f f f f f f . . . . . . . . . .
g   | . . . . . . . . . . . . . . . . . .
x   | f . f f f f f f . . . . . . . . . .
h   | f . f f f f f f . . . . . . . . . .
i   | f . f f f f f f . . . . . . . . . .
j   | f . f f f f f f . . . . . . . . . .
e   | f . f f f f f f . . . . . . . . . .
f   | f . f f f f f f . . . . . . . . . .
c   | . . . . . . . . . . . . . . . . . .
s   | . . . . . . . . . . . . . . . . . .
p   | . . . . . . . . . . . . . . . . . .
m   | . . . . . . . . . . . . . . . . . .
d   | . . . . . . . . . . . . . . . . . .
z   | . . . . . . . . . . . . . . . . . .
n   | . . . . . . . . . . . . . . . . . .
u   | . . . . . . . . . . . . . . . . . .
v   | . . . . . . . . . . . . . . . . . .
t   | . . . . . . . . . . . . . . . . . .
```
Range: `f`


<i class="far fa-hand-point-right"></i> [Arithmetic](/basics/arithmetic), [`exp`](/ref/exp), [`log`](/ref/log), [`xlog`](/ref/xlog)