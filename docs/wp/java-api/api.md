# API overview  



The API is contained in a <i class="fa fa-github"></i> [single source file](https://github.com/KxSystems/javakdb/blob/master/src/kx/c.java) on GitHub.
Inclusion in a development project is, therefore, a straightforward matter
of including the file with other source code under the package `kx`, and
ensuring it is properly imported and referenced by other classes. If
preferred, it can be compiled separately into a class or JAR file to be
included in the classpath for use as an external library or uploaded to
a local repository for build integration.

As the API is provided as source, it is perfectly possible to customize code to meet specific requirements. 
However, without prior knowledge of how the interactions work, this is not advised unless the solution to these requirements or issues are known.
It is also possible, and in some contexts encouraged, to wrap the
functionality of this class within a model suitable for your framework.
An example might be the open-source <i class="fa fa-github"></i> [qJava library](https://github.com/exxeleron/qJava). 
Although it is not compatible with the most recent kdb+ version at the time of writing, it shows how to use `c.java` as a core over which an object-oriented framework of q types and functionality has been applied.

The source file is structured as a single outer class, `c`. 
Within it, a number of constants and inner classes together model an
environment for sending and receiving data from a kdb+ process. 
This section explores the fundamentals of the class to provide context and understanding of practical use-cases for the API.


## Connection and interface logic

The highly-recommended means of connecting to a kdb+ process using the API is through instantiation of the `c` object itself. 
Three constructors provide for this purpose:
```java
public c(String host,int port,String usernamepassword) 
public c(String host,int port,String usernamepassword,boolean useTLS)
public c(String host,int port)
```
These constructors are straightforward to use. 
The host and port specify a socket-object connection, with the username/password string serialized and passed to the remote instance for authorization.
The core logic is the same for all; the host/port-only constructor attempts to retrieve the user string from the Java properties, and the constructor with the `useTLS` boolean will, when flagged true, attempt to use an SSL socket instead of an ordinary socket.

It is also possible to set up the object to accept incoming connections
from kdb+ processes rather than just making them. There are two
constructors which, when passed a server socket reference, will allow a
q session to establish a handle against the `c` object:
```java
public c(ServerSocket s)
public c(ServerSocket s,IAuthenticate a)
```
`IAuthenticate` is an interface within the `c` class that can be
implemented to emulate kdb+ server-side authentication, allowing the
establishment of authentication rules similar to that which might be
done through the kdb+ function [.z.pw](/ref/dotz/#zpw-validate-user).

Both of these constructor families represent two ‘modes’ in which
the `c` object can be instantiated. The first, and ultimately most
widely used, is for making connections to kdb+ processes, which
naturally would be used for queries, subscriptions and any task that
requires the reception of or sending of data to said processes. The
second, which sees Java act as the server, would see utility in
management and aggregation of kdb+ clients, perhaps as a data sink or
an intermediary interface for another technology.

Interactions between Java and kdb+ through these connections are
largely handled by what might be called the ‘k’ family of methods in
the `c` class. There are thirteen combined methods and overloads that
fall under this group. They can be divided roughly into four groups:


## Synchronous query methods  

```java
public Object k(String expr)
public Object k(String s,Object x)
public Object k(String s,Object x,Object y)
public void k(String s,Object x,Object y,Object z)
public synchronized Object k(Object x)
```
These methods are responsible for handling synchronous queries to a kdb+
process. The String parameter will represent either the entire q
expression or the function name; in the case of the latter, the Object
parameters may be used to pass values into that function. In all
instances, the String/Object combinations are merged into a single
object to be passed to the synchronized `k(Object)` method.


## Asynchronous query methods

```java
public void ks(String expr)
public void ks(String s,Object x)
public void ks(String s,Object x,Object y)
public void ks(String s,Object x,Object y,Object z)
public void ks(Object obj)
```
These methods are responsible for handling asynchronous queries to a
kdb+ process. They operate logically in a similar manner to the
synchronous query method, with the exception that they are, of course,
void methods in that they neither wait for nor return any response from
the process.


## Incoming message method

```java
public Object k()
```
This method waits on the class input stream and will deserialize the
next incoming kdb+ message. It is used by the `c` synchronous methods in
order to capture and return response objects, and is also used in
server-oriented applications in order to capture incoming messages from
client processes.


## Response message methods

```java
public void kr(Object obj)
public void ke(String text)
```
These methods are typically used in server-oriented applications to
serialize and write response messages to the class output stream.
`kr(Object)` will act much like any synchronous response, while `ke(String)`
will format and output an error message.

The use of these constructors and methods will be treated in more
practical detail through the use-case examples below.


