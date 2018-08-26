# Adverbs


Adverbs are a special kind of native higher-order function, and the means by which iteration is most often specified in q expressions. 

In English, an adverb modifies a verb, e.g. to run _quickly_, to breathe _heavily_. Similarly in q, an adverb modifies a map. Formally, we can say an adverb takes a map as its argument/s and returns a related function, known as the _derived function_, or _derivative_. 
```q
q)totl:+/
q)totl[2 3 4]
9
```
In the example above, the adverb `/` (Over) takes the operator `+` as its argument. The derivative is assigned the name `totl`, and `totl` returns the sum of a numeric vector by consecutively applying `+` to its items. 

Over is applied postfix: it follows its argument. Only adverbs can be applied [postfix](functions/#postfix).  

!!! note "Genealogy"
    Q inherits the term _adverb_ from the [J language](jsoftware.com), where functions are _verbs_ and data _nouns_. 

    J inherited the adverb concept from [APL](https://en.wikipedia.org/wiki/APL_(programming_language) "Wikipedia"), where it is known as an _operator_, following Heaviside’s [operational calculus](https://en.wikipedia.org/wiki/Operational_calculus "Wikipedia"). 


## `/` and `\`

The glyphs `/` and `\` denote a number of adverbs. They all iterate the application of a map. 

In every case `/` and `\` perform exactly the same computation as each other. The derivatives of

-   `/` return the result of the **last** application
-   `\` return the results of **every** application

!!! tip "Debug `/` with `\`"
    If you want only the final result but don’t get what you expect, replace `/` with `\` to see the intermediate results. They are usually illuminating.

    Set `\P 0` to see the convergence of your original computation.


## Ambivalence

The derivatives of some adverbs are _ambivalent_: they can be applied as unary or binary functions.
```q
q)(+/)3 4 5   / applied unary, by juxtaposition
12
q)10+/3 4 5   / applied binary, by infix
22
```
Put another way, applying an ambivalent function to a single argument does not return a projection.
```q
q)double:2*              / projection
q)double 16 48
32 96
q)10+/3 4 5              / derivative applied binary by infix
22
q)+/[10;3 4 5]           / derivative applied binary by prefix
22
q)+/[3 4 5]              / applied unary by prefix - no projection
12
```
The derivative can be projected only by using a semicolon to make the projection explicit. 
```q
q)foo:+/[;3 4 5]         / projection of second argument
q)foo 10
22
```
Making a projection explicit in this way is a good practice for all projections, whether or not the function is ambivalent.

When an ambivalent derivative is applied as a unary, the domain of its single argument is often the same as the domain of its right argument.
```q
q)0+/3 4 5
12
q)(+/)3 4 5
12
```
So we can (loosely) speak of the _right argument_ of a derivative even when it is applied as a unary. 

**Watch out** When a derivative is applied as a unary, the first item of its argument has to be in the _left domain_ of the modified function. This becomes clear when the modified function has distinct left and right domains.

Here the left and right arguments of `.h.htc` are a symbol and a string. A lambda reverses the order of arguments, and Over applies the lambda to a succession of symbols. 
```q
q)"Hello world"{.h.htc[y;x]}/`p`body`html
"<html><body><p>Hello world</p></body></html>"
q)({.h.htc[y;x]}/)("Hello world";`p;`body;`html)
"<html><body><p>Hello world</p></body></html>"
```
Where a modified function, such as `.h.htc` has distinct left and right domains, and the derivative is applied as a unary, its argument must be a list of mixed type, and references to the derivative’s _right domain_ would be unhelpful.


## Exercises

==FIXME==