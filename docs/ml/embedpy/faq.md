---
hero: <i class="fa fa-share-alt"></i> Machine learning / embedPy
title: embedPy frequently-asked questions
keywords: dataframe, date, datetime, embedpy,kdb+, month, numpy, pandas,python, q, timestamp
---

# Frequently-asked questions




## How can I convert a q table to a Pandas DataFrame?

Using embedPy, we can directly initialise q tables as Pandas DataFrames.

```q
q)show qtab:([]fcol:10?10.;icol:10?10;scol:10?`aaa`bbb`ccc)
fcol      icol scol
-------------------
4.414491  2    ccc 
7.267987  5    bbb 
9.996082  8    bbb 
7.433285  7    ccc 
2.371288  9    ccc 
5.67081   9    bbb 
4.269177  7    bbb 
7.704774  7    aaa 
0.1594028 1    ccc 
3.573039  9    aaa 

q)print pytab:.p.import[`pandas;`:DataFrame]qtab
       fcol  icol scol
0  4.414491     2  ccc
1  7.267987     5  bbb
2  9.996082     8  bbb
3  7.433285     7  ccc
4  2.371288     9  ccc
5  5.670810     9  bbb
6  4.269177     7  bbb
7  7.704774     7  aaa
8  0.159403     1  ccc
9  3.573039     9  aaa
```

Key columns are treated as regular columns in the conversion…

```q
q)show qkeytab:select by scol from qtab
scol| fcol      icol
----| --------------
aaa | 3.573039  9   
bbb | 4.269177  7   
ccc | 0.1594028 1   

q)print pytab2:.p.import[`pandas;`:DataFrame]qkeytab
  scol      fcol  icol
0  aaa  3.573039     9
1  bbb  4.269177     7
2  ccc  0.159403     1
```

… but can be explicitly set as DataFrame indices.

```q
q)print pykeytab:pytab2[`:set_index]keys qkeytab
          fcol  icol
scol                
aaa   3.573039     9
bbb   4.269177     7
ccc   0.159403     1
```


### `tab2df`

The `tab2df` function converts both unkeyed and keyed tables to DataFrames.

```q
tab2df:{
  r:.p.import[`pandas; `:DataFrame; x][@; cols x];
  $[count k:keys x; r[`:set_index]k; r]}
```

```q
q)print tab2df qtab
       fcol  icol scol
0  4.414491     2  ccc
1  7.267987     5  bbb
2  9.996082     8  bbb
3  7.433285     7  ccc
4  2.371288     9  ccc
5  5.670810     9  bbb
6  4.269177     7  bbb
7  7.704774     7  aaa
8  0.159403     1  ccc
9  3.573039     9  aaa

q)print tab2df qkeytab
          fcol  icol
scol                
aaa   3.573039     9
bbb   4.269177     7
ccc   0.159403     1
```


## How can I convert a Pandas DataFrame to a q table?

A Pandas DataFrame can be efficiently converted to a q column dictionary using the `to_dict` method.

N.B. Python strings will be converted to q strings, and should be converted to symbols as appropriate.

```q
q)print pytab
       fcol  icol scol
0  4.414491     2  ccc
1  7.267987     5  bbb
2  9.996082     8  bbb
3  7.433285     7  ccc
4  2.371288     9  ccc
5  5.670810     9  bbb
6  4.269177     7  bbb
7  7.704774     7  aaa
8  0.159403     1  ccc
9  3.573039     9  aaa

q)pytab[`:to_dict;`list]`
fcol| 4.414491 7.267987 9.996082 7.433285 2.371288 5.67081 4.269177 7.704774 ..
icol| 2        5        8        7        9        9       7        7        ..
scol| "ccc"    "bbb"    "bbb"    "ccc"    "ccc"    "bbb"   "bbb"    "aaa"    ..
```

This can be easily flipped to a q table.

```q
q)show qtab:flip qdict
fcol      icol scol 
--------------------
4.414491  2    "ccc"
7.267987  5    "bbb"
9.996082  8    "bbb"
7.433285  7    "ccc"
2.371288  9    "ccc"
5.67081   9    "bbb"
4.269177  7    "bbb"
7.704774  7    "aaa"
0.1594028 1    "ccc"
3.573039  9    "aaa"
```

Indices within DataFrames are not considered to be columns and will be dropped in the conversion.

