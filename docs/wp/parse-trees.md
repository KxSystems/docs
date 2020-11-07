---
title: Parse trees and functional forms | White Paper | kdb+ and q documentation
description: How to understand parse trees and use functional forms in q queries; how to convert qSQL expressions to functional form.
author: [Peter Storeng, Stephen Taylor]
keywords: functional, kdb+, parse, parse tree, q, qSQL, query, SQL
---
White paper
{: #wp-brand}

# Parse trees and functional forms

by [Peter Storeng &amp; Stephen Taylor](#authors)
{: .wp-author}



The importance of understanding and using the functional form of qSQL statements in kdb+ cannot be overstated. The functional form has many advantages over the qSQL approach, including the ability to select columns and build Where clauses dynamically. It is important for any q programmer to understand the functional form fully and how to convert to it from qSQL.

Applying `parse` to a qSQL statement written as a string will return the internal representation of the functional form. With some manipulation this can then be used to piece together the functional form in q. This generally becomes more difficult as the query becomes more complex and requires a deep understanding of what kdb+ is doing when it parses qSQL form.

The main goal of this paper is to show in detail how this conversion works, so that it is understood how to build the functional form of qSQL statements correctly. In order to do this, we will need to look at how q and k commands relate to each other, as the parse function often returns the cryptic k code for functions. An understanding of what parse trees are, and how to use them, is also vital in the building of functional queries.

Finally, this paper will look at creating a function which will automate the process of converting qSQL statements into functional form. This is to be used as a helpful development tool when facing the task of writing a tricky functional statement.

All tests were run using kdb+ version 3.2 (2015.01.14).


## k4, q and `q.k`

Kdb+ is a database management system which ships with the general-purpose and database language q. Q is an embedded domain-specific language implemented in the k programming language, sometimes known as k4. The q interpreter can switch between q and k modes and evaluate expressions written in k as well as q.

The k language is for Kx implementors. 
It is not documented or supported for use outside Kx. 
All the same functionality is available in the much more readable q language. However in certain cases, such as debugging, a basic understanding of some k syntax can be useful.

The `q.k` file is part of the standard installation of q and loads into each q session on startup. It defines many of the q keywords in terms of k. To see how a q keyword is defined in terms of k we could check the `q.k` file or simply enter it into the q prompt:

```q
q)key
!:
```

A few q keywords are defined natively from C and do not have a k representation:

```q
q)like
like
```


## The `parse` keyword

`parse` is a useful tool for seeing how a statement in q is evaluated. Pass the `parse` keyword a q statement as a string and it will return the parse tree of that expression.


### Parse trees

A parse tree is a q construct which represents an expression but which is not immediately evaluated. It takes the form of a list where the first item is a function and the remaining items are the arguments. Any of the items of the list can be parse trees themselves.

Note that in a parse tree a variable is represented by a symbol containing its name. Thus to distinguish a symbol or a list of symbols from a variable it is necessary to enlist that expression. When we apply the `parse` function to create a parse tree, explicit definitions in `.q` are shown in their full k form. In particular, an enlisted element is represented by a preceding comma.

```q
q)parse"5 6 7 8 + 1 2 3 4"                               
+                          //the function/operator 
5 6 7 8                    //first argument 
1 2 3 4                    //second argument 
```
```q
q)parse"2+4*7"                 
+                          //the function/operator
2                          //first argument
(*;4;7)                    //second argument, itself a parse tree
```
```q
q)v:`e`f
q)`a`b`c,`d,v
`a`b`c`d`e`f
q)parse"`a`b`c,`d,v"
,                          // join operator
,`a`b`c                    //actual symbols/lists of symbols are enlisted 
(,;,`d;`v)                 //v a variable represented as a symbol
```

We can also manually construct a parse tree:

```q
q)show pTree:parse "(aggr;data) fby grp"
k){@[(#y)#x[0]0#x 1;g;:;x[0]'x[1]g:.=y]} //fby in k form 
(enlist;`aggr;`data)
`grp

q)pTree~(fby;(enlist;`aggr;`data);`grp)  //manually constructed 
1b                                       //parse tree
```

As asserted previously every statement in q parses into the form:

```txt
(function; arg 1; …; arg n)
```

where every item could itself be a parse tree. In this way we see that every action in q is essentially a function evaluation.


### `eval` and `value`

`eval` can be thought of as the dual to `parse`. The following holds for all valid q statements put into a string. (Recall that `value` executes the command inside a string.)

```q
//a tautology (for all valid q expressions str)
q)value[str]~eval parse str
1b            
q)value["2+4*7"]~eval parse"2+4*7" //simple example 
1b
```

When passed a list, `value` applies the first item (which contains a function) to the rest of the list (the arguments).

```q
q)function[arg 1;..;arg n] ~ value(function;arg 1;..;arg n) 
1b
```

When `eval` and `value` operate on a parse tree with no nested parse trees they return the same result. However it is not true that `eval` and `value` are equivalent in general. `eval` operates on parse trees, evaluating any nested parse trees, whereas `value` operates on the literals.

```q
q)value(+;7;3)                  //parse tree, with no nested trees
10
q)eval(+;7;3)
10
q)eval(+;7;(+;2;1))             //parse tree with nested trees
10
q)value(+;7;(+;2;1))
'type
```
```q
q)value(,;`a;`b)
`a`b
q)eval(,;`a;`b)          //no variable b defined
'b
q)eval(,;enlist `a;enlist `b)
`a`b
```


### Variadic operators

Many operators and some keywords in k and q are [variadic](../basics/glossary.md#variadic): they are overloaded so that the behavior of the operator changes depending on the number and type of arguments. In q (not k) the unary form of operators such as (`+`, `$`, `.`, `&` etc.) is disabled: keywords are provided instead.

For example, in k the unary form of the `$` operator equates to the `string`
keyword in q.

```q
q)k)$42
"42"
q)$42                  //$ unary form disabled in q
'$
q)string 42
"42"
```

!!! info "A parenthesized variadic function applied prefix is parsed as its unary form."

```q
q)($)42
"42"
```

A familiar example of a variadic function is the Add Over function `+/` derived by applying the Over iterator to the Add operator. 

```q
q)+/[1000;2 3 4]    // +/ applied binary
1009
q)+/[2 3 4]         // +/ applied unary 
9
q)(+/)2 3 4         // +/ applied unary 
9
```

In k, the unary form of an operator can also be specified explicitly by suffixing it with a colon. 

```q
q)k)$:42
"42"
```

`+:` is a unary operator; the unary form of `+`. We can see this in the parse tree:

```q
q)parse"6(+)4"
6
(+:;4)
```

The items of a `parse` result use k syntax. Since (most of) the q keywords are defined in the `.q` namespace, we can use dictionary reverse lookup to find the meaning.

```q
q).q?(+:)
`flip
```

