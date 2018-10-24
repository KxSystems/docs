# Extracting data from returned objects



## Note on internal variables and casting  

The relationship between the kdb+ types and their Java counterparts has
been discussed in the previous section. From a practical perspective, it
is important to note that almost all objects and fields that might
return from a given synchronous query will be of type Object, and will
therefore more often than not require casting in order to be manipulated
properly. Care must be taken, therefore, to ensure that the types that
can be returned from a given query are known and handled appropriately
so as to avoid unwanted exceptions.

The exception to this might be the column names of a `flip` object (once
cast itself) held in the field `flip.x`. This field is already typed as
`String[]`, as column names must always be symbols in q.

Kdb+ types that map to primitives (such as int) can be passed in Java to
a `k` method as a primitive thanks to
[autoboxing](https://docs.oracle.com/javase/tutorial/java/data/autoboxing.html),
but will always be returned as the corresponding wrapper object (such as
Integer).


## Extracting atoms from a list

Lists will always be returned as an array of the given list type, or as
`Object[]` if the list is generic. Extraction of atomic values from a
list, therefore, is as simple as casting the return object to the
appropriate array type and accessing the desired index:


Example: `ExtractionExamples.java`
```java
//Get a list from the q session
Object result = qConnection.k("(1 2 3 4)");

//Cast the returned Object into long[], and retrieve the desired result.
long[] castList = ((long[]) result);
long extractedAtom = castList[0];
System.out.println(extractedAtom);
```
If the type of list is unknown, the method `c.t(Object)` can be used to
derive the q type of the object, and theoretically could be useful in
further casting efforts.


## Extracting lists from a nested list

Accessing a list from a nested list is similar to accessing a value from
any list. Here there are two casts required: a cast to `Object[]` for
the parent list and then again to the appropriate typed array for the
extracted list:


Example: `ExtractionExamples.java`
```java
// Start by casting the returned Object into Object[]
Object[] resultArray = (Object[]) qConnection.k("((1 2 3 4); (1 2))");

//Iterate through the Object array
for (Object resultElement : resultArray) {

  //Retrieve each list and cast to appropriate type
  long[] elementArray = (long[]) resultElement;

  //Iterate through these arrays to access values.
  for(long elementAtom : elementArray) {
    System.out.println(elementAtom);
  }
}
```


## Working with dictionaries 

The Dict inner class is used for all returned objects of q type
dictionary (and therefore, by extension, keyed tables). Key values are
stored in the field `Dict.x`, and values in `Dict.y`, both of which will
generally be castable as an array.

Aside from matching the index positions of `x` and `y`, there is no
intrinsic key-value pairing between the two, meaning that alteration of
either of the array structures can compromise the key-value
relationship. The following example illustrates operations that might be
performed on a returned dictionary object:

Example: `ExtractionExamples.java`
```java
//Retrieve Dictionary
c.Dict dict = (c.Dict) qConnection.k("`a`b`c!((1 2 3);\"Second\"; (`x`y`z))");
//Retrieve keys from dictionary
String[] keys = (String[]) dict.x;
System.out.println(Arrays.toString(keys));
//Retrieve values
Object[] values = (Object[]) dict.y;
//These can then be worked with similarly to nested lists
long[] valuesLong = (long[]) values[0];
//[…]
```


## Working with tables  

The inner class `c.Flip` used to represent tables operates in a similar
manner to `c.Dict`. The primary difference, as previously mentioned, is
that `Flip.x` is already typed as `String[]`, while `Flip.y` will still
require casting. The following example shows how the data from a
returned `Flip` object might be used to print the table to console:


Example: `ExtractionExamples.java`
```java
// (try to load trade.q first for this (create a table manually if not possible)
qConnection.ks("system \"l trade.q\"");
//Retrieve table
c.Flip flip = (c.Flip) qConnection.k("select from trade where sym = `a");

//Retrieve columns and data
String[] columnNames = flip.x;
Object[] columnData = flip.y;
//Extract row data into typed arrays
java.sql.Timestamp[] time = (java.sql.Timestamp[]) columnData[0];
String[] sym = (String[]) columnData[1];
double[] price = (double[]) columnData[2];
int[] size = (int[]) columnData[3];
int rows = time.length;

//Print the table now - columns first:
for (String columnName : columnNames)
{
  System.out.print(columnName + "\t\t\t");
}
System.out.println("\n-----------------------------------------------------");
//Then rows:
for (int i = 0; i < rows; i++)
{
  System.out.print(time[i]+"\t"+sym[i]+"\t\t\t"+price[i]+"\t\t\t"+size[i]+"\n");
}
```


