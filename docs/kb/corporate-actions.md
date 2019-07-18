---
title: Corporate actions – q and kdb+ Knowledge Base
description: Even routine corporate actions can have a significant impact on prices, volume and volatility. With q one typically captures raw tick data, and should a corporate action influence a previously captured price, an adjustment factor is applied to that raw data – this can be done on-the-fly, and hence can also be selective about which types of corporate actions are applied.
keywords: actions, corporate, kdb+, q
---
# Corporate actions




Even routine corporate actions can have a significant impact on prices, volume and volatility. With q one typically captures raw tick data, and should a corporate action influence a previously captured price, an adjustment factor is applied to that raw data – this can be done on-the-fly, and hence can also be selective about which types of corporate actions are applied.

Q is data-vendor agnostic, and as such you are free to choose which vendor to source corporate actions data from, one being [ActionsExchange](https://www.actionsxchange.com) who provide corporate action updates several times per day via an FTP site in a well-documented fixed-width ASCII format, or [ISO15022 MT564](http://www.iso15022.org/UHB/UHB2007/FINMT564.htm). [Telekurs](https://www.six-group.com/financial-information/en/site/six-id-x/overview.html) and [bme](http://www.bmemarketdata.es/) are other such vendors. 

If your vendor happens to provide adjustment factors, that is a nice-to-have, otherwise you’ll be tasked with calculating the adjustment factor from first principles – not difficult, but you’ll need further data such as close prices. Also, your corporate action vendor may provide each action with a confidence measure. 

!!! tip "Future-looking actions"

    Future-looking corporate actions can prepare traders for some upcoming unusual activities, e.g. special dividends.

Given a table that contains the raw corporate actions for a security, e.g.

```q
q)ca
date       sym caType   factor
------------------------------
2000.01.01 ABC split    0.5
2000.02.01 ABC dividend 0.98
2000.03.01 ABC bonus    0.8
2000.04.01 ABC dividend 0.97
```

and a table of trades

```q
q)t
date       sym price size
-------------------------
1995.01.01 ABC 100   100
2000.01.02 ABC 100   100
2000.02.02 ABC 100   100
2000.03.02 ABC 100   100
2000.04.02 ABC 100   100
2000.05.01 ABC 100   100
```

we can write a function `adjust` to apply the relevant adjustment factors for a date and sym

```q
getCAs:{[caTypes]
    / handles multiple corporate actions on one date
    t:0!select factor:prd factor by date-1,sym from ca where caType in caTypes;
    t,:update date:1901.01.01,factor:1.0 from ([]sym:distinct t`sym);
    t:`date xasc t;
    t:update factor:reverse prds reverse 1 rotate factor by sym from t;
    :update `g#sym from 0!t;
  };

adjust:{[t;caTypes]
    t:0!t;
    factors:enlist 1.0^aj[`sym`date;([] date:t`date;sym:t`sym);getCAs caTypes]`factor;
    mc:c where (lower c:cols t) like "*price"; / find columns to multiply
    dc:c where lower[c] like "*size"; / find columns to divide
    :![t;();0b;(mc,dc)!((*),/:mc,\:factors),((%),/:dc,\:factors)]; / multiply or divide out the columns
  };

/ get the adjustment factors considering all corporate actions
q)getCAs exec distinct caType from ca
date       sym factor
----------------------
1901.01.01 ABC 0.38024
2000.01.01 ABC 0.76048
2000.02.01 ABC 0.776
2000.03.01 ABC 0.97
2000.04.01 ABC 1

q)adjust[t;`dividend] / adjust trades for dividends only
date       sym price size
-----------------------------
1995.01.01 ABC 95.06 105.1967
2000.01.02 ABC 95.06 105.1967
2000.02.02 ABC 97    103.0928
2000.03.02 ABC 97    103.0928
2000.04.02 ABC 100   100
2000.05.01 ABC 100   100
```


## Further reading

-   [Corporate Actions: A Guide to Securities Event Management](http://www.amazon.com/Corporate-Actions-Securities-Management-Finance/dp/0470870664/ref=sr_1_1?ie=UTF8&qid=1321379060&sr=8-1)
-   [Corporate Actions – A Concise Guide: An Introduction to Securities Events](http://www.amazon.com/Corporate-Actions-Concise-Introduction-Securities/dp/1905641672/ref=sr_1_3?ie=UTF8&qid=1321379060&sr=8-3)
