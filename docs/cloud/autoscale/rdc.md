---
title: Real-time data cluster | Auto Scaling for a kdb+ realtime database | Cloud | kdb+ and q documentation
description: An Auto Scaling group is used to maintain the RAM capacity of the realtime data cluster.
author: Jack Stapleton
date: September 2020
---
# Real-time data cluster




Instead of one large instance, our RDB will now be a cluster of smaller instances and the day’s real-time data will be distributed between them.
An Auto Scaling group will be used to maintain the RAM capacity of the cluster.
Throughout the day more data will be ingested by the tickerplant and added to the cluster.
The ASG will increase the number of instances in the cluster throughout the day in order to hold this new data.
At the end of the day, the day’s data will be flushed from memory and the ASG will scale the cluster in.


??? detail "Distributed RDBs"

    This solution has one obvious difference to a regular kdb+ system in that there are multiple RDB servers.
    User queries will need to be parsed and routed to each one to ensure the data can be retrieved effectively.

    Engineering a solution for this is beyond the scope of this article, but it will be tackled in the future.


## kdb+tick

The code here has been written to act as a wrapper around [kdb+tick’s](https://github.com/KxSystems/kdb-tick) `.u` functionality.
The code to coordinate the RDBs has been put in a new `.u.asg` namespace, its functions determine when to call `.u.sub` and `.u.del` to add and remove subscribers from `.u.w`.


## Scaling the cluster

On a high level the scaling method is quite simple.

1. A single RDB instance is launched and subscribes to the tickerplant.
2. When it fills up with data a second RDB will come up to take its place.
3. This cycle repeats throughout the day growing the cluster.
4. At end-of-day all but the latest RDB instances are shutdown.


## The subscriber queue

There is an issue with the solution outlined above.
An RDB will not come up at the exact moment its predecessor unsubscribes, so there are two scenarios that the tickerplant must be able to handle.

* The new RDB comes up too early.
* The new RDB does not come up in time.

If the RDB comes up too early, the tickerplant must add it to a queue, while remembering the RDB’s handle, and the subscription info.
If it does this, it can add the RDB to `.u.w` when it needs to.

If the RDB does not come up in time, the tickerplant must remember the last `upd` message it sent to the previous RDB.
When the RDB eventually comes up it can use this to recover the missing data from the tickerplant’s log file.
This will prevent any gaps in the data.

The tickerplant will store these details in `.u.asg.tab`.

```q
/ table used to handle subscriptions
/   time   - time the subscriber was added
/   handle - handle of the subscriber
/   tabs   - tables the subscriber has subscribed for
/   syms   - syms the subscriber has subscribed for
/   ip     - ip of the subscriber
/   queue  - queue the subscriber is a part of
/   live   - time the tickerplant addd the subscriber to .u.w
/   rolled - time the subscriber unsubscribed
/   firstI - upd count when subscriber became live
/   lastI  - last upd subscriber processed

.u.asg.tab: flip `time`handle`tabs`syms`queue`live`rolled`lastI!()
```
```q
q).u.asg.tab
time handle tabs syms ip queue live rolled firstI lastI
-------------------------------------------------------

```

The first RDB to come up will be added to this table and `.u.w`, it will then be told to replay the log.
We will refer to the RDB that is in `.u.w` and therefore currently being published to as **live**.

When it is time to roll to the next subscriber the tickerplant will query `.u.asg.tab`.
It will look for the handle, tables and symbols of the next RDB in the queue and make it the new **live** subscriber.
kdb+tick’s functionality will then take over and start publishing to the new RDB.


## Adding subscribers

To be added to `.u.asg.tab` a subscriber must call `.u.asg.sub`, it takes three parameters.

1. A list of tables to subscribe for.
2. A list of symbol lists to subscribe for (one symbol list for each of the tables).
3. The name of the queue to subscribe to.

If the RDB is subscribing to a queue with no **live** subscriber, the tickerplant will immediately add it to `.u.w` and tell it to replay the log.
This means the RDB cannot make multiple `.u.asg.sub` calls for each table it wants from the tickerplant.
Instead table and symbol lists are sent as parameters.
So multiple subscriptions can still be made.

```q
/ t - A list of tables (or ` for all).
/ s - Lists of symbol lists for each of the tables.
/ q - The name of the queue to be added to.

