---
title: Kdb+ server for ODBC – Interfaces – kdb+ and q documentation
description: The ODBC interface for kdb+is no longer supported. See instead the SImba Magnitude ODBC drivers.
keywords: api, interface, kdb+, library, odbc, q, server
---
# :fontawesome-solid-database: Kdb+ server for ODBC




!!! warning "Deprecated"

    This interface is no longer supported.

    See instead [ODBC3](q-server-for-odbc3.md) and 
    [Simba/Magnitude ODBC drivers](odbc-simba.md)





In Windows only, you can use ODBC to connect to a q database from a non-q client.  


## Installation

To install:

Ensure your q process has loaded the SQL interpreter.  
:fontawesome-brands-github: [KxSystems/kdb/s.k](https://github.com/KxSystems/kdb/blob/master/s.k)

!!! warning "Windows 2003 hotfix KB948459"

    If using Windows 2003, before installing ensure you have hotfix [KB948459](https://www.microsoft.com/en-gb/download/details.aspx?id=20065) applied. 

-   in W32, download :fontawesome-brands-github: [KxSystems/kdb/w32/odbc.zip](https://github.com/KxSystems/kdb/blob/master/w32/odbc.zip) and run it to install the q ODBC driver
-   in W64, download :fontawesome-brands-github: [KxSystems/kdb/w64/odbc.zip](https://github.com/KxSystems/kdb/blob/master/w64/odbc.zip) and extract it to a temporary directory. Run `d0.exe` to install the q ODBC driver.

!!! tip "Troubleshooting"

    If everything appears to be set up properly but you cannot connect to, or retrieve data from q then try rebooting.


## Method

-   if the user or password are not needed for the connection, then you can use the Windows ODBC Data Source Administrator to create a q [DSN](https://en.wikipedia.org/wiki/Database_Source_Name) of `host:port`, for example `localhost:5001`
-   if the user or password has to be given, you need to connect with a statement of the form:

```txt
DRIVER=kdb+;DBQ=host:port;UID=usr;PWD=pwd;
```

Start kdb+ with the given port number, and load a database:

```q
q)\p 5001
q)\l sp.q
```

You can now use ODBC from a non-q client to access the database in q. For example (depending on your client application):

```txt
h=: ddcon 'dsn=localhost:5001'
ddread h;'select * from s'
+--+-----+--+------+
|s1|smith|20|london|
|s2|jones|10|paris |
|s3|blake|30|paris |
|s4|clark|20|london|
|s5|adams|30|athens|
+--+-----+--+------+
```

The default language for ODBC is SQL. To use q, prefix with `q)`:

```txt
ddread h;'q)select from s'
```


## Connection syntax

The actual connection syntax depends on your ODBC client. Some examples:

From Excel 2003 with Microsoft Query installed, you can use menu _Data&gt;Import External Data&gt;New Database Query_ and select the `localhost:5001` data source to import into the current worksheet.

From Excel that supports `sql.request`:

```txt
 =SQL.REQUEST("DRIVER=kdb+;DBQ=localhost:5001;UID=usr;PWD=pwd;",,,"select * from s")
```

From Visual Basic _Add-ins&gt;Visual Data Manager&gt;File&gt;Opendatabase&gt;ODBC_:

```txt
r=new adodb.recordset
r.Open "select * from s","DRIVER=kdb+;DBQ=localhost:5001;UID=usr;PWD=pwd;"
```

or

```txt
connQ.Open"Provider=MSDASQL.1;DRIVER=kdb+;DBQ=localhost:5001;UID=usr;PWD=pwd;"
```

From SQL Server via a linked server:

```sql
EXEC sp_addlinkedserver @server = N'kdb', @srvproduct = N'',@provider = N'MSDASQL.1', @provstr = 'Provider=MSDASQL.1;DRIVER=kdb+;DBQ=localhost:5001';
EXEC sp_addlinkedsrvlogin 'kdb', 'false', NULL, 'usr', 'pwd'
GO
select * from openquery(kdb, 'q)([]a:til 10)')
```

