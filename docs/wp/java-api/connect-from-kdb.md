# Connecting from kdb+ to a Java process



The examples thus far have emphasized interfacing between Java and kdb+
very much from the perspective of a Java client connecting to a kdb+
server, using the constructors relevant to this purpose. It is very much
possible to reverse these roles using the `c(Serversocket)` constructor,
which enables a Java process to listen for incoming kdb+ messages on the
specified port.

While the use cases for this ‘server’ mode of operation are not as
common as they might be for ‘client’-mode connections, it is nevertheless
available to developers as a means of implementing communication between
Java and kdb+ processes. The following examples demonstrate the
basic mechanisms by which this can be done. 


## Handling a single connection

To set this up, a `c` object is instantiated using the ‘server’ mode constructor.
This will listen to the incoming connection of a single kdb+ process:

Example: `IncomingConnectionExample.java` 
```java
//Wait for incoming connection
System.out.println("Waiting for incoming connection on port 5001..");
c incomingConnection = new c(new ServerSocket(5001));
```
In a manner similar to tickerplant subscription, the method `k()` (without
parameters) can be used to wait on and listen to any connecting q
session. In this example, the object is retrieved in this fashion and
deciphered, either to return an error when passed the
symbol `` `returnError`` or to return a message describing what was sent:


Example: `IncomingConnectionExample.java`
```java
while(true) {
  //k() method will wait until the kdb+ process sends an object.
  Object incoming = incomingConnection.k();
  try {
    // check the incoming object and return something based on what it is
	if (incoming instanceof String && ((String)incoming).equals("returnError")) {
	  incomingConnection.ke("ReturningError!");
    } else if(incoming.getClass().isArray()) {
	  // if list, use Arrays toString method
	  incomingConnection.kr("The incoming list values are: " + Arrays.toString((Object[])incoming));
    } else {
	  incomingConnection.kr(("The incoming message was: " + incoming.toString()).toCharArray());
	}
  } catch(IOException | KException e) {
    //return error responses too
	  incomingConnection.ke(e.getMessage());
  }
}
```


## Handling multiple connections

In the above example, the server `c` object is instantiated with a
new ServerSocket being created in its constructor. This is acceptable in
this instance because we cared only about the handling of one
connection.

In general, ServerSocket objects should not be used in this manner, as
they are designed to handle more than a single incoming connection.
Instead, the ServerSocket should be passed as a reference. With the
addition of some simple threading, an application capable of handling
messages from multiple q sessions can be created:


Example: `IncomingConnectionsExample.java`
```java
//Create server socket reference beforehand..
ServerSocket serverSocket = new ServerSocket(5001);

//Set up connection loop
while(true) {	
  //Create c object with reference to server socket
  final c incomingConnection = new c(serverSocket);

  //Create thread for handling this connection
  new Thread(new Runnable() {	
    @Override
    public void run() {
      while(true) {
        //Logic in this loop is similar to single connection 
        //[...]		
      }	
	}
  //Run thread and restart loop.
  }).start();
}
```
This will allow any number of connections to be established, with factors
such as connection limitation and load balancing left up to how the
process is implemented. As in any case where threading is used, take
care that such a method does not enable race conditions or concurrency
issues; if necessary, steps can be taken to reduce the risk of such
operations, such as synchronized blocks and methods.