.u.asg.sub:{[t;s;q]
    if[-11h = type t;
            t: enlist t;
            s: enlist s];

    if[not (=) . count each (t;s);
            '"Count of table and symbol lists must match"];

    if[not all missing: t in .u.t,`;
            '.Q.s1[t where not missing]," not available"];

    `.u.asg.tab upsert
      (.z.p; .z.w; t; s; `$"." sv string 256 vs .z.a; q; 0Np; 0Np; 0N; 0N);

    liveProc: select from .u.asg.tab where not null handle,
                                           not null live,
                                           null rolled,
                                           queue = q;

    if[not count liveProc; .u.asg.add[t;s;.z.w]]; }
```

`.u.asg.sub` first carries out some checks on the arguments.

- Ensures `t` and `s` are enlisted.
- Checks that the count of `t` and `s` match.
- Checks that all tables in `t` are available for subscription.

A record is then added to `.u.asg.tab` for the subscriber.
Finally, `.u.asg.tab` is checked to see if there are other RDBs in the same queue.
If the queue is empty the tickerplant will immediately make this RDB the **live** subscriber.

```q
q).u.asg.tab
time                          handle tabs syms ip       queue                                          live                          rolled firstI lastI
--------------------------------------------------------------------------------------------------------------------------------------------------------
2020.04.13D23:36:43.518172000 7      ,`   ,`   10.0.1.5 rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg  2020.04.13D23:36:43.518223000        0
q).u.w
Quote| 7i `
Trade| 7i `
```

If there is already a live subscriber the RDB will just be added to the queue.

```q
q).u.asg.tab
time                          handle tabs syms ip        queue                                          live                          rolled firstI lastI
---------------------------------------------------------------------------------------------------------------------------------------------------------
2020.04.13D23:36:43.518172000 7                10.0.1.5  rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg  2020.04.13D23:36:43.518223000        0
2020.04.14D07:37:42.451523000 9                10.0.1.22 rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg
q).u.w
Quote| 7i `
Trade| 7i `
```


## The live subscriber

To make an RDB the live subscriber the tickerplant will call `.u.asg.add`.
There are two instances when this is called.

1. When an RDB subscribes to a queue with no live subscriber.
2. When the tickerplant is rolling subscribers.

```q
/ t - List of tables the RDB wants to subscribe to.
/ s - Symbol lists the RDB wants to subscribe to.
/ h - The handle of the RDB.

.u.asg.add:{[t;s;h]
  schemas: raze .u.subInner[;;h] .' flip (t;s);
  q: first exec queue from .u.asg.tab where handle = h;
  startI: max 0^ exec lastI from .u.asg.tab where queue = q;
  neg[h] @ (`.sub.rep; schemas; .u.L; (startI; .u.i));
  update live:.z.p, firstI:startI from `.u.asg.tab where handle = h; }
```

In `.u.asg.add` `.u.subInner` is called to add the handle to `.u.w` for each table.
This function is equivalent to kdb+tick’s `.u.sub` but it takes a handle as a third argument.
This change to `.u` will be discussed in a later section.

The tickerplant then calls `.sub.rep` on the RDB and the schemas, log file, and the log window are passed down as parameters.

Once the replay is kicked off on the RDB it is marked as the **live** subscriber in `.u.asg.tab`.


## Becoming the live subscriber

When the tickerplant makes an RDB the **live** subscriber it will call `.sub.rep` to initialize it.

```q
/ schemas   - table names and corresponding schemas
/ tplog     - file path of the tickerplant log
/ logWindow - start and end of the window needed in the log, (start;end)

.sub.rep:{[schemas;tplog;logWindow]
  .sub.live: 1b;
  (.[;();:;].) each schemas;
  .sub.start: logWindow 0;
  `upd set .sub.replayUpd;
  -11!(logWindow 1;tplog);
  `upd set .sub.upd;
  .z.ts: .sub.monitorMemory;
  system "t 5000"; }
```

The RDB first marks itself as live, then as in `tick/r.q` the RDBs will set the table schemas and replay the tickerplant’s log.


### Replaying the tickerplant log

In kdb+tick `.u.i` will be sent to the RDB.
The RDB will then replay that many `upd` messages from the log.
As it replays it inserts every row of data in the `upd` messages into the tables.

In our case we may not want to keep all of the data in the log as other RDBs in the cluster may be holding some of it.
This is why the `logWindow` is passed down by the tickerplant.

`logWindow` is a list of two integers.

1. The last `upd` message processed by the other RDBs in the same queue.
2. The last `upd` processed by the tickerplant, `.u.i`.


To replay the log `.sub.start` is set to the first element of `logWindow` and `upd` is set to `.sub.replayUpd`.
The tickerplant log replay is then kicked off with `-11!` until the second element in the `logWindow`, `.u.i`.

`.sub.replayUpd` is then called for every `upd` message.
With each `upd` it increments `.sub.i` until it reaches `.sub.start`.
From that point it calls `.sub.upd` to insert the data.

```q
.sub.replayUpd:{[t;data]
  if[.sub.i > .sub.start;
    if[not .sub.i mod 100; .sub.monitorMemory[]];
    .sub.upd[t;flip data];
    :(::);
    ];
  .sub.i+: 1; }

.sub.upd: {.sub.i+: 1; x upsert y}
```

One other function of `.sub.replayUpd` is to monitor the memory of the server while we are replaying.
This will protect the RDB in the case where there is too much data in the log to replay.
In this case the RDB will unsubscribe from the tickerplant and another RDB will continue the replay.

After the log has been replayed `upd` is set to `.sub.upd`, this will `upsert` data and keep incrementing `.sub.i` for every `upd` the RDB receives.
Finally the RDB sets `.z.ts` to `.sub.monitorMemory` and initializes the timer to run every five seconds.


## Monitoring RDB server memory

The RDB server’s memory is monitored for two reasons.

1. To tell the Auto Scaling group to scale out.
2. To unsubscribe from the tickerplant when full.


### Scaling out

As discussed in the [Auto Scaling in q](#auto-scaling-in-q) section, AWS CLI commands can take some time to run.
This could create some unwanted buffering in the RDB if they were to run while subscribed to the tickerplant.

To avoid this another q process runs separately on the server to coordinate the scale out.
It will continuously run `.mon.monitorMemory` to check the server’s memory usage against a scale threshold, say 60%.
If the threshold is breached it will increment the Auto Scaling group’s `DesiredCapacity` and set `.sub.scaled` to be true.
This will ensure the monitor process does not tell the Auto Scaling group to scale out again.

```q
.mon.monitorMemory:{[]
  if[not .mon.scaled;
    if[.util.getMemUsage[] > .mon.scaleThreshold;
      .util.aws.scale .aws.groupName;
      .mon.scaled: 1b;
    ];
  ]; }
```


### Unsubscribing

The RDB process runs its own timer function to determine when to unsubscribe from the tickerplant.
It will do this to stop the server from running out of memory.

```q
.sub.monitorMemory:{[]
  if[.sub.live;
    if[.util.getMemUsage[] > .sub.rollThreshold; .sub.roll[] ];
  ]; }
```

`.sub.monitorMemory` checks when the server’s memory usage breaches the `.sub.rollThreshold`.
It then calls `.sub.roll` on the tickerplant which will then roll to the next subscriber.


### Thresholds

Ideally `.mon.scaleThreshold` and `.sub.rollThreshold` will be set far enough apart so that the new RDB has time to come up before the tickerplant tries to roll to the next subscriber.
This will prevent the cluster from falling behind and reduce the number of `upd` messages that will need to be recovered from the log.


## Rolling subscribers

As discussed, when `.sub.rollThreshold` is hit the RDB will call `.sub.roll` to unsubscribe from the tickerplant.
From that point The RDB will not receive any more data, but it will be available to query.

```q
.sub.roll:{[]
  .sub.live: 0b;
  `upd set {[x;y] (::)};
  neg[.sub.TP] @ ({.u.asg.roll[.z.w;x]}; .sub.i); }
```

`.sub.roll` marks `.sub.live` as false and `upd` is set to do nothing so that no further `upd` messages are processed.
It will also call `.u.asg.roll` on the tickerplant, using its own handle and `.sub.i` (the last `upd` it has processed) as arguments.

```q
/ h    - handle of the RDB
/ subI - last processed upd message

.u.asg.roll:{[h;subI]
  .u.del[;h] each .u.t;
  update rolled:.z.p, lastI:subI from `.u.asg.tab where handle = h;
  q: first exec queue from .u.asg.tab where handle = h;
  waiting: select from .u.asg.tab where not null handle,
                                        null live,
                                        queue = q;
  if[count waiting; .u.asg.add . first[waiting]`tabs`syms`handle]; }
```

`.u.asg.roll` uses kdb+tick’s `.u.del` to delete the RDB’s handle from `.u.w`.
It then marks the RDB as **rolled** and `.sub.i` is stored in the `lastI` column of `.u.asg.tab`.
Finally `.u.asg.tab` is queried for the next RDB in the queue.
If one is ready the tickerplant calls `.u.asg.add` making it the new **live** subscriber and the cycle continues.

This switch to the new RDB may cause some latency in high volume systems.
The switch itself will only take a moment but there may be some variability over the network as the tickerplant starts sending data to a new server.
Implementing batching in the tickerplant could lessen this latency.

```q
q).u.asg.tab
time                          handle tabs syms ip         queue                                          live                          rolled                        firstI lastI
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2020.04.13D23:36:43.518172000 7                10.0.1.5   rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg  2020.04.13D23:36:43.518223000 2020.04.14D08:13:05.942338000 0      9746
2020.04.14D07:37:42.451523000 9                10.0.1.22  rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg  2020.04.14D08:13:05.942400000                               9746
q).u.w
Quote| 9i `
Trade| 9i `
```

If there is no RDB ready in the queue, the next one to subscribe up will immediately be added to `.u.w` and `lastI` will be used to recover from the tickerplant log.


## End of day

Throughout the day the RDB cluster will grow in size as the RDBs launch, subscribe, fill and roll.
`.u.asg.tab` will look something like the table below.

```q
q).u.asg.tab
time                          handle tabs syms ip         queue                                          live                          rolled                        firstI lastI
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2020.04.13D23:36:43.518172000 7                10.0.1.5   rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg  2020.04.13D23:36:43.518223000 2020.04.14D08:13:05.942338000 0      9746
2020.04.14D07:37:42.451523000 9                10.0.1.22  rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg  2020.04.14D08:13:05.942400000 2020.04.14D09:37:17.475790000 9746   19366
2020.04.14D09:14:14.831793000 10               10.0.1.212 rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg  2020.04.14D09:37:17.475841000 2020.04.14D10:35:36.456220000 19366  29342
2020.04.14D10:08:37.606592000 11               10.0.1.196 rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg  2020.04.14D10:35:36.456269000 2020.04.14D11:42:57.628761000 29342  39740
2020.04.14D11:24:45.642699000 12               10.0.1.42  rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg  2020.04.14D11:42:57.628809000 2020.04.14D13:09:57.867826000 39740  50112
2020.04.14D12:41:57.889318000 13               10.0.1.80  rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg  2020.04.14D13:09:57.867882000 2020.04.14D15:44:19.011327000 50112  60528
2020.04.14D14:32:22.817870000 14               10.0.1.246 rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg  2020.04.14D15:44:19.011327000                               60528
2020.04.14D16:59:10.663224000 15               10.0.1.119 rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg
```

Usually when end-of-day occurs `.u.end` is called in the tickerplant.
It informs the RDB which would write its data to disk and flush it from memory.
In our case when we do this the **rolled** RDBs will be sitting idle with no data.

To scale in `.u.asg.end` is called alongside kdb+tick’s `.u.end`.

```q
.u.asg.end:{[]
  notLive: exec handle from .u.asg.tab where not null handle,
                                             (null live) or not any null (live;rolled);
  neg[notLive] @\: (`.u.end; dt);
  delete from `.u.asg.tab where any (null handle; null live; not null rolled);
  update firstI:0 from `.u.asg.tab where not null live; }
```

The function first sends `.u.end` to all non live subscribers.
It then deletes these servers from `.u.asg.tab` and resets `firstI` to zero for all of the live RDBs.

```q
q).u.asg.tab
time                          handle tabs syms ip         queue                                           live                          rolled firstI lastI
-----------------------------------------------------------------------------------------------------------------------------------------------------------
2020.04.14D15:32:22.817870000 14               10.0.1.246 rdb-cluster-v1-RdbASGMicro-NWN25W2UPGWQ.r-asg   2020.04.14D15:44:19.011327000        0
```

When `.u.end` is called on the RDB it will delete the previous day’s data from each table.
If the process is live it will mark `.mon.scaled` to false on the monitor process so that it can scale out again when it refills.

If the RDB is not live and it has flushed all of its data it will terminate its own instance and reduce the `DesiredCapacity` of the ASG by one.

```q
.u.end: .sub.end;

.sub.end:{[dt]
  .sub.i: 0;
  .sub.clear dt+1; }

/ tm - clear all data from all tables before this time
.sub.clear:{[tm]
  ![;enlist(<;`time;tm);0b;`$()] each tables[];
  if[.sub.live;
    .Q.gc[];
    neg[.sub.MON] (set;`.mon.scaled;0b);
    :(::);
  ];
  if[not max 0, count each get each tables[];
    .util.aws.terminate .aws.instanceId
  ]; }
