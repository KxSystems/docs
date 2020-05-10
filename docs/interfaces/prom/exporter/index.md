---
title: Using Prometheus Exporter for kdb+ – Interfaces
description: Prometheus Exporter for kdb+ metrics 
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
keywords: prometheus, grafana, monitoring, metrics, interface, fusion, exporter, visualisation, q
---
# ![Prometheus](../../img/prometheus.png) Prometheus Exporter for kdb+


<i class="fab fa-github"></i> [KxSystems/prometheus-kdb-exporter](https://github.com/KxSystems/prometheus-kdb-exporter)

## Introduction

[Prometheus](https://prometheus.io/docs/instrumenting/exporters/) is free software which facilitates metric gathering, querying and alerting for a wealth of different 3rd party languages and applications. It also provides integration with Kubernetes for automatic discovery of supported applications.

Visualization and querying can be done through its built in expression browser, or more commonly via [Grafana](https://grafana.com/).

An environment being administrated or analyzed by Prometheus will be able to include current and past metrics exposed by kdb+.

### Use-cases

The following are potential use cases for the interface, this is by no means an exhaustive list

- Effects from version upgrades (e.g. performance before/after changes).
- Alerts when your that a licence may be due to expire.
- Bad use of symbol types within an instance.

### kdb+/Prometheus-Exporter integration

The purpose of this interface is to:

1. Provide a script that provides useful general metrics that can be extended if required.
2. Allow correlations between different instances, metrics, exporters and installs to be easily identified.

The following caveats should be made regarding where this interface in its current iteration can be used

1. This interface does not provide service discovery. Prometheus itself has support for multiple mechanisms such as DNS, Kubernetes, EC2, file based config, etc in order to discover all the kdb+ instances within your environment.
2. You may need to extend this script to provide more relevant metrics for your environment. Please consider contributing if your change may be generic enough to have a wider user benefit.
3. General machine/kubernetes/cloud metrics on which kdb+ is running. Metrics can be gathered by such exporters as the node exporter. Metrics from multiple exporters can be correlated together to provide a bigger picture of your environment conditions.

### Metrics

In Prometheus `metrics` refer to the statistics which are being monitored. Within prometheus there are a number of different forms of metric, the exposure of these metrics from a kdb+ session allows for the monitoring a q process with Prometheus.

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

## Status

This interface is currently available as a beta version under an Apache 2.0 licence and is supported on a best effort basis by the Fusion team. This interface is currently in active development, with additional functionality to be released on an ongoing basis.

If you find issues with the interface or have feature requests please consider raising an issue [here](https://github.com/KxSystems/prometheus-kdb-exporter/issues). If you wish to contribute to this project please follow the contributing guide [here](https://github.com/KxSystems/prometheus-kdb-exporter/blob/master/CONTRIBUTING.md).
