---
keywords: mqtt, api, consumer, fusion, interface, broker, message, library, telemetry, producer, q
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
---

# <i class="fa fa-share-alt"></i> MQTT Interface Example

<i class="fab fa-github"></i> [KxSystems/mqtt](https://github.com/KxSystems/mqtt)

## Requirements

This example requires the following steps to be completed

1. The MQTT interace is installed following the steps outlined in the interfaces' `README.md` [here](https://github.com/kxsystems/mqtt/blob/master/README.md).
2. A mosquitto broker is available on port `1883`. A local MQTT instance can be installed by following the instructions outlined [here](https://mosquitto.org/download/).


## Example

The example below outlines a minimal use case which publishes data on multiple topics from kdb+ to a mosquitto broker and subscribes to these topics from a separate kdb+ process. This is achieved following the steps outlined below

* Open a mosquitto broker on the default localhost `tcp://localhost:1883`.
* From the examples folder, start two q processes.
* Load the test producer script on one of the processes to publish messages to topics `topic1` and `topic2`

```q
q)\l producer.q
// Type `\t 100` to publish a message every 100ms 
// for up to 200 messages. To stop at any time type `q)\t 0`
q)\t 100
(`msgsent;1)
(`msgsent;2)
(`msgsent;3)
(`msgsent;4)
q)\t 0
```

* On the other process load the test receiver script which updates messages from topics `topic1` and `topic2`

```q
q)\l consumer.q
"Message received"
"Message received"
"Message received"
"Message received"

// Display messages being added to .mqtt.tab
q).mqtt.tab
topic  msg_sent                      msg_recv                      recieved_m..
-----------------------------------------------------------------------------..
topic1 2019.07.29D10:47:19.185993000 2019.07.29D10:47:19.186598000 topic1_0  ..
topic2 2019.07.29D10:47:19.186129000 2019.07.29D10:47:19.286879000 topic2_0  ..
topic1 2019.07.29D10:47:20.187006000 2019.07.29D10:47:20.187568000 topic1_1  ..
topic2 2019.07.29D10:47:20.187124000 2019.07.29D10:47:20.287820000 topic2_1  ..
```

