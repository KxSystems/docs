---
title: Using ODBC with kdb+ – Knowledge Base – kdb+ and q documentation
description: Q has limited support for ODBC. In general, ODBC is not recommended for large databases (for performance reasons) but may be acceptable for small databases, or for one-off data import and export.
keywords: database, kdb+, linux, odbc, odbc3, q, windows
---
# :fontawesome-solid-database: Using ODBC with kdb+





Q has limited support for ODBC. In general, ODBC is not recommended for large databases – for performance reasons – but may be acceptable for small databases, or for one-off data import and export.

-   in Windows and Linux, kdb+ can use ODBC to access a non-kdb+ database  
:fontawesome-regular-hand-point-right: Interfaces: [Q client for ODBC](../interfaces/q-client-for-odbc.md)
-   in Windows only, a non-kdb+ client can use ODBC to access a kdb+ database  
:fontawesome-regular-hand-point-right: Interfaces: [Simba/Magnitude ODBC drivers](../interfaces/odbc-simba.md)  
:fontawesome-regular-hand-point-right: Interfaces: [Q server for ODBC3 ](../interfaces/q-server-for-odbc3.md)

:fontawesome-regular-hand-point-right: John Ludlow’s :fontawesome-brands-github: [How to get kdb+ to talk to other databases :fontawesome-regular-file-pdf:](https://github.com/kxcontrib/jludlow/blob/master/docs/odbc.pdf)

:fontawesome-regular-hand-point-right: Charles Skelton’s :fontawesome-brands-github: [Babel for kdb+](https://github.com/CharlesSkelton/babel) for a simpler alternative to ODBC

