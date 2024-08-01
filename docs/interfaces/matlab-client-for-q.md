---
title: Working with MATLAB | Interfaces | kdb+ and q documentation
description: How connect a MATLAB client program to a kdb+ server process
---
# Working with MATLAB

## Installation

!!! note "Versions"

    As MATLAB/datafeed toolbox evolves features or instruction below are subject to revisions. Please refer to toolbox documentation for latest version.
    Users have reported that this works with more recent versions (e.g. R2015b on RHEL 6.8/2016b and 2017a on macOS).

    See also community-supported native connector :fontawesome-brands-github: [dmarienko/kdbml](https://github.com/dmarienko/kdbml)


=== "MATLAB R2021a and later"

    Download and unzip [kx_kdbplus.zip](https://uk.mathworks.com/matlabcentral/answers/864350-trading-toolbox-functionality-for-kx-systems-inc-kdb-in-matlab-r2021a-and-later).
    Add the resulting directory to your [MATLAB path](https://uk.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html), for example in MATLAB
    ```matlab
    >> addpath('/Users/Developer/matlabkx')
    ```

=== "MATLAB prior to R2021a"

    Support for MATLAB is a part of [Datafeed Toolbox for MATLAB](https://uk.mathworks.com/help/releases/R2020b/datafeed/kx-systems-inc-.html): since R2007a edition.

The MATLAB integration depends on the two Java files `c.jar` and `jdbc.jar`. 

:fontawesome-brands-github: 
[KxSystems/kdb/c/c.jar](https://github.com/KxSystems/kdb/blob/master/c/c.jar)  
:fontawesome-brands-github: 
[KxSystems/kdb/c/jdbc.jar](https://github.com/KxSystems/kdb/blob/master/c/jdbc.jar)

Add the JAR files to the classpath used by MATLAB. It can be added permanently by editing `classpath.txt` (type `edit classpath.txt` at the MATLAB prompt) or for the duration of a particular session using the `javaaddpath` function, for example

```matlab
>> javaaddpath /home/myusername/jdbc.jar
>> javaaddpath /home/myusername/c.jar
```

!!! note "Installation directory"

    In these examples change `/home/myusername` to the directory where `jdbc.jar` and `c.jar` are installed.

Alternatively, this can be achieved in a MATLAB source file (i.e., \*.m file) adding the following two functions before calling `kx` functions.

```matlab
javaaddpath('/home/myusername/jdbc.jar')
javaaddpath('/home/myusername/c.jar')
```

Confirm they have been added successfully using the `javaclasspath` function.

```matlab
>> javaclasspath
    STATIC JAVA PATH
...
    /opt/matlab/2015b/java/jar/toolbox/stats.jar
    /opt/matlab/2015b/java/jar/toolbox/symbol.jar

    DYNAMIC JAVA PATH

    /home/myusername/jdbc.jar
    /home/myusername/c.jar
>>
```

## Connecting to a q process

First, we start up a kdb+ process that we wish to communicate with from MATLAB and load some sample data into it.
Save following as `tradedata.q` file

```q
/ List of securities
seclist:([name:`ACME`ABC`DEF`XYZ]
 market:`US`UK`JP`US)

/ Distinct list of securities
secs: distinct exec name from seclist

n:5000
/ Data table
trade:([]sec:`seclist$n?secs;price:n?100.0;volume:100*10+n?20;exchange:5+n?2.0;date:2004.01.01+n?499)

/ Intra day tick data table
intraday:([]sec:`seclist$n?secs;price:n?100.0;volume:100*10+n?20;exchange:5+n?2.0;time:08:00:00.0+n?43200000)

/ Function with one input parameter
/ Return total trading volume for given security
totalvolume:{[stock] select volume from trade where sec = stock}

/ Function with two input parameters
/ Return total trading volume for given security with volume greate than 
/ given value
totalvolume2:{[stock;minvolume] select sum(volume) from trade where sec = stock, volume > minvolume}
```

Then

```bash
q tradedata.q -p 5001
```

```q
q)show trade
sec  price    volume exchange date
----------------------------------------
ACME 89.5897  1300   6.58303  2005.04.26
ABC  4.346879 2000   5.957694 2004.03.08
DEF  2.486644 1000   5.304114 2004.03.18
ACME 42.26209 1600   5.31383  2004.03.14
DEF  67.79352 2500   5.954478 2004.04.21
DEF  85.56155 1300   6.462338 2004.03.15
ACME 52.65432 1800   5.240313 2005.02.05
ABC  22.43142 2700   5.088007 2005.03.13
ABC  58.26731 2100   5.220929 2004.09.10
XYZ  74.14568 2900   5.075229 2004.08.24
DEF  35.67741 1500   6.064387 2004.03.12
DEF  30.37496 1300   5.025874 2004.03.24
ABC  20.30781 1000   6.642873 2005.02.02
DEF  2.984627 1200   6.346634 2004.12.15
ACME 28.80098 2100   5.591732 2004.09.19
DEF  45.20084 2800   5.481197 2004.08.01
DEF  29.25037 1000   6.065474 2005.02.05
XYZ  50.68805 1700   6.901464 2004.11.02
DEF  41.79832 2300   6.016484 2005.05.04
XYZ  13.64856 2900   6.435824 2005.04.03
..
q)
```

We then start a new MATLAB session. From here on, `>>` represents the MATLAB prompt.

We’re now ready to open a connection to the q process:

```matlab
>> q = kx('localhost',5001)

q =

       handle: [1x1 c]
    ipaddress: 'localhost'
         port: 5001
```

!!! tip "Credentials"

    We can also pass a username:password string as the third parameter to the `kx` function if it is required to log in to the q process.

The `q` value is a normal MATLAB object and we can inspect the listed properties. We’ll use this value in all our communications with the q process. 

We close a connection using the `close` function:

```matlab
>> close(q)
```

!!! warning "Installation errors"

    If there is a problem with either the installation of the q integration, or the jar file is not found, we’ll get an error along the lines of:
    
    ```matlab
    ??? Undefined function or method 'c' for input arguments of type 'char'.
    
    Error in ==> kx.kx at 51
        w.handle = c(ip,p);
    ```

    Or if the socket is not currently connected then any future communications will result in an error like:

    ```matlab
    ??? Java exception occurred:
    java.net.SocketException: Socket closed

        at java.net.SocketOutputStream.socketWrite(Unknown Source)
        at java.net.SocketOutputStream.write(Unknown Source)
        at c.w(c.java:99)
        at c.k(c.java:107)
        at c.k(c.java:108)

    Error in ==> kx.fetch at 65
        t = c.handle.k(varargin{1});
    ```


## Using the kdb+ process

It is typical to perform basic interactions with a database using the `fetch` function via a connected handle. For example in a legacy database we might perform this:

```matlab
x = fetch(q,'select * from tablename')
```

We can use this function to perform basic interaction with kdb+, where we expect a value to be returned. This need not be a query but in fact can be general chunks of code. Using q as a calculator, we can compute the average of 0 to 999.

```matlab
>> fetch(q,'avg til 1000')

ans =

  499.5000
```


## Fetching data from kdb+

The `fetch` function can be used to get q data such as lists, as well as tables. Given the list `c`:

```q
q)c:((til 100);(til 100))
q)c
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 ..
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 ..
```

Then we can fetch it:

```matlab
>> hundreds = fetch(q, 'c')

hundreds =

  java.lang.Object[]:

    [100×1 int64]
    [100×1 int64]
```

We can use the [`cell`](https://uk.mathworks.com/help/matlab/ref/cell.html) function to strip the Java array wrapper away:

```matlab
>> hundreds_as_cell = cell(hundreds)

hundreds_as_cell =

  2×1 cell array

    {100×1 int64}
    {100×1 int64}
```

Tables are returned as an object with an array property for each column. Taking the first 10 rows of the `trade` table as an example:

```q
q)10#trade
sec  price    volume exchange date
----------------------------------------
ACME 89.5897  1300   6.58303  2005.04.26
ABC  4.346879 2000   5.957694 2004.03.08
DEF  2.486644 1000   5.304114 2004.03.18
ACME 42.26209 1600   5.31383  2004.03.14
DEF  67.79352 2500   5.954478 2004.04.21
DEF  85.56155 1300   6.462338 2004.03.15
ACME 52.65432 1800   5.240313 2005.02.05
ABC  22.43142 2700   5.088007 2005.03.13
ABC  58.26731 2100   5.220929 2004.09.10
XYZ  74.14568 2900   5.075229 2004.08.24
```

Will be returned in MATLAB:

```matlab
>> ten = fetch(q, '10#trade')

ten =

         sec: {10×1 cell}
       price: [10×1 double]
      volume: [10×1 int64]
    exchange: [10×1 double]
        date: [10×1 double]
```

With suitable computation in q, we can return data suitable for immediate plotting. Here we compute a 10-item moving average over the `` `ACME `` prices:

```q
q)mavg[10;exec price from trade where sec=`ACME]
89.5897 65.9259 61.50204 53.32677 54.74408 57.39743 57.15958 62.33525 56.8732..
```
```matlab
>> acme = fetch(q,'mavg[10;exec price from trade where sec=`ACME]')
```


## Metadata

The q integration in MATLAB provides the `tables` meta function.

```matlab
>> tables(q)

ans =

    'intraday'
    'seclist'
    'trade'
```

The experienced q user can use the [`\v`](../basics/syscmds.md#v-variables) command to see all values in the directory:

```matlab
>> fetch(q,'\v')

ans =

    'a'
    'b'
    'c'
    'intraday'
    'n'
    'seclist'
    'secs'
    'trade'
```


## Sending data to q

We can use the `fetch` function to cause side effects in the kdb+ process, such as inserting data into a table.

Given a table `b`:

```q
q)b:([] a:1 2; b:1 2)
q)b
a b
---
1 1
2 2
```

Then we can add a row like this:

```matlab
>> fetch(q,'b,:(3;3)')

ans =

     []
```

and, sure enough, on the q side we see the new data:

```q
q)show b
a b
---
1 1
2 2
3 3
```

The q integration also provides an `insert` function: this takes an array of items in the row and may be more convenient for certain purposes.

```matlab
>> insert(q,'b',{4,4})
```

shows on the q side as:

```q
q)show b
a b
---
1 1
2 2
3 3
4 4
```

A more complicated row shows the potential advantage to better effect:

```matlab
>> insert(q,'trade',{'`ACME',100.45,400,.0453,'2005.04.28'})
```

Be warned though, that errors will not be detected very well. For example the following expression silently fails!

```matlab
>> insert(q,'b',{1,2,3})
```

whereas the equivalent `fetch` call provokes an error:

```matlab
>> fetch(q,'b,:(1;2;3)')
Error using fetch (line 64)
Java exception occurred:
kx.c$KException: length
	at kx.c.k(c.java:110)
	at kx.c.k(c.java:111)
	at kx.c.k(c.java:112)
```

## Async commands to q

The `exec` function is used for sending asynchronous commands to q; ones we do not expect a response to, and which may be performed in the background while we continue interacting with the MATLAB process.

Here we establish a large-ish data structure in the kdb+ process:

```matlab
>> exec(q,'big_data:10000000?100')
```

Then we take the average of the data, delete it from the namespace and close the connection:

```matlab
>> fetch(q,'avg big_data')

ans =

   49.4976

>> exec(q,'delete big_data from `.')
>> close(q)
```

## Handling null

kdb+ has the ability to set values to null. MATLAB doesnt have a corresponding null type, so if your data contains nulls you may wish to filter or detect them.

MATLAB has the ability to call static methods within Java. The `NULL` method can provide the null values for the different [data types](../basics/datatypes.md). For example

```matlab
NullInt=kx.c.NULL('i')
NullLong=kx.c.NULL('j')
NullDouble=kx.c.NULL('f')
NullDate=kx.c.NULL('d')
```

With this, you can test values for null. The following shows that the comparison will return true when requesting null values from a kdb+ connection named conn:

```matlab
fetch(conn,'0Ni')== NullInt
fetch(conn,'0N')== NullLong
fetch(conn,'0Nd')== NullDate
isequaln(fetch(conn,'0Ni'),NullInt)
isequaln(fetch(conn,'0N'), NullLong)
isequaln(fetch(conn,'0Nd'), NullDate)
isequaln(fetch(conn,'0Nf'), NullDouble)
```

An alternative is to have your query include a filter for nulls (if they are populated), so they arent retrieved by MATLAB.


## Getting more help

Start with `help kx` in your MATLAB session and also see `help kx.fetch` and so on for further details of the integration.

MathWorks provides functions overview, usage instructions and some examples on the [toolbox webpage](https://uk.mathworks.com/help/releases/R2020b/datafeed/kx-systems-inc-.html).
