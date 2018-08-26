---
title: Iterating with operators
authors: 
    - Conor Slattery
    - Stephen Taylor
date: August 2018
keywords: converge, iteration, kdb+, loop, operators, q, repeat, while
---

# Iterating with operators



With unary functions, Scan and Over control iteration.
Evaluation is _successive_: the first evaluation is of the argument.
Subsequent evaluations are of the result of the previous evaluation.

There are three forms.

Scan    | Over    | form
--------|---------|-------
`(f\)x` | `(f/)x` | Converge
`n f\x` | `n f/x` | Repeat
`t f\x` | `t f/x` | While

```txt
Key:
f: unary function   n: non-negative integer   t: truth map
```

Converge

: Apply `f` until the result matches either the previous evaluation or `x`.

Repeat

: Apply `f` `n` times. If `n` is 0, return `x`.

While

: Apply `f` until truth map `t` applied to the result is 0. A truth map may be a function, list or dictionary.

```q
q) //Calculate a Fibonacci sequence using Over
q) fib: {x,sum -2#x}/
q) //Call the function with an integer as the first parameter
q) fib[10;1 1]
1 1 2 3 5 8 13 21 34 55 89 144
q) //Call the function with a function as the first parameter
q) fib[{last[x]<200};1 1]
1 1 2 3 5 8 13 21 34 55 89 144 233
```


## Infinite loops

Certain expressions result in infinite loops. 
Consider the function defined and illustrated below.

```q
q)30{3.2*x*(1-x)}\.4      / 30 iterations
0.4 0.768 0.5701632 0.7842468 0.541452 0.7945015 0.5224603 0.7983857 0.515091..
q)({3.2*x*(1-x)}\)0.4     / does not return!
```

![](img/image35.png)  
<small>_Infinite looping function example_</small>

From the chart it is evident this results in a loop with
period 2 (at least within floating-point tolerance). 
If no exit condition is supplied the function will not terminate.

!!! tip "Set a timeout"

    When using Converge, it may be a good idea to set the timeout in your session via the `\T` command. This will terminate evaluation after a set number of seconds; infinite loops will not lock your instance indefinitely.


## Recursion

The self function `.z.s` can be used in recursion, allowing
more flexibility than Over or Scan. 

```q
q)l:(`a`n;(1 2;"efd");3;("a";("fes";3.4)))
q){}0N!{$[0h=type x;.z.s'[x];10h=abs type x;upper x;x]}l
(`a`n;(1 2;"EFD");3;("A";("FES";3.4)))
```

The above function will operate on a list of any structure and data
types, changing strings and characters to upper case and leaving all
other elements unaltered. 
Note that when using `.z.s` the function will error out with a `'stack` error message after 2000 loops.
This can be seen in the example below:

```q
{.z.s[0N!x+1]}0
```

No such restriction exists when using Scan or Over.
Use `.z.s` only where it is not possible to use Scan or Over.


## Operators vs loops

Many native q operators are overloaded to work with atoms, lists, dictionaries or a combination of them.
For example, the Add operator `+` can take two atoms, an atom and a list or dictionary or two lists or dictionaries as arguments. 

For more control over execution, or to work with user-defined functions, either loops or unary operators can be used. 
In almost all cases, unary operators allow shorter code with lower latency, and avoid creating unnecessary global variables.

Often the implementation is relatively easy, using Each, Each Left and
Each Right to cycle through a list and amend items.
As an example, we can check if either of the integers 2 or 3
are present in a list, using a `while` loop:

```q
q) chk:{i:0;a:();while[i<count x;a,:enlist any 2 3 in x[i];i+:1];a}
q) chk (1 2 3;3 4 5;4 5 6)
110b
q)\t:100000 chk (1 2 3;3 4 5;4 5 6)
515
```

However, operators allow neater, more efficient code.

```q
q) any each 2 3 in/: (1 2 3;3 4 5;4 5 6)
110b
q)\t:10000 any each 2 3 in/: (1 2 3;3 4 5;4 5 6)
374
```

Similarly we can use Over to deal with tasks which would be handled by loops in C-like languages. 
Suppose you want to join a variable number of tables.

```q
//Create a list of tables, of random length
q)tl:{1!flip(`sym;`$"pr",x;`$"vol",x)!(`a`b`c;3?50.0;3?100)}each string til 2+rand 10

//Join the tables using a while loop
q) {a:([]sym:`a`b`c);i:0;while[i<count[x];0N!a:a lj x[i];i+:1];a}tl
sym pr0      vol0 pr1      vol1 pr2      vol2
---------------------------------------------
a   35.2666  53   38.08624 95   1.445859 57
b   19.28851 39   6.41355  50   12.97504 24
c   23.24556 84   13.62839 19   6.89369  46

q)\t:100 {a:([]sym:`a`b`c);i:0;while[i<count[x];0N!a:a lj x[i];i+:1];a}tl
101

//Join the tables using Over
q) 0!(lj/)tl
sym pr0      vol0 pr1      vol1 pr2      vol2
---------------------------------------------
a   35.2666  53   38.08624 95   1.445859 57
b   19.28851 39   6.41355  50   12.97504 24
c   23.24556 84   13.62839 19   6.89369  46
q)\t:100 0!(lj/)tl
82
```

