# Reconnecting to a q process automatically  

Requirements will often dictate that while q processes will need to be
bounced (such as for End-of-Day processing), that a Java process will
need to be able to handle loss and reacquisition of said processes
without being restarted itself. A simple example might be a graphical
user interface, where the forced shutdown of the entire application due
to a dropped connection, or the lack of ability to reconnect, would be
very poor design indeed.

Use of patterns such as factories can help with the task of setting up a
reconnection mechanism, as it allows for the simple creation of a
preconfigured object. For `c` Objects, given that they connect on
instantiation, means that a connection can be re-established simply by
calling the relevant factory method.

In order to handle longer periods of potential downtime, either loops or
recursion should be used. The danger with recursive methodology here is
that, given an extended without a timeout limitation, there is a risk of
overflowing the method-call stack, as each failed attempt will invoke a
new method onto the stack.

For mechanisms that may need to wait indefinitely, it might be
considered safer to use an indefinite while-loop that makes use of catch
blocks, continue and break statements. This averts the danger of
`StackOverflowError` occurring and is easily modified to implement a
maximum number of tries:

Example: `ReconnectionExample.java`
```java
//initiate reconnect loop (possibly within a catch block).
while (true) {
  try {
    System.err.println("Connection failed - retrying..");
    //Wait a bit before trying to reconnect
    Thread.sleep(5000);
    qConnection = qConnFactory.getQConnection();
    System.out.println("Connection re-established! Resuming..");
    //Exit loop
    break;
  } catch (IOException | KException e1) {
    //resume loop if it fails
    continue;
  }
  …
}
```


