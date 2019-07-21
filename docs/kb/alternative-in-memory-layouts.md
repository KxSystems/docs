---
title: Alternative in-memory layouts
description: Prior to kdb+ some schemas used nested data per symbol. The g# attribute allowed us to move away from those more complicated designs and queries to long flat tables with fast access via the group attribute. There is however a third layout for in-memory data, using a dictionary of symbols!tables, which might be relevant to your particular use case.
keywords: attribute, group, kdb+, memory, nyse, q, taq
---
# Alternative in-memory layouts





Prior to kdb+, as veterans will remember, some schemas used nested data per symbol. The `` `g#`` attribute allowed us to move away from those more complicated designs and queries to long flat tables with fast access via the group attribute. 

There is however a third layout for in-memory data, using a dictionary of symbols!tables, which might be relevant to your particular use case.

```q
q)/Load some dummy data from nyse taq
q)/and store as symbols!tables to demonstrate in-memory usage
q)\ts t:(`u#sym)!{[x;y]update time:`s#time from select from x where sym=y}[select from trade where date=last date;]each sym
3896 4346890128

q)count each t / simple count per sym
A      | 14195
AA     | 88962
AA.PR  | 25
AADR   | 13
AAIT   | 8
AAL    | 42609
AALC.P | 392
AAMC   | 711
AAME   | 154
AAN    | 6698
...

q)sum count each t / total row count for trades
30035729

q)meta t`GOOG / to get GOOG trade, we just do t`GOOG
c    | t f a
-----| -----
date | d    
sym  | s    
time | t   s
ex   | c    
cond | C    
size | i    
price| e    
stop | b    
corr | i    
seq  | j    
cts  | c    
trf  | c    

q)last each t`GOOG`CSCO / get last trades 
date       sym  time         ex cond   size price  stop corr seq     cts trf
----------------------------------------------------------------------------
2014.01.15 GOOG 19:56:10.575 D  "@ TI" 78   1146.5 0    0    2279567 N   Q  
2014.01.15 CSCO 19:47:39.458 P  "@FTI" 37   22.8   0    0    2180880 N      

q)(t[`GOOG`CSCO])asof\:(enlist`time)!enlist 09:30t / last trade for GOOG and CSCO  as of 09:30
date       sym  ex cond   size price   stop corr seq   cts trf
--------------------------------------------------------------
2014.01.15 GOOG Q  "@FTI" 50   1152.01 0    0    5831  N      
2014.01.15 CSCO Q  "T   " 1268 22.53   0    0    14380 N      
etc.

q)\ts last each value t / last trade for every symbol
11 3165104

q)/ vwap for whole day for all symbols in 5 minute bins
q)\ts raze {0!select first sym,size wavg price by 5 xbar time.minute from x} each value t 
942 21631792

q)/ Use multiple slave threads for queries! e.g. using 4 threads - almost linear scaling.
q)\ts raze {0!select first sym,size wavg price by 5 xbar time.minute from x} peach value t 
269 21002352

q)/ vwaps for a selection of symbols
q)sym where sym like "GO*"
`GOF`GOGO`GOL`GOLD`GOM`GOMO`GOOD`GOOD.N`GOOD.O`GOOD.P`GOOG`GORO`GOV`GOVT
q)\ts raze {0!select first sym,size wavg price by 5 xbar time.minute from x} peach t sym where sym like "GO*"
1 9776

q)/ Set default schema
q)t:(`u#enlist`)!enlist flip`time`sym`price`size!(`s#`timespan$();`symbol$();`float$();`int$())
q)t`BADSYM / non-existent symbol lookup uses prototype from first element of dict
time sym price size
-------------------

q)/ upd function for rdb to receive data from ticker plant and upsert into dicts of syms!tables. 
q)/ Allows log file playback by creating flips from value list.
q)upd:{[t;d]if[not type d;d:flip(cols value[t]`)!d;];@[t;key g;,;d value g:group d`sym];}

q)/ end-of-day persist to hdb
q)\ts trade:raze t asc key[t] except ` / re-organize data to flat layout, dropping the ` entry
426 1477313216
q).Q.dpft[`:db;2007.07.23;`sym;`trade] / save the re-organized flat layout

q)/ At end of day, if you're short on memory and need to avoid going 
q)/ through the above for flat layout to save, you can do the following
q)/ primeSym get the unique vector of symbols used across the tables, 
q)/ and verifies that they all exist in path/sym file
q)primeSym:{[path;dict](` sv path,`sym)?{distinct x,{distinct x,distinct y}/[(enlist 0#`),y where 11h=type each y:value flip y]}/[(enlist 0#`),value dict];}
q)/ dpfdot saves each table enumerating and appending them to disk one table at a time.
q)dpfdot:{[d;p;f;tname]t:value tname;primeSym[d;t];t:k!t k iasc k:key t;{[d;t;colnames]@[d;colnames;;]'[@[count[t]#(,);0;:;:];{$[11h=type x;`sym?x;x]}each t@\:colnames];}[d:.Q.par[d;p;tname];value t]each colnames:cols first t;@[;f;`p#]@[d;`.d;:;f,colnames except f];}
q)\ts dpfdot[`:db;2014.01.14;`sym;`t] / t is a dict of tables, i.e. syms!tables. 30 MM trades, 7869 syms, saved to ssd
3444 179274224
```

<i class="far fa-hand-point-right"></i> 
[above transcript](assets/alternative-in-memory-layouts.log) in full window