```q
q)print pykeytab
          fcol  icol
scol                
aaa   3.573039     9
bbb   4.269177     7
ccc   0.159403     1

q)pykeytab[`:to_dict;`list]`
fcol| 3.573039 4.269177 0.1594028
icol| 9        7        1        
```

These indices can be set to columns using the `reset_index` method.

```q
q)print pykeytab[`:reset_index][]
  scol      fcol  icol
0  aaa  3.573039     9
1  bbb  4.269177     7
2  ccc  0.159403     1

q)pykeytab[`:reset_index][][`:to_dict;`list]`
scol| "aaa"    "bbb"    "ccc"    
fcol| 3.573039 4.269177 0.1594028
icol| 9        7        1        
```

To check the _keyed_ nature of a DataFrame, we can inspect the `index` attribute. 

_Unkeyed_ tables have a simple `RangeIndex`, while _keyed_ tables have a more complex Index type.

```q
q)print pytab`:index
RangeIndex(start=0, stop=10, step=1)

q)print pykeytab`:index
Index(['aaa', 'bbb', 'ccc'], dtype='object', name='scol')
```


### `df2tab`

The `df2tab` function converts both _unkeyed_ and _keyed_ DataFrames to tables.

```q
df2tab:{
  n:$[.p.isinstance[x`:index;.p.import[`pandas]`:RangeIndex]`;0;x[`:index.nlevels]`];
  n!flip $[n;x[`:reset_index][];x][`:to_dict;`list]`}
```

```q
q)df2tab pytab
fcol      icol scol 
--------------------
4.414491  2    "ccc"
7.267987  5    "bbb"
9.996082  8    "bbb"
7.433285  7    "ccc"
2.371288  9    "ccc"
5.67081   9    "bbb"
4.269177  7    "bbb"
7.704774  7    "aaa"
0.1594028 1    "ccc"
3.573039  9    "aaa"

q)df2tab pykeytab
scol | fcol      icol
-----| --------------
"aaa"| 3.573039  9   
"bbb"| 4.269177  7   
"ccc"| 0.1594028 1 
```


## How can I convert q dates to Python dates?

In q, there are three date types (date, month and timestamp) that map to Python or NumPy `datetime64` types. 

!!! note "Not datetime"

    We ignore the kdb+ datetime type here, deprecated due to the underlying floating-point representation.

To convert these dates:

1.  Adjust to the Unix epoch (1970.01.01)
2.  Convert to a NumPy array with the appropriate `datetime64` type/precision


### Dates

Create a list of dates.

```q
q)show datelist:6?"d"$0
2000.12.11 2000.01.15 2000.02.02 2003.08.16 2002.04.24 2000.03.22
```

Adjust for the Unix epoch

```q
q)"j"$datelist-1970.01.01
11302 10971 10989 12280 11801 11038
```

and convert to a NumPy array (with `datetime64[D]` type).

```q
q)print .p.import[`numpy;`:array]["j"$datelist-1970.01.01;`dtype pykw"datetime64[D]"]
['2000-12-11' '2000-01-15' '2000-02-02' '2003-08-16' '2002-04-24' '2000-03-22']
```


### Months

Create a list of months.

```q
q)show monthlist:6?"m"$0
2000.12 2002.02 2003.12 2000.12 2003.11 2000.07m
```

Adjust for the Unix epoch

```q
q)"j"$monthlist-1970.01m
371 385 407 371 406 366
```

and convert to a NumPy array (with `datetime64[M]` type).

```q
q)print .p.import[`numpy;`:array]["j"$monthlist-1970.01m;`dtype pykw"datetime64[M]"]
['2000-12' '2002-02' '2003-12' '2000-12' '2003-11' '2000-07']
```


### Timestamps

Create a list of timestamps.

```q
q)show stamplist:6?"p"$0
2003.06.28D17:26:01.260806768 2002.08.17D16:36:35.216906816 2003.11.07D05:38:..
```

Adjust for the Unix epoch

```q
q)"j"$stamplist-1970.01.01D0
1056821161260806768 1029602195216906816 1068183533870536832 99357904889686256..
```

and convert to a NumPy array (with `datetime64[ns]` type).

```q
q)print .p.import[`numpy;`:array]["j"$stamplist-1970.01.01D0;`dtype pykw"datetime64[ns]"]
['2003-06-28T17:26:01.260806768' '2002-08-17T16:36:35.216906816'
 '2003-11-07T05:38:53.870536832' '2001-06-26T18:10:48.896862568'
 '2000-09-11T21:28:21.496423780' '2002-05-11T13:56:52.890104944']