So we can see that in k, the unary form of `+` corresponds to `flip` in q.

```q
q)d:`c1`c2`c3!(1 2;3 4;5 6)
q)d
c1| 1 2
c2| 3 4
c3| 5 6
q)k)+d 
c1 c2 c3 
-------- 
1  3  5
2  4  6
q)k)+:d 
c1 c2 c3 
-------- 
1  3  5 
2  4  6
```

!!! warning "Exposed infrastructure"

    The unary forms of operators are [exposed infrastructure]().
    Their use in q expressions is **strongly discouraged**.
    Use the corresponding q keywords instead. 

    For example, write `flip d` rather than `(+:)d`. 

    The unary forms are reviewed here to enable an understanding of parse trees, in which k syntax is visible. 

<!-- 
The monadic functionality of a special character operator can be used
in q only if it is wrapped in parentheses:

```q
q)+d
'+

q)flip d 
c1 c2 c3 
-------- 
1  3  5 
2  4  6 

q)(+)d
c1 c2 c3 
-------- 
1  3  5 
2  4  6 
```
 -->

When using reverse lookup on the `.q` context we are slightly hampered by the fact that it is not an injective mapping. The Find `?` operator returns only the first q keyword matching the k expression. In some cases there is more than one. Instead use the following function:

```q
q)qfind:{key[.q]where x~/:string value .q}

