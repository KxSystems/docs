# `ceiling`


Syntax: `ceiling x`, `ceiling[x]` (atomic)

Returns the least integer greater than or equal to boolean or numeric `x`. 
```q
q)ceiling -2.1 0 2.1
-2 0 3
q)ceiling 01b
0 1i
```


## Domain and range
```
domain b g x h i j e f c s p m d z n u v t
range  i . i . i j j j i . . . . . . . . .
```
Range: `ij`

!!! note "Comparison tolerance; datetime"
    Prior to V3.0, `ceiling` used [comparison tolerance](/kb/precision/#comparison-tolerance).
    <pre><code class="language-q">
    q)ceiling 2 + 10 xexp -12 -13
    3 2
    </code></pre>
    Prior to V3.0, `ceiling` accepted datetime. Since V3.0, use `"d"$23:59:59.999+` instead.
    <pre><code class="language-q">
    q)ceiling 2010.05.13T12:30:59.999 /type error since V3.0
    2010.05.14
    q)"d"$23:59:59.999+ 2010.05.13T12:30:59.999
    2010.05.14
    </code></pre>

<i class="far fa-hand-point-right"></i> [Arithmetic](/basics/arithmetic), [`floor`](/ref/floor)


