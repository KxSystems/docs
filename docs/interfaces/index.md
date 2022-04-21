---
title: Interfaces and editor integrations | Interfaces | kdb+ and q documentation
description: Interfaces between kdb+ and other languages and services; also extensions to text editors for writing q code
keywords: editor, github, integration, interface, kdb+, q, repository
---
<span style="color: #009BAB; font-size: 2em">121</span><br><span style="font-size: .7em">interfaces &<br>connectors
{: style="border: 1px solid #009BAB; border-radius: 10px; float: right; line-height: 1.2em; margin: 0 1em 0 0; padding: 1em 1em .5em; text-align: center"}

# :fontawesome-regular-handshake: Interfaces and editor integrations



A kdb+ process can communicate with other processes through [TCP/IP](../basics/ipc.md), which is baked in to the q language. 



:fontawesome-regular-hand-point-right: [General index](../github.md) of other kdb+ repositories

Repositories at :fontawesome-brands-github: [KxSystems](https://github.com/KxSystems) are maintained and supported by KX. 
Other repositories are maintained by their owners. 

<div style="background-color: #efefef; border: 1px solid #005499; border-radius: 10px; display: inline-block; padding: 0 1em;" markdown>Please tell [librarian@kx.com](mailto:librarian@kx.com)
about new repositories.</div>


## :fontawesome-brands-superpowers: Fusion interfaces

The [Fusion interfaces](fusion.md) to kdb+ are

-   written for non-kdb+ programmers to use
-   well documented, with understandable and useful examples
-   maintained and supported by KX on a best-efforts basis, at no cost to customers
-   released under the [Apache 2 license](https://www.apache.org/licenses/LICENSE-2.0)
-   free for all use cases, including 64-bit and commercial use

<table class="kx-compact" markdown>
<tr markdown><td markdown>Arrow</td><td markdown>[Using Apache Arrow/Parquet data with kdb+](arrow/index.md)</td></tr>
<tr markdown><td markdown>FFI</td><td markdown>[Using foreign functions with kdb+](ffi/index.md)</td></tr>
<tr markdown><td markdown>HDF5</td><td markdown>[Handling HDF5 data with kdb+](hdf5/index.md)</td></tr>
<tr markdown><td markdown>Insights Assemblies</td><td markdown> [Deployment assemblies for KX Insights](https://github.com/KxSystems/insights-assemblies/) ==new==</td>
<tr markdown><td markdown>Java</td><td markdown> [Java client for kdb+](java-client-for-q.md)</td>
<tr markdown><td markdown>Jupyter</td><td markdown>[Jupyter kernel for kdb+](../ml/jupyterq/index.md) [:fontawesome-brands-superpowers:](../ml/index.md "Machine learning")</td>
<tr markdown><td markdown>Kafka</td><td markdown>[Q client for Kafka](kafka/index.md)</td></tr>
<tr markdown><td markdown>MQTT</td><td markdown>[Q client for MQTT](mqtt/index.md)</td></tr>
<tr markdown><td markdown>Prometheus-Exporter</td><td markdown>[Exporter of kdb+ metrics to Prometheus](prom/exporter/index.md)</td></tr>
<tr markdown><td markdown>Protobuf</td><td markdown>[Protobuf](protobuf/index.md)</td></tr>
<tr markdown><td markdown>LDAP</td><td markdown>[Q client for LDAP](ldap/index.md)</td></tr>
<tr markdown><td markdown>Python</td> <td markdown> [Using Python within kdb+ (embedPy)](../ml/embedpy/index.md) [:fontawesome-brands-superpowers:](../ml/ "Machine learning") </td></tr> 
<tr markdown><td markdown>R</td><td markdown>[Using R with kdb+](r/index.md)</td>
<tr markdown><td markdown>Solace</td><td markdown>[Interface to Solace PubSub+ broker](solace/index.md)</td></tr>
</tr>
</table>


## :fontawesome-solid-server: Kdb+ as server

<table class="kx-compact" markdown>
<tr markdown><td markdown>Adobe Flex</td><td markdown>:fontawesome-brands-github: [quantbin/kdb](https://github.com/quantbin/kdb)</td></tr>
<tr markdown><td markdown>Apache Spark</td><td markdown>:fontawesome-brands-github: [hughhyndman/kdbspark](https://github.com/hughhyndman/kdbspark)</td></tr>
<tr markdown>
<td markdown>ADO.Net</td>
<td markdown>
:fontawesome-brands-github: [ScottWeinstein/Linq2KdbQ](https://github.com/ScottWeinstein/Linq2KdbQ)<br/>
:fontawesome-brands-github: [sv/kp.net](https://github.com/sv/kp.net)
</td>
</tr>
<tr markdown><td markdown>amCharts</td><td markdown>:fontawesome-brands-github: [kxcontrib/cburke/amcharts](https://github.com/kxcontrib/cburke/tree/master/amcharts/)</td></tr>
<tr markdown><td markdown>AQuery</td><td markdown>:fontawesome-brands-github: [josepablocam/aquery](https://github.com/josepablocam/aquery)</td></tr>
<tr markdown><td markdown>C</td><td markdown>[C client for kdb+](c-client-for-q.md)</td></tr>
<tr markdown><td markdown>CZMQ</td><td markdown>:fontawesome-brands-github: [jaeheum/qzmq](https://github.com/jaeheum/qzmq)</i></td></tr>
<tr markdown><td markdown>C#</td><td markdown>[C# client for kdb+](csharp-client-for-q.md)<br/>
:fontawesome-brands-github: [exxeleron/qSharp](https://github.com/exxeleron/qSharp)</td></tr>
<tr markdown>
<td markdown>:fontawesome-brands-erlang: Erlang</td>
<td markdown>
:fontawesome-brands-github: [exxeleron/qErlang](https://github.com/exxeleron/qErlang/)<br/>
:fontawesome-brands-github: [republicwireless-open/gen_q](https://github.com/republicwireless-open/gen_q)<br/>
:fontawesome-brands-github: [michaelwittig/erlang-q](https://github.com/michaelwittig/erlang-q)
</td>
</tr>
<tr markdown>
<td markdown>:fontawesome-solid-table: Excel</td>
<td markdown>
[Excel client for kdb+](excel-client-for-q.md)<br/>
:fontawesome-brands-github: [exxeleron/qXL](https://github.com/exxeleron/qXL)<br/>
:fontawesome-brands-github: [CharlesSkelton/excelrtd](https://github.com/exxeleron/qXL)
</td>
</tr>
<tr markdown><td markdown>F#</td><td markdown>:fontawesome-brands-github: [kimtang/c.fs](https://github.com/kimtang/c.fs)</td></tr>
<tr markdown>
<td markdown>Go</td>
<td markdown>
:fontawesome-brands-github: [jshinonome/geek](https://github.com/jshinonome/geek) ==new==<br>
:fontawesome-brands-github: [sv/kdbgo](https://github.com/sv/kdbgo)
</td>
</tr>
<tr markdown>
<td markdown>Haskell</td>
<td markdown>
:fontawesome-brands-github: [carrutstick/hasq](https://github.com/carrutstick/hasq)<br/>
:fontawesome-brands-github: [jkozlowski/kdb-haskell](https://github.com/jkozlowski/kdb-haskell)
</td>
</tr>
<tr markdown><td markdown>J</td><td markdown>[J client for kdb+](j-client-for-q.md)</td></tr>
<tr markdown>
<td markdown>:fontawesome-brands-java: Java</td>
<td markdown>
:fontawesome-brands-github: [CharlesSkelton/jshow](https://github.com/CharlesSkelton/jshow)<br/>
:fontawesome-brands-github: [exxeleron/qJava](https://github.com/exxeleron/qJava)<br/>
:fontawesome-brands-github: [michaelwittig/java-q](https://github.com/michaelwittig/java-q)
</td>
</tr>
<tr markdown>
<td markdown>JDBC</td>
<td markdown>[JDBC client for kdb+](jdbc-client-for-kdb.md)</td>
</tr>
<tr markdown>
<td markdown>JavaScript</td>
<td markdown>
[WebSockets](../kb//websockets.md)<br/>
:fontawesome-brands-github: [KxSystems/kdb/c/c.js](https://github.com/KxSystems/kdb/blob/master/c/c.js)<br/>
:fontawesome-brands-github: [kxcontrib/cbutler/ChartsForKdb](https://github.com/kxcontrib/cbutler/tree/master/ChartsForKdb)<br/>
:fontawesome-brands-github: [MdSalih/Kdb-Stuff/IPCWebParse](https://github.com/MdSalih/Kdb-Stuff/tree/master/IPCWebParse)<br/>
:fontawesome-brands-github: [michaelwittig/java-q](https://github.com/michaelwittig/java-q)
</td>
</tr>
<tr markdown><td markdown>Lua</td><td markdown>:fontawesome-brands-github: [geocar/qlua](https://github.com/geocar/qlua)</td></tr>
<tr markdown>
<td markdown>Mathematica</td>
<td markdown>
:fontawesome-brands-github: [KxSystems/kdb/c/other/qmathematica.txt](https://github.com/KxSystems/kdb/blob/master/c/other/qmathematica.txt)
</td>
</tr>
<tr markdown><td markdown>Matlab</td>
<td markdown>
[Matlab client for kdb+](matlab-client-for-q.md)<br/>
:fontawesome-brands-github: [dmarienko/kdbml](https://github.com/dmarienko/kdbml)</td></tr>
<tr markdown><td markdown>NaCL</td><td markdown>:fontawesome-brands-github: [geocar/qsalt](https://github.com/geocar/qsalt)</td></tr>
<tr markdown>
<td markdown>:fontawesome-brands-node-js: NodeJS</td>
<td markdown>
:fontawesome-brands-github: [geocar/qnode](https://github.com/geocar/qnode)<br/>
:fontawesome-brands-github: [michaelwittig/node-q](https://github.com/michaelwittig/node-q)
</td>
</tr>
<tr markdown><td markdown>ODBC</td><td markdown>[Kdb+ server for ODBC3](q-server-for-odbc3.md)</td></tr>
<tr markdown>
<td markdown>Perl</td>
<td markdown>
:fontawesome-brands-github: [wjackson/anyevent-k](https://github.com/wjackson/anyevent-k)<br/>
:fontawesome-brands-github: [wjackson/k-perl](https://github.com/wjackson/k-perl)
</td>
</tr>
<tr markdown>
<td markdown>:fontawesome-brands-php: PHP</td>
<td markdown>
:fontawesome-brands-github: [geocar/qphp](https://github.com/geocar/qphp)<br/>
:fontawesome-brands-github: [johnanthonyludlow/kdb/docs/phptoq.pdf](https://github.com/johnanthonyludlow/kdb/blob/master/docs/phptoq.pdf)
</td>
</tr>
<tr markdown><td markdown>PLplot</td><td markdown>:fontawesome-brands-github: [jaeheum/qplplot](https://github.com/jaeheum/qplplot)</td></tr>
<tr markdown><td markdown>Postgres</td><td markdown>:fontawesome-brands-github: [hughhyndman/pgtokdb](https://github.com/hughhyndman/pgtokdb)</td></tr>
<tr markdown><td markdown>:fontawesome-brands-python: Python</td>
<td markdown>
[Using kdb+ within Python (PyQ)](pyq/index.md)<br/>
:fontawesome-brands-github: [brogar/pykdb](https://github.com/brogar/pykdb)<br/>
:fontawesome-brands-github: [enlnt/pyk](https://github.com/enlnt/pyk)<br/>
<!-- :fontawesome-brands-github: [enlnt/pyq](https://github.com/enlnt/pyq)<br/> -->
:fontawesome-brands-github: [eschnapp/q](https://github.com/eschnapp/q)<br/>
:fontawesome-brands-github: [nugend/q](https://github.com/nugend/q)<br/>
:fontawesome-brands-github: [nugend/qPython](https://github.com/nugend/qPython)<br/>
:fontawesome-brands-github: [exxeleron/qPython](https://github.com/exxeleron/qPython)
</td></tr>
<tr markdown><td markdown>:fontawesome-brands-r-project: R</td><td markdown>:fontawesome-brands-github: [yang-guo/qserver](https://github.com/yang-guo/qserver)</td></tr> 
<tr markdown>
<td markdown>:fontawesome-brands-rust: Rust</td>
<td markdown>
:fontawesome-brands-github: [adwhit/krust](https://github.com/adwhit/krust)<br/>
:fontawesome-brands-github: [jnordwick/rik](https://github.com/jnordwick/rik)<br/>
:fontawesome-brands-rust: [kdbplus](https://docs.rs/kdbplus/0.1.4/kdbplus/)
</td>
</tr>
<tr markdown><td markdown>Scala</td><td markdown>[Scala client for kdb+](scala-client-for-q.md)</td></tr>
</table>


## :fontawesome-regular-handshake: Kdb+ as client

<table class="kx-compact" markdown>
<tr markdown><td markdown>Betfair</td><td markdown>:fontawesome-brands-github: [picoDoc/betfair-data-capture](https://github.com/picoDoc/betfair-data-capture)</td></tr>
<tr markdown>
<td markdown>:fontawesome-brands-bitcoin: Bitcoin</td>
<td markdown>
:fontawesome-brands-github: [bitmx/btceQ](https://github.com/bitmx/btceQ)<br/>
:fontawesome-brands-github: [jlucid/qbitcoind](https://github.com/jlucid/qbitcoind)<br/>
:fontawesome-brands-github: [jlucid/qexplorer](https://github.com/jlucid/qexplorer)
</td>
</tr>
<tr markdown><td markdown>Bloomberg</td><td markdown>[Q client for Bloomberg](q-client-for-bloomberg.md)</td></tr>
<tr markdown><td markdown>[BosonNLP](https://bosonnlp.com)</td><td markdown>:fontawesome-brands-github: [FlyingOE/q_BosonNLP](https://github.com/FlyingOE/q_BosonNLP)</td></tr>
<tr markdown><td markdown>COMTRADE</td><td markdown>:fontawesome-brands-github: [diamondrod/q_comtrade](https://github.com/diamondrod/q_comtrade)</td></tr>
<tr markdown><td markdown>CUDA</td><td markdown>[GPUs](gpus.md)</td></tr>
<tr markdown><td markdown>Expat XML parser</td><td markdown>:fontawesome-brands-github: [felixlungu/qexpat](https://github.com/felixlungu/qexpat)</td></tr>
<tr markdown>
<td markdown>[Factom](https://www.factom.com/) blockchain</td>
<td markdown>
:fontawesome-brands-github: [jlucid/qfactom](https://github.com/jlucid/qfactom)<br/>
:fontawesome-brands-github: [jlucid/qfactomconnect](https://github.com/jlucid/qfactomconnect)
</td>
</tr>
<tr markdown><td markdown>ForexConnect</td><td markdown>:fontawesome-brands-github: [mortensorensen/qfxcm](https://github.com/mortensorensen/qfxcm)</td></tr>
<tr markdown><td markdown>[gRPC](https://grpc.io)</td><td markdown>:fontawesome-brands-github: [diamondrod/qrpc](https://github.com/diamondrod/qrpc) ==new==</td></tr>
<tr markdown><td markdown>Interactive Brokers</td><td markdown>:fontawesome-brands-github: [mortensorensen/QInteractiveBrokers](https://github.com/mortensorensen/QInteractiveBrokers)</td></tr>
<tr markdown><td markdown>[IEX](https://iextrading.com)</td><td markdown>:fontawesome-brands-github: [himoacs/iex_q](https://github.com/himoacs/iex_q)</td></tr>
<tr markdown><td markdown>J</td><td markdown>[Q client for J](q-client-for-j.md)</td></tr>
<tr markdown><td markdown>JDBC</td><td markdown>:fontawesome-brands-github: [CharlesSkelton/babel](https://github.com/CharlesSkelton/babel)</td></tr>
<tr markdown><td markdown>Kafka</td><td markdown>:fontawesome-brands-github: [ajayrathore/krak](https://github.com/ajayrathore/krak)</td></tr>
<tr markdown><td markdown>Lightning</td><td markdown>:fontawesome-brands-github: [jlucid/qlnd](https://github.com/jlucid/qlnd)</td></tr>
<tr markdown><td markdown>MQTT</td><td markdown>:fontawesome-brands-github: [himoacs/mqtt-q](https://github.com/himoacs/mqtt-q)</td></tr>
<tr markdown><td markdown>ODBC</td><td markdown>[Q client for ODBC](q-client-for-odbc.md)<br/>
:fontawesome-brands-github: [johnanthonyludlow/kdb/docs/odbc.pdf](https://github.com/johnanthonyludlow/kdb/blob/master/docs/odbc.pdf)</td></tr>
<tr markdown><td markdown>Philips Hue</td><td markdown>:fontawesome-brands-github: [jparmstrong/qphue](https://github.com/jparmstrong/qphue)</td></tr>
<tr markdown><td markdown>:fontawesome-brands-r-project: R</td><td markdown>[Using R with kdb+](r/r-and-q.md)</td></tr>
<tr markdown><td markdown>Reuters</td><td markdown>:fontawesome-brands-github: [KxSystems/kdb/c/feed/rfa.zip](https://github.com/KxSystems/kdb/blob/master/c/feed/rfa.zip)</td></tr>
<tr markdown><td markdown>TSE FLEX</td><td markdown>:fontawesome-brands-github: [Naoki-Yatsu/TSE-FLEX-Converter](https://github.com/Naoki-Yatsu/TSE-FLEX-Converter)</td></tr>
<tr markdown>
<td markdown> :fontawesome-brands-twitter: Twitter</td>
<td markdown>
:fontawesome-brands-github: [gartinian/kdbTwitter](https://github.com/gartinian/kdbTwitter)<br/>
:fontawesome-brands-github: [timeseries/twitter-kdb](https://github.com/timeseries/twitter-kdb)
</td>
</tr>
<tr markdown><td markdown>[Wind资讯](https://www.wind.com.cn/en/)</td><td markdown>:fontawesome-brands-github: [FlyingOE/q_Wind](https://github.com/FlyingOE/q_Wind)</td></tr>
<tr markdown><td markdown>:fontawesome-brands-yahoo: Yahoo!</td><td markdown>:fontawesome-brands-github: [fdeleze/tickYahoo](https://github.com/fdeleze/tickYahoo)</td></tr>
</table>



## :fontawesome-solid-map-signs: Foreign functions

<table class="kx-compact" markdown>
<tr markdown><td markdown>[Boost](https://www.boost.org) math library</td><td markdown>:fontawesome-brands-github: [kimtang/bml](https://github.com/kimtang/bml)</td></tr>
<tr markdown>
<td markdown>C/C++</td>
<td markdown>
[Using C/C++ functions](using-c-functions.md)<br/>
:fontawesome-brands-github: [enlnt/ffiq](https://github.com/enlnt/ffiq)<br/>
:fontawesome-brands-github: [felixlungu/c](https://github.com/felixlungu/c)
</td>
</tr>
<tr markdown><td markdown>Fortran</td><td markdown>:fontawesome-brands-github: [johnanthonyludlow/kdb/docs/fortran.pdf](https://github.com/kxcontrib/jludlow/blob/master/docs/fortran.pdf)</td></tr>
<tr markdown><td markdown>gnuplot</td><td markdown>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qgnuplot](https://github.com/kxcontrib/zuoqianxu/tree/master/qgnuplot)</td></tr>
<tr markdown><td markdown>Google Charts</td><td markdown>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qgooglechart](https://github.com/kxcontrib/zuoqianxu/tree/master/qgooglechart)</td></tr>
<tr markdown><td markdown>LAPACK, Cephes and FDLIBM</td><td markdown>[althenia.net/qml](http://althenia.net/qml)</td></tr>
<tr markdown><td markdown>Mathematica</td><td markdown>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qmathematica](https://github.com/kxcontrib/zuoqianxu/tree/master/qmathematica)</td></tr>
<tr markdown><td markdown>Matlab</td><td markdown>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qmatlab](https://github.com/kxcontrib/zuoqianxu/tree/master/qmatlab)</td></tr>
<tr markdown><td markdown>Perl</td><td markdown>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qperl](https://github.com/kxcontrib/zuoqianxu/tree/master/qperl)</td></tr>
<tr markdown><td markdown>:fontawesome-brands-python: Python</td><td markdown>
:fontawesome-brands-github: [kxcontrib/serpent.speak](https://github.com/kxcontrib/serpent.speak)<br/>
:fontawesome-brands-github: [kxcontrib/zuoqianxu/qpython](https://github.com/kxcontrib/zuoqianxu/tree/master/qpython)
</td></tr>
<tr markdown><td markdown>Non-linear least squares</td><td markdown>:fontawesome-brands-github: [brogar/nls](https://github.com/brogar/nls)</td></tr>
<tr markdown><td markdown>Regular Expressions</td><td markdown>[Regex libraries](../basics/regex.md#regex-libraries)</td></tr>
<tr markdown><td markdown>:fontawesome-brands-r-project: R</td><td markdown>:fontawesome-brands-github: [kimtang/rinit](https://github.com/kimtang/rinit)<br/>
:fontawesome-brands-github: [rwinston/kdb-rmathlib](https://github.com/rwinston/kdb-rmathlib)</td></tr>
<tr markdown>
<td markdown>Rust</td>
<td markdown>
:fontawesome-brands-github: [adwhit/krust](https://github.com/adwhit/krust)<br>
:fontawesome-brands-github: [redsift/rkdb](https://github.com/redsift/rkdb) ==new==<br>
:fontawesome-brands-github: [redsift/kdb-rs-hash](https://github.com/redsift/kdb-rs-hash) ==new==<br>
</td>
</tr>
<tr markdown><td markdown>TA-Lib</td><td markdown>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qtalib](https://github.com/kxcontrib/zuoqianxu/tree/master/qtalib)</td></tr>
<tr markdown><td markdown>ZeroMQ</td><td markdown>:fontawesome-brands-github: [wjackson/qzmq](https://github.com/wjackson/qzmq)</td></tr>
</table>


## :fontawesome-solid-plug: Editor integrations

<table class="kx-compact" markdown>
<tr markdown>
<td markdown>Atom</td>
<td markdown>
:fontawesome-brands-github: [derekwisong/atom-q](https://github.com/derekwisong/atom-q)<br/>
:fontawesome-brands-github: [quintanar401/atom-charts](https://github.com/quintanar401/atom-charts)<br/>
:fontawesome-brands-github: [quintanar401/connect-kdb-q](https://github.com/quintanar401/connect-kdb-q)
</td>
</tr>
<tr markdown><td markdown>Eclipse</td><td markdown>[qkdt.org](http://www.qkdt.org/features.html)</td></tr>
<tr markdown><td markdown>Emacs</td>
<td markdown>
:fontawesome-brands-github: [eepgwde/kdbp-mode](https://github.com/eepgwde/kdbp-mode)<br/>
:fontawesome-brands-github: [geocar/kq-mode](https://github.com/geocar/kq-mode)<br/>
:fontawesome-brands-github: [indiscible/emacs](https://github.com/indiscible/emacs)<br/>
:fontawesome-brands-github: [psaris/q-mode](https://github.com/psaris/q-mode)
</td>
</tr>
<tr markdown><td markdown>Evolved</td><td markdown>:fontawesome-brands-github: [simongarland/Syntaxhighlighter-for-q](https://github.com/simongarland/Syntaxhighlighter-for-q)</td></tr>
<tr markdown><td markdown>Heroku</td><td markdown>:fontawesome-brands-github: [gargraman/heroku-buildpack-kdb](https://github.com/gargraman/heroku-buildpack-kdb)</td></tr>
<tr markdown><td markdown>IntelliJ IDEA</td>
<td markdown>
:fontawesome-brands-github: [a2ndrade/k-intellij-plugin](https://github.com/a2ndrade/q-intellij-plugin)<br/>
:fontawesome-brands-github: [kdbinsidebrains/plugin](https://github.com/kdbinsidebrains/plugin) ==new==<br/>
:fontawesome-brands-gitlab: [shupakabras/kdb-intellij-plugin](https://gitlab.com/shupakabras/kdb-intellij-plugin) 
</td>
</tr>
<tr markdown><td markdown>Jupyter</td>
<td markdown>
:fontawesome-brands-github: [jvictorchen/IKdbQ](https://github.com/jvictorchen/IKdbQ)<br/>
:fontawesome-brands-github: [newtux/KdbQ_kernel](https://github.com/newtux/KdbQ_kernel)
</td></tr>
<tr markdown><td markdown>Linux, macOS, Unix</td><td markdown>:fontawesome-brands-github: [enlnt/kdb-magic](https://github.com/enlnt/kdb-magic)</td></tr>
<tr markdown><td markdown>Pygments</td><td markdown>:fontawesome-brands-github: [jasraj/q-pygments](https://github.com/jasraj/q-pygments)</td></tr>
<tr markdown>
<td markdown>Sublime Text</td>
<td markdown>
:fontawesome-brands-github: [smbody-mipt/kdb](https://github.com/smbody-mipt/kdb) <br/>
:fontawesome-brands-github: [kimtang/QStudio](https://github.com/kimtang/QStudio)<br/>
:fontawesome-brands-github: [kimtang/sublime-q](https://github.com/kimtang/sublime-q)<br/>
:fontawesome-brands-github: [kimtang/Q](https://github.com/kimtang/Q)<br/>
:fontawesome-brands-github: [komsit37/sublime-q](https://github.com/komsit37/sublime-q)
</td>
</tr>
<tr markdown>
<td markdown>TextMate</td><td markdown>:fontawesome-brands-github: [psaris/KX.tmbundle](https://github.com/psaris/KX.tmbundle) </td>
</tr>
<tr markdown>
<td markdown>vim</td>
<td markdown>
:fontawesome-brands-github: [katusk/vim-qkdb-syntax](https://github.com/katusk/vim-qkdb-syntax)<br/>
:fontawesome-brands-github: [patmok/qvim](https://github.com/patmok/qvim)<br/>
:fontawesome-brands-github: [simongarland/vim](https://github.com/simongarland/vim)
</td>
</tr>
<tr markdown>
<td markdown>Visual Studio Code</td>
<td markdown>
:fontawesome-brands-windows: [kdb+/q extension](https://marketplace.visualstudio.com/items?itemName=jshinonome.vscode-q)<br>
:fontawesome-brands-github: [lwshang/vscode-q](https://github.com/lwshang/vscode-q)
</td>
</tr>
<tr markdown>
<td markdown>:fontawesome-brands-wordpress: WordPress</td><td markdown>:fontawesome-brands-github: [simongarland/Syntaxhighlighter-for-q](https://github.com/simongarland/Syntaxhighlighter-for-q) </td>
</tr>
</table>


??? warning "Salvaged repositories in kxcontrib"

    :fontawesome-brands-github: [kxcontrib](https://github.com/kxcontrib) contains repositories salvaged from the former Subversion server for which we have been unable to identify current versions on GitHub. These repositories are not maintained. 

