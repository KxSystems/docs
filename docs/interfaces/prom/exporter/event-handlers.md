---
title: Guide for using the Prometheus exporter with kdb+
author: Conor McCarthy
description: List all functionality and options for the Prometheus Exporter for kdb+ metrics 
date: April 2020
keywords: prometheus, grafana, monitoring, metrics, interface, fusion, exporter, visualisation, q
---
# <i class="fa fa-share-alt"></i> Metric Event Handlers 

<i class="fab fa-github"></i>
[KxSystems/prometheus-kdb-exporter](https://github.com/KxSystems/prometheus-kdb-exporter)

Metric updates are generally carried out inside event handlers. By overwriting these handlers, users can update metric values in response to various triggers ranging from HTTP requests to timer events.

The functions outlined below can be modified to allow a user to monitor events outside those exposed in `exporter.q` 

```txt
Prometheus event handlers triggered on
  .prom.on_poll        Prometheus poll request
  .prom.on_pc          ipc socket connection closing
  .prom.on_po          ipc socket connection opening
  .prom.on_wc          Websocket connection closing
  .prom.on_wo          Websocket connection opening
  .prom.afer_pg        Syncronous ipc socket request handler, call after execution
  .prom.before_pg      Syncronous ipc socket request handler, call before execution
  .prom.after_ps       Asynchronous ipc socket request handler, call after execution
  .prom.before_ps      Asynchronous ipc socket request handler, call before execution
  .prom.after_ph       HTTP GET request handler, call after execution
  .prom.before_ph      HTTP GET request handler, call before execution
  .prom.after_pp       HTTP POST request handler, call after execution
  .prom.before_pp      HTTP POST request handler, call before execution
  .prom.after_ws       Websocket request handler, call after execution
  .prom.before_ws      Websocket request handler, call before execution
  .prom.after_ts       Timer event handler, call after execution
  .prom.before_ts      Timer event handler, call after execution
```

!!!Note
	* Example invocations of these event handlers can be seen [here](https://github.com/KxSystems/prometheus-kdb-exporter/blob/master/exporter.q)
	* Once the relevant event handlers have been defined to update the metric values, the library can by initialized with a call to [`.prom.init`](./user-guide.md#initialize-library)
	* Updating `.z.*` handlers after the call to `.prom.init` will overwrite the Prometheus logic. Correct usage is to load all process logic before loading the Prometheus library. 

## `.prom.on_poll`

_Prometheus poll request handler_

Syntax: `.prom.on_poll[msg]`

Where

- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)

## `.prom.on_po`

_Socket open handler_

Syntax: `.prom.on_po[hdl]`

Where

- `hdl` is the handle of the socket connection being opened

## `.prom.on_pc`

_Socket close handler_

Syntax: `.prom.on_pc[hdl]`

Where

- `hdl` is the handle of the socket connection being closed

## `.prom.before_pg`

_Synchronous ipc socket request handler, called before execution_

Syntax: `.prom.before_pg[msg]`

Where

- `msg` is the object to be executed 

returns a `tmp` object to be passed to the _after_ handler.

## `.prom.after_pg`

_Synchronous ipc socket request handler, called after execution_

Syntax: `.prom.after_pg[tmp;msg;res]`

Where

- `tmp` is the object returned by `.prom.before_pg`
- `msg` is the object that was executed
- `res` is the object returned by the execution of `msg` 

## `.prom.before_ps`

_Asynchronous ipc socket request handler, called before execution_

Syntax: `.prom.before_ps[msg]`

Where

- `msg` is the object to be executed 

returns a `tmp` object to be passed to the _after_ handler.

## `.prom.after_ps`

_Asynchronous ipc socket request handler, called after execution_

Syntax: `.prom.after_ps[tmp;msg;res]`

Where

- `tmp` is the object returned by `.prom.before_ps`
- `msg` is the object that was executed
- `res` is the object returned by the execution of `msg` 

## `.prom.before_ph`

_HTTP GET request handler, called before execution_

Syntax: `.prom.before_ph[msg]`

Where

- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)

returns a `tmp` object to be passed to the _after_ handler.

## `.prom.after_ph`

_HTTP GET request handler, called after execution_

Syntax: `.prom.after_ph[tmp;msg;res]`

Where

- `tmp` is the object returned by `.prom.before_ph`
- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)
- `res` is the object returned by the execution of `msg` 

## `.prom.before_pp`

_HTTP POST request handler, called before execution_

Syntax: `.prom.before_pp[msg]`

Where

- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)

returns a `tmp` object to be passed to the _after_ handler.

## `.prom.after_pp`

_HTTP POST request handler, called after execution_

Syntax: `.prom.after_pp[tmp;msg;res]`

Where

- `tmp` is the object returned by `.prom.before_pp`
- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)
- `res` is the object returned by the execution of `msg` 

## `.prom.before_ws`

_Websocket request handler, called before execution_

Syntax: `.prom.before_ws[msg]`

Where

- `msg` is the object to be executed 

returns a `tmp` object to be passed to the _after_ handler.

## `.prom.after_ws`

_Websocket request handler, called after execution_

Syntax: `.prom.after_ws[tmp;msg;res]`

Where

- `tmp` is the object returned by `.prom.before_ws`
- `msg` is the object that was executed
- `res` is the object returned by the execution of `msg` 

## `.prom.before_ts`

_Timer event handler, called before execution_

Syntax: `.prom.before_ts[dtm]`

Where

- `dtm` is the timestamp at the start of execution

returns a `tmp` object to be passed to the _after_ handler.

## `.prom.after_ts`

_Timer event handler, called after execution_

Syntax: `.prom.after_ts[tmp;dtm;res]`

Where

- `tmp` is the object returned by `.prom.before_ts`
- `dtm` is the timestamp at the start of execution
- `res` is the object returned by the execution of `dtm` 

