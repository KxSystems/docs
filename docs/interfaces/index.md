---
title: Interfaces | kdb+ and q documentation
description: KX interfaces between kdb+ and other languages and services
---
# :fontawesome-regular-handshake: KX libraries


## :fontawesome-brands-superpowers: Fusion interfaces

Our Fusion interfaces are

-   written for non-q programmers to use
-   well documented, with understandable and useful examples
-   maintained and supported by KX on a best-efforts basis, at no cost to customers
-   released under the [Apache 2 license](https://www.apache.org/licenses/LICENSE-2.0)
-   free for all use cases, including 64-bit and commercial use

### Languages

<table class="kx-compact" markdown>
<tr markdown><td markdown>[csharpkdb](https://github.com/KxSystems/csharpkdb)</td><td markdown>Call kdb+ from **C#** and **.NET** [:fontawesome-regular-map:](../wp/gui/index.md "White paper: An introduction to graphical interfaces for kdb+ using C#")</td></tr>
<tr markdown><td markdown>[embedPy](https://github.com/KxSystems/embedPy)</td><td markdown>Call **Python** from q</td></tr>
<tr markdown><td markdown>[embedR](https://github.com/KxSystems/embedR)</td><td markdown>[Call **R** from q](r.md)</td></tr>
<tr markdown><td markdown>[ffi](https://github.com/KxSystems/ffi)</td><td markdown>[Call **C/C++** from q](using-c-functions.md)</td></tr>
<tr markdown><td markdown>[javakdb](https://github.com/KxSystems/javakdb)</td><td markdown>**Java** client for kdb+</td></tr>
<tr markdown><td markdown>[pykx](https://code.kx.com/pykx)</td><td markdown>Integrate **Python** and q code</td></tr>
<tr markdown><td markdown>[rkdb](https://github.com/KxSystems/rkdb)</td><td markdown>[Query kdb+ from **R**](r.md)</td></tr>
<tr markdown><td markdown>[kxkdb](https://github.com/KxSystems/kxkdb)</td><td markdown>Query kdb+ from **Rust**</td></tr>
</tr>
</table>


### Message and data formats

<table class="kx-compact" markdown>
<tr markdown><td markdown>[arrowkdb](https://github.com/KxSystems/arrowkdb)</td><td markdown>Read and write **Arrow** and **Parquet** data</td></tr>
<tr markdown><td markdown>[avrokdb](https://github.com/KxSystems/avrokdb)</td><td markdown>Read and write **Avro** data</td></tr>
<tr markdown><td markdown>[hdf5](https://github.com/KxSystems/hdf5)</td><td markdown>Read and write **HDF5** data</td></tr>
<tr markdown><td markdown>[jdbc](https://github.com/KxSystems/jdbc)</td><td markdown>**JDBC** driver for kdb+</td>
<tr markdown><td markdown>[kafka](https://github.com/KxSystems/kafka)</td><td markdown>Q client for **Apache Kafka**</td></tr>
<tr markdown><td markdown>[ldap](https://github.com/KxSystems/ldap)</td><td markdown>Q client for **LDAP**</td></tr>
<tr markdown><td markdown>[mqtt](https://github.com/KxSystems/mqtt)</td><td markdown>Q client for **MQTT** [:fontawesome-regular-map:](../wp/iot-mqtt/index.md "White paper: Internet of Things with MQTT")</td></tr>
<tr markdown><td markdown>[prometheus-kdb-exporter](https://github.com/KxSystems/prometheus-kdb-exporter)</td><td markdown>Export kdb+ metrics to **Prometheus**</td></tr>
<tr markdown><td markdown>[protobufkdb](https://github.com/KxSystems/protobufkdb)</td><td markdown>Read and write **Protocol Buffers** data</td></tr>
<tr markdown><td markdown>[solace](https://github.com/KxSystems/solace)</td><td markdown>Query kdb+ from a **Solace** event broker [:fontawesome-regular-map:](../wp/solace/index.md "White paper: Publish/subscribe with the Solace event broker")</td></tr>
</tr>
</table>


## Other repos maintained by KX

<table class="kx-compact" markdown>
<tr markdown><td markdown>[analyst-training](https://github.com/kxsystems/analyst-training)</td><td markdown>Learn [**KX Analyst**](https://code.kx.com/analyst/) and [**KX Developer**](https://code.kx.com/developer/)</td> </tr>
<tr markdown><td markdown>[automl](https://github.com/KxSystems/automl)</td><td markdown>[Automate machine learning in kdb+](../ml.md)</td></tr>
<tr markdown><td markdown>[cookbook](https://github.com/KxSystems/cookbook)</td><td markdown>Companion files to the Knowledge Base</td></tr>
<tr markdown><td markdown>[help](https://github.com/KxSystems/help)</td><td markdown>Online **help** for q</td></tr>
<tr markdown><td markdown>[insights-assemblies](https://github.com/KxSystems/insights-assemblies)</td><td markdown> Deploy assemblies for **KX Insights** ==new==</td></tr>
<tr markdown><td markdown>[jupyterq](https://github.com/KxSystems/jupyterq)</td><td markdown>**Jupyter** kernel for kdb+</td>
<tr markdown><td markdown>[kdb](https://github.com/KxSystems/kdb)</td><td markdown>Companion files to **kdb+**</td></tr>
<tr markdown><td markdown>[kdb-taq](https://github.com/KxSystems/kdb-taq)</td><td markdown>Processing **trade-and-quote** data</td></tr>
<tr markdown><td markdown>[kdb-tick](https://github.com/KxSystems/kdb-tick)</td><td markdown>[**Ticker**plant](../kb/kdb-tick.md)</td></tr>
<tr markdown><td markdown>[man](https://github.com/KxSystems/man)</td><td markdown>[man-style reference](../about/man.md)</td></tr>
<tr markdown><td markdown>[ml](https://github.com/KxSystems/ml)</td><td markdown>[**Machine Learning** Toolkit](../ml.md)</td></tr>
<tr markdown><td markdown>[mlnotebooks](https://github.com/KxSystems/mlnotebooks)</td><td markdown>Jupyter notebooks with ML examples</td></tr>
<tr markdown><td markdown>[nlp](https://github.com/KxSystems/nlp)</td><td markdown>[**Natural Language Processing** in q](../ml.md)</td></tr>
</tr>
</table>



!!! info "Interprocess communication"

	A kdb+ process can communicate with other processes through [TCP/IP](../basics/ipc.md), which is baked into the q language. 

:fontawesome-regular-hand-point-right: [General index](../github.md) of open-source repositories


