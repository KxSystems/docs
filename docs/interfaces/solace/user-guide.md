---
title: Guide for using Solace with kdb+
author: Conor McCarthy
description: List all functionality and options for the kdb+ interface to Solace 
date: April 2020
keywords: solace, interface, fusion , q
---
# <i class="fa fa-share-alt"></i> User guide 

<i class="fab fa-github"></i>
[KxSystems/solace](https://github.com/KxSystems/solace)

The following functions are those exposed within the `.solace` namespace allowing users to interact with Solace

```txt
.solace - Solace Interface
  // Event Notifications
  setSessionCallback         Set a callback function for session events
  setFlowCallback            Set a callback function for flow events

  // Connect-Disconnect
  init                       Connect to and create a session
  destroy                    Destroy a previously created session

  // Endpoint Management
  createEndpoint             Create an endpoint from a session
  destroyEndpoint            Destroy an endpoint from a session
  endpointTopicSubscribe     Add a topic subscription to an existing endpoint
  endpointTopicUnsubscribe   Unsubscribe from a topic on an endpoint
  
  // Direct Messaging
  sendDirect                 Send a direct message
  sendDirectRequest          Send a direct message requiring a sync response

  // Topic Subscription
  setTopicMsgCallback        Set callback for messages received from topic subscriptions
  subscribeTopic             Subscribe to a topic
  unSubscribeTopic           Unsubscribe from a topic

  // Guaranteed/Persistent messaging
  sendPersistent             Send a persistent message onto a queue or topic
  sendPersistentRequest      Send a guaranteed message requiring a synchronous reply

  // Flow Bindings
  setQueueMsgCallback        Set a callback function called when a message is sent to an endpoint
  bindQueue                  Bind to a queue
  sendAck                    Acknowledge processing of a message
  unBindQueue                Remove a subscription/binding created via .solace.bindQueue

  // Utility functions
  .solace.getCapability      Value of the specified capability for the session
  .solace.version            Current version of the build/deployment
  
```


## Event Notifications

### `.solace.setSessionCallback`

_Associate the provided function with session events such as connection notifications or session errors_

Syntax: `.solace.setSessionCallback[callbackFunction]`

Where

-  `callbackFunction` is a symbol denoting a function within your q session which takes three parameters:
	1. `eventType` is an integer denoting the type of event. Possible values are listed [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#a992799734a2bbe3dd8506ef332e5991f)
	2. `responseCode` is an integer denoting the response code that is returned for some event, otherwise zero.
	3. `eventInfo` is a string providing further information about the event

### .solace.setFlowCallback

_Associate the provided function with flow events_

Syntax: `.solace.setFlowCallback[callbackFunction]`

Where 

-  `callbackFunction` is a symbol named for a function within your q session which takes 5 parameters:
	1. `eventType` is an integer denoting the type of event. Possible values are listed [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#a992799734a2bbe3dd8506ef332e5991f)
	2. `responseCode` is an integer denoting the response code that is returned for some events, otherwise zero.
	3. `eventInfo` is a string providing further information about the event
	4. `destType` is an integer denoting the type of the destination. Possible values are listed [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#aa7d0b19a8c8e8fbec442272f3e05b485).
	5. `destName` is the destination name as a string


## Connection/Disconnection

### `.solace.init`

_Connect to and create a session_

Syntax: `.solace.init[options]`

Where

- `options` is a dictionary of options consisting of a symbol to symbol mapping. 
	- A list of possible session properties are listed [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/group___session_props.html). 
	- Common properties are `SESSION_HOST`,  `SESSION_VPN_NAME`, `SESSION_USERNAME`, `SESSION_PASSWORD`, `SESSION_RECONNECT_RETRIES`.
	- Mapping is from Solace property to kdb+ value

!!!Warning
	You must be connected before running any subsequent solace functions.

### `.solace.destroy`

_Destroy a previously created session_

Syntax: `.solace.destroy[unused]`

## EndPoint Management

The functions outlined here may be used to create or destroy endpoints from the kdb+ session. In some deployments, endpoints may already be created for you by an admin.

!!!Note
	Endpoint management must be enabled for the user in order to use this functionality

### `.solace.createEndpoint`

_Provision an endpoint on the appliance from a session_

Syntax: `.solace.createEndpoint[options;provFlags]`

Where

-  `options` is a symbol to symbol dictionary mapping Solace endpoint properties (keys) to their values. The list of possible Solace endpoint property names can be found [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps).
-  `provFlags` is an integer indicating the provision flag used by Solace. A list of provision flags for the Solace api can be found [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags).

### `.solace.destroyEndpoint`

_Destroys an endpoint from a session_

Syntax: `.solace.destroyEndpoint[options;provFlags]`

Where

-  `options` is a symbol to symbol dictionary mapping Solace endpoint properties (keys) to their values. The list of possible Solace endpoint property names can be found [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps).
-  `provFlags` is an integer indicating the provision flag used by Solace. A list of provision flags fo
r the Solace api can be found [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags).

### `.solace.endpointTopicSubscribe`

_Add a topic subscription to an existing endpoint_

Syntax: `.solace.endpointTopicSubscribe[options;provFlags;topic]`

Where

- `options` is a symbol to symbol dictionary mapping Solace endpoint properties (keys) to their values.. The list of possible Solace endpoint property names can be found [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps).
-  `provFlags` is an integer indicating the provision flag used by Solace. A list of provision flags fo
r the Solace api can be found [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags).
-  `topic` is a symbol or string denoting a topic subscription

!!!Note
	Topic subscriptions can be added to queues or remote clients

### `.solace.endpointTopicUnsubscribe`

_Unsubscribe from a topic on an endpoint_

Syntax: `.solace.endpointTopicUnsubscribe[options;provFlags;topic]`

Where

- `options` is a symbol to symbol dictionary. The list of possible Solace endpoint property names can be found [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#endpointProps).
-  `provFlags` is an integer indicating the provision flag used by Solace. A list of provision flags fo
r the Solace api can be found [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#provisionflags).
-  `topic` is a symbol or string denoting a topic subscription

!!!Note
	Unsubscriptions from topics may be from either queues or remote clients.


## Direct Messaging

###  `.solace.sendDirect`

_Send a direct message_

Syntax: `.solace.sendDirect[topic;data]`

Where

-  `topic` is a string denoting the topic to which the message is sent
-  `data` is the message payload as either a string, symbol or byte array

!!!Notes
	* Further information on direct messaging can be found [here](https://docs.solace.com/PubSub-Basics/Direct-Messages.htm).
	* Each message will automatically be populated with message eliding eligibility enabled and dead message queue (DMQ) eligibility enabled.

### `.solace.sendDirectRequest`

_Send a direct message which requires a sync reply_

Syntax: `.solace.sendDirectRequest[topic;data;timeout;replyType;replyDest]`

Where

-  `topic` is a string denoting the topic to which a message is sent
-  `data` is the message payload as either a string, symbol or byte array
-  `timeout` is an integer indicating the milliseconds to block/wait (must be greater than zero).
-  `replyType` is an integer  
	1. `-1 = null`
	2. `0 = topic`
	3. `1 = queue`
	4. `2 = temp topic`
	5. `3 = temp queue`
-  `replyDest` is a symbol denoting the topic/queue that you wish a reply to this message to go to (empty for default session topic).

Returns a byte array containing the payload on successful execution. Otherwise will return an integer to indicate the return code. For example if the return is `7`, the reply wasn't received.


## Topic Subscriptions

### `.solace.setTopicMsgCallback`

_Set callback for messages received from topic subscriptions_

Syntax: `.solace.setTopicMsgCallback[cb]`

Where

- `cb` is a function taking three parameters 
	1. `destination` as a symbol
	2. `payload` as a byte array containing the message payload
	3. `msg values` as a dictionary

!!!Notes
	* As mentioned above `msg values` is a dictionary. This consists of the following:

		1. `isRedeliv` is a boolean which states the redelivered status
		2. `isDiscard` is a boolean returning true if one or more messages have been discarded prior to the current message, otherwise it returns false. This indicates congestion discards only, and is not affected by message eliding.
		3. `isRequest` is a boolean stating if the client is expecting a reply (in which case the function should return a byte array for the response)
		4. `sendTime` is a timestamp of the client's send time (if populated)

	* This function registers a q function that should be called on receipt of messages from topic subscriptions. If the `msg values` contains a value of `1b` for the key `isRequest`, the function should return with the response message contents (type byte list) as this is an indication that the sender is requesting a reply.

### `.solace.subscribeTopic`

_Subscribe to a topic_

Syntax: `.solace.subscribeTopic[topic;isBlocking]`

Where

- `topic` is a string denoting the topic to subscribe to.
- `isBlocking` is a boolean indicating if the subscription is blocking

!!!Note
	- Solace format wildcards `(*, >)` can be used in the topic subscription value.
	- If `isBlocking` is true then block until confirm or true to get session event callback on sub activation

### `.solace.unSubscribeTopic`

_Unsubscribe from an existing topic subscription_

Syntax: `.solace.unSubscribeTopic[topic]`

Where

- `topic` is a string denoting the topic to unsubscribe from.

```q
q).solace.unSubscribeTopic["topic1"]
```


## Persistent/Guaranteed Message Publishing

### `.solace.sendPersistent`

_Send a persistent message onto a queue or topic_

Syntax: `.solace.sendPersistent[destType;dest;data;correlationId]`

Where

-  `destType` is an integer indicating the type of destination
	1. `-1 for null`
	2. `0 for topic`
	3. `1 for queue`
	4. `2 for temp topic`
	5. `3 for temp queue`
-  `dest` is a symbol denoting the name of the queue/topic destination
-  `data` is a string/symbol/byte data which forms the message payload
-  `correlationId` is an optional parameter with default behaviour accessed with null. Otherwise this is a symbol denoting ig a Correlation Id is carried in the Solace message headers unmodified which may be used for peer-to-peer message synchronization

### `.solace.sendPersistentRequest`

_Send a guaranteed message requiring a synchronous reply_

Syntax: `.solace.sendPersistentRequest[destType;dest;data;timeout;replyType;replydest]`

Where

-  `destType` is an integer denoting the type of destination
	1. `-1 for null`
	2. `0 for topic`
	3. `1 for queue`
	4. `2 for temp topic`
	5. `3 for temp queue`
-  `dest` is a symbol denoting the name of the queue/topic destination
-  `data` is a string/symbol/byte data which forms the message payload
-  `timeout` is an integer indicating the milliseconds to block/wait (must be greater than zero).
-  `replyType` is an integer representing the reply destination type
	1. `-1 = null`
	2. `0 = topic`
	3. `1 = queue`
	4. `2 = temp topic`
	5. `3 = temp queue`
-  `replyDest` is a symbol denoting the topic/queue that you wish a reply to this message to go to (empty for default session topic).

Returns a byte array containing the payload on successful execution. Otherwise will return an integer to indicate the return code. For example if the return is `7`, the reply wasn't received.


## Flow Binding

### `.solace.setQueueMsgCallback`

_Set a callback function which is called when a message is sent to an endpoint_

Syntax: `.solace.setQueueMsgCallback[callbackFunction]`

Where 

- `callbackFunction` is a q function taking three parameters
	1. `destination` is a symbol denoting the flow destination (queue from which the subscription originated)
	2. `payload` is a byte array containing the message payload
	3. `msg values` is a dictionary specifying message information

!!!Note
	* As mentioned above `msg values` is a dictionary. This consists of the following

		1. `destType` is an integer denoting the type of destination
		2. `destName` is the destination name as a string
		3. `replyType` is an integer representing the reply destination type
		4. `replyDest` is a string denoting the topic/queue that you wish a reply to this message to go to
	 	5. `correlationId` is a string containing the original messages correlationId
	 	6. `msgId` is a long used for sending acks see [here](#solacesendack)

	* See [here](#solacesendersistentRequest) for information on possible values for `destType` and `replyType`

### `.solace.bindQueue`

_Bind to a queue_ 

Syntax: `.solace.bindQueue[bindProps]`

Where

-  `bindProps` is a symbol to symbol dictionary. This maps symbols denoting the Solace bind properties to their values
 
!!!Note
	You can find possible flow binding properties [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#flowProps) along with the default settings.

### `.solace.sendAck`

_Acknowledge processing of a message_

Syntax: `.solace.sendAck[endpointname;msgid]`

Where
	
- `endpointname` is a string denoting the name of an endpoint
- `msgid` is a long denoting the ID of a message

!!!Notes
	* This function allows you to acknowledge messages. It should be called by the subscriptions `callbackFunction` to acknowledge that the message has been processed, in order to prevent the message from being consumed on a subsequent subscription.
	* This is only required when you wish to take control and run with auto acks off (e.g. `FLOW_ACKMODE` disabled in the flow binding).

### .solace.unBindQueue

_Remove a subscription/binding created via `.solace.bindQueue_

Syntax: `.solace.unBindQueue[endpointname]`

Where

-  `endpointname` is is a string denoting the name of an endpoint

```q
q).solace.unBindQueue["endpoint1"]
```

## Utility Functions

### `.solace.getCapability`

_Retreive the value of the specified capability for the session_

Syntax: `.solace.getCapability[capabilityName]`

Where

-  `capabilityName` is a symbol or string denoting a capability from a list of features [here](https://docs.solace.com/API-Developer-Online-Ref-Documentation/c/sol_client_8h.html#sessioncapabilities)

Returns the capability value for the session, returned value type will vary depending on the capability requested.

### `.solace.version`

_Current version of the build/deployment_

Syntax: `.solace.version[unused]`

Returns Solace API version info as a dictionary.

