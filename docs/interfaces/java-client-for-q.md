---
title: Using Java with kdb+ – Interfaces – kdb+ and q documentation
description: How to enable a Java client to query kdb+, subscribe to a kdb+ publisher, and publish to a kdb+ consumer
keywords: fusion, interface, java, kdb+, q
---
# :fontawesome-brands-java: Using Java with kdb+




:fontawesome-brands-github: [KxSystems/javakdb](https://github.com/KxSystems/javakdb) is the original Java driver, a.k.a `c.java`, from KX for interfacing [Java](https://www.java.com/en/) with kdb+ via TCP/IP. This driver allows Java applications to

 - query kdb+
 - subscribe to a kdb+ publisher
 - publish to a kdb+ consumer 

using a straightforward and compact API. The four methods of the single class `c` of immediate interest are

method    | purpose
--------- | --------
`c`.      | the constructor
`c.ks`    | send an async message
`c.k`.    | send a sync message
`c.close` | close the connection

To establish a connection to a kdb+ process listening on the localhost on port 12345, invoke the relevant constructor of the `c` class

```java
 c c=new c("localhost",12345,System.getProperty("user.name")+":mypasswordhere");
```

A KException will be thrown if the kdb+ process rejects the connection attempt.

Then, to issue a query and read the response, use

```java
Object result=c.k("2+3");
System.out.println("result is "+result); // expect to see 5 printed
```

or to subscribe to a kdb+ publisher, here kdb+tick, use

```java
  c.k(".u.sub","mytable",x);
  while(true)
    System.out.println("Received "+c.k());
```

or to publish to a kdb+ consumer, here a kdb+ ticker plant, use

```java
// Assuming a remote schema of
// mytable:([]time:`timespan$();sym:`symbol$();price:`float$();size:`long$())
Object[]row={new c.Timespan(),"SYMBOL",new Double(93.5),new Long(300)};
c.k(".u.upd","mytable",row);
```

And to close a connection once it is no longer needed:

```java
c.close();
```

!!! tip "Closing unused connections"

    Closing unused connections is important to help avoid unnecessary resource usage on the remote process.

The Java driver is effectively a data marshaller between Java and kdb+: sending an object to kdb+ typically results in kdb+ evaluating that object in some manner. The default message handlers on the kdb+ side are initialized to the kdb+ `value` operator, which means they will evaluate a string expression, e.g.

```java
c.k("2+3")
```

or a list of (function; arg0; arg1; ...; argN), e.g.

```java
c.k(new Object[]{'+',2,3})
```

Usually when querying a database, one would receive a table as a result. This is indeed the common case with kdb+, and a table is represented in this Java interface as the `c.Flip` class. A flip has an array of column names, and an array of arrays containing the column data.

The following is example code to iterate over a flip, printing each row to the console.

```java
c.Flip flip=(c.Flip)c.k("([]sym:`MSFT`GOOG;time:0 1+.z.n;price:320.2 120.1;size:100 300)");
for(int col=0;col<flip.x.length;col++)
  System.out.print((col>0?",":"")+flip.x[col]);
System.out.println();
for(int row=0;row<n(flip.y[0]);row++){
  for(int col=0;col<flip.x.length;col++)
    System.out.print((col>0?",":"")+c.at(flip.y[col],row));
    System.out.println();
}
```

resulting in the following printing at the console

```csv
sym,time,price,size
MSFT,15:39:23.746172000,320.2,100
GOOG,15:39:23.746172001,120.1,300
```

A keyed table is represented as a dictionary where both the key and the value of the dictionary are flips themselves. To obtain a table without keys from a keyed table, use the `c.td(d)` method. In the example below, note that the table is created with `sym` as the key, and the table is unkeyed using `c.td`.

```java
c.Flip flip=c.td(c.k("([sym:`MSFT`GOOG]time:0 1+.z.n;price:320.2 120.1;size:100 300)"));
```

To create a table to send to kdb+, first construct a flip of a dictionary of column names with a list of column data. e.g.

```java
c.Flip flip=new c.Flip(new c.Dict(
  new String[]{"time","sym","price","volume"},
  new Object[]{new c.Timespan[]{new c.Timespan(),new c.Timespan()},
               new String[]{"ABC","DEF"},
               new double[]{123.456,789.012},
               new long[]{100,200}}));
```

and then send it via a sync or async message

```java
Object result=c.k("{x}",flip); // a sync msg, echos the flip back as result
```


## Type mapping

Kdb+ types are mapped to and from Java types by this driver, and the example `src/kx/examples/TypesMapping.java` demonstrates the construction of atoms, vectors, a dictionary, and a table, sending them to kdb+ for echo back to Java, for comparison with the original type and value. The output is recorded here for clarity:

|            Java type|            kdb+ type|                            value sent|                            kdb+ value|
|--------------------:|--------------------:|-------------------------------------:|-------------------------------------:|
|   [Ljava.lang.Object|             (0) list|                                      |                                      |
|    java.lang.Boolean|          (-1)boolean|                                  true|                                    1b|
|                   [Z|    (1)boolean vector|                                  true|                                   ,1b|
|       java.util.UUID|             (-2)guid|  f5889a7d-7c4a-4068-9767-a009c8ac46ef|  f5889a7d-7c4a-4068-9767-a009c8ac46ef|
|     [Ljava.util.UUID|       (2)guid vector|  f5889a7d-7c4a-4068-9767-a009c8ac46ef| ,f5889a7d-7c4a-4068-9767-a009c8ac46ef|
|       java.lang.Byte|             (-4)byte|                                    42|                                  0x2a|
|                   [B|       (4)byte vector|                                    42|                                 ,0x2a|
|      java.lang.Short|            (-5)short|                                    42|                                   42h|
|                   [S|      (5)short vector|                                    42|                                  ,42h|
|    java.lang.Integer|              (-6)int|                                    42|                                   42i|
|                   [I|        (6)int vector|                                    42|                                  ,42i|
|       java.lang.Long|             (-7)long|                                    42|                                    42|
|                   [J|       (7)long vector|                                    42|                                   ,42|
|      java.lang.Float|             (-8)real|                                 42.42|                                42.42e|
|                   [F|       (8)real vector|                                 42.42|                               ,42.42e|
|     java.lang.Double|            (-9)float|                                 42.42|                                 42.42|
|                   [D|      (9)float vector|                                 42.42|                                ,42.42|
|  java.lang.Character|            (-10)char|                                     a|                                   "a"|
|                   [C|      (10)char vector|                                     a|                                  ,"a"|
|     java.lang.String|          (-11)symbol|                                    42|                               &#96;42|
|   [Ljava.lang.String|    (11)symbol vector|                                    42|                              ,&#96;42|
|   java.sql.Timestamp|       (-12)timestamp|               2017-07-07 15:22:38.976|         2017.07.07D15:22:38.976000000|
| [Ljava.sql.Timestamp| (12)timestamp vector|               2017-07-07 15:22:38.976|        ,2017.07.07D15:22:38.976000000|
|           kx.c\$Month|           (-13)month|                               2000-12|                              2000.12m|
|         [Lkx.c\$Month|     (13)month vector|                               2000-12|                             ,2000.12m|
|        java.sql.Date|            (-14)date|                            2017-07-07|                            2017.07.07|
|      [Ljava.sql.Date|      (14)date vector|                            2017-07-07|                           ,2017.07.07|
|       java.util.Date|        (-15)datetime|    Fri Jul 07 15:22:38 GMT+03:00 2017|               2017.07.07T15:22:38.995|
|     [Ljava.util.Date|  (15)datetime vector|    Fri Jul 07 15:22:38 GMT+03:00 2017|              ,2017.07.07T15:22:38.995|
|        kx.c\$Timespan|        (-16)timespan|                    15:22:38.995000000|                  0D15:22:38.995000000|
|      [Lkx.c\$Timespan|  (16)timespan vector|                    15:22:38.995000000|                 ,0D15:22:38.995000000|
|          kx.c\$Minute|          (-17)minute|                                 12:22|                                 12:22|
|        [Lkx.c\$Minute|    (17)minute vector|                                 12:22|                                ,12:22|
|          kx.c\$Second|          (-18)second|                              12:22:38|                              12:22:38|
|        [Lkx.c\$Second|    (18)second vector|                              12:22:38|                             ,12:22:38|
|        java.sql.Time|            (-19)time|                              15:22:38|                          15:22:38.995|
|      [Ljava.sql.Time|      (19)time vector|                              15:22:38|                         ,15:22:38.995|


## Timezone

For global data capture, it is common practice to store events using a GMT timestamp. To minimize confusion, it is easiest to set the current timezone to GMT, either explicitly in the `c` class as 

```java
c.tz=TimeZone.getTimeZone("GMT");
```

or from the environment, e.g.

```bash
$ export TZ=GMT;...
```

otherwise kdb+ will use the default timezone from the environment, and adjust values between local and GMT during serialization.


## Message types

There are three message types in kdb+

|Msg Type|Description|
|--------|-----------|
|   async| send via `c.ks(…)`. This call blocks until the message has been fully sent. There is no guarantee that the server has processed this message by the time the call returns.|
|    sync| send via `c.k(…)`. This call blocks until a response message has been received, and returns the response which could be either data or an error.|
|response| this should _only_ ever be sent as a response to a sync message. If your Java process is acting as a server, processing incoming sync messages, a response message can be sent with `c.kr(responseObject)`. If the response should indicate an error, use `c.ke("error string here")`.|

If `c.k()` is called with no arguments, the call will block until a message is received of _any_ type. This is useful for subscribing to a tickerplant, to receive incoming async messages published by the ticker plant.


## Sending sync/async messages 

The methods for sending sync/async messages are overloaded as follows:

-   Methods which send async messages do not return a value:

```java
public void ks(String s) throws IOException 
public void ks(String s, Object x) throws IOException
public void ks(String s, Object x, Object y) throws IOException
public void ks(String s, Object x, Object y, Object z) throws IOException
```

-   Methods which send sync messages return an Object, the result from the remote processing the sync message:

```java
public Object k(Object x) throws KException, IOException
public Object k(String s) throws KException, IOException
public Object k(String s, Object x) throws KException, IOException
public Object k(String s, Object x, Object y) throws KException, IOException
public Object k(String s, Object x, Object y, Object z) throws KException, IOException
```
-   If no argument is given, the `k` call will block until a message is received, deserialized to an Object.

```java 
public Object k() throws KException, IOException
```


## Exceptions

The `c` class throws IOExceptions for network errors such as read/write failures and throws KExceptions for higher-level cases, such as remote execution errors arising during the query at hand.


## Accessing items of lists

List items can be accessed using the `at` method of the utility class `c`:

```java
Object c.at(Object x, int i) // Returns the object at x[i] or null
```

and set them with `set`:

```java
void c.set(Object x, int i, Object y) // Set x[i] to y, or the appropriate q null value if y is null
```


## Creating null values

For each type suffix, "hijefcspmdznuvt", we can get a reference to a null q value by indexing into the `NULL` Object array using the `NULL` utility method. Note the q null values are not the same as Java’s null.

An example of creating an object array containing a null integer and a null long:

```java
Object[] twoNullIntegers = {NULL('i'), NULL('j')}; // i - int, j - long
```


## Testing for null

An object can be tested where it is a q null using the `c` utility method

```java
public static boolean qn(Object x);
```
 

## SSL/TLS

Secure, encrypted connections may be established using SSL/TLS, by specifying the `useTLS` argument to the `c` constructor as true, e.g.

```java
c c=new c("localhost",12345,System.getProperty("user.name"),true);
```

N.B. The kdb+ process [must be enabled](../kb/ssl.md) to accept TLS connections.

Prior to using SSL/TLS, ensure that the server’s certificate has been imported into your keystore. e.g.

```bash
keytool -printcert -rfc -sslserver localhost:5010 > example.pem
keytool -importcert -file example.pem -alias example.com -storepass changeit -keystore ./keystore
java -Djavax.net.ssl.trustStore=./keystore -Djavax.net.ssl.keyStore=./keystore kx.c
```

To troubleshoot SSL, supply `-Djavax.net.debug=ssl` on the command line when invoking your Java application.



