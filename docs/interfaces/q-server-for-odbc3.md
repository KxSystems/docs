---
title: Kdb+ server for ODBC3 – Interfaces – kdb+ and q documentation
description: The ODBC3 server allows applications to query kdb+ via the ODBC interface.  
keywords: api, interface, kdb+, library, odbc, odbc3, q, SQL
---
# :fontawesome-solid-database: Kdb+ server for ODBC3



The ODBC3 server allows applications to query kdb+ via the ODBC interface.  
:fontawesome-brands-github: [KxSystems/kdb/c/qodbc3.zip](https://github.com/KxSystems/kdb/blob/master/c/qodbc3.zip)

Currently the applications may run on the following platforms: w64, w32, l64, l32. Primary compatibility target has been [Tableau](https://www.tableau.com/), although other uses are welcome.

Requirements: V3.2 or later.

!!! tip "Reporting problems"

    When reporting a problem (e.g. SQL error, wrong results, slowness, segfault etc.) make sure to include steps to reproduce along with your ODBC trace.


## Installation

### Windows

1.  Close Tableau or anything that uses ODBC
2.  Extract qodbc3.zip to temporary location. Go to the directory corresponding to your OS architecture (w64 or w32)
3.  Run `d0.exe` as Administrator. This will copy `qodbc3.dll` to the correct location – you don’t need to do that yourself.
4.  You will now be able to add new kdb+ DSNs (data sources) in the `ODBC Data Source Administrator (64-bit)` (or `32-bit` if on 32-bit OS). Make sure to select `kdb+(odbc3)` in the list of drivers. You will be prompted for DSN name, hostname, port, username and password.
5.  In the ODBC data source administrator, click _Start Tracing_ on the _Tracing_ tab.
6.  Copy `q.tdc` to My Documents\My Tableau Repository\Datasources
7.  Copy `ps.k` to `$QHOME`


### Linux

Requirements: [unixODBC](http://www.unixodbc.org) 2.3.4, [Binutils](https://www.gnu.org/software/binutils/) (ld)

Download :fontawesome-brands-github: [KxSystems/kdb/l64/c.o](https://github.com/KxSystems/kdb/blob/master/l64/c.o) to qodbc/l64

```bash
$ cd qodbc3/l64
$ ld -o qodbc3.so -shared qodbc3.o c.o -lodbc -lodbcinst -lm
```

Add a DSN entry to your `~/.odbc.ini` file:

```ini
[your_dsn_name]
Description=kdb+
Driver=/path/to/qodbc3.so
HOST=your.host:port
UID=username
PWD=password
```

You should now be able to connect to your DSN with `isql`:

```bash
$ isql -3 -v -k 'DSN=your_dsn_name;'
```


## Running

Ensure you have `ps.k` loaded into the kdb+ process specified in your DSN:

```q
q)\l ps.k
```


## Notes

To use q from Tableau’s Custom SQL use the `q()` function, e.g.:

`q('select p,name,color,city from f[]')` or  
`q('functionname',<parameter1>,<parameter2>)` or  
`   q('{f[x;y]}',<parameter1>,<parameter2>)`

Parameters can be supplied by Tableau. Note that Tableau’s _string_ type corresponds to q’s symbol and _datetime_ corresponds to timestamp.

`test.q` provides additional examples of SQL usage, including the create/insert/update/delete statement syntax.


## Compatibility

The driver translates SQL expressions into q and inherits q’s data model. This gives rise to the following SQL compatibility issues:

1.  SQL string literals are trimmed like q symbols
2.  `MIN()` and `MAX()` don't work on strings
3.  q strings and bools lack nulls, therefore SQL operations on null data resulting in these types ‘erase’ nulls
4.  `COUNT` and `COUNT DISTINCT` don’t ignore nulls

Also, SQL selects from partitioned tables are not supported – one should pre-select from a partitioned table using the `q()` function instead.

