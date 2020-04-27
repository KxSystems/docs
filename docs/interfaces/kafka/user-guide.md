---
title: Guide for using Kafka with kdb+
author: Conor McCarthy
description: Lists functions available for use within the Kafka API for kdb+ and gives limitations as well as examples of each being used 
date: September 2019
keywords: broker, consumer, kafka, producer, publish, subscribe, subscription, topic
---
# <i class="fa fa-share-alt"></i> User guide 


As outlined in the overview for this API, the kdb+/Kafka interface is a thin wrapper for kdb+ around the [`librdkafka`](https://github.com/edenhill/librdkafka) C API for [Apache Kafka](https://kafka.apache.org/). 

<i class="fab fa-github"></i>
[KxSystems/kafka](https://github.com/KxSystems/kafka)

The following functions are those exposed within the `.kfk` namespace allowing users to interact with Kafka from a kdb+ instance.

```txt
Kafka interface functionality
  // client functionality 
  .kfk.ClientDel               Close consumer and destroy Kafka handle to client
  .kfk.ClientName              Kafka handle name
  .kfk.ClientMemberId          Client's broker assigned member ID
  .kfk.Consumer                Create a consumer according to defined configuration

  // offset based functionality
  .kfk.CommitOffsets           Commit offsets on broker for provided partition list
  .kfk.PositionOffsets         Current offsets for topics and partitions
  .kfk.CommittedOffsets        Retrieve committed offsets for topics and partitions
  .kfk.AssignOffsets           Assignment of partitions to consume

  // pub-sub functionality
  .kfk.Pub                     Publish a message to a defined topic
  .kfk.OutQLen                 Current out queue length
  .kfk.Sub                     Subscribe to a defined topic
  .kfk.Unsub                   Unsubscribe from a topic
  .kfk.Subscription            Most recent topic subscription
  .kfk.Producer                Create a producer according to defined configuration
  .kfk.Poll                    Manually poll the feed

  // system infomation
  .kfk.Metadata                Broker Metadata
  .kfk.Version                 Librdkafka version
  .kfk.VersionSym              Human readable Librdkafka version
  .kfk.ThreadCount             Number of threads being used by librdkafka

  // topic functionality
  .kfk.Topic                   Create a topic on which messages can be sent
  .kfk.TopicDel                Delete a defined topic
  .kfk.TopicName               Topic Name
```

For simplicity in each of the examples below it should be assumed that the user’s system is configured correctly, unless otherwise specified. For example:

1. If subscribing to a topic, this topic exists.
2. If an output is presented, the output reflects the system used in the creation of these examples.


## Clients

The following functions relate to the creation of consumers and producers and their manipulation/interrogation.


### `.kfk.ClientDel`

_Close a consumer and destroy the associated Kafka handle to client_

Syntax: `.kfk.ClientDel[x]`

Where

-   `x` is an integer denoting the client to be deleted

returns null on successful deletion of a client. If client unknown, signals `'unknown client`.

```q
/Client exists
q).kfk.ClientName[0i]
`rdkafka#consumer-1
q).kfk.ClientDel[0i]
q).kfk.ClientName[0i]
'unknown client
/Client can no longer be deleted
q).kfk.ClientDel[0i]
'unknown client
```


### `.kfk.ClientMemberId`

_Client's broker-assigned member ID_

Syntax: `.kfk.ClientMemberId[x]`

Where

-   `x` is an integer denoting the requested client name

returns the member ID assigned to the client.

!!! warning "Consumer processes only"

    This function should be called only on a consumer process. This is an [external limitation](https://docs.confluent.io/2.0.0/clients/librdkafka/rdkafka_8h.html#a856d7ecba1aa64e5c89ac92b445cdda6).

```q
q).kfk.ClientMemberId[0i]
`rdkafka-881f3ee6-369b-488a-b6b2-c404d45ebc7c
q).kfk.ClientMemberId[1i]
'unknown client
```


