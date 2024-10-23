---
title: kdb+ server for ODBC3 – Interfaces – kdb+ and q documentation
description: The ODBC3 server allows applications to query kdb+ via the ODBC interface.  
---
# :fontawesome-solid-database: kdb+ server for ODBC3


The ODBC3 driver allows applications to query kdb+ via the ODBC interface.  
:fontawesome-brands-github: [KxSystems/kdb/c/qodbc3.zip](https://github.com/KxSystems/kdb/blob/master/c/qodbc3.zip)

Currently the applications may run on the following platforms: w64, w32, l64, l32. Primary compatibility target has been [Tableau](https://www.tableau.com/), although other uses are welcome.

Requirements: V3.2 or later.

!!! tip "Reporting problems"

    When reporting a problem (e.g. SQL error, wrong results, slowness, segfault etc.) make sure to include steps to reproduce along with your [ODBC trace](#debugging).

:fontawesome-regular-map: [**Data visualization with kdb+ using ODBC**: a Tableau case study](../wp/data-visualization/index.md "White paper")

## Installation

### kdb+ configuration

The kdb+ process should be [listening on port](../basics/listening-port.md) which relates to the port choosen and defined in the odbc configuration.

Unzip qodbc3.zip, and copy `ps.k` to `$QHOME`. Ensure you have `ps.k` loaded into the kdb+ process:

```q
q)\l ps.k
```

Run `.s.ver` to check that ps.k has been loaded and for the current version e.g.
```q
q).s.ver
1.15
```

The following is an example of staring kdb+ with ps.k listening on port 5000

```bash
q ps.k -p 5000
```

### ODBC driver and DSN configuration

Software that uses ODBC connections refer to individual connections via a `DSN`(Data Source Name). 
The DSN details the ODBC driver (e.g. qodbc3) and connection details specific to the data source (e.g. hostname, username, etc).

The following details adding a new DSN to connect to kdb+:

#### Windows

The following details installing the ODBC driver and configuring a user or system DSN as an administrator.

1.  Close Tableau or anything that uses ODBC
2.  Extract qodbc3.zip to temporary location. Go to the directory corresponding to your OS architecture (w64 or w32)
3.  Run `d0.exe` as Administrator. This will copy `qodbc3.dll` to the correct location – you don’t need to do that yourself.
4.  You will now be able to add new kdb+ DSNs (data sources) in the `ODBC Data Source Administrator (64-bit)` (or `32-bit` if on 32-bit OS). Make sure to select `kdb+(odbc3)` in the list of drivers. You will be prompted for DSN name, hostname, port, username and password.
5.  Use `Test Connection` within the DSN configuration screen to check that the connection to kdb+ is working.

#### Linux

Requirements: [unixODBC](http://www.unixodbc.org) 2.3.4, [Binutils](https://www.gnu.org/software/binutils/) (ld)

Download :fontawesome-brands-github: [KxSystems/kdb/l64/c.o](https://github.com/KxSystems/kdb/blob/master/l64/c.o) to qodbc/l64

```bash
$ cd qodbc3/l64
$ ld -o qodbc3.so -shared qodbc3.o c.o -lodbc -lodbcinst -lm
```

The ODBC driver should be installed in the corresponding system `ini` file and a DSN entry created in either the system data sources (for all users) or user data source (current user).
The linux `odbcinst` tool can be used to find these locations if not known, for example:

```bash
$ odbcinst -j
unixODBC 2.3.7
DRIVERS............: /etc/odbcinst.ini
SYSTEM DATA SOURCES: /etc/odbc.ini
FILE DATA SOURCES..: /etc/ODBCDataSources
USER DATA SOURCES..: /root/.odbc.ini
SQLULEN Size.......: 8
SQLLEN Size........: 8
SQLSETPOSIROW Size.: 8
```

Add the driver to your list of drivers by editing the driver ini file ( `/etc/odbcinst.ini`). An example of the definition follows (note: the driver locaton should be altered to the location choosen on your system):

```ini
[kdb+(odbc3)]
Description     = ODBC for kdb+
Driver          = /src/qodbc3/l64/qodbc3.so
```

After adding, this can be verified by listing the system ODBC drivers:

```bash
$ odbcinst -q -d
[PostgreSQL]
[MySQL]
[FreeTDS]
[MariaDB]
[kdb+(odbc3)]
```

Add a DSN entry to your system data source file (`/etc/odbc.ini`) or user data source file (`~/.odbc.ini`), with the appropriate settings to communicate with the kdb+ server. For example:

```ini
[your_dsn_name]
Description=kdb+
Driver=kdb+(odbc3)
HOST=localhost:5000
UID=username
PWD=password
```

You should now be able to connect to kdb+ represented by the DSN with `isql`:

```bash
$ isql -3 -v -k 'DSN=your_dsn_name;'
```

### Tableau configuration

If there is a requirement to connect Tableau with kdb+, copy `q.tdc` to the appropriate directory for your application as detailed [here](https://help.tableau.com/current/pro/desktop/en-us/connect_customize.htm#installing-tdc-and-properties-files). 

Follow the Tableau directions for restarting Tableau Desktop/Server after the file is copied to the appropriate location.

The `q.tdc` file is a `Tableau Datasource Customization` (TDC) file to customize Tableau-specific settings for the kdb+ ODBC connection. The driver name within the file must match the name of the kdb+ driver installed (`kdb+(odbc3)`).

!!! note "The destination directory can be different depending on whether Tableau Desktop or Tableau Server is being used"

## Tableau Notes

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

## Debugging

ODBC implementations provide a tracing capability to log interactions with an ODBC driver. This can aid in diagnosing any issues. Tracing can have a detremental 
effect to ODBC performance.

This is a feature of the ODBC system, and not a feature unique to the kdb+ driver. Associated documentation, features and troubleshooting can be found online for your OS.

!!! warn "Connection details can be logged, therefore the log file should be stored in a private location"

### Windows

In the ODBC data source administrator, click _Start Tracing_ on the _Tracing_ tab. 

An example of the data recorded to the `SQL.LOG`:

```txt
powershell      da8-9a0	ENTER SQLExecDirectW
		        HSTMT               0x00000256C37A6920
                WCHAR *             0x00000256AA98112C [      -3] "SELECT * FROM t\ 0"
                SDWORD                    -3
...
powershell      da8-9a0	EXIT  SQLGetData  with return code 0 (SQL_SUCCESS)
		        HSTMT               0x00000256C37A6920
		        UWORD                        2
		        SWORD                       -8 <SQL_C_WCHAR>
		        PTR                 0x00000256A79BB1D0 [       2] "1"
		        SQLLEN                  4092
		        SQLLEN *            0x000000DAA198E160 (2)
```

Please ensure tracing is disabled after debugging complete.

### Linux

In the `[ODBC]` section of the driver ini file (`/etc/odbcinst.ini`), set `Trace` to `1` to enable tracing and `TraceFile` to the location of the log file to create. 
Additional configuration options are available. For example:

```txt
[ODBC]
Trace           = 1
TraceFile       = /tmp/odbc.log
TraceOptions    = 3
ODBCTraceFlush  = 1
```

An example of the data recorded:
```txt
[ODBC][194][1729684200.251390][SQLPrepare.c][196]
                Entry:
                        Statement = 0x55ba1f4cdb30
                        SQL = [select * from t][length = 15]
...
[ODBC][194][1729684200.252562][SQLGetData.c][237]
                Entry:
                        Statement = 0x55ba1f4cdb30
                        Column Number = 1
                        Target Type = 1 SQL_CHAR
                        Buffer Length = 301
                        Target Value = 0x55ba1f4cfd10
                        StrLen Or Ind = 0x7ffe4093ef20
```

Please ensure tracing is disabled after debugging complete.

