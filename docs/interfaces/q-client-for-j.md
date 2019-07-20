---
title: Q client for J
description: QJ is a C extension for q, working as a frontend of J engine DLL, so we can use the J engine and the J Application Library within q.
keywords: api, client, interface, j, kdb+, q
---
# ![J](img/j.png) Q client for J



QJ is a C extension for q, working as a frontend of [J](http://jsoftware.com) engine DLL, so we can use the [J engine](http://www.jsoftware.com/help/dictionary/vocabul.htm) and the [J Application Library](http://www.jsoftware.com/jwiki/JAL/j701) within q. It has been tested on l64 with j701beta. 

<i class="fab fa-github"></i> [kxcontrib/zuoqianxu/qj](https://github.com/kxcontrib/zuoqianxu/tree/master/qj) 


## Install

-   In `qj` dir, run `mkqjfe.sh`, then copy `qjfe.so` to `$QHOME/l64/`
-   Install `j701beta` from [j701a\_linux64.sh](http://www.jsoftware.com/download/j701a_linux64.sh)
-   Install J Application Library: run jconsole

```j
load 'pacman'
'update' jpkg ''
'install' jpkg 'all'
```


## Functions

| function | role |
|----------|------|
| `jeinit[x]` | Load libj.so from directory `x` |
| `jefree[]` | Free libj.so |
| `j2q[x]` | Get q data from J name `x` |
| `q2j[x;y]` | Set q data `y` to J name `x` |
| `jedo[x]` | Run J code `x`, then return result |
| `jemv[x;y]` | Run J code `x` with right operand `y`, then return result |
| `jedv[x;y;z]` | Run J code `x` with left operand x and right operand `y` ,then return result |
| `initj[x]` | Load libj.so from directory `x`, then load profile.ijs from `x`– required for using libraries |


## Datatype map

| J | q |
|---|---|
| boolean | boolean |
| char | char |
| double | double |
| int | long |
| complex atom A | 2-item double array (Re A;Im A) |
| complex array L | 2-item list whose items are double arrays (Re L;Im L) |
| boxed array | mixed list:  items will be converted for supported datatypes |

<!-- original
- There are natural mappings of some J/q datatypes on l64: boolean, char, double, J int&lt;=&gt;q long
- J complex atom `A` will be converted to a 2-item double array (Re A;Im A). J complex array `L` will be converted to a 2-item list whose items are double arrays (Re L;Im L)
- Q mixed list maps to J boxed array, items will be converted for supported datatypes
-->

For convenience on l64, q int will be auto-converted to J int, but `0N` `0W` `-0W` will not be correctly converted


## Sample usage

Start a q session, then load `qj.q`.

```q
q)\l qj.q
```

Load J runtime:

```q
q)initj["/opt/j64-701/bin"];
```

Set data to J:

```q
q)q2j["a";(01b;2 3 4j;5;1 0n 0w -0w -2f;"abcd")]
```

Get data from J:

```q
q)2jq["a"]
01b
2 3 4j
5j
1 0n 0w -0w -2
"abcd"
```

Eval J sentences:

```q
q)jedo "i.2 3 4"
0 1 2  3    4 5 6  7    8 9 10 11
12 13 14 15 16 17 18 19 20 21 22 23
```

Call J monads:

```q
q)jemv["q:"] 1234567890j
2 3 3 5 3607 3803j
```

Call J dyads:

```q
q)jedv["e.";"cat";"abcd"]
110b
```

Use J [plot](http://www.jsoftware.com/jwiki/Plot) library:

```q
q)jedo "load 'plot'";
q)jemv["plot"] 100?1f;
q).q.plot:jedv["plot"];
q)"type bar" plot 10?1f;
```

Use J `fftw` library:

```q
q)jedo "load 'math/fftw'";
q)jemv["fftw"]  til 8
28 -4       -4 -4       -4 -4        -4 -4
0  9.656854 4  1.656854 0  -1.656854 -4 -9.656854
```

Use J `tara` library to read Excel files:

```q
q)jedo "load 'tables/tara'";
q)\wget http://www.iso15022.org/MIC/ISO10383_MIC_v1_78.xls -O /tmp/10383.xls
q){flip (`$x[0])!flip 1_x} trim jedo "\":>readexcel '/tmp/10383.xls'"
COUNTRY     CC   MIC    INSTITUTION DESCRIPTION              ACR     CITY    ..
-----------------------------------------------------------------------------..
"ALBANIA"   "AL" "XTIR" "TIRANA STOCK EXCHANGE"              ""      "TIRANA"..
"ALGERIA"   "DZ" "XALG" "ALGIERS STOCK EXCHANGE"             ""      "ALGIERS..
"ARGENTINA" "AR" "BACE" "BUENOS AIRES CEREAL EXCHANGE"       ""      "BUENOS ..
..
```

