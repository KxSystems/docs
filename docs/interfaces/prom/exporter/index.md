---
title: Prometheus Exporter | Interfaces | Documentation for kdb+ and q
description: Prometheus Exporter for kdb+ metrics 
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
keywords: prometheus, grafana, monitoring, metrics, interface, fusion, exporter, visualisation, q
---
# ![Prometheus](../../img/prometheus.png) Prometheus Exporter

:fontawesome-brands-github:
[KxSystems/prometheus-kdb-exporter](https://github.com/KxSystems/prometheus-kdb-exporter)



[Prometheus](https://prometheus.io/docs/instrumenting/exporters/) is free software which facilitates metric gathering, querying and alerting for a wealth of different third-party languages and applications. It also provides integration with Kubernetes for automatic discovery of supported applications.

Visualization and querying can be done through its built-in expression browser or, more commonly, via [Grafana](https://grafana.com/).

An environment being administered or analyzed by Prometheus can include current and past metrics exposed by kdb+.


## Use-cases

The following are potential use cases for the interface, this is by no means an exhaustive list

-   effects from version upgrades (e.g. performance before/after changes)
-   alerts when your that a licence may be due to expire
-   bad use of symbol types within an instance


## Kdb+/Prometheus-Exporter integration

This interface

-   provides a script for useful general metrics that can be extended if required
-   allows correlations between different instances, metrics, exporters and installs to be easily identified

Some caveats regarding where this interface in its current iteration can be used

-   This interface does not provide service discovery. Prometheus itself has support for multiple mechanisms such as DNS, Kubernetes, EC2, file based config, etc., to discover all the kdb+ instances within your environment.
-   You may need to extend this script to provide more relevant metrics for your environment. Please consider contributing if your change may be generic enough to have a wider user benefit.
-   General machine/Kubernetes/cloud metrics on which kdb+ is running. Metrics can be gathered by such exporters as the node exporter. Metrics from multiple exporters can be correlated to provide a bigger picture of your environment conditions.


## Metrics

In Prometheus _metrics_ refer to the statistics being monitored. Within Prometheus are different forms of metric. The exposure of these metrics from a kdb+ session allows for the monitoring a kdb+ process with Prometheus.

There are [four types of metric](https://prometheus.io/docs/concepts/metric_types/) in Prometheus:

```txt
counter
gauge
histogram
summary
```

These are classified as either _Single-value_ or _Sample_ metrics

Single-value metrics

: Both `counter` and `gauge` are single-value metrics, providing a number per instance.

: When updating a single-value metric, a single number will be modified. On a request, this number will be reported directly as the metric value.

Sample metrics

: Both `histogram` and `summary` are aggregate metrics, providing summary statistics (defined by the metric params) per instance.

: When updating a sample metric, a list of numeric values will be appended to. On request, this list will be used to construct the metric values, depending on the metric type and params.

## Status

The interface is currently available under an Apache 2.0 licence and is supported on a best-efforts basis by the Fusion team. The interface is currently in active development, with additional functionality to be released on an ongoing basis.

:fontawesome-brands-github: 
[Issues and feature requests](https://github.com/KxSystems/prometheus-kdb-exporter/issues) 

:fontawesome-brands-github: 
[Guide to contributing](https://github.com/KxSystems/prometheus-kdb-exporter/blob/master/CONTRIBUTING.md)
