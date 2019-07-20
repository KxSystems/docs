---
title: Datatypes
description: Every kdb+ object has a corresponding datatype. There are 38 datatypes. 
author: Stephen Taylor
keywords: atom, boolean, character, datatype, date, datetime, double, float, integer, kdb+, list, long, q, scalar, short, string, symbol, temporal, time, timespan, timestamp, type, vector
---
# Datatypes







Every kdb+ object has a corresponding datatype. There are 38 datatypes. 

The datatype of an object is given as a short int. 

```q
q)type 5                      / long (integer) atom
-7h
q)type 2 3 5                  / long (integer) list
7h
q)type (2;3 5f;"hello")       / mixed list
0h
q)type each (2;3 5f;"hello")
-7 9 10h
q)type (+)                    /not just data
102h
```

`type` returns short integers (type `5h` or `"h"`), negative for an atom, positive for a list.

```q
q)type type 1
-5h
```

<i class="far fa-hand-point-right"></i> 
[Casting](casting.md), 
[`type`](../ref/type.md), 
[`.Q.ty`](../ref/dotq.md#qty-type) (type)


## Primitive datatypes

Primitive datatypes are in the range ± `1h` to `19h`: positive for a vector, negative for an atom. (A general list has type `0h`.)  

<i class="far fa-hand-point-right"></i> 
[`type`](../ref/type.md)

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
<tr><td class="nowrap">100</td><td/><td colspan="7">lambda</td><td/><td/><td/></tr>
<tr><td class="nowrap">101</td><td/><td colspan="7">unary primitive</td><td/><td/><td/></tr>
<tr><td class="nowrap">102</td><td/><td colspan="7">operator</td><td/><td/><td/></tr>
<tr><td class="nowrap">103</td><td/><td colspan="7">iterator</td><td/><td/><td/></tr>
<tr><td class="nowrap">104</td><td/><td colspan="7">projection</td><td/><td/><td/></tr>
<tr><td class="nowrap">105</td><td/><td colspan="7">composition</td><td/><td/><td/></tr>
<tr><td class="nowrap">106</td><td/><td colspan="7">f'</td><td/><td/><td/></tr>
<tr><td class="nowrap">107</td><td/><td colspan="7">f/</td><td/><td/><td/></tr>
<tr><td class="nowrap">108</td><td/><td colspan="7">f\</td><td/><td/><td/></tr>
<tr><td class="nowrap">109</td><td/><td colspan="7">f':</td><td/><td/><td/></tr>
<tr><td class="nowrap">110</td><td/><td colspan="7">f/:</td><td/><td/><td/></tr>
<tr><td class="nowrap">111</td><td/><td colspan="7">f\:</td><td/><td/><td/></tr>
<tr><td class="nowrap">112</td><td/><td colspan="7">dynamic load</td><td/><td/><td/></tr>
</tbody>
</table>

_n_: short int returned by [`type`](../ref/type.md) and used for [casting](casting.md), e.g. `9h$3`  
_c_: character used lower-case for [casting](casting.md) and upper-case for [Load CSV](../ref/file-text.md#load-csv)  
_sz_: size in bytes  
_inf_: infinity (no math on temporal types); `0Wh` is `32767h`  
RO: read only; RW: read-write

!!! note "Strings"

    There is no string datatype. On this site, _string_ is a synonym for character vector (type 10h). In kdb, the nearest equivalent to an atomic string is the symbol.

!!! note "Default integer type"

    The default type for an integer is long (`7h` or `"j"`). 
    Before V3.0 it was int (`6h` or `"i"`).


### Temporal

The valid date range for parsing is ​1709.01.01 to 2290.12.31.
Date arithmetic is not checked, so you can go out of this range.

```q
q)2290.12.31
2290.12.31
q)2291.01.01        / out of range
'2291.01.01
q)2290.12.31+0 1
2290.12.31 2291.01.01
q)2000.01.01+2000.01.01-1709.01.01
2290.12.31
```

Valid ranges can be seen by incrementing or decrementing the infinities.

```q
q)-0W 0Wp+1 -1      / limit of timestamp type
1707.09.22D00:12:43.145224194 2292.04.10D23:47:16.854775806

q)0p+ -0W 0Wp+1 -1  / timespan offset of those from 0p
-106751D23:47:16.854775806 106751D23:47:16.854775806

q)-0W 0Wn+1 -1      / coincide with the min/max for timespan
```


### Symbols

A back tick `` ` `` followed by a series of characters represents a _symbol_, which is not the same as a string. 

```q
q)`symbol ~ "symbol"
0b
```

A back tick without characters after it represents the _empty symbol_: `` ` ``. 

!!! tip "Cast string to symbol"

    The empty symbol can be used with [Cast](../ref/cast.md) to cast a string into a symbol, creating symbols whose names could not otherwise be written, such as symbols containing spaces. `` `$x`` is shorthand for `"S"$x`. 

    <pre><code class="language-q">
    q)s:\`hello world
    'world
    q)s:\`$"hello world"
    q)s
    \`hello world
    </code></pre>

<i class="far fa-hand-point-right"></i> 
_Q for Mortals_: [§2.4 Basic Data Types – Atoms](/q4m3/2_Basic_Data_Types_Atoms/#24-text-data)


### Filepaths

Filepaths are a special form of symbol. 

```q
q)count read0 `:path/to/myfile.txt  / count lines in myfile.txt
```


### Infinities

Note that arithmetic for integer infinities (`0Wh`,`0Wi`,`0Wj`) is undefined, and does not retain the concept when cast.

```q
q)0Wi+5
2147483652
q)0Wi+5i
-2147483644i
q)`float$0Wj
9.223372e+18
q)`float$0Wi
2.147484e+09
```

Arithmetic for float infinities (`0we`,`0w`) behaves as expected.

```q
q)0we + 5
0we
q)0w + 5
0w
```

<i class="far fa-hand-point-right"></i> 
[`.Q.M`](../ref/dotq.md#qm-long-infinity) (long infinity)


### Guid

The guid type (since V3.0) is a 16-byte type, and can be used for storing arbitrary 16-byte values, typically transaction IDs.

!!! tip "Generation"

    Use [Deal](../ref/deal.md) to generate a guid (global unique: uses `.z.a .z.i .z.p`).

    <pre><code class="language-q">
    q)-2?0Ng
    337714f8-3d76-f283-cdc1-33ca89be59e9 0a369037-75d3-b24d-6721-5a1d44d4bed5
    </code></pre>

    If necessary, manipulate the bytes to make the uuid a [Version-4 'standard' uuid](http://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_.28random.29).
    
    Guids can also be created from strings or byte vectors, using `sv` or `"G"$`, e.g.
    <pre><code class="language-q">
    q)0x0 sv 16?0xff
    8c680a01-5a49-5aab-5a65-d4bfddb6a661
    q)"G"$"8c680a01-5a49-5aab-5a65-d4bfddb6a661"
    8c680a01-5a49-5aab-5a65-d4bfddb6a661
    </code></pre>

`0Ng` is null guid. 

```q
q)0Ng
00000000-0000-0000-0000-000000000000
q)null 0Ng
1b
```

There is no literal entry for a guid, it has no conversions, and the only scalar primitives are `=`, `<` and `>` (similar to sym). In general, since V3.0, there should be no need for char vectors for IDs. IDs should be int, sym or guid. Guids are faster (much faster for `=`) than the 16-byte char vecs and take 2.5 times less storage (16 per instead of 40 per).


## Other types


### Enumerated types

Enumerated types are numbered from `20h` up to `76h`. For example, in a new session with no enumerations defined:

```q
q)type `sym$10?sym:`AAPL`AIG`GOOG`IBM
20h
q)type `city$10?city:`london`paris`rome
21h
```

(Since V3.0, type `20h` is reserved for `` `sym$``.)


### Nested types

These types are used for mapped lists of lists of the same type. The numbering is 77 + primitive type (e.g. 77 is [anymap](../releases/ChangesIn3.6.md#anymap), 78 is boolean, 96 is time and 97 is `` `sym$`` enumeration.)

```q
q)`:t1.dat set 2 3#til 6
`:t1.dat
q)a:get `:t1.dat
q)type a            /integer nested type
83h
q)a
0 1 2
3 4 5
```


### Dictionary and table

Dictionary is `99h` and table is `98h`.

```q
q)type d:`a`b`c!(1 2;3 5;7 11)     / dict
99h
q)type flip d                      / table
98h
```


### Functions, iterators, derived functions

Functions, lambdas, operators, iterators, projections, compositions and derived functions have types in the range [100–112].

```q
q)type each({x+y};neg;-;\;+[;1];<>;,';+/;+\;prev;+/:;+\:;`f 2:`f,1)
100 101 102 103 104 105 106 107 108 109 110 111 112h
```




