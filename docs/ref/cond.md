# $ Cond




_Conditional evaluation_

Syntax: `$[x;y;z]`


Where `x` evaluates to zero, returns `z`, otherwise `y`.
```q
q)$[0b;`true;`false]
`false
q)$[1b;`true;`false]
`true
```
Only the first argument is certain to be evaluated.
```q
q)$[1b;`true;x:`false]
`true
q)x
'x
```
For brevity, nested triads can be flattened: `$[q;a;$[r;b;c]]` is equivalent to `$[q;a;r;b;c]`. An example of Cond in a _signum_-like function:
```q
q){$[x>0;1;x<0;-1;0]}'[0 3 -9]
0 1 -1
```
`$[q;$[r;a;b];c]` is not the same as `$[q;r;a;b;c]`.

Cond with many arguments can be translated to triads by repeatedly replacing the last three arguments with the triad: `$[q;a;r;b;s;c;d]` is `$[q;a;$[r;b;$[s;c;d]]]`. So Cond always has an odd number of arguments.

These two expressions are equivalent:
```q
q)$[0;a;r;b;c]
q)    $[r;b;c]
```

<i class="far fa-hand-point-right"></i> 
[`$`](ref/overloads/#dollar),
[Evaluation control](/basics/control)