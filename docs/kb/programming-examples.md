---
title: Programming examples
description: Some examples of q programs to solve various problems
keywords: example, kdb+, programming, q
---
# Programming examples




## HTTP client request and parse string result into a table

Q has a built-in HTTP request command, which follows the syntax

```q
`:http://host:port "string to send as HTTP method etc"
```

The string-to-send can be anything within the HTTP protocol the HTTP server will understand.  
<i class="far fa-hand-point-right"></i> [jmarshall.com/easy/http](http://www.jmarshall.com/easy/http)

Kdb+ does not add to nor encode the string to send, and as it does not support ‘chunking’ you should specify HTTP 1.0 for your desired HTTP procotol. Kdb+ will signal a `'chunk error` if it encounters a chunked response – not possible with HTTP 1.0. Kdb+ doesn’t decode the response – it just returns the raw data. 

```q
q)/ string to send
q)s2s:"GET /mmz4281/1314/E0.csv HTTP/1.0\r\nhost:www.football-data.co.uk\r\n\r\n"
q)data:(`$":http://www.football-data.co.uk") s2s
q)(" SSSIIIIII IIIIIIIIIIII"; ",")0:data
```

<i class="fab fa-github"></i> [KxSystems/cookbook/yahoo.q](https://github.com/KxSystems/cookbook/blob/master/yahoo.q)

This example function queries Yahoo Financials and produces a table of trading info for a list of stocks during the last few days. 
The list of stocks and the number of days are parameters of the function.

The function definition contains examples of:

-   date manipulation
-   string creation, manipulation and pattern matching
-   do loops
-   sending HTTP requests to an HTTP server
-   parsing tables from strings
-   queries with user-defined functions
-   parsing dates from strings

Sample use:

```q
q)yahoo[10;`GOOG`AMZN]
Date       Open   High   Low    Close  Volume   Sym
----------------------------------------------------
2006.08.21 28.7   28.98  27.97  28.13  5334900  AMZN
2006.08.21 378.1  379    375.22 377.3  4023300  GOOG
2006.08.22 28.14  28.89  28.05  28.37  4587100  AMZN
2006.08.22 377.73 379.26 374.84 378.29 4164100  GOOG
2006.08.23 28.56  28.89  27.77  28.14  4726400  AMZN
2006.08.23 377.64 378.27 372.66 373.43 3642300  GOOG
...
```

The above function definition has been adapted from a more compact one by Simon Garland. 
The long version adds comments, renames variables, and splits computations into smaller steps so that the code is easier to follow.  
Compact version: <i class="fab fa-github"></i> [KxSystems/cookbook/yahoo_compact.q](https://github.com/KxSystems/cookbook/blob/master/yahoo_compact.q)


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

/convert a table (of numbers, strings and time vaues) into xml

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

[Bollinger bands](http://wikipedia.org/wiki/bollinger_bands) <i class="fab fa-wikipedia-w"></i> consist of:

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
