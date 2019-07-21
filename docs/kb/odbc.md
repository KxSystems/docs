---
title: Using ODBC with kdb+
description: Q has limited support for ODBC. In general, ODBC is not recommended for large databases (for performance reasons) but may be acceptable for small databases, or for one-off data import and export.
keywords: database, kdb+, linux, odbc, odbc3, q, windows
---
# <i class="fas fa-database"></i> Using ODBC with kdb+





Q has limited support for ODBC. In general, ODBC is not recommended for large databases – for performance reasons – but may be acceptable for small databases, or for one-off data import and export.

-   in Windows and Linux, kdb+ can use ODBC to access a non-kdb+ database  
<i class="far fa-hand-point-right"></i> Interfaces: [Q client for ODBC](../interfaces/q-client-for-odbc.md)
-   in Windows only, a non-kdb+ client can use ODBC to access a kdb+ database  
<i class="far fa-hand-point-right"></i> Interfaces: [Simba/Magnitude ODBC drivers](../interfaces/odbc-simba.md)  
<i class="far fa-hand-point-right"></i> Interfaces: [Q server for ODBC3 ](../interfaces/q-server-for-odbc3.md)

<i class="far fa-hand-point-right"></i> John Ludlow’s <i class="fab fa-github"></i> [How to get kdb+ to talk to other databases <i class="far fa-file-pdf"></i>](https://github.com/kxcontrib/jludlow/blob/master/docs/odbc.pdf)

<i class="far fa-hand-point-right"></i> Charles Skelton’s <i class="fab fa-github"></i> [Babel for kdb+](https://github.com/CharlesSkelton/babel) for a simpler alternative to ODBC

