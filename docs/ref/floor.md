# `floor`


Syntax: `floor x`, `floor[x]` (atomic)

Returns the greatest integer ≤ to numeric `x`. 
```q
q)floor -2.1 0 2.1
-3 0 2
```

!!! note "Comparison tolerance; datetime"
    Prior to V3.0, `floor` used [comparison tolerance](/kb/precision/#comparison-tolerance).
    <pre><code class="language-q">
    q)floor 2 - 10 xexp -12 -13
    1 2
    </code></pre>
    Prior to V3.0, `floor` accepted datetime. Since V3.0, use `"d"$` instead.
    <pre><code class="language-q">
    q)floor 2009.10.03T13:08:00.222. /type error since V3.0
    2009.10.03
    q)"d"$2009.10.03T13:08:00.222
    2009.10.03
    </code></pre>


## Domain and range
```
domain b g x h i j e f c s p m d z n u v t
range  . . . . i j j j c s . . . . . . . .
```
Range: `ijcs`

<i class="fa fahand-o-right"></i> [Arithmetic](/basics/arithmetic), [`ceiling`](/ref/ceiling)