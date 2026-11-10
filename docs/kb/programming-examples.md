---
title: Programming examples – Knowledge Base – kdb+ and q documentation
description: Some examples of q programs to solve various problems
keywords: example, kdb+, programming, q
---
# Programming examples




## Send an HTTP request and parse the result into a table

[`.Q.hg`](../ref/dotq.md#hg-http-get) sends an HTTP GET request and returns the response body as a string. It handles proxy settings and decompresses a gzipped payload.

HTTPS requests need the OpenSSL libraries and a CA certificate file. See [SSL/TLS](ssl.md).

The following example downloads English Premier League results from [football-data.co.uk](https://www.football-data.co.uk/) and parses the CSV text into a table.

```q
q)data:.Q.hg ":https://football-data.co.uk/mmz4281/2425/E0.csv"
q)\z 1  / dates in the file are dd/mm/yyyy
q)3#t:(" DSSSIIS";enlist ",")0:data
Date       Time  HomeTeam   AwayTeam  FTHG FTAG FTR
---------------------------------------------------
2024.08.16 20:00 Man United Fulham    1    0    H
2024.08.17 12:30 Ipswich    Liverpool 0    2    A
2024.08.17 15:00 Arsenal    Wolves    2    0    H
```

The URL is a string, not a symbol literal, because a hyphen ends a symbol literal in q.

The CSV has over 100 columns. A type string with fewer characters than the file has columns loads only the leading columns. A space in the type string skips a column; the example skips the first, because the file starts with a byte-order mark.

The [`nasdaq.q` example in the KxSystems cookbook](https://github.com/KxSystems/cookbook/blob/master/nasdaq.q) :fontawesome-brands-github: queries the Nasdaq API and produces a table of daily trading information for a list of stocks during the last few days. The API needs no key. The list of stocks and the number of days are parameters of the function. A symbol the API doesn't know contributes no rows.

The function definition contains examples of:

- Date manipulation
- String creation and manipulation, with projections such as `ssr[;".";"-"]` and `except[;"$,"]`
- A lambda with typed parameters, projected and applied to each stock with `each`
- Sending an HTTPS request with `.Q.hg`
- Parsing JSON with `.j.k` into a list of dictionaries, which `select` queries as a table
- Building a table with a `select` that converts strings to dates, floats and longs
- Combining the per-stock tables with `raze`

Sample use:

```q
q)nasdaq[10;`GOOG`AMZN]
Date       Sym  Open    High     Low      Close  Volume
---------------------------------------------------------
2026.11.09 GOOG 290.545 294.69   285.94   286.01 24039970
2026.11.06 GOOG 283.415 289.22   283      283.93 24620200
2026.11.05 GOOG 291.805 293.6399 276.2    281.74 41149910
2026.11.04 GOOG 281.475 294.4    281.33   287.3  31709230
2026.11.03 GOOG 279.19  280.34   272      278.27 23372330
2026.11.02 GOOG 280.575 285.2099 277.78   278.04 29231780
2026.11.09 AMZN 269.32  275.34   266.91   266.93 51523180
2026.11.06 AMZN 259.81  264.182  258.53   259.3  42571530
...
```

## An efficient query to extract last n ticks for a particular stock from quote table

The quote table is defined as follows:

```q
q)quote: ([] stock:();time:();price())
```

For fast (constant-time) continuous queries on last _n_ ticks we have to maintain the data nested.
For our quote table, we define

```q
q)q: ([stock:()]time:();price:())
```

where, for each row, the columns `time` and `price` contain a list, rather than an atom
(i.e., the columns `time` and `price` are lists of lists). This table is populated as follows:

```q
q)q: select time, price by stock from quote
```

Now, to get the last 5 quotes for Google

```q
q)select -5#'time,-5#'price from q where stock=`GOOG
```

This query executes in constant time. If you want the quotes LIFO,

```q
q)select reverse each -5#'time, reverse each -5#'price from q where stock=`GOOG
```

This one is also constant-time.

!!! note "Those iterators…"

    Why do we use `each` and Each Both? Because the columns `time` and `price` are lists of lists, not lists of atoms.


## An efficient query to know on which days a symbol appears

Issuing a single select that covers a whole year would be too inefficient.
You could issue a separate select for each date, but if you are covering a year or two, the cumulative time quickly adds up.

The design of the following query is based on efficiency (both time and memory) on a large, parallel database.

A straightforward implementation of this query takes over a second per month.
The version shown here takes 50ms for a whole year.
(There will be an initial warm-up cost for a new q instance, but once it has been issued, queries with other symbols take 50ms).

```q
getDates:{[table;testSyms;startDate;endDate]
 symsByDate:select distinct sym by date from table[]where date within(startDate;endDate);
 firstSymList:exec first sym from symsByDate;
 val:(@[type[firstSymList]$;;`badCast]each(),testSyms)except`badCast;
 exec date from(select date,val{(x in y)|/}/:sym from symsByDate)where sym=1b}
```

Sample usage:

```q
q)getDates[`quote;`GOOG`AMZN;2005.01.01;2006.02.01]
```


## A function to convert a table into XML

```q
/given a value of type number, string or time, make an XML element with the type and the value
typedData:{
  typeOf:{(string`Number`String`Time)[0 10 13h bin neg type x]};
  "<data ss:type='" , (typeOf x) ,"'>",string[x],"</data>"}

/ wrap a value around a tag
tagit:{[tagname; v]
  tagname: string [tagname];
  "<",tagname,">", v,"</",tagname,">"};

/convert a table (of numbers, strings and time values) into xml

toxml:{
  f: {flip value flip x};
  colNames: enlist cols x;
  tagit[`worksheet]tagit[`table]raze(tagit[`row] raze tagit[`cell] each typedData each)each colNames,f x}
```

Sample usage:

```q
q)t
stock price
-----------
ibm   102
goog  103
q)toxml t
"<worksheet><table><row><cell><data ss:type='String'>stock</data></cell><cell..
```

The result looks as follows after some space is added by hand:

```xml
<worksheet>
<table>

