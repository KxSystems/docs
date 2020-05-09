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

!!!Note
        The callbacks implemented within this API to handle disconnections and the sending/receipt of messages are minimal implementations and can be overwritten by the user to tailor to the messages being sent to or received from the broker. An outline of how these can be modified is outlined below.

### `.mqtt.conn`

_Connect to a mosquitto host_

Syntax: `.mqtt.conn[host;nm;opts]`

Where

-   `host` is the IP address or hostname of the MQTT broker being connected to as a symbol.
-   `name` is a symbol denoting the name to be given to the connecting process
-   `opts` dictionary of connection options to the MQTT broker, for default options use `()!()`

returns a failure notice if connnection to host could not be established otherwise does not return output.

!!!Note
	At present the `opts` parameter can allow a user to specify a username and password for brokers that require this flexibility. Further options will be added

```q
// In this example Mosquitto is not started on the defined host
q)hst:`$"tcp://localhost:1883"
q).mqtt.conn[hst;`src;()!()]
'Failure

// Attempt to connect to a host using an invalid protocol with default options
q).mqtt.conn[`$"https://localhost:1883";`src;()!()]
'Invalid protocol scheme

// Mosquitto now started on appropriate host with default options
q).mqtt.conn[hst;`src;()!()]

// Connect to Mosquitto broker providing username and password
q).mqtt.conn[hst;`src;`username`password!`myuser`mypass]
```

### `.mqtt.pub`

_Publish a message to a mosquitto broker_

Syntax: `.mqtt.pub[topic;msg]`

Where

-   `topic` is a symbol denoting the topic that the message is to be sent to
-   `msg` is a string of the message being sent to the broker

returns a callback to the process stating that the message has been sent to the broker.

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

## Callback functions

As outlined above a number of functions control the handling of messages and signals via callback.

```txt
MQTT interface callback functionality
  .mqtt.disconn           Triggered on disconnection from MQTT broker
  .mqtt.msgrcvd           Triggered when a message is received from a broker
  .mqtt.msgsent           Triggered when a q process successfully sends a message to broker
```

These functions should be modified to control how messages and disconnections are handled by the q process in a that is suitable for the use case and messages being transfered via MQTT.

### `.mqtt.disconn`

_Handle disconnections from an MQTT broker_

Syntax: `.mqtt.disconn[x]`

Where

-   `x` is a null value

returns the output of user defined logic for handling disconnections

```q
// Default occurrence of a disconnection
(`disconn;())

// Modify the disconnection callback function
q).mqtt.disconn:{0N!"Disconnection from broker at: ",string[.z.p];}

// Disconnect with the new disconnection logic
"Disconnection from broker at: 2020.05.07D08:28:47.836698000"

```

### `.mqtt.msgrcvd`

_Handle messages received from an MQTT broker_

Syntax: `.mqtt.msgrcvd[topic;msg]`

Where

-  `topic` is a string denoting the topic from which the message was received

-  `msg` is the content of the message received from the MQTT broker

```q
// Default occurrence of a message being received
(`msgrecvd;"topic1";"Test message")

// Modify the receiving callback function
q).mqtt.msgrcvd:{0N!"Message - '",string[y],"' received from, ",string[x];}

// The same message received with the new logic
"Message - 'Test message' received from, topic1"
```

### `.mqtt.msgsent`

_Handle callback on successful sending a message to an MQTT broker_

Syntax: `.mqtt.msgsent[token]`

Where

-  `token` is a long representing the MqttDeliveryToken to monitor delivery

```q
// Default occurrence of a message being sent
q).mqtt.pub[`tcp://localhost:1883;"Test message"];
(`msgsent;1)

// Modify the sending callback function
q).mqtt.msgsent:{0N!"Message was sent with delivery token - ,string[x];}

// The same message sent with the new logic
"Message was sent with delivery token - 1" 
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

