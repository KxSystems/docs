---
title: Outline of the use of REST messaging with Solace
author: Conor McCarthy
description: Messaging solace broker via REST api
date: March 2020
keywords: Solace, PubSub+, publish, subscribe, REST, streaming 
---

# <i class="fa fa-share-alt"></i> Messaging and subscibing to Solace via REST api

The following page outlines an alternative method to interact with Solace using the the Solace REST api outline [here](https://docs.solace.com/Open-APIs-Protocols/REST-get-start.htm) rather than via the C api. This may be suitable in low data rate settings.

## REST Publishing to Solace

In order to publish to a Solace broker via REST a kdb+ user should make use of the function [.Q.hp](https://code.kx.com/q/ref/dotq/#qhp-http-post) to create a POST request.

The Solace [documentation](https://docs.solace.com/Open-APIs-Protocols/REST-get-start.htm) should be used as a reference guide to configure HTTP parameters according to your use case. This documentation should also be used to test the api prior to running from a kdb+ session

The following examples provide some basic commands to publish to queues and topics

### Publish to a queue

Publish the string 'hello world' to a Solace queue called 'KDB_QUEUE'

```q
q).Q.hp["http://localhost:9000/QUEUE/KDB_QUEUE";.h.ty`text]"hello world"
```

### Publish to a topic

Publish the string 'hello world' to a Solace topic called 'Q/topic' via direct messaging

```q
q).Q.hp["http://localhost:9000/TOPIC/Q/test";.h.ty`text]"hello world"
```

## REST Subscription

In order to configure a kdb+ instance to receive HTTP post requests from Solace a user must configure [.z.pp](https://code.kx.com/q/ref/dotz/#zpp-http-post) in order to receive these post requests.

You can then configure the Solace framework to publish to the kdb+ instance using the instances IP/port and remebering to preface any 'Post Request Target' with the character '/'

### Example

The following example returns a HTTP 200 response on receipt of a message and prints out the received payload. 

Configure the kdb+ instance as follows:

* Start the instance on port 12341

```bash
q -p 12341
```

* Define the `.z.pp` function to handle post requests

```q
q).z.pp:{[x] 0N!((first where x[0]=" ")+1)_x[0];r:.h.hn["200 OK";`txt;""];r}
```

Configuring a Solace REST Consumer using your host/port, with a queue binding will allow messages on the queue to be received in kdb+ (view Solace documentation on configuring REST consumers).

!!!Note
	It is possible to configure multiple REST endpoints in KDB+, with data transformations & callbacks.

