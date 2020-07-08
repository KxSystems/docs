---
title: Example usage | Solace | Interfaces | Docuemntation for q and kdb+
author: Conor McCarthy
description: Examples showing the use of the Solace kdb+ interface
date: March 2020
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
keywords: Solace, PubSub+, publish, subscribe, request, reply, streaming
---

# Solace interface examples

:fontawesome-brands-github:
[KxSystems/solace](https://github.com/KxSystems/solace)

The scripts below are in the `examples` folder of the [interface](https://github.com/KxSystems/solace/tree/master/examples). 
They provide insight into the different capabilities of the interface.


## Requirements

1. The Solace interface installed as described in the interface’s [`README.md`](https://github.com/kxsystems/solace/blob/master/README.md)
2. The folder `script/` containing `solace.q` placed either in the examples folder or (preferably) in the your `QHOME` directory.

## Parameters

Pass parameters to the scripts as command-line arguments.
Default values for all parameters are set in `sol_init.q`.

```txt
-corr   correlation ID
-data   message payload to send
-dest   name of endpoint queue to use or create
-dtype  type of destination: [queue (default) | topic]
-host   broker hostname
-name   name of the endpoint to create
-pass   password
-queue  name of the exiting queue endpoint to alter
-topic  topic name  (Solace wildcard format supported)
-user   username
-vpn    VPN name
```


## Endpoint interactions

### Create a queue

`q sol_endpoint_create.q -host -vpn -user -pass -name`

Creates a queue on a Solace PubSub+ broker, subject to permission.

```bash
q sol_endpoint_create.q -name "Q/test"
```


### Remove an endpoint

`q sol_endpoint_destroy.q -host -vpn -user -pass -name`

Removes an existing endpoint on the Solace broker, subject to permission.

```bash
q sol_endpoint_destroy.q -name "Q/test"
```


### Add a topic subscription to a queue

`q sol_topic_to_queue_mapping.q -host -vpn -user -pass -queue -topic`

Adds a topic subscription to an existing endpoint queue, subject to permission.

```bash
q sol_topic_to_queue_mapping.q -queue "Q/test" -topic "Q/topic"
```


## Pub/sub with direct messages


### Send a direct message via a topic

`q sol_pub_direct.q -host -vpn -user -pass -topic -data`

This can be used in conjunction with `sol_sub_direct.q` or any Solace example program.

```bash
q sol_pub_direct.q -topic "Q/1" -data "hello world"
```


### Subscribe to a topic for direct messages

`q sol_sub_direct.q -host -vpn -user -pass -topic`

```bash
q sol_sub_direct.q -host 192.168.65.2:55111 -topic "Q/>"
```


### Send a direct message via a topic, request a reply

`q sol_pub_directrequestor.q -host -vpn -user -pass -topic -data`

Sends a direct message via a topic, and requests a reply as part of the published message.

This can be used in conjunction with `sol_sub_directreplier.q` or any Solace example program.

```bash
q sol_pub_directrequestor.q -topic "Q/1" -data "hello world"
```

### Subscribe to a topic for direct messages, replying

`q sol_sub_directrequestor.q -host -vpn -user -pass -topic`

Subscribes to a topic for the consumption of direct messages, replying to any message received.

```bash
q sol_sub_directreplier.q -host 192.168.65.2:55111 -topic "Q/>"
```


## Pub/sub with guaranteed messages

### Send a persistent or guaranteed message

`q sol_pub_persist.q -host -vpn -user -pass -data -dtype -dest -corr`

Sends a persistent or guaranteed message to an existing endpoint.

(See `sol_endpoint_create.q`.)

```bash
q sol_pub_persist.q -dtype "queue" -dest "Q/1" -data "hello world" -corr 555
```

### Subscribe while printing and acknowledging each message

`q sol_sub_persist.q -host -vpn -user -pass -dest`

```bash
q sol_sub_persist.q -dest "Q/1"
```