<row>
<cell><data ss:type='String'>stock</data></cell>
<cell><data ss:type='String'>price</data></cell>
</row>

<row>
<cell><data ss:type='String'>ibm</data></cell>
<cell><data ss:type='Number'>102</data></cell>
</row>

<row>
<cell><data ss:type='String'>goog</data></cell>
<cell><data ss:type='Number'>103</data></cell>
</row>

</table>
</worksheet>
```


## Computing Bollinger bands

[Bollinger bands](https://en.wikipedia.org/wiki/Bollinger_Bands) :fontawesome-brands-wikipedia-w: consist of:

-   a middle band being a N-period simple moving average
-   an upper band at K times a N-period standard deviation above the middle band
-   a lower band at K times a N-period standard deviation below the middle band

Typical values for N and K are 20 and 2, respectively.

```q
bollingerBands: {[k;n;data]
      movingAvg: mavg[n;data];
      md: sqrt mavg[n;data*data]-movingAvg*movingAvg;
      movingAvg+/:(k*-1 0 1)*\:md}
```

The above definition makes sure nothing is calculated twice, compared to a more naïve version.

Sample usage:

```q
q)vals: 20 + (100?5.0)
q)vals
20.32759 21.56053 23.19912 24.08458 24.73181 22.88464 22.09355 22.54231 20.81..
q)bollingerBands[2;20] vals
20.32759 19.71112 19.34336 19.38947 19.53251 19.83184 19.90732 20.06612 19.74..
20.32759 20.94406 21.69575 22.29296 22.78073 22.79804 22.6974  22.67802 22.47..
20.32759 22.177   24.04813 25.19644 26.02894 25.76425 25.48749 25.28992 25.19..
```


## Parallel correlation of time series

Parallelism is achieved by the use of `peach`.

```q
k)comb:{(,!0){,/(|!#y),''y#\:1+x}/x+\\(y-x-:1)#1}
/ d - date
/ st, et - start time, end time
/ gt - granularity type `minute `second `hour ..
/ gi - granularity interval (for xbar)
/ s - symbols
pcorr:{[d;st;et;gt;gi;s]
    data:select last price by sym,gi xbar gt$time from trade where date=d,sym in s,time within(st,et);
    us:select distinct sym from data;
       ut:select distinct time from data;
    if[not(count data)=(count us)*count ut; / if there are data holes..
        filler:first 1#0#exec price from data;
        data:update price:fills price by sym from`time xasc(2!update price:filler from us cross ut),data;
        if[count ns:exec sym from data where time=st,null price;
            data:update price:reverse fills reverse price by sym from data where sym in ns]];
    PCORR::0!select avgp:avg price,devp:dev price,price by sym from data;
    data:(::);r:{.[pcorrcalc;;0]PCORR x}peach comb[2]count PCORR;PCORR::(::);r}

pcorrcalc:{[x;y]`sym0`sym1`co!(x[`sym];y[`sym];(avg[x[`price]*y[`price]]-x[`avgp]*y[`avgp])%x[`devp]*y[`devp])}

matrix:{ / convert output from pcorr to matrix
    u:asc value distinct exec sym0 from x; / sym0 has 1 more element than sym1!
    exec u#(value sym1)!co by value sym0 from x}
```

Sample usage:

```q
d:first daily.date;
st:10:00;
et:11:30;
gt:`second;
gi:10;
s:`GOOG`MSFT`AAPL`CSCO`IBM`INTL;
s:100#exec sym from `size xdesc select sym,size from daily where date=d;
show pcorr[d;st;et;gt;gi;s];
show matrix pcorr[d;st;et;gt;gi;s]
```
