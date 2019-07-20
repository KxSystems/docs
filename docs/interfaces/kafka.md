---
title: Using Kafka with kdb+
description: How to connect a kdb+ server process to the Apache Kafka distributed streaming platform
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
keywords: apache, api, consumer, fusion, interface, kafka, learning, library, machine, producer, q
---
# ![Apache Kafka](img/kafka.png) Using Kafka with kdb+




<i class="fab fa-github"></i> [KxSystems/kafka](https://github.com/KxSystems/kafka)


`kfk` is a thin wrapper for kdb+ around the 
<i class="fab fa-github"></i> 
[edenhill/librdkafka](https://github.com/edenhill/librdkafka) 
C API for [Apache Kafka](https://kafka.apache.org/). 

Follow the [installation instructions](https://github.com/KxSystems/kafka#building-and-installation) for set-up.

To run examples on this page you will need a Kafka broker available. It is easy to [set up a local instance for testing](https://github.com/KxSystems/kafka#setting-up-test-kafka-instance).


## API

The library follows the `librdkafka` API closely where possible.
As per its [introduction](https://github.com/edenhill/librdkafka/blob/master/INTRODUCTION.md):

-   Base container `rd_kafka_t` is a client created by `.kfk.Client`. `.kfk.Producer` and `.kfk.Consumer` are provided for simplicity. Provides global configuration and shared state.
-   One or more topics `rd_kafka_topic_t`, which are either producers or consumers and created by function `.kfk.Topic` 

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

<i class="far fa-hand-point-right"></i> 
[<i class="fab fa-github"></i> KxSystems/kafka/test_producer.q](https://github.com/KxSystems/kafka/blob/master/test_producer.q)


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

<i class="far fa-hand-point-right"></i> 
[<i class="fab fa-github"></i> KxSystems/kafka/test_consumer.q](https://github.com/KxSystems/kafka/blob/master/test_consumer.q) for a slightly more elaborate version 


## Configuration

The library supports and uses all configuration options exposed by `librdkafka`, except callback functions, which are identical to Kafka options by design of `librdkafka`. 

<i class="far fa-hand-point-right"></i> 
[<i class="fab fa-github"></i> edenhill/librdkafka/CONFIGURATION.md](https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md) for a list of options


## Testing

Use can use either existing Kafka broker or start a test Kafka broker as described below.


### Setting up a test Kafka instance

<i class="far fa-hand-point-right"></i> 
[Apache Kafka tutorial](http://kafka.apache.org/documentation.html#quickstart)

Download and unzip Kafka.

```bash
$ cd $HOME
$ wget http://www-us.apache.org/dist/kafka/0.10.2.0/kafka_2.11-0.10.2.0.tgz
$ tar xzvf kafka_2.11-0.10.2.0.tgz
$ cd $HOME/kafka_2.11-0.10.2.0
```

Start `zookeeper`.

```bash
$ bin/zookeeper-server-start.sh config/zookeeper.properties
```

Start Kafka broker

```bash
$ bin/kafka-server-start.sh config/server.properties
```


### Running examples

Start producer.

```q
q)\l test_producer.q
q)\t 1000
```

Start consumer.

```q
q)\l test_consumer.q
```

The messages will now flow from producer to consumer and the publishing rate can be adjusted via `\t x` in the producer process.


## Performance and tuning

<i class="far fa-hand-point-right"></i> 
[<i class="fab fa-github"></i> edenhill/librdkafka/wiki/How-to-decrease-message-latency](https://github.com/edenhill/librdkafka/wiki/How-to-decrease-message-latency)

There are numerous configuration options and it is best to find settings that suit your needs and setup. See [Configuration](#configuration) above. 

