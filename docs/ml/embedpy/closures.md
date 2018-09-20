---
hero: <i class="fa fa-share-alt"></i> Machine learning / embedPy
keywords: closure, factorial, fibonacci, generator, kdb+, learning, machine, python, q
---

# Closures and generators


## Closures

Closures allow us to define functions that retain state between successive calls, avoiding the need for global variables.  

To create a closure in embedPy, we must:

1.  Define a function in q with
    -   2+ arguments: the current state and at least one other (possibly dummy) argument
    -   2 return values: the new state and the return value  
1.  Wrap the function using `.p.closure`, which takes 2 arguments:
    -   the q function
    -   the initial state

**Functions without arguments** The dummy argument is needed if we want the resulting function to take no arguments.


### Example 1: `til`

We can define a closure to return incrementing natural numbers, similar to the q `til` function.  

The state `x` is the last value returned.

```q
q)xtil:{[x;dummy]x,x+:1}
```

Create the closure with initial state -1, so the first value returned will be.

```q
q)ftil:.p.closure[xtil;-1][<]
q)ftil[]
0
q)ftil[]
1
q)ftil[]
2
q)ftil[]
3
```


### Example 2: Fibonacci

The Fibonacci sequence is a sequence in which each number is the sum of the two numbers preceding it.  
Starting with 0 and 1, the sequence goes `x(n) = x(n-1) + x(n-2)`

i.e. 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, …

The state `x` will be the last two values produced.

```q
q)xfib:{[x;dummy](x[1],r;r:sum x)}
```

Create the closure with initial state `0 1`, so the first value produced will be 1.

```q
q)fib:.p.closure[xfib;0 1][<]
q)fib[]
1
q)fib[]
2
q)fib[]
3
q)fib[]
5
q)fib[]
8
q)fib[]
13
```


### Example 3: Running sum

In this example, we will allow a numeric argument to be passed to the closure, removing the need for a dummy argument. The closure will keep track of all arguments passed so far, and return a running sum.

The state `x` will be the total so far.

```q
q)xrunsum:{x,x+:y}
```

Create the closure with initial state 0, so the first value produced will be the first argument passed.

```q
q)runsum:.p.closure[xrunsum;0][<]
q)runsum 2
2
q)runsum 3
5
q)runsum -2.5
2.5
q)runsum 0
2.5
q)runsum 10
12.5
```


## Generators

Generators are objects that we can iterate over (e.g. in a for-loop) to produce sequences of values.  
EmbedPy allows us to produce generators for use in Python functions and statements where they are required.

To create a generator in embedPy, we must

1.  Define a function in q (as per closures) with:
    -   2 arguments - the current state and a dummy argument
    -   2 return values - the new state and the return value  
1.  Wrap the function using `.p.generator`, which takes 3 arguments:
    -   the q function
    -   the initial state
    -   the max number of iterations, or `::` to run indefinitely


### Example 1: Factorials

The _factorial_ ($n!$) of a non-negative integer n, is the product of all positive integers less than or equal to n.  

We can create a sequence of factorials (starting with 1), with the sequence  `x(n) = x(n-1)*n`

The state `x` will be a 2-item list comprising

-   the last value used in the product
-   the last value returned

```q
q)xfact:{[x;dummy](x;last x:prds x+1 0)}
```

Create two generators, each with initial state `0 1`.

```q
q)fact4:.p.generator[xfact;0 1;4]     / generates first 4 factorial values
q)factinf:.p.generator[xfact;0 1;::]  / generates factorial values indefinitely
```

The resulting generators can be used as iterators in Python.

```q
q).p.set[`fact4]fact4
q)p)for x in fact4:print(x)
1
2
6
24
q).p.set[`factinf]factinf
q).p.e"for x in factinf:\n print(x)\n if x>1000:break"  / force break to stop iteration
1
2
6
24
120
720
5040
```


### Example 2: Look-and-say

The look-and-say sequence is the sequence of integers beginning as follows:
1, 11, 21, 1211, 111221, 312211, 13112221, 1113213211

-   `1` is read off as “one 1” or 11.
-   `11` is read off as “two 1s” or 21.
-   `21` is read off as “one 2, then one 1” or 1211.
-   `1211` is read off as “one 1, one 2, then two 1s” or 111221

The state `x` will be the last value produced.

```q
q)xlook:{[x;dummy]r,r:"J"$raze string[count each s],'first each s:(where differ s)_s:string x}
```

Create a generator (to run for 7 iterations) with initial state 1, so the first value produced will be 11.

```q
q)look:.p.generator[xlook;1;7]
```

This can be used as an iterator in Python.

```q
q).p.set[`look]look
q)p)for x in look:print(x)
11
21
1211
111221
312211
13112221
1113213211
```


### Example 3: Successive sublists

We can define a closure to extract successive sublists, of a given size, from a larger list.  

The state `x` will be a 3-item list comprising

-   the list
-   the start index
-   the sublist size

```q
q)xsub:{[x;d](@[x;1;+;x 2];sublist[x 1 2]x 0)}
```

To create a generator (to run for 6 iterations), extracting sublists of size 6 from `.Q.A` (list of 26 alphabetical chars)

```q
q)sub:.p.generator[xsub;(.Q.A;0;6);6]
```

This can be used as an iterator in Python.

```q
q).p.set[`sub]sub
q)p)for x in sub:print(x)
ABCDEF
GHIJKL
MNOPQR
STUVWX
YZ

q)
```


