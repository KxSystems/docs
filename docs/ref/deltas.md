# `deltas`


Syntax: `deltas y`, `deltas[y]`, `deltas[x;y]` 

Where 

-   `y` is a numeric or temporal vector
-   `x` is a numeric or temporal atom of the same type as `y`

returns differences between consecutive pairs of items of `y`.
Note `deltas` is ambivalent: can be applied as unary or binary.

Where applied as 

- a **binary** function, the result is
<pre><code>
(-[y 0;x];-[y 1;y 0];-[y 2;y 1];…;-[y n-1;y n-2])
</code></pre>
<pre><code class="language-q">
q)deltas[0N;1 4 9 16]
0N 3 5 7
</code></pre>

- a **unary** function, 0 replaces the `x` in the binary application. 
<pre><code class="language-q">
q)deltas 1 4 9 16
1 3 5 7
</code></pre>

In a query to get price movements:
```q
q)update diff:deltas price by sym from trade
```
With [`signum`](signum) to count the number of up/down/same ticks:
```q
q)select count i by signum deltas price from trade
price| x
-----| ----
-1   | 247
0    | 3
1    | 252
```

<i class="far fa-hand-point-right"></i> [_each-prior_](quote-colon/#each-prior), [`differ`](differ), [`ratios`](ratios)


