---
title: Publish and subscribe
description: KxSystems/kdb-tick contains functionality to allow processes to publish data and subscribe to it. It is worth highlighting how the publish-and-subscribe code can be used by any process on a standalone basis. The pubsub functionality is supplied in the u.q script of kdb+tick.
keywords: kdb+, publish, q, subscribe
---
# Publish and subscribe




<i class="fab fa-github"></i> 
[KxSystems/kdb-tick](https://github.com/KxSystems/kdb-tick) 
contains functionality to allow processes to publish data and subscribe to it. It is worth highlighting how the publish-and-subscribe code can be used by any process on a standalone basis. The pubsub functionality is supplied in the `u.q` script of kdb+tick.

To give the ability to publish data to any process, a few things need to be done:

-   load `u.q`
-   declare the tables to be published in the top level namespace. Each table must contain a column called `sym`, which acts as the single key field to which subscribers subscribe
-   initialise by calling `.u.init[]`
-   publish data by calling `.u.pub[table name; table data]`

The list of tables that can be published and the processes currently subscribed are held in `.u.w`. When a client process closes a connection, it is removed from `.u.w`.

Subscriber processes must open a connection to the publisher and call `.u.sub[tablename;list_of_symbols_to_subscribe_to]`. 

`.u.sub` can be called synchronously or asynchronously. If `.u.sub` is called synchronously, the table schema is returned to the client. If the table being subscribed to is a keyed table, then the current value for each subscribed `sym` is returned, assuming it is stored. Otherwise, an empty schema definition is returned. Specifying `` ` `` for either parameter of `.u.sub` means _all_ – all tables, all syms, or all tables and all syms.

If a subscriber calls `.u.sub` again, the current subscription will be overwritten either for all tables (if a wildcard is used) or the specified table. To add to a subscription (e.g. add more syms to a current subscription) the subscriber can call `.u.add`.


The example scripts below can be downloaded from GitHub. Each script should be run from the OS command prompt e.g.

```bash
$ q publisher.q
$ q subscriber.q
```
 <i class="fab fa-github"></i> 
 [KxSystems/cookbook/pubsub](https://github.com/KxSystems/cookbook/tree/master/pubsub)


## Publisher 

The code below will generate some random data and publish it periodically on a timer.

```q
\d .testdata

// set the port
@[system;"p 6812";{-2"Failed to set port to 6812: ",x,
                     ". Please ensure no other processes are running on that port",
                     " or change the port in both the publisher and subscriber scripts.";
                     exit 1}]

// create some test data to be published
// this could also be read from a csv file (for example)
meterdata:([]sym:10000?200j; reading:10000?500i)
griddata:([]sym:2000?100?`3; capacity:2000?100f; flowrate:2000?3000i)

// utility functions to get the next set of data to publish
// get the next chunk of data, return to start once data set is exhausted
counts:`.testdata.meterdata`.testdata.griddata!0 0
getdata:{[table;n]
 res:`time xcols update time:.z.p from (counts[table];n) sublist value table;
 counts[table]+:n;
 if[count[value table]<=counts[table]; counts[table]:0];
 res}
getmeter:getdata[`.testdata.meterdata]
getgrid:getdata[`.testdata.griddata]

\d .

// the tables to be published - all must be in the top level namespace
// tables to be published require a sym column, which can be of any type
// apart from that, they can be anything you like
meter:([]time:`timestamp$(); sym:`long$(); reading:`int$())
grid:([]time:`timestamp$(); sym:`symbol$(); capacity:`float$(); flowrate:`int$())

// load in u.q from tick
upath:"tick/u.q"
@[system;"l ",upath;{-2"Failed to load u.q from ",x," : ",y,
                       ". Please make sure u.q is accessible.",
                       " kdb+tick can be downloaded from https://github.com/KxSystems/kdb-tick";
                       exit 2}[upath]]

// initialise pubsub
// all tables in the top level namespace (`.) become publish-able
// tables that can be published can be seen in .u.w
.u.init[]

// functions to publish data
// .u.pub takes the table name and table data
// there is no checking to ensure that the table being published matches
// the table schema defined at the top level
// that is left up to the programmer!
publishmeter:{.u.pub[`meter; .testdata.getmeter[x]]}
publishgrid:{.u.pub[`grid; .testdata.getgrid[x]]}

// create timer function to randomly publish
// between 1 and 10 meter records, and between 1 and 5 grid records
.z.ts:{publishmeter[1+rand 10]; publishgrid[1+rand 5]}

/- fire timer every 1 second
\t 1000
```


## Subscriber 

```q
// define upd function
// this is the function invoked when the publisher pushes data to it
upd:{[tabname;tabdata] show tabname; show tabdata}

// open a handle to the publisher
h:@[hopen;`::6812;{-2"Failed to open connection to publisher on port 6812: ",
                     x,". Please ensure publisher is running";
                     exit 1}]

// subscribe to the required data
// .u.sub[tablename; list of instruments]
// ` is wildcard for all
h(`.u.sub;`;`)

\
Could also do (for example)

Subscribe to 10 syms of meter data:
h(`.u.sub;`meter;`long$til 10)

Add subscriptions
h(`.u.add;`meter;20 21 22j)
```


## Running

The subscriber will receive data from the publisher and output it to the screen. You can modify the subscription request and the `upd` function of the subscriber as required. You can run multiple subscribers at once.
