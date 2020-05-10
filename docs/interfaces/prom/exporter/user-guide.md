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

The following functions are those exposed within the `.prom` namespace allowing users to interact augment metrics exposed to prometheus from a kdb+ interface. The functionality to modify the behaviour of event handlers which control the logic of metric updates is outlined [here](./event-handlers.md).

```txt
Prometheus Exporter Interface
  // Creating Metrics
  .prom.addmetric         Create a metric instance
  .prom.newmetric         Define a new metric class
  
  // Updating Metric Values
  .prom.updval            Update a metric value
  
  // Initialize library
  .prom.init              Initialize the library 
```

## Creating Metrics

The following functions relate to the creation and addition of new metrics which can be monitored by Prometheus.

### `.prom.addmetric`

_Create a metric instance_

Syntax: `.prom.addmetric[metric;labelvals;params;startval]`

Where

- `metric` is a symbol denoting the metric class being used.
- `labelvals` are the values of labels used to differentiate metric characteristics as a symbol/list of symbols.
- `params` are the parameters relevant to the metric type as a list of floats.
- `startval` is a float denoting the starting value of the metric.

returns an identifier(s) for the metric, to be used in future updates.

```q
// Tables
q)numtab1:.prom.addmetric[`number_tables;`amer;();0f]
q)numtab2:.prom.addmetric[`number_tables;`emea;();0f]
q)numtab3:.prom.addmetric[`number_tables;`apac;();0f]
// Updates
q)updsz:.prom.addmetric[`size_updates;();0.25 0.5 0.75;`float$()]
```
!!!Note
        Once created, a metric will automatically be included in each http response to a request from Prometheus.

### `.prom.newmetric`

_Define a metric class_

Syntax: `.prom.newmetric[metric;metrictype;labelnames;helptxt]`

Where

- `metric` is a symbol denoting the name of the metric class.
- `metrictype` is a symbol outlining the type of metric.
- `labelnames` is a symbol or list of symbols denoting the names of labels used to differentiate metric characteristics.
- `helptxt` is a string providing the HELP text which is provided with the metric values.

```q
// Tables
q).prom.newmetric[`number_tables;`gauge;`region;"number of tables"]
// Updates
q).prom.newmetric[`size_updates;`summary;();"size of updates"]
```

## Updating Metric Values

Metric values for an instance can be updated using `.prom.updval`.

### `.prom.updval`

_Update a metric value_

Syntax: `.prom.updval[name;func;arg]`

Where

- `name` is a symbol denoting the metric instance being updated.
- `func` is a function/operator used to update the value.
- `arg` is the second argument provided to `func` (the first argument being the value itself).

!!!Note
	* When updating a single-value metric (`counter` or `gauge`), the value will typically be incremented, decremented or assigned to. This value will be reported directly to Prometheus.
	* When updating a sample metric (`histogram` or `summary`), a list of numeric values will typically be appended to. This list will be aggregated to provide statistics to Prometheus according to the metric type and parameters provided.

```q
// Tables
q).prom.updval[`numtab1;:;count tables[]] // set
q).prom.updval[`numtab2;+;1]              // increment
q).prom.updval[`numtab3;-;1]              // decrement
// Updates
q).prom.updval[`updsz;,;10 15 20f]        // append
```

## Initialize library

Once the relevant event handlers have been defined to update the metric values, the library can by initialized with a call to `.prom.init`, the updating of event handler logic is described [here](event-handlers.md)

### `.prom.init`

_Initialize metric monitoring_

Syntax: `.prom.init[unused]`

```q
q).prom.init[]
```

!!!Note
        Updating `.z.*` handlers after the call to `.prom.init` will overwrite the Prometheus logic. Correct usage is to load all process logic before loading the Prometheus library.
