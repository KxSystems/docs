---
title: Frequently-asked questions about embedPy
description: Frequently-asked questions about embedPy
keywords: dates, embedpy, interface, kdb+, pandas, python, q
---
# <i class="fab fa-python"></i> Frequently-asked questions about embedPy



## How can I convert between q tables and pandas DataFrames?

Using embedPy, we can directly convert between q tables to pandas Dataframes and vice-versa. This functionality is contained within the machine learning toolkit available [here](https://github.com/kxsystems/ml). The functions `.ml.tab2df` and `.ml.df2tab` control these conversions and are fully documented [here](../toolkit/utilities/util.md)


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

```q
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
