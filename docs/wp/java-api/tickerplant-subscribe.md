# Tickerplant subscription


## Extracting the table schema

Typical subscriber processes are required to make an initial subscription request to the tickerplant in order to receive data. 
See the [publish and subscribe](/cookbook/publish-subscribe) cookbook article for details. 
This request involves calling the `.u.sub` function with two
parameters. The first parameter is the table name and the second is a
list of symbols for subscription. (Specifying a backtick in any of the
parameters means all tables and/or all symbols).


Example: `TickSubscriberExample.java`
```java
// Run sub function and store result
Object[] response = (Object[]) qConnection.k(".u.sub[`trade;`]");
```
If the `.u.sub` function is called synchronously, the tickerplant will
return the table schema. If subscribing to one table, the returned
object will be a generic Object array, with the table name in
`object[0]` and a `c.Flip` representation of the schema in `object[1]`:


Example: `TickSubscriberExample.java`
```java
// first index is table name
System.out.println("table name: " + response[0]);

// second index is flip object
c.Flip table = (c.Flip) response[1];

// Retrieve column names
String[] columnNames = table.x;
for (int i = 0; i < columnNames.length; i++) {
  System.out.printf("Column %d is named %s\n", i, columnNames[i]);
}
```
If more than one table is being subscribed to, the returned object will
be an Object array consisting of the above object arrays; therefore, in
order to retrieve each individual Flip object, this should be iterated
against:


Example: `TickSubscriberExample.java` 
```java
// Run sub function and store result
Object[] response = (Object[]) qConnection.k(".u.sub[`;`]");

// iterate through Object array
for (Object tableObjectElement : response) {

  // From here, it is similar to the one-table schema extraction
  Object[] tableData = (Object[]) tableObjectElement;
  System.out.println("table name: " + tableData[0]);
  c.Flip table = (c.Flip) tableData[1];
  String[] columnNames = table.x;
  for (int i = 0; i < columnNames.length; i++) {
    System.out.printf("Column %d is named %s\n", i, columnNames[i]);
  }
}
```


## Subscribing to a tickerplant data feed  

Upon calling `.u.sub` and retrieving the schema, the tickerplant process
will start to publish data to the Java process. The data it sends can be
retrieved through the parameter-free `k()` method, which will wait for a
response and return an Object (a `c.Flip` of the passed data) on
publication:


Example: `TickSubscriberExample.java`
```java
while (true) {

  //wait on k()
  Object response = qConnection.k();

  if(response != null) {
    Object[] data = (Object[]) response;

    //Slightly different.. table is in data[2]\!
    c.Flip table = (c.Flip) data[2];
    //[…]
  }
}
```
With the data in this form, it can be manipulated in a number of
meaningful ways. To iterate through the columns, `c.n` can be called on
individual `flip.y` columns in order to provide a row count:


Example: `TickSubscriberExample.java`
```java
String[] columnNames = table.x;
Object[] columnData = table.y;

//Get row count for looping
int rowCount = c.n(columnData[0]);

//Print out the table!
System.out.printf("%s\t\t\t%s\t%s\t%s\n", 
    columnNames[0], columnNames[1], columnNames[2], columnNames[3]);
System.out.println("--------------------------------------------");
for (int i = 0; i < rowCount; i++) {

  //[Printing logic]

}
```
This mechanism might be then enveloped in an indefinite loop, such as a
`while(true)` loop. Each iteration waits on the `k()` method returning
published data, which will continue until one of the contributing
processes fails (at which point an exception is caught and handled
appropriately).