q)qfind"k){x*y div x:$[16h=abs[@x];\"j\"$x;x]}" 
,`xbar
q)qfind"~:"
`not`hdel
```

We see `not` and `hdel` are equivalent. Writing the following could be confusing:

```q
q)hdel 01001b
10110b
```

So q provides two different names for clarity.


### Iterators as higher-order functions

An iterator applies to a value (function, list, or dictionary) to produce a  related function. This is again easy to see by inspecting the parse tree:

```q
q)+/[1 2 3 4]
10
q)parse "+/[1 2 3 4]"
(/;+)
1 2 3 4
```

The first item of the parse tree is `(/;+)`, which is itself a parse
tree. We know the first item of a parse tree is to be applied to the
remaining items. Here `/` (the Over iterator) is applied to `+` to
produce a new function which sums the items of a list.

:fontawesome-regular-hand-point-right:
White paper: [Iterators](iterators/index.md)


## Functional queries

Alongside each qSQL query we also have the equivalent functional
forms. These are especially useful for programmatically-generated
queries, such as when column names are dynamically queried.

```q
?[t;c;b;a] // select and exec
![t;c;b;a] // update and delete
```

Here 

-   `t` is a table
-   `c` is a list of constraints in the portable parse tree format
-   `b` is a dictionary of group-bys
-   `a` is a dictionary of aggregates

