# `ratios`

Syntax: `ratios y`, `ratios[y]` (unary, uniform)  
Syntax: `x ratios y`, `ratios[x;y]` (binary uniform)

Where 

-   `x` is a numeric atom
-   `y` is a numeric list

returns the ratios of consecutive pairs of items of numeric list `y`.

Where applied as: 

- a binary function, the result is
<pre><code>
(%[y 0;x];%[y 1;y 0];%[y 2;y 1];…;%[y n-1;y n-2])
</code></pre>
<pre><code class="language-q">
q)ratios[5;1 2 4 6 7 10]
0.2 2 2 1.5 1.166667 1.428571
</code></pre>

- a unary function, 1 replaces the `x` in the binary application.
<pre><code class="language-q">
q)ratios 1 2 4 6 7 10
1 2 2 1.5 1.166667 1.428571
</code></pre>

!!! tip "Example"
    In a query to get returns on prices:
    <pre><code class="language-q">
    q)update ret:ratios price by sym from trade
    q)select log ratios price from trade
    </code></pre>

<i class="far fa-hand-point-right"></i> [Mathematics](/basics/math), [each-prior](adverbs/#each-prior), [`differ`](comparison/#differ), [`%` _divide_](divide)


