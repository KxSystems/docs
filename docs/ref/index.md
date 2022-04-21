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
--8<-- "docs/ref/kwds.txt"
</tbody></table>

### By category
<table class="kx-tight" markdown>
<tbody markdown>
--8<-- "docs/ref/kwdcat.txt"
</tbody></table>

:fontawesome-solid-book:
[`.Q.id`](dotq.md#qid-sanitize) (sanitize),
[`.Q.res`](dotq.md#qres-keywords) (reserved words)


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
<td markdown class="kx-glyph">[`!`](overloads.md#bang)</td><td colspan="7" markdown>[Dict](dict.md), [Enkey](enkey.md), [Unkey](enkey.md#unkey), [Enumeration](enumeration.md), [Flip Splayed](flip-splayed.md), [Display](display.md), [internal](../basics/internal.md), [Update](../basics/funsql.md#update), [Delete](../basics/funsql.md#delete)</td>
</tr>
<tr markdown>
<td markdown class="kx-glyph">[`?`](overloads.md#query)</td><td colspan="7" markdown>[Find](find.md), [Roll, Deal](deal.md), [Enum Extend](enum-extend.md), [Select](../basics/funsql.md#select), [Exec](../basics/funsql.md#exec), [Simple Exec](../basics/funsql.md#simple-exec), [Vector Conditional](vector-conditional.md)</td>
</tr>
<tr markdown>
</tr>
<tr markdown> <td markdown class="kx-glyph">`+ - * %`</td><td colspan="7" markdown>[Add](add.md), [Subtract](subtract.md), [Multiply](multiply.md), [Divide](divide.md)</td> </tr>
<tr markdown> <td markdown class="kx-glyph">`= <> ~`</td><td colspan="7" markdown>[Equals](../basics/comparison/#six-comparison-operators), [Not Equals](../basics/comparison/#six-comparison-operators), [Match](../basics/comparison/#match)</td></tr>
<tr markdown>
<td markdown class="kx-glyph">`< <= >= >`</td><td colspan="7" markdown>[Less Than](../basics/comparison/#six-comparison-operators), [Up To](../basics/comparison/#six-comparison-operators), [At Least](../basics/comparison/#six-comparison-operators), [Greater Than](../basics/comparison/#six-comparison-operators)</td>
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
<tr markdown><td markdown>[`-b`](../basics/cmdline.md#-b-blocked)</td><td markdown>blocked</td><td markdown>[`-s`](../basics/cmdline.md#-s-secondary-processes) [`\s`](../basics/syscmds.md#s-number-of-secondary-processes)</td><td markdown>secondary processes</td></tr>
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
<tr markdown><td markdown>[`-r`](../basics/cmdline.md#-r-replicate) [`\r`](../basics/syscmds.md#r-replication-master)</td><td markdown>replicate</td><td markdown>[`\\`](../basics/syscmds.md#quit)</td><td markdown>quit</td></tr>
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

### `.h`

Markup output for HTTP

<div markdown class="typewriter">
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

<div markdown class="typewriter">
[.j.j   serialize](dotj.md#jj-serialize)                [.j.k   deserialize](dotj.md#jk-deserialize)
[.j.jd  serialize infinity](dotj.md#jjd-serialize-infinity)
</div>


### `.m`

:fontawesome-regular-hand-point-right:
[Memory backed by files](dotm.md)


### `.Q`

Utilities: general, environment, IPC, datatype, database, partitioned database state, segmented database state, file I/O

<div markdown class="typewriter">
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

<div markdown class="typewriter">
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
