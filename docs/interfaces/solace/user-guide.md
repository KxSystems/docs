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
Solace Interface
  // Initialization functions
  
  // Callback functions
  
  // Topic handling functionality

  // General use functions
  .solace.version       What version of the solace api is being used

```

## General functions

The following functionality allows a number of general procedures to be completed

### `.solace.version`

_What version of the solace api is being used_

Syntax: `.solace.version[]`

returns ...

```q
q).solace.version[]
...
```
