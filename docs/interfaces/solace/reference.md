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
.solace   **Solace interface**

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
  [setTopicMsgCallback](#solacesettopicmsgcallback)        Set callback for messages from topic subscriptions (provides binary payload)
  [setTopicRawMsgCallback](#solacesettopicrawmsgcallback)        Set callback for messages from topic subscriptions (provides original msg)
  [subscribeTopic](#solacesubscribetopic)             Subscribe to a topic
  [unSubscribeTopic](#solaceunsubscribetopic)           Unsubscribe from a topic

Guaranteed/persistent messaging
  [sendPersistent](#solacesendpersistent)             Send a persistent message onto a queue or topic
  [sendPersistentRequest](#solacesendpersistentrequest)      Send a guaranteed message for a synchronous reply

Flow bindings
  [setQueueMsgCallback](#solacesetqueuemsgcallback)        Set callback for when message sent to an endpoint (provides binary payload)
  [setQueueRawMsgCallback](#solacesetrawqueuemsgcallback)        Set callback for when message sent to an endpoint (provides original msg)
  [bindQueue](#solacebindqueue)                  Bind to a queue
  [sendAck](#solacesendack)                    Acknowledge processing of a message
  [unBindQueue](#solaceunbindqueue)                Remove subscription/binding created with bindQueue

Message functions
  .solace.getPayloadAsXML                Get the XML part of the Solace message
  .solace.getPayloadAsString                Get the string part of the Solace message
  .solace.getPayloadAsBinary                Get the binary part of the Solace message

Utility functions
  .solace.getCapability      Value of the specified capability for the session
  .solace.version            Current version of the build/deployment
</div>

Endpoint-management functions may be used to create or destroy endpoints from the kdb+ session. In some deployments, endpoints may already be created for you by an admin.

!!! tip "Endpoint management must be enabled for the user in order to use this functionality."



## `.solace.bindQueue`

_Bind to a queue_

Syntax: `.solace.bindQueue[bindProps]`

Where `bindProps` is a symbol-to-symbol dictionary mapping the [Solace bind properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#flowProps) to their values.


## `.solace.createEndpoint`

_Provision an endpoint on the appliance from a session_

Syntax: `.solace.createEndpoint[options;provFlags]`

Where

-   `options` is a symbol-to-symbol dictionary mapping Solace [endpoint properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps) to their values.
-  `provFlags` is an integer indicating the [provision flag](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags) used by Solace


## `.solace.destroy`

_Destroy a previously created session_

Syntax: `.solace.destroy[]`


## `.solace.destroyEndpoint`

_Destroys an endpoint from a session_

Syntax: `.solace.destroyEndpoint[options;provFlags]`

Where

-  `options` is a symbol-to-symbol dictionary mapping Solace [endpoint properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps) to their values
-  `provFlags` is an integer indicating the [provision flag](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags) used by Solace


## `.solace.endpointTopicSubscribe`

_Add a topic subscription to an existing endpoint_

Syntax: `.solace.endpointTopicSubscribe[options;provFlags;topic]`

Where

-   `options` is a symbol-to-symbol dictionary mapping Solace [endpoint properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps) to their values
-   `provFlags` is an integer indicating the [provision flag](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags) used by Solace
-   `topic` is a symbol or string denoting a topic subscription

!!! tip "Topic subscriptions can be added to queues or remote clients."


## `.solace.endpointTopicUnsubscribe`

_Unsubscribe from a topic on an endpoint_

Syntax: `.solace.endpointTopicUnsubscribe[options;provFlags;topic]`

Where

-   `options` is a symbol-to-symbol dictionary mapping Solace [endpoint properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps) to their values
-   `provFlags` is an integer indicating the [provision flag](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags) used by Solace
-   `topic` is a symbol or string denoting a topic subscription

!!! tip "Unsubscriptions from topics may be from either queues or remote clients."


## `.solace.getCapability`

_Retrieve the value of the specified capability for the session_

Syntax: `.solace.getCapability[capabilityName]`

Where `capabilityName` is a symbol or string denoting a [capability](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#sessioncapabilities) returns the capability value for the session.

The returned value type will vary depending on the capability requested.


## `.solace.init`

_Connect to and create a session_

Syntax: `.solace.init[options]`

Where `options` is a symbol-to-symbol dictionary mapping Solace [properties](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/group___session_props.html) to their values.

Common properties are `SESSION_HOST`,  `SESSION_VPN_NAME`, `SESSION_USERNAME`, `SESSION_PASSWORD`, and `SESSION_RECONNECT_RETRIES`.

!!! tip "You must be connected before running any subsequent Solace functions."


## `.solace.sendAck`

_Acknowledge processing of a message_

Syntax: `.solace.sendAck[endpointname;msgid]`

Where

- `endpointname` is a string denoting the name of an endpoint
- `msgid` is a long denoting the ID of a message

This function allows you to acknowledge messages. It should be called by the subscriptions `callbackFunction` to acknowledge that the message has been processed, in order to prevent the message from being consumed on a subsequent subscription.

This is only required when you wish to take control and run with auto acks off (e.g. `FLOW_ACKMODE` disabled in the flow binding).


##  `.solace.sendDirect`

_Send a direct message_

Syntax: `.solace.sendDirect[topic;data]`

Where

-  `topic` is a string denoting the topic to which the message is sent
-  `data` is the message payload as either a string, symbol or byte array

:fontawesome-solid-globe:
[Solace direct messages](https://docs.solace.com/PubSub-Basics/Direct-Messages.htm)

Each message will automatically be populated with message-eliding eligibility enabled and dead message queue (DMQ) eligibility enabled.


## `.solace.sendDirectRequest`

_Send a direct message which requires a sync reply_

Syntax: `.solace.sendDirectRequest[topic;data;timeout;replyType;replyDest]`

Where

-   `topic` is a string denoting the topic to which a message is sent
-   `data` is the message payload as either a string, symbol or byte array
-   `timeout` is an integer indicating the milliseconds to block/wait (must be greater than zero).
-   `replyType` is an integer (see below)
-   `replyDest` is a symbol denoting the topic/queue that you wish a reply to this message to go to (empty for default session topic).

returns a byte array containing the payload on successful execution; else an integer return code. For example, if the result is 7, the reply wasn’t received.

```txt
replyType:

-1  null
0   topic
1   queue
2   temp topic
3   temp queue
```


## `.solace.sendPersistent`

_Send a persistent message onto a queue or topic_

Syntax: `.solace.sendPersistent[destType;dest;data;correlationId]`

Where

-   `destType` is an integer indicating the type of destination (see below)
-   `dest` is a symbol denoting the name of the queue/topic destination
-   `data` is a string/symbol/byte data which forms the message payload
-   `correlationId` is an optional parameter with default behavior accessed with null. Otherwise this is a symbol denoting e.g. a Correlation ID is carried in the Solace message headers unmodified which may be used for peer-to-peer message synchronization

```txt
destType:

-1  null
0   topic
1   queue
2   temp topic
3   temp queue
```


## `.solace.sendPersistentRequest`

_Send a guaranteed message requiring a synchronous reply_

Syntax: `.solace.sendPersistentRequest[destType;dest;data;timeout;replyType;replydest]`

Where

-   `destType` is an integer denoting the type of destination
-   `dest` is a symbol denoting the name of the queue/topic destination
-   `data` is a string/symbol/byte data which forms the message payload
-   `timeout` is an integer indicating the milliseconds to block/wait (must be greater than zero).
-   `replyType` is an integer representing the reply destination type
-   `replyDest` is a symbol denoting the topic/queue that you wish a reply to this message to go to (empty for default session topic).

returns a byte array containing the payload on successful execution; else an integer return code. For example, if the result is 7, the reply was not received.

```txt
destType:               replyType:

-1  null                -1  null
0   topic               0   topic
1   queue               1   queue
2   temp topic          2   temp topic
3   temp queue          3   temp queue
```


## `.solace.setFlowCallback`

_Associate the provided function with flow events_

Syntax: `.solace.setFlowCallback[callbackFunction]`

Where `callbackFunction` is a symbol named for a function within your q session which takes five arguments:

1.  `eventType` is an [integer denoting the type of event](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#a992799734a2bbe3dd8506ef332e5991f)
2.  `responseCode` is an integer denoting the response code returned for some events, otherwise zero.
3.  `eventInfo` is a string providing further information about the event
4.  `destType` is an integer denoting the [type of the destination](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#aa7d0b19a8c8e8fbec442272f3e05b485).
5.  `destName` is the destination name as a string


## `.solace.setQueueMsgCallback`

_Set a callback function for when a message is sent to an endpoint_

Syntax: `.solace.setQueueMsgCallback[callbackFunction]`

Where `callbackFunction` is a q function taking three arguments:

1.  `destination` is a symbol denoting the flow destination (queue from which the subscription originated)
2.  `payload` is a byte array containing the message payload
3.  `msg values` is a dictionary specifying message information as follows:

<div markdown="1" class="typewriter">
destType       type of destination (integer)
destName       destination name (string)
replyType      reply destination type (integer)
replyDest      topic/queue to reply to (string)
correlationId  original message’s correlation ID (string)
msgId          used for [sending acks](#solacesendack) (long)
</div>
:fontawesome-regular-hand-point-right:
[Values for `destType` and `replyType`](#solacesendpersistentrequest) 

## `.solace.setQueueRawMsgCallback`

_Set a callback function for when a message is sent to an endpoint_. *This is an alternative to `.solace.setQueueMsgCallback`.*

Syntax: `.solace.setQueueRawMsgCallback[callbackFunction]`

Where `callbackFunction` is a q function taking three arguments:

1.  `destination` is a symbol denoting the flow destination (queue from which the subscription originated)
2.  `msg` as a long pointing to the underlying solace msg (can be used within the callback with the functions to get the payload based on the senders type e.g. `getPayloadAsXML`, `getPayloadAsString`, etc).
3.  `msg values` is a dictionary specifying message information as follows:

<div markdown="1" class="typewriter">
destType       type of destination (integer)
destName       destination name (string)
replyType      reply destination type (integer)
replyDest      topic/queue to reply to (string)
correlationId  original message’s correlation ID (string)
msgId          used for [sending acks](#solacesendack) (long)
</div>

:fontawesome-regular-hand-point-right:
[Values for `destType` and `replyType`](#solacesendpersistentrequest) 


## `.solace.setSessionCallback`

_Associate the provided function with session events such as connection notifications or session errors_

Syntax: `.solace.setSessionCallback[callbackFunction]`

Where `callbackFunction` is a symbol denoting a function within your q session which takes three arguments:

1.  `eventType` is an integer denoting the [type of event](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#a992799734a2bbe3dd8506ef332e5991f)
2.  `responseCode` is an integer denoting the response code that is returned for some event, otherwise zero
3.  `eventInfo` is a string providing further information about the event


## `.solace.setTopicMsgCallback`

_Set callback for messages received from topic subscriptions_

Syntax: `.solace.setTopicMsgCallback[callbackFunction]`

Where `callbackFunction` is a function taking three arguments:

1.  `destination` as a symbol
2.  `payload` as a byte array containing the message binary payload
3.  `msg values` as a dictionary: see below

```txt
isRedeliv  whether redelivered (boolean)
isDiscard  whether messages have been discarded prior to the current message (boolean)
           (Indicates congestion discards only; not affected by message eliding.)
isRequest  whether client expects a reply (boolean) 
           (In this case the function should return a byte array.)
sendTime   client’s send time, if populated (timestamp)
```

registers a q function to be called on receipt of messages from topic subscriptions. If the `msg values` contains a value of `1b` for the key `isRequest`, the function should return with the response message contents (type byte list) as this indicate the sender requests a reply.

## `.solace.setTopicRawMsgCallback`

_Set callback for messages received from topic subscriptions_. *This is an alternative to `.solace.setTopicMsgCallback`.*

Syntax: `.solace.setTopicRawMsgCallback[callbackFunction]`

Where `callbackFunction` is a function taking three arguments:

1.  `destination` as a symbol
2.  `msg` as a long pointing to the underlying solace msg (can be used within the callback with the functions to get the payload based on the senders type e.g. `getPayloadAsXML`, `getPayloadAsString`, etc).
3.  `msg values` as a dictionary: see below

```txt
isRedeliv  whether redelivered (boolean)
isDiscard  whether messages have been discarded prior to the current message (boolean)
           (Indicates congestion discards only; not affected by message eliding.)
isRequest  whether client expects a reply (boolean) 
           (In this case the function should return a byte array.)
sendTime   client’s send time, if populated (timestamp)
```

registers a q function to be called on receipt of messages from topic subscriptions. If the `msg values` contains a value of `1b` for the key `isRequest`, the function should return with the response message contents (type byte list) as this indicate the sender requests a reply.


## `.solace.subscribeTopic`

_Subscribe to a topic_

Syntax: `.solace.subscribeTopic[topic;isBlocking]`

Where

-   `topic` is a string denoting the topic to subscribe to
-   `isBlocking` is a boolean indicating if the subscription is blocking

Solace format wildcards `(*, >)` can be used in the topic subscription value.

If `isBlocking` is true then block until confirm or true to get session event callback on sub activation.


## `.solace.unBindQueue`

_Remove a subscription/binding created via `.solace.bindQueue`_

Syntax: `.solace.unBindQueue[endpointname]`

Where `endpointname` is is a string denoting the name of an endpoint

```q
q).solace.unBindQueue["endpoint1"]
```


## `.solace.unSubscribeTopic`

_Unsubscribe from an existing topic subscription_

Syntax: `.solace.unSubscribeTopic[topic]`

Where `topic` is a string denoting the topic to unsubscribe from.

```q
q).solace.unSubscribeTopic["topic1"]
```



## `.solace.version`

_Current version of the build/deployment_

Syntax: `.solace.version[]`

Returns Solace API version info as a dictionary.

## `.solace.getPayloadAsXML`

_Get XML part of a Solace msg_

Syntax: `.solace.getPayloadAsXML[msg]`

Where `msg` is a msg provided in the callback function registered with `setQueueRawMsgCallback` or `setTopicRawMsgCallback`. This corresponds to the Solace sender setting the payload using the solace function to set the payload as XML (there is no conversion to XML by this API).

Returns byte array (or long representing the solace error code if the payload wasnt an XML solace type)

## `.solace.getPayloadAsString

_Get string part of a Solace msg_

Syntax: `.solace.getPayloadAsString[msg]`

Where `msg` is a msg provided in the callback function registered with `setQueueRawMsgCallback` or `setTopicRawMsgCallback`. This corresponds to the Solace sender setting the payload using the solace function to set the payload as string (there is no conversion to string by this API).

Returns char array (or long representing the solace error code if the payload wasnt an string solace type)

## `.solace.getPayloadAsBinary

_Get binary part of a Solace msg_

Syntax: `.solace.getPayloadAsBinary[msg]`

Where `msg` is a msg provided in the callback function registered with `setQueueRawMsgCallback` or `setTopicRawMsgCallback`.

Returns char array (or long representing the solace error code if the payload could be retrieved as binary). This API defaults to sending msgs as binary (of which string/xml/etc can be used).


















