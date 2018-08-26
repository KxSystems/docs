# Models and type mapping

The majority of q data types are represented in the API through mapping
to standard Java objects. This is best seen in the method
[`c.r()`](https://github.com/KxSystems/javakdb/blob/master/src/kx/c.java#L709),
which reads bytes from an incoming message and converts those bytes into
representative Java types.

A [full list of Java type mappings](/interfaces/java-client-for-q/#type-mapping) is on code.kx.com.


## Basic types  

The method `c.r()` deserializes a stream of bytes within a certain range to point
to further methods which return the appropriate typed object. These are
largely self-explanatory, such as booleans and integer primitives
mapping directly to one another, or q UUIDs mapping to `java.util.UUID`.
There are some types with caveats, however:

-   The kdb+ float type (9) corresponds to `java.lang.Double` and _not_ `java.lang.Float`, which corresponds to the kdb+ real type (8).

-   Java strings map to the kdb+ symbol type (11). In terms of reading
    or passing in data, this means that passing  `"String"` from Java to
    kdb would result in `` `String``. Conversely, passing `"String"` (type 10
    list) from kdb to Java would result in a six-index character array.


## Time-based types

Of particular interest is how the mapping handles temporal types, of
which there are eight:

q type | id | Java type | note
-------|----|-----------|------
datetime | 15 | `java.util.Date` | This Java class stores times as milliseconds passed since the Unix epoch. Therefore, like the q datetime, it can represent time information accurate to the millisecond. (This despite the default output format of the class).
date | 14 | java.sql.Date | While this Java class extends the `java.util` date object it is used specifically for the date type as it restricts usage and output of time data.
time | 19 | `java.sql.Time` | This also extends `java.util.Date`, restricting usage and output of date data this time.
timestamp | 12 | <span class="nowrap">`java.sql.Timestamp`</span> | This comes yet again from the base date class, extended this time to include nanoseconds storage (which is done separately from the underlying date object, which only has millisecond accuracy). This makes it directly compatible with the q timestamp type.
month | 13 | inner class [`c.Month`](https://github.com/KxSystems/javakdb/blob/master/src/kx/c.java#L300) |
timespan | 16 | inner class [`c.Timespan`](https://github.com/KxSystems/javakdb/blob/master/src/kx/c.java#L376) |
minute | 17 | inner class [`c.Minute`](https://github.com/KxSystems/javakdb/blob/master/src/kx/c.java#L326) |
second | 18 | inner class [`c.Second`](https://github.com/KxSystems/javakdb/blob/master/src/kx/c.java#L351) |

When manipulating date, time and datetime data from kdb+ it is important
to note that while `java.sql.Date` and `Time` extend `java.util.Date`, and can
be assigned to a `java.util` reference, that many of the methods from the
original date class are overridden in these to throw exceptions if
invoked. For example, in order to create a single date object for two
separate SQL Date and Time objects, a `java.util.Date` object should be
instantiated by adding the `getTime()` values from both SQL objects:
```java
//Date value = datetime - time
java.sql.Date sqlDate = (java.sql.Date)qconn.k(".z.d"); 
// Time value - datetime - date
java.sql.Time sqlTime = (java.sql.Time)qconn.k(".z.t"); 
java.util.Date utilDate= new java.util.Date(sqlDate.getTime()+sqlTime.getTime());
```
The four time types represented by inner classes are somewhat less
prevalent than those modeled by Date and its subclasses. These classes
exist as comparable models due to a lack of a clear representative
counterpart in the standard Java library, although their modeling is for
the large part fairly simple and the values can be easily implemented or
extracted.


## Dictionaries and tables  

Kdb+ dictionaries (type 99) and tables (type 98) are represented by the
internal classes Dict and Flip respectively. The makeup of these models
is simple but effective, and useful in determining how best to
manipulate them.

[The Dict class](https://github.com/KxSystems/javakdb/blob/master/src/kx/c.java#L427)
consists of two public `java.lang.Object` fields (`x` for keys, `y` for
values) and a basic constructor, which allows any of the represented
data types to be used. However, while from a Java perspective any object
could be passed to the constructor, dictionaries in q are always
structured as two lists. This means that if the object is being created
to pass to a q session directly, the Object fields in a Dict object
should be assigned arrays of a given representative type, as passing in
an atomic object will result in an error.

For example, the first of the following dictionary instantiation is
legal with regards to the Java object, but because the pairs being
passed in are atomic, it would signal a type error in q. Instead, the
second example should be used, and can be seen as mirroring the practice
of enlisting single values in q:
```java
new c.Dict("Key","Value"); // not q-compatible
new c.Dict(new String[] {"Key"}, new String[] {"Value"}); // q-compatible
```
As the logical extension of that, in order to represent a list as a
single key or pair, multi-dimensional arrays should be used:
```java
new c.Dict(new String[] {"Key"}, new String[][] {{"Value1","Value2","Value3"}});
```
[Flip (table) objects](https://github.com/KxSystems/javakdb/blob/master/src/kx/c.java#L440)
consist of a String array for columns, an Object array for values, a
constructor and a method for returning the Object array for a given
column. The constructor takes a dictionary as its parameter, which is
useful for the conversion of one to the other should the dictionary in
question consist of single symbol keys. Of course, with the fields of
the class being public, the columns and values can be assigned manually.

Keyed tables in q are dictionaries in terms of type, and therefore will
be represented as a Dict object in Java. The method
[`td(Object)`](https://github.com/KxSystems/javakdb/blob/master/src/kx/c.java#L1396)
will create a Flip object from a keyed table Dict, but will remove its
keyed nature in the process.


## GUID

The globally unique identifier (GUID) type was introduced into kdb+ with
version 3.0 for the purpose of storing arbitrary 16-byte values, such as
transaction IDs. Storing such values in this form allows for savings in
tasks such as memory and storage usage, as well as improved performance
in certain operations such as table lookups when compared with standard
types such as Strings.

Java has its own unique identifier type: `java.util.UUID` (universally
unique identifier). In the API the kdb+ GUID type maps directly to this
object through the extraction and provision of its most and least
significant long values. Otherwise, the only high-level difference in
how this type can be used when compared to other types handled by the
API is that a `RuntimeException` will be thrown if an attempt is made to
serialize and pass a UUID object to a kdb+ instance with a version lower
than 3.0.

More information on these identifier types can be found in the [Kx documentation](/ref/datatypes/#guid) as well as the
[core Java documentation](https://docs.oracle.com/javase/7/docs/api/java/util/UUID.html).


## Null types

Definitions for q null type representations in Java are held in the
static Object array `NULL`, with index positions representing the q type.
```java
public static Object[] NULL={
    null,
    new Boolean(false),
    new UUID(0,0),
    null,
    new Byte((byte)0),
    new Short(Short.MIN_VALUE),
    new Integer(ni),
    new Long(nj),
    new Float(nf),
    new Double(nf),
    new Character(' '),
    "",
    new Timestamp(nj),
    new Month(ni)
    ,new Date(nj),
    new java.util.Date(nj),
    new Timespan(nj),
    new Minute(ni),
    new Second(ni),
    new Time(nj)
};
```
Of note are the integer types, as the null values for these are
represented by the minimum possible value of each of the Java
primitives. Shorts, for example, have a minimum value of -372768 in
Java, but a minimum value of -372767 in q. The extra negative value in
Java can therefore be used to signal a null value to the q connection
logic in the `c` class.

Float and real nulls are both represented in Java by the
`java.lang.Double.NaN` constant. Time values, essentially being longs
under the bonnet, are represented by the same null value as longs in
Java. Month, minute, second and timespan, each with custom model
classes, use the same null value as ints.

The method
[`c.qn(Object)`](https://github.com/KxSystems/javakdb/blob/master/src/kx/c.java#L1355)
can assist with checking and identifying null value representations, as
it will check both the `Object` type and value against the `NULL` list.

It is worth noting that infinity types are not explicitly mapped in
Java, although kdb+ float and real infinities will correspond with the
infinity constants in `java.lang.Double` and `java.lang.Float`
respectively.


## Exceptions

[`KException`](https://github.com/KxSystems/javakdb/blob/master/src/kx/c.java#L457)
is the single custom exception defined and thrown by the API. It is
fairly safe to assume that a thrown `KException` denotes a q error signal,
which will be included in the exception message when thrown.

Other common exceptions thrown in the API logic include:

IOException 

: Denotes issues with connecting to the kdb+ process. It is also thrown by `c.java` itself for such issues as authentication.

RuntimeException

: Thrown when certain type implementations are attempted on kdb+ versions prior to their introduction (such as the GUIDs prior to kdb+ 3.0)

UnsupportedEncodingException 

: It is possible, through the method `setEncoding`, to specify character encoding different to the default (`ISO-859-1`). This exception will be thrown commonly if the default is changed to a charset format not implemented on the target Java platform.


