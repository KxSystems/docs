---
title: Timezones and Daylight Savings Time – Knowledge Base – kdb+ and q documentation
description: Q has two built-in functions ltime and gtime which can be used to get the UTC time or local time according to the TZ shell environment setting.
keywords: daylight, kdb+, q, savings, time
---
# Timezones (TZ) and Daylight Savings Time (DST)




Q has two built-in functions `ltime` and `gtime` which can be used to get the UTC time or local time according to the TZ shell environment setting.

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

and then, using three functions

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

The timezone information can be generated using a brute-force approach in Java, and written to a CSV file using

```java
// Requires Java 11+
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Function;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import static java.time.ZoneOffset.UTC;
import static java.util.TimeZone.getTimeZone;
import static java.util.stream.Collectors.toMap;

public class WriteTzInfo {

    private static final ZonedDateTime startDate = ZonedDateTime.of(1900, 1, 1, 0, 0, 0, 0, UTC);
    private static final ZonedDateTime endDate = ZonedDateTime.of(2100, 1, 1, 0, 0, 0, 0, UTC);

    private static List<String> generateAdjustmentLines(String zoneName, ZoneId zoneId) {
        Logger.getLogger(WriteTzInfo.class.getName()).log(Level.INFO, "Processing {0}",zoneName);
        List<String> result = new ArrayList<>();
        ZoneOffset previousOffset = null;
        ZonedDateTime currentDate = startDate.withZoneSameInstant(zoneId);

        // Repeatedly increment by 1-minute, checking if the offset changes, and recording when this happens
        while (currentDate.isBefore(endDate)) {
            if (!currentDate.getOffset().equals(previousOffset)) {
                previousOffset = currentDate.getOffset();
                String timeUtcString = currentDate.withZoneSameInstant(UTC).format(DateTimeFormatter.ofPattern("yyyy.MM.dd'D'HH:mm:ss.SSS"));
                result.add(zoneName + "," + timeUtcString + "," + previousOffset.getTotalSeconds());
            }
            currentDate = currentDate.plusMinutes(1);
        }

        return result;
    }

    public static void main(String[] args) {
        System.setProperty("java.util.logging.SimpleFormatter.format", "%1$tF %1$tT %4$s %5$s%6$s%n");
        try (PrintWriter out = new PrintWriter(new FileWriter("tzinfo.csv"))) {
            out.println("timezoneID,gmtDateTime,gmtOffset");

            // Get all timezone ids by joining ZoneId (new) and TimeZone (legacy)
            // ZoneId doesn't include three-letter codes such as EST, and will convert these to a format such as -05:00
            // So we need to preserve the names that TimeZone uses
            Map<String, ZoneId> zoneIds = ZoneId.getAvailableZoneIds().stream().collect(toMap(Function.identity(), ZoneId::of));
            Arrays.stream(TimeZone.getAvailableIDs()).forEach(x -> zoneIds.merge(x, getTimeZone(x).toZoneId(), (zid, tz) -> zid));

            List<String> lines = zoneIds.entrySet().parallelStream()
                    .map(e -> generateAdjustmentLines(e.getKey(), e.getValue()))
                    .flatMap(Collection::stream)
                    .sorted()
                    .collect(Collectors.toList());

            for (String line : lines) {
                out.println(line);
            }

        } catch (IOException ex) {
            Logger.getLogger(WriteTzInfo.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
```

(note: above Java code creates times between years 1900 and 2100, and can be edited for different date periods).
Import into kdb+ and save to a binary file using

```q
q)t:("SPJ";enlist ",")0:`:tzinfo.csv;
q)update gmtOffset:`timespan$1000000000*gmtOffset from `t;
q)update localDateTime:gmtDateTime+gmtOffset from `t;
q)`gmtDateTime xasc `t;
q)update `g#timezoneID from `t;
q)`:tzinfo set t; / save file for easy distribution
```

and then, for use later, one needs only

```q
q)t:get`:tzinfo;
q)lg:{[tz;z] exec gmtDateTime+gmtOffset from aj[`timezoneID`gmtDateTime;([]timezoneID:tz;gmtDateTime:z);t]};
q)gl:{[tz;z] exec localDateTime-gmtOffset from aj[`timezoneID`localDateTime;([]timezoneID:tz;localDateTime:z);t]};
q)ttz:{[d;s;z]lg[d;gl[s;z]]}
```

Note that the most recent version of Java should be used to ensure that the latest timezone database is being used.

:fontawesome-brands-github: 
[KxSystems/cookbook/timezones/tzinfo.zip](https://github.com/KxSystems/cookbook/blob/master/timezones/tzinfo.zip) 
– zipped `tzinfo.csv` 

Alternatively you can use combination of `/usr/share/zoneinfo/zone.tab` and the `zdump` Unix command. 


