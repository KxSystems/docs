---
title: Access a table in kdb+ from an MDB file via ODBC | Database | kdb+ and q documentation
description: Access a table in kdb+ from an MDB file via ODBC
date: November 2020
---
# :fontawesome-brands-windows: Access a table from an MDB file via ODBC


Install the [ODBC client driver for kdb+](../interfaces/q-client-for-odbc.md).
Install Microsoft ODBC driver for Microsoft Access. 

Using the driver installed, a MDB file can be opened using the following example command:


```q
q)h:.odbc.open "driver=Microsoft Access Driver (*.mdb, *.accdb);dbq=C:\\mydb.mdb"
```

!!! note "The name of the driver may differ between versions. The command above should be altered to reflect the driver name installed."

Use [`.odbc.tables`](../interfaces/q-client-for-odbc.md#tables) to list the tables.

```q
q).odbc.tables  h
`aa`bb`cc`dd`ii`nn
```

Use [`.odbc.eval`](../interfaces/q-client-for-odbc.md#eval) to evaluate SQL commands via ODBC.

```q
q).odbc.eval[h;"select * from aa"]
```

An alternative to querying through SQL is to load the entire database into kdb+ via the [.odbc.load](../interfaces/q-client-for-odbc.md#load) command, where the data can then be queried using kdb+ directly.
