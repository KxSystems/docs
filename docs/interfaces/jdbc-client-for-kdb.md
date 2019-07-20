---
title: JDBC client for kdb+
description: How to connect a Java client program to a kdb+server process using the JDBC driver
keywords: api, interface, java, jdbc, kdb+, library, q
---
# <i class="fab fa-java"></i> JDBC client for kdb+



<i class="fab fa-github"></i> 
[KxSystems/kdb/c/jdbc.java](https://github.com/KxSystems/kdb/blob/master/c/jdbc.java)

Compile:

```bash
$ java jdbc.java
$ jar cf jdbc.jar *.class
```

and use as normal.

!!! note "Implementation"

    This is a pure Java native-protocol driver (type 4) JDBC driver. The implementation builds on the lower-level [javakdb API](java-client-for-q.md), which is somewhat simpler, and a good choice for application development when support for legacy code is not a consideration.

The JDBC driver implements only the minimal core of the JDBC feature set. 
Operations must be prefixed by `"q)"` in order to be executed as q statements. 
There is no significant difference in performance between using the `!PreparedStatement`, `!CallableStatement` or `Statement` interfaces.

Q does not have the concept of transactions as expected by the JDBC API. 
That is, you cannot open a connection, explicitly begin a transaction, issue a series of separate queries within that transaction and finally roll back or commit the transaction. 
It will always behave as if `autoCommit` is set to true and the transaction isolation is set to `SERIALIZABLE`. 
In practice, this means that any single query (or sequence of queries if executed in a single JDBC call) will be executed in isolation 
without noticing the effects of other queries, and modifications made to the database will always be permanent.

## Connection pooling

If little work is being performed per interaction via the JDBC driver, 
that is, few queries and each query is very quick to execute, 
then there is a significant advantage to using connection pooling. 

Using the [Apache Commons DBCP](https://commons.apache.org/proper/commons-dbcp/) component improves the performance of this case by about 70%. 
DBCP avoids some complexity which can be introduced by other connection pool managers. 
For example, it handles connections in the pool that have become invalid (say due to a database restart) by automatically reconnecting. 
Furthermore it offers configuration options to check the status of connections in the connection pool using a variety of strategies.

Although it is not necessary to call the `close` method on `!ResultSet`, `Statement`, `!PreparedStatement` and `!CallableStatement` when using the q JDBC driver, 
it is recommended with the DBCP component as it performs checks to ensure all resources are cleaned up, and has the ability to report resource leaks. 
Explicitly closing the resources avoids a small runtime cost.

```java
package kx;
import java.sql.*;

//in kdb+3.x and above
//init table with
//Employees:([]id:0 1 2;firstName:`Charlie`Arthur`Simon;lastName:`Skelton`Whitney`Garland;age:10 20 30;timestamp:.z.p+til 3)

public class JDBCTest{
  static final String JDBC_DRIVER="jdbc";
  static final String DB_URL="jdbc:q:localhost:5000";
  static final String USER="username";
  static final String PASS="password";

  public static void main(String[] args){
    Connection conn=null;
    Statement stmt=null;
    try{
      Class.forName(JDBC_DRIVER);

      System.out.println("Connecting to database...");
      conn=DriverManager.getConnection(DB_URL,USER,PASS);

      System.out.println("Creating statement...");
      stmt=conn.createStatement();
      ResultSet rs=stmt.executeQuery("SELECT id, firstName, lastName, age,timestamp FROM Employees");

      while(rs.next()){
        long id=rs.getLong("id");
        long age=rs.getLong("age");
        String first=rs.getString("firstName");
        String last=rs.getString("lastName");
        Timestamp timestamp=rs.getTimestamp("timestamp");

        System.out.print("ID: "+id);
        System.out.print(", Age: "+age);
        System.out.print(", FirstName: "+first);
        System.out.println(", LastName: "+last);
        System.out.println(", Timestamp: "+timestamp);
      }
      rs.close();
      stmt.close();
      conn.close();
    }catch(SQLException se){
      se.printStackTrace();
    }catch(Exception e){
      e.printStackTrace();
    }finally{
      try{
        if(stmt!=null)
          stmt.close();
      }catch(SQLException se2){
      }
      try{
        if(conn!=null)
          conn.close();
      }catch(SQLException se){
        se.printStackTrace();
      }
    }
  }
}
```

when run should print something like

```txt
Connecting to database...
Creating statement...
ID: 0, Age: 10, FirstName: Charlie, LastName: Skelton, Timestamp: 2014-09-02 08:28:11.688024
ID: 1, Age: 20, FirstName: Arthur, LastName: Whitney, Timestamp: 2014-09-02 08:28:11.688024001
ID: 2, Age: 30, FirstName: Simon, LastName: Garland, Timestamp: 2014-09-02 08:28:11.688024002
```

```java
#!java

// An ObjectPool serves as the pool of connections.
//
ObjectPool connectionPool = new GenericObjectPool(null);

// A ConnectionFactory is used by the to create Connections.
// This example uses the DriverManagerConnectionFactory, with a
// a connection string for a local q database listening on port 5001.
//
ConnectionFactory connectionFactory =
            new DriverManagerConnectionFactory("jdbc:q:localhost:5001",null);

// A PoolableConnectionFactory is used to wrap the Connections
// created by the ConnectionFactory with the classes that implement
// the pooling functionality.
//
PoolableConnectionFactory poolableConnectionFactory = new
            PoolableConnectionFactory(connectionFactory,connectionPool,null,
            null,false,true);

// Finally, we create the PoolingDriver itself:
//
Class.forName("org.apache.commons.dbcp.PoolingDriver");
PoolingDriver driver = (PoolingDriver)
            DriverManager.getDriver("jdbc:apache:commons:dbcp:");

// ...and register our pool with it.
//
driver.registerPool("q",connectionPool);

// Now we can just use the connect string "jdbc:apache:commons:dbcp:q"
// to access our pool of Connections.
```