### `.kfk.ClientName`

_Kafka handle name_

Syntax: `.kfk.ClientName[x]`

Where

-   `x` is an integer denoting the requested client name

returns assigned client name.

```q
q).kfk.ClientName[0i]
`rdkafka#producer-1
/Client removed
q).kfk.ClientName[1i]
'unknown client
```


### `.kfk.Consumer`

_Create a consumer according to user-defined configuration_

Syntax: `.kfk.Consumer[x]`

Where

-   `x` is a dictionary user-defined configuration

returns an integer denoting the ID of the consumer.

```q
q)kfk_cfg
metadata.broker.list  | localhost:9092
group.id              | 0
queue.buffering.max.ms| 1
fetch.wait.max.ms     | 10
statistics.interval.ms| 10000
q).kfk.Consumer[kfk_cfg]
0i
```


### `.kfk.Producer`

_Create a producer according to user-defined configuration_

Syntax: `.kfk.Producer[x]`

Where

-   `x` is a user-defined dictionary configuration

returns an integer denoting the ID of the producer.

```q
q)kfk_cfg
metadata.broker.list  | localhost:9092
statistics.interval.ms| 10000
queue.buffering.max.ms| 1
fetch.wait.max.ms     | 10
q).kfk.Producer[kfk_cfg]
0i
```


### `.kfk.SetLoggerLevel`

_Set the maximum logging level for a client_

Syntax: `.kfk.SetLoggerLevel[x;y]`

Where

-   `x` is an integer denoting the client ID
-   `y` is an int/long/short denoting the syslog severity level

returns a null on successful application of function.

```q
q)show client
0i
q).kfk.SetLoggerLevel[client;7]
```


## Offset functionality

The following functions relate to use of offsets within the API to ensure records are read correctly from the broker.

!!! note "Multiple topic offset assignment"

    As of v1.4.0 offset functionality can now handle calls associated with multiple topics without overwriting previous definitions. To apply the functionality this must be called for each topic.

### `.kfk.CommitOffsets`

_Commit offsets on broker for provided partitions and offsets_

Syntax: `.kfk.CommitOffsets[x;y;z;r]`

Where

-   `x` is the integer value associated with the consumer client ID
-   `y` is a symbol denoting the topic
-   `z` is a dictionary of partitions(ints) and last received offsets (longs)
-   `r` is a boolean denoting if commit will block until offset commit is complete or not, 0b = non blocking

returns a null on successful commit of offsets.


### `.kfk.PositionOffsets`

_Current offsets for particular topics and partitions_

Syntax: `.kfk.PositionOffsets[x;y;z]`

Where

-   `x` is the integer value associated with the consumer ID
-   `y` is a symbol denoting the topic
-   `z` is a list of int/short or long partitions or a dictionary of partitions(int) and offsets(long)

returns a table containing the current offset and partition for the topic of interest.

```q
q)client:.kfk.Consumer[kfk_cfg];
q)TOPIC:`test
q)show seen:exec last offset by partition from data;
0|0
// dictionary input
q).kfk.PositionOffsets[client;TOPIC;seen]
topic partition offset metadata
-------------------------------
test  0         26482  ""
// int list input
q).kfk.PositionOffsets[client;TOPIC;0 1i]
topic partition offset metadata
-------------------------------
test  0         26482  ""
test  1         -1001  ""
// long list input
q).kfk.PositionOffsets[client;TOPIC;0 1 2]
topic partition offset metadata
-------------------------------
test  0         26482  ""
test  1         -1001  ""
test  2         -1001  ""
```


### `.kfk.CommittedOffsets`

_Retrieve the last-committed offset for a topic on a particular partition_

Syntax: `.kfk.CommittedOffsets[x;y;z]`

Where

-   `x` is the integer value associated with the consumer ID
-   `y` is a symbol denoting the topic
-   `z` is a list of int/short or long partitions or a dictionary of partitions(int) and offsets(long)

