# Creating and passing data objects



When passing objects to q via the `c` class, there is less emphasis on how a given object is created. Rather, such an operation
is subject to the common pitfalls associated with passing values to a q
expression; those of type and rank.

The k family of methods, regardless of its return protocol, will take
either the String of a q expression or the String of a q operator or
function, complemented by Object parameters. Given the nature of q as an
interpreted language, all of these are serialized and sent to the q
session with little regard for logical correctness.

It is important, therefore, that any expressions passed to a query
method are syntactically accurate and refer to variables that actually
exist in the target session. It is also important that any passed
objects are mapped to a relevant q type, and function within the context
that they are sent. `KException` messages to look out for while
implementing these operations are `'type` and `'rank`, as these will
generally denote basic type and rank issues respectively.


## Creating and passing a simple list

The following method might be applied to all direct type mappings in
the API; for simple lists (lists in which all elements are of the same
type), it is enough to pass a Java array of the appropriate type.

The following example invokes the q `set` function, which allows for the
passing of a variable name as well as an object with which the variable
might be set:


Example: `CreateAndSendExamples.java` 
```java
//Create typed array
int[] simpleList = {10, 20, 30};
//Pass array to q using set function.
qConnection.k("set", "simpleList", simpleList)
```


### Creating and passing a mixed list  

Mixed lists should always be passed to kdb+ through an Object array,
`Object[]`. This array may then hold any number of mapped types,
including, if appropriate, other typed or Object arrays:


Example: `CreateAndSendExamples.java` 
```java
//Create generic Object array.
Object[] mixedList = {new String[] {"first", "second"}, new double[] {1.0, 2.0}};
//Pass to q in the same way as a simple list.
qConnection.k("set", "mixedList", mixedList);
```


## Creating and passing dictionaries  

`c.Dict` objects are instantiated by setting its `x` and `y` objects in the
constructor, and these objects should always be arrays. Once created,
the Dict can be passed to kdb+ like any other object:


Example: `CreateAndSendExamples.java`
```java
//Create keys and values
Object[] keys = {"a", "b", "c"};
int[] values = {100, 200, 300};
//Set in dict constructor
c.Dict dict = new c.Dict(keys, values);
//Set in q session
qConnection.k("set","dict",dict);
```

## Creating and passing tables

`c.Flip` objects are created slightly differently; it is best to
instantiate these by passing a `c.Dict` object into the constructor. This
is because tables are essentially collections of dictionaries in kdb+,
and therefore using this constructor helps ensure that the Flip object
is set up correctly.

It is worth noting that for this method to work correctly, the passed
Dict object must use String keys, as these will map into the Flip
object’s typed `String[]` columns:

Example: `CreateAndSendExamples.java` 
```java
//Create rows and columns
int[] values = {1, 2, 3};
Object[] data = new Object[] {values};
String[] columnNames = new String[] {"column"};
//Wrap values in dictionary
c.Dict dict = new c.Dict(columnNames, data);
//Create table using dict
c.Flip table = new c.Flip(dict);
//Send to q using 'insert' method
qConnection.ks("insert", "t1", table);
```


## Creating and passing GUID objects

Globally universal identifier objects are represented in Java by
`java.util.UUID` objects, and are passed to kdb+ in an identical manner as
other basic types. The Java object has a useful static method for
generating random identifiers, which further streamlines this process
and can see utility in some use cases where only a certain number of
arbitrary identifiers are required:


Example: `CreateAndSendExamples.java`
```java
//Generate random UUID object
java.util.UUID uuid = java.util.UUID.randomUUID();
System.out.println(uuid.toString());

//Pass object to q using set function
qConnection.k("set","randomGUID",uuidj);
System.out.println(qConnection.k("randomGUID").toString());
```
Of course, it should be remembered that kdb+ version 3.0 or higher is
required to work with GUIDs, and running the above code connected to an
older version will cause a `RuntimeException` to be thrown.


