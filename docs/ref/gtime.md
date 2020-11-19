---
title: gtime, ltime – global and local time | Reference | kdb+ and q documentation
description: gtime and ltime are q keywords that return, respectively, global and local time.
author: Stephen Taylor
---
# `gtime`, `ltime`

_Global and local time_




## `gtime`

_UTC equivalent of local timestamp_

```txt
gtime ts    gtime[ts]
```

Where `ts` is a datetime/timestamp, returns the UTC datetime/timestamp.

```q
q).z.p
2009.10.20D10:52:17.782138000
q)gtime .z.P                      / same timezone as .z.p
2009.10.20D10:52:17.783660000
```



## `ltime`

_Local equivalent of UTC timestamp_

```txt
ltime ts    ltime[ts]
```

Where `ts` is a datetime/timestamp, returns the local datetime/timestamp.

```q
q).z.P
2009.11.05D15:21:10.040666000
q)ltime .z.p                  / same timezone as .z.P
2009.11.05D15:21:10.043235000
```


## System clocks

UTC and local datetime/timestamps are available as

<div markdown="1" class="typewriter">
scope   datetime     timestamp
\------------------------------
UTC     [`.z.z`](dotz.md#zz-utc-datetime)         [`.z.p`](dotz.md#zp-utc-timestamp)
local   [`.z.Z`](dotz.md#zz-local-datetime)         [`.z.P`](dotz.md#zp-local-timestamp)
</div>

----

:fontawesome-solid-book-open:
[Environment](../basics/by-topic.md#environment)