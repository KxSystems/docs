---
title: Outline of the use of REST messaging with Solace
author: Conor McCarthy
description: Messaging solace broker via REST api
date: March 2020
keywords: Solace, PubSub+, publish, subscribe, REST, streaming 
---

# Solace messaging and subscription via RESTful API

An alternative method to interact with Solace using the Solace [REST API](https://docs.solace.com/Open-APIs-Protocols/REST-get-start.htm) rather than the C API. 
This may be suitable in low data-rate settings.


## REST publishing to Solace

To publish from q to a Solace broker via REST, use [`.Q.hp`](../../ref/dotq.md#hp-http-post) to create a POST request.

Use the Solace [documentation](https://docs.solace.com/Open-APIs-Protocols/REST-get-start.htm) as a guide to configure HTTP parameters for your use case. Use it also to test the API before running from a kdb+ session.

The following examples provide some basic commands to publish to queues and topics.


### Publish to a queue

Publish the string `"hello world"` to a Solace queue called `KDB_QUEUE`.

```q
.Q.hp["http://localhost:9000/QUEUE/KDB_QUEUE";.h.ty`text]"hello world"
```


### Publish to a topic

Publish the string `"hello world"` to a Solace topic called `Q/topic` via direct messaging.

```q
.Q.hp["http://localhost:9000/TOPIC/Q/test";.h.ty`text]"hello world"
```


## REST Subscription

For a kdb+ instance to receive HTTP POST requests from Solace, configure [`.z.pp`](../../ref/dotz.md#zpp-http-post) to receive these POST requests.

You can then configure the Solace framework to publish to the kdb+ instance using the instance’s IP/port. 

!!! tip "Remember to preface any Post Request Target with the character `/`."


The following example returns a HTTP 200 response on receipt of a message and prints out the received payload. 

Configure the kdb+ instance as follows:

Start the instance on port 12341

```bash
q -p 12341
```

Define the `.z.pp` function to handle post requests

```q
.z.pp:{[x] 0N!((first where x[0]=" ")+1)_x[0];r:.h.hn["200 OK";`txt;""];r}
```

Configuring a Solace REST Consumer using your host/port, with a queue binding will allow messages on the queue to be received in kdb+. (See Solace documentation on configuring REST consumers.)

!!! tip "It is possible to configure multiple REST endpoints in kdb+, with data transformations and callbacks."

