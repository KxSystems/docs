---
title: Basic client-server computing 
description: A kdb+ server can listen for connections on a port. Clients can then send requests to the server via that port. A kdb+ process starts listening to a port either at start-up, via a command-line argument.
keywords: client, kdb+, q, server
---
# Basic client-server computing 




A kdb+ server can listen for connections on a port. Clients can then send requests to the server via that port.

A kdb+ process starts listening to a port either at start-up, via a command-line argument.

```bash
$ q -p 5001
```
or at a later time, using the command `\p`

```q
q)\p 5001
```

!!! tip "Secure it"

    You can restrict the interface by starting  
    
    <pre><code class="language-bash">
    $ q -p 127.0.0.1:5000
    </code></pre>
    
    or within q

    <pre><code class="language-q">    
    q)\p 127.0.0.1:5000
    </code></pre>

To stop listening, you can ask the server to listen on port zero, like this

```q
q)\p 0
```
Clients can be other q processes, or they can be written in C, Java, C\#, etc. This is an example of a Java client:

```bash
$ sudo cp -r /var/www/q .
$ sudo chown -R fred:fred q
```

```java
public class KDBClient {

    public static void main(String[] args) {
        try{
            // create q server object
            c kdbServer = new c("localhost",5001);
            // create a row (array of objects)
            Object[] row= {new Time(System.currentTimeMillis()%86400000), "IBM", new Double(93.5), new Integer(300)};
            // insert the row into the trade table
                kdbServer.ks("insert","trade", row);
            // send a sync message (see below for an explanation)
            kdbServer.k("");
            // execute a query in the server that returns a table
            Flip table = td(kdbServer.k("select sum size by sym from trade"));
            // read the data from the Flip object ...
            // close connection to q server
            kdbServer.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

!!! note "Parameters and result"

    The parameters to methods `k` and `ks`, and its result are arbitrarily-nested arrays (Integer, Double, int[], !DateTime, etc).

This client does not need a reply after the insert, so it sends an asynchronous message using method `ks`. For the select, it expects a table as a result, and sends a synchronous message using method `k`. 

<i class="far fa-hand-point-right"></i> 
[Java client for q](../interfaces/java-client-for-q.md)

A q client process connects to a server using `hopen`:

```q
q)h: hopen `:localhost:5001
```

The syntax of the argument to `hopen` is

```q
`:host:port
```

where `host` is the hostname of the server. In this example, the client is in the same machine as the server, so we use `localhost`.

We have assigned the handle of the connection to the variable `h`. To close the connection, write

```q
q)hclose h
```

From a q client, a synchronous message is sent simply like this:

```q
q)h "select sum size by sym from trade"
sym  | amount
-----| ---------
amd  | 324928400
amzn | 326589900
goog | 324356900
ibm  | 324553500
intel| 324721900
msft | 324377400
```

To send an asynchronous message, use the handle value, negated

```q
q)(neg h) "insert[`trade](10:30:01.000; `intel; 88.5; 1625)"
```

Execution of this message returns immediately with no result.

Messages can also be created as lists instead of strings. For instance:

```q
q)(neg h) (insert; `trade; (10:30:01.000; `intel; 88.5; 1625))
```

In most realistic situations the data to be inserted is not constant, but is either generated algorithmically or received from an external source. Consequently, the list message format is the more generally useful one because it does not require formatting the data into strings.

If you want to send a bunch of async messages, and then wait for them to complete processing, you can chase them with

```q
q)h ""
```

which will cause the client to block until the server sends a null reply to that message.

<i class="far fa-hand-point-right"></i> 
[Interprocess communication](../basics/ipc.md)
<!--FIXME Consider merging these articles-->
