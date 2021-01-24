---
title: Reference card - code.kx.com – Reference – kdb+ and q documentation
description: Quick reference for kdb+ and the q programming language
author: Stephen Taylor
keywords: card, index, kdb+, keywords, operators, q, reference
---

# Reference card




## Keywords

<table class="kx-shrunk kx-tight" markdown="1">
<tr markdown="1"><td markdown="1">A</td><td markdown="1">[`abs`](abs.md "absolute value") [`acos`](cos.md "arccosine") [`aj` `aj0` `ajf` `ajf0`](aj.md "as-of join") [`all`](all-any.md#all "all nonzero") [`and`](lesser.md "lesser") [`any`](all-any.md#any "any item is non-zero") [`asc`](asc.md "ascending sort") [`asin`](sin.md "arcsine") [`asof`](asof.md "as-of join") [`atan`](tan.md "arctangent") [`attr`](attr.md "attributes") [`avg`](avg.md#avg "arithmetic mean") [`avgs`](avg.md#avgs "running averages")</td></tr>
<tr markdown="1"><td markdown="1">B</td><td markdown="1">[`bin` `binr`](bin.md "binary search")</td></tr>
<tr markdown="1"><td markdown="1">C</td><td markdown="1">[`ceiling`](ceiling.md "lowest integer above") [`cols`](cols.md#cols "column names of a table") [`cor`](cor.md "correlation") [`cos`](cos.md "cosine") [`count`](count.md "number of items") [`cov`](cov.md "covariance") [`cross`](cross.md "cross product") [`csv`](csv.md "comma delimiter") [`cut`](cut.md "cut array into pieces")</td></tr>
<tr markdown="1"><td markdown="1">D</td><td markdown="1">[`delete`](delete.md#delete-keyword "delete rows or columns from a table") [`deltas`](deltas.md "differences between consecutive pairs") [`desc`](desc.md "descending sort") [`dev`](dev.md "standard deviation") [`differ`](differ.md "flag differences in consecutive pairs") [`distinct`](distinct.md "unique items") [`div`](div.md "integer division") [`do`](do.md) [`dsave`](dsave.md "save global tables to disk")</td></tr>
<tr markdown="1"><td markdown="1">E</td><td markdown="1">[`each`](each.md "apply to each item") [`ej`](ej.md "equi-join") [`ema`](ema.md "exponentially-weighted moving average") [`enlist`](enlist.md "arguments as a list") [`eval`](eval.md "evaluate a parse tree") [`except`](except.md "left argument without items in right argument") [`exec`](exec.md) [`exit`](exit.md "terminate q") [`exp`](exp.md "power of e")</td></tr>
<tr markdown="1"><td markdown="1">F</td><td markdown="1">[`fby`](fby.md "filter-by") [`fills`](fill.md#fills "forward-fill nulls") [`first`](first.md "first item") [`fkeys`](fkeys.md "foreign-key columns mapped to their tables") [`flip`](flip.md "transpose") [`floor`](floor.md "greatest integer less than argument")</td></tr>
<tr markdown="1"><td markdown="1">G</td><td markdown="1">[`get`](get.md "get a q data file") [`getenv`](getenv.md "value of an environment variable") [`group`](group.md "dictionary of distinct items") [`gtime`](gtime.md "UTC timestamp")</td></tr>
<tr markdown="1"><td markdown="1">H</td><td markdown="1">[`hclose`](hopen.md#hclose "close a file or process") [`hcount`](hcount.md "size of a file") [`hdel`](hdel.md "delete a file") [`hopen`](hopen.md "open a file") [`hsym`](hsym.md "convert symbol to filename or IP address")</td></tr>
<tr markdown="1"><td markdown="1">I</td><td markdown="1">[`iasc`](asc.md#iasc "indices of ascending sort") [`idesc`](desc.md#idesc "indices of descending sort") [`if`](if.md) [`ij` `ijf`](ij.md "inner join") [`in`](in.md "membership") [`insert`](insert.md "append records to a table") [`inter`](inter.md "items common to both arguments") [`inv`](inv.md "matrix inverse")</td></tr>
<tr markdown="1"><td markdown="1">K</td><td markdown="1">[`key`](key.md "keys of a dictionary etc.") [`keys`](keys.md "names of a table's columns")</td></tr>
<tr markdown="1"><td markdown="1">L</td><td markdown="1">[`last`](first.md#last "last item") [`like`](like.md "pattern matching") [`lj` `ljf`](lj.md "left join") [`load`](load.md "load binary data") [`log`](log.md "natural logarithm") [`lower`](lower.md "lower case") [`lsq`](lsq.md "least squares – matrix divide") [`ltime`](gtime.md#ltime "local timestamp") [`ltrim`](trim.md#ltrim "function remove leading spaces")</td></tr>
<tr markdown="1"><td markdown="1">M</td><td markdown="1">[`mavg`](avg.md#mavg "moving average") [`max`](max.md "maximum") [`maxs`](max.md#maxs "maxima of preceding items") [`mcount`](count.md#mcount "moving count") [`md5`](md5.md "MD5 hash") [`mdev`](dev.md#mdev "moving deviation") [`med`](med.md "median") [`meta`](meta.md "metadata of a table") [`min`](min.md "minimum") [`mins`](min.md#mins "minimum of preceding items") [`mmax`](max.md#mmax "moving maxima") [`mmin`](min.md#mmin "moving minima") [`mmu`](mmu.md "matrix multiplication") [`mod`](mod.md "remainder") [`msum`](sum.md#msum "moving sum")</td></tr>
<tr markdown="1"><td markdown="1">N</td><td markdown="1">[`neg`](neg.md "negate") [`next`](next.md "next items") [`not`](not.md "logical not") [`null`](null.md "is argument a null")</td></tr>
<tr markdown="1"><td markdown="1">O</td><td markdown="1">[`or`](greater.md "greater") [`over`](over.md "reduce an array with a value")</td></tr>
<tr markdown="1"><td markdown="1">P</td><td markdown="1">[`parse`](parse.md "parse a string") [`peach`](each.md "parallel each") [`pj`](pj.md "plus join") [`prd` `prds`](prd.md "product, unning products") [`prev`](next.md#prev "previous items") [`prior`](prior.md "apply function between each item and its predecessor")</td></tr>
<tr markdown="1"><td markdown="1">R</td><td markdown="1">[`rand`](rand.md "random number") [`rank`](rank.md "grade up") [`ratios`](ratios.md "ratios of consecutive pairs") [`raze`](raze.md "join items") [`read0`](read0.md "read file as lines") [`read1`](read1.md "read file as bytes") [`reciprocal`](reciprocal.md "reciprocal of a number") [`reval`](eval.md#reval "variation of eval") [`reverse`](reverse.md "reverse the order of items") [`rload`](load.md#rload "load a splayed table") [`rotate`](rotate.md "rotate items") [`rsave`](save.md#rsave) [`rtrim`](trim.md#rtrim "remove trailing spaces")</td></tr>
<tr markdown="1"><td markdown="1">S</td><td markdown="1">[`save`](save.md "save global data to file") [`scan`](over.md "apply value to successive items") [`scov`](cov.md#scov "statistical covariance") [`sdev`](dev.md#sdev "statistical standard deviation") [`select`](select.md "select columns from a table") [`set`](get.md#set "assign a value to a name") [`setenv`](getenv.md#setenv "set an environment variable") [`show`](show.md "format to the console") [`signum`](signum.md "sign of its argument/s") [`sin`](sin.md "sine") [`sqrt`](sqrt.md "square root") [`ss`](ss.md "string search") [`ssr`](ss.md#ssr "string search and replace") [`string`](string.md "cast to string") [`sublist`](sublist.md "sublist of a list") [`sum`](sum.md "sum of a list") [`sums`](sum.md#sums "cumulative sums") [`sv`](sv.md "decode, consolidate") [`svar`](var.md#svar "statistical variance") [`system`](system.md "execute system command")</td></tr>
<tr markdown="1"><td markdown="1">T</td><td markdown="1">[`tables`](tables.md "sorted list of tables") [`tan`](tan.md "tangent") [`til`](til.md "integers up to x") [`trim`](trim.md "remove leading and trailing spaces") [`type`](type.md "data type")</td></tr>
<tr markdown="1"><td markdown="1">U</td><td markdown="1">[`uj` `ujf`](uj.md "union join") [`ungroup`](ungroup.md "flattened table") [`union`](union.md "distinct items of combination of two lists") [`update`](update.md "insert or replace table records") [`upper`](lower.md#upper "upper-case") [`upsert`](upsert.md "add table records")</td></tr>
<tr markdown="1"><td markdown="1">V</td><td markdown="1">[`value`](value.md "value of a variable or dictionary key; value of an executed sting") [`var`](var.md "variance") [`view`](view.md "definition of a dependency") [`views`](view.md#views "list of defined views") [`vs`](vs.md "encode, split")</td></tr>
<tr markdown="1"><td markdown="1">W</td><td markdown="1">[`wavg`](avg.md#wavg "weighted average") [`where`](where.md "replicated items") [`while`](while.md) [`within`](within.md "flag items within range") [`wj` `wj1`](wj.md "window join") [`wsum`](sum.md#wsum "weighted sum")</td></tr>
<tr markdown="1"><td markdown="1">X</td><td markdown="1">[`xasc`](asc.md#xasc "table sorted ascending by columns") [`xbar`](xbar.md "interval bar") [`xcol`](cols.md#xcol "rename table columns") [`xcols`](cols.md#xcols "re-order table columns") [`xdesc`](desc.md#xdesc "table sorted descending by columns") [`xexp`](exp.md#xexp "raised to a power") [`xgroup`](xgroup.md "table grouped by keys") [`xkey`](keys.md#xkey "set primary keys of a table") [`xlog`](log.md#xlog "base-x logarithm") [`xprev`](next.md#xprev "previous items") [`xrank`](xrank.md "items assigned to buckets")</td></tr>
</table>

:fontawesome-solid-book:
[`.Q.id`](dotq.md#qid-sanitize) (sanitize),
[`.Q.res`](dotq.md#qres-keywords) (reserved words)


## Operators

<table markdown="1">
<tr markdown="1">
<td markdown="1" class="kx-glyph">[`@`](overloads.md#at)<br>[`.`](overloads.md#dot)</td><td markdown="1">[Apply](apply.md)<br>[Index](apply.md#index)<br>[Trap](apply.md#trap)<br>[Amend](amend.md)</td>
<td markdown="1" class="kx-glyph">[`$`](overloads.md#dollar)</td><td markdown="1">[Cast](cast.md)<br>[Tok](tok.md)<br>[Enumerate](enumerate.md)<br>[Pad](pad.md)<br>[`mmu`](mmu.md)</td>
<td markdown="1" class="kx-glyph">[`!`](overloads.md#bang)</td><td markdown="1">[Dict](dict.md)<br>[Enkey](enkey.md)<br>[Unkey](enkey.md#unkey)<br>[Enumeration](enumeration.md)<br>[Flip Splayed](flip-splayed.md)<br>[Display](display.md)<br>[internal](../basics/internal.md)<br>[Update](../basics/funsql.md#update)<br>[Delete](../basics/funsql.md#delete)</td>
<td markdown="1" class="kx-glyph">[`?`](overloads.md#query)</td><td markdown="1">[Find](find.md)<br>[Roll, Deal](deal.md)<br>[Enum Extend](enum-extend.md)<br>[Select](../basics/funsql.md#select)<br>[Exec](../basics/funsql.md#exec)<br>[Simple Exec](../basics/funsql.md#simple-exec)<br>[Vector Conditional](vector-conditional.md)</td>
</tr>
<tr markdown="1">
<td markdown="1" class="kx-glyph">`+`</td><td markdown="1">[Add](add.md)</td>
<td markdown="1" class="kx-glyph">`-`</td><td markdown="1">[Subtract](subtract.md)</td>
<td markdown="1" class="kx-glyph">`*`</td><td markdown="1">[Multiply](multiply.md)</td>
<td markdown="1" class="kx-glyph">`%`</td><td markdown="1">[Divide](divide.md)</td>
</tr>
<tr markdown="1">
<td markdown="1" class="kx-glyph">`=`<br><code class="nowrap">&lt;&gt;</code></td><td markdown="1">[Equals](../basics/comparison/#six-comparison-operators)<br>[Not Equals](../basics/comparison/#six-comparison-operators)</td>
<td markdown="1" class="kx-glyph">`<`<br>`<=`</td><td markdown="1">[Less Than](../basics/comparison/#six-comparison-operators)<br>[Up To](../basics/comparison/#six-comparison-operators)</td>
<td markdown="1" class="kx-glyph">`>`<br>`>=`</td><td markdown="1">[Greater Than](../basics/comparison/#six-comparison-operators)<br>[At Least](../basics/comparison/#six-comparison-operators)</td>
<td markdown="1" class="kx-glyph">`~`</td><td markdown="1">[Match](../basics/comparison/#match)</td>
</tr>
<tr markdown="1">
<td markdown="1" class="kx-glyph">`|`</td> <td markdown="1">[Greater, OR](greater.md)</td>
<td markdown="1" class="kx-glyph">`&`</td> <td markdown="1" colspan="5">[Lesser, AND](lesser.md)</td>
</tr>
<tr markdown="1">
<td markdown="1" class="kx-glyph">[`#`](overloads.md#hash)</td><td markdown="1">[Take](take.md)<br>[Set&nbsp;Attribute](set-attribute.md)</td>
<td markdown="1" class="kx-glyph">[`_`](overloads.md#_-underscore)</td><td markdown="1">[Cut](cut.md)<br>[Drop](drop.md)</td>
<td markdown="1" class="kx-glyph">`^`</td><td markdown="1">[Fill](fill.md)<br>[Coalesce](coalesce.md)</td>
<td markdown="1" class="kx-glyph">`,`<br>[`'`](overloads.md#quote)</td><td markdown="1">[Join](join.md)<br>[Compose](compose.md)</td>
</tr>
</table>

:fontawesome-solid-book:
[Overloaded glyphs](overloads.md)


## [Iterators](iterators.md)

<div markdown="1" class="typewriter">
[maps](maps.md)                                                    [accumulators](accumulators.md)
[`'`](overloads.md#quote)   [Each](maps.md#each), [`each`](each.md), [Case](maps.md#case)       `/:`  [Each Right](maps.md#each-left-and-each-right)              [`/`](overloads.md#slash)  [Over](accumulators.md), [`over`](over.md)
[`':`](overloads.md#quote-colon)  [Each Parallel](maps.md#each-parallel), [`peach`](each.md#peach)   `\:`  [Each Left](maps.md#each-left-and-each-right)               [`\`](overloads/#backslash)  [Scan](accumulators.md), [`scan`](over.md)
[`':`](overloads.md#quote-colon)  [Each Prior](maps.md##each-prior), [`prior`](prior.md)
</div>

## [Execution control](../basics/control.md)

<div markdown="1" class="typewriter">
[.[f;x;e] Trap](../ref/apply.md#trap)          [: Return](../basics/function-notation.md#explicit-return)        [do](../ref/do.md)  [exit](../ref/exit.md)         [\$[x;y;z] Cond](../ref/cond.md)
[@[f;x;e] Trap-At](../ref/apply.md#trap)       [' Signal](../ref/signal.md)        [if](../ref/if.md)  [while](../ref/while.md)
</div>

:fontawesome-solid-book-open:
[Debugging](../basics/debug.md)



## Other

<div markdown="1" class="typewriter">
[`   pop stack](../basics/debug.md#debugging)        [:](overloads.md#colon)    [assign](../ref/assign.md)         [0      console](../basics/files.md)     [0:  File Text](file-text.md)
[.](overloads.md#dot)   [push stack](../basics/debug.md#debugging)       [::](overloads.md#colon-colon)   [identity](identity.md)       [1, -1  stdout](../basics/files.md)      [1:  File Binary](file-binary.md)
[\x  system cmd](../basics/syscmds.md)            [generic null](identity.md)   [2, -2  stderr](../basics/files.md)      [2:  Dynamic Load](dynamic-load.md)
[\\   abort](../basics/debug.md#abort)                 [global amend](../basics/function-notation.md#name-scope)   [_n, -n_  handle](../basics/files.md)
\\\\  quit q                [set view](../learn/views.md)

()     [precedence](../basics/syntax.md#precedence-and-order-of-evaluation)    \[;\]  [expn block](../basics/syntax.md#conditional-evaluation-and-control-statements)     {}  [lambda](../basics/function-notation.md)         \`   symbol
(;)    [list](../basics/syntax.md#list-notation)               [argt list](../basics/syntax.md#bracket-notation)      ;   separator      \`:  filepath
(\[\]..) [table](../basics/syntax.md#table-notation)
</div>



<!-- <td markdown="1" class="kx-glyph">`:`</td><td markdown="1">[Amend](amend.md)<br>[unary form](../basics/exposed-infrastructure.md#unary-forms)</td> -->

## [Attributes](../basics/syntax.md#attributes)

<div markdown="1" class="typewriter">
**g** grouped     **p**  parted     **s** sorted     **u** unique
</div>

:fontawesome-solid-book:
[Set Attribute](set-attribute.md)


## Command-line options and system commands

<table markdown="1" class="kx-shrunk kx-tight">
<tr markdown="1"><td markdown="1">[file](../basics/cmdline.md#file)</td></tr>
<tr markdown="1"><td markdown="1">[`\a`](../basics/syscmds.md#a-tables)</td><td markdown="1">tables</td><td markdown="1">[`\r`](../basics/syscmds.md#r-rename)</td><td markdown="1">rename</td></tr>
<tr markdown="1"><td markdown="1">[`-b`](../basics/cmdline.md#-b-blocked)</td><td markdown="1">blocked</td><td markdown="1">[`-s`](../basics/cmdline.md#-s-secondary-processes) [`\s`](../basics/syscmds.md#s-number-of-secondary-processes)</td><td markdown="1">secondary processes</td></tr>
<tr markdown="1"><td markdown="1">[`\b`](../basics/syscmds.md#b-views) [`\B`](../basics/syscmds.md#b-pending-views)</td><td markdown="1">views</td><td markdown="1">[`\S`](../basics/syscmds.md#s-random-seed)</td><td markdown="1">random seed</td></tr>
<tr markdown="1"><td markdown="1">[`-c`](../basics/cmdline.md#-c-console-size) [`\c`](../basics/syscmds.md#c-console-size)</td><td markdown="1">console size</td><td markdown="1">[`-t`](../basics/cmdline.md#-t-timer-ticks) [`\t`](../basics/syscmds.md#t-timer)</td><td markdown="1">timer ticks</td></tr>
<tr markdown="1"><td markdown="1">[`-C`](../basics/cmdline.md#-c-http-size) [`\C`](../basics/syscmds.md#c-http-size)</td><td markdown="1">HTTP size</td><td markdown="1">[`\ts`](../basics/syscmds.md#ts-time-and-space)</td><td markdown="1">time and space</td></tr>
<tr markdown="1"><td markdown="1">[`\cd`](../basics/syscmds.md#cd-change-directory)</td><td markdown="1">change directory</td><td markdown="1">[`-T`](../basics/cmdline.md#-t-timeout) [`\T`](../basics/syscmds.md#t-timeout)</td><td markdown="1">timeout</td></tr>
<tr markdown="1"><td markdown="1">[`\d`](../basics/syscmds.md#d-directory)</td><td markdown="1">directory</td><td markdown="1">[`-u`](../basics/cmdline.md#-u-usr-pwd-local) [`-U`](../basics/cmdline.md#-u-usr-pwd) [`\u`](../basics/syscmds.md#u-reload-user-password-file)</td><td markdown="1">usr-pwd</td></tr>
<tr markdown="1"><td markdown="1">[`-e`](../basics/cmdline.md#-e-error-traps) [`\e`](../basics/syscmds.md#e-error-trap-clients)</td><td markdown="1">error traps</td><td markdown="1">[`-u`](../basics/cmdline.md#-u-disable-syscmds)</td><td markdown="1">disable syscmds</td></tr>
<tr markdown="1"><td markdown="1">[`-E`](../basics/cmdline.md#-e-tls-server-mode) [`\E`](../basics/syscmds.md#e-tls-server-mode)</td><td markdown="1">TLS server mode</td><td markdown="1">[`\v`](../basics/syscmds.md#v-variables)</td><td markdown="1">variables</td></tr>
<tr markdown="1"><td markdown="1">[`\f`](../basics/syscmds.md#f-functions)</td><td markdown="1">functions</td><td markdown="1">[`-w`](../basics/cmdline.md#-w-workspace) [`\w`](../basics/syscmds.md#w-workspace)</td><td markdown="1">memory</td></tr>
<tr markdown="1"><td markdown="1">[`-g`](../basics/cmdline.md#-g-garbage-collection) [`\g`](../basics/syscmds.md#g-garbage-collection-mode)</td><td markdown="1">garbage collection</td><td markdown="1">[`-W`](../basics/cmdline.md#-w-start-week) [`\W`](../basics/syscmds.md#w-week-offset)</td><td markdown="1">week offset</td></tr>
<tr markdown="1"><td markdown="1">[`\l`](../basics/syscmds.md#l-load-file-or-directory)</td><td markdown="1">load file or directory</td><td markdown="1">[`\x`](../basics/syscmds.md#x-expunge)</td><td markdown="1">expunge</td></tr>
<tr markdown="1"><td markdown="1">[`-l`](../basics/cmdline.md#-l-log-updates) [`-L`](../basics/cmdline.md#-l-log-sync)</td><td markdown="1">log sync</td><td markdown="1">[`-z`](../basics/cmdline.md#-z-date-format) [`\z`](../basics/syscmds.md#z-date-parsing)</td><td markdown="1">date format</td></tr>
<tr markdown="1"><td markdown="1">[`-o`](../basics/cmdline.md#-o-utc-offset) [`\o`](../basics/syscmds.md#o-offset-from-utc)</td><td markdown="1">UTC offset</td><td markdown="1">[`\1` `\2`](../basics/syscmds.md#1-2-redirect)</td><td markdown="1">redirect</td></tr>
<tr markdown="1"><td markdown="1">[`-p`](../basics/cmdline.md#-p-listening-port) [`\p`](../basics/syscmds.md#p-listening-port)</td><td markdown="1">listening port</td><td markdown="1">[`\_`](../basics/syscmds.md#_-hide-q-code)</td><td markdown="1">hide q code</td></tr>
<tr markdown="1"><td markdown="1">[`-P`](../basics/cmdline.md#-p-display-precision) [`\P`](../basics/syscmds.md#p-precision)</td><td markdown="1">display precision</td><td markdown="1">[`\`](../basics/syscmds.md#terminate)</td><td markdown="1">terminate</td></tr>
<tr markdown="1"><td markdown="1">[`-q`](../basics/cmdline.md#-q-quiet-mode)</td><td markdown="1">quiet mode</td><td markdown="1">[`\`](../basics/syscmds.md#toggle-qk)</td><td markdown="1">toggle q/k</td></tr>
<tr markdown="1"><td markdown="1">[`-r`](../basics/cmdline.md#-r-replicate) [`\r`](../basics/syscmds.md#r-replication-master)</td><td markdown="1">replicate</td><td markdown="1">[`\\`](../basics/syscmds.md#quit)</td><td markdown="1">quit</td></tr>
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
<thead><tr markdown="1"><th>var</th><th>default</th><th>use</th></tr></thead>
<tbody>
<tr markdown="1"><td markdown="1"><code>QHOME</code></td><td markdown="1"><code>$HOME/q</code></td><td markdown="1">folder searched for q.k and unqualified script names</td></tr>
<tr markdown="1"><td markdown="1"><code>QLIC</code></td><td markdown="1"><code>$HOME</code></td><td markdown="1">folder searched for k4.lic license file</td></tr>
<tr markdown="1"><td markdown="1"><code>QINIT</code></td><td markdown="1"><code>q.q</code></td><td markdown="1">additional file loaded after q.k has initialised</td></tr>
<tr markdown="1"><td markdown="1"><code>LINES</code></td><td markdown="1"/><td markdown="1">supplied by OS, used to set <code>\c</code></td></tr>
<tr markdown="1"><td markdown="1"><code>COLUMNS</code></td><td markdown="1"/><td markdown="1"><code>\c $LINES $COLUMNS</code></td></tr>
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
<pre class="language-txt" style="font-size:80%">
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
11  s   symbol        \`                  \`        varchar   String    string
12  p   timestamp 8   dateDtimespan      0Np  0Wp           Timestamp DateTime (RW)
13  m   month     4   2000.01m           0Nm
14  d   date      4   2000.01.01         0Nd  0Wd date      Date
15  z   datetime  8   dateTtime          0Nz  0wz timestamp Timestamp DateTime (RO)
16  n   timespan  8   00:00:00.000000000 0Nn  0Wn           Timespan  TimeSpan
17  u   minute    4   00:00              0Nu  0Wu
18  v   second    4   00:00:00           0Nv  0Nv
19  t   time      4   00:00:00.000       0Nt  0Wt time      Time      TimeSpan
</pre>

<div markdown="1" class="typewriter">
20-76   enums
77      anymap
78-96   77+t – mapped list of lists of type t
97      nested sym enum
98      table
99      dictionary
100     [lambda](../basics/function-notation.md)
101     unary primitive
102     operator
103     [iterator](../ref/iterators.md)
104     [projection](../basics/application.md#projection)
105     [composition](../ref/compose.md)
106     [f'](../ref/maps.md#each)
107     [f/](../ref/accumulators.md)
108     [f\\](../ref/accumulators.md)
109     [f':](../ref/maps.md)
110     [f/:](../ref/maps.md#each-left-and-each-right)
111     [f\\:](../ref/maps.md#each-left-and-each-right)
112     [dynamic load](../ref/dynamic-load.md)
</div>

_n_: short int returned by [`type`](type.md) and used for [Cast](cast.md), e.g. `9h$3`
<br>
_c_: character used lower-case for [Cast](cast.md) and upper-case for [Load CSV](file-text.md#load-csv)
<br>
_sz_: size in bytes
<br>
_inf_: infinity (no math on temporal types); `0Wh` is `32767h`
<br>
`v`: applicable value
<br>
RO: read only; RW: read-write


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

### `.h`

Markup output for HTTP

<div markdown="1" class="typewriter">
[.h.br](doth.md#hbr-linebreak)      linebreak                [.h.cd](doth.md#hcd-csv-from-data)      CSV from data
[.h.code](doth.md#hcode-code-after-tab)    code after Tab           [.h.d](doth.md#hd-delimiter)       delimiter
[.h.fram](doth.md#hfram-frame)    frame                    [.h.ed](doth.md#hed-excel-from-data)      Excel from data
[.h.ha](doth.md#hha-anchor)      anchor                   [.h.edsn](doth.md#hedsn-excel-from-tables)    Excel from tables
[.h.hb](doth.md#hhb-anchor-target)      anchor target            [.h.hc](doth.md#hhc-escape-lt)      escape lt
[.h.ht](doth.md#hht-marqdown-to-html)      Marqdown to HTML         [.h.hr](doth.md#hhr-horizontal-rule)      horizontal rule
[.h.hta](doth.md#hhta-start-tag)     start tag                [.h.iso8601](doth.md#hiso8601-iso-timestamp) ISO timestamp
[.h.htac](doth.md#hhtac-element)    element                  [.h.jx](doth.md#hjx-table)      table
[.h.htc](doth.md#hhtc-element)     element                  [.h.td](doth.md#htd-tsv-from-data)      TSV from data
[.h.html](doth.md#hhtml-document)    document                 [.h.tx](doth.md#htx-filetypes)      filetypes
[.h.http](doth.md#hhttp-hyperlinks)    hyperlinks               [.h.xd](doth.md#hxd-xml)      XML
[.h.nbr](doth.md#hnbr-no-break)     no break                 [.h.xs](doth.md#hxs-xml-escape)      XML escape
[.h.pre](doth.md#hpre-pre)     pre                      [.h.xt](doth.md#hxt-json)      JSON
[.h.text](doth.md#htext-paragraphs)    paragraphs
[.h.xmp](doth.md#hxmp-xmp)     XMP

[.h.he](doth.md#hhe-http-400)      HTTP 400                 [.h.c0](doth.md#hc0-web-color)    web color
[.h.hn](doth.md#hhn-http-response)      HTTP response            [.h.c1](doth.md#hc1-web-color)    web color
[.h.hp](doth.md#hhp-http-response-pre)      HTTP response pre        [.h.HOME](doth.md#hhome-webserver-root)  webserver root
[.h.hy](doth.md#hhy-http-response-content)      HTTP response content    [.h.logo](doth.md#hlogo-kx-logo)  KX logo
                                    [.h.sa](doth.md#hsa-anchor-style)    anchor style
[.h.hu](doth.md#hhu-uri-escape)      URI escape               [.h.sb](doth.md#hsb-body-style)    body style
[.h.hug](doth.md#hhug-uri-map)     URI map                  [.h.ty](doth.md#hty-mime-types)    MIME types
[.h.sc](doth.md#hsc-uri-safe)      URI-safe                 [.h.val](doth.md#hval-value)   value
[.h.uh](doth.md#huh-uri-unescape)      URI unescape
</div>


### `.j`

De/serialize as JSON

<div markdown="1" class="typewriter">
[.j.j   serialize](dotj.md#jj-serialize)                [.j.k   deserialize](dotj.md#jk-deserialize)
[.j.jd  serialize infinity](dotj.md#jjd-serialize-infinity)
</div>


### `.m`

:fontawesome-regular-hand-point-right:
[Memory backed by files](dotm.md)


### `.Q`

Utilities: general, environment, IPC, datatype, database, partitioned database state, segmented database state, file I/O

<div markdown="1" class="typewriter">
General                           Datatype
 [addmonths](dotq.md#qaddmonths)                         [btoa   b64 encode](dotq.md#qbtoa-b64-encode)
 [bt       backtrace](dotq.md#qbt-backtrace)                [j10    encode binhex](dotq.md#qj10-encode-binhex)
 [dd       join symbols](dotq.md#qdd-join-symbols)             [j12    encode base 36](dotq.md#qj12-encode-base-36)
 [def](dotq.md#qdef)                               [M      long infinity](dotq.md#qm-long-infinity)
 [f        format](dotq.md#qf-format)                   [ty     type](dotq.md#qty-type)
 [ff       append columns](dotq.md#qff-append-columns)           [x10    decode binhex](dotq.md#qx10-decode-binhex)
 [fmt      format](dotq.md#qfmt-format)                   [x12    decode base 36](dotq.md#qx12-decode-base-36)
 [ft       apply simple](dotq.md#qft-apply-simple)
 [fu       apply unique](dotq.md#qfu-apply-unique)            Database
 [gc       garbage collect](dotq.md#qgc-garbage-collect)          [chk    fill HDB](dotq.md#qchk-fill-hdb)
 [gz       GZip](dotq.md#qgz-gzip)                     [dpft   save table](dotq.md#qdpft-save-table)
 [id       sanitize](dotq.md#qid-sanitize)                 [dpfts  save table with sym](dotq.md#qdpfts-save-table-with-symtable)
 [qt       is table](dotq.md#qqt-is-table)                 [dsftg  load process save](dotq.md#qdsftg-load-process-save)
 [res      keywords](dotq.md#qres-keywords)                 [en     enumerate varchar cols](dotq.md#qen-enumerate-varchar-cols)
 [s        plain text](dotq.md#qs-plain-text)               [ens    enumerate against domain](dotq.md#qens-enumerate-against-domain)
 [s1       string representation](dotq.md#qs1-string-representation)    [fk     foreign key](dotq.md#qfk-foreign-key)
 [sbt      string backtrace](dotq.md#qsbt-string-backtrace)         [hdpf   save tables](dotq.md#qhdpf-save-tables)
 [trp      extend trap](dotq.md#qtrp-extend-trap)              [qt     is table](dotq.md#qqt-is-table)
 [ts       time and space](dotq.md#qts-time-and-space)           [qp     is partitioned](dotq.md#qqp-is-partitioned)
 [u        date based](dotq.md#qu-date-based)
 [V        table to dict](dotq.md#qv-table-to-dict)
 [v        value](dotq.md#qv-value)                   Partitioned database state
 [view     subview](dotq.md#qview-subview)                  [bv     build vp](dotq.md#qbv-build-vp)
                                   [ind    partitioned index](dotq.md#qind-partitioned-index)
Constants                          [cn     count partitioned table](dotq.md#qcn-count-partitioned-table)
 [A        uppercase alphabet](dotq.md#qa-upper-case-alphabet)       [MAP    maps partitions](dotq.md#qmap-maps-partitions)
 [a        lowercase alphabet](dotq.md#qa-lower-case-alphabet)       [D      partitions](dotq.md#qd-partitions)
 [b6       bicameral alphanums](dotq.md#qb6-bicameral-alphanums)      [par    locate partition](dotq.md#qpar-locate-partition)
 [nA       alphanums](dotq.md#qna-alphanums)                [PD     partition locations](dotq.md#qpd-partition-locations)
                                   [pd     modified partition locns](dotq.md#qpd-modified-partition-locations)
Environment                        [pf     partition field](dotq.md#qpf-partition-field)
 [k        version](dotq.md#qk-version)                  [pn     partition counts](dotq.md#qpn-partition-counts)
 [opt      command parameters](dotq.md#qopt-command-parameters)       [qp     is partitioned](dotq.md#qqp-is-partitioned)
 [w        memory stats](dotq.md#qw-memory-stats)             [pt     partitioned tables](dotq.md#qpt-partitioned-tables)
 [x        non-command parameters](dotq.md#qx-non-command-parameters)   [PV     partition values](dotq.md#qpv-partition-values)
                                   [pv     modified partition values](dotq.md#qpv-modified-partition-values)
IPC                                [vp     missing partitions](dotq.md#qvp-missing-partitions)
 [addr     IP address](dotq.md#qaddr-ip-address)
 [fps fpn  streaming algorithm](dotq.md#qfps-streaming-algorithm)     Segmented database state
 [fs  fsn  streaming algorithm](dotq.md#qfsn-streaming-algorithm)      [D      partitions](dotq.md#qd-partitions)
 [hg       HTTP get](dotq.md#qhg-http-get)                 [P      segments](dotq.md#qp-segments)
 [host     hostname](dotq.md#qhost-hostname)                 [u      date based](dotq.md#qu-date-based)
 [hp       HTTP post](dotq.md#qhp-http-post)
 [l        load](dotq.md#ql-load)

 File I/O
 [Cf       create empty nested char file](dotq.md#qcf-create-empty-nested-char-file)
 [Xf       create file](dotq.md#qxf-create-file)
</div>


### `.z`

System variables, callbacks

<div markdown="1" class="typewriter">
System information                 Callbacks
[.z.a    IP address](dotz.md#za-ip-address)                 [.z.ac    HTTP auth from cookie](dotz.md#zac-http-auth-from-cookie)
[.z.b    dependencies](dotz.md#zb-dependencies)               [.z.bm    msg validator](dotz.md#zbm-msg-validator)
[.z.c    cores](dotz.md#zc-cores)                      [.z.exit  action on exit](dotz.md#zexit-action-on-exit)
[.z.D/d  date shortcuts](dotz.md#zt-zt-zd-zd-timedate-shortcuts)             [.z.pc    close](dotz.md#zpc-close)
[.z.e    TLS connection status](dotz.md#ze-tls-connection-status)      [.z.pd    peach handles](dotz.md#zpd-peach-handles)
[.z.ex   failed primitive](dotz.md#zex-failed-primitive)           [.z.pg    get](dotz.md#zpg-get)
[.z.ey   arg to failed primitive](dotz.md#zey-argument-to-failed-primitive)    [.z.ph    HTTP get](dotz.md#zph-http-get)
[.z.f    file](dotz.md#zf-file)                       [.z.pi    input](dotz.md#zpi-input)
[.z.h    host](dotz.md#zh-host)                       [.z.po    open](dotz.md#zpo-open)
[.z.i    PID](dotz.md#zi-pid)                        [.z.pp    HTTP post](dotz.md#zpp-http-post)
[.z.K    version](dotz.md#zk-version)                    [.z.pq    qcon](dotz.md#zpq-qcon)
[.z.k    release date](dotz.md#zk-release-date)               [.z.ps    set](dotz.md#zps-set)
[.z.l    license](dotz.md#zl-license)                    [.z.pw    validate user](dotz.md#zpw-validate-user)
[.z.N/n  local/UTC timespan](dotz.md#zn-local-timespan)         [.z.ts    timer](dotz.md#zts-timer)
[.z.o    OS version](dotz.md#zo-os-version)                 [.z.vs    value set](dotz.md#zvs-value-set)
[.z.P/p  local/UTC timestamp](dotz.md#zp-local-timestamp)        [.z.wc    WebSocket close](dotz.md#zwc-websocket-close)
[.z.pm   HTTP options](dotz.md#zpm-http-options)               [.z.wo    WebSocket open](dotz.md#zwo-websocket-open)
[.z.q    quiet mode](dotz.md#zq-quiet-mode)                 [.z.ws    WebSockets](dotz.md#zws-websockets)
[.z.s    self](dotz.md#zs-self)
[.z.T/t  time shortcuts](dotz.md#zt-zt-zd-zd-timedate-shortcuts)
[.z.u    user ID](dotz.md#zu-user-id)
[.z.W/w  handles/handle](dotz.md#zw-handles)
[.z.X/x  raw/parsed command line](dotz.md#zx-raw-command-line)
[.z.Z/z  local/UTC datetime](dotz.md#zz-local-datetime)
[.z.zd   zip defaults](dotz.md#zzd-zip-defaults)
</div>
