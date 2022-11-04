---
title: Solace function reference | Interfaces Documentation for kdb+ and q
author: Conor McCarthy
description: List all functionality and options for the kdb+ interface to Solace
date: April 2020
keywords: solace, interface, fusion , q
---
# Solace function reference

:fontawesome-brands-github:
[KxSystems/solace](https://github.com/KxSystems/solace)

<div markdown="1" class="typewriter">
.solace.   **Solace interface**

Event notifications
  [setSessionCallback](#solacesetsessioncallback)         Set a callback function for session events
  [setFlowCallback](#solacesetflowcallback)            Set a callback function for flow events

Connect-disconnect
  [init](#solaceinit)                       Connect to and create a session
  [destroy](#solacedestroy)                    Destroy a previously created session

Endpoint management
  [createEndpoint](#solacecreateendpoint)             Create an endpoint from a session
  [destroyEndpoint](#solacedestroyendpoint)            Destroy an endpoint from a session
  [endpointTopicSubscribe](#solaceendpointtopicsubscribe)     Add a topic subscription to an existing endpoint
  [endpointTopicUnsubscribe](#solaceendpointtopicunsubscribe)   Unsubscribe from a topic on an endpoint

Direct messaging
  [sendDirect](#solacesenddirect)                 Send a direct message
  [sendDirectRequest](#solacesenddirectrequest)          Send a direct message requiring a sync response

Topic subscription
  [setTopicMsgCallback](#solacesettopicmsgcallback)        Set callback for messages from topic subscriptions
  [setTopicRawMsgCallback](#solacesettopicrawmsgcallback)     Set callback for messages from topic subscriptions
  [subscribeTopic](#solacesubscribetopic)             Subscribe to a topic
  [unSubscribeTopic](#solaceunsubscribetopic)           Unsubscribe from a topic

Guaranteed/persistent messaging
  [sendPersistent](#solacesendpersistent)             Send a persistent message onto a queue or topic
  [sendPersistentRequest](#solacesendpersistentrequest)      Send a guaranteed message for a synchronous reply

Flow bindings
  [setQueueMsgCallback](#solacesetqueuemsgcallback)        Set callback for when message sent to an endpoint
  [setQueueRawMsgCallback](#solacesetqueuerawmsgcallback)     Set callback for when message sent to an endpoint
  [bindQueue](#solacebindqueue)                  Bind to a queue
  [sendAck](#solacesendack)                    Acknowledge processing of a message
  [unBindQueue](#solaceunbindqueue)                Remove subscription/binding created with bindQueue

Message functions
  [getPayloadAsBinary](#solacegetpayloadasbinary)         Get the binary part of the Solace message
  [getPayloadAsString](#solacegetpayloadasstring)         Get the string part of the Solace message
  [getPayloadAsXML](#solacegetpayloadasxml)            Get the XML part of the Solace message

Utility functions
  [getCapability](#solacegetcapability)              Value of the specified capability for the session
  [version](#solaceversion)                    Current version of the build/deployment
</div>



## Event notifications


### `.solace.setSessionCallback`

_Associate the provided function with session events_

```syntax
.solace.setSessionCallback callbackFunction
```

Where `callbackFunction` is a symbol denoting a function in your q session with arguments:

1.  [event type of event](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#a992799734a2bbe3dd8506ef332e5991f) (integer)
2.  response code returned for some event, otherwise zero (integer)
3.  further information about the event (string)

associates the named function with session events, such as connection notifications or session errors.

### `.solace.setFlowCallback`

_Associate the provided function with flow events_

```syntax
.solace.setFlowCallback callbackFunction
```

Where `callbackFunction` is a symbol denoting a function in your q session with arguments:

1.  [type of event](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#a992799734a2bbe3dd8506ef332e5991f) (integer)
2.  response code returned for some events, otherwise zero (integer)
3.  further information about the event (string)
4.  [destination type](#destination-types) (integer)
5.  destination name (string)


## Connect-disconnect

### `.solace.init`

_Connect to and create a session_

```syntax
.solace.init options
```

Where `options` is a symbol-to-symbol dictionary mapping Solace [properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/group___session_props.html) to their values.

Common properties are `SESSION_HOST`,  `SESSION_VPN_NAME`, `SESSION_USERNAME`, `SESSION_PASSWORD`, `SESSION_RECONNECT_RETRIES` and `SESSION_SSL_TRUST_STORE_DIR`.

!!! tip "You must be connected before running any subsequent Solace functions."

### `.solace.destroy`

_Destroy a session_

```syntax
.solace.destroy[]
```
Destroys the current session.


## Endpoint management


Endpoint-management functions may be used to create or destroy endpoints from the kdb+ session.
In some deployments, endpoints may already be created for you by an admin.

!!! tip "Endpoint management must be enabled for the user in order to use this functionality"


### `.solace.createEndpoint`

```syntax
.solace.createEndpoint[options;provFlags]
```

_Create an endpoint_

Where

-   `options` is a symbol-to-symbol dictionary mapping Solace [endpoint properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps) to their values.
-   `provFlags` is the [provision flag](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags) used by Solace (integer)

provisions an endpoint on the appliance from the session.


### `.solace.destroyEndpoint`

_Destroy an endpoint_

```syntax
.solace.destroyEndpoint[options;provFlags]
```

Where

-   `options` is a symbol-to-symbol dictionary mapping Solace [endpoint properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps) to their values
-   `provFlags` is the [provision flag](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags) used by Solace (integer)

destroys an endpoint from the session.


### `.solace.endpointTopicSubscribe`

_Add a topic subscription to an existing endpoint_

```syntax
.solace.endpointTopicSubscribe[options;provFlags;topic]
```

Where

-   `options` is a symbol-to-symbol dictionary mapping Solace [endpoint properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps) to their values
-   `provFlags` is the [provision flag](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags) used by Solace (integer)
-   `topic` is a topic subscription (symbol or string)

!!! tip "Topic subscriptions can be added to queues or remote clients."


### `.solace.endpointTopicUnsubscribe`

_Unsubscribe from a topic on an endpoint_

```syntax
.solace.endpointTopicUnsubscribe[options;provFlags;topic]
```

Where

-   `options` is a symbol-to-symbol dictionary mapping Solace [endpoint properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps) to their values
-   `provFlags` is the [provision flag](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags) used by Solace (integer)
-   `topic` is a topic subscription (symbol or string)

!!! tip "Un-subscriptions from topics may be from either queues or remote clients."


## Direct messaging


### `.solace.sendDirect`

_Send a direct message_

```syntax
.solace.sendDirect[topic;data]
```

Where

-  `topic` is the topic to which the message is sent (string)
-  `data` is the message payload (string, symbol or byte array)

:fontawesome-solid-globe:
[Solace direct messages](https://docs.solace.com/PubSub-Basics/Direct-Messages.htm)

Each message will automatically be populated with message-eliding eligibility enabled and dead message queue (DMQ) eligibility enabled.


### `.solace.sendDirectRequest`

_Send a direct message which requires a sync reply_

```syntax
.solace.sendDirectRequest[topic;data;timeout;replyType;replyDest]
```

Where

argument   | type                           | value
-----------|--------------------------------|--------------------------------
topic      | string                         | topic to which message is sent
data       | string, symbol, or byte vector | message payload
timeout    | integer                        | milliseconds to block/wait (> zero)
replyType  | integer                        | reply [destination type](#destination-types)
replyDest  | symbol                         | topic or queue a reply to this message goes to<br>(empty for default session topic)

returns either

-   the payload (byte array)
-   an integer error code (integer)

For example, if the result is 7, the reply wasn’t received.
<!-- FIXME: list return codes -->

<!-- FIXME Include example -->


## Topic subscription


### `.solace.setTopicMsgCallback`

_Set callback for messages received from topic subscriptions_

```syntax
.solace.setTopicMsgCallback callbackFunction
```
Where `callbackFunction` is <!-- FIXME name of? --> a q function with arguments:

1.  destination (symbol)
2.  message binary payload (byte vector)
3.  a dictionary:

    key        | type      | value
    -----------|-----------|----------------------------------------------
    isRedeliv  | boolean   | whether redelivered 
    isDiscard  | boolean   | whether messages  discarded prior to the current message<br>(Congestion discards only; not affected by message eliding.)
    isRequest  | boolean   | whether client expects a reply<br>(In this case the function should return a byte array.)
    sendTime   | timestamp | client’s send time, if populated

registers a q function to be called on receipt of messages from topic subscriptions.
If the dictionary value for `isRequest` is true, the function should return with the response message contents (a byte list) to indicate the sender requests a reply.


### `.solace.setTopicRawMsgCallback`

_Set callback for messages received from topic subscriptions_


```syntax
.solace.setTopicRawMsgCallback callbackFunction
```

Where `callbackFunction` is a function with arguments:

1.  destination (symbol)
2.  a pointer (long) to the underlying Solace message (can be used within the callback with the functions to get the payload based on the sender’s type e.g. `getPayloadAsXML`, `getPayloadAsString`, etc)
3.  a dictionary:

    key        | type      | content
    -----------|-----------|--------
    isRedeliv  | boolean   | whether redelivered
    isDiscard  | boolean   | whether messages discarded prior to the current message<br>(Congestion discards only; not affected by message eliding.)
    isRequest  | boolean   | whether client expects a reply<br>(In this case the function should return a byte array.)
    sendTime   | timestamp | client’s send time, if populated

registers `callbackFunction` to be called on receipt of messages from topic subscriptions.
If the dictionary value for `isRequest` is true, the function should return with the response message contents (a byte list) to indicate the sender requests a reply.

This is an alternative to `.solace.setTopicMsgCallback`.


### `.solace.subscribeTopic`

_Subscribe to a topic_

```syntax
.solace.subscribeTopic[topic;isBlocking]
```

Where

-   `topic` is the topic to subscribe to (string)
-   `isBlocking` is whether the subscription is blocking (boolean)

Solace format wildcards `(*, >)` can be used in the topic subscription value.

If `isBlocking` is true then block until confirm or true to get session event callback on sub activation.


### `.solace.unSubscribeTopic`

_Unsubscribe from a topic_

```syntax
.solace.unSubscribeTopic topic
```

Where `topic` is a string denoting a topic, unsubscribes from it.

```q
.solace.unSubscribeTopic "topic1"
```


## Guaranteed/persistent messaging


### `.solace.sendPersistent`

_Send a persistent message onto a queue or topic_

```syntax
.solace.sendPersistent[destType;dest;data;correlationId]
```

Where

argument       | type                    | value
---------------|-------------------------|-----------------------------------
destType       | integer                 | [destination type](#destination-types)
dest           | symbol                  | destination queue or topic
data           | char/symbol/byte vector | message payload
correlationId  | symbol                  | a Correlation ID to be carried in the Solace message headers unmodified – may be used for peer-to-peer message synchronization; null for default behavior

<!-- FIXME Include example -->


### `.solace.sendPersistentRequest`

_Send a guaranteed message requiring a synchronous reply_

```syntax
.solace.sendPersistentRequest[destType;dest;data;timeout;replyType;replydest]
```

Where

argument   | type                    | value
-----------|-------------------------|-----------------------------------
destType   | integer                 | [destination type](#destination-types)
dest       | symbol                  | destination queue or topic
data       | char/symbol/byte vector | message payload
timeout    | integer                 | milliseconds to block/wait (> zero)
replyType  | integer                 | reply [destination type](#destination-types)
replyDest  | symbol                  | topic/queue a reply to this message goes to<br>(empty for default session topic)

returns either

-   the payload (byte array)
-   an error code (integer)

For example, if the result is 7, the reply was not received.


## Flow bindings

### `.solace.setQueueMsgCallback`

_Set a callback function for when a message is sent to an endpoint_

```syntax
.solace.setQueueMsgCallback callbackFunction
```

Where `callbackFunction` is <!-- FIXME name of? --> a q function with arguments:

1.  flow destination: the queue from which the subscription originated (symbol)
2.  message payload (byte vector)
3.  a dictionary:

    key            | type    | value
    ---------------|---------|---------------------------------
    destType       | integer | [destination type](#destination-types)
    destName       | string  | destination name
    replyType      | integer | reply [destination type](#destination-types)
    replyDest      | string  | topic/queue to reply to
    correlationId  | string  | original message’s correlation ID
    msgId          | long    | used for [sending acks](#solacesendack)


### `.solace.setQueueRawMsgCallback`

_Set a callback function for when a message is sent to an endpoint_

```syntax
.solace.setQueueRawMsgCallback callbackFunction
```

Where `callbackFunction` is <!-- FIXME name of? --> a q function with arguments:

1.  flow destination: the queue from which the subscription originated (symbol)
2.  a pointer (long) to the underlying Solace message (can be used within the callback with the functions to get the payload based on the sender’s type e.g. `getPayloadAsXML`, `getPayloadAsString`, etc.)
3.  a dictionary:

    key            | type    | value
    ---------------|---------|---------------------------------
    destType       | integer | [destination type](#destination-types)
    destName       | string  | destination name
    replyType      | integer | reply [destination type](#destination-types)
    replyDest      | string  | topic/queue to reply to
    correlationId  | string  | original message’s correlation ID
    msgId          | long    | used for [sending acks](#solacesendack)

This is an alternative to `.solace.setQueueMsgCallback`.

### `.solace.bindQueue`

_Bind to a queue_

```syntax
.solace.bindQueue bindProps
```

Where `bindProps` is a symbol-to-symbol dictionary mapping the [Solace bind properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#flowProps) to their values.


### `.solace.sendAck`

_Acknowledge processing of a message_

```syntax
.solace.sendAck[endpointname;msgid]
```

Where

- `endpointname` is the name of an endpoint (string)
- `msgid` is the ID of a message (long)

This function allows you to acknowledge messages.
It should be called by the subscriptions `callbackFunction` to acknowledge that the message has been processed,
in order to prevent the message from being consumed on a subsequent subscription.

This is only required when you wish to take control and run with auto acks off (e.g. `FLOW_ACKMODE` disabled in the flow binding).


### `.solace.unBindQueue`

_Remove a subscription/binding_

```syntax
.solace.unBindQueue endpointname
```

Where `endpointname` is is a string naming an endpoint,
removes a subscription or binding created via `.solace.bindQueue`.

```q
.solace.unBindQueue "endpoint1"
```


## Message functions


### `.solace.getPayloadAsBinary`

_Get binary part of a Solace message_

```syntax
.solace.getPayloadAsBinary msg
```

Where `msg` is a message provided in the callback function registered with `setQueueRawMsgCallback` or `setTopicRawMsgCallback`,
returns either

-   a string
-   a long representing the Solace error code if the payload could be retrieved as binary

This API defaults to sending messages as binary (of which string/XML/etc can be used.)


### `.solace.getPayloadAsString`

_Get string part of a Solace message_

```syntax
.solace.getPayloadAsString msg
```

Where `msg` is a message provided in the callback function registered with `setQueueRawMsgCallback` or `setTopicRawMsgCallback`,
returns either

-   a string
-   a long representing the Solace error code if the payload was not a string Solace type

This corresponds to the Solace sender setting the payload using the Solace function to set the payload as a string.
(There is no conversion to string by this API.)


### `.solace.getPayloadAsXML`

_Get XML part of a Solace message_

```syntax
.solace.getPayloadAsXML msg
```

Where `msg` is a message provided in the callback function registered with `setQueueRawMsgCallback` or `setTopicRawMsgCallback`,
returns either

-   a byte vector
-   a long representing the Solace error code if the payload was not an XML Ssolace type

This corresponds to the Solace sender setting the payload using the Solace function to set the payload as XML.
(There is no conversion to XML by this API.)


## Utility functions


### `.solace.getCapability`

_Retrieve the value of the specified capability for the session_

```syntax
.solace.getCapability capabilityName
```

Where `capabilityName` is a symbol or string denoting a [capability](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#sessioncapabilities) returns the capability value for the session.

The returned value type will vary depending on the capability requested.


### `.solace.version`

_Current version of the build/deployment_

```syntax
.solace.version[]
```

Returns Solace API version info as a dictionary.


## Destination types

```txt
-1  null
0   topic
1   queue
2   temp topic
3   temp queue
```