returns a table containing the offset for a particular partition for a topic.

```q
q)client:.kfk.Consumer[kfk_cfg];
q)TOPIC:`test
q)show seen:exec last offset by partition from data;
0|0
// dictionary input
q).kfk.CommittedOffsets[client;TOPIC;seen]
topic partition offset metadata
-------------------------------
test  0         26481  ""
// integer list input
q).kfk.CommittedOffsets[client;TOPIC;0 1i]
topic partition offset metadata
-------------------------------
test  0         26481  ""
test  1         -1001  ""
// long list input
q).kfk.CommittedOffsets[client;TOPIC;0 1]
topic partition offset metadata
-------------------------------
test  0         26481  ""
test  1         -1001  ""
```


### `.kfk.AssignOffsets`

_Assignment of the partitions to be consumed_

Syntax: `.kfk.AssignOffsets[x;y;z]`

Where

-   `x` is the integer value associated with the consumer ID.
-   `y` is a symbol denoting the topic.
-   `z` is a dictionary with key denoting the partition and value denoting where to start consuming the partition.

returns a null on successful execution.

```q
q).kfk.OFFSET.END   // start consumption at end of partition
-2
q).kfk.OFFSET.BEGINNING // start consumption at start of partition
-1
q).kfk.AssignOffsets[client;TOPIC;(1#0i)!1#.kfk.OFFSET.END]
```

!!! note "Last-committed offset"

  	In the above examples an offset of -1001 is a special value. It indicates the offset could not be determined and the consumer will read from the last-committed offset once one becomes available.


## Subscribe and publish

### `.kfk.Pub`

_Publish a message to a defined topic_

Syntax: `.kfk.Pub[x;y;z;r]`

Where

-   `x` is the integer of the topic to be published on
-   `y` is an integer denoting the target partition
-   `z` is a string which incorporates the payload to be published
-   `r` is a key as a string to be passed with the message to the partition

returns a null on successful publication.

```q
q)producer:.kfk.Producer[kfk_cfg]
q)test_topic:.kfk.Topic[producer;`test;()!()]
/ partition set as -1i denotes an unassigned partition
q).kfk.Pub[test_topic;-1i;string .z.p;""]
q).kfk.Pub[test_topic;-1i;string .z.p;"test_key"]
```


### `.kfk.Sub`

_Subscribe from a consumer process to a topic_

Syntax: `.kfk.Sub[x;y;z]`

Where

-   `x` is the integer value of the consumer
-   `y` is a symbol denoting the topic being subscribed to
-   `z` is an enlisted integer denoting the target partition

returns a null on successful execution.

!!! note "Subscribing in advance"

    Subscriptions can be made to topics that do not currently exist.

!!! note "Multiple subscriptions"

    As of v1.4.0 multiple calls to `.kfk.Sub` for a given client will allow for consumption from multiple topics rather than overwriting the subscribed topic.

```q
q)client:.kfk.Consumer[kfk_cfg]
q).kfk.PARTITION_UA // subscription defined to be to an unassigned partition
-1i
// List of topics to be subscribed to
q)topic_list:`test`test1`test2
q).kfk.Sub[client;;enlist .kfk.PARTITION_UA]each topic_list
```


### `.kfk.Subscription`

_Most-recent subscription to a topic_

Syntax: `.kfk.Subscription[x]`

Where

-   `x` is the integer value of the client ID which the subscription is being requested for

returns a table with the topic, partition, offset and metadata of the most recent subscription.

```q
q)client:.kfk.Consumer[kfk_cfg];
q).kfk.Sub[client;`test2;enlist -1i]
q).kfk.Subscription[client]
topic partition offset metadata
-------------------------------
test2 -1        -1001  ""
```


### `.kfk.Unsub`

_Unsubscribe from all topics associated with Client_

Syntax: `.kfk.Unsub[x]`

Where

-   `x` is the integer representating the client ID from which you intend to unsubscribe from all topics

returns a null on successful execution; signals an error if client is unknown.

```q
q).kfk.Unsub[0i]
q).kfk.Unsub[1i]
'unknown client
```


## System information

### `.kfk.Metadata`

_Information about configuration of brokers and topics_

Syntax: `.kfk.Metadata[x]`

Where

-   `x` is the integer associated with the consumer or producer of interest

returns a dictionary with information about the brokers and topics.

```q
q)show producer_meta:.kfk.Metadata[producer]
orig_broker_id  | 0i
orig_broker_name| `localhost:9092/0
brokers         | ,`id`host`port!(0i;`localhost;9092i)
topics          | (`topic`err`partitions!(`test3;`Success;,`id`err`leader`rep..
q)producer_meta`topics
topic              err     partitions                                        ..
-----------------------------------------------------------------------------..
test               Success ,`id`err`leader`replicas`isrs!(0i;`Success;0i;,0i;..
__consumer_offsets Success (`id`err`leader`replicas`isrs!(0i;`Success;0i;,0i;..
```


### `.kfk.OutQLen`

_Current number of messages that are queued for publishing_

Syntax: `.kfk.OutQLen[x]`

Where

-   `x` is the integer value of the producer which we wish to check the number of queued messages

returns as an int the number of messages in the queue.

```q
q).kfk.OutQLen[producer]
5i
```


### `.kfk.Poll`

_Manually poll the messages from the message feed_

Syntax: `.kfk.Poll[x;y;z]`

Where

-   `x` is an integer representing the client ID
-   `y` is a long denoting the max time in ms to block the process
-   `z` is a long denoting the max number of messages to be polled

returns the number of messages polled within the allotted time.

```q
q).kfk.Poll[0i;5;100]
0
q).kfk.Poll[0i;100;100]
10
```


### `.kfk.ThreadCount`

_The number of threads that are being used by librdkafka_

Syntax: `.kfk.ThreadCount[]`

returns the number of threads currently in use by `librdkafka`.

```q
q).kfk.ThreadCount[]
5i
```


### `.kfk.Version`

_Integer value of the librdkafka version_

Syntax: `.kfk.Version`

Returns the integer value of the `librdkafka` version being used within the interface.

```q
q).kfk.Version
16777471i
```


### `.kfk.VersionSym`

_Symbol representation of librdkafka version_

Syntax: `.kfk.VersionSym[]`

Returns a symbol denoting the version of `librdkafka` that is being used within the interface.

```q
q).kfk.VersionSym[]
`1.1.0
```