```


### `q2pydts`

The `q2pydts` function converts all three date types to the equivalent `datetime64` type.

```q
q2pydts:{.p.import[`numpy;
                   `:array;
                   "j"$x-("pmd"t)$1970.01m;
                   `dtype pykw "datetime64[",@[("ns";"M";"D");t:type[x]-12],"]"]}
```

```q
q)print q2pydts datelist
['2000-12-11' '2000-01-15' '2000-02-02' '2003-08-16' '2002-04-24' '2000-03-22']
 
q)print q2pydts monthlist
['2000-12' '2002-02' '2003-12' '2000-12' '2003-11' '2000-07']

q)print q2pydts stamplist
['2003-06-28T17:26:01.260806768' '2002-08-17T16:36:35.216906816'
 '2003-11-07T05:38:53.870536832' '2001-06-26T18:10:48.896862568'
 '2000-09-11T21:28:21.496423780' '2002-05-11T13:56:52.890104944']
```


## How can I convert Python dates to q dates?

To convert these dates,

1.  Check the (`datetime64`) type
2.  Convert to q (as `int`)
3.  Adjust to the Unix epoch (1970.01.01) as appropriate for the precision

N.B. The Python date type can be extracted (and the precision determined) from the `dtype.name` attribute.


### Dates

```q
q)print pydates
['2000-12-11' '2000-01-15' '2000-02-02' '2003-08-16' '2002-04-24' '2000-03-22']
```

Check type/precision.

```q
q)pydates[`:dtype.name]`
"datetime64[D]"

q)pydates[`:dtype.name;`]11
"D"
```

Convert to q (as `int`).

```q
q)pydates[`:astype;"int64"]`
11302 10971 10989 12280 11801 11038
```

Adjust for the Unix epoch (as `date`).

```
q)(pydates[`:astype;"int64"]`)+1970.01.01
2000.12.11 2000.01.15 2000.02.02 2003.08.16 2002.04.24 2000.03.22
```


### Months

```q
q)print pymonths
['2000-12' '2002-02' '2003-12' '2000-12' '2003-11' '2000-07']
```

Check type/precision.

```q
q)pymonths[`:dtype.name]`
"datetime64[M]"

q)pymonths[`:dtype.name;`]11
"M"
```

Convert to q (as `int`).

```q
q)pymonths[`:astype;"int64"]`
371 385 407 371 406 366
```

Adjust for the Unix epoch (as `month`).

```q
q)(pymonths[`:astype;"int64"]`)+1970.01m
2000.12 2002.02 2003.12 2000.12 2003.11 2000.07m
```


### Timestamps

```q
q)print pystamps
['2003-06-28T17:26:01.260806768' '2002-08-17T16:36:35.216906816'
 '2003-11-07T05:38:53.870536832' '2001-06-26T18:10:48.896862568'
 '2000-09-11T21:28:21.496423780' '2002-05-11T13:56:52.890104944']
```

Check type/precision.

```q
q)pystamps[`:dtype.name]`
"datetime64[ns]"

q)pystamps[`:dtype.name;`]11
"n"
```

Convert to q (as `int`).

```q
q)pystamps[`:astype;"int64"]`
1056821161260806768 1029602195216906816 1068183533870536832 99357904889686256..
```

Adjust for the Unix epoch (as `timestamp`).

```q
q)(pystamps[`:astype;"int64"]`)+1970.01.01D0
2003.06.28D17:26:01.260806768 2002.08.17D16:36:35.216906816 2003.11.07D05:38:..
```


### `py2qdts`

The `py2qdts` function converts all three `datetime64` types to the equivalent q date type.
```q
py2qdts:{t$(x[`:astype;"int64"]`)+"j"$(t:"pmd" "nMD"?x[`:dtype.name;`]11)$1970.01m}
```

```q
q)py2qdts pydates
2000.12.11 2000.01.15 2000.02.02 2003.08.16 2002.04.24 2000.03.22

q)py2qdts pymonths
2000.12 2002.02 2003.12 2000.12 2003.11 2000.07m

q)py2qdts pystamps
2003.06.28D17:26:01.260806768 2002.08.17D16:36:35.216906816 2003.11.07D05:38:..
```