:fontawesome-regular-hand-point-right:
_Q for Mortals_: [§9.12 Functional forms of queries](/q4m3/9_Queries_q-sql/#912-functional-forms)

The q interpreter parses the syntactic forms of `select`, `exec`, `update`
and `delete` into their equivalent functional forms. Therefore there is
no performance difference between a qSQL query and a functional
one.


### Issues converting to functional form

To convert a `select` query to a functional form one may attempt to
apply the `parse` function to the query string:

```q
q)parse "select sym,price,size from trade where price>50" 
?
`trade
,,(>;`price;50)
0b
`sym`price`size!`sym`price`size
```

As we know, `parse` produces a parse tree and since some of the elements may themselves be parse trees we can’t immediately take the output of parse and plug it into the form `?[t;c;b;a]`. After a little playing around with the result of `parse` you might eventually figure out that the correct functional form is as follows.

```q
q)funcQry:?[`trade;enlist(>;`price;50);0b;`sym`price`size! `sym`price`size]

q)strQry:select sym,price,size from trade where price>50 q)
q)funcQry~strQry
1b
```

This, however, becomes more difficult as the query statements become more complex:

```q
q)parse "select count i from trade where 140>(count;i) fby sym" 
?
`trade
,,(>;140;(k){@[(#y)#x[0]0#x 
1;g;:;x[0]'x[1]g:.=y]};(enlist;#:;`i);`sym))
0b
(,`x)!,(#:;`i)
```

In this case, it is not obvious what the functional form of the above query should be, even after applying `parse`.

There are three issues with this parse-and-“by eye” method to convert to the equivalent functional form. We will cover these in the next three subsections.


### Parse trees and eval

The first issue with passing a `select` query to `parse` is that each returned item is in unevaluated form. As [discussed above](#eval-and-value), simply applying `value` to a parse tree does not work. However, if we evaluate each one of the arguments fully, then there would be no nested parse trees. We could then apply `value` to the result:

```q
q)eval each parse "select count i from trade where 140>(count;i) fby sym"
?
+`sym`time`price`size!(`VOD`IBM`BP`VOD`IBM`IBM`HSBC`VOD`MS.. 
,(>;140;(k){@[(#y)#x[0]0#x 
1;g;:;x[0]'x[1]g:.=y]};(enlist;#:;`i);`sym))
0b
(,`x)!,(#:;`i)
```

The equivalence below holds for a general qSQL query provided as a string:

```q
q)value[str]~value eval each parse str
1b
```

In particular:

```q
q)str:"select count i from trade where 140>(count;i) fby sym" 

q)value[str]~value eval each parse str
1b
```

In fact, since within the functional form we can refer to the table by name we can make this even clearer. Also, the first item in the result of `parse` applied to a `select` query will always be `?` (or `!` for a `delete`or `update` query) which cannot be evaluated any further. So we don’t need to apply `eval` to it.

```q
q)pTree:parse str:"select count i from trade where 140>(count;i) fby sym"
q)@[pTree;2 3 4;eval]
?
`trade
,(>;140;(k){@[(#y)#x[0]0#x 
1;g;:;x[0]'x[1]g:.=y]};(enlist;#:;`i);`sym)) 
0b
(,`x)!,(#:;`i)
q)value[str] ~ value @[pTree;2 3 4;eval]
1b
```


### Variable representation in parse trees

Recall that in a parse tree a variable is represented by a symbol containing its name. So to represent a symbol or a list of symbols, you must use `enlist` on that expression. In k, `enlist` is the unary form of the comma operator in k:

```q
q)parse"3#`a`b`c`d`e`f"
#
3
,`a`b`c`d`e`f
q)(#;3;enlist `a`b`c`d`e`f)~parse"3#`a`b`c`d`e`f" 
1b
```

This causes a difficulty. As [discussed above](#variadic-operators), q has no unary syntax for operators.

Which means the following isn’t a valid q expression and so returns an error.

```q
q)(#;3;,`a`b`c`d`e`f)
',
```

In the parse tree we receive we need to somehow distinguish between k’s unary `,` (which we want to replace with `enlist`) and the binary Join operator, which we want to leave as it is.


### Explicit definitions in `.q` are shown in full

The `fby` in the `select` query above is represented by its full k
definition.

```q
q)parse "fby"
k){@[(#y)#x[0]0#x 1;g;:;x[0]'x[1]g:.=y]}
```

While using the k form isn’t generally a problem from a functionality perspective, it does however make the resulting functional statement difficult to read.


## The solution

We will write a function to automate the process of converting a `select` query into its equivalent functional form.

This function, `buildQuery`, will return the functional form as a string.

```q
q)buildQuery "select count i from trade where 140>(count;i) fby sym" 
"?[trade;enlist(>;140;(fby;(enlist;count;`i);`sym));0b;
  (enlist`x)! enlist (count;`i)]"
```

When executed it will always return the same result as the `select` query from which it is derived:

```q
q)str:"select count i from trade where 140>(count;i) fby sym" 
q)value[str]~value buildQuery str
1b
```

And since the same logic applies to `exec`, `update` and `delete` it will be able to convert to their corresponding functional forms also.

To write this function we will solve the three issues outlined above:

1.  parse-tree items may be parse trees
2.  parse trees use k’s unary syntax for operators
3.  q keywords from `.q.` are replaced by their k definitions

The first issue, where some items returned by `parse` may themselves be parse trees is easily resolved by applying `eval` to the individual items.

The second issue is with k’s unary syntax for `,`. We want to replace it with the q keyword `enlist`. To do this we define a function that traverses the parse tree and detects if any element is an enlisted list of symbols or an enlisted single symbol. If it finds one we replace it with a string representation of `enlist` instead of `,`.

```q
ereptest:{ //returns a boolean
  (1=count x) and ((0=type x) and 11=type first x) or 11=type x}
ereplace:{"enlist",.Q.s1 first x}
funcEn:{$[ereptest x;ereplace x;0=type x;.z.s each x;x]}
```

Before we replace the item we first need to check it has the
correct form. We need to test if it is one of:

-   An enlisted list of syms. It will have type `0h`, count 1 and the type of its first item will be `11h` if and only if it is an enlisted list of syms.
-   An enlisted single sym. It will have type `11h` and count 1 if and only if it is an enlisted single symbol.

The `ereptest` function above performs this check, with `ereplace` performing the replacement.

!!! tip "Console size"

    `.Q.s1` is dependent on the size of the console so make it larger if necessary.

Since we are going to be checking a parse tree which may contain parse trees nested to arbitrary depth, we need a way to check all the elements down to the base level.

We observe that a parse tree is a general list, and therefore of type `0h`. This knowledge combined with the use of `.z.s` allows us to scan a parse tree recursively. The logic goes: if what you have passed into `funcEn` is a parse tree then reapply the function to each element.

To illustrate we examine the following `select` query.

```q
q)show pTree:parse "select from trade where sym like \"F*\",not sym=`FD"
?
`trade
,((like;`sym;"F*");(~:;(=;`sym;,`FD))) 0b
()

