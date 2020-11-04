---
title: Architecture | Documentation for q and kdb+
description: How to construct systems from kdb+ processes
author: Stephen Taylor
date: November 2020
---
# Architecture of kdb+ systems




![architecture](../img/architecture.png)


Applications that use kdb+ typically consist of multiple processes. 

The means by which processes communicate with each other may be as simple as the [interprocess communication](../basics/ipc.md) baked into the q language, or more sophisticated interfaces such as [Apache Kafka](../interfaces/kafka/index.md) or a [Solace event broker](../interfaces/solace/index.md). 