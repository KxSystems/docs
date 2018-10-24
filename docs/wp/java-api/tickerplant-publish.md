# Tickerplant publishing



Publishing data to a tickerplant is almost always a necessity for a kdb+
feed-handler process. Java, as a common language of choice for
third-party API development (e.g. Reuters, Bloomberg, MarkIT), is a popular language for feedhandler development, within which `c.java` is
used to handle the asynchronous invocation of a publishing function.


## Publishing rows 

In general, publishing values to a tickerplant will require an
asynchronous query much like the following:
```java
qConnection.ks(".u.upd", "trade", data); //Where data is an Object[]
```
The parameters for this can be defined as follows:

The update function name (`.u.upd`) 

: This is the function executed on the tickerplant which enables the data insertion. As per the norm with this API, this is passed as a string.

Table name

: A String representation of the name of the table that receives the data.

Data

: An Object that will form the row(s) to be appended to the table. This parameter is typically passed as an object array, each index representing a table column.

In order to publish a single row to a tickerplant, typed arrays
consisting of single values might be instantiated. These are then
encapsulated in an Object array and passed to the `ks` method:


Example: `TickPublisherExamples.java`
```java
//Create typed arrays for holding data
String[] sym = new String[] {"IBM"};
double[] bid = new double[] {100.25};
double[] ask = new double[] {100.26};
int[] bSize = new int[]{1000};
int[] aSize = new int[]{1000};
//Create Object[] for holding typed arrays
Object[] data = new Object[] {sym, bid, ask, bSize, aSize};
//Call .u.upd asynchronously
qConnection.ks(".u.upd", "quote", data);
```
Publishing multiple rows is then just a case of increased length of each
of the typed arrays:


Example: `TickPublisherExamples.java`
```java
String[] sym = new String[] {"IBM", "GE"};
double[] bid = new double[] {100.25, 120.25};
double[] ask = new double[] {100.26, 120.26};
int[] bSize = new int[]{1000, 2000};
int[] aSize = new int[]{1000, 2000};
```
In order to maximize tickerplant throughput and efficiency, it is
generally recommended to publish multiple rows in one go. 

<i class="fa fa-hand-o-right"></i> whitepaper [_Kdb+tick Profiling for Throughput Optimization_](/wp/kdbtick_profiling_for_throughput_optimization.pdf).

Care has to be taken here to ensure that all typed arrays maintain
the same length, as failure to do so will likely result in a kdb+
type error. Such errors are especially troublesome when using
asynchronous methods, which will not return `KExceptions` in the same
manner as sync methods! It is also worth noting that the order of the
typed arrays within the object array should match that of the table
schema.


## Adding a timespan column

It is standard tickerplant functionality to append a timespan column to
each row received from a feed handler if not included with the data
passed, which is used to record when the data was received by the
tickerplant. It’s possible for the publisher to create the timespan
column to prevent the tickerplant from adding one:


Example: `TickPublisherExamples.java`
```java
//Timespan can be added here
c.Timespan[] time = new c.Timespan[] {new c.Timespan()};
String[] sym = new String[] {"GS"};
double[] bid = new double[] {100.25};
double[] ask = new double[] {100.26};
int[] bSize = new int[]{1000};
int[] aSize = new int[]{1000};
//Timespan array is then added at beginning of Object array
Object[] data = new Object[] {time, sym, bid, ask, bSize, aSize};
qConnection.ks(".u.upd", "quote", data);
```
This might be done, for example, to allow the feedhandler to define the
time differently than simply logging the time at which the tickerplant
receives the data.


