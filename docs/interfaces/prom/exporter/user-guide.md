---
title: Guide for using the Prometheus exporter with kdb+
author: Conor McCarthy
description: List all functionality and options for the Prometheus Exporter for kdb+ metrics 
date: April 2020
keywords: prometheus, grafana, monitoring, metrics, interface, fusion, exporter, visualisation, q
---
# <i class="fa fa-share-alt"></i> User guide 

<i class="fab fa-github"></i>
[KxSystems/prometheus-kdb-exporter](https://github.com/KxSystems/prometheus-kdb-exporter)

The following functions are those exposed within the `.prom` namespace allowing users to interact augment metrics exposed to prometheus from a kdb+ interface

```txt
Prometheus Exporter Interface
  // Creating Metrics
  .prom.newmetric         Define a new metric class
  .prom.addmetric         Create a metric instance
  
  // Updating Metric Values
  .prom.updval            Update a metric value
  
  // Event handlers responding to
  .prom.on_poll           Prometheus poll request
  .prom.on_pc             ipc socket connection closing
  .prom.on_po             ipc socket connection opening
  .prom.on_wc             Websocket connection closing
  .prom.on_wo             Websocket connection opening
  .prom.afer_pg           Syncronous ipc socket request handler, call after execution
  .prom.before_pg         Syncronous ipc socket request handler, call before execution
  .prom.after_ps          Asynchronous ipc socket request handler, call after execution
  .prom.before_ps         Asynchronous ipc socket request handler, call before execution
  .prom.after_ph          HTTP GET request handler, call after execution
  .prom.before_ph         HTTP GET request handler, call before execution
  .prom.after_pp          HTTP POST request handler, call after execution
  .prom.before_pp         HTTP POST request handler, call before execution
  .prom.after_ws          Websocket request handler, call after execution
  .prom.before_ws         Websocket request handler, call before execution
  .prom.after_ts          Timer event handler, call after execution
  .prom.before_ts         Timer event handler, call after execution
  
  // Initialize library
  .prom.init              Initialize the library 
```

## Creating Metrics

The following functions relate to the creation of new metrics which can be monitored by Prometheus.

### `.prom.newmetric`

_Define a metric class_

Syntax: `.prom.newmetric[metric;metrictype;labelnames;helptxt]`

Where

- `metric` is the name of the metric class (s)
- `metrictype` is the type of metric (s)
- `labelnames` are the names of labels used to differentiate metric characteristics (s|S)
- `helptxt` is the HELP text provided with the metric values (C)

Example

```
// Tables
q).prom.newmetric[`number_tables;`gauge;`region;"number of tables"]
// Updates
q).prom.newmetric[`size_updates;`summary;();"size of updates"]
```

### `.prom.addmetric`

_Create a metric instance_

Syntax: `.prom.addmetric[metric;labelvals;params;startval]`

Where

- `metric` is the metric class being used (s)
- `labelvals` are the values of labels used to differentiate metric characteristics (s|S)
- `params` are the parameters relevant to the metric type (F)
- `startval` is the starting value of the metric (f)

returning an identifier (s) for the metric, to be used in future updates.

Example

```
// Tables
q)numtab1:.prom.addmetric[`number_tables;`amer;();0f]
q)numtab2:.prom.addmetric[`number_tables;`emea;();0f]
q)numtab3:.prom.addmetric[`number_tables;`apac;();0f]
// Updates
q)updsz:.prom.addmetric[`size_updates;();0.25 0.5 0.75;`float$()]
```
!!!Note
	Once created, a metric will automatically be included in each http response to a request from Prometheus.

## Updating Metric Values

Metric values for an instance can be updated using `.prom.updval`.

### `.prom.updval`

_Update a metric value_

Syntax: `.prom.updval[name;func;arg]`

Where

- `name` is the metric instance being updated (s)
- `func` is the function/operator used to update the value
- `arg` is the second argument provided to `func` (the first argument being the value itself)

When updating a single-value metric (`counter` or `gauge`), the value will typically be incremented, decremented or assigned to. This value will be reported directly to Prometheus.

When updating a sample metric (`histogram` or `summary`), a list of numeric values will typically be appended to. This list will be aggregated to provide statistics to Prometheus according to the metric type and parameters provided.

Example

```
// Tables
q).prom.updval[numtab1;:;count tables[]] // set
q).prom.updval[numtab2;+;1]              // increment
q).prom.updval[numtab3;-;1]              // decrement
// Updates
q).prom.updval[updsz;,;10 15 20f]        // append
```

## Event handlers

Metric updates are generally carried out inside event handlers. By overwriting these handlers, users can update metric values in response to various triggers ranging from HTTP requests to timer events

### `.prom.on_poll`

_Prometheus poll request handler_

Syntax: `.prom.on_poll[msg]`

Where

- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)

### `.prom.on_po`

_Socket open handler_

Syntax: `.prom.on_po[hdl]`

Where

- `hdl` is the handle of the socket connection being opened

### `.prom.on_pc`

_Socket close handler_

Syntax: `.prom.on_pc[hdl]`

Where

- `hdl` is the handle of the socket connection being closed

### `.prom.before_pg`

_Synchronous ipc socket request handler, called before execution_

Syntax: `.prom.before_pg[msg]`

Where

- `msg` is the object to be executed 

returning a (tmp) object to be passed to the _after_ handler.

### `.prom.after_pg`

_Synchronous ipc socket request handler, called after execution_

Syntax: `.prom.after_pg[tmp;msg;res]`

Where

- `tmp` is the object returned by `.prom.before_pg`
- `msg` is the object that was executed
- `res` is the object returned by the execution of `msg` 

### `.prom.before_ps`

_Asynchronous ipc socket request handler, called before execution_

Syntax: `.prom.before_ps[msg]`

Where

- `msg` is the object to be executed 

returning a (tmp) object to be passed to the _after_ handler.

### `.prom.after_ps`

_Asynchronous ipc socket request handler, called after execution_

Syntax: `.prom.after_ps[tmp;msg;res]`

Where

- `tmp` is the object returned by `.prom.before_ps`
- `msg` is the object that was executed
- `res` is the object returned by the execution of `msg` 

### `.prom.before_ph`

_HTTP GET request handler, called before execution_

Syntax: `.prom.before_ph[msg]`

Where

- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)

returning a (`tmp`) object to be passed to the _after_ handler.

### `.prom.after_ph`

_HTTP GET request handler, called after execution_

Syntax: `.prom.after_ph[tmp;msg;res]`

Where

- `tmp` is the object returned by `.prom.before_ph`
- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)
- `res` is the object returned by the execution of `msg` 

### `.prom.before_pp`

_HTTP POST request handler, called before execution_

Syntax: `.prom.before_pp[msg]`

Where

- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)

returning a (`tmp`) object to be passed to the _after_ handler.

### `.prom.after_pp`

_HTTP POST request handler, called after execution_

Syntax: `.prom.after_pp[tmp;msg;res]`

Where

- `tmp` is the object returned by `.prom.before_pp`
- `msg` is the http request as a 2-item list (requestText;requestHeaderAsDictionary)
- `res` is the object returned by the execution of `msg` 

### `.prom.before_ws`

_Websocket request handler, called before execution_

Syntax: `.prom.before_ws[msg]`

Where

- `msg` is the object to be executed 

returning a (tmp) object to be passed to the _after_ handler.

### `.prom.after_ws`

_Websocket request handler, called after execution_

Syntax: `.prom.after_ws[tmp;msg;res]`

Where

- `tmp` is the object returned by `.prom.before_ws`
- `msg` is the object that was executed
- `res` is the object returned by the execution of `msg` 

### `.prom.before_ts`

_Timer event handler, called before execution_

Syntax: `.prom.before_ts[dtm]`

Where

- `dtm` is the timestamp at the start of execution

returning a (tmp) object to be passed to the _after_ handler.

### `.prom.after_ts`

_Timer event handler, called after execution_

Syntax: `.prom.after_ts[tmp;dtm;res]`

Where

- `tmp` is the object returned by `.prom.before_ts`
- `dtm` is the timestamp at the start of execution
- `res` is the object returned by the execution of `dtm` 

## Initialize library

Once the relevant event handlers have been defined to update the metric values, the library can by initialized with a call to `.prom.init`

```
q).prom.init[]
```

!!!Note
        Updating `.z.*` handlers after the call to `.prom.init` will overwrite the Prometheus logic. Correct usage is to load all process logic before loading the Prometheus library.
