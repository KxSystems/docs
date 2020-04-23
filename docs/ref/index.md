---
title: Reference card - code.kx.com – Reference – kdb+ and q documentation
description: Quick reference for kdb+ and the q programming language
author: Stephen Taylor
keywords: card, index, kdb+, keywords, operators, q, reference
---

# Reference card




## Keywords

<table class="kx-shrunk kx-tight" markdown="1">
<tr><td>A</td><td>[`abs`](abs.md "absolute value") [`acos`](cos.md#acos "arccosine") [`aj` `aj0` `ajf` `ajf0`](aj.md "as-of join") [`all`](all-any.md#all "all nonzero") [`and`](lesser.md "lesser") [`any`](all-any.md#any "any item is non-zero") [`asc`](asc.md "ascending sort") [`asin`](sin.md#asin "arcsine") [`asof`](asof.md "as-of join") [`atan`](tan.md#atan "arctangent") [`attr`](attr.md "attributes") [`avg`](avg.md#avg "arithmetic mean") [`avgs`](avg.md#avgs "running averages")</td></tr>
<tr><td>B</td><td>[`bin` `binr`](bin.md "binary search")</td></tr>
<tr><td>C</td><td>[`ceiling`](ceiling.md "lowest integer above") [`cols`](cols.md#cols "column names of a table") [`cor`](cor.md "correlation") [`cos`](cos.md "cosine") [`count`](count.md "number of items") [`cov`](cov.md "covariance") [`cross`](cross.md "cross product") [`csv`](csv.md "comma delimiter") [`cut`](cut.md "cut array into pieces")</td></tr>
<tr><td>D</td><td>[`delete`](delete.md#delete-keyword "delete rows or columns from a table") [`deltas`](deltas.md "differences between consecutive pairs") [`desc`](desc.md "descending sort") [`dev`](dev.md "standard deviation") [`differ`](differ.md "flag differences in consecutive pairs") [`distinct`](distinct.md "unique items") [`div`](div.md "integer division") [`do`](do.md) [`dsave`](dsave.md "save global tables to disk")</td></tr>
<tr><td>E</td><td>[`each`](each.md "apply to each item") [`ej`](ej.md "equi-join") [`ema`](ema.md "exponentially-weighted moving average") [`enlist`](enlist.md "arguments as a list") [`eval`](eval.md "evaluate a parse tree") [`except`](except.md "left argument without items in right argument") [`exec`](exec.md) [`exit`](exit.md "terminate q") [`exp`](exp.md "power of e")</td></tr>
<tr><td>F</td><td>[`fby`](fby.md "filter-by") [`fills`](fill.md#fills "forward-fill nulls") [`first`](first.md "first item") [`fkeys`](fkeys.md "foreign-key columns mapped to their tables") [`flip`](flip.md "transpose") [`floor`](floor.md "greatest integer less than argument")</td></tr>
<tr><td>G</td><td>[`get`](get.md "get a q data file") [`getenv`](getenv.md "value of an environment variable") [`group`](group.md "dictionary of distinct items") [`gtime`](gtime.md "UTC timestamp")</td></tr>
<tr><td>H</td><td>[`hclose`](hopen.md#hclose "close a file or process") [`hcount`](hcount.md "size of a file") [`hdel`](hdel.md "delete a file") [`hopen`](hopen.md "open a file") [`hsym`](hsym.md "convert symbol to filename or IP address")</td></tr>
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

:fontawesome-solid-book:
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

:fontawesome-solid-book:
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

<pre markdown="1" class="language-txt" style="font-size: 90%">
s  sorted     u  unique
p  parted     g  grouped
</pre>

:fontawesome-solid-book:
[Set Attribute](set-attribute.md)

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
<tr><td>[`\f`](../basics/syscmds.md#f-functions)</td><td>functions</td><td>[`-w`](../basics/cmdline.md#-w-workspace) [`\w`](../basics/syscmds.md#w-workspace)</td><td>memory</td></tr>
<tr><td>[`-g`](../basics/cmdline.md#-g-garbage-collection) [`\g`](../basics/syscmds.md#g-garbage-collection-mode)</td><td>garbage collection</td><td>[`-W`](../basics/cmdline.md#-w-start-week) [`\W`](../basics/syscmds.md#w-week-offset)</td><td>week offset</td></tr>
<tr><td>[`\l`](../basics/syscmds.md#l-load-file-or-directory)</td><td>load file or directory</td><td>[`\x`](../basics/syscmds.md#x-expunge)</td><td>expunge</td></tr>
<tr><td>[`-l`](../basics/cmdline.md#-l-log-updates) [`-L`](../basics/cmdline.md#-l-log-sync)</td><td>log sync</td><td>[`-z`](../basics/cmdline.md#-z-date-format) [`\z`](../basics/syscmds.md#z-date-parsing)</td><td>date format</td></tr>
<tr><td>[`-o`](../basics/cmdline.md#-o-utc-offset) [`\o`](../basics/syscmds.md#o-offset-from-utc)</td><td>UTC offset</td><td>[`\1` `\2`](../basics/syscmds.md#1-2-redirect)</td><td>redirect</td></tr>
<tr><td>[`-p`](../basics/cmdline.md#-p-listening-port) [`\p`](../basics/syscmds.md#p-listening-port)</td><td>listening port</td><td>[`\_`](../basics/syscmds.md#_-hide-q-code)</td><td>hide q code</td></tr>
<tr><td>[`-P`](../basics/cmdline.md#-p-display-precision) [`\P`](../basics/syscmds.md#p-precision)</td><td>display precision</td><td>[`\`](../basics/syscmds.md#terminate)</td><td>terminate</td></tr>
<tr><td>[`-q`](../basics/cmdline.md#-q-quiet-mode)</td><td>quiet mode</td><td>[`\`](../basics/syscmds.md#toggle-qk)</td><td>toggle q/k</td></tr>
<tr><td>[`-r`](../basics/cmdline.md#-r-replicate) [`\r`](../basics/syscmds.md#r-replication-master)</td><td>replicate</td><td>[`\\`](../basics/syscmds.md#quit)</td><td>quit</td></tr>
</table>

:fontawesome-regular-hand-point-right:
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
<br>
_c_: character used lower-case for [casting](../basics/casting.md) and upper-case for [Load CSV](file-text.md#load-csv)
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

<pre markdown="1" class="language-txt" style="font-size: 80%">
[`.h.br`](doth.md#hbr-linebreak)      linebreak                [`.h.cd`](doth.md#hcd-csv-from-data)      CSV from data
[`.h.code`](doth.md#hcode-code-after-tab)    code after Tab           [`.h.d`](doth.md#hd-delimiter)       delimiter
[`.h.fram`](doth.md#hfram-frame)    frame                    [`.h.ed`](doth.md#hed-excel-from-data)      Excel from data
[`.h.ha`](doth.md#hha-anchor)      anchor                   [`.h.edsn`](doth.md#hedsn-excel-from-tables)    Excel from tables
[`.h.hb`](doth.md#hhb-anchor-target)      anchor target            [`.h.hc`](doth.md#hhc-escape-lt)      escape lt
[`.h.ht`](doth.md#hht-marqdown-to-html)      Marqdown to HTML         [`.h.hr`](doth.md#hhr-horizontal-rule)      horizontal rule
[`.h.hta`](doth.md#hhta-start-tag)     start tag                [`.h.iso8601`](doth.md#hiso8601-iso-timestamp) ISO timestamp
[`.h.htac`](doth.md#hhtac-element)    element                  [`.h.jx`](doth.md#hjx-table)      table
[`.h.htc`](doth.md#hhtc-element)     element                  [`.h.td`](doth.md#htd-tsv-from-data)      TSV from data
[`.h.html`](doth.md#hhtml-document)    document                 [`.h.tx`](doth.md#htx-filetypes)      filetypes
[`.h.http`](doth.md#hhttp-hyperlinks)    hyperlinks               [`.h.xd`](doth.md#hxd-xml)      XML
[`.h.nbr`](doth.md#hnbr-no-break)     no break                 [`.h.xs`](doth.md#hxs-xml-escape)      XML escape
[`.h.pre`](doth.md#hpre-pre)     pre                      [`.h.xt`](doth.md#hxt-json)      JSON
[`.h.text`](doth.md#htext-paragraphs)    paragraphs
[`.h.xmp`](doth.md#hxmp-xmp)     XMP

[`.h.he`](doth.md#hhe-http-400)      HTTP 400                 [`.h.c0`](doth.md#hc0-web-color)    web color
[`.h.hn`](doth.md#hhn-http-response)      HTTP response            [`.h.c1`](doth.md#hc1-web-color)    web color
[`.h.hp`](doth.md#hhp-http-response-pre)      HTTP response pre        [`.h.HOME`](doth.md#hhome-webserver-root)  webserver root
[`.h.hy`](doth.md#hhy-http-response-content)      HTTP response content    [`.h.logo`](doth.md#hlogo-kx-logo)  Kx logo
                                    [`.h.sa`](doth.md#hsa-anchor-style)    anchor style
[`.h.hu`](doth.md#hhu-uri-escape)      URI escape               [`.h.sb`](doth.md#hsb-body-style)    body style
[`.h.hug`](doth.md#hhug-uri-map)     URI map                  [`.h.ty`](doth.md#hty-mime-types)    MIME types
[`.h.sc`](doth.md#hsc-uri-safe)      URI-safe                 [`.h.val`](doth.md#hval-value)   value
[`.h.uh`](doth.md#huh-uri-unescape)      URI unescape
</pre>


### `.j`

De/serialize as JSON

<pre markdown="1" class="language-txt" style="font-size: 80%">
[.j.j   serialize](dotj.md#jj-serialize)                [.j.k   deserialize](dotj.md#jk-deserialize)
[.j.jd  serialize infinity](dotj.md#jjd-serialize-infinity)
</pre>


### `.m`

:fontawesome-regular-hand-point-right:
[Memory backed by files](dotm.md)


### `.Q`

Utilities: general, environment, IPC, datatype, database, partitioned database state, segmented database state, file I/O

<pre markdown="1" class="language-txt" style="font-size: 80%">
General                               Datatype
[.Q.a        lowercase alphabet](dotq.md#qa-lower-case-alphabet)        [.Q.btoa   b64 encode](dotq.md#qbtoa-b64-encode)
[.Q.A        uppercase alphabet](dotq.md#qa-upper-case-alphabet)        [.Q.j10    encode binhex](dotq.md#qj10-encode-binhex)
[.Q.addmonths](dotq.md#qaddmonths)                          [.Q.j12    encode base64](dotq.md#qj12-encode-base64)
[.Q.bt       backtrace](dotq.md#qbt-backtrace)                 [.Q.M      long infinity](dotq.md#qm-long-infinity)
[.Q.dd       join symbols](dotq.md#qdd-join-symbols)              [.Q.ty     type](dotq.md#qty-type)
[.Q.def](dotq.md#qdef)                                [.Q.x10    decode binhex](dotq.md#qx10-decode-binhex)
[.Q.f        format](dotq.md#qf-format)                    [.Q.x12    decode base64](dotq.md#qx12-decode-base64)
[.Q.fc       parallel on cut](dotq.md#qfc-parallel-on-cut)
[.Q.ff       append columns](dotq.md#qff-append-columns)            Database
[.Q.fmt      format](dotq.md#qfmt-format)                    [.Q.chk    fill HDB](dotq.md#qchk-fill-hdb)
[.Q.ft       apply simple](dotq.md#qft-apply-simple)              [.Q.dpft   save table](dotq.md#qdpft-save-table)
[.Q.fu       apply unique](dotq.md#qfu-apply-unique)              [.Q.dpfts  save table with sym](dotq.md#qdpfts-save-table-with-symtable)
[.Q.gc       garbage collect](dotq.md#qgc-garbage-collect)           [.Q.dsftg  load process save](dotq.md#qdsftg-load-process-save)
[.Q.id       sanitize](dotq.md#qid-sanitize)                  [.Q.en     enumerate varchar cols](dotq.md#qen-enumerate-varchar-cols)
[.Q.qt       is table](dotq.md#qqt-is-table)                  [.Q.ens    enumerate against domain](dotq.md#qens-enumerate-against-domain)
[.Q.res      keywords](dotq.md#qres-keywords)                  [.Q.fk     foreign key](dotq.md#qfk-foreign-key)
[.Q.s        plain text](dotq.md#qs-plain-text)                [.Q.hdpf   save tables](dotq.md#qhdpf-save-tables)
[.Q.s1       string representation](dotq.md#qs1-string-representation)     [.Q.qt     is table](dotq.md#qqt-is-table)
[.Q.sbt      string backtrace](dotq.md#qsbt-string-backtrace)          [.Q.qp     is partitioned](dotq.md#qqp-is-partitioned)
[.Q.sha1     SHA-1 encode](dotq.md#qsha1-sha-1-encode)
[.Q.trp      extend trap](dotq.md#qtrp-extend-trap)               Partitioned database state
[.Q.ts       time and space](dotq.md#qts-time-and-space)            [.Q.bv     build vp](dotq.md#qbv-build-vp)
[.Q.u        date based](dotq.md#qu-date-based)                [.Q.cn     count partitioned table](dotq.md#qcn-count-partitioned-table)
[.Q.V        table to dict](dotq.md#qv-table-to-dict)             [.Q.D      partitions](dotq.md#qd-partitions)
[.Q.v        value](dotq.md#qv-value)                     [.Q.ind    partitioned index](dotq.md#qind-partitioned-index)
[.Q.view     subview](dotq.md#qview-subview)                   [.Q.MAP    maps partitions](dotq.md#qmap-maps-partitions)
                                      [.Q.par    locate partition](dotq.md#qpar-locate-partition)
Environment                           [.Q.PD     partition locations](dotq.md#qpd-partition-locations)
[.Q.k        version](dotq.md#qk-version)                   [.Q.pd     modified partition locns](dotq.md#qpd-modified-partition-locations)
[.Q.opt      command parameters](dotq.md#qopt-command-parameters)        [.Q.pf     partition field](dotq.md#qpf-partition-field)
[.Q.w        memory stats](dotq.md#qw-memory-stats)              [.Q.pn     partition counts](dotq.md#qpn-partition-counts)
[.Q.x        non-command parameters](dotq.md#qx-non-command-parameters)    [.Q.qp     is partitioned](dotq.md#qqp-is-partitioned)
                                      [.Q.pt     partitioned tables](dotq.md#qpt-partitioned-tables)
IPC                                   [.Q.PV     partition values](dotq.md#qpv-partition-values)
[.Q.addr     IP address](dotq.md#qaddr-ip-address)                [.Q.pv     modified partition values](dotq.md#qpv-modified-partition-values)
[.Q.fps      streaming algorithm](dotq.md#qfps-streaming-algorithm)       [.Q.vp     missing partitions](dotq.md#qvp-missing-partitions)
[.Q.fs       streaming algorithm](dotq.md#qfs-streaming-algorithm)
[.Q.fsn      streaming algorithm](dotq.md#qfsn-streaming-algorithm)       Segmented database state
[.Q.hg       HTTP get](dotq.md#qhg-http-get)                  [.Q.D      partitions](dotq.md#qd-partitions)
[.Q.host     hostname](dotq.md#qhost-hostname)                  [.Q.P      segments](dotq.md#qp-segments)
[.Q.hp       HTTP post](dotq.md#qhp-http-post)                 [.Q.u      date based](dotq.md#qu-date-based)
[.Q.l        load](dotq.md#ql-load)

File I/O
[.Q.Cf       create empty nested char file](dotq.md#qcf-create-empty-nested-char-file)
[.Q.Xf       create file](dotq.md#qxf-create-file)
</pre>


### `.z`

System variables, callbacks

<pre markdown="1" class="language-txt" style="font-size: 80%">
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
</pre>
