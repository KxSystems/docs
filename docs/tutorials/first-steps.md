Kdb+ is a powerful database that can be used for streaming, real-time and historical data. Q is the SQL-like general purpose programming language built on top of kdb+ that offers high-performance, in-database analytic capabilities.

<i class="far fa-hand-point-right"></i> [Get started](/learn) to download and install q


## Launch q

At the shell prompt, type `q` to start a q console session, where the prompt `q)` will appear.
```bash
$ q
q)
```


## Create a table

To begin learning q, we will create a simple table. To do this please type or copy the below code into your q session. Make sure you remove the leading q) from these code snippets.
```q
q)n:1000000;
q)item:`apple`banana`orange`pear;
q)city:`beijing`chicago`london`paris;
q)tab:([]time:asc n?0D0;n?item;amount:n?100;n?city);
```
This code creates a table called `tab` which contains a million rows and 4 columns of random time-series sales data. For now, understanding these lines of code is not important.


## Simple query

The first query we run selects all rows from the table where the item sold is a banana.
```q
q)select from tab where item=`banana                                            
time                 item   amount city   
------------------------------------------
0D00:00:00.466201454 banana 31     london 
0D00:00:00.712388008 banana 86     london 
0D00:00:00.952962040 banana 20     london 
0D00:00:01.036425679 banana 49     chicago
0D00:00:01.254006475 banana 94     beijing
..
```
Note that all columns in the table are returned in the result when there is no column explicitly mentioned.


## Aggregate query

The next query will calculate the sum of the amounts sold of all items by each city.
```q
q)select sum amount by city from tab                                            
city   | amount  
-------| --------
beijing| 12398569
chicago| 12317015
london | 12375412
paris  | 12421447
```
This uses the aggregate function `sum` within the q language. Please note that this returns a keyed table where the key column is `city`. This key column is automatically returned in alphabetical order.


## Time-series aggregate query

The following query shows the sum of the amount of each item sold by hour during the day.
```q
q)select sum amount by time.hh,item from tab                                    
hh item  | amount
---------| ------
0  apple | 522704
0  banana| 506947
0  orange| 503054
0  pear  | 515212
1  apple | 513723
..
```
The result is a keyed table with two key columns, `hh` for the hour and `item`. The results are ordered by the keyed columns. This query extracts the hour portion from the nanosecond-precision time column by adding a `.hh` to the column name.

Congratulations, you have now successfully created and queried your first q table!

