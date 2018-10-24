# Kdb+ tickerplant overview

A kdb+ tickerplant is a q process specifically designed to handle
incoming high-frequency data feeds from publishing process. Its primary
responsibility is the management of subscription requests and the fast
publication of data to subscribers. The following diagram illustrates a
simple dataflow of a potential kdb+ tick system:

![Simple dataflow of a potential kdb+ tick system](media/image2.png)

<i class="fa fa-hand-o-right"></i> [_Building Real-time Tick Subscribers_](/wp/building_real_time_tick_subscribers.pdf) regarding the above vanilla setup

Of interest in this whitepaper are the Java publisher and subscriber processes. As the kdb+ tick system is very widely used, both of these kinds of processes are highly likely to come up in development tasks involving kdb+ interfacing.


## Test tickerplant and feedhandler setup

To facilitate the testing of Java subscriber processes we can implement
example q processes freely available in the Kx repository. Simulation of
a tickerplant can be achieved with
[`tick.q`](https://github.com/KxSystems/kdb-tick/blob/master/tick.q);
Trade data, using the trade schema defined in `sym.q`, can then be
published to this tickerplant using the definition for the file `feed.q`
given here:
```q
// q feed.q / with a default port of 5010 and default timer of 1000
// q feed.q -port 10000 / with a default timer of 1000
// q feed.q -port 10000 -t 2000

tph:hopen $[0=count .z.x;5010;"J"$first .Q.opt\[.z.x]`port]
if[not system"t";system"t 1000"]

publishTradeToTickerPlant:{
  nRows:first 1?1+til 3;
  tph(".u.upd";`trade;(nRows#.z.N;nRows?`IBM`FB`GS`JPM;nRows?150.35;nRows?1000));
  }

.z.ts:{
  publishTradeToTickerPlant[];
  }
```
The tickerplant and feed handlers can then be started by executing the
following commands consecutively:
```bash
$ q tick.q sym -t 2000
$ q feed.q
```
Once the feedhandler is publishing to the tickerplant, processes can
connect to it in order either to publish or subscribe to it.

It should be noted that in this example and below we are using a
Java process to subscribe to a tickerplant being fed directly
by a simulated feed. While we are doing this here in order to
facilitate a simple example setup, in production this is not
usually encouraged. Processes such as Java subscribers would generally
connect to derivative kdb+ processes such as chained tickerplants (as in the above diagram),
for which standard publishing and subscription logic should be
the same as that covered here.


