---
title: getenv, setenv
description: getenv and setenv are q keywords that get or set an environment variable.
author: Stephen Taylor
keywords: environment, get, getenv, kdb+, q, set, setenv, variable
---
# `getenv`

_Get or set an environment variable_




## `getenv`

_Get the value of an environment variable_

Syntax: `getenv x`, `getenv[x]`

where `x` is a symbol atom naming an environment variable, returns its value.

```q
q)getenv `SHELL
"/bin/bash"
q)getenv `UNKNOWN      / returns empty if variable not defined
""
```


## `setenv`

_Set the value of an environment variable_

Syntax: `x setenv y`, `setenv[x;y]`

where 

-   `x` is a symbol atom
-   `y` is a string

sets the environment variable named by `x`.

```q
q)`RTMP setenv "/home/user/temp"
q)getenv `RTMP
"/home/user/temp"
q)\echo $RTMP
"/home/user/temp"
```


<i class="far fa-hand-point-right"></i> 
[`get`, `set`](get.md)  
Basics: [Environment](../basics/environment.md) 
