---
title: Loading and exporting with Bulk Copy Progam
description: Microsoft’s Bulk Copy Progam (bcp) is supported using the text format. 
keywords: bulk, copy, database, kdb+, load, microsoft, program, q, server, sql, upload
---
# Loading and exporting with bcp



Microsoft’s [Bulk Copy Progam](https://docs.microsoft.com/en-us/sql/tools/bcp-utility) (bcp) is supported using the text format. 


## Export
```q
`t.bcp 0:"\t"0:value flip t  / remove column headings
```


## Import
```q
flip cols!("types";"\t")0:`t.bcp /add headings
```


## Pumping data out and inserting it into SQL Server

Create the table in SQL Server if it doesn’t already exist.  
<i class="fab fa-github"></i> [KxSystems/kdb/c/odbc.k](https://github.com/KxSystems/kdb/blob/master/c/odbc.k)

Once the table exists in SQL Server:
```q
`t.bcp 0:"\t"0:value flip t
\bcp t in t.bcp -c -T
```