q)x:eval pTree 2         //apply eval to Where clause
```

Consider the Where clause in isolation.

```q
q)x //a 2-list of Where clauses 
(like;`sym;"F*")
(~:;(=;`sym;,`FD))

q)funcEn x
(like;`sym;"F*")
(~:;(=;`sym;"enlist`FD"))
```

Similarly we create a function which will replace k functions with
their q equivalents in string form, thus addressing the third issue above. 

```q
q)kreplace:{[x] $[`=qval:.q?x;x;string qval]}
q)funcK:{$[0=t:type x;.z.s each x;t<100h;x;kreplace x]}
```

Running these functions against our Where clause, we see the k
representations being converted to q.

```q
q)x
(like;`sym;"F*")
(~:;(=;`sym;,`FD))

q)funcK x //replaces ~: with “not”
(like;`sym;"F*")
("not";(=;`sym;,`FD))
```

Next, we make a slight change to `kreplace` and `ereplace` and combine them.

```q
kreplace:{[x] $[`=qval:.q?x;x;"~~",string[qval],"~~"]}
ereplace:{"~~enlist",(.Q.s1 first x),"~~"}
q)funcEn funcK x
(like;`sym;"F*") ("~~not~~";(=;`sym;"~~enlist`FD~~"))
```

The double tilde here is going to act as a tag to allow us to differentiate from actual string elements in the parse tree. This allows us to drop the embedded quotation marks at a later stage inside the `buildQuery` function:

```q
q)ssr/[;("\"~~";"~~\"");("";"")] .Q.s1 funcEn funcK x 
"((like;`sym;\"F*\");(not;(=;`sym;enlist`FD)))"
```

thus giving us the correct format for the Where clause in a functional select. By applying the same logic to the rest of the parse tree we can write the `buildQuery` function.

```q
q)buildQuery "select from trade where sym like \"F*\",not sym=`FD" 
"?[trade;((like;`sym;\"F*\");(not;(=;`sym;enlist`FD)));0b;()]"
```

One thing to take note of is that since we use reverse lookup on the `.q` namespace and only want one result we occasionally get the wrong keyword back.

```q
q)buildQuery "update tstamp:ltime tstamp from z" 
"![z;();0b;(enlist`tstamp)!enlist (reciprocal;`tstamp)]" 

q).q`ltime
%:
q).q`reciprocal
%:
```

These instances are rare and a developer should be able to spot when they occur. Of course, the functional form will still work as expected but could confuse readers of the code.


### Fifth and sixth arguments

Functional select also has ranks 5 and 6; i.e. fifth and sixth arguments.

:fontawesome-regular-hand-point-right:
_Q for Mortals_: [§9.12.1 Functional queries](/q4m3/9_Queries_q-sql/#9121-functional-select)

We also cover these with the `buildQuery` function.

```q
q)buildQuery "select[10 20] from trade" 
"?[trade;();0b;();10 20]" 
q)//5th parameter included
```

The 6th argument is a column and a direction to order the results by. Use `<` for ascending and `>` for descending.

```q
q)parse"select[10;<price] from trade"
?
`trade
()
0b
()
10
,(<:;`price)

q).q?(<:;>:)
`hopen`hclose

q)qfind each ("<:";">:")   //qfind defined above
hopen
hclose
```

We see that the k function for the 6th argument of the functional form is `<:` (ascending) or `>:` (descending). At first glance this appears to be `hopen` or `hclose`. In fact in earlier versions of q, `iasc` and `hopen` were equivalent (as were `idesc` and `hclose`). The definitions of `iasc` and `idesc` were later altered to signal a rank error if not applied to a list.

```q
q)iasc
k){$[0h>@x;'`rank;<x]}

q)idesc
k){$[0h>@x;'`rank;>x]}

q)iasc 7
'rank
```

Since the columns of a table are lists, it is irrelevant whether the functional form uses the old or new version of `iasc` or `idesc`.

The `buildQuery` function handles the 6th argument as a special case so will produce `iasc` or `idesc` as appropriate.

```q
q)buildQuery "select[10 20;>price] from trade" 
"?[trade;();0b;();10 20;(idesc;`price)]"
```

The full `buildQuery` function code is provided in the Appendix.


## Conclusion

This paper has investigated how statements in q are evaluated by the parser. To do this we examined the relationship between q and k, and explained why parse trees generated by the parse function contain k code. We have then used this understanding to explain how qSQL statements can be converted into their equivalent and more powerful functional form.

To further help those learning how to construct functional statements, and also as a useful development tool, we have written a function which will correctly convert a qSQL query into the q functional form. This would be useful for checking that a functional statement is formed correctly or to help with a particularly tricky query.

All tests were run using kdb+ version 3.2 (2015.01.14).

:fontawesome-solid-print:
[An earlier version of this paper](/download/wp/parse_trees_and_functional_forms.pdf)
by Peter Storeng


## Authors

**Peter Storeng** is a kdb+ developer who has worked as a consultant for some of the world’s largest financial institutions. He is currently based in London where he divides his time between maintaining a firm-wide risk system and implementing algorithmic trading strategies for a tier-one investment bank.


![Stephen Taylor](../img/faces/stephentaylor.png)
{: .small-face}

**Stephen Taylor** FRSA is the Kx Librarian. He has followed the evolution of the Iversonian languages through APL, J, k, and q, and is a former editor of [_Vector_](https://vector.org.uk), the journal of the British APL Association.
<br>
[:fontawesome-solid-envelope:](mailto:stephen@kx.com?subject=White paper: Parse trees and functional forms) &nbsp;
[:fontawesome-brands-linkedin:](https://www.linkedin.com/in/stephen-taylor-b5ba78/) &nbsp;
[:fontawesome-brands-twitter:](https://twitter.com/sjt5jt)

Other papers by Stephen Taylor
{: .publications}

<ul markdown="1" class="publications">
-   :fontawesome-regular-map: [Iterators](iterators/index.md)
-   :fontawesome-solid-globe: [Pair programming with the users](http://archive.vector.org.uk/art10009900)
-   :fontawesome-solid-globe: [Three principles of coding clarity](http://archive.vector.org.uk/art10009750)
</ul>


## Appendix

```q
\c 30 200
tidy:{ssr/[;("\"~~";"~~\"");("";"")] $[","=first x;1_x;x]}
strBrk:{y,(";" sv x),z}

//replace k representation with equivalent q keyword
kreplace:{[x] $[`=qval:.q?x;x;"~~",string[qval],"~~"]}
funcK:{$[0=t:type x;.z.s each x;t<100h;x;kreplace x]}

//replace eg ,`FD`ABC`DEF with "enlist`FD`ABC`DEF"
ereplace:{"~~enlist",(.Q.s1 first x),"~~"}
ereptest:{(1=count x) and ((0=type x) and 11=type first x) or 11=type x}
funcEn:{$[ereptest x;ereplace x;0=type x;.z.s each x;x]}

basic:{tidy .Q.s1 funcK funcEn x}

addbraks:{"(",x,")"}

//Where clause needs to be a list of Where clauses, 
//so if only one Where clause, need to enlist.
stringify:{$[(0=type x) and 1=count x;"enlist ";""],basic x}

//if a dictionary, apply to both keys and values
ab:{
  $[(0=count x) or -1=type x; .Q.s1 x;
    99=type x; (addbraks stringify key x ),"!",stringify value x;
    stringify x] }

inner:{[x]
  idxs:2 3 4 5 6 inter ainds:til count x;
  x:@[x;idxs;'[ab;eval]];
  if[6 in idxs;x[6]:ssr/[;("hopen";"hclose");("iasc";"idesc")] x[6]]; 
  //for select statements within select statements
  x[1]:$[-11=type x 1;x 1;[idxs,:1;.z.s x 1]];
  x:@[x;ainds except idxs;string];
  x[0],strBrk[1_x;"[";"]"] }

buildQuery:{inner parse x}
```
