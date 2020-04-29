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

Within the interface the script `exporter.q` is supplied. This contains a variety of metrics which can be monitored on an associated port. For example to expose the metrics on port 8080

```q
$q exporter.q -p 8080
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

## Example Demonstration

The demonstration described below uses [Docker Compose](https://docs.docker.com/compose/install/) to run an instance of Prometheus and [Grafana](https://grafana.com/) to gather and present them to a pre-configured interactive dashboard respectively.

This is intended as a simple and quick way to run an environment to demonstrate the use of this interface and is not a suggestion of how an environment should be run and maintained. It is not intended as a production ready example, only for demonstration and development.

### Requirements

This demonstration requires a Docker instance capable of running Unix based containers e.g. Docker Desktop for Mac, Linux, Windows 10 Pro (and above), with Internet access.

### Setup

Run kdb+ with the supplied `exporter.q` on the host upon which Docker is initialized. This will metrics over http that will be gathered by Prometheus configured within in the supplied demo

The following will expose the metrics on port 8080

```q
$q exporter.q -p 8080
```

Next we are required to initialize docker environment containing a single prometheus instance and a grafana dashboard. This accesses the kdb+ exporter from the local machine at port 8080. Please refer to the prometheus docs for using multiple targets and service discovery if wishing to use it for mulitple targets.

Initializing the docker environment varies for Linux/Mac vs Windows as outlined here

**Linux and Mac**
In order to run Prometheus and Grafana, enter the supplied DockerCompose directory and run

```bash
docker-compose up
```

Wait till images/etc downloaded and running. First time will take longer than subsequent times once images downloaded i.e. should take about a second to run if images have been downloaded previously.

When you have finished running the demo, ctrl-c in the running docker-compose and run

```bash
docker-compose-down
```

**Windows**
As above, but run

```bash
docker-compose -f docker-compose-win.yml up
```

and then the following when you wish to finish with the environment.

```bash
docker-compose -f docker-compose-win.yml down
```

### Example Resource Utilization

In order to show resources being consumed within the demo environment, we have supplied a q script that can connect to the q session being monitored and consumed resources (along with generating example errors).

The following script defaults to connecting to a remote q session on port 8080 (i.e. the q session being monitored above). To do this, run the following from the same machine.

```bash
q kdb_user_example.q
```

If the system is configured correctly, you should start to see the metrics changing within the Grafanas kdb+ dashboard after a few seconds.

### Accessing Prometheus and Grafana

After starting the environment, Prometheus and Grafana should be accessible from your web browser in the port mentioned in the docker-compose.yml these are defaulted as follows

- The Prometheus expression browser should be running on port 9090 e.g. http://localhost:9090 
- Grafana should be running on port 3000 e.g. http://localhost:3000 

!!!Note
	For the Grafana dashboard please use `admin` and `pass` as the username and password respectively

While in the Prometheus front-end, you can try executing a basic expression such as 'up' for the current status of monitored exporters. A '1' value should appear for your configured kdb+ instance(s) to indicate that Prometheus can reach the provided host, and it sees that kdb+ is running.

On logging into Grafana, a pre-configured dashboard called 'kdb+' should be available with example metrics being displayed from your kdb instance on port 8080. To find this, select 'Home'.

Once you are viewing the kdb+ dashboard, you can use the server drop down to select other configured kdb+ instances (if you have configured Prometheus to watch more than one instance).

Files contained with the grafana-config directory contain the defaults used for the data source and dashboards which may be altered or saved between invocations of the environment.

Example generated dashboard using the exposed metric data:

![Grafana_dash](../../img/grafana_kdb_example.png)
