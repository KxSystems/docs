---
title: Reference card - code.kx.com
description: Quick reference for kdb+ and the q programming language
author: Stephen Taylor
keywords: card, index, kdb+, keywords, operators, q, reference
---

# Reference card




## Keywords

<table class="kx-shrunk kx-tight" markdown="1">
<tr><td>A</td><td>[`abs`](abs.md "absolute value") [`acos`](cos.md#acos "arccosine") [`aj` `aj0`](aj.md "as-of join") [`all`](all-any.md#all "all nonzero") [`and`](lesser.md "lesser") [`any`](all-any.md#any "any item is non-zero") [`asc`](asc.md "ascending sort") [`asin`](sin.md#asin "arcsine") [`asof`](asof.md "as-of join") [`atan`](tan.md#atan "arctangent") [`attr`](attr.md "attributes") [`avg`](avg.md#avg "arithmetic mean") [`avgs`](avg.md#avgs "running averages")</td></tr>
<tr><td>B</td><td>[`bin` `binr`](bin.md "binary search")</td></tr>
<tr><td>C</td><td>[`ceiling`](ceiling.md "lowest integer above") [`cols`](cols.md#cols "column names of a table") [`cor`](cor.md "correlation") [`cos`](cos.md "cosine") [`count`](count.md "number of items") [`cov`](cov.md "covariance") [`cross`](cross.md "cross product") [`csv`](csv.md "comma delimiter") [`cut`](cut.md "cut array into pieces")</td></tr>
<tr><td>D</td><td>[`delete`](delete.md#delete-keyword "delete rows or columns from a table") [`deltas`](deltas.md "differences between consecutive pairs") [`desc`](desc.md "descending sort") [`dev`](dev.md "standard deviation") [`differ`](differ.md "flag differences in consecutive pairs") [`distinct`](distinct.md "unique items") [`div`](div.md "integer division") [`do`](do.md) [`dsave`](dsave.md "save global tables to disk")</td></tr>
<tr><td>E</td><td>[`each`](each.md "apply to each item") [`ej`](ej.md "equi-join") [`ema`](ema.md "exponentially-weighted moving average") [`enlist`](enlist.md "arguments as a list") [`eval`](eval.md "evaluate a parse tree") [`except`](except.md "left argument without items in right argument") [`exec`](exec.md) [`exit`](exit.md "terminate q") [`exp`](exp.md "power of e")</td></tr>
<tr><td>F</td><td>[`fby`](fby.md "filter-by") [`fills`](fill.md#fills "forward-fill nulls") [`first`](first.md "first item") [`fkeys`](fkeys.md "foreign-key columns mapped to their tables") [`flip`](flip.md "transpose") [`floor`](floor.md "greatest integer less than argument")</td></tr>
<tr><td>G</td><td>[`get`](get.md "get a q data file") [`getenv`](getenv.md "value of an environment variable") [`group`](group.md "dictionary of distinct items") [`gtime`](gtime.md "UTC timestamp")</td></tr>
<tr><td>H</td><td>[`hclose`](handles.md#hclose "close a file or process") [`hcount`](handles.md#hcount "size of a file") [`hdel`](handles.md#hdel "delete a file") [`hopen`](handles.md#hopen "open a file") [`hsym`](handles.md#hsym "convert symbol to filename or IP address")</td></tr>
<tr><td>I</td><td>[`iasc`](asc.md#iasc "indices of ascending sort") [`idesc`](desc.md#idesc "indices of descending sort") [`if`](if.md) [`ij` `ijf`](ij.md "inner join") [`in`](in.md "membership") [`insert`](insert.md "append records to a table") [`inter`](inter.md "items common to both arguments") [`inv`](inv.md "matrix inverse")</td></tr>
<tr><td>K</td><td>[`key`](key.md "keys of a dictionary etc.") [`keys`](keys.md "names of a table's columns")</td></tr>
<tr><td>L</td><td>[`last`](first.md#last "last item") [`like`](like.md "pattern matching") [`lj` `ljf`](lj.md "left join") [`load`](load.md "load binary data") [`log`](log.md "natural logarithm") [`lower`](lower.md "lower case") [`lsq`](lsq.md "least squares – matrix divide") [`ltime`](gtime.md#ltime "local timestamp") [`ltrim`](trim.md#ltrim "function remove leading spaces")</td></tr>
<tr><td>M</td><td>[`mavg`](avg.md#mavg "moving average") [`max`](max.md "maximum") [`maxs`](max.md#maxs "maxima of preceding items") [`mcount`](count.md#mcount "moving count") [`md5`](md5.md "MD5 hash") [`mdev`](dev.md#mdev "moving deviation") [`med`](med.md "median") [`meta`](meta.md "metadata of a table") [`min`](min.md "minimum") [`mins`](min.md#mins "minimum of preceding items") [`mmax`](max.md#mmax "moving maxima") [`mmin`](min.md#mmin "moving minima") [`mmu`](mmu.md "matrix multiplication") [`mod`](mod.md "remainder") [`msum`](sum.md#msum "moving sum")</td></tr>
<tr><td>N</td><td>[`neg`](neg.md "negate") [`next`](next.md "next items") [`not`](not.md "logical not") [`null`](null.md "is argument a null")</td></tr>
<tr><td>O</td><td>[`or`](greater.md "greater") [`over`](over.md "reduce an array with a value")</td></tr>
<tr><td>P</td><td>[`parse`](parse.md "parse a string") [`peach`](each.md "parallel each") [`pj`](pj.md "plus join") [`prd` `prds`](prd.md "product, unning products") [`prev`](next.md#prev "previous items") [`prior`](prior.md "apply function between each item and its predecessor")</td></tr>
<tr><td>R</td><td>[`rand`](rand.md "random number") [`rank`](rank.md "grade up") [`ratios`](ratios.md "ratios of consecutive pairs") [`raze`](raze.md "join items") [`read0`](read0.md "read file as lines") [`read1`](read1.md "read file as bytes") [`reciprocal`](reciprocal.md "reciprocal of a number") [`reval`](eval.md#reval "variation of eval") [`reverse`](reverse.md "reverse the order of items") [`rload`](load.md#rload "load a splayed table") [`rotate`](rotate.md "rotate items") [`rsave`](save.md#rsave) [`rtrim`](trim.md#rtrim "remove trailing spaces")</td></tr>
<tr><td>S</td><td>[`save`](save.md "save global data to file") [`scan`](over.md "apply value to successive items") [`scov`](cov.md#scov "statistical covariance") [`sdev`](dev.md#sdev "statistical standard deviation") [`select`](select.md "select columns from a table") [`set`](get.md#set "assign a value to a name") [`setenv`](getenv.md#setenv "set an environment variable") [`show`](show.md "format to the console") [`signum`](signum.md "sign of its argument/s") [`sin`](sin.md "sine") [`sqrt`](sqrt.md "square root") [`ss`](ss.md "string search") [`ssr`](ss.md#ssr "string search and replace") [`string`](string.md "cast to string") [`sublist`](sublist.md "sublist of a list") [`sum`](sum.md "sum of a list") [`sums`](sum.md#sums "cumulative sums") [`sv`](sv.md "decode, consolidate") [`svar`](var.md#svar "statistical variance") [`system`](system.md "execute system command")</td></tr>
<tr><td>T</td><td>[`tables`](tables.md "sorted list of tables") [`tan`](tan.md "tangent") [`til`](til.md "integers up to x") [`trim`](trim.md "remove leading and trailing spaces") [`type`](type.md "data type")</td></tr>
<tr><td>U</td><td>[`uj` `ujf`](uj.md "union join") [`ungroup`](ungroup.md "flattened table") [`union`](union.md "distinct items of combination of two lists") [`update`](update.md "insert or replace table records") [`upper`](lower.md#upper "upper-case") [`upsert`](upsert.md "add table records")</td></tr>
<tr><td>V</td><td>[`value`](value.md "value of a variable or dictionary key; value of an executed sting") [`var`](var.md "variance") [`view`](view.md "definition of a dependency") [`views`](view.md#views "list of defined views") [`vs`](vs.md "encode, split")</td></tr>
<tr><td>W</td><td>[`wavg`](avg.md#wavg "weighted average") [`where`](where.md "replicated items") [`while`](while.md) [`within`](within.md "flag items within range") [`wj` `wj1`](wj.md "window join") [`wsum`](sum.md#wsum "weighted sum")</td></tr>
<tr><td>X</td><td>[`xasc`](asc.md#xasc "table sorted ascending by columns") [`xbar`](xbar.md "interval bar") [`xcol`](cols.md#xcol "rename table columns") [`xcols`](cols.md#xcols "re-order table columns") [`xdesc`](desc.md#xdesc "table sorted descending by columns") [`xexp`](exp.md#xexp "raised to a power") [`xgroup`](xgroup.md "table grouped by keys") [`xkey`](keys.md#xkey "set primary keys of a table") [`xlog`](log.md#xlog "base-x logarithm") [`xprev`](next.md#xprev "previous items") [`xrank`](xrank.md "items assigned to buckets")</td></tr>
</table>

<i class="far fa-hand-point-right"></i>
[`.Q.id`](dotq.md#qid-sanitize) (sanitize),
[`.Q.res`](dotq.md#qres-keywords) (reserved words)


## Operators

<table markdown="1">
<tr>
<td class="kx-glyph">[`@`](overloads.md#at)<br>[`.`](overloads.md#dot)</td><td>[Apply](apply.md)<br>[Index](apply.md#index)<br>[Trap](apply.md#trap)<br>[Amend](amend.md)</td>
<td class="kx-glyph">[`$`](overloads.md#dollar)</td><td>[Cond](cond.md)<br>[Cast](cast.md)<br>[Tok](tok.md)<br>[Enumerate](enumerate.md)<br>[Pad](pad.md)<br>[`mmu`](mmu.md)</td>
<td class="kx-glyph">[`!`](overloads.md#bang)</td><td>[Dict](dict.md)<br>[Enkey](enkey.md)<br>[Unkey](enkey.md#unkey)<br>[Enumeration](enumeration.md)<br>[Flip Splayed](flip-splayed.md)<br>[Display](display.md)<br>[internal](../basics/internal.md)<br>[Update](../basics/funsql.md#update)<br>[Delete](../basics/funsql.md#delete)</td>
<td class="kx-glyph">[`?`](overloads.md#query)</td><td>[Find](find.md)<br>[Roll, Deal](deal.md)<br>[Enum Extend](enum-extend.md)<br>[Select](../basics/funsql.md#select)<br>[Exec](../basics/funsql.md#exec)<br>[Simple Exec](../basics/funsql.md#simple-exec)<br>[Vector Conditional](vector-conditional.md)</td>
</tr>
<td class="kx-glyph">`+`</td><td>[Add](add.md)</td>
<td class="kx-glyph">`-`</td><td>[Subtract](subtract.md)</td>
<td class="kx-glyph">`*`</td><td>[Multiply](multiply.md)</td>
<td class="kx-glyph">`%`</td><td>[Divide](divide.md)</td>
</tr>
<tr>
<td class="kx-glyph">`=`<br><code class="nowrap">&lt;&gt;</code></td><td>[Equals](../basics/comparison/#six-comparison-operators)<br>[Not Equals](../basics/comparison/#six-comparison-operators)</td>
<td class="kx-glyph">`<`<br>`<=`</td><td>[Less Than](../basics/comparison/#six-comparison-operators)<br>[Up To](../basics/comparison/#six-comparison-operators)</td>
<td class="kx-glyph">`>`<br>`>=`</td><td>[Greater Than](../basics/comparison/#six-comparison-operators)<br>[At Least](../basics/comparison/#six-comparison-operators)</td>
<td class="kx-glyph">`~`</td><td>[Match](../basics/comparison/#match)</td>
</tr>
<tr>
<td class="kx-glyph">`|`</td> <td>[Greater, OR](greater.md)</td>
<td class="kx-glyph">`&`</td> <td>[Lesser, AND](lesser.md)</td>
</tr>
<tr>
<td class="kx-glyph">[`#`](overloads.md#hash)</td><td>[Take](take.md)<br>[Set&nbsp;Attribute](set-attribute.md)</td>
<td class="kx-glyph">[`_`](overloads.md#_-underscore)</td><td>[Cut](cut.md)<br>[Drop](drop.md)</td>
<td class="kx-glyph">`^`</td><td>[Fill](fill.md)</td>
<td class="kx-glyph">`,`</td><td>[Join](join.md)</td>
</tr>
</table>

<i class="far fa-hand-point-right"></i>
[Overloaded operator glyphs](overloads.md)


## [Iterators](iterators.md)

<table markdown="1">
<thead>
<tr><th colspan="2">accumulators</th><th colspan="2">maps</th><th colspan="2">maps</th><th colspan="2"/></tr>
</thead>
<tbody>
<tr>
<td class="kx-glyph">[`/`](overloads.md#slash)<br>[`\`](overloads/#backslash)</td><td>[Over<br>Scan](accumulators.md)</td>
<td class="kx-glyph">`/:`<br>`\:`</td><td>[Each Right<br>Each Left](maps.md#each-left-and-each-right)</td>
<td class="kx-glyph">[`'`](overloads.md#quote)<br>[`':`](overloads.md#quote-colon)<br>[`':`](overloads.md#quote-colon)</td><td>[Each](maps.md#each)<br>[Each&nbsp;Parallel](maps.md#each-parallel)<br>[Each Prior](maps.md##each-prior)</td>
<td class="kx-glyph">[`'`](overloads.md#quote)<br>[`'`](overloads.md#quote)</td><td>[Case](maps.md#case)<br>[Compose](compose.md)</td>
</tr>
</tbody>
</table>



## Other

<table markdown="1">
<tr>
<td class="kx-glyph nowrap">`\\`<br>`\`<br>`\x`<br>[`'`](overloads.md#quote)</td><td>quit<br>[abort](../basics/debug.md#abort)<br>[system cmd](../basics/syscmds.md)<br>[Signal](signal.md)</td>
<td class="kx-glyph">`:`<br><code class="nowrap">::</code></td><td>[assign](../basics/syntax.md#colon), [return](../basics/control.md#explicit-return)<br>[identity<br>generic null](identity.md)<br>global amend<br>set view</td>
<td class="kx-glyph">`0`<br><span class="nowrap">`1`, `-1`</span><br>`2`, `-2`<br>_n_, _-n_</td><td>[console<br>stdout<br>stderr<br>handle](../basics/files.md)</td>
<td class="kx-glyph"><span class="nowrap">`0:`</span><br>`1:`<br>`2:`</td><td>[File Text](file-text.md)<br>[File Binary](file-binary.md)<br>[Dynamic&nbsp;Load](dynamic-load.md)</td>
</tr>
<tr>
<td class="kx-glyph nowrap">`()`<br>`(;)`<br>`([]…)`</td><td>[precedence](../basics/syntax.md#precedence-and-order-of-evaluation)<br>[list](../basics/syntax.md#list-notation)<br>[table](../basics/syntax.md#table-notation)</td>
<td class="kx-glyph nowrap">`[;]`</td><td>[expn block](../basics/syntax.md#conditional-evaluation-and-control-statements)<br>[argt list](../basics/syntax.md#bracket-notation)</td>
<td class="kx-glyph">`{}`<br>`;`</td><td>[lambda](../basics/function-notation.md)<br>separator</td>
<td class="kx-glyph"><code>&#96;</code><br><code>&#96;:</code></td><td>symbol<br>filepath</td>
</tr>
</table>

<!-- <td class="kx-glyph">`:`</td><td>[Amend](amend.md)<br>[unary form](../basics/exposed-infrastructure.md#unary-forms)</td> -->

## [Attributes](../basics/syntax.md#attributes)

```txt
`s  sorted     `u  unique
`p  parted     `g  grouped
```


## Command-line options and system commands

<table markdown="1" class="kx-shrunk kx-tight">
<tr><td>[file](../basics/cmdline.md#file)</td></tr>
<tr><td>[`\a`](../basics/syscmds.md#a-tables)</td><td>tables</td><td>[`\r`](../basics/syscmds.md#r-rename)</td><td>rename</td></tr>
<tr><td>[`-b`](../basics/cmdline.md#-b-blocked)</td><td>blocked</td><td>[`-s`](../basics/cmdline.md#-s-slaves) [`\s`](../basics/syscmds.md#s-number-of-slaves)</td><td>slaves</td></tr>
<tr><td>[`\b`](../basics/syscmds.md#b-views) [`\B`](../basics/syscmds.md#b-pending-views)</td><td>views</td><td>[`\S`](../basics/syscmds.md#s-random-seed)</td><td>random seed</td></tr>
<tr><td>[`-c`](../basics/cmdline.md#-c-console-size) [`\c`](../basics/syscmds.md#c-console-size)</td><td>console size</td><td>[`-t`](../basics/cmdline.md#-t-timer-ticks) [`\t`](../basics/syscmds.md#t-timer)</td><td>timer ticks</td></tr>
<tr><td>[`-C`](../basics/cmdline.md#-c-http-size) [`\C`](../basics/syscmds.md#c-http-size)</td><td>HTTP size</td><td>[`\ts`](../basics/syscmds.md#ts-time-and-space)</td><td>time and space</td></tr>
<tr><td>[`\cd`](../basics/syscmds.md#cd-change-directory)</td><td>change directory</td><td>[`-T`](../basics/cmdline.md#-t-timeout) [`\T`](../basics/syscmds.md#t-timeout)</td><td>timeout</td></tr>
<tr><td>[`\d`](../basics/syscmds.md#d-directory)</td><td>directory</td><td>[`-u`](../basics/cmdline.md#-u-usr-pwd-local) [`-U`](../basics/cmdline.md#-u-usr-pwd) [`\u`](../basics/syscmds.md#u-reload-user-password-file)</td><td>usr-pwd</td></tr>
<tr><td>[`-e`](../basics/cmdline.md#-e-error-traps) [`\e`](../basics/syscmds.md#e-error-trap-clients)</td><td>error traps</td><td>[`-u`](../basics/cmdline.md#-u-disable-syscmds)</td><td>disable syscmds</td></tr>
<tr><td>[`-E`](../basics/cmdline.md#-e-error-traps)</td><td>TLS Server Mode</td><td>[`\v`](../basics/syscmds.md#v-variables)</td><td>variables</td></tr>
<tr><td>[`\f`](../basics/syscmds.md#f-functions)</td><td>functions</td><td>[`-w`](../basics/cmdline.md#-w-memory) [`\w`](../basics/syscmds.md#w-workspace)</td><td>memory</td></tr>
<tr><td>[`-g`](../basics/cmdline.md#-g-garbage-collection) [`\g`](../basics/syscmds.md#g-garbage-collection-mode)</td><td>garbage collection</td><td>[`-W`](../basics/cmdline.md#-w-start-week) [`\W`](../basics/syscmds.md#w-week-offset)</td><td>week offset</td></tr>
<tr><td>[`\l`](../basics/syscmds.md#l-load-file-or-directory)</td><td>load file or directory</td><td>[`\x`](../basics/syscmds.md#x-expunge)</td><td>expunge</td></tr>
<tr><td>[`-l`](../basics/cmdline.md#-l-log-updates) [`-L`](../basics/cmdline.md#-l-log-sync)</td><td>log sync</td><td>[`-z`](../basics/cmdline.md#-z-date-format) [`\z`](../basics/syscmds.md#z-date-parsing)</td><td>date format</td></tr>
<tr><td>[`-o`](../basics/cmdline.md#-o-utc-offset) [`\o`](../basics/syscmds.md#o-offset-from-utc)</td><td>UTC offset</td><td>[`\1` `\2`](../basics/syscmds.md#1-2-redirect)</td><td>redirect</td></tr>
<tr><td>[`-p`](../basics/cmdline.md#-p-listening-port) [`\p`](../basics/syscmds.md#p-listening-port)</td><td>multithread port</td><td>[`\_`](../basics/syscmds.md#_-hide-q-code)</td><td>hide q code</td></tr>
<tr><td>[`-P`](../basics/cmdline.md#-p-display-precision) [`\P`](../basics/syscmds.md#p-precision)</td><td>display precision</td><td>[`\`](../basics/syscmds.md#terminate)</td><td>terminate</td></tr>
<tr><td>[`-q`](../basics/cmdline.md#-q-quiet-mode)</td><td>quiet mode</td><td>[`\`](../basics/syscmds.md#toggle-qk)</td><td>toggle q/k</td></tr>
<tr><td>[`-r`](../basics/cmdline.md#-r-replicate) [`\r`](../basics/syscmds.md#r-replication-master)</td><td>replicate</td><td>[`\\`](../basics/syscmds.md#quit)</td><td>quit</td></tr>
</table>

<i class="far fa-hand-point-right"></i>
[Command-line options](../basics/cmdline.md),
[System commands](../basics/syscmds.md),
[OS Commands](../basics/syscmds.md#os-commands),
[`system`](../ref/system.md)

<!--
## Environment variables

<table class="kx-tight">
<thead><tr><th>var</th><th>default</th><th>use</th></tr></thead>
<tbody>
<tr><td><code>QHOME</code></td><td><code>$HOME/q</code></td><td>folder searched for q.k and unqualified script names</td></tr>
<tr><td><code>QLIC</code></td><td><code>$HOME</code></td><td>folder searched for k4.lic license file</td></tr>
<tr><td><code>QINIT</code></td><td><code>q.q</code></td><td>additional file loaded after q.k has initialised</td></tr>
<tr><td><code>LINES</code></td><td/><td>supplied by OS, used to set <code>\c</code></td></tr>
<tr><td><code>COLUMNS</code></td><td/><td><code>\c $LINES $COLUMNS</code></td></tr>
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

## Datatypes
<table class="kx-tight" markdown="1" style="font-size:80%">
<thead>
<tr><th>n</th><th>c</th><th>name</th><th>sz</th><th>literal</th><th>null</th><th>inf</th><th>SQL</th><th>Java</th><th>.Net</th></tr>
</thead>
<tbody>
<tr><td class="nowrap">0</td><td>*</td><td>list</td><td/><td/><td/><td/><td/><td/><td/></tr>
<tr><td class="nowrap">1</td><td>b</td><td>boolean</td><td>1</td><td>`0b`</td><td/><td/><td/><td>Boolean</td><td>boolean</td></tr>
<tr><td class="nowrap">2</td><td>g</td><td>guid</td><td>16</td><td/><td>`0Ng`</td><td/><td/><td>UUID</td><td>GUID</td></tr>
<tr><td class="nowrap">4</td><td>x</td><td>byte</td><td>1</td><td>`0x00`</td><td/><td/><td/><td>Byte</td><td>byte</td></tr>
<tr><td class="nowrap">5</td><td>h</td><td>short</td><td>2</td><td>`0h`</td><td>`0Nh`</td><td>`0Wh`</td><td>smallint</td><td>Short</td><td>int16</td></tr>
<tr><td class="nowrap">6</td><td>i</td><td>int</td><td>4</td><td>`0i`</td><td>`0Ni`</td><td>`0Wi`</td><td>int</td><td>Integer</td><td>int32</td></tr>
<tr><td class="nowrap">7</td><td>j</td><td>long</td><td>8</td><td>`0j` or `0`</td><td>`0Nj`<br>or `0N`</td><td>`0Wj`<br>or `0W`</td><td>bigint</td><td>Long</td><td>int64</td></tr>
<tr><td class="nowrap">8</td><td>e</td><td>real</td><td>4</td><td>`0e`</td><td>`0Ne`</td><td>`0We`</td><td>real</td><td>Float</td><td>single</td></tr>
<tr><td class="nowrap">9</td><td>f</td><td>float</td><td>8</td><td>`0.0` or `0f`</td><td>`0n`</td><td>`0w`</td><td>float</td><td>Double</td><td>double</td></tr>
<tr><td class="nowrap">10</td><td>c</td><td>char</td><td>1</td><td>`" "`</td><td>`" "`</td><td/><td/><td>Character</td><td>char</td></tr>
<tr><td class="nowrap">11</td><td>s</td><td>symbol</td><td>.</td><td>`` ` ``</td><td>`` ` ``</td><td/><td>varchar</td><td>String</td><td>string</td></tr>
<tr><td class="nowrap">12</td><td>p</td><td>timestamp</td><td>8</td><td>dateDtimespan</td><td>`0Np`</td><td>`0Wp`</td><td/><td>Timestamp</td><td>DateTime (RW)</td></tr>
<tr><td class="nowrap">13</td><td>m</td><td>month</td><td>4</td><td>`2000.01m`</td><td>`0Nm`</td><td/><td/><td/><td/></tr>
<tr><td class="nowrap">14</td><td>d</td><td>date</td><td>4</td><td>`2000.01.01`</td><td>`0Nd`</td><td>`0Wd`</td><td>date</td><td>Date</td><td/></tr>
<tr><td class="nowrap">15</td><td>z</td><td>datetime</td><td>8</td><td>dateTtime</td><td>`0Nz`</td><td>`0wz`</td><td>timestamp</td><td>Timestamp</td><td>DateTime (RO)</td></tr>
<tr><td class="nowrap">16</td><td>n</td><td>timespan</td><td>8</td><td>`00:00:00.000000000`</td><td>`0Nn`</td><td>`0Wn`</td><td/><td>Timespan</td><td>TimeSpan</td></tr>
<tr><td class="nowrap">17</td><td>u</td><td>minute</td><td>4</td><td>`00:00`</td><td>`0Nu`</td><td>`0Wu`</td><td/><td/><td/></tr>
<tr><td class="nowrap">18</td><td>v</td><td>second</td><td>4</td><td>`00:00:00`</td><td>`0Nv`</td><td>`0Nv`</td><td/><td/><td/></tr>
<tr><td class="nowrap">19</td><td>t</td><td>time</td><td>4</td><td>`00:00:00.000`</td><td>`0Nt`</td><td>`0Wt`</td><td>time</td><td>Time</td><td>TimeSpan</td></tr>
<tr><td class="nowrap" colspan="2">20-76</td><td>enums</td><td/><td/><td/><td/><td/><td/></tr>
<tr><td class="nowrap">77</td><td/><td colspan="7">anymap</td><td/><td/><td/></tr>
<tr><td class="nowrap" colspan="2">78-96</td><td colspan="7">77+t – mapped list of lists of type t</td><td/><td/><td/></tr>
<tr><td class="nowrap">97</td><td/><td colspan="7">nested sym enum</td><td/><td/><td/></tr>
<tr><td class="nowrap">98</td><td/><td colspan="7">table</td><td/><td/><td/></tr>
<tr><td class="nowrap">99</td><td/><td colspan="7">dictionary</td><td/><td/><td/></tr>
<tr><td class="nowrap">100</td><td/><td colspan="7">[lambda](../basics/function-notation.md)</td><td/><td/><td/></tr>
<tr><td class="nowrap">101</td><td/><td colspan="7">unary primitive</td><td/><td/><td/></tr>
<tr><td class="nowrap">102</td><td/><td colspan="7">operator</td><td/><td/><td/></tr>
<tr><td class="nowrap">103</td><td/><td colspan="7">[iterator](iterators.md)</td><td/><td/><td/></tr>
<tr><td class="nowrap">104</td><td/><td colspan="7">projection</td><td/><td/><td/></tr>
<tr><td class="nowrap">105</td><td/><td colspan="7">[composition](compose.md)</td><td/><td/><td/></tr>
<tr><td class="nowrap">106</td><td/><td colspan="7">[`v'`](maps.md#each)</td><td/><td/><td/></tr>
<tr><td class="nowrap">107</td><td/><td colspan="7">[`v/`](accumulators.md)</td><td/><td/><td/></tr>
<tr><td class="nowrap">108</td><td/><td colspan="7">[`v\`](accumulators.md)</td><td/><td/><td/></tr>
<tr><td class="nowrap">109</td><td/><td colspan="7">[`v':`](maps.md)</td><td/><td/><td/></tr>
<tr><td class="nowrap">110</td><td/><td colspan="7">[`v/:`](maps.md#each-left-and-each-right)</td><td/><td/><td/></tr>
<tr><td class="nowrap">111</td><td/><td colspan="7">[`v\:`](maps.md#each-left-and-each-right)</td><td/><td/><td/></tr>
<tr><td class="nowrap">112</td><td/><td colspan="7">dynamic load</td><td/><td/><td/></tr>
</tbody>
</table>

_n_: short int returned by [`type`](type.md) and used for [casting](../basics/casting.md), e.g. `9h$3`
_c_: character used lower-case for [casting](../basics/casting.md) and upper-case for [Load CSV](file-text.md#load-csv)
_sz_: size in bytes
_inf_: infinity (no math on temporal types); `0Wh` is `32767h`
`v`: applicable value
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

<table class="kx-shrunk kx-tight" markdown="1">
<tr><td><a href="doth/#hbr-linebreak">`.h.br`</a></td><td><a href="doth/#hbr-linebreak">linebreak</a></td><td><a href="doth/#hhu-uri-escape">`.h.hu`</a></td><td><a href="doth/#hhu-uri-escape">URI escape</a></td></tr>
<tr><td><a href="doth/#hc0-web-color">`.h.c0`</a></td><td><a href="doth/#hc0-web-color">web color</a></td><td><a href="doth/#hhug-uri-map">`.h.hug`</a></td><td><a href="doth/#hhug-uri-map">URI map</a></td></tr>
<tr><td><a href="doth/#hc1-web-color">`.h.c1`</a></td><td><a href="doth/#hc1-web-color">web color</a></td><td><a href="doth/#hhy-http-response">`.h.hy`</a></td><td><a href="doth/#hhy-http-response">HTTP response</a></td></tr>
<tr><td><a href="doth/#hcd-csv-from-data">`.h.cd`</a></td><td><a href="doth/#hcd-csv-from-data">CSV from data</a></td><td><a href="doth/#hiso8601-iso-timestamp">`.h.iso8601`</a></td><td><a href="doth/#hiso8601-iso-timestamp">ISO timestamp</a></td></tr>
<tr><td><a href="doth/#hcode-code-after-tab">`.h.code`</a></td><td><a href="doth/#hcode-code-after-tab">code after Tab</a></td><td><a href="doth/#hjx-table">`.h.jx`</a></td><td><a href="doth/#hjx-table">table</a></td></tr>
<tr><td><a href="doth/#hed-excel-from-data">`.h.ed`</a></td><td><a href="doth/#hed-excel-from-data">Excel from data</a></td><td><a href="doth/#hlogo-kx-logo">`.h.logo`</a></td><td><a href="doth/#hlogo-kx-logo">Kx logo</a></td></tr>
<tr><td><a href="doth/#hedsn-excel-from-tables">`.h.edsn`</a></td><td><a href="doth/#hedsn-excel-from-tables">Excel from tables</a></td><td><a href="doth/#hnbr-no-break">`.h.nbr`</a></td><td><a href="doth/#hnbr-no-break">no break</a></td></tr>
<tr><td><a href="doth/#hfram-frame">`.h.fram`</a></td><td><a href="doth/#hfram-frame">frame</a></td><td><a href="doth/#hpre-pre">`.h.pre`</a></td><td><a href="doth/#hpre-pre">pre</a></td></tr>
<tr><td><a href="doth/#hha-anchor">`.h.ha`</a></td><td><a href="doth/#hha-anchor">anchor</a></td><td><a href="doth/#hsa-style">`.h.sa`</a></td><td><a href="doth/#hsa-style">style</a></td></tr>
<tr><td><a href="doth/#hhb-anchor-target">`.h.hb`</a></td><td><a href="doth/#hhb-anchor-target">anchor target</a></td><td><a href="doth/#hsb-style">`.h.sb`</a></td><td><a href="doth/#hsb-style">style</a></td></tr>
<tr><td><a href="doth/#hhc-escape-lt">`.h.hc`</a></td><td><a href="doth/#hhc-escape-lt">escape lt</a></td><td><a href="doth/#hsc-uri-safe">`.h.sc`</a></td><td><a href="doth/#hsc-uri-safe">URI-safe</a></td></tr>
<tr><td><a href="doth/#hhe-http-400">`.h.he`</a></td><td><a href="doth/#hhe-http-400">HTTP 400</a></td><td><a href="doth/#htd-tsv">`.h.td`</a></td><td><a href="doth/#htd-tsv">TSV</a></td></tr>
<tr><td><a href="doth/#hhn-http-error">`.h.hn`</a></td><td><a href="doth/#hhn-http-error">HTTP error</a></td><td><a href="doth/#htext-paragraphs">`.h.text`</a></td><td><a href="doth/#htext-paragraphs">paragraphs</a></td></tr>
<tr><td><a href="doth/#hhp-http-response">`.h.hp`</a></td><td><a href="doth/#hhp-http-response">HTTP response</a></td><td><a href="doth/#htx-filetypes">`.h.tx`</a></td><td><a href="doth/#htx-filetypes">filetypes</a></td></tr>
<tr><td><a href="doth/#hhr-horizontal-rule">`.h.hr`</a></td><td><a href="doth/#hhr-horizontal-rule">horizontal rule</a></td><td><a href="doth/#hty-mime-types">`.h.ty`</a></td><td><a href="doth/#hty-mime-types">MIME types</a></td></tr>
<tr><td><a href="doth/#hht-marqdown-to-html">`.h.ht`</a></td><td><a href="doth/#hht-marqdown-to-html">Marqdown to HTML</a></td><td><a href="doth/#huh-uri-unescape">`.h.uh`</a></td><td><a href="doth/#huh-uri-unescape">URI unescape</a></td></tr>
<tr><td><a href="doth/#hhta-start-tag">`.h.hta`</a></td><td><a href="doth/#hhta-start-tag">start tag</a></td><td><a href="doth/#hxd-xml">`.h.xd`</a></td><td><a href="doth/#hxd-xml">XML</a></td></tr>
<tr><td><a href="doth/#hhtac-element">`.h.htac`</a></td><td><a href="doth/#hhtac-element">element</a></td><td><a href="doth/#hxmp-xmp">`.h.xmp`</a></td><td><a href="doth/#hxmp-xmp">XMP</a></td></tr>
<tr><td><a href="doth/#hhtc-element">`.h.htc`</a></td><td><a href="doth/#hhtc-element">element</a></td><td><a href="doth/#hxs-xml-escape">`.h.xs`</a></td><td><a href="doth/#hxs-xml-escape">XML escape</a></td></tr>
<tr><td><a href="doth/#hhtml-document">`.h.html`</a></td><td><a href="doth/#hhtml-document">document</a></td><td><a href="doth/#hxt-json">`.h.xt`</a></td><td><a href="doth/#hxt-json">JSON</a></td></tr>
<tr><td><a href="doth/#hhttp-hyperlinks">`.h.http`</a></td><td><a href="doth/#hhttp-hyperlinks">hyperlinks</a></td></tr>
</table>


### `.j`

De/serialize as JSON

<table class="kx-shrunk kx-tight" markdown="1">
<tr><td><a href="dotj/#jj-serialize">`.j.j`</a></td><td><a href="dotj/#jj-serialize">serialize</a></td><td><a href="dotj/#jk-deserialize">`.j.k`</a></td><td><a href="dotj/#jk-deserialize">deserialize</a></td></tr>
</table>


### `.Q`

Utilities: general, environment, IPC, datatype, database, partitioned database state, segmented database state, file I/O

<table class="kx-shrunk kx-tight" markdown="1">
<tr><td><a href="dotq/#qa-lower-case-alphabet">`.Q.a`</a></td><td><a href="dotq/#qa-lower-case-alphabet">lower-case alphabet</a></td>                                                               <td><a href="dotq/#qj10-encode-binhex">`.Q.j10`</a></td><td><a href="dotq/#qj10-encode-binhex">encode binhex</a></td></tr>
<tr><td><a href="dotq/#qa-upper-case-alphabet">`.Q.A`</a></td><td><a href="dotq/#qa-upper-case-alphabet">upper-case alphabet</a></td>                                                               <td><a href="dotq/#qx10-decode-binhex">`.Q.x10`</a></td><td><a href="dotq/#qx10-decode-binhex">decode binhex</a></td></tr>
<tr><td><a href="dotq/#qaddmonths">`.Q.addmonths`</a></td><td><a href="dotq/#qaddmonths"></a></td>                                                                                                  <td><a href="dotq/#qj12-encode-base64">`.Q.j12`</a></td><td><a href="dotq/#qj12-encode-base64">encode base64</a></td></tr>
<tr><td><a href="dotq/#qaddr-ip-address">`.Q.addr`</a></td><td><a href="dotq/#qaddr-ip-address">IP address</a></td>                                                                                 <td><a href="dotq/#qx12-decode-base64">`.Q.x12`</a></td><td><a href="dotq/#qx12-decode-base64">decode base64</a></td></tr>
<tr><td><a href="dotq/#qbt-backtrace">`.Q.bt`</a></td><td><a href="dotq/#qbt-backtrace">backtrace</a></td>                                                                                          <td><a href="dotq/#qk-version">`.Q.k`</a></td><td><a href="dotq/#qk-version">version</a></td></tr>
<tr><td><a href="dotq/#qbtoa-b64-encode">`.Q.btoa`</a></td><td><a href="dotq/#qbtoa-b64-encode">b64 encode</a></td>                                                                                 <td><a href="dotq/#ql-load">`.Q.l`</a></td><td><a href="dotq/#ql-load">load</a></td></tr>
<tr><td><a href="dotq/#qbv-build-vp">`.Q.bv`</a></td><td><a href="dotq/#qbv-build-vp">build vp</a></td>                                                                                             <td><a href="dotq/#qm-long-infinity">`.Q.M`</a></td><td><a href="dotq/#qm-long-infinity">long infinity</a></td></tr>
<tr><td><a href="dotq/#qchk-fill-hdb">`.Q.chk`</a></td><td><a href="dotq/#qchk-fill-hdb">fill HDB</a></td>                                                                                          <td><a href="dotq/#qmap-maps-partitions">`.Q.MAP`</a></td><td><a href="dotq/#qmap-maps-partitions">maps partitions</a></td></tr>
<tr><td><a href="dotq/#qcn-count-partitioned-table">`.Q.cn`</a></td><td><a href="dotq/#qcn-count-partitioned-table">count partitioned table</a></td>                                                <td><a href="dotq/#qopt-command-parameters">`.Q.opt`</a></td><td><a href="dotq/#qopt-command-parameters">command parameters</a></td></tr>
<tr><td><a href="dotq/#qcf-create-empty-nested-char-file">`.Q.Cf`</a></td><td><a href="dotq/#qcf-create-empty-nested-char-file">create empty nested char file</a></td>                              <td><a href="dotq/#qpar-locate-partition">`.Q.par`</a></td><td><a href="dotq/#qpar-locate-partition">locate partition</a></td></tr>
<tr><td><a href="dotq/#qd-partitions">`.Q.D`</a></td><td><a href="dotq/#qd-partitions">partitions</a></td>                                                                                          <td><a href="dotq/#qpd-modified-partition-locations">`.Q.pd`</a></td><td><a href="dotq/#qpd-modified-partition-locations">modified partition locations</a></td></tr>
<tr><td><a href="dotq/#qdd-join-symbols">`.Q.dd`</a></td><td><a href="dotq/#qdd-join-symbols">join symbols</a></td>                                                                                 <td><a href="dotq/#qpf-partition-field">`.Q.pf`</a></td><td><a href="dotq/#qpf-partition-field">partition field</a></td></tr>
<tr><td><a href="dotq/#qdef">`.Q.def`</a></td><td><a href="dotq/#qdef"></a></td>                                                                                                                    <td><a href="dotq/#qpn-partition-counts">`.Q.pn`</a></td><td><a href="dotq/#qpn-partition-counts">partition counts</a></td></tr>
<tr><td><a href="dotq/#qdpft-save-table">`.Q.dpft`</a></td><td><a href="dotq/#qdpft-save-table">save table</a></td>                                                                                 <td><a href="dotq/#qpt-partitioned-tables">`.Q.pt`</a></td><td><a href="dotq/#qpt-partitioned-tables">partitioned tables</a></td></tr>
<tr><td><a href="dotq/#qdpfts-save-table-with-symtable">`.Q.dpfts`</a></td><td><a href="dotq/#qdpfts-save-table-with-symtable">save table with symtable</a></td>                                    <td><a href="dotq/#qpv-modified-partition-values">`.Q.pv`</a></td><td><a href="dotq/#qpv-modified-partition-values">modified partition values</a></td></tr>
<tr><td><a href="dotq/#qdsftg-load-process-save">`.Q.dsftg`</a></td><td><a href="dotq/#qdsftg-load-process-save">load process save</a></td>                                                         <td><a href="dotq/#qp-segments">`.Q.P`</a></td><td><a href="dotq/#qp-segments">segments</a></td></tr>
<tr><td><a href="dotq/#qen-enumerate-varchar-cols">`.Q.en`</a></td><td><a href="dotq/#qen-enumerate-varchar-cols">enumerate varchar cols</a></td>                                                   <td><a href="dotq/#qpd-partition-locations">`.Q.PD`</a></td><td><a href="dotq/#qpd-partition-locations">partition locations</a></td></tr>
<tr><td><a href="dotq/#qens-enumerate-against-domain">`.Q.ens`</a></td><td><a href="dotq/#qens-enumerate-against-domain">enumerate against domain</a></td>                                          <td><a href="dotq/#qpv-partition-values">`.Q.PV`</a></td><td><a href="dotq/#qpv-partition-values">partition values</a></td></tr>
<tr><td><a href="dotq/#qf-format">`.Q.f`</a></td><td><a href="dotq/#qf-format">format</a></td>                                                                                                      <td><a href="dotq/#qqp-is-partitioned">`.Q.qp`</a></td><td><a href="dotq/#qqp-is-partitioned">is partitioned</a></td></tr>
<tr><td><a href="dotq/#qfc-parallel-on-cut">`.Q.fc`</a></td><td><a href="dotq/#qfc-parallel-on-cut">parallel on cut</a></td>                                                                        <td><a href="dotq/#qqt-is-table">`.Q.qt`</a></td><td><a href="dotq/#qqt-is-table">is table</a></td></tr>
<tr><td><a href="dotq/#qff-append-columns">`.Q.ff`</a></td><td><a href="dotq/#qff-append-columns">append columns</a></td>                                                                           <td><a href="dotq/#qres-keywords">`.Q.res`</a></td><td><a href="dotq/#qres-keywords">keywords</a></td></tr>
<tr><td><a href="dotq/#qfk-foreign-key">`.Q.fk`</a></td><td><a href="dotq/#qfk-foreign-key">foreign key</a></td>                                                                                    <td><a href="dotq/#qs-plain-text">`.Q.s`</a></td><td><a href="dotq/#qs-plain-text">plain text</a></td></tr>
<tr><td><a href="dotq/#qfmt-format">`.Q.fmt`</a></td><td><a href="dotq/#qfmt-format">format</a></td>                                                                                                <td><a href="dotq/#qsbt-string-backtrace">`.Q.sbt`</a></td><td><a href="dotq/#qsbt-string-backtrace">string backtrace</a></td></tr>
<tr><td><a href="dotq/#qfps-streaming-algorithm">`.Q.fps`</a></td><td><a href="dotq/#qfps-streaming-algorithm">streaming algorithm</a></td>                                                         <td><a href="dotq/#qsha1-sha-1-encode">`.Q.sha1`</a></td><td><a href="dotq/#qsha1-sha-1-encode">SHA-1 encode</a></td></tr>
<tr><td><a href="dotq/#qfs-streaming-algorithm">`.Q.fs`</a></td><td><a href="dotq/#qfs-streaming-algorithm">streaming algorithm</a></td>                                                            <td><a href="dotq/#qtrp-extend-trap">`.Q.trp`</a></td><td><a href="dotq/#qtrp-extend-trap">extend trap</a></td></tr>
<tr><td><a href="dotq/#qfsn-streaming-algorithm">`.Q.fsn`</a></td><td><a href="dotq/#qfsn-streaming-algorithm">streaming algorithm</a></td>                                                         <td><a href="dotq/#qts-time-and-space">`.Q.ts`</a></td><td><a href="dotq/#qts-time-and-space">time and space</a></td></tr>
<tr><td><a href="dotq/#qft-apply-simple">`.Q.ft`</a></td><td><a href="dotq/#qft-apply-simple">apply simple</a></td>                                                                                 <td><a href="dotq/#qty-type">`.Q.ty`</a></td><td><a href="dotq/#qty-type">type</a></td></tr>
<tr><td><a href="dotq/#qfu-apply-unique">`.Q.fu`</a></td><td><a href="dotq/#qfu-apply-unique">apply unique</a></td>                                                                                 <td><a href="dotq/#qu-date-based">`.Q.u`</a></td><td><a href="dotq/#qu-date-based">date based</a></td></tr>
<tr><td><a href="dotq/#qgc-garbage-collect">`.Q.gc`</a></td><td><a href="dotq/#qgc-garbage-collect">garbage collect</a></td>                                                                        <td><a href="dotq/#qv-value">`.Q.v`</a></td><td><a href="dotq/#qv-value">value</a></td></tr>
<tr><td><a href="dotq/#qhdpf-save-tables">`.Q.hdpf`</a></td><td><a href="dotq/#qhdpf-save-tables">save tables</a></td>                                                                              <td><a href="dotq/#qv-table-to-dict">`.Q.V`</a></td><td><a href="dotq/#qv-table-to-dict">table to dict</a></td></tr>
<tr><td><a href="dotq/#qhg-http-get">`.Q.hg`</a></td><td><a href="dotq/#qhg-http-get">HTTP get</a></td>                                                                                             <td><a href="dotq/#qview-subview">`.Q.view`</a></td><td><a href="dotq/#qview-subview">subview</a></td></tr>
<tr><td><a href="dotq/#qhost-hostname">`.Q.host`</a></td><td><a href="dotq/#qhost-hostname">hostname</a></td>                                                                                       <td><a href="dotq/#qvp-missing-partitions">`.Q.vp`</a></td><td><a href="dotq/#qvp-missing-partitions">missing partitions</a></td></tr>
<tr><td><a href="dotq/#qhp-http-post">`.Q.hp`</a></td><td><a href="dotq/#qhp-http-post">HTTP post</a></td>                                                                                          <td><a href="dotq/#qw-memory-stats">`.Q.w`</a></td><td><a href="dotq/#qw-memory-stats">memory stats</a></td></tr>
<tr><td><a href="dotq/#qid-sanitize">`.Q.id`</a></td><td><a href="dotq/#qid-sanitize">sanitize</a></td>                                                                                             <td><a href="dotq/#qx-non-command-parameters">`.Q.x`</a></td><td><a href="dotq/#qx-non-command-parameters">non-command parameters</a></td></tr>
<tr><td><a href="dotq/#qind-partitioned-index">`.Q.ind`</a></td><td><a href="dotq/#qind-partitioned-index">partitioned index</a></td>                                                               <td><a href="dotq/#qxf-create-file">`.Q.Xf`</a></td><td><a href="dotq/#qxf-create-file">create file</a></td></tr>
</table>


### `.z`

System variables, callbacks

<table class="kx-shrunk kx-tight" markdown="1">
<tr><td><a href="dotz/#za-ip-address">`.z.a`</a></td><td><a href="dotz/#za-ip-address">IP address</a></td>                                          <td><a href="dotz/#zpi-input">`.z.pi`</a></td><td><a href="dotz/#zpi-input">input</a></td></tr>
<tr><td><a href="dotz/#zac-http-auth-from-cookie">`.z.ac`</a></td><td><a href="dotz/#zac-http-auth-from-cookie">HTTP auth from cookie</a></td>      <td><a href="dotz/#zpm-http-options">`.z.pm`</a></td><td><a href="dotz/#zpm-http-options">HTTP options</a></td></tr>
<tr><td><a href="dotz/#zb-dependencies">`.z.b`</a></td><td><a href="dotz/#zb-dependencies">dependencies</a></td>                                    <td><a href="dotz/#zpo-open">`.z.po`</a></td><td><a href="dotz/#zpo-open">open</a></td></tr>
<tr><td><a href="dotz/#zbm-msg-validator">`.z.bm`</a></td><td><a href="dotz/#zbm-msg-validator">msg validator</a></td>                              <td><a href="dotz/#zpp-http-post">`.z.pp`</a></td><td><a href="dotz/#zpp-http-post">HTTP post</a></td></tr>
<tr><td><a href="dotz/#zc-cores">`.z.c`</a></td><td><a href="dotz/#zc-cores">cores</a></td>                                                         <td><a href="dotz/#zpq-qcon">`.z.pq`</a></td><td><a href="dotz/#zpq-qcon">qcon</a></td></tr>
<tr><td><a href="dotz/#ze-tls-connection-status">`.z.e`</a></td><td><a href="dotz/#ze-tls-connection-status">TLS connection status</a></td>         <td><a href="dotz/#zps-set">`.z.ps`</a></td><td><a href="dotz/#zps-set">set</a></td></tr>
<tr><td><a href="dotz/#zex-failed-primitive">`.z.ex`</a></td><td><a href="dotz/#zex-failed-primitive">failed primitive</a></td>                     <td><a href="dotz/#zpw-validate-user">`.z.pw`</a></td><td><a href="dotz/#zpw-validate-user">validate user</a></td></tr>
<tr><td><a href="dotz/#zexit-action-on-exit">`.z.exit`</a></td><td><a href="dotz/#zexit-action-on-exit">action on exit</a></td>                     <td><a href="dotz/#zq-quiet-mode">`.z.q`</a></td><td><a href="dotz/#zq-quiet-mode">quiet mode</a></td></tr>
<tr><td><a href="dotz/#zey-argument-to-failed-primitive">`.z.ey`</a></td><td><a href="dotz/#zey-argument-to-failed-primitive">argument to failed primitive</a></td><td><a href="dotz/#zs-self">`.z.s`</a></td><td><a href="dotz/#zs-self">self</a></td></tr>
<tr><td><a href="dotz/#zf-file">`.z.f`</a></td><td><a href="dotz/#zf-file">file</a></td>                                                            <td><a href="dotz/#zts-timer">`.z.ts`</a></td><td><a href="dotz/#zts-timer">timer </a></td></tr>
<tr><td><a href="dotz/#zh-host">`.z.h`</a></td><td><a href="dotz/#zh-host">host</a></td>                                                            <td><a href="dotz/#zu-user-id">`.z.u`</a></td><td><a href="dotz/#zu-user-id">user ID</a></td></tr>
<tr><td><a href="dotz/#zi-pid">`.z.i`</a></td><td><a href="dotz/#zi-pid">PID</a></td>                                                               <td><a href="dotz/#zvs-value-set">`.z.vs`</a></td><td><a href="dotz/#zvs-value-set">value set</a></td></tr>
<tr><td><a href="dotz/#zk-version">`.z.K`</a></td><td><a href="dotz/#zk-version">version</a></td>                                                   <td><a href="dotz/#zw-handles">`.z.W`</a></td><td><a href="dotz/#zw-handles">handles</a></td></tr>
<tr><td><a href="dotz/#zk-release-date">`.z.k`</a></td><td><a href="dotz/#zk-release-date">release date</a></td>                                    <td><a href="dotz/#zw-handle">`.z.w`</a></td><td><a href="dotz/#zw-handle">handle</a></td></tr>
<tr><td><a href="dotz/#zl-license">`.z.l`</a></td><td><a href="dotz/#zl-license">license</a></td>                                                   <td><a href="dotz/#zwc-websocket-close">`.z.wc`</a></td><td><a href="dotz/#zwc-websocket-close">websocket close</a></td></tr>
<tr><td><a href="dotz/#zn-local-timespan">`.z.N`</a></td><td><a href="dotz/#zn-local-timespan">local timespan</a></td>                              <td><a href="dotz/#zwo-websocket-open">`.z.wo`</a></td><td><a href="dotz/#zwo-websocket-open">websocket open</a></td></tr>
<tr><td><a href="dotz/#zn-utc-timespan">`.z.n`</a></td><td><a href="dotz/#zn-utc-timespan">UTC timespan</a></td>                                    <td><a href="dotz/#zws-websockets">`.z.ws`</a></td><td><a href="dotz/#zws-websockets">websockets</a></td></tr>
<tr><td><a href="dotz/#zo-os-version">`.z.o`</a></td><td><a href="dotz/#zo-os-version">OS version</a></td>                                          <td><a href="dotz/#zx-raw-command-line">`.z.X`</a></td><td><a href="dotz/#zx-raw-command-line">raw command line</a></td></tr>
<tr><td><a href="dotz/#zp-local-timestamp">`.z.P`</a></td><td><a href="dotz/#zp-local-timestamp">local timestamp</a></td>                           <td><a href="dotz/#zx-argv">`.z.x`</a></td><td><a href="dotz/#zx-argv">argv</a></td></tr>
<tr><td><a href="dotz/#zp-utc-timestamp">`.z.p`</a></td><td><a href="dotz/#zp-utc-timestamp">UTC timestamp</a></td>                                 <td><a href="dotz/#zz-local-datetime">`.z.Z`</a></td><td><a href="dotz/#zz-local-datetime">local datetime</a></td></tr>
<tr><td><a href="dotz/#zpc-close">`.z.pc`</a></td><td><a href="dotz/#zpc-close">close</a></td>                                                      <td><a href="dotz/#zz-utc-datetime">`.z.z`</a></td><td><a href="dotz/#zz-utc-datetime">UTC datetime</a></td></tr>
<tr><td><a href="dotz/#zpd-peach-handles">`.z.pd`</a></td><td><a href="dotz/#zpd-peach-handles">peach handles</a></td>                              <td><a href="dotz/#zzd-zip-defaults">`.z.zd`</a></td><td><a href="dotz/#zzd-zip-defaults">zip defaults</a></td></tr>
<tr><td><a href="dotz/#zpg-get">`.z.pg`</a></td><td><a href="dotz/#zpg-get">get</a></td>                                                            <td><a href="dotz/#zt-zt-zd-zd-timedate-shortcuts">`.z.T|t|D|d`</a></td><td><a href="dotz/#zt-zt-zd-zd-timedate-shortcuts">time/date shortcuts</a></td></tr>
<tr><td><a href="dotz/#zph-http-get">`.z.ph`</a></td><td><a href="dotz/#zph-http-get">HTTP get</a></td>                                             <td/>
</table>
