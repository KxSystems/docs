---
title: Using Kafka with kdb+ – Interfaces
description: How to connect a kdb+ server process to the Apache Kafka distributed streaming platform
keywords: apache, api, consumer, fusion, interface, kafka, learning, library, machine, producer, q
---
# ![Apache Kafka](../img/kafka.png) Using Kafka with kdb+




:fontawesome-brands-github: [KxSystems/kafka](https://github.com/KxSystems/kafka)


`kfk` is a thin wrapper for kdb+ around the 
 `librdkafka` C API (available on [MacOS/Linux](https://github.com/edenhill/librdkafka) or [Windows](https://www.nuget.org/packages/librdkafka.redist/1.0.0)) for [Apache Kafka](https://kafka.apache.org/).

Follow the [installation instructions](https://github.com/KxSystems/kafka#building-and-installation) for set-up.

To run examples on this page you will need a Kafka broker available. It is easy to [set up a local instance for testing](https://github.com/KxSystems/kafka#setting-up-test-kafka-instance).


## API

The library follows the `librdkafka` API closely where possible.
As per its [introduction](https://github.com/edenhill/librdkafka/blob/master/INTRODUCTION.md):

-   Base container `rd_kafka_t` is a client created by `.kfk.Client`. For ease of use `.kfk.Producer` and `.kfk.Consumer` are provided. These provide global configuration and shared states.
-   One or more topics `rd_kafka_topic_t`, which are either producers or consumers are created by the function `.kfk.Topic` 

Both clients and topics accept an optional configuration dictionary.
`.kfk.Client` and `.kfk.Topic` return an int which acts as a Client or Topic ID (index into an internal array). Client IDs are used to create topics and Topic IDs are used to publish or subscribe to data on that topic. They can also be used to query metadata – state of subscription, pending queues, etc.


### Minimal producer example

```q
\l kfk.q
// specify kafka brokers to connect to and statistics settings.
kfk_cfg:`metadata.broker.list`statistics.interval.ms!`localhost:9092`10000
// create producer with the config above
producer:.kfk.Producer[kfk_cfg]
// setup producer topic "test"
test_topic:.kfk.Topic[producer;`test;()!()]
// publish current time with a key "time"
.kfk.Pub[test_topic;.kfk.PARTITION_UA;string .z.t;"time"];
show "Published 1 message";
```

:fontawesome-regular-hand-point-right: 
[:fontawesome-brands-github: KxSystems/kafka/examples/test_producer.q](https://github.com/KxSystems/kafka/blob/master/examples/test_producer.q)


### Minimal consumer example

```q
\l kfk.q
// create consumer process within group 0
client:.kfk.Consumer[`metadata.broker.list`group.id!`localhost:9092`0];
data:();
// setup meaningful consumer callback(do nothing by default)
.kfk.consumecb:{[msg]
    msg[`data]:"c"$msg[`data];
    msg[`rcvtime]:.z.p;
    data,::enlist msg;}
// subscribe to the "test" topic with default partitioning
.kfk.Sub[client;`test;enlist .kfk.PARTITION_UA];
```

:fontawesome-regular-hand-point-right: 
[:fontawesome-brands-github: KxSystems/kafka/examples/test_consumer.q](https://github.com/KxSystems/kafka/blob/master/examples/test_consumer.q) for a slightly more elaborate version 


## Configuration

The library supports and uses all configuration options exposed by `librdkafka`, except callback functions, which are identical to Kafka options by design of `librdkafka`. 

:fontawesome-regular-hand-point-right: 
[:fontawesome-brands-github: edenhill/librdkafka/CONFIGURATION.md](https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md) for a list of options


## Testing

One can use either existing Kafka broker or start a test Kafka broker as described below.


### Setting up a test Kafka instance

To start a Kafka instance for testing follow the instructions outlined in the link below

:fontawesome-regular-hand-point-right: 
[Apache Kafka tutorial](http://kafka.apache.org/documentation.html#quickstart)

Zookeeper and a Kafka broker are initialized using the following commands.

Start `zookeeper`.

```bash
$ bin/zookeeper-server-start.sh config/zookeeper.properties
```

Start Kafka broker.

```bash
$ bin/kafka-server-start.sh config/server.properties
```


### Running examples

Start producer.

```q
q)\l test_producer.q
"Publishing on topic:test"
"Published 1 message"
topic              err     partitions                                        ..
-----------------------------------------------------------------------------..
test               Success ,`id`err`leader`replicas`isrs!(0i;`Success;0i;,0i;..
__consumer_offsets Success (`id`err`leader`replicas`isrs!(0i;`Success;0i;,0i;..
"Set timer with \t 1000 to publish message every second"
q)\t 1000
```

Start consumer.

```q
q)\l test_consumer.q
q)data
mtype topic client partition offset msgtime                       data       ..
-----------------------------------------------------------------------------..
      test  0      0         20616  2019.08.09D09:11:03.709000000 "2019.08.09..
      test  0      0         20617  2019.08.09D09:11:21.955000000 "2019.08.09..
      test  0      0         20618  2019.08.09D09:11:22.956000000 "2019.08.09..
      test  0      0         20619  2019.08.09D09:11:23.955000000 "2019.08.09..
      test  0      0         20620  2019.08.09D09:11:24.956000000 "2019.08.09..
      test  0      0         20621  2019.08.09D09:11:25.956000000 "2019.08.09..
```

The messages will now flow from producer to consumer, the publishing rate can be adjusted via `\t x` in the producer process.


## Performance and tuning

:fontawesome-regular-hand-point-right: 
[:fontawesome-brands-github: edenhill/librdkafka/wiki/How-to-decrease-message-latency](https://github.com/edenhill/librdkafka/wiki/How-to-decrease-message-latency)

There are numerous configuration options and it is best to find settings that suit your needs and setup. See [Configuration](#configuration) above. 
