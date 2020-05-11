---
title: User Guide | MQTT | Interfaces | Documentation for kdb+ and q
keywords: mqtt, api, consumer, fusion, interface, broker, message, library, telemetry, producer, q
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
---
# :fontawesome-solid-share-alt: Function reference

:fontawesome-brands-github: 
[KxSystems/mqtt](https://github.com/KxSystems/mqtt)


The following functions are exposed in the `.mqtt` namespace allowing you to interact with MQTT brokers and manage receipt and sending of messages.

<pre markdown="1" class="language-txt">
.mqtt   **MQTT interface**

Broker interaction
  [conn](#mqttconn)      connect to a MQTT broker
  [pub](#mqttpub)       publish a message to topic
  [sub](#mqttsub)       subscribe to a topic
  [unsub](#mqttunsub)     unsubscribe from a topic

Callback functions
  [disconn](#mqttdisconn)   manage disconnection events
  [msgrecv](#mqttmsgrecv)   manage receipt of messages
  [msgsent](#mqttmsgsent)   manage sending of messages
</pre>

The callbacks implemented within this API to handle disconnections and the sending/receipt of messages are minimal implementations. 

They can be adapted by the user to the messages being sent to or received from their broker.


## `.mqtt.conn`

_Connect to a Mosquitto host_

Syntax: `.mqtt.conn[host;name;opts]`

Where

-   `host` is the IP address or hostname of the MQTT broker being connected to as a symbol.
-   `name` is a symbol denoting the name to be given to the connecting process
-   `opts` dictionary of connection options to the MQTT broker, for default options use `()!()`

returns a failure notice if connnection to host could not be established otherwise does not return output.

!!! detail "`opts`"
	At present the `opts` parameter can allow a user to specify a username and password for brokers that require this flexibility. Further options will be added.

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


## `.mqtt.disconn`

_Handle disconnections from an MQTT broker_

Syntax: `.mqtt.disconn[]`

Returns the output of user-defined logic for handling disconnections.

```q
// Default occurrence of a disconnection
(`disconn;())

// Modify the disconnection callback function
q).mqtt.disconn:{0N!"Disconnection from broker at: ",string[.z.p];}

// Disconnect with the new disconnection logic
"Disconnection from broker at: 2020.05.07D08:28:47.836698000"
```


## `.mqtt.msgrcvd`

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


## `.mqtt.msgsent`

_Handle callback on successful sending a message to an MQTT broker_

Syntax: `.mqtt.msgsent[token]`

Where `token` is a long representing the MqttDeliveryToken to monitor delivery

```q
// Default occurrence of a message being sent
q).mqtt.pub[`tcp://localhost:1883;"Test message"];
(`msgsent;1)

// Modify the sending callback function
q).mqtt.msgsent:{0N!"Message was sent with delivery token - ,string[x];}

// The same message sent with the new logic
"Message was sent with delivery token - 1" 
```


## `.mqtt.pub`

_Publish a message to a Mosquitto broker_

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


## `.mqtt.sub`

_Subscribe to a topic on a Mosquitto broker process_

Syntax: `.mqtt.sub[topic]`

Where `topic` is a symbol denoting the topic that the process should listen to, returns a callback to the process when a message is received on topic stating that the message was received and what that message is.

```q
// Connect to the host broker and publish a message
q).mqtt.conn[`$"tcp://localhost:1883";`rcv]

// Subscribe to topic1 and recieve a message sent to that topic
q).mqtt.sub[`topic1]
(`msgrcvd;"topic1";"This is a test message")
```


## `.mqtt.unsub`

_Unsubscribe from a Mosquitto broker topic_

Syntax: `.mqtt.unsub[topic]`

Where `topic` is a symbol denoting the topic to be unsubscribed from, does not return a message on correct application, but signals an error on incorrect input.

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




