---
title: Using Prometheus Exporter for kdb+ – Interfaces
description: Prometheus Exporter for kdb+ metrics 
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
keywords: prometheus, grafana, monitoring, metrics, interface, fusion, exporter, visualisation, q
---
# ![Prometheus](../../img/prometheus.png) Prometheus Exporter for kdb+


<i class="fab fa-github"></i> [KxSystems/prometheus-kdb-exporter](https://github.com/KxSystems/prometheus-kdb-exporter)

## Introduction

Prometheus is free software which facilitates metric gathering, querying and alerting for a wealth of different 3rd party languages and applications. It also provides integration with Kubernetes for automatic discovery of supported applications.

Visualization and querying can be done through its built in expression browser, or more commonly via Grafana.

An  environment being administrated or analyzed by Prometheus will be able to include current and past metrics exposed by kdb+.

The purpose of this interface is to:

1. Provide a script that provides useful general metrics that can be extended if required
2. Allow correlations between different instances, metrics, exporters and installs to be easily identified

The following caveats should be made regarding where this interface in its current iteration can be used

1. This interface does not provide service discovery. Prometheus itself has support for multiple mechanisms such as DNS, Kubernetes, EC2, file based config, etc in order to discover all the kdb+ instances within your environment.
2. You may need to extend this script to provide more relevant metrics for your environment. Please consider contributing if your change may be generic enough to have a wider user benefit
3. General machine/kubernetes/cloud metrics on which kdb+ is running. Metrics can be gathered by such exporters as the node exporter. Metrics from multiple exporters can be correlated together to provide a bigger picture of your environment conditions.

### Example Use cases

The following are potential use cases for the interface, this is by no means an exhaustive list

- Effects from version upgrades (e.g. performance before/after changes)
- Alerts when your that a licence may be due to expire
- Bad use of symbol types within an instance
- Instances upon which garbage collection may be beneficial on long running processes

## Quick Start

Within the interface the script `exporter.q` is supplied. This contains a variety of metrics which can be monitored on an associated port. For example to expose the metrics on port 8080 run the following command

```q
q exporter.q -p 8080
```

Once running, you can use your web browser to view the currently exposed statistics on the metrics URL e.g. http://localhost:8080/metrics. The metrics exposed will be the current values from the time at which the URL is requested.

## Metrics

In Prometheus `metrics` refer to the statistics which are being monitored. By running the exporter above, you can view the metric endpoints in your web browser. Within prometheus there are a number of different forms of metric.

### Metric Types

There are [4 types of metric](https://prometheus.io/docs/concepts/metric_types/) in Prometheus

- counter
- gauge
- histogram
- summary

These are classified as either `Single-value` or `Sample` metrics

**Single-value metrics**

Both `counter` and `gauge` are single-value metrics, providing a number per instance.

When updating a single-value metric, a single number will be modified. On a request, this number will be reported directly as the metric value.

**Sample metrics**

Both `histogram` and `summary` are aggregate metrics, providing summary statistics (defined by the metric params) per instance.

When updating a sample metric, a list of numeric values will be appended to. On request, this list will be used to construct the metric values, depending on the metric type and params.