## Topics

### `.kfk.Topic`

_Create a topic on which messages can be sent_

Syntax: `.kfk.Topic[x;y;z]`

Where

-   `x` is an integer denoting the consumer/producer on which the topic is produced
-   `y` is the desired topic name
-   `z` is a user-defined topic configuration default `()!()`

returns an integer denoting the value given to the assigned topic.

```q
q)consumer:.kfk.Consumer[kfk_cfg]
q).kfk.Topic[consumer;`test;()!()]
0i
q).kfk.Topic[consumerl`test1;()!()]
1i
```


### `.kfk.TopicDel`

_Delete a currently defined topic_

Syntax: `.kfk.TopicDel[x]`

Where

-   `x` is the integer value assigned to the topic to be deleted

returns a null if a topic is deleted sucessfully.

```q
q).kfk.Topic[0i;`test;()!()]
0i
q).kfk.TopicDel[0i]
/ topic now no longer available for deletion
q).kfk.TopicDel[0i]
'unknown topic
```


### `.kfk.TopicName`

_Returns the name of a topic_

Syntax: `.kfk.TopicName[x]`

Where

-   `x` is the integer value associated with the topic name requested

returns as a symbol the name of the requested topic.

```q
q).kfk.Topic[0i;`test;()!()]
0i
q).kfk.Topic[0i;`test1;()!()]
1i
q).kfk.TopicName[0i]
`test
q).kfk.TopicName[1i]
`test1
```
