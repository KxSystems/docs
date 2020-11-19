---
title: Function reference for the Prometheus Exporter | Interfaces | Documentation for kdb+ and q
author: Conor McCarthy
description: All functionality and options for the Prometheus Exporter for kdb+ metrics
date: April 2020
keywords: prometheus, grafana, monitoring, metrics, interface, fusion, exporter, visualisation, q
---
# Prometheus function reference

:fontawesome-brands-github:
[KxSystems/prometheus-kdb-exporter](https://github.com/KxSystems/prometheus-kdb-exporter)

<div markdown="1" class="typewriter">
.prom   **Prometheus Exporter interface**

Create metrics
  [addmetric](#promaddmetric)         Create a metric instance
  [newmetric](#promnewmetric)         Define a new metric class

Update metric values
  [updval](#promupdval)            Update a metric value

Initialize library
  [init](#prominit)              Initialize the library
</div>

Once the relevant event handlers have been defined to update the metric values, the library can by initialized with a call to `.prom.init`.

:fontawesome-regular-hand-point-right:
[Modify the behavior of event handlers that control the logic of metric updates](event-handlers.md)





## `.prom.addmetric`

_Create a metric instance_

Syntax: `.prom.addmetric[metric;labelvals;params;startval]`

Where

-   `metric` is a symbol denoting the metric class being used
-   `labelvals` are the values of labels used to differentiate metric characteristics as a symbol/list of symbols
-   `params` are the parameters relevant to the metric type as a list of floats
-   `startval` is a float denoting the starting value of the metric

returns identifier/s for the metric, to be used in future updates.

```q
q)// Tables
q)numtab1:.prom.addmetric[`number_tables;`amer;();0f]
q)numtab2:.prom.addmetric[`number_tables;`emea;();0f]
q)numtab3:.prom.addmetric[`number_tables;`apac;();0f]

q)// Updates
q)updsz:.prom.addmetric[`size_updates;();0.25 0.5 0.75;`float$()]
```

Once created, a metric will automatically be included in each HTTP response to a request from Prometheus.


## `.prom.init`

_Initialize metric monitoring_

Syntax: `.prom.init[]`

```q
q).prom.init[]
```

Updating `.z.*` handlers after the call to `.prom.init` will overwrite the Prometheus logic. 

!!! tip "Load all process logic before loading the Prometheus library."


## `.prom.newmetric`

_Define a metric class_

Syntax: `.prom.newmetric[metric;metrictype;labelnames;helptxt]`

Where

-   `metric` is a symbol denoting the name of the metric class
-   `metrictype` is a symbol outlining the type of metric
-   `labelnames` is a symbol or list of symbols denoting the names of labels used to differentiate metric characteristics
-   `helptxt` is a string providing the HELP text which is provided with the metric values

```q
q)// Tables
q).prom.newmetric[`number_tables;`gauge;`region;"number of tables"]

q)// Updates
q).prom.newmetric[`size_updates;`summary;();"size of updates"]
```


## `.prom.updval`

_Update a metric value_

Syntax: `.prom.updval[name;func;arg]`

Where

-   `name` is a symbol denoting the metric instance being updated
-   `func` is a function/operator used to update the value
-   `arg` is the second argument provided to `func` (the first argument being the value itself)

When updating a single-value metric (`counter` or `gauge`), the value will typically be incremented, decremented or assigned to. This value will be reported directly to Prometheus.

When updating a sample metric (`histogram` or `summary`), a list of numeric values will typically be appended to. This list will be aggregated to provide statistics to Prometheus according to the metric type and parameters provided.

```q
q)// Tables
q).prom.updval[`numtab1;:;count tables[]] // set
q).prom.updval[`numtab2;+;1]              // increment
q).prom.updval[`numtab3;-;1]              // decrement

q)// Updates
q).prom.updval[`updsz;,;10 15 20f]        // append
```


