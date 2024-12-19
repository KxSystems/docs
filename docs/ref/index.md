---
title: Reference card | kdb+ and q documentation
description: Quick reference for kdb+ and the q programming language
author: Stephen Taylor
---

# Reference card




## Keywords
<style>
	.kx-tight td,
	.kx-tight th {
		font-size: 85%;
		padding: 0 .4em;
	}
	.kx-tight th {
		border-bottom: 1px solid rgba(0,0,0,.3);
		opacity: .7;
		text-align: left;
	}
	.kx-tight thead {
		border-bottom: 1px solid #aaa;
	}
</style>

<table class="kx-tight" markdown><tbody markdown>
<tr markdown><td markdown>[abs](abs.md "absolute value")</td><td markdown>[cor](cor.md "correlation")</td><td markdown>[ej](ej.md "equi-join")</td><td markdown>[gtime](gtime.md "UTC timestamp")</td><td markdown>[like](like.md "pattern matching")</td><td markdown>[mins](min.md#mins "minimum of preceding items")</td><td markdown>[prev](next.md#prev "previous items")</td><td markdown>[scov](cov.md#scov "statistical covariance")</td><td markdown>[system](system.md "execute system command")</td><td markdown>[wavg](avg.md#wavg "weighted average")</td></tr>
<tr markdown><td markdown>[acos](cos.md "arccosine")</td><td markdown>[cos](cos.md "cosine")</td><td markdown>[ema](ema.md "exponentially-weighted moving average")</td><td markdown>[hclose](hopen.md#hclose "close a file or process")</td><td markdown>[lj ljf](lj.md "left join")</td><td markdown>[mmax](max.md#mmax "moving maxima")</td><td markdown>[prior](prior.md "apply function between each item and its predecessor")</td><td markdown>[sdev](dev.md#sdev "statistical standard deviation")</td><td markdown>[tables](tables.md "sorted list of tables")</td><td markdown>[where](where.md "replicated items")</td></tr>
<tr markdown><td markdown>[aj aj0](aj.md "as-of join")</td><td markdown>[count](count.md "number of items")</td><td markdown>[enlist](enlist.md "arguments as a list")</td><td markdown>[hcount](hcount.md "size of a file")</td><td markdown>[load](load.md "load binary data")</td><td markdown>[mmin](min.md#mmin "moving minima")</td><td markdown>[rand](rand.md "random number")</td><td markdown>[select](select.md "select columns from a table")</td><td markdown>[tan](tan.md "tangent")</td><td markdown>[while](while.md "repeat under condition")</td></tr>
<tr markdown><td markdown>[ajf ajf0](aj.md "as-of join")</td><td markdown>[cov](cov.md "covariance")</td><td markdown>[eval](eval.md "evaluate a parse tree")</td><td markdown>[hdel](hdel.md "delete a file")</td><td markdown>[log](log.md "natural logarithm")</td><td markdown>[mmu](mmu.md "matrix multiplication")</td><td markdown>[rank](rank.md "grade up")</td><td markdown>[set](get.md#set "assign a value to a name")</td><td markdown>[til](til.md "integers up to x")</td><td markdown>[within](within.md "flag items within range")</td></tr>
<tr markdown><td markdown>[all](all-any.md#all "all nonzero")</td><td markdown>[cross](cross.md "cross product")</td><td markdown>[except](except.md "left argument without items in right argument")</td><td markdown>[hopen](hopen.md "open a file")</td><td markdown>[lower](lower.md "lower case")</td><td markdown>[mod](mod.md "remainder")</td><td markdown>[ratios](ratios.md "ratios of consecutive pairs")</td><td markdown>[setenv](getenv.md#setenv "set an environment variable")</td><td markdown>[trim](trim.md "remove leading and trailing spaces")</td><td markdown>[wj wj1](wj.md "window join")</td></tr>
<tr markdown><td markdown>[and](lesser.md "lesser")</td><td markdown>[csv](csv.md "comma delimiter")</td><td markdown>[exec](exec.md "")</td><td markdown>[hsym](hsym.md "convert symbol to filename or IP address")</td><td markdown>[lsq](lsq.md "least squares – matrix divide")</td><td markdown>[msum](sum.md#msum "moving sum")</td><td markdown>[raze](raze.md "join items")</td><td markdown>[show](show.md "format to the console")</td><td markdown>[type](type.md "data type")</td><td markdown>[wsum](sum.md#wsum "weighted sum")</td></tr>
<tr markdown><td markdown>[any](all-any.md#any "any item is non-zero")</td><td markdown>[cut](cut.md "cut array into pieces")</td><td markdown>[exit](exit.md "terminate q")</td><td markdown>[iasc](asc.md#iasc "indices of ascending sort")</td><td markdown>[ltime](gtime.md#ltime "local timestamp")</td><td markdown>[neg](neg.md "negate")</td><td markdown>[read0](read0.md "read file as lines")</td><td markdown>[signum](signum.md "sign of its argument/s")</td><td markdown>[uj ujf](uj.md "union join")</td><td markdown>[xasc](asc.md#xasc "table sorted ascending by columns")</td></tr>
<tr markdown><td markdown>[asc](asc.md "ascending sort")</td><td markdown>[delete](delete.md#delete-keyword "delete rows or columns from a table")</td><td markdown>[exp](exp.md "power of e")</td><td markdown>[idesc](desc.md#idesc "indices of descending sort")</td><td markdown>[ltrim](trim.md#ltrim "function remove leading spaces")</td><td markdown>[next](next.md "next items")</td><td markdown>[read1](read1.md "read file as bytes")</td><td markdown>[sin](sin.md "sine")</td><td markdown>[ungroup](ungroup.md "flattened table")</td><td markdown>[xbar](xbar.md "interval bar")</td></tr>
<tr markdown><td markdown>[asin](sin.md "arcsine")</td><td markdown>[deltas](deltas.md "differences between consecutive pairs")</td><td markdown>[fby](fby.md "filter-by")</td><td markdown>[if](if.md "if")</td><td markdown>[mavg](avg.md#mavg "moving average")</td><td markdown>[not](not.md "logical not")</td><td markdown>[reciprocal](reciprocal.md "reciprocal of a number")</td><td markdown>[sqrt](sqrt.md "square root")</td><td markdown>[union](union.md "distinct items of combination of two lists")</td><td markdown>[xcol](cols.md#xcol "rename table columns")</td></tr>
<tr markdown><td markdown>[asof](asof.md "as-of join")</td><td markdown>[desc](desc.md "descending sort")</td><td markdown>[fills](fill.md#fills "forward-fill nulls")</td><td markdown>[ij ijf](ij.md "inner join")</td><td markdown>[max](max.md "maximum")</td><td markdown>[null](null.md "is argument a null")</td><td markdown>[reval](eval.md#reval "variation of eval")</td><td markdown>[ss](ss.md "string search")</td><td markdown>[update](update.md "insert or replace table records")</td><td markdown>[xcols](cols.md#xcols "re-order table columns")</td></tr>
<tr markdown><td markdown>[atan](tan.md "arctangent")</td><td markdown>[dev](dev.md "standard deviation")</td><td markdown>[first](first.md "first item")</td><td markdown>[in](in.md "membership")</td><td markdown>[maxs](max.md#maxs "maxima of preceding items")</td><td markdown>[or](greater.md "greater")</td><td markdown>[reverse](reverse.md "reverse the order of items")</td><td markdown>[ssr](ss.md#ssr "string search and replace")</td><td markdown>[upper](lower.md#upper "upper-case")</td><td markdown>[xdesc](desc.md#xdesc "table sorted descending by columns")</td></tr>
<tr markdown><td markdown>[attr](attr.md "attributes")</td><td markdown>[differ](differ.md "flag differences in consecutive pairs")</td><td markdown>[fkeys](fkeys.md "foreign-key columns mapped to their tables")</td><td markdown>[insert](insert.md "append records to a table")</td><td markdown>[mcount](count.md#mcount "moving count")</td><td markdown>[over](over.md "reduce an array with a value")</td><td markdown>[rload](load.md#rload "load a splayed table")</td><td markdown>[string](string.md "cast to string")</td><td markdown>[upsert](upsert.md "add table records")</td><td markdown>[xexp](exp.md#xexp "raised to a power")</td></tr>
<tr markdown><td markdown>[avg](avg.md#avg "arithmetic mean")</td><td markdown>[distinct](distinct.md "unique items")</td><td markdown>[flip](flip.md "transpose")</td><td markdown>[inter](inter.md "items common to both arguments")</td><td markdown>[md5](md5.md "MD5 hash")</td><td markdown>[parse](parse.md "parse a string")</td><td markdown>[rotate](rotate.md "rotate items")</td><td markdown>[sublist](sublist.md "sublist of a list")</td><td markdown>[value](value.md "value of a variable or dictionary key; value of an executed sting")</td><td markdown>[xgroup](xgroup.md "table grouped by keys")</td></tr>
<tr markdown><td markdown>[avgs](avg.md#avgs "running averages")</td><td markdown>[div](div.md "integer division")</td><td markdown>[floor](floor.md "greatest integer less than argument")</td><td markdown>[inv](inv.md "matrix inverse")</td><td markdown>[mdev](dev.md#mdev "moving deviation")</td><td markdown>[peach](each.md "parallel each")</td><td markdown>[rsave](save.md#rsave "")</td><td markdown>[sum](sum.md "sum of a list")</td><td markdown>[var](var.md "variance")</td><td markdown>[xkey](keys.md#xkey "set primary keys of a table")</td></tr>
<tr markdown><td markdown>[bin binr](bin.md "binary search")</td><td markdown>[do](do.md "repeat")</td><td markdown>[get](get.md "get a q data file")</td><td markdown>[key](key.md "keys of a dictionary etc.")</td><td markdown>[med](med.md "median")</td><td markdown>[pj](pj.md "plus join")</td><td markdown>[rtrim](trim.md#rtrim "remove trailing spaces")</td><td markdown>[sums](sum.md#sums "cumulative sums")</td><td markdown>[view](view.md "definition of a dependency")</td><td markdown>[xlog](log.md#xlog "base-x logarithm")</td></tr>
<tr markdown><td markdown>[ceiling](ceiling.md "lowest integer above")</td><td markdown>[dsave](dsave.md "save global tables to disk")</td><td markdown>[getenv](getenv.md "value of an environment variable")</td><td markdown>[keys](keys.md "names of a table's columns")</td><td markdown>[meta](meta.md "metadata of a table")</td><td markdown>[prd](prd.md "product")</td><td markdown>[save](save.md "save global data to file")</td><td markdown>[sv](sv.md "decode/consolidate")</td><td markdown>[views](view.md#views "list of defined views")</td><td markdown>[xprev](next.md#xprev "previous items")</td></tr>
<tr markdown><td markdown>[cols](cols.md#cols "column names of a table")</td><td markdown>[each](each.md "apply to each item")</td><td markdown>[group](group.md "dictionary of distinct items")</td><td markdown>[last](first.md#last "last item")</td><td markdown>[min](min.md "minimum")</td><td markdown>[prds](prd.md "running products")</td><td markdown>[scan](over.md "apply value to successive items")</td><td markdown>[svar](var.md#svar "statistical variance")</td><td markdown>[vs](vs.md "encode")</td><td markdown>[xrank](xrank.md "items assigned to buckets")</td></tr>
</tbody></table>

### By category
<table class="kx-tight" markdown>
<tbody markdown>
<tr markdown><td markdown>control</td><td markdown>[do](do.md "repeat"), [exit](exit.md "terminate q"), [if](if.md "if"), [while](while.md "repeat under condition")</td></tr>
<tr markdown><td markdown>env</td><td markdown>[getenv](getenv.md "value of an environment variable"), [gtime](gtime.md "UTC timestamp"), [ltime](gtime.md#ltime "local timestamp"), [setenv](getenv.m
d#setenv "set an environment variable")</td></tr>
<tr markdown><td markdown>interpret</td><td markdown>[eval](eval.md "evaluate a parse tree"), [parse](parse.md "parse a string"), [reval](eval.md#reval "variation of eval"), [show](show.md "format to the console"), [system](system.md "execute system command"), [value](value.md "value of a variable or dictionary key; value of an executed sting")</td></tr>
<tr markdown><td markdown>io</td><td markdown>[dsave](dsave.md "save global tables to disk"), [get](get.md "get a q data file"), [hclose](hopen.md#hclose "close a file or process"), [hcount](hcount.md "size of a file"), [hdel](hdel.md "delete a file"), [hopen](hopen.md "open a file"), [hsym](hsym.md "convert symbol to filename or IP address"), [load](load.md "load binary data"), [read0](read0.md "read file as lines"), [read1](read1.md "read file as bytes"), [rload](load.md#rload "load a splayed table"), [rsave](save.md#rsave ""), [save](save.md "save global data to file"), [set](get.md#set "assign a value to a name")</td></tr>
<tr markdown><td markdown>iterate</td><td markdown>[each](each.md "apply to each item"), [over](over.md "reduce an array with a value"), [peach](each.md "parallel each"), [prior](prior.md "apply function between each item and its predecessor"), [scan](over.md "apply value to successive items")</td></tr>
<tr markdown><td markdown>join</td><td markdown>[aj aj0](aj.md "as-of join"), [ajf ajf0](aj.md "as-of join"), [asof](asof.md "as-of join"), [ej](ej.md "equi-join"), [ij ijf](ij.md "inner join"), [lj ljf](lj.md "left join"), [pj](pj.md "plus join"), [uj ujf](uj.md "union join"), [wj wj1](wj.md "window join")</td></tr>
<tr markdown><td markdown>list</td><td markdown>[count](count.md "number of items"), [cross](cross.md "cross product"), [cut](cut.md "cut array into pieces"), [enlist](enlist.md "arguments as a list"), [except](except.md "left argument without items in right argument"), [fills](fill.md#fills "forward-fill nulls"), [first](first.md "first item"), [flip](flip.md "transpose"), [group](group.md "dictionary of distinct items"), [in](in.md "membership"), [inter](inter.md "items common to both arguments"), [last](first.md#last "last item"), [mcount](count.md#mcount "moving count"), [next](next.md "next items"), [prev](next.md#prev "previous items"), [raze](raze.md "join items"), [reverse](reverse.md "reverse the order of items"), [rotate](rotate.md "rotate items"), [sublist](sublist.md "sublist of a list"), [sv](sv.md "decode/consolidate"), [til](til.md "integers up to x"), [union](union.md "distinct items of combination of two lists"), [vs](vs.md "encode"), [where](where.md "replicated items"), [xprev](next.md#xprev "previous items")</td></tr>
<tr markdown><td markdown>logic</td><td markdown>[all](all-any.md#all "all nonzero"), [and](lesser.md "lesser"), [any](all-any.md#any "any item is non-zero"), [not](not.md "logical not"), [or](greater.md "greater")</td></tr>
<tr markdown><td markdown>math</td><td markdown>[abs](abs.md "absolute value"), [acos](cos.md "arccosine"), [asin](sin.md "arcsine"), [atan](tan.md "arctangent"), [avg](avg.md#avg "arithmetic mean"), [avgs](avg.md#avgs "running averages"), [ceiling](ceiling.md "lowest integer above"), [cor](cor.md "correlation"), [cos](cos.md "cosine"), [cov](cov.md "covariance"), [deltas](deltas.md "differences between consecutive pairs"), [dev](dev.md "standard deviation"), [div](div.md "integer division"), [ema](ema.md "exponentially-weighted moving average"), [exp](exp.md "power of e"), [floor](floor.md "greatest integer less than argument"), [inv](inv.md "matrix inverse"), [log](log.md "natural logarithm"), [lsq](lsq.md "least squares – matrix divide"), [mavg](avg.md#mavg "moving average"), [max](max.md "maximum"), [maxs](max.md#maxs "maxima of preceding items"), [mdev](dev.md#mdev "moving deviation"), [med](med.md "median"), [min](min.md "minimum"), [mins](min.md#mins "minimum of preceding items"), [mmax](max.md#mmax "moving maxima"), [mmin](min.md#mmin "moving minima"), [mmu](mmu.md "matrix multiplication"), [mod](mod.md "remainder"), [msum](sum.md#msum "moving sum"), [neg](neg.md "negate"), [prd](prd.md "product"), [prds](prd.md "running products"), [rand](rand.md "random number"), [ratios](ratios.md "ratios of consecutive pairs"), [reciprocal](reciprocal.md "reciprocal of a number"), [scov](cov.md#scov "statistical covariance"), [sdev](dev.md#sdev "statistical standard deviation"), [signum](signum.md "sign of its argument/s"), [sin](sin.md "sine"), [sqrt](sqrt.md "square root"), [sum](sum.md "sum of a list"), [sums](sum.md#sums "cumulative sums"), [svar](var.md#svar "statistical variance"), [tan](tan.md "tangent"), [var](var.md "variance"), [wavg](avg.md#wavg "weighted average"), [within](within.md "flag items within range"), [wsum](sum.md#wsum "weighted sum"), [xexp](exp.md#xexp "raised to a power"), [xlog](log.md#xlog "base-x logarithm")</td></tr>
<tr markdown><td markdown>meta</td><td markdown>[attr](attr.md "attributes"), [null](null.md "is argument a null"), [tables](tables.md "sorted list of tables"), [type](type.md "data type"), [view](view.md "definition of a dependency"), [views](view.md#views "list of defined views")</td></tr>
<tr markdown><td markdown>query</td><td markdown>[delete](delete.md#delete-keyword "delete rows or columns from a table"), [exec](exec.md ""), [fby](fby.md "filter-by"), [select](select.md "select columns from a table"), [update](update.md "insert or replace table records")</td></tr>
<tr markdown><td markdown>sort</td><td markdown>[asc](asc.md "ascending sort"), [bin binr](bin.md "binary search"), [desc](desc.md "descending sort"), [differ](differ.md "flag differences in consecutive pairs"), [distinct](distinct.md "unique items"), [iasc](asc.md#iasc "indices of ascending sort"), [idesc](desc.md#idesc "indices of descending sort"), [rank](rank.md "grade up"), [xbar](xbar.md "interval bar"), [xrank](xrank.md "items assigned to buckets")</td></tr>
<tr markdown><td markdown>table</td><td markdown>[cols](cols.md#cols "column names of a table"), [csv](csv.md "comma delimiter"), [fkeys](fkeys.md "foreign-key columns mapped to their tables"), [insert](insert.md "append records to a table"), [key](key.md "keys of a dictionary etc."), [keys](keys.md "names of a table's columns"), [meta](meta.md "metadata of a table"), [ungroup](ungroup.md "flattened table"), [upsert](upsert.md "add table records"), [xasc](asc.md#xasc "table sorted ascending by columns"), [xcol](cols.md#xcol "rename table columns"), [xcols](cols.md#xcols "re-order table columns"), [xdesc](desc.md#xdesc "table sorted descending by columns"), [xgroup](xgroup.md "table grouped by keys"), [xkey](keys.md#xkey "set primary keys of a table")</td></tr>
<tr markdown><td markdown>text</td><td markdown>[like](like.md "pattern matching"), [lower](lower.md "lower case"), [ltrim](trim.md#ltrim "function remove leading spaces"), [md5](md5.md "MD5 hash"), [rtrim](trim.md#rtrim "remove trailing spaces"), [ss](ss.md "string search"), [ssr](ss.md#ssr "string search and replace"), [string](string.md "cast to string"), [trim](trim.md "remove leading and trailing spaces"), [upper](lower.md#upper "upper-case")</td></tr>
</tbody></table>

:fontawesome-solid-book:
[`.Q.id`](dotq.md#id-sanitize) (sanitize),
[`.Q.res`](dotq.md#res-keywords) (reserved words)


## Operators
<style>.kx-glyph{background-color: rgba(0,0,0,.05);font-size: 110%;text-align: center; white-space: nowrap;}</style>
<table class="kx-tight" markdown>
<tr markdown>
<td markdown class="kx-glyph">[`.`](overloads.md#dot)</td><td colspan="3" markdown>[Apply](apply.md), [Index](apply.md#index), [Trap](apply.md#trap), [Amend](amend.md)</td>
<td markdown class="kx-glyph">[`@`](overloads.md#at)</td><td colspan="3" markdown>[Apply At](apply.md#apply-at-index-at), [Index At](apply.md##apply-at-index-at), [Trap At](apply.md#trap-at), [Amend At](amend.md)</td>
</tr>
<tr markdown>
<td markdown class="kx-glyph">[`$`](overloads.md#dollar)</td><td colspan="7" markdown>[Cast](cast.md), [Tok](tok.md), [Enumerate](enumerate.md), [Pad](pad.md), [`mmu`](mmu.md)</td>
</tr>
<tr markdown>
<td markdown class="kx-glyph">[`!`](overloads.md#bang)</td><td colspan="7" markdown>[Dict](dict.md), [Enkey](enkey.md), [Unkey](enkey.md#unkey), [Enumeration](enumeration.md), [Flip Splayed](flip-splayed.md), [Display](display.md), [internal](../basics/internal.md), [Update](../basics/funsql.md#update), [Delete](../basics/funsql.md#delete), [`lsq`](lsq.md)</td>
</tr>
<tr markdown>
<td markdown class="kx-glyph">[`?`](overloads.md#query)</td><td colspan="7" markdown>[Find](find.md), [Roll, Deal](deal.md), [Enum Extend](enum-extend.md), [Select](../basics/funsql.md#select), [Exec](../basics/funsql.md#exec), [Simple Exec](../basics/funsql.md#simple-exec), [Vector Conditional](vector-conditional.md)</td>
</tr>
<tr markdown>
</tr>
<tr markdown> <td markdown class="kx-glyph">`+ - * %`</td><td colspan="7" markdown>[Add](add.md), [Subtract](subtract.md), [Multiply](multiply.md), [Divide](divide.md)</td> </tr>
<tr markdown> <td markdown class="kx-glyph">`= <> ~`</td><td colspan="7" markdown>[Equals](../basics/comparison.md#six-comparison-operators), [Not Equals](../basics/comparison.md#six-comparison-operators), [Match](../basics/comparison.md#match)</td></tr>
<tr markdown>
<td markdown class="kx-glyph">`< <= >= >`</td><td colspan="7" markdown>[Less Than](../basics/comparison.md#six-comparison-operators), [Up To](../basics/comparison.md#six-comparison-operators), [At Least](../basics/comparison.md#six-comparison-operators), [Greater Than](../basics/comparison.md#six-comparison-operators)</td>
</tr>
<tr markdown> <td markdown class="kx-glyph">`| &`</td><td colspan="3" markdown>[Greater (OR)](greater.md), [Lesser, AND](lesser.md)</td> </tr>
<tr markdown>
<td markdown class="kx-glyph">[`#`](overloads.md#hash)</td><td colspan="3" markdown>[Take](take.md), [Set&nbsp;Attribute](set-attribute.md)</td>
<td markdown class="kx-glyph">[`_`](overloads.md#_-underscore)</td><td markdown>[Cut](cut.md), [Drop](drop.md)</td>
<td markdown class="kx-glyph">`:`</td><td markdown>[Assign](assign.md)</td>
</tr>
<tr markdown>
<td markdown class="kx-glyph">`^`</td><td colspan="3" markdown>[Fill](fill.md), [Coalesce](coalesce.md)</td>
<td markdown class="kx-glyph">`,`</td><td markdown>[Join](join.md)</td>
<td markdown class="kx-glyph">[`'`](overloads.md#quote)</td><td markdown>[Compose](compose.md)</td>
</tr>
<tr markdown> <td markdown class="kx-glyph">`0: 1: 2:`</td><td colspan="7" markdown>[File Text](file-text.md), [File Binary](file-binary.md), [Dynamic Load](dynamic-load.md)</td> </tr>
<tr markdown> <td markdown class="kx-glyph">`0 ±1 ±2 ±n`</td><td colspan="7" markdown>write to [console, stdout, stderr, handle _n_](../basics/handles.md)</td> </tr>
</table>

:fontawesome-solid-book:
[Overloaded glyphs](overloads.md)


## [Iterators](iterators.md)

<div markdown class="typewriter">
[maps](maps.md)                                                    [accumulators](accumulators.md)
[`'`](overloads.md#quote)   [Each](maps.md#each), [`each`](each.md), [Case](maps.md#case)       `/:`  [Each Right](maps.md#each-left-and-each-right)              [`/`](overloads.md#slash)  [Over](accumulators.md), [`over`](over.md)
[`':`](overloads.md#quote-colon)  [Each Parallel](maps.md#each-parallel), [`peach`](each.md#peach)   `\:`  [Each Left](maps.md#each-left-and-each-right)               [`\`](overloads/#backslash)  [Scan](accumulators.md), [`scan`](over.md)
[`':`](overloads.md#quote-colon)  [Each Prior](maps.md##each-prior), [`prior`](prior.md)
</div>

## [Execution control](../basics/control.md)

<div markdown class="typewriter">
[.[f;x;e] Trap](../ref/apply.md#trap)          [: Return](../basics/function-notation.md#explicit-return)        [do](../ref/do.md)  [exit](../ref/exit.md)         [\$[x;y;z] Cond](../ref/cond.md)
[@[f;x;e] Trap-At](../ref/apply.md#trap)       [' Signal](../ref/signal.md)        [if](../ref/if.md)  [while](../ref/while.md)
</div>

:fontawesome-solid-book-open:
[Debugging](../basics/debug.md)



## Other

<div markdown class="typewriter">
[`   pop stack](../basics/debug.md#debugging)        [::](overloads.md#colon-colon)   [identity](identity.md)         [\x  system cmd x](../basics/syscmds.md)
[.](overloads.md#dot)   [push stack](../basics/debug.md#debugging)            [generic null](identity.md)     [\\    abort](../basics/debug.md#abort)
                          [global amend](../basics/function-notation.md#name-scope)     \\\\   quit q
                          [set view](../learn/views.md)         /    comment

()     [precedence](../basics/syntax.md#precedence-and-order-of-evaluation)    \[;\]  [expn block](../basics/syntax.md#conditional-evaluation-and-control-statements)       {}  [lambda](../basics/function-notation.md)       \`   symbol
(;)    [list](../basics/syntax.md#list-notation)               [argt list](../basics/syntax.md#bracket-notation)        ;   separator    \`:  filepath
(\[\]..) [table](../basics/syntax.md#table-notation)
</div>



<!-- <td markdown class="kx-glyph">`:`</td><td markdown>[Amend](amend.md)<br>[unary form](../basics/exposed-infrastructure.md#unary-forms)</td> -->

## [Attributes](../basics/syntax.md#attributes)

<div markdown class="typewriter">
**g** grouped     **p** parted     **s** sorted     **u** unique
</div>

:fontawesome-solid-book:
[Set Attribute](set-attribute.md)


## Command-line options and system commands

<table markdown class="kx-tight">
<tr markdown><td markdown>[file](../basics/cmdline.md#file)</td></tr>
<tr markdown><td markdown>[`\a`](../basics/syscmds.md#a-tables)</td><td markdown>tables</td><td markdown>[`\r`](../basics/syscmds.md#r-rename)</td><td markdown>rename</td></tr>
<tr markdown><td markdown>[`-b`](../basics/cmdline.md#-b-blocked)</td><td markdown>blocked</td><td markdown>[`-s`](../basics/cmdline.md#-s-secondary-processes) [`\s`](../basics/syscmds.md#s-number-of-secondary-threads)</td><td markdown>secondary processes</td></tr>
<tr markdown><td markdown>[`\b`](../basics/syscmds.md#b-views) [`\B`](../basics/syscmds.md#b-pending-views)</td><td markdown>views</td><td markdown>[`-S`](../basics/cmdline.md#-s-random-seed) [`\S`](../basics/syscmds.md#s-random-seed)</td><td markdown>random seed</td></tr>
<tr markdown><td markdown>[`-c`](../basics/cmdline.md#-c-console-size) [`\c`](../basics/syscmds.md#c-console-size)</td><td markdown>console size</td><td markdown>[`-t`](../basics/cmdline.md#-t-timer-ticks) [`\t`](../basics/syscmds.md#t-timer)</td><td markdown>timer ticks</td></tr>
<tr markdown><td markdown>[`-C`](../basics/cmdline.md#-c-http-size) [`\C`](../basics/syscmds.md#c-http-size)</td><td markdown>HTTP size</td><td markdown>[`\ts`](../basics/syscmds.md#ts-time-and-space)</td><td markdown>time and space</td></tr>
<tr markdown><td markdown>[`\cd`](../basics/syscmds.md#cd-change-directory)</td><td markdown>change directory</td><td markdown>[`-T`](../basics/cmdline.md#-t-timeout) [`\T`](../basics/syscmds.md#t-timeout)</td><td markdown>timeout</td></tr>
<tr markdown><td markdown>[`\d`](../basics/syscmds.md#d-directory)</td><td markdown>directory</td><td markdown>[`-u`](../basics/cmdline.md#-u-usr-pwd-local) [`-U`](../basics/cmdline.md#-u-usr-pwd) [`\u`](../basics/syscmds.md#u-reload-user-password-file)</td><td markdown>usr-pwd</td></tr>
<tr markdown><td markdown>[`-e`](../basics/cmdline.md#-e-error-traps) [`\e`](../basics/syscmds.md#e-error-trap-clients)</td><td markdown>error traps</td><td markdown>[`-u`](../basics/cmdline.md#-u-disable-syscmds)</td><td markdown>disable syscmds</td></tr>
<tr markdown><td markdown>[`-E`](../basics/cmdline.md#-e-tls-server-mode) [`\E`](../basics/syscmds.md#e-tls-server-mode)</td><td markdown>TLS server mode</td><td markdown>[`\v`](../basics/syscmds.md#v-variables)</td><td markdown>variables</td></tr>
<tr markdown><td markdown>[`\f`](../basics/syscmds.md#f-functions)</td><td markdown>functions</td><td markdown>[`-w`](../basics/cmdline.md#-w-workspace) [`\w`](../basics/syscmds.md#w-workspace)</td><td markdown>memory</td></tr>
<tr markdown><td markdown>[`-g`](../basics/cmdline.md#-g-garbage-collection) [`\g`](../basics/syscmds.md#g-garbage-collection-mode)</td><td markdown>garbage collection</td><td markdown>[`-W`](../basics/cmdline.md#-w-start-week) [`\W`](../basics/syscmds.md#w-week-offset)</td><td markdown>week offset</td></tr>
<tr markdown><td markdown>[`\l`](../basics/syscmds.md#l-load-file-or-directory)</td><td markdown>load file or directory</td><td markdown>[`\x`](../basics/syscmds.md#x-expunge)</td><td markdown>expunge</td></tr>
<tr markdown><td markdown>[`-l`](../basics/cmdline.md#-l-log-updates) [`-L`](../basics/cmdline.md#-l-log-sync)</td><td markdown>log sync</td><td markdown>[`-z`](../basics/cmdline.md#-z-date-format) [`\z`](../basics/syscmds.md#z-date-parsing)</td><td markdown>date format</td></tr>
<tr markdown><td markdown>[`-o`](../basics/cmdline.md#-o-utc-offset) [`\o`](../basics/syscmds.md#o-offset-from-utc)</td><td markdown>UTC offset</td><td markdown>[`\1` `\2`](../basics/syscmds.md#1-2-redirect)</td><td markdown>redirect</td></tr>
<tr markdown><td markdown>[`-p`](../basics/cmdline.md#-p-listening-port) [`\p`](../basics/syscmds.md#p-listening-port)</td><td markdown>listening port</td><td markdown>[`\_`](../basics/syscmds.md#_-hide-q-code)</td><td markdown>hide q code</td></tr>
<tr markdown><td markdown>[`-P`](../basics/cmdline.md#-p-display-precision) [`\P`](../basics/syscmds.md#p-precision)</td><td markdown>display precision</td><td markdown>[`\`](../basics/syscmds.md#terminate)</td><td markdown>terminate</td></tr>
<tr markdown><td markdown>[`-q`](../basics/cmdline.md#-q-quiet-mode)</td><td markdown>quiet mode</td><td markdown>[`\`](../basics/syscmds.md#toggle-qk)</td><td markdown>toggle q/k</td></tr>
<tr markdown><td markdown>[`-r`](../basics/cmdline.md#-r-replicate) [`\r`](../basics/syscmds.md#r-replication-primary)</td><td markdown>replicate</td><td markdown>[`\\`](../basics/syscmds.md#quit)</td><td markdown>quit</td></tr>
</table>

:fontawesome-solid-book:
[`system`](../ref/system.md)
<br>
:fontawesome-solid-book-open:
[Command-line options](../basics/cmdline.md),
[System commands](../basics/syscmds.md),
[OS commands](../basics/syscmds.md#os-commands)


<!--
## Environment variables

<table class="kx-tight">
<thead><tr markdown><th>var</th><th>default</th><th>use</th></tr></thead>
<tbody>
<tr markdown><td markdown><code>QHOME</code></td><td markdown><code>$HOME/q</code></td><td markdown>folder searched for q.k and unqualified script names</td></tr>
<tr markdown><td markdown><code>QLIC</code></td><td markdown><code>$HOME</code></td><td markdown>folder searched for k4.lic license file</td></tr>
<tr markdown><td markdown><code>QINIT</code></td><td markdown><code>q.q</code></td><td markdown>additional file loaded after q.k has initialised</td></tr>
<tr markdown><td markdown><code>LINES</code></td><td markdown/><td markdown>supplied by OS, used to set <code>\c</code></td></tr>
<tr markdown><td markdown><code>COLUMNS</code></td><td markdown/><td markdown><code>\c $LINES $COLUMNS</code></td></tr>
</tbody>
</table>

If not set, `LINES COLUMNS` default to 25 80 for console, and 36 2000 for Web. `\c` [clamps](https://en.wikipedia.org/wiki/Clamping_(graphics) "wikipedia definition") to range 10…2000 for both inputs.

Ensure `LINES` and `COLUMNS` are exported. In Bash
```bash
$ export LINES COLUMNS
```
before starting q.
```q
q)getenv`VARNAME
q)`VARNAME setenv "NEWVALUE"
```
 -->

## [Datatypes](../basics/datatypes.md)

<div markdown class="typewriter">
**Basic datatypes**
n   c   name      sz  literal            null inf SQL       Java      .Net
\------------------------------------------------------------------------------------
0   *   list
1   b   boolean   1   0b                                    Boolean   boolean
2   g   guid      16                     0Ng                UUID      GUID
4   x   byte      1   0x00                                  Byte      byte
5   h   short     2   0h                 0Nh  0Wh smallint  Short     int16
6   i   int       4   0i                 0Ni  0Wi int       Integer   int32
7   j   long      8   0j                 0Nj  0Wj bigint    Long      int64
                      0                  0N   0W
8   e   real      4   0e                 0Ne  0We real      Float     single
9   f   float     8   0.0                0n   0w  float     Double    double
                      0f                 0Nf
10  c   char      1   " "                " "                Character char
11  s   symbol        \`                  \`        varchar
12  p   timestamp 8   dateDtimespan      0Np  0Wp           Timestamp DateTime (RW)
13  m   month     4   2000.01m           0Nm
14  d   date      4   2000.01.01         0Nd  0Wd date      Date
15  z   datetime  8   dateTtime          0Nz  0wz timestamp Timestamp DateTime (RO)
16  n   timespan  8   00:00:00.000000000 0Nn  0Wn           Timespan  TimeSpan
17  u   minute    4   00:00              0Nu  0Wu
18  v   second    4   00:00:00           0Nv  0Wv
19  t   time      4   00:00:00.000       0Nt  0Wt time      Time      TimeSpan

Columns:
_n_    short int returned by [`type`](type.md) and used for [Cast](cast.md), e.g. `9h$3`
_c_    character used lower-case for [Cast](cast.md) and upper-case for [Tok](tok.md) and [Load CSV](file-text.md#load-csv)
_sz_   size in bytes
_inf_  infinity (no math on temporal types); `0Wh` is `32767h`

RO: read only; RW: read-write

**Other datatypes**
20-76   enums
77      anymap                                      104  [projection](../basics/application.md#projection)
78-96   77+t – mapped list of lists of type t       105  [composition](compose.md)
97      nested sym enum                             106  [f'](maps.md#each)
98      table                                       107  [f/](accumulators.md)
99      dictionary                                  108  [f\\](accumulators.md)
100     [lambda](../basics/function-notation.md)                                      109  [f':](maps.md)
101     unary primitive                             110  [f/:](maps.md#each-left-and-each-right)
102     operator                                    111  [f\\:](maps.md#each-left-and-each-right)
103     [iterator](iterators.md)                                    112  [dynamic load](dynamic-load.md)
</div>

Above, `f` is an [applicable value](../basics/glossary.md#applicable-value).

Nested types are 77+t (e.g. 78 is boolean. 96 is time.)

[Cast `$`](cast.md): where `char` is from the `c` column above `char$data:CHAR$string`

```txt
dict:`a`b!…
table:([]x:…;y:…)
date.(year month week mm dd)
time.(minute second mm ss)
milliseconds: time mod 1000
```


## Namespaces

### [`.h`](doth.md) (markup)

HTTP, markup and data conversion.

### [`.j`](dotj.md) (JSON)

De/serialize as JSON.

### [`.m`](dotm.md) (memory backed files)

Memory backed by files.

### [`.Q`](dotq.md) (utils)

Utilities: general, environment, IPC, datatype, database, partitioned database state, segmented database state, file I/O, debugging, profiling.

### [`.z`](dotz.md) (environment, callbacks)

Environment, callbacks

