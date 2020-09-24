---
title: Guide for using Kafka with kdb+
author: Conor McCarthy
description: Lists functions available for use within the Kafka API for kdb+ and gives limitations as well as examples of each being used 
date: September 2019
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+ / PyQ
keywords: broker, consumer, kafka, producer, publish, subscribe, subscription, topic
---
# <i class="fa fa-share-alt"></i> Function reference 


As outlined in the overview for this API, the kdb+/Kafka interface is a thin wrapper for kdb+ around the [`librdkafka`](https://github.com/edenhill/librdkafka) C API for [Apache Kafka](https://kafka.apache.org/). 

:fontawesome-brands-github:
[KxSystems/kafka](https://github.com/KxSystems/kafka)

The following functions are those exposed within the `.kfk` namespace allowing users to interact with Kafka from a kdb+ instance.

<pre markdown="1" class="language-txt">
Kafka interface functionality
  // client functionality 
  [.kfk.ClientDel](#kfkclientdel)               Close consumer and destroy Kafka handle to client
  [.kfk.ClientName](#kfkclientname)              Kafka handle name
  [.kfk.ClientMemberId](#kfkclientmemberid)          Client's broker assigned member ID
  [.kfk.Consumer](#kfkconsumer)                Create a consumer according to defined configuration
  [.kfk.Producer](#kfkproducer)                Create a producer according to defined configuration
  [.kfk.SetLoggerLevel](#kfksetloggerlevel)          Set the maximum logging level for a client

  // offset based functionality
  [.kfk.CommitOffsets](#kfkcommitoffsets)           Commit offsets on broker for provided partition list
  [.kfk.PositionOffsets](#kfkpositionoffsets)         Current offsets for topics and partitions
  [.kfk.CommittedOffsets](#kfkcommittedoffsets)        Retrieve committed offsets for topics and partitions
  [.kfk.AssignOffsets](#kfkassignoffsets)           Assignment of partitions to consume

  // publising functionality
  [.kfk.BatchPub](#kfkbatchpub)                Publish a batch of data to a defined topic
  [.kfk.Pub](#kfkpub)                     Publish a message to a defined topic
  [.kfk.PubWithHeaders](#kfkpubwithheaders)          Publish a message to a defined topic with a header 
  [.kfk.OutQLen](#kfkoutqlen)                 Current out queue length

  // subscription functionality
  [.kfk.Sub](#kfksub)                     Subscribe to a defined topic
  [.kfk.Subscribe](#kfksubscribe)               Subscribe from a consumer to a topic with a specified callback
  [.kfk.Subscription](#kfksubscription)            Most recent topic subscription
  [.kfk.Unsub](#kfkunsub)                   Unsubscribe from a topic
  [.kfk.MaxMsgsPerPoll](#kfkmaxmsgsperpoll)          Set the maximum number of messages per poll
  [.kfk.Poll](#kfkpoll)                    Manually poll the feed

  // assignment functionality
  [.kfk.Assign](#kfkassign)                  Create a new assignment from which data will be consumed
  [.kfk.AssignAdd](#kfkassignadd)               Add new assignments to the current assignment
  [.kfk.AssignDel](#kfkassigndel)               Remove topic partition assignments from the current assignments
  [.kfk.Assignment](#kfkassignment)              Return the current assignment 

  // Assignment functionality
  .kfk.Assign                  Create a new assignment from which data will be consumed
  .kfk.AssignAdd               Add new assignments to the current assignment
  .kfk.AssignDel               Remove topic partition assignments from the current assignments
  .kfk.Assignment              Return the current assignment 

  // system infomation
  [.kfk.Metadata](#kfkmetadata)                Broker Metadata
  [.kfk.Version](#kfkversion)                 Librdkafka version
  [.kfk.VersionSym](#kfkversionsym)              Human readable Librdkafka version
  [.kfk.ThreadCount](#kfkthreadcount)             Number of threads being used by librdkafka

  // topic functionality
  [.kfk.Topic](#kfktopic)                   Create a topic on which messages can be sent
  [.kfk.TopicDel](#kfktopicdel)                Delete a defined topic
  [.kfk.TopicName](#kfktopicname)               Topic Name

  // callback modifications
  [.kfk.errcbreg](#kfkerrcbreg)                Register an error callback associated with a specific client
  [.kfk.throttlecbreg](#kfkthrottlecbreg)           Register a throttle callback associated with a specific client
</pre>


For simplicity in each of the examples below it should be assumed that the user’s system is configured correctly, unless otherwise specified. For example:

1. If subscribing to a topic, this topic exists.
2. If an output is presented, the output reflects the system used in the creation of these examples.


## Clients

The following functions relate to the creation of consumers and producers and their manipulation/interrogation.


### `.kfk.ClientDel`

_Close a consumer and destroy the associated Kafka handle to client_

Syntax: `.kfk.ClientDel[clid]`

Where

-   `clid` is an integer denoting the client to be deleted

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

Syntax: `.kfk.ClientMemberId[clid]`

Where

-   `clid` is an integer denoting the requested client name

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

Syntax: `.kfk.ClientName[clid]`

Where

-   `clid` is an integer denoting the requested client name

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

Syntax: `.kfk.Consumer[cfg]`

Where

-   `cfg` is a dictionary user-defined configuration

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

Syntax: `.kfk.Producer[cfg]`

Where

-   `cfg` is a user-defined dictionary configuration

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

Syntax: `.kfk.SetLoggerLevel[clid;level]`

Where

-   `clid` is an integer denoting the client ID
-   `level` is an int/long/short denoting the syslog severity level

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

Syntax: `.kfk.CommitOffsets[clid;topic;part_offsets;block_commit]`

Where

-   `clid` is the integer value associated with the consumer client ID
-   `topic` is a symbol denoting the topic
-   `part_offsets` is a dictionary of partitions(ints) and last received offsets (longs)
-   `block_commit` is a boolean denoting if commit will block until offset commit is complete or not, 0b = non blocking

returns a null on successful commit of offsets.


### `.kfk.PositionOffsets`

_Current offsets for particular topics and partitions_

Syntax: `.kfk.PositionOffsets[clid;topic;part_offsets]`

Where

-   `clid` is the integer value associated with the consumer ID
-   `topic` is a symbol denoting the topic
-   `part_offsets` is a list of int/short or long partitions or a dictionary of partitions(int) and offsets(long)

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

Syntax: `.kfk.CommittedOffsets[clid;topic;part_offsets]`

Where

-   `clid` is the integer value associated with the consumer ID
-   `topic` is a symbol denoting the topic
-   `part_offsets` is a list of int/short or long partitions or a dictionary of partitions(int) and offsets(long)

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

Syntax: `.kfk.AssignOffsets[clid;topic;part_offsets]`

Where

-   `clid` is the integer value associated with the consumer ID.
-   `topic` is a symbol denoting the topic.
-   `part_offsets` is a dictionary with key denoting the partition and value denoting where to start consuming the partition.

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


## Publishing functionality

### `.kfk.BatchPub`

_Publish a batch of messages to a defined topic_

Syntax: `.kfk.BatchPub[tpcid;partid;data;keys]`

Where

-   `tpcid` is an integer denoting the topic (previously created) to be published on
-   `partid` is an integer or list of partitions denoting the target partition
-   `data` is a mixed list payload containing either bytes or strings
-   `keys` is an empty string for auto key on all messages or a key per message as a mixed list of bytes or strings

returns an integer list denoting the status for each message (zero indicating success)

```q
q)batchMsg :("test message 1";"test message 2")
q)batchKeys:("Key 1";"Key 2")

// Send two messages to any partition using default key
q).kfk.BatchPub[;.kfk.PARTITION_UA;batchMsg;""]each(topic1;topic2)
0 0
0 0

// Send 2 messages to partition 0 for each topic using default key
q).kfk.BatchPub[;0i;batchMsg;""]each(topic1;topic2)
0 0
0 0

// Send 2 messages the first to separate partitions using generated keys
q).kfk.BatchPub[;0 1i;batchMsg;batchKeys]each(topic1;topic2)
0 0
0 0
```

### `.kfk.Pub`

_Publish a message to a defined topic_

Syntax: `.kfk.Pub[tpcid;partid;data;keys]`

Where

-   `tpcid` is the integer of the topic to be published on
-   `partid` is an integer denoting the target partition
-   `data` is a string which incorporates the payload to be published
-   `keys` is a string to be passed with the message to the partition denoting the message key


returns a null on successful publication.

```q
q)producer:.kfk.Producer[kfk_cfg]
q)test_topic:.kfk.Topic[producer;`test;()!()]
/ partition set as -1i denotes an unassigned partition
q).kfk.Pub[test_topic;-1i;string .z.p;""]
q).kfk.Pub[test_topic;-1i;string .z.p;"test_key"]
```

### `.kfk.PubWithHeaders`

_Publish a message to a defined topic, with an associated header_

Syntax: `.kfk.PubWithHeader[clid;tpcid;partid;data;keys;hdrs]`

Where

-   `clid` is an integer denoting a target client ID
-   `tpcid` is the integer of the topic to be published on
-   `partid` is an integer denoting the target partition
-   `data` is a string which incorporates the payload to be published
-   `keys` is a string to be passed with the message to the partition denoting the message key
-   `hdrs` is a dictionary mapping a header name as a symbol to a byte array or string

returns a null on successful publication, errors if version conditions not met

```q
// Create an appropriate producer
q)producer:.kfk.Producer[kfk_cfg]

// Create a topic
q)test_topic:.kfk.Topic[producer;`test;()!()]

// Define the target partition as unassigned
part:-1i

// Define an appropriate payload
payload:string .z.p

// Define the headers to be added
hdrs:`header1`header2!("test1";"test2")

// Publish a message to client #0 with a header but no key
q).kfk.PubWithHeaders[0i;test_topic;part;payload;"";hdrs]

// Publish a message to client #1 with headers and a key
q).kfk.PubWithHeaders[1i;test_topic;part;payload;"test_key";hdrs]
```

!!!Note "Support for functionality"
	
	This functionality is only available for versions of librdkafka >= 0.11.4, use of a version less than this does not allow this 

### `.kfk.OutQLen`

_Current number of messages that are queued for publishing_

Syntax: `.kfk.OutQLen[prid]`

Where

-   `prid` is the integer value of the producer which we wish to check the number of queued messages

returns as an int the number of messages in the queue.

```q
q).kfk.OutQLen[producer]
5i
```

## Subscription functionality

### `.kfk.Sub`

_Subscribe from a consumer process to a topic_

Syntax: `.kfk.Sub[clid;topic;partid]`

Where

-   `clid` is an integer value denoting the client id
-   `topic` is a symbol denoting the topic being subscribed to
-   `partid` is an enlisted integer denoting the target partition

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

### `.kfk.Subscribe`

_Subscribe from a consumer to a topic with a specified callback_

Syntax: `.kfk.Subscribe[clid;topic;partid;callback]`

Where

-   `clid` is an integer value denoting the client id
-   `topic` is a symbol denoting the topic being subscribed to
-   `partid` is an enlisted integer denoting the target partition
-   `callback` is a callback function defined related to the subscribed topic. This function should take as input a single parameter
    - `msg` the content of a message received from any calls to the subscription on the topic.

returns a null on successful execution and augments `.kfk.consumetopic` with a new callback function for the consumer.

```q
// create a client with a user created config kfk_cfg
q)client:.kfk.Consumer[kfk_cfg]
// Subscription consumes from any available partition
q)part:.kfk.PARTITION_UA 
// List of topics to be subscribed to
q)topicname:`test
// Display consumer callbacks prior to new subscription
q).kfk.consumetopic
     | {[msg]}
q).kfk.Subscribe[client;topicname;enlist part;{[msg]show msg;}]
// Display consumer callbacks following invocation of Subscribe
q).kfk.consumetopic
    | {[msg]}
test| {[msg]show msg;}
```

!!! Note "Consume Callbacks"
	
	The addition of callbacks specific to a topic was added in `v1.5.0` a call of `.kfk.Subscribe` augments the dictionary `.kfk.consumetopic` where the key maps topic name to the callback function in question. A check for a custom callback is made on each call to `.kfk.consumecb` following `v1.5.0`. If an appropriate key is found the associated callback will be invoked. The default callback can be modified via modification of ```.kfk.consumetopic[`]```

### `.kfk.Subscription`

_Most-recent subscription to a topic_

Syntax: `.kfk.Subscription[clid]`

Where

-   `clid` is the integer value of the client ID which the subscription is being requested for

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

Syntax: `.kfk.Unsub[clid]`

Where

-   `clid` is the integer representating the client ID from which you intend to unsubscribe from all topics

returns a null on successful execution; signals an error if client is unknown.

```q
q).kfk.Unsub[0i]
q).kfk.Unsub[1i]
'unknown client
```

### `.kfk.MaxMsgsPerPoll`

_Set the maximum number of messages per poll_

Syntax: `.kfk.MaxMsgsPerPoll[max_messages]

Where

-   `max_messages` is an integer denoting a maximum number od messages per poll

returns the set limit.

```q
q).kfk.MaxMsgsPerPoll[100]
100
```

!!! note "Upper limit set by `.kfk.MaxMsgsPerPoll` vs max_messages in `.kfk.Poll`"

    The argument `max_messages` passed to `.kfk.Poll` is preferred to the global limit of maximum number of messages set by `.kfk.MaxMsgPerPoll`. The latter limit is used only when `max_messages` passed to `.kfk.Poll` is 0.


### `.kfk.Poll`

_Manually poll the messages from the message feed_

Syntax: `.kfk.Poll[cid;timeout;max_messages]`

Where

-   `cid` is an integer representing the client ID
-   `timeout` is a long denoting the max time in ms to block the process
-   `max_messages` is a long denoting the max number of messages to be polled

returns the number of messages polled within the allotted time.

```q
q).kfk.Poll[0i;5;100]
0
q).kfk.Poll[0i;100;100]
10
```

## Assignment functionality

### `.kfk.Assign`

_Create a new assignment from which data is to be consumed_

Syntax: `.kfk.Assign[clid;tpc_part]`

Where

-   `clid` is an integer denoting the client id which the assignment is to applied
-   `tpc_part` is a dictionary mapping topic name as a symbol to partition as a long which is to be assigned


returns a null on successful execution

```q
q).kfk.Assign[cid;`test`test1!0 1]
```

### `.kfk.AssignAdd`

_Add additional topic paritions pairs to the current assignment_

Syntax: `.kfk.Assign[clid;tpc_part]`

Where

-   `clid` is an integer denoting the client id which the assignment is to applied
-   `tpc_part` is a dictionary mapping topic name as a symbol to partition as a long which is to be added to the current assignment

returns a null on successful execution, will display inappropriate assignments if necessary

```q
// Create a new assignment
q).kfk.Assign[cid;`test`test1!0 0]

// Retrieve the current assignment
q).kfk.Assignment[cid]
topic partition offset metadata
-------------------------------
test1 0         -1001  ""      
test2 0         -1001  ""      

// Add new assignments to the current assignment
q).kfk.AssignAdd[cid;`test`test1!1 1]

// Retrieve the current assignment
q).kfk.Assignment[cid]
topic partition offset metadata
-------------------------------
test  1         -1001  ""      
test1 0         -1001  ""      
test1 1         -1001  ""      
test2 0         -1001  ""      

// Attempt to assign an already assigned topic partition pair
q).kfk.AssignAdd[cid;`test`test1!1 1]
`test  1
`test1 1
'The above topic-partition pairs already exist, please modify dictionary
```

### `.kfk.AssignDel`

_Delete a set of topic parition pairs to the current assignment_

Syntax: `.kfk.AssignDel[clid;tpc_part]`

Where

-   `clid` is an integer denoting the client id which the assignment is to applied
-   `tpc_part` is a dictionary mapping topic name as a symbol to partition as a long to be removed

returns a null on successful execution, will display inappropriate assignment deletion if necessary

```q
// Create a new assignment
q).kfk.Assign[cid;`test`test`test1`test1!0 1 0 1]

// Retrieve the current assignment
q).kfk.Assignment[cid]
topic partition offset metadata
-------------------------------
test  0         -1001  ""
test  1         -1001  ""
test1 0         -1001  ""
test1 1         -1001  ""

// Add new assignments to the current assignment
q).kfk.AssignDel[cid;`test`test1!1 1]

// Retrieve the current assignment
q).kfk.Assignment[cid]
topic partition offset metadata
-------------------------------
test  0         -1001  ""
test1 0         -1001  ""

// Attempt to assign an already unassigned topic partition pair
q).kfk.AssignDel[cid;`test`test1!1 1]
`test  1
`test1 1
'The above topic-partition pairs cannot be deleted as they are not assigned
```

### `.kfk.Assignment`

_Retrieve the current assignment for a specified client_

Syntax: `.kfk.Assignment[clid]`

Where

-   `clid` is an integer denoting the client id from which the assignment is to be retrieved

returns a list of dictionaries describing the current assignment for the specified client

```q
// Attempt to retrieve assignment without a current assignment
q).kfk.Assignment[cid]
topic partition offset metadata
-------------------------------

// Create a new assignment
q).kfk.Assign[cid;`test`test1!0 1]

// Retrieve the new current assignment
q).kfk.Assignment[cid]
topic partition offset metadata
-------------------------------
test  0         -1001  ""
test1 1         -1001  ""
```

## System information

### `.kfk.Metadata`

_Information about configuration of brokers and topics_

Syntax: `.kfk.Metadata[id]`

Where

-   `id` is the integer associated with the consumer or producer of interest

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

Syntax: `.kfk.Version[]`

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

Syntax: `.kfk.Topic[id;topic;cfg]`

Where

-   `id` is an integer denoting the consumer/producer on which the topic is produced
-   `topic` is the desired topic name to be assigned to the topic as a symbol
-   `cfg` is a dictionary denoting a user-defined topic configuration, to use default set this to `()!()`


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

Syntax: `.kfk.TopicDel[topic]`

Where

-   `topic` is the integer value assigned to the topic to be deleted

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

Syntax: `.kfk.TopicName[tpcid]`

Where

-   `tpcid` is the integer value associated with the topic name requested

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


## Callback Modifications

### `.kfk.errcbreg`

_Register an error callback associated with a specific client_

Syntax: `.kfk.errcbreg[clid;callback]`

Where

-   `clid` is the integer value associated with the client to which the callback is to be registered
-   `callback` function taking 3 arguments which will be triggered on errors associated with the client. The parameters of this function are:
    -   `cid`: integer denoting a client ID to which this callback is called
    -   `err_int`: integer denoting an error status code in Kafka
    -   `reason`: string denoting a reason for the error

returns a null on successful execution and augments the dictionary `.kfk.errclient` mapping client id to callback

```q
// Assignment prior to registration of new callback
// this is the default behaviour invoked
q).kfk.errclient
 |{[cid;err_int;reason]}
// Attempt to create a consumer which will fail
q).kfk.Consumer[`metadata.broker.list`group.id!`foobar`0]
0i

// Update the default behaviour to show the output
q).kfk.errclient[`]:{[cid;err_int;reason]show(cid;err_int;reason);}

// Attempt to create another failing consumer
q).kfk.Consumer[`metadata.broker.list`group.id!`foobar`0]
1i
q)1i
-193i
"foobar:9092/bootstrap: Failed to resolve 'foobar:9092': nodename nor servnam..
1i
-187i
"1/1 brokers are down"

// Start a new q session and register an error callback for cid 0
q).kfk.errcbreg[0i;{[cid;err_int;reason] show err_int;}]
// Attempt to create a consumer that will fail
q).kfk.Consumer[`metadata.broker.list`group.id!`foobar`0]
0i
q)-193i
-187i
```

### `.kfk.throttlecbreg`

_Register an throttle callback associated with a specific client_

Syntax: `.kfk.throttlecbreg[clid;callback]`

Where

-   `clid` is the integer value associated associated with the client to which the callback is to be regis
tered
-   `callback` function taking 4 arguments which will be triggered on throttling associated with the client. These parameters represent:
    -   `cid`: integer denoting a client ID to which this callback is called
    -   `bname`: string representing a broker name
    -   `bid`: integer denoting a broker ID
    -   `throttle_time`: integer denoting the accepted throttle time in milliseconds


returns a null on successful execution and augments the dictionary `.kfk.errclient` mapping client id t
o callback

```q
// Assignment prior to registration of new callback 
// this is the default behaviour invoked
q).kfk.throttleclient
 |{[cid;bname;bid;throttle_time]}

// Update the default behaviour to show the output
q).kfk.throttleclient[`]:{[cid;bname;bid;throttle_time]show(cid;bid);}

// Add a throttle client associated specifically with client 0
q).kfk.throttlecbreg[0i;{[cid;bname;bid;throttle_time]show(cid;throttle_time);}]

// Display the updated throttle callback logic
q).kfk.throttleclient
 |{[cid;bname;bid;throttle_time]show(cid;bid);}
0|{[cid;bname;bid;throttle_time]show(cid;throttle_time);}

```
