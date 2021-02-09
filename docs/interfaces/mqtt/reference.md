---
title: Function reference | MQTT | Interfaces | Documentation for kdb+ and q
keywords: mqtt, api, consumer, fusion, interface, broker, message, library, telemetry, producer, q
---
# MQTT function reference

:fontawesome-brands-github: 
[KxSystems/mqtt](https://github.com/KxSystems/mqtt)
<br>
:fontawesome-solid-globe:
[MQTT manual](https://mosquitto.org/man/mqtt-7.html)

The following functions are exposed in the `.mqtt` namespace.
They allow you to interact with MQTT brokers and send and receive messages.

<div markdown="1" class="typewriter">
.mqtt   **MQTT interface**

Broker interaction
  [conn](#mqttconn)      connect to a MQTT broker
  [pub](#mqttpub)       publish a message to a topic
  [pubx](#mqttpubx)      publish a message to a topic controlling qos and ret
  [sub](#mqttsub)       subscribe to a topic
  [unsub](#mqttunsub)     unsubscribe from a topic

Callback functions
  [disconn](#mqttdisconn)   manage disconnection events
  [msgrecv](#mqttmsgrecv)   manage receipt of messages
  [msgsent](#mqttmsgsent)   manage sending of messages
</div>

The callbacks here to handle disconnections and the sending and receipt of messages are minimal implementations. 

You can adapt them to the messages being sent to or received from your broker.


## `.mqtt.conn`

_Connect to a Mosquitto host_

```txt
.mqtt.conn[host;name;opts]
```

Where

-   `host` is the IP address or hostname of the MQTT broker being connected to as a symbol.
-   `name` is a symbol denoting the name to be given to the connecting process
-   `opts` dictionary of connection options to the MQTT broker, for default options use `()!()`

returns a failure notice if connnection to host could not be established otherwise does not return output.

!!! detail "The `opts` parameter lets you provide a username and password to brokers that require them. Further options will be added."

Within MQTT the Client Identifier identifies a client to the server. This must be unique to ensure connections are appropriately established. Within this interface the parameter `name` maps to `ClientID` and as such each defined `name` must be unique across all processes connecting to a broker.

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

```txt
.mqtt.disconn[]
```

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

```txt
.mqtt.msgrcvd[topic;msg]
```

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

_Handle callback on successfuly sending a message to an MQTT broker_

```txt
.mqtt.msgsent[token]
```

Where `token` is a long representing the `MqttDeliveryToken` to monitor delivery

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

```txt
.mqtt.pub[topic;msg]
```

Where

-   `topic` is a symbol denoting the topic that the message is to be sent to
-   `msg` is a string of the message being sent to the broker

returns a callback to the process stating that the message has been sent to the broker.

```q
// Connect to the host broker
q).mqtt.conn[`$"tcp://localhost:1883";`src]

// Publish a message to a topic named `topic1
q).mqtt.pub[`topic1;"This is a test message"];
(`msgsent;1)
```

??? detail "This function is a projection of the function `.mqtt.pubx` defined below."

    Where 

  	1. `kqos` is set to 1. The broker/client will deliver the message at least once, with confirmation required.
  	2. `kret` is set to `0b`. Messages are not retained after sending.


## `.mqtt.pubx`

_Publish a message to a Mosquitto broker, controlling quality of service and message retention_

```txt
.mqtt.pubx[topic;msg;kqos;kret]
```

Where

- `topic` is a symbol denoting the topic that the message is to be sent to
- `msg` is a string of the message being sent to the broker
- `kqos` is an long denoting the quality of service to be used
- `kret` is a boolean denoting if published messages are to be retained

returns a callback to the process stating that the message has been sent to the broker.

```q
// Connect to the host broker
q).mqtt.conn[`$"tcp://localhost:1883";`src]

// Publish a message to topic named topic2 with kqos=2, kret=1b
q).mqtt.pubx[`topic2;"Sending test message";2;1b]
(`msgsent;1)
```


## `.mqtt.sub`

_Subscribe to a topic on a Mosquitto broker process_

```txt
.mqtt.sub[topic]
```

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

```txt
.mqtt.unsub[topic]
```

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

