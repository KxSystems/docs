---
title: Interface example | MQTT | Interfaces | Documentation for kdb+ and q
keywords: mqtt, api, consumer, fusion, interface, broker, message, library, telemetry, producer, q
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
---
# MQTT interface example

:fontawesome-brands-github:
[KxSystems/mqtt](https://github.com/KxSystems/mqtt)



This example requires 

-   the MQTT interface [installed](https://github.com/kxsystems/mqtt/blob/master/README.md)
-   a Mosquitto broker [available on port 1883](https://mosquitto.org/download/)


The example below outlines a minimal use case which publishes data on multiple topics from kdb+ to a Mosquitto broker and subscribes to these topics from a separate kdb+ process. The steps are

## Open a Mosquitto broker 

Open a Mosquitto broker on the default localhost `tcp://localhost:1883`.


## Start two kdb+ processes

From the examples folder, start two q processes.


## Load the test producer 

Load the test producer script on one of the processes to publish messages to topics `topic1` and `topic2`.

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


## Load the test receiver

On the other process load the test receiver script, which updates messages from topics `topic1` and `topic2`

```q
q)\l receiver.q
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

