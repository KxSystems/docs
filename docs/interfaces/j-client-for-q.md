---
title: J client for kdb+
description: JQ is a socket interface to kdb+ from J, for example to provide a GUI for a kdb+ server. 
keywords: api, interface, j, kdb+, library, q
---
# ![J](img/j.png) J client for kdb+



JQ is a socket interface to kdb+ from [J](http://jsoftware.com), for example to provide a GUI for a kdb+ server. JQ was written in J602 for V2.4, and has been tested on w32, l32 and l64. 

<i class="fab fa-github"></i> [kxcontrib/cburke/jk](https://github.com/kxcontrib/cburke/tree/master/jk) 


## Sample session

Start a q session, listening on a given port. Load J, then:

```j
load 'qclient.ijs'           NB. load JQ client application
```

Create a client instance, defining cover functions in `z`:

```j
   1 conew 'cqclient'
+-+
|1|
+-+
   connect 'robot';5001;'elmo'  NB. connect to robot on port 5001 with user elmo

   cmd 'trade:([]time:();sym:();price:();size:())' NB. create trade database
```

Send a command string to insert a record:

```j
   cmd '`trade insert(09:30:00;`a;10.75;100)'

   get 'trade' NB. get database
+-----+----+------+-----+
|`time|`sym|`price|`size|
+-----+----+------+-----+
|34200|`a  |10.75 |100  |
+-----+----+------+-----+
```

Get database in extended format. Each item is a pair: Qdatatype;value. The display shows that trade is the flip (type 98) of a dict (type 99). The dict is a pair: varchar, object list.

```j
   getx 'trade'
+--+------------------------------------------------------------------------------+
|98|+--+-------------------------------------------------------------------------+|
|  ||99|+----------------------------+------------------------------------------+||
|  ||  ||+--+-----------------------+|+-+--------------------------------------+|||
|  ||  |||11|`time `sym `price `size|||0|+----------+-------+---------+-------+||||
|  ||  ||+--+-----------------------+|| ||+--+-----+|+--+--+|+-+-----+|+-+---+|||||
|  ||  ||                            || |||18|34200|||11|`a|||9|10.75|||6|100||||||
|  ||  ||                            || ||+--+-----+|+--+--+|+-+-----+|+-+---+|||||
|  ||  ||                            || |+----------+-------+---------+-------+||||
|  ||  ||                            |+-+--------------------------------------+|||
|  ||  |+----------------------------+------------------------------------------+||
|  |+--+-------------------------------------------------------------------------+|
+--+------------------------------------------------------------------------------+
```

Insert records using the `insert` function. The result is the record number:

```j
   execr 'insert';(s:<'trade');<('09:31:12';(s:<'a');11.01;200)
1
   execr 'insert';(s:<'trade');<('09:31:15';(s:<'bc');10.80;150)
2
```

The next example has a numeric time field, and integer price field. Extended format ensures the correct datatypes are sent:

```j
   execr 'insert';(s:<'trade');<((,:18;34301);(s:<'bc');(,:9;22);500)
3
```

The utility col, defined below, formats cells into columns:

```j
   col=: ,.@:>L:0

   col getf 'trade'
+--------+----+------+-----+
|`time   |`sym|`price|`size|
+--------+----+------+-----+
|09:30:00|`a  |10.75 |100  |
|09:31:12|`a  |11.01 |200  |
|09:31:15|`bc | 10.8 |150  |
|09:31:41|`bc |   22 |500  |
+--------+----+------+-----+
```

The next result is displayed as a pair – key columns and data columns.

```j
   col cmdr 'select sum size by sym from trade'
+------+-------+
|+----+|+-----+|
||`sym|||`size||
|+----+|+-----+|
||`a  |||300  ||
||`bc |||650  ||
|+----+|+-----+|
+------+-------+
```

Send command string to load the `sp.q` database:

```j
cmd '\l sp.q'
```

Query the `sp.q` database:

```j
   col cmdr 'select sum qty by p.color from sp'
+--------+------+
|+------+|+----+|
||`color|||`qty||
|+------+|+----+|
||`blue ||| 900||
||`green|||1000||
||`red  |||1200||
|+------+|+----+|
+--------+------+

   col get 's'
+-----+------------------------+
|+---+|+------+-------+-------+|
||`s |||`name |`status|`city  ||
|+---+|+------+-------+-------+|
||`s1|||`smith|20     |`london||
||`s2|||`jones|10     |`paris ||
||`s3|||`blake|30     |`paris ||
||`s4|||`clark|20     |`london||
||`s5|||`adams|30     |`athens||
|+---+|+------+-------+-------+|
+-----+------------------------+
```


## Load client

The client is in script `qclient.ijs`. This populates locale `cqclient`.

```j
load 'qclient.ijs'
```


## Methods

methods            | role 
-------------------------|-----------------------------------
`connect` `close`            | open connection, close connection 
`cmd` `cmdr` `cmdrf` `cmdrx`     | send command string 
`exec` `execr` `execrf` `execrx` | execute q function  
`get` `getf` `getx`            | get value             
`set`                      | set value                 

All methods return two items: 

-   returncode (0=success)
-   result, or error message for non-zero returncode. 

The non-zero returncodes are 

-   1: error signalled in client
-   2: error signalled in q server

The `get` and `set` methods are convenience functions that call corresponding `cmd` or `exec` methods.

The `cmd` family methods send character strings to be executed by the q `value` function, as if they were entered on the terminal. 
The `exec` family methods send a function name and parameters in q internal format. 
This is more efficient than `cmd` for large amounts of data.

Methods differ in the type of response returned from q. For example, the `cmd` method has four variants:

 method  | effect                 
---------|------------------------
 `cmd`   | no response            
 `cmdr`  | with response          
 `cmdrf` | with formatted response
 `cmdrx` | with extended response 

The response variants are described in section [Datatypes](#datatypes) below.

When used under program control, create an instance of `cqclient` and use the instance handle when calling methods. 
Your application should check the return code of each command, for example:

```j
q=: conew 'cqclient'
connect__q 'robot';5001;'elmo'
cmd__q '\l sp.q'
cmdr__q 'select sum qty by p.color from sp'
```


## Interactive use

For interactive use, you can define cover verbs of the same name in `z`, by calling `conew` with a left argument of 1. 
For a zero returncode, the result is the method result, otherwise the result is the returncode and error message.

The examples in the rest of this manual use these cover verbs. The above example showing session output is:

```j
   1 conew 'cqclient'     NB. result is the instance locale
+-+
|1|
+-+
   connect 'robot';5001;'elmo'
   cmd '\l sp.q'
   cmdr 'select sum qty by p.color from sp'
+-------------------+---------------+
|+-----------------+|+-------------+|
||`color           |||`qty         ||
|+-----------------+|+-------------+|
||`blue `green `red|||900 1000 1200||
|+-----------------+|+-------------+|
+-------------------+---------------+
```


## Method syntax

### `connect`

This connects to a q session. Parameters are:

-   host: host name or IP address
-   port: port number
-   user\[:password\]: user name, with optional password


### `close`

Closes the session and erases the instance locale. Same as calling `codestroy` in the instance locale. The argument is ignored.

### `cmd`

The argument is a text string to be executed in q. No response is expected from kdb+ (an asynchronous message). The method result simply indicates whether the string was sent successfully.

For example:

```j
cmd 'val: sum key 100'
```


### `cmdr cmdrf cmdrx`

As `cmd`, except that the response from q is returned (a synchronous message).

### `exec`

Sends a function name and parameters to be executed in q. 
As with `cmd`, no response is expected from q, and the method result simply indicates whether the message was sent successfully.

For example, load the `trade` table, and add a record using the `insert` function:

```j
cmd '\l trade.q'

exec 'insert';(s:<'trade');<('09:31:15';(s:<'bc');10.80;150)
```


### `execr execrf execrx`

As `exec`, except that the response from q is returned.


### `get getf getx`

Identical to `cmdr`, `cmdrf`, `cmdrx`.


### `set`

Binary with form:

```j
'name' set value
```

Calls the `set` function, and checks the name was set in q.


## Datatypes

There is no one-to-one mapping between q and J datatypes.

All q datatypes are mapped in some way to J datatypes. 
Three such mappings are supported: _raw_, _formatted_ and _extended_. 
Corresponding methods are named, for example, `cmdr`, `cmdrf`, `cmdrx`. Essentially:

_raw_
: converts q to J equivalents suitable for further processing. In particular, all temporal types are converted to numbers. 

_formatted_
: as raw, except that temporal types are formatted.

_extended_
: as raw, but each mapping is a 1×2 array: Qdatatype;value. This provides an exact mapping between q and J.

J datatypes that are in the range of q mappings can be mapped back to q. Other datatypes such as complex numbers or rank-3 arrays, cannot be sent to q.

The next sections discuss primitive datatypes (e.g. boolean, byte etc), complex datatypes (flip, dict, keyed table), and object lists.


### Primitive datatypes

The following is a summary:
```txt
 Qname     Qexample             Jraw       Jfmt      Jnull
---------------------------------------------------------
boolean   1b                   boolean    as Jraw   n/a
byte      0xff                 character  as Jraw   n/a
short     23h                  integer    as Jraw   <.-2^31
int       23                   integer    as Jraw   <.-2^31
long      23j                  extended   as Jraw   -2^56x
real      2.3e                 floating   as Jraw   __
float     2.3                  floating   as Jraw   __
char      "a"                  character  as Jraw   ''
varchar   `ab                  symbol     as Jraw   `
month     2003.03m             integer    as Q      <.-2^31 | nnnn.nnm
date      2003.03.23           integer    as Q      ditto | numbers to "n"
datetime  2003.03.23T08:31:53  integer    as Q           ditto
minute    08:31                integer    as Q           ditto
second    08:31:53             integer    as Q           ditto
time      09:10:35.000         integer    as Q           ditto
```

Raw invertible datatypes are: boolean, int, long, float, char, varchar. Formatted invertible datatypes are all except: byte, short, real.

Q atoms, lists and empties are mapped into J atoms, lists and empties. The only exception is the formatted values for temporal types – in this case, q atoms are mapped to J character strings, and q lists to J character tables.

Q long is mapped into J extended integer in the range +/- 2^56x.

Use extended notation when mapping back non-invertible datatypes, for example, the following sets a list of short:

```j
'xx' set ,:5;2 3 5 7
```

Enumerations are mapped into J lists.


### Nulls

Q short null is mapped into `<.-2^31`, and not into `<.-2^15` (the short null value in q).

Q real and float nulls are mapped into J negative infinity.

Formatted temporal nulls have `"n"` in each numeric position.

Example of nulls:

```j
   get 'trade[99]'
+------+-----------+
|`time |_2147483648|
+------+-----------+
|`sym  |`          |
+------+-----------+
|`price|__         |
+------+-----------+
|`size |_2147483648|
+------+-----------+
```


### Complex datatypes

Flips and dicts are mapped to J boxed tables. Examples:

```j
   cmd 'd:`x`y`z!(("two";"three";"five";"seven");2 3 5 7;`pi`hk`de`hk)'

   get 'd'                        NB. dict
+--+----------------------+
|`x|+---+-----+----+-----+|
|  ||two|three|five|seven||
|  |+---+-----+----+-----+|
+--+----------------------+
|`y|2 3 5 7               |
+--+----------------------+
|`z|`pi `hk `de `hk       |
+--+----------------------+

   get 'key d'                    NB. dict keys
`x `y `z

   get 'value d'                  NB. dict values
+----------------------+-------+---------------+
|+---+-----+----+-----+|2 3 5 7|`pi `hk `de `hk|
||two|three|five|seven||       |               |
|+---+-----+----+-----+|       |               |
+----------------------+-------+---------------+

   cmd 'f:flip d'                 NB. flip
   get 'f'
+----------------------+-------+---------------+
|`x                    |`y     |`z             |
+----------------------+-------+---------------+
|+---+-----+----+-----+|2 3 5 7|`pi `hk `de `hk|
||two|three|five|seven||       |               |
|+---+-----+----+-----+|       |               |
+----------------------+-------+---------------+
```

Key tables are mapped to a 2-item list: primary key columns;data columns. Example:

```j
   cmd '`y xkey `f'                NB. convert to keyed table
   get 'f'
+---------+----------------------------------------+
|+-------+|+----------------------+---------------+|
||`y     |||`x                    |`z             ||
|+-------+|+----------------------+---------------+|
||2 3 5 7|||+---+-----+----+-----+|`pi `hk `de `hk||
|+-------+|||two|three|five|seven||               ||
|         ||+---+-----+----+-----+|               ||
|         |+----------------------+---------------+|
+---------+----------------------------------------+

      get 'key f'                  NB. key table keys
+-------+
|`y     |
+-------+
|2 3 5 7|
+-------+

      get 'value f'                NB. key table data
+----------------------+---------------+
|`x                    |`z             |
+----------------------+---------------+
|+---+-----+----+-----+|`pi `hk `de `hk|
||two|three|five|seven||               |
|+---+-----+----+-----+|               |
+----------------------+---------------+
```


### Object lists

Object lists are mapped to J boxed lists. For example:

```j
   cmdr '(`one;(2 3 5;"seven");01100b)'
+----+-------------+---------+
|`one|+-----+-----+|0 1 1 0 0|
|    ||2 3 5|seven||         |
|    |+-----+-----+|         |
+----+-------------+---------+
```


### Temporal numbers

Day zero is 2000 1 1.

Dates are integer day numbers, months are integer month numbers. For example:

```j
   get '1999.01.01,2000.01.01,2003.03.23'
_365 0 1177

   get '1999.01m,2000.01m,2003.03m'
_12 0 38
```

Minutes, second, time are all integers. For example:

```j
   get '00:00,01:00,08:31'
0 60 511

   get '00:00:00.123,08:31:24.000'
123 30684000
```

Datetime is a float: day number + seconds as a fraction of day. For example:

```j
   0j6 ":  get '2003.03.23T08:31:24'
1177.355139

   (60 #. 8 31 24) % 86400
0.355139
```


## Message format

<i class="far fa-hand-point-right"></i> 
[Interprocess communication](../basics/ipc.md) for the internal layout of messages


### Initial connection

Messages are plain text, zero terminated. Once a connection is established, the client sends user name and optional password, and the server responds with `"c"` if successful, or `"e"` if error.


### Subsequent communications

The message header has 8 bytes:

byte |                                                           
-----|-----------------------------------------------------------
0    | endian: 0=big endian (e.g. Sun); 1=little endian (e.g PC) 
1    | type: 0=async; 1=sync; 2=response from Q                  
2, 3 | 0 (unused)                                                
4-7  | overall message length                                    

The rest of the message is the data.


### Atoms

Atoms have a single byte giving the type (e.g. int is 250 = 256-6), followed by the data. The data size is fixed except for varchar which is zero-terminated. For example, using the `toQ` keyword in the J client:

```j
   a. i. toQ 123456
250 64 226 1 0

   256 #. |. }. a. i. toQ 123456
123456
```


### Lists

Lists have a byte giving the type (e.g. int is 6), followed by 0, followed by the length of the list in 4 bytes. The data size is the length times the fixed size for an atom, except for varchar, for which individual atoms are zero-terminated. For example:

```j
   a. i. toQ 123456 + i.3
6 0 3 0 0 0 64 226 1 0 65 226 1 0 66 226 1 0

   256 #. _4 |.\ 6 }. a. i. toQ 123456 + i.3
123456 123457 123458

   a. i. toQ s: 'two';'three'
11 0 2 0 0 0 116 119 111 0 116 104 114 101 101 0
```


### Dict, flip, keyed table

Dict has a byte giving the type (99), followed by two lists. For example, the dictionary:

```q
`x`y!(`a;10)
```

has representation:

```txt
99 11 0 2 0 0 0 120 0 121 0 0 0 2 0 0 0 245 97 0 250 10 0 0 0
```

Therefore it is a list of varchar, followed by an object list consisting of an atom varchar and an atom integer.

A flip has a two-byte header, type 98 followed by 0, followed by the representation of its dictionary contents. For example, the flip:

```q
flip(`x`y!(`a`b;10 11))
```

has representation:

```txt
98 0 99 11 0 2 0 0 0 120 0 121 0 0 0 2 0 0 0 11 0 2 ...
```

A keyed table is like a dict, except that the two lists are two flips, the key columns and the data columns. For example, if `y` is set as a key field in the above flip, the representation is:

```txt
99 98 0 99 11 0 1 0 0 0 121 0 0 0 1 0 0 0 6 0 2 0 0 0 ...
```


### Object lists

Object lists have a header of length 6, followed by each data item.

The header is two 0 bytes, followed by the length of the object (i.e. number of top level items). For example:

```j
   a. i. toQ 10;(s:<'papa');'0'
0 0 3 0 0 0 250 10 0 0 0 245 112 97 112 97 0 246 48
```


### Asynchronous messages

These are sent as a character string, and evaluated by the q `value` function.


### Synchronous messages

These are sent as an object list. The first item is the function name as a text string, and the remaining items are the parameter list. For example, the J client `set` method sends an object list in the form:

```j
"set";`abc;1 2 3
```


### Error messages

Error messages from q have a type byte of 128, followed by a zero-terminated text string.


![Zippy the Pinhead](img/zippy.gif)