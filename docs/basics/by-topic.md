---
title: Q language resources by topic | Basics | kdb+ and q documentation
description: Q language resources by topic
author: Stephen Taylor
date: October 2020
---
# Q language resources by topic


## Casting and encoding

<div markdown="1" class="typewriter">
$       [Cast](../ref/cast.md) between datatypes
$       [Tok](../ref/tok.md): interpret string as value
!       [Enumeration](../ref/enumeration.md)
[parse](../ref/parse.md)   parse string to function
[string](../ref/string.md)  cast to character
[sv](../ref/sv.md)      decode to integer
[value](../ref/value.md)   parse string to function 
[vs](../ref/vs.md)      encode
</div>


## [Comparison](comparison.md)

<div markdown="1" class="typewriter">
[<     Less Than](../ref/less-than.md)            [>     Greater Than](../ref/greater-than.md)             [deltas  differences](../ref/deltas.md)
[<=    Up To](../ref/less-than.md)                [>=    At Least](../ref/greater-than.md)                 [differ  flag changes](../ref/differ.md)
[&     Lesser](../ref/lesser.md)               [|     Greater](../ref/greater.md)
[min   least, minimum](../ref/min.md)       [max   greatest, maximum](../ref/max.md)
[mins  running minimums](../ref/min.md#mins)     [maxs  running maximums](../ref/max.md#maxs)
[mmin  moving minimums](../ref/min.md#mmin)      [mmax  moving maximums](../ref/max.md#mmax)
</div>

:fontawesome-solid-book-open:
[Precision](precision.md)


## [Dictionaries](dictsandtables.md)

<div markdown="1" class="typewriter">
[! Dict](../ref/dict.md)  make a dictionary         [key](../ref/key.md)      key list
[group](../ref/group.md)   group list by values      [value](../ref/value.md)    value list
</div>


## Environment 

variable | defines | default
---------|---------|--------
COLUMNS  | [`\c`](syscmds.md#c-console-size) | 80
LINES    | [`\c`](syscmds.md#c-console-size) | 25
QHOME    | folder searched for q.k and unqualified script names | `$HOME/q` :fontawesome-brands-apple: :fontawesome-brands-linux:<br>`C:\q` :fontawesome-brands-windows:
QINIT    | additional file loaded after `q.k` has initialized,<br>executed in the default namespace | `$QHOME/q.q`:fontawesome-brands-apple: :fontawesome-brands-linux:<br>`%QHOME%\q.q` :fontawesome-brands-windows:
QLIC     | folder searched for `k4.lic` or `kc.lic` license key file | `$QHOME`:fontawesome-brands-apple: :fontawesome-brands-linux:<br>`%QHOME%` :fontawesome-brands-windows:

<div markdown="1" class="typewriter">
[getenv](../ref/getenv.md)      get value of an environment variable
[gtime](../ref/gtime.md)       UTC equivalent of local timestamp
[ltime](../ref/gtime.md#ltime)       local equivalent of UTC timestamp
[setenv](../ref/getenv.md#setenv)      set value of an environment variable
</div>


## [Evaluation control](control.md)

<div markdown="1" class="typewriter">
[' ': /: \\:   each peach prior](../ref/maps.md "maps")          [\$[test;et;ef;…] Cond](../ref/cond.md)
[\\ /          scan over](../ref/accumulators.md "accumulators")                 [do](../ref/do.md)  [if](../ref/if.md)  [while](../ref/while.md)

[.[f;x] Apply](../ref/apply.md#apply-index)          [.[f;x;e] Trap](../ref/apply.md#trap)          [: Return](function-notation.md#explicit-return)        [exit](../ref/exit.md)
[@[f;x] Apply-At](../ref/apply.md#apply-at-index-at)       [@[f;x;e] Trap-At](../ref/apply.md#trap)       [' Signal](../ref/signal.md)        
</div>


## [File system](files.md)

<div markdown="1" class="typewriter">
[get set](../ref/get.md)       read/write or memory-map a data file¹
[value](../ref/value.md)         read a data file¹

[hcount](../ref/hcount.md)        file size
[hdel](../ref/hdel.md)          delete a file or folder
[hsym](../ref/hsym.md)          symbol/s to file symbol/s¹

[0: File Text](../ref/file-text.md)      read/write chars¹       [read0](../ref/read0.md)  read chars¹
[1: File Binary](../ref/file-binary.md)    read/write bytes¹       [read1](../ref/read1.md)  read bytes¹
[2: Dynamic Load](../ref/dynamic-load.md)   load shared object

[save](../ref/save.md#save)   [load](../ref/load.md)   a variable
[rsave](../ref/save.md#rsave)  [rload](../ref/load.md#rload)  a splayed table
[dsave](../ref/dsave.md)         tables
[?  Enum Extend](../ref/enum-extend.md#filepath)
</div>

¹ Has application beyond the file system.


## [Functional qSQL](funsql.md)

```q
![t;c;b;a]              / update and delete
 
?[t;i;p]                / simple exec
 
?[t;c;b;a]              / select or exec
?[t;c;b;a;n]            / select up to n records
?[t;c;b;a;n;(g;cn)]     / select up to n records sorted by g on cn
```


## [Interprocess communication](ipc.md)

<div markdown="1" class="typewriter">
[\p](syscmds.md#listening-port)  [-p](cmdline.md#listening-port)          listen to port
[hopen hclose](../ref/hopen.md)    open/close connection
[.z](../ref/dotz.md)              callbacks
</div>


## Joins

<div markdown="1" class="typewriter">
**Keyed**                 **As of**
 [ej](../ref/ej.md)        equi        [aj aj0](../ref/aj.md)      as-of
 [ij ijf](../ref/ij.md)    inner       [ajf ajf0](../ref/aj.md)
 [lj ljf](../ref/lj.md)    left        [asof](../ref/asof.md)        simple as-of
 [pj](../ref/pj.md)        plus        [wj wj1](../ref/wj.md)      window
 [uj ujf](../ref/uj.md)    union
 [upsert](../ref/upsert.md)                [, Join](../ref/join.md)               [^ Coalesce](../ref/coalesce.md)
</div>


## Logic

<div markdown="1" class="typewriter">
[all](../ref/all-any.md#all)     whether all items are non-zero
[& and](../ref/lesser.md)   lesser of two values; logical AND
[any](../ref/all-any.md#any)     whether any item is zero
[not](../ref/not.md)     whether if argument is zero 
[null](../ref/null.md)    whether is null
[| or](../ref/greater.md)    greater of two values; logical OR
</div>


## [Math and statistics](math.md)

<div markdown="1" class="typewriter">
\+ [Add](../ref/add.md)      \- [Subtract](../ref/subtract.md)   \* [Multiply](../ref/multiply.md)    % [Divide](../ref/divide.md)
& [Lesser](../ref/lesser.md)   | [Greater](../ref/greater.md)    $ [dot product, Matrix Multiply](../ref/mmu.md)
</div>
<div markdown="1" class="typewriter">
[abs](../ref/abs.md)         absolute value                [mins](../ref/min.md#mins)        minimums
[acos](../ref/cos.md)        arccosine                     [mmax](../ref/max.md#mmax)        moving maximum
[asin](../ref/sin.md)        arcsine                       [mmin](../ref/min.md#mmin)        moving minimum
[atan](../ref/tan.md)        arctangent                    [mmu](../ref/mmu.md)         matrix multiply
[avg](../ref/avg.md#avg)         arithmetic mean               [mod](../ref/mod.md)         modulo
[avgs](../ref/avg.md#avgs)        arithmetic means              [msum](../ref/sum.md#msum)        moving sum
[ceiling](../ref/ceiling.md)     round up to integer           [prd](../ref/prd.md)         product
[cor](../ref/cor.md)         correlation                   [prds](../ref/prd.md#prds)        products
[cos](../ref/cos.md)         cosine                        [ratios](../ref/ratios.md)      ratios
[cov](../ref/cov.md)         covariance                    [reciprocal](../ref/reciprocal.md)  reciprocal
[deltas](../ref/deltas.md)      differences                   [scov](../ref/cov.md#scov)        sample covariance
[dev](../ref/dev.md#dev)         standard deviation            [sdev](../ref/dev.md#sdev)        sample standard deviation
[div](../ref/div.md)         integer division              [signum](../ref/signum.md)      sign
[ema](../ref/ema.md)         exponential moving average    [sin](../ref/sin.md)         sine
[exp](../ref/exp.md#exp)         _e_<sup>x</sup>                            [sqrt](../ref/sqrt.md)        square root
[floor](../ref/floor.md)       round down to integer         [sum](../ref/sum.md)         sum
[inv](../ref/inv.md)         matrix inverse                [sums](../ref/sum.md#sums)        sums
[log](../ref/log.md#log)         natural logarithm             [svar](../ref/var.md#svar)        sample variance
[lsq](../ref/lsq.md)         matrix divide                 [tan](../ref/tan.md)         tangent
[mavg](../ref/avg.md#mavg)        moving average                [til](../ref/til.md)         natural numbers till
[max](../ref/max.md#max)         greatest                      [var](../ref/var.md#var)         variance
[maxs](../ref/max.md#maxs)        maximums                      [wavg](../ref/avg.md#wavg)        weighted average
[mcount](../ref/count.md#mcount)      moving count                  [wsum](../ref/sum.md#wsum)        weighted sum
[mdev](../ref/dev.md#mdev)        moving deviation              [xbar](../ref/xbar.md)        round down
[med](../ref/med.md)         median                        [xexp](../ref/exp.md#xexp)        x<sup>y</sup>
[min](../ref/min.md#min)         least                         [xlog](../ref/log.md#xlog)        base-x logarithm of y
</div>


## [QSQL query templates](qsql.md)

<div markdown="1" class="typewriter">
[delete](../ref/delete.md)  delete rows or columns from a table
[exec](../ref/exec.md)    return columns from a table, possibly with new columns
[select](../ref/select.md)  return part of a table, possibly with new columns
[update](../ref/update.md)  add rows or columns to a table
</div>


## Search 

<div markdown="1" class="typewriter">
[bin, binr](../ref/bin.md)    binary search
[distinct](../ref/distinct.md)     unique items of a list
[? Find](../ref/find.md)       find x in y
[in](../ref/in.md)           which items of x are items of y
[within](../ref/within.md)       whether x are items of list y
</div>


## Selection

<div markdown="1" class="typewriter">
[except](../ref/except.md)       exclude items of one list or dictionary from another
[first](../ref/first.md)         first item of a list or first entry of a dictionary
[. Index](../ref/apply.md#index)      select item at depth from a list or entries from a dictionary
[@ Index At](../ref/apply.md#index)   select items from a list or entries from a dictionary
[inter](../ref/inter.md)        intersection of two lists or dictionaries
[last](../ref/first.md#last)         last item of a list or last entry of a dictionary
[next](../ref/next.md)         immediately following item/s
[prev](../ref/next.md#prev)         immediately preceding item/s
[sublist](../ref/sublist.md)      sublist of a list
[union](../ref/union.md)        union of two lists or dictionaries
[where](../ref/where.md)        copies of indexes of a list, or keys or of a dictionary
[xprev](../ref/next.md#xprev)        nearby list items
</div>


## Sort

<div markdown="1" class="typewriter">
[asc](../ref/asc.md)       sort ascending 
[desc](../ref/desc.md#desc)      sort descending
[group](../ref/group.md)     group a list by values
[iasc](../ref/asc.md#iasc)      grade ascending 
[idesc](../ref/desc.md#idesc)     grade descending
[rank](../ref/rank.md)      position in sorted list
[xgroup](../ref/xgroup.md)    group table by values of selected column/s
[xrank](../ref/xrank.md)     group by value
[xasc](../ref/asc.md#xasc)      sort table ascending
[xdesc](../ref/desc.md#xdesc)     sort table descending
</div>

!!! danger "Duplicate dictionary keys or table column names cause unpredictable results from sorts, grades, and groups."


!!! warning "Re-sorting compressed data on disk decompresses it."

:fontawesome-solid-book-open:
[Dictionaries](dictsandtables.md),
[Tables](../kb/faq.md)


## Strings

<div markdown="1" class="typewriter">
[$ Pad](../ref/pad.md)   pad with spaces
[like](../ref/like.md)    match pattern
[lower](../ref/lower.md)   shift to lower case
[ltrim](../ref/trim.md#ltrim)   trim leading space
[md5](../ref/md5.md)     hash from string
[rtrim](../ref/trim.md#rtrim)   trim trailing space
[ss](../ref/ss.md#ss)      string search
[ssr](../ref/ss.md#ssr)     string search and replace
[trim](../ref/trim.md)    trim leading and trailing space
[upper](../ref/lower.md#upper)   shift to upper case
</div>


## [Tables](../kb/faq.md)

<div markdown="1" class="typewriter">
[cols](../ref/cols.md)     column names             [ungroup](../ref/ungroup.md)  normalize
[meta](../ref/meta.md)     metadata                 [xasc](../ref/asc.md#xasc)     sort ascending
[xcol](../ref/cols.md#xcol)     rename cols              [xdesc](../ref/desc.md#xdesc)    sort descending
[xcols](../ref/cols.md#xcols)    re-order cols            [xgroup](../ref/xgroup.md)   group by values in selected cols
[insert](../ref/insert.md)   insert records           [xkey](../ref/keys.md#xkey)     sset cols as primary keys
[upsert](../ref/upsert.md)   add/insert records       [xdesc](../ref/desc.md#xdesc)    sort descending
[! Enkey, Unkey](../ref/enkey.md)  add/remove keys

[**qSQL query templates**](../basics/qsql.md):   [select](../ref/select.md)   [exec](../ref/exec.md)   [update](../ref/update.md)   [delete](../ref/delete.md)
</div>

