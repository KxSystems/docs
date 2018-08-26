# Applying functions


_Function_ is an inclusive term in q. It includes: 

-   _operators_, such as `+`, `-` and `*`
-   _native functions_, such as `like` and `til` 
-   _adverbs_, such as `/` and `\`
-   _lambdas_, such as `{(x*x)+(2*x*y)+y*y}`
-   _derivatives_ of adverbs, such as `+/`

Without application, a function evaluates as itself, a function atom.
```q
q)2                    / 2 is 2
2
q)+                    / + is +
+
q)like                 / like is like
like
q)til                  / til is defined in k
k){$[0>@x;!x;'`type]}
q)(+;like;/;{x+y})     / a list of functions
+
like
/
{x+y}
```
To apply a function is to evaluate it on an argument or arguments.
There are several ways to apply functions:

application   | examples        | note
--------------|-----------------|----------------------------------------------
prefix        | `xexp[2;3]`     | function juxtaposed to an _argument list_
infix         | `2+2`, `a or b` | operator interposed between its two arguments
postfix       | `+/`, `count'`  | adverb preceded by its argument
juxtaposition | `til 6`         | function followed by its single argument
`@`           | `til@6`         | unary function as left argument to operator `@`
`.`           | `xexp . 3 2`    | function as left argument to operator `.`


!!! warning "Ambivalence"
    The rank of native functions and lambdas is fixed – with some important exceptions. ==Enlarge==


## Prefix

_All_ functions can be applied prefix, by immediate juxtaposition to an argument list.
```q
q)+[2;2]
4
q)tot:(/[+])      / map-reduce by addition 
q)tot[1 2 3 4 5] 
15
```

!!! note "Even adverbs"
    Even adverbs can be applied prefix. (And the adverb [Compose](FIXME) must be.) But there is no advantage to prefix when postfix is possible. 

    Adverbs are applied postfix wherever possible. 


## Infix

Native binary functions may be applied infix, and usually are. These functions are known as _operators_.
```q
q)2+2
4
q)"quick" like "qui*"
1b
```


## Postfix

_Adverbs_ are native functions that can be applied either prefix or (more conveniently, for most of them) postfix. They return functions, known as _derived functions_ or _derivatives_.
```q
q)total:+/
q)total[1 2 3 4 5]
15
```
Here, the adverb Over `/` is applied to the operator Add `+`. The result (or _derivative_) is assigned the name `total`. The derivative can be applied directly: there is no need to assign a name to it.
```q
q)*/[1 2 3 4 5]
120
```
Iterations in q are mostly written with adverbs. Loops are rare. 

> — _I can write for-loops in my sleep!_  
> — We want you to wake up.


## Juxtaposition

A unary function can be applied simply by juxtaposing it with its argument.
```q
q)til[6]
0 1 2 3 4 5
q)til 6
0 1 2 3 4 5
```
It is always possible simply to omit the brackets enclosing the argument to a unary function. 


## `@` Apply At

The two arguments of this operator are a unary function and its argument. 

Its simplest use is therefore redundant: `f@x` is always equivalent to `f x`. 


## `.` Apply

The two arguments of this operator are a function and a list of its arguments. 
```q
q)ssr["The quick brown fox";"brown";"red"]
"The quick red fox"
q)ssr . ("The quick brown fox";"brown";"red")
"The quick red fox"
```
Handy when iterating higher-rank functions across tables.


## Exercises 

==FIXME==