---
title: Timezones and Daylight Savings Time
description: Q has two built-in functions ltime and gtime which can be used to get the UTC time or local time according to the TZ shell environment setting.
keywords: daylight, kdb+, q, savings, time
---
# Timezones (TZ) and Daylight Savings Time (DST)




Q has two built-in functions `ltime` and `gtime` which can be used to get the UTC time or local time according to the TZ shell environment setting.

One solution for more comprehensive timezone calculations is to have a table that contains the timezones, their UTC offsets, and the datetime of any DST changes. e.g.

```q
timezoneID    gmtDateTime                   gmtOffset            dstOffset
-------------------------------------------------------------------------------------
Europe/Zurich 2006.10.29D01:00:00.000000000 0D01:00:00.000000000 0D00:00:00.000000000
Europe/Zurich 2007.03.25D01:00:00.000000000 0D01:00:00.000000000 0D01:00:00.000000000
Europe/Zurich 2007.10.28D01:00:00.000000000 0D01:00:00.000000000 0D00:00:00.000000000
Europe/Zurich 2008.03.30D01:00:00.000000000 0D01:00:00.000000000 0D01:00:00.000000000
Europe/Zurich 2008.10.26D01:00:00.000000000 0D01:00:00.000000000 0D00:00:00.000000000
Europe/Zurich 2009.03.29D01:00:00.000000000 0D01:00:00.000000000 0D01:00:00.000000000
Europe/Zurich 2009.10.25D01:00:00.000000000 0D01:00:00.000000000 0D00:00:00.000000000
Europe/Zurich 2010.03.28D01:00:00.000000000 0D01:00:00.000000000 0D01:00:00.000000000
Europe/Zurich 2010.10.31D01:00:00.000000000 0D01:00:00.000000000 0D00:00:00.000000000
Europe/Zurich 2011.03.27D01:00:00.000000000 0D01:00:00.000000000 0D01:00:00.000000000
Europe/Zurich 2011.10.30D01:00:00.000000000 0D01:00:00.000000000 0D00:00:00.000000000
Europe/Zurich 2012.03.25D01:00:00.000000000 0D01:00:00.000000000 0D01:00:00.000000000
Europe/Zurich 2012.10.28D01:00:00.000000000 0D01:00:00.000000000 0D00:00:00.000000000
```

and then, using three functions

```q
lg:{[tz;z] exec gmtDateTime+adjustment from aj[`timezoneID`gmtDateTime;([]timezoneID:tz;gmtDateTime:z);t]};
gl:{[tz;z] exec localDateTime-adjustment from aj[`timezoneID`localDateTime;([]timezoneID:tz;localDateTime:z);t]};
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

The timezone information can be generated using a brute-force approach in Java, and written to a CSV file using

```java
#!java
package dst;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.TimeZone;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Main {
    public static void main(String[] args) {
        PrintWriter out = null;
        try {
            out = new PrintWriter(new FileWriter("tzinfo.csv"));
            out.println("timezoneID,gmtDateTime,gmtOffset,dstOffset");
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd'D'HH:mm:ss.SSS");
            formatter.setTimeZone(TimeZone.getTimeZone("GMT"));
            String[] timezones = TimeZone.getAvailableIDs();
            for (int i = 0; i < timezones.length; i++) {
                TimeZone tz = TimeZone.getTimeZone(timezones[i]);
                boolean prevDst = false;
                Calendar cal = GregorianCalendar.getInstance(tz);
                cal.clear();
                cal.set(1970, 0, 1);
                int nMins=365 * 60 * 60 * 24;
                for (int j = 0; j < nMins; j++) {
                    cal.add(Calendar.MINUTE, 1);
                    boolean dst = tz.inDaylightTime(cal.getTime());
                    if ((dst != prevDst) || j==0) {
                        out.println(timezones[i] + "," + formatter.format(cal.getTime()) + "," +
                                    tz.getRawOffset()/1000 + "," + (dst ? tz.getDSTSavings()/1000 : 0));
                        prevDst = dst;
                    }
                }
            }
        } catch (IOException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            out.close();
        }
    }
}
```

and import into kdb+ and save to a binary file using

```q
q)t:("SPJJ";enlist ",")0:`:tzinfo.csv;
q)update gmtOffset:`timespan$1000000000*gmtOffset,dstOffset:`timespan$1000000000*dstOffset from `t;
q)update adjustment:gmtOffset+dstOffset from `t;
q)update localDateTime:gmtDateTime+adjustment from `t;
q)`gmtDateTime xasc `t;
q)update `g#timezoneID from `t;
q)`:tzinfo set t; / save file for easy distribution
```

and then, for use later, one needs only

```q
q)t:get`:tzinfo;
q)lg:{[tz;z] exec gmtDateTime+adjustment from aj[`timezoneID`gmtDateTime;([]timezoneID:tz;gmtDateTime:z);t]};
q)gl:{[tz;z] exec localDateTime-adjustment from aj[`timezoneID`localDateTime;([]timezoneID:tz;localDateTime:z);t]};
q)ttz:{[d;s;z]lg[d;gl[s;z]]}
```

Note that the most recent version of Java should be used to ensure that the latest timezone database is being used.

<i class="fab fa-github"></i> 
[KxSystems/cookbook/timezones/tzinfo.zip](https://github.com/KxSystems/cookbook/blob/master/timezones/tzinfo.zip) 
– zipped `tzinfo.csv` 

Alternatively you can use combination of `/usr/share/zoneinfo/zone.tab` and the `zdump` Unix command. 


