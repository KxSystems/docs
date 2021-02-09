---
title: getenv, setenv – get and set environment variables | Reference | kdb+ and q documentation
description: getenv and setenv are q keywords that get or set an environment variable.
author: Stephen Taylor
---
# `getenv`

_Get or set an environment variable_




## `getenv`

_Get the value of an environment variable_

```txt
getenv x     getenv[x]
```

where `x` is a symbol atom naming an environment variable, returns its value.

```q
q)getenv `SHELL
"/bin/bash"
q)getenv `UNKNOWN      / returns empty if variable not defined
""
```


## `setenv`

_Set the value of an environment variable_

```txt
x setenv y     setenv[x;y]
```

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


----

:fontawesome-solid-book:
[`get`, `set`](get.md)
<br>
:fontawesome-solid-book-open:
[Environment](../basics/by-topic.md#environment)