```


## Bringing it all together

The q scripts for the code outlined above are laid out in the same way as kdb+tick, i.e. `tickasg.q` is in the top directory with the RDB and `.u.asg` scripts in the directory below, `asg/`.

The code runs alongside kdb+tick so its scripts are placed in the same top directory.

```bash
$ tree q/
q
├── asg
│   ├── mon.q
│   ├── r.q
│   ├── sub.q
│   ├── u.q
│   └── util.q
├── tick
│   ├── r.q
│   ├── sym.q
│   ├── u.q
│   └── w.q
├── tickasg.q
└── tick.q
```

Starting the tickerplant is the same as in kdb+tick, but `tickasg.q` is loaded instead of `tick.q`.

```bash
q tickasg.q sym /mnt/efs/tplog -p 5010
```

### tickasg.q

```q
system "l tick.q"
system "l asg/u.q"

.tick.zpc: .z.pc;
.z.pc: {.tick.zpc x; .u.asg.zpc x;};

.tick.end: .u.end;
.u.end: {.tick.end x; .u.asg.end x;};
```

`tickasg.q` starts by loading in `tick.q`, `.u.tick` is called in this file so the tickerplant is started.
Loading in `asg/u.q` will initiate the `.u.asg` code on top of it.

`.z.pc` and `.u.end` are then overwritten to run both the `.u` and the `.u.asg` versions.

```q
.u.asg.zpc:{[h]
  if[not null first exec live from .u.asg.tab where handle = h;
    .u.asg.roll[h;0]
  ];
  update handle:0Ni from `.u.asg.tab where handle = h; }
```

`.u.asg.zpc` checks if the disconnecting RDB is the live subscriber and calls `.u.asg.roll` if so.
It then marks the handle as null in `.u.asg.tab` for any disconnection.

There are also some minor changes made to `.u.add` and `.u.sub` in `asg/u.q`.


### Changes to `.u`

`.u` will still work as normal with these changes.

The main change is needed because `.z.w` cannot be used in `.u.sub` or `.u.add` anymore.
When there is a queue of RDBs `.u.sub` will not be called in the RDB’s initial subscription call, so `.z.w` will not be the handle of the RDB we want to start publishing to.
To remedy this `.u.add` has been changed to take a handle as a third parameter instead of using `.z.w`.

The same change could not be made to `.u.sub` as it is the entry function for kdb+tick’s `tick/r.q`.
To keep `tick/r.q` working `.u.subInner` has been added, it is a copy of `.u.sub` but takes a handle as a third parameter.
`.u.sub` is now a projection of `.u.subInner`, it passes `.z.w` in as the third parameter.

#### tick/u.q
```q
\d .u
add:{$[ (count w x)>i:w[x;;0]?.z.w;
  .[`.u.w;(x;i;1);union;y];
  w[x],:enlist(.z.w;y) ];
  (x;$[99=type v:value x;sel[v]y;@[0#v;`sym;`g#]]) }

sub:{if[x~`;:sub[;y]each t];if[not x in t;'x];del[x].z.w;add[x;y]}
\d .
```


#### asg/u.q

```q
/ use 'z' instead of .z.w
add:{$[ (count w x)>i:w[x;;0]?z;
  .[`.u.w;(x;i;1);union;y];
  w[x],:enlist(z;y) ];
  (x;$[99=type v:value x;sel[v]y;@[0#v;`sym;`g#]]) }

/ use 'z' instead of .z.w and input as 3rd argument to .u.add
subInner:{if[x~`;:subInner[;y;z]each t];if[not x in t;'x];del[x]z;add[x;y;z]}
sub:{subInner[x;y;.z.w]}

\d .
```


### asg/r.q

When starting an RDB in Auto Scaling mode `asg/r.q` is loaded instead of `tick/r.q`.


```bash
q asg/r.q 10.0.0.1:5010
```

Where `10.0.0.1` is the private IP address of the tickerplant’s server.

```q
/q asg/r.q [host]:port[:usr:pwd]

system "l asg/util.q"
system "l asg/sub.q"

while[null .sub.TP: @[{hopen (`$":", .u.x: x; 5000)}; .z.x 0; 0Ni]];

while[null .sub.MON: @[{hopen (`::5016; 5000)}; (::); 0Ni]];

.aws.instanceId: .util.aws.getInstanceId[];
.aws.groupName: .util.aws.getGroupName[.aws.instanceId];

.sub.rollThreshold: getenv `ROLLTHRESHOLD;

.sub.live: 0b;

.sub.i: 0;

.u.end: {[dt] .sub.clear dt+1};

neg[.sub.TP] @ (`.u.asg.sub; `; `; `$ .aws.groupName, ".r-asg");
```

`asg/r.q` loads the scaling code in `asg/util.q` and the code to subscribe and roll in `asg/sub.q`.
Connecting to the tickerplant is done in a retry loop just in case the tickerplant takes some time to initially come up.
The script then sets the global variables outlined below.

```txt
.aws.instanceId      instance ID of its EC2 instance
.aws.groupName       name of its Auto Scaling group
.sub.rollThreshold   memory percentage threshold to unsubscribe
.sub.live            whether tickerplant is currently it sending data
.sub.scaled          whether it has launched a new instance
.sub.i               count of `upd` messages queue has processed
```


