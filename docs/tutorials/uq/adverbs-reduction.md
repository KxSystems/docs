# Reduce


With a **binary** or higher-rank map, `/` and `\` are the Reduce adverb in its two forms: Over and Scan. They use the map to reduce a list. (Compare _map-reduce_ in some other programming languages.)

As with [Iterate](iteration), the derivatives of

-   `/` return the result of the **last** application, i.e. are **aggregate** functions <pre><code class="language-q">
q)+/[2 3 4]
9
</code></pre>
-   `\` return the result of **every** application, i.e. are **uniform** functions<pre><code class="language-q">
q)+\\[2 3 4]
2 5 9
</code></pre>

The mnemonic-aid operators `over` and `scan` apply `/` and `\` (respectively) to binary maps.

syntax                                                  | name | semantics
--------------------------------------------------------|------|--------------
`(m/)y`, `m/[y]`, `m over y`<br>`x m/y`, `mm/[x;y;z;…]` | over | reduce list/s
`(m\)y`, `m\[y]`, `m scan y`<br>`x m\y`, `mm\[x;y;z;…]` | scan | scan list/s

Key
```
m: binary map         x: in the left domain of m and mm
mm: map of rank ≥2    y, z, …: lists in the right domain/s of m and mm
```

!!! note "Parentheses for maps that can be applied infix"
    In `(m) over y` and `(m) scan y` the parentheses are required when `m` can be applied infix.<pre><code class="language-q">
    q)(+)over 2 3 4   / + can be applied infix
    9
    q)foo:+
    q)foo over 2 3 4  / foo cannot
    9</code></pre>


The derivatives `m/` and `m\` are variadic. As 

-   **unary** functions, they are applied prefix, or parenthesized for juxtaposition 
-   **binary** functions, their left arguments are used as initial states for the reduction, i.e. the initial left argument of the map; and they are applied prefix or infix

application   | prefix         | juxtaposition/infix
--------------|----------------|---------------------
unary         | `+/[2 3 4]`    | `(+/)2 3 4`
binary        | `+/[10;2 3 4]` | `10+/2 3 4`


## Unary application

Syntax: `(m/)y`, `m/[y]`, `m over y`<br>
Syntax: `(m\)y`, `m\[y]`, `m scan y`

Where 

-   `m` is a binary map
-   `y` is a list: `y[0]` is in the left domain of `m` and the remaining items are in the right domain of `m`

the derivative `m/` returns (supposing `y` has four items)
```q
m[m[m[y 0;y 1];y 2];y 3]
```
while `m\` returns
```q
y 0
m[y 0;y 1]
m[m[y 0;y 1];y 2]
m[m[m[y 0;y 1];y 2];y 3]
```
In the most widely-known example, `m` is the operator `+`.
```q
q)+/[2 3 4]
9
q)(+) scan 2 3 4
2 5 9
q)({x," ",y}/)string `The`quick`brown`fox
"The quick brown fox"
```
A transition matrix is a binary map: another finite-state machine.
```q
q)m
0 2
1 1
0 1
q)(m\)1 0 1 1 0 1
1 1 1 1 1 1
q)(m\)0 1 0 0 1 0
0 2 0 0 2 0
```


## Binary application

Syntax: `x m/y`, `m/[x;y]`<br>
Syntax: `x m\y`, `m\[x;y]`

Where 

-   `m` is a binary map
-   `x` is in the left domain of `m`
-   `y` is a list of which the items are in the right domain of `m`

the derivative `m/` returns (supposing `y` has four items)
```q
m[m[m[m[x;y 0];y 1];y 2];y 3]
```
while `m\` returns
```q
m[x;y 0]
m[m[x;y 0];y 1]
m[m[m[x;y 0];y 1];y 2]
m[m[m[m[x;y 0];y 1];y 2];y 3]
```
One can consider `x` as an initial state.
```q
q)10 +\2 3 4
12 15 19
q)0 m\1 0 1 1 0 1   / finite-state machine
2 0 2 1 1 1
```
We can also use this form to apply a succession of arguments to an initial state.
```q
q)"Hello world"{.h.htc[y;x]}/`p`body`html
"<html><body><p>Hello world</p></body></html>"
```


## Exercises

==FIXME==


