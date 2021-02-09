---
title: Access a table in kdb+ from an MDB file via ODBC | Database | kdb+ and q documentation
description: Access a table in kdb+ from an MDB file via ODBC
date: November 2020
---
# :fontawesome-brands-windows: Access a table from an MDB file via ODBC



From Windows, load `odbc.k` into your q session, and then load the MDB file.

```dos
C:>q w32\odbc.k
```

```q
q)h: .odbc.load `mydb.mdb
```

This loads the entire database, which may consist of several tables. Use `.odbc.tables` to list the tables.

```q
q).odbc.tables  h
`aa`bb`cc`dd`ii`nn
```

Use `.odbc.eval` to evaluate SQL commands via ODBC.

```q
q).odbc.eval[h;"select * from aa"]
```

---
:fontawesome-solid-handshake:
[Q client for ODBC](../interfaces/q-client-for-odbc.md)