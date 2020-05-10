---
title: Example usage of the Solace kdb+ interface
author: Conor McCarthy
description: Examples showing the use of the Solace kdb+ interface
date: March 2020
keywords: Solace, PubSub+, publish, subscribe, request, reply, streaming 
---

# <i class="fa fa-share-alt"></i> Solace Interface Examples

<i class="fab fa-github"></i> [KxSystems/solace](https://github.com/KxSystems/solace)

The following page outlines the use of a number of scripts provided with this interface to highlight available functionality within the interface.

## Requirements

These examples require the following steps to be completed

1. The Solace interface to be installed following the steps outlined in the interfaces `README.md` [here](https://github.com/kxsystems/solace/blob/master/README.md)
2. The folder `script/` containing `solace.q` be placed either in the examples folder or preferably in the users `$QHOME`/`%QHOME%` directory.

## Examples

Each of the scripts outlined below are contained in the `examples` folder of the interface [here](https://github.com/KxSystems/solace/tree/master/examples). These scripts provide an insight into to different capabilities within the Solace Interface.

An outline is provided here as a guide for potential users, in order to showcase the parameters which can be passed to the scripts as command line arguments on initialisation of a q session.

### Endpoint interactions

#### `sol_endpoint_create.q`

Create a queue on a Solace PubSub+ broker (permission permitting)

```bash
q sol_endpoint_create.q -name "Q/test"
```

Parameters:

- `-host` = broker hostname
- `-vpn`  = VPN name
- `-user` = username
- `-pass` = password
- `-name` = name of the endpoint to be created

#### `sol_endpoint_destroy.q`

Remove a previously created endpoint on the Solace broker (permission permitting)

```bash
q sol_endpoint_destroy.q -name "Q/test"
```

Parameters:

- `-host` = broker hostname
- `-vpn`  = VPN name
- `-user` = username
- `-pass` = password
- `-name` = name of the endpoint to be created

#### `sol_topic_to_queue_mapping.q`

Add a topic subscription to an existing endpoint queue (permission permitting)

```bash
q sol_topic_to_queue_mapping.q -queue "Q/test" -topic "Q/topic"
```

Parameters:

- `-host`  = Broker hostname
- `-vpn`   = VPN name
- `-user`  = username
- `-pass`  = password
- `-queue` = name of the exiting queue endpoint to alter
- `-topic` = name of the topic to add to the existing queue

### Pub/Sub with Direct Messages

#### `sol_pub_direct.q`

Sends a direct message via a topic. This can be used in conjunction with the script `sol_sub_direct.q` or any solace example program.

```bash
q sol_pub_direct.q -topic "Q/1" -data "hello world"
```

Parameters:

- `-host`  = Broker hostname
- `-vpn`   = VPN name
- `-user`  = username
- `-pass`  = password
- `-topic` = topic name to publish the message to
- `-data`  = message payload to send

#### `sol_sub_direct.q`

Subscribe to a topic for the consumption of direct messages

```bash
q sol_sub_direct.q -host 192.168.65.2:55111 -topic "Q/>"
```

Parameters:

- `-host`  = Broker hostname
- `-vpn`   = VPN name
- `-user`  = username
- `-pass`  = password
- `-topic` = topic name to publish the subscribe to (Solace wildcard format supported)

#### `sol_pub_directrequestor.q`

Sends a direct message via a topic, with the additional requirement that the publisher request a reply as part of the publised message. This can be used in conjunction with the script `sol_sub_directreplier.q` or any solace example program.

```bash
q sol_pub_directrequestor.q -topic "Q/1" -data "hello world"
```

Parameters:

- `-host`  = Broker hostname
- `-vpn`   = VPN name
- `-user`  = username
- `-pass`  = password
- `-topic` = topic name to publish the message to
- `-data`  = message payload to send

#### `sol_sub_directrequestor.q`

Subscribe to a topic for the consumption of direct messages, replying to any message received

```bash
q sol_sub_directreplier.q -host 192.168.65.2:55111 -topic "Q/>"
```

Parameters:

- `-host`  = Broker hostname
- `-vpn`   = VPN name
- `-user`  = username
- `-pass`  = password
- `-topic` = topic name to publish the subscribe to (Solace wildcard format supported)

### Pub/Sub With Guaranteed Messages

#### `sol_pub_persist.q`

Sends a persistent/guaranteed message to an existing endpoint (see sol_endpoint_create.q)

```bash
q sol_pub_persist.q -desttype "queue" -destname "Q/1" -data "hello world"  -correlationid 555
```

Parameters:

- `-host`  = Broker hostname
- `-vpn`   = VPN name
- `-user`  = username
- `-pass`  = password
- `-data`  = message payload to send
- `-dtype` = (optional) type of the destination (can be 'queue' or 'topic'), defaults to queue
- `-dest`  = (optional) name of the endpoint to be created
- `-corr`  = (optional) correlation id

#### `sol_sub_persist.q`

Subscribes, while printing and acknowledging each message

```bash
q sol_sub_persist.q -destname "Q/1"
```

Parameters:

- `-host` = Broker hostname
- `-vpn`  = VPN name
- `-user` = username
- `-pass` = password
- `-dest` = (optional) name of the endpoint queue to be used

