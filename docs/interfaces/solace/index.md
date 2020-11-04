---
title: Solace | Interfaces | Documentation for kdb+ and q
description: Interface between kdb+ and Solace 
keywords: Solace, publish, subscribe, request, reply, streaming, qos, q
---
# ![Solace](../img/solace.jpeg) Solace interface to kdb+

:fontawesome-brands-github:
[KxSystems/solace](https://github.com/KxSystems/solace)



The [Solace PubSub+ Event Broker](https://solace.com/products/event-broker/software/) can be used to efficiently stream events and information across cloud, on-premises and within IoT environments. The “+” in PubSub+ indicates its support of wide-ranging functionality beyond publish-subscribe. This includes request-reply, streaming and replay, as well as different qualities of service, such as best-effort and guaranteed delivery.


## Use cases

The event broker is used across a number of sectors including

-   airline industry (air-traffic control)
-   financial services (payment processing)
-   retail (supply-chain/warehouse management)

:fontawesome-solid-globe:
[Other sectors](https://solace.com/use-cases/)


## Kdb+/Solace Integration

This interface lets you communicate with a Solace PubSub+ event broker from a kdb+ session. The interface follows closely the [Solace C API](https://docs.solace.com/Solace-PubSub-Messaging-APIs/C-API/c-api-home.htm). Exposed functionality includes

-   subscription to topics on Solace brokers
-   direct/persistent/guaranteed messaging functionality
-   endpoint management

:fontawesome-brands-github:
[Install guide](https://github.com/KxSystems/solace#installation)

## Status

The interface is currently available under an Apache 2.0 licence and is supported on a best effort basis by the Fusion team. This interface is currently in active development, with additional functionality to be released on an ongoing basis.

:fontawesome-brands-github: 
[Issues and feature requests](https://github.com/KxSystems/solace/issues) 
<br>
:fontawesome-brands-github: 
[Guide to contributing](https://github.com/KxSystems/solace/blob/master/CONTRIBUTING.md)