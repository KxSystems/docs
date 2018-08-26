# Connecting to a kdb+ process  




## Starting a local q server  

During development, it can be helpful to start a basic q server to which
a Java process can connect. This requires the opening of a port, for
which there are two basic methods:

Example: Starting q with `–p` parameter
```bash
$ q -p 10000
```
```q
q)\p // command to show the port that q is listening on
10000i
```

Example: Using the `\p` system command
```bash
$ q
```
```q
q)\p 10000 // set the listening port to 10000
q)\p
10000i
```
To close the port, it should be set to its default value of 0 i.e. `\p 0`.

Setting up a q session in this manner will allow other processes to open
handles to it on the specified port. The remainder of the examples in
this paper assume an opened q session listening on port 10000, with
no further configuration unless otherwise specified.


## Opening a socket connection

As discussed in the previous section, the `c` class establishes
connections via its constructors.

For connecting to a listening q process, one useful mechanism might be
to create a factory class with a method that returns a connected `c`
object based on what is passed to it. This way, any number of credential
combinations can be set whilst allowing the creation of multiple
connections, say for reconnection purposes:


Example: `QConnectionFactory.java`
```java
public QConnectionFactory(String host, int port, 
    String username, String password, boolean useTLS) {
  this.host=host;
  this.port=port;
  this.username=username;
  this.password=password;
  this.useTLS=useTLS;
}

//[…]

public c getQConnection() throws KException, IOException {
  return new c(host,port,username+":"+password,useTLS);
}
```
These constructors will always return a `c` object connected to the target
session, and failure to do so will result in a thrown exception;
`IOException` will denote the port not being open or available, and a
`KException` will denote something wrong with the q process itself (such
as `'access` for incorrect or incomplete credentials).

For the remaining examples, connections will be made using a custom
`QConnectionFactory` object returned from a static method `getDefault()`,
which will instantiate the object with the host `localhost` and the port
10000:

Example: `QConnectionFactory.java`
```java
public static QConnectionFactory getDefault() {
  return new QConnectionFactory("localhost", 10000);
}
```
Connection objects created using this will be given the variable name
`qConnection` unless otherwise stated.


## Running queries using k methods  

Queries can be made using the ‘k’ family of methods in the `c` class. 
For synchronous queries, that might be used to retrieve data (or, more 
generally, to halt execution of the java process until a response
is received), the k methods with parameter combinations of strings
and objects might be used.
For asynchronous queries, as might be used in a
feed-handler process to push data to a tickerplant, the `ks` methods would
be used.

The methods `k()`, `kr()` and `ke()` would not see explicit use in the
querying of a server q process, but are more significant when the Java
process acts as the server, as will be touched upon below.

The following examples demonstrate some of the means by which these
synchronous and asynchronous queries may be called:


Example: `SimpleQueryExamples.java`
```java
//Object for storing the results of these queries
Object result = null;

//Basic synchronous q expression
result = qConnection.k("{x+y}\[4;3\]");
System.out.println(result.toString());

//parameterised synchronous query
result = qConnection.k("{x+y}",4,3); //Note autoboxing!
System.out.println(result.toString());

//asynchronous assignment of function
qConnection.ks("jFunc:{x-y+z}");

//synchronous calling of that function
result = qConnection.k("jFunc",10,4,3);
System.out.println(result);

//asynchronous error - note no exception can be returned, so be careful!
qConnection.ks("{x+y}\[4;3;2\]");

//Always close resources\!
qConnection.close(); 
```


