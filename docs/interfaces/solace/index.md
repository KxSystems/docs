---
title: Solace interface to kdb+ – Interfaces
description: Interface between kdb+ and Solace 
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
keywords: Solace, publish, subscribe, request, reply, streaming, qos, q
---
# ![Solace](../img/solace.jpeg) Solace interface to kdb+

<i class="fab fa-github"></i> [KxSystems/solace](https://github.com/KxSystems/solace)

## Introduction

The [Solace PubSub+ Event Broker](https://solace.com/products/event-broker/software/) can be used to efficiently stream events and information across cloud, on-premises and within IoT environments. The “+” in PubSub+ indicate it support of wide ranging functionality beyond publish/subscribe. This includes request/reply, streaming and replay, as well as different qualities of service, such as best effort and guaranteed delivery.

### Use-cases

This event broker is used across a number of sectors including the following

1. Airline industry (Air traffic control)
2. Financial services (Payment processing)
3. Retail (Supply chain/warehouse management)

Further information on sectors which make use of this technology can be found [here](https://solace.com/use-cases/)

### kdb+/Solace Integration

The purpose of this interface is to provide kdb+ users with the ability to communicate with a Solace PubSub+ event broker from a kdb+ session. The interface follows closely the Solace C api available [here](https://docs.solace.com/Solace-PubSub-Messaging-APIs/C-API/c-api-home.htm). Exposed functionality includes

1. Subscription to topics on Solace brokers
2. Direct/persistent/guaranteed messaging functionality
3. Endpoint management

A full outline of the available functionality is outlined [here](user-guide.md) with example inplementations outlined [here](examples.md).

Installation of this interface can be completed by following the install guide outlined [here](https://github.com/KxSystems/solace#installation).


In addition to integration with the C api use of the Solace RESTful api is also outlined for the sending and receipt of messages from kdb+. This method of integrating with Solace PubSub+ brokers is outlined [here](solacerest.md).

## Status

This interface is currently available as a beta version under an Apache 2.0 licence and is supported on a best effort basis by the Fusion team. This interface is currently in active development, with additional functionality to be released on an ongoing basis.

If you find issues with the interface or have feature requests please consider raising an issue [here](https://github.com/KxSystems/solace/issues). If you wish to contribute to this project please follow the contributing guide [here](https://github.com/KxSystems/solace/blob/master/CONTRIBUTING.md).
