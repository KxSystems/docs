---
title: The C# interface to kdb+ – Interfaces – kdb+ and q documentation
description: How to connect a C# program to a kdb+ server process
keywords: api, c#, c sharp, interface, kdb+, library, q
---
# C&#035;


:fontawesome-brands-github: 
[KxSystems/csharpkdb](https://github.com/KxSystems/csharpkdb) 

The C\# interface to kdb+ is implemented in the `c` class, which implements the protocol to interact with a kdb+ server. 
The interface closely resembles that for [interfacing with Java](java-client-for-q.md).

Instances may be constructed with one of the following constructors:

<div class="kx-compact" markdown="1">

| signature                                                     | notes                                                                                                                                    |
|---------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|
| `public c(string host, int port, string usernameAndPassword)` | Throws `Exception("access")` if access is denied by the q server. The username and password should be of the format username:password |
| `public c(string host, int port)`                             | Throws `Exception("access")` if access is denied by the q server. Uses `Environment.!UserName` as the login name and password             |

</div>

It is important to close the `c` object explicitly, via the `Close` method, when we are finished with the connection to a kdb+ server.

The class provides a number of other features explored in the following sections.


## Utility class for q types

Within the `c` class are a number of utility classes provided which match the available types in q that do not map directly to standard classes such as Integer. 
In general these classes have all their fields declared with public access, and several provide custom `toString()` methods to decode the data payload.

<div class="kx-compact" markdown="1">

| class  | members                    | methods                          | notes                                                                                                     |
|--------|----------------------------|----------------------------------|-----------------------------------------------------------------------------------------------------------|
| Dict   | object x; object y         | `int find(string[] x, string y)` |                                                                                                           |
| Flip   | string\[\] x, object\[\] y | `public object at(string s)`     |                                                                                                           |
| Month  | int i                      | `string ToString()`              | Provides `ToString()` to decode the i field                                                                 |
| Minute | int i                      | `string ToString()`              | Provides `ToString()` to decode the i field                                                                 |
| Second | int i                      | `string ToString()`              | Provides `ToString()` to decode the i field                                                                 |
| Date   | int i                      | `string ToString()`              | Provides `ToString()` to decode the i field. Provides constructors which decode from int, long and DateTime |

</div>


## Creating null values

For each type character, we can get a reference to a null q value by indexing into the NU Object array using the `NULL` utility method. 
Note that the q null values are not the same as C\#’s null.

An example of creating an object array containing two null q integers:

```c#
#!text/x-c++src
object[] twoNullIntegers = {NULL('i'), NULL('i')};
```

The q null values are mapped to C\# values according to the following table:

<div class="kx-compact" markdown="1">

q type    | q null accessor | C\# null 
----------|-------------|----------------------------
Boolean   | `NULL('b')` | `false`                    
Guid      | `NULL('g')` | `Guid.Empty`               
Byte      | `NULL('x')` | `(byte)0`                  
Short     | `NULL('h')` | `Int16.MinValue`           
Integer   | `NULL('i')` | `Int32.MinValue`           
Long      | `NULL('j')` | `Int64.MinValue`           
Float     | `NULL('e')` | `(Single)Double.NaN`       
Double    | `NULL('f')` | `Double.NaN`               
Character | `NULL('c')` | `' '`                      
String    | `NULL('s')` | `""`                       
Timestamp | `NULL('p')` | `DateTime(0)`              
Month     | `NULL('m')` | `Month(Int32.!MinValue)`   
Date      | `NULL('d')` | `Date(Int32.!MinValue)`    
DateTime  | `NULL('z')` | `DateTime(0)`              
TimeSpan  | `NULL('n')` | `TimeSpan(Int32.!MinValue)`
Minute    | `NULL('u')` | `Minute(Int32.!MinValue)`  
Second    | `NULL('v')` | `Second(Int32.!MinValue)`  
Time      | `NULL('t')` | `TimeSpan(Int64.!MinValue)`

</div>

We can check whether a given Object x is a q null using the `c` utility method:

```c#
#!text/x-c++src
public static bool qn(object x);
```


## Q types of C\# objects

For reference, internally, types are mapped as follows for atoms:

<div class="kx-compact" markdown="1">

| C\# object type | q type number |
|-----------------|------------------|
| bool            | -1               |
| byte            | -4               |
| short           | -5               |
| int             | -6               |
| long            | -7               |
| float           | -8               |
| double          | -9               |
| char            | -10              |
| string          | -11              |
| \*DateTime      | -12              |
| Month           | -13              |
| Date            | -14              |
| \*DateTime      | -15              |
| \*TimeSpan      | -16              |
| Minute          | -17              |
| Second          | -18              |
| \*TimeSpan      | -19              |

</div>

and the following for complex data:

<div class="kx-compact" markdown="1">

C\# object type | q type number
----------------|--------------
object\[\]      | 0            
bool\[\]        | 1            
byte\[\]        | 4            
short\[\]       | 5            
int\[\]         | 6            
long\[\]        | 7            
float\[\]       | 8            
double\[\]      | 9            
char\[\]        | 10           
String\[\]      | 11           
\*DateTime\[\]  | 12           
Month\[\]       | 13           
Date\[\]        | 14           
\*DateTime\[\]  | 15           
\*TimeSpan\[\]  | 16           
Minute\[\]      | 17           
Second\[\]      | 18           
\*TimeSpan\[\]  | 19           
Flip            | 98           
Dict            | 99           

</div>

!!! note "DateTime and Timespan"

    With the introduction of the new time types (timespan, timestamp) the C\# driver evolved to remap these, 
    hence it can no longer write q datetime/time: it writes timestamp and timespan. 
    However, this can be handled by e.g. casting the resulting timestamp to a datetime on the server side if such compatibility is required.

The default return value for all other objects is 0.


## Interacting with kdb+ via an open `c` instance

Interacting with the kdb+ server is very simple. 
You must make a basic choice between sending a message to the server where you expect no answer, 
or will check later for an answer.

In the first case, where we will not wait for a response, use the `ks` method on a `c` instance:

```c#
public void ks(String s)
public void ks(String s,Object x)
public void ks(String s,Object x,Object y)
```

Alternatively, should we expect an immediate response, use the `k` method:

```c#
public object k(object x)
public object k(string s)
public object k(string s,object x)
public object k(string s,object x,object y)
public object k(string s,object x,object y,object z)
```

The parameters to methods `k` and `ks`, and its result, are arbitrarily-nested arrays (Integer, Double, int\[\], DateTime, etc). 
If you need to pass more than 3 arguments, you should put them in list(s).

As a special case of the `k` method, we may receive a message from the server without sending any message as an argument:

```c#
public object k()
```


## Accessing items of arrays

We can access elements using the `at` method:

```c#
public static object at(object x,int i) // Returns the object at x\[i\] or null 
```

and set them with `set`:

```c#
public static void set(object x,int i,object y) // Set x\[i\] to y, or the appropriate q null value if y is null 
```


## Bulk transfers

A kdb+tick feed handler can send one record at a time, like this

```c#
#!text/x-c++src
Object[] row = {"ibm", new Double(93.5), new Integer(300)};
c.ks(".u.upd", "trade", row);
```

or send many records at a time:

```c#
#!text/x-c++src
int n = 100;
Object[] rows = {new String[n], new double[n], new int[n]};
for(int i=0; i<n ; i++) {
   rows[0][i] = ...;
   ...
}
c.ks(".u.upd", "trade", rows);
```

This example assumes rows with three fields, symbol, price and size.


## Exceptions

The `c` class throws exceptions of C\# class Exceptions both for typical socket read/write reasons and in higher level cases; 
that is, errors at the q level rather than the Socket level.


## Examples

### Simple query

This connects to a q process, creates a table to query, selects all rows from that table and prints the output as CSV to the console.

```c#
using System;
using System.IO;
using System.Net.Sockets;
using kx;

public class Query{
  public static void Main(string[]args){
    c c=new c("localhost",5001,"username:password");
    c.ks("mytable:([]sym:10?`1;time:.z.p+til 10;price:10?100.;size:10?1000)"); // create example table using async msg (c.ks)
    Object result=c.k("select from mytable"); // query the table using a sync msg (c.k)
    // A flip is a table. A keyed table is a dictionary where the key and value are both flips.
    c.Flip flip=c.td(result); // if the result set is a keyed table, this removes the key. 
    int nRows=c.n(flip.y[0]); // flip.y is an array of columns. Get the number of rows from the first column.
    int nColumns=c.n(flip.x); // flip.x is an array of column names
    Console.WriteLine("Number of columns: "+c.n(flip.x));
    Console.WriteLine("Number of rows:    "+nRows);
    for(int column=0;column<nColumns;column++)
      System.Console.Write((column>0?",":"")+flip.x[column]);
    System.Console.WriteLine();
    for(int row=0;row<nRows;row++){
      for(int column=0;column<nColumns;column++)
        System.Console.Write((column>0?",":"")+c.at(flip.y[column],row)); // c.at extracts the cell from column,row.
      System.Console.WriteLine();
    }
    c.Close();
  }
}
```


### Simple insert

This connects to a q process, creates a table to insert into, and then inserts a single row to that table.

```c#
using System;
using System.IO;
using System.Net.Sockets;
using kx;
public class Insert{
  public static void Main(string[]args){
    c c=new c("localhost",5001,"username:password");
    c.ks("mytrade:([]time:();sym:();price:();size:())"); // create an empty dummy table which we will insert into
    object[]x=new object[4];
    x[0]=DateTime.Now.TimeOfDay;
    x[1]="abc";
    x[2]=(double)93.5;
    x[3]=300;
    c.k("insert","mytrade",x);
    c.Close();
  }
}
```


### Simple bulk insert

This connects to a q process, creates a table to insert into, and then inserts 1024 rows to that table.

```c#
using System;
using System.IO;
using System.Net.Sockets;
using kx;
public class BulkInsert{
  public static void Main(string[]args){
    Random rnd=new Random();
    string[] syms=new string[]{"abc","def","ghi","jki"};
    c c=new c("localhost",5001,"username:password");
    c.ks("mytrade:([]time:();sym:();price:();size:())");
    object[]x=new object[4];
    System.TimeSpan[] time=new System.TimeSpan[1024];
    string[]sym=new string[1024];
    double[]price=new double[1024];
    int[]size=new int[1024];
    for(int i=0;i<1024;i++){
      time[i]=DateTime.Now.TimeOfDay;
      sym[i]=syms[rnd.Next(0,syms.Length)];
      price[i]=(double)rnd.Next(0,200);
      size[i]=100*rnd.Next(1,10);
    }
    x[0]=time;
    x[1]=sym;
    x[2]=price;
    x[3]=size;
    c.k("insert","mytrade",x);
    c.Close();
  }
}
```


### Simple subscriber

This code subscribes to a ticker plant, and prints updates to the console as they are received.

```c#
using System;
using System.IO;
using System.Net.Sockets;
using kx;

public class Subscriber{
  public static void Main(string[]args){
    c c=null;
    try{
      c=new c("localhost",5001,"username:password");
      c.k("sub[`trade;`MSFT.O`IBM.N]");
      while(true){
        object result=c.k();
        c.Flip flip=c.td(result);
        int nRows=c.n(flip.y[0]);
        int nColumns=c.n(flip.x);
        for(int row=0;row<nRows;row++){
          for(int column=0;column<nColumns;column++)
            System.Console.Write((column>0?",":"")+c.at(flip.y[column],row));
          System.Console.WriteLine();
        }
      }
    }
    finally{
      if(c!=null)c.Close();
    }
  }
}
```

