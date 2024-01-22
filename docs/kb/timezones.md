---
title: Timezones and Daylight Savings Time – Knowledge Base – kdb+ and q documentation
description: Q has two built-in functions ltime and gtime which can be used to get the UTC time or local time according to the TZ shell environment setting.
keywords: daylight, kdb+, q, savings, time
---
# Timezones (TZ) and Daylight Savings Time (DST)

Q has two built-in functions [`ltime`](../ref/gtime.md#ltime) and [`gtime`](../ref/gtime.md#gtime) which can be used to get the UTC time or local time according to the TZ shell environment setting.

One solution for more comprehensive timezone calculations is to have a table that contains the timezones, their UTC offsets, and the datetime of any DST changes. e.g.

```q
timezoneID    gmtDateTime                   gmtOffset            localDateTime                
----------------------------------------------------------------------------------------------
Europe/Zurich 2006.03.26D01:00:00.000000000 0D02:00:00.000000000 2006.03.26D03:00:00.000000000
Europe/Zurich 2006.10.29D01:00:00.000000000 0D01:00:00.000000000 2006.10.29D02:00:00.000000000
Europe/Zurich 2007.03.25D01:00:00.000000000 0D02:00:00.000000000 2007.03.25D03:00:00.000000000
Europe/Zurich 2007.10.28D01:00:00.000000000 0D01:00:00.000000000 2007.10.28D02:00:00.000000000
Europe/Zurich 2008.03.30D01:00:00.000000000 0D02:00:00.000000000 2008.03.30D03:00:00.000000000
Europe/Zurich 2008.10.26D01:00:00.000000000 0D01:00:00.000000000 2008.10.26D02:00:00.000000000
Europe/Zurich 2009.03.29D01:00:00.000000000 0D02:00:00.000000000 2009.03.29D03:00:00.000000000
Europe/Zurich 2009.10.25D01:00:00.000000000 0D01:00:00.000000000 2009.10.25D02:00:00.000000000
Europe/Zurich 2010.03.28D01:00:00.000000000 0D02:00:00.000000000 2010.03.28D03:00:00.000000000
Europe/Zurich 2010.10.31D01:00:00.000000000 0D01:00:00.000000000 2010.10.31D02:00:00.000000000
Europe/Zurich 2011.03.27D01:00:00.000000000 0D02:00:00.000000000 2011.03.27D03:00:00.000000000
Europe/Zurich 2011.10.30D01:00:00.000000000 0D01:00:00.000000000 2011.10.30D02:00:00.000000000
Europe/Zurich 2012.03.25D01:00:00.000000000 0D02:00:00.000000000 2012.03.25D03:00:00.000000000
```

and then, using three functions, where `t` is the timezone table:

```q
lg:{[tz;z] exec gmtDateTime+gmtOffset from aj[`timezoneID`gmtDateTime;([]timezoneID:tz;gmtDateTime:z);t]};
gl:{[tz;z] exec localDateTime-gmtOffset from aj[`timezoneID`localDateTime;([]timezoneID:tz;localDateTime:z);t]};
ttz:{[d;s;z]lg[d;gl[s;z]]}
```

one can transform between local time and UTC and vice-versa, for any specified timezone.

```q
q)lg[enlist `$"Europe/Zurich";enlist 2010.03.28D01:00:00.000]
,2010.03.28D03:00:00.000000000
q)gl[enlist `$"Europe/Zurich";enlist 2010.03.28D03:00:00.000]
,2010.03.28D01:00:00.000000000
```

and local times between timezones

```q
q)show ttz[enlist `$"America/New_York";enlist `$"Europe/Zurich";enlist 2010.03.28D03:00:00.000]
,2010.03.27D21:00:00.000000000
q)show ttz[enlist `$"America/New_York";enlist `$"Europe/Zurich";enlist .z.P]
,2010.01.20D07:00:08.088411000
```

## Generating Reference Data

### Via TimeZoneDB

TimeZoneDB provides a CSV generated from [IANA tz database](https://data.iana.org/time-zones/tz-link.html) which can be downloaded from [here](https://timezonedb.com/download). 
Please check any current license details [here](https://timezonedb.com);

The `time_zone.csv` can be loaded as follows:

```q
q)t:flip `timezoneID`gmtDateTime`gmtOffset`dst!("S  JIB";csv)0:`:time_zone.csv
q)delete from `t where gmtDateTime>=10170056837;      / remove any unix timestamps greater than our max timestamp
q)update gmtDateTime:12h$-946684800000000000+gmtDateTime*1000000000 from `t; / change datatype timestamp
q)update gmtOffset:16h$gmtOffset*1000000000 from `t;  / change datatype to timespan
q)update localDateTime:gmtDateTime+gmtOffset from `t; / create localtime when change occured
q)`gmtDateTime xasc `t;
q)update `g#timezoneID from `t;
```

### Via Java util

The timezone information can be generated using a brute-force approach in Java, and written to a CSV file using:

:fontawesome-brands-github:
[KxSystems/cookbook/timezones/WriteTzInfo.java](https://github.com/KxSystems/cookbook/blob/master/timezones/WriteTzInfo.java)

!!! note "Date Period"

    The above Java code creates times between years 1900 and 2100, and can be edited for different date periods

Import into kdb+ and save to a binary file using

```q
q)t:("SPJ";enlist ",")0:`:tzinfo.csv;
q)update gmtOffset:`timespan$1000000000*gmtOffset from `t;
q)update localDateTime:gmtDateTime+gmtOffset from `t;
q)`gmtDateTime xasc `t;
q)update `g#timezoneID from `t;
q)`:tzinfo set t; / save file for easy distribution
```

A previously generated CSV can be found at:

:fontawesome-brands-github: 
[KxSystems/cookbook/timezones/tzinfo.zip](https://github.com/KxSystems/cookbook/blob/master/timezones/tzinfo.zip) 
– zipped `tzinfo.csv` 

### Via Unix zdump

Alternatively you can use the `zdump` Unix command. 

Valid timezones supported by the system can be found in `/usr/share/zoneinfo/` e.g.

```q
q)system"zdump -v Africa/Cairo"
"Africa/Cairo  Fri Dec 13 20:45:52 1901 UTC = Fri Dec 13 22:45:52 1901 EET isdst=0"
"Africa/Cairo  Sat Dec 14 20:45:52 1901 UTC = Sat Dec 14 22:45:52 1901 EET isdst=0"
"Africa/Cairo  Sun Jul 14 21:59:59 1940 UTC = Sun Jul 14 23:59:59 1940 EET isdst=0"
"Africa/Cairo  Sun Jul 14 22:00:00 1940 UTC = Mon Jul 15 01:00:00 1940 EEST isdst=1"
...
```

for example, to load a table based on info from `Africa/Cairo`:

```q
t:([] timezoneID:(); gmtDateTime:(); gmtOffset:(); localDateTime:(); abbr:(); dst:());
mon:`Jan`Feb`Mar`Apr`May`Jun`Jul`Aug`Sep`Oct`Nov`Dec!("01";"02";"03";"04";"05";"06";"07";"08";"09";"10";"11";"12")
uptz:{[x;y]
  prepend:{if[1=count x;:"0",x];x};
  x:" " vs ssr[x;"  ";" "];
  t1:12h$value "" sv (x[5];enlist".";mon`$x[2];enlist".";prepend[x[3]];enlist"D";x[4];".000000000");
  t2:12h$value "" sv (x[12];enlist".";mon`$x[9];enlist".";prepend[x[10]];enlist"D";x[11];".000000000");
  y upsert (`$x[0];t1;t2-t1;t2;`$x[13];1h$parse @["=" vs x[14];1]);
  };
poptz:{[x;y]uptz[;`t] each system "zdump -v ",x;};

poptz["Africa/Cairo";`t];
```

