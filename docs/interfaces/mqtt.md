---
keywords: mqtt, api, consumer, fusion, interface, broker, message, library, telemetry, producer, q
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
---

# ![mqtt](img/MQTT_Icon.png) Using MQTT with kdb+

<i class="fab fa-github"></i> [KxSystems/mqtt](https://github.com/KxSystems/mqtt)

## Overview

`mqtt` is a thin wrapper for kdb+ around the
<i class="fab fa-github"></i>
[eclipse/paho.mqtt.c](https://github.com/eclipse/paho.mqtt.c)
C API for the Message Queuing Telemetry Transport [(MQTT)](http://mqtt.org/) ISO pub/sub messaging protocol.

Follow the installation instructions for set-up [here](https://github.com/KxSystems/mqtt#build-instructions).

In order to run the examples provided with this interface you will need a MQTT broker installed and running locally. A Mosquitto broker can be setup and installed following the instructions provided [here](https://mosquitto.org/download/).

## User guide

This interface exposes a number of functions allowing a kdb+ process to interact with a MQTT broker, these functions allow connection, publishing, subscription and unsubscription to topics and are defined as follows:

### `.mqtt.conn`

_Connect to a mosquitto host_

Syntax: `.mqtt.conn[host;nm]`

Where

-   `host` is the IP address or hostname of the MQTT broker beign connected to as a symbol.
-   `name` is a symbol denoting the name to be given to the connecting process

returns a failure notice if connnection to host could not be established otherwise does not return output.

```q
// In this example Mosquitto is not started on the defined host
q)hst:`$"tcp://localhost:1883"
q).mqtt.conn[hst;`src]
'Failure

// Attempt to connect to a host using an invalid protocol
q).mqtt.conn[`$"https://localhost:1883";`src]
'Invalid protocol scheme

// Mosquitto now started on appropriate host
q).mqtt.conn[hst;`src]
q)
```

### `.mqtt.pub`

_Publish a message to a mosquitto broker_

Syntax: `.mqtt.pub[topic;msg]`

Where

-   `topic` is a symbol denoting the topic that the message is to be sent to
-   `msg` is a string of the message being sent to the broker

returns a callback to the process stating that the message has been sent to the broker (this can be overwritten by a user).

```q
// Connect to the host broker
q).mqtt.conn[`$"tcp://localhost:1883";`src]

// Publish a message to a topic names `topic1
q).mqtt.pub[`topic1;"This is a test message"];
(`msgsent;1)
```

### `.mqtt.sub`

_Subscribe to a topic on a mosquitto broker process_

Syntax: `.mqtt.sub[topic]`

Where

-   `topic` is a symbol denoting the topic that the process should listen to 

returns a callback to the process when a message is received on topic stating that the message was received and what that message is.

```q
// Connect to the host broker and publish a message
q).mqtt.conn[`$"tcp://localhost:1883";`rcv]

// Subscribe to topic1 and recieve a message sent to that topic
q).mqtt.sub[`topic1]
(`msgrcvd;"topic1";"This is a test message")
```

!!!note
	The callbacks implemented within this API are minimal implementations and can be overwritten by the user to tailor to the messages being received or sent through the broker.

### `.mqtt.unsub`

_Unsubscribe from a mosquitto broker topic_

Syntax: `.mqtt.unsub[topic]`

Where

-  `topic` is a symbol denoting the topic to be unsubscribed from

Does not return a message on correct application, errors on incorrect input

```q
// Connect to the host broker with the name `rcv
q).mqtt.conn[`$"tcp://localhost:1883";`rcv]
// Subscribe to `topic1
q).mqtt.sub[`topic1]

// publish a message to `topic1 on the broker
(`msgrcvd;"This is a test message")

// Unsubscribe from the topic 
q).mqtt.unsub[`topic1]
// publish another message to `topic1 (note, no message received)
```


## Example

* Open a mosquitto broker on the default localhost `tcp://localhost:1883`.
* Start two q processes to run the producer and receivers separately through the mosquitto broker process.
* Load the test producer script to publish messages to topics `topic1` and `topic2`

```q
q)\l producer.q
// Type `\t 100` to publish a message every 100ms 
// for up to 200 messages. To stop and any time type `q)\t 0`
q)\t 100
(`msgsent;1)
(`msgsent;2)
(`msgsent;3)
(`msgsent;4)
q)\t 0
```

* Load the test receiver script which updates messages from topics `topic1` and `topic2`

```q
q)\l receiver.q
"Message received"
"Message received"
"Message received"
"Message received"
q).mqtt.tab
topic  msg_sent                      msg_recv                      recieved_m..
-----------------------------------------------------------------------------..
topic1 2019.07.29D10:47:19.185993000 2019.07.29D10:47:19.186598000 topic1_0  ..
topic2 2019.07.29D10:47:19.186129000 2019.07.29D10:47:19.286879000 topic2_0  ..
topic1 2019.07.29D10:47:20.187006000 2019.07.29D10:47:20.187568000 topic1_1  ..
topic2 2019.07.29D10:47:20.187124000 2019.07.29D10:47:20.287820000 topic2_1  ..
```

