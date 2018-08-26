# Iterate



> We shall not cease from exploration  
> And the end of all our exploring  
> Will be to arrive where we started  
> And know the place for the first time.  
> — _T.S. Eliot_, “Little Gidding”



With a **unary map**, `/` and `\` are the Iterate adverb in its three forms: Converge, Repeat, and While. Iterate repeatedly applies the map, first to an argument, then to the result of the application.

syntax                                    | semantics
------------------------------------------|----------
`(m/)y`, `m/[y]`<br>`(m\)y`, `m\[y]`      | Converge
`n m/y`, `m/y[n;y]`<br>`n m\y`, `m\[n;y]` | Repeat
`t m/y`, `m/[t;y]`<br>`t m\y`, `m\[t;y]`  | While

Key
```
m: unary map
n: integer ≥0
t: unary map with 0 in its range
y: object in the domain of m
```
The derivatives `m/` and `m\` are variadic. Applying them as

-   **unary** functions give Converge
-   **binary** functions give Repeat or While, according to the left argument


## Repeat 

Syntax: `n m/y`, `m/[n;y]`<br>
Syntax: `n m\y`, `m\[n;y]` 

Repeat applies `m/` and `m\` as **binaries**. It means _apply the map `n` times_.
```q
q)halve:%[;2]
q)halve[1024]
512f
q)halve/[3;1024 16]
128 2f
```
The derivative’s right argument is the initial state; its domain, that of `halve`. The left argument is the number of times `halve` is evaluated.
```q
q)halve halve halve 1024 16
128 2f
```
Replace `/` with `\` and the derivative returns not just the last, but the initial state and the results of _all_ the applications. 
```q
q)halve\[3;1024 16]
1024 16
512  8
256  4
128  2
```
The binary derivative is often applied infix.
```q
q)3 halve\1024 16
1024 16
512  8
256  4
128  2
q)10{x,sum -2#x}/0 1           / first 10+2 numbers of Fibonacci sequence
0 1 1 2 3 5 8 13 21 34 55 89
```
Lists and dictionaries are also unary maps.
```q
q)show double:2*til 10
0 2 4 6 8 10 12 14 16 18
q)double double double 2 1
16 8
q)3 double/2 1
16 8
q)route                        / European tour route
Berlin  | London
Florence| Milan
London  | Paris
Paris   | Florence
Milan   | Vienna
Vienna  | Berlin
q)3 route\`London              / fly three stages, start London
`London`Paris`Florence`Milan
q)3 route\`London`Vienna       / start London - or Vienna
London   Vienna
Paris    Berlin
Florence London
Milan    Paris
```
The dictionary `route` here represents a simple finite-state machine.


## While

Syntax: `t m/y`, `m/[t;y]`<br>
Syntax: `t m\y`, `m\[t;y]` 

While is the other **binary** application of `m/` and `m\`. Here `t` is a ‘test’ – a unary map that 

-   has 0 in its range
-   has the range of `m` in its domain

The map `t` is applied to each successive application of `m`, to see _Are we there yet?_. When `t` returns 0, iteration ends. 
```q
q)mod[;5] +[3;]\1                           / add 3 until a multiple of 5
1 4 7 10
q)<>[;`London] route\`Paris                 / start in Paris, stop in London
`Paris`Florence`Milan`Vienna`Berlin`London
q)<>[;`London] route\`Vienna                / start in Vienna, stop in London
`Vienna`Berlin`London
```
In the above, the test map `t` is a unary function. It can also be a list or a dictionary.
```q
q)show t:mod[til 20;5]
0 1 2 3 4 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4
q)t (3+)\1
1 4 7 10
q)waypoints
Berlin  | 1
Florence| 1
Milan   | 1
Paris   | 1
Vienna  | 1
q)waypoints route\`Paris              / start Paris, continue through waypoints
`Paris`Florence`Milan`Vienna`Berlin`London
```
The tour ends in the first city that is not a waypoint.


## Converge

Syntax: `m/y`, `m/[y]`<br>
Syntax: `m\y`, `m\[y]` 

Converge is the **unary** application of `m/` and `m\`. Without a left argument to specify an endpoint, `m` is applied until the result matches either

-   the initial value `y`
-   the result of the previous application

```q
q)(neg\)1
1 -1
q)(rotate[1]\)"abcd"
"abcd"
"bcda"
"cdab"
"dabc"
q){x*x}\[0.1]
0.1 0.01 0.0001 1e-08 1e-16 1e-32 1e-64 1e-128 1e-256 0
```
The first two examples above terminated when they encountered the original value of `y`; the last when the result was indistinguishable from 0. 

As always, lists and dictionaries are also maps.
```q
q)a
1 8 5 6 0 3 6 4 2 9
q)10 a\1                / repeat
1 8 2 5 3 6 6 6 6 6 6
q)a\[1]                 / converge
1 8 2 5 3 6
q)route\[`London]       / stop when back in London
`London`Paris`Florence`Milan`Vienna`Berlin
```


## Exercises

==FIXME==