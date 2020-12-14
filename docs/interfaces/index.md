---
title: Interfaces and editor integrations | Interfaces | kdb+ and q documentation
description: Interfaces between kdb+ and other languages and services; also extensions to text editors for writing q code
keywords: editor, github, integration, interface, kdb+, q, repository
---
# :fontawesome-regular-handshake: Interfaces and editor integrations



A kdb+ process can communicate with other processes through [TCP/IP](../basics/ipc.md), which is baked in to the q language. 



:fontawesome-regular-hand-point-right: [General index](../github.md) of other kdb+ repositories

Repositories at :fontawesome-brands-github: [KxSystems](https://github.com/KxSystems) are maintained and supported by Kx. 
Other repositories are maintained by their owners. 

<div style="background-color: #efefef; border: 1px solid #005499; border-radius: 10px; display: inline-block; padding: 0 1em;" markdown="1">Please tell [librarian@kx.com](mailto:librarian@kx.com)
about new repositories.</div>


## :fontawesome-brands-superpowers: Fusion interfaces

The [Fusion interfaces](fusion.md) to kdb+ are

-   written for non-kdb+ programmers to use
-   well documented, with understandable and useful examples
-   maintained and supported by Kx on a best-efforts basis, at no cost to customers
-   released under the [Apache 2 license](https://www.apache.org/licenses/LICENSE-2.0)
-   free for all use cases, including 64-bit and commercial use

<table class="kx-compact" markdown="1">
<tr markdown="1"><td markdown="1">FFI</td><td markdown="1">[Using foreign functions with kdb+](ffi.md)</td></tr>
<tr markdown="1"><td markdown="1">HDF5</td><td markdown="1">[Handling HDF5 data with kdb+](hdf5/index.md)</td></tr>
<tr markdown="1"><td markdown="1">Java</td><td markdown="1"> [Java client for kdb+](java-client-for-q.md)</td>
<tr markdown="1"><td markdown="1">Jupyter</td><td markdown="1">[Jupyter kernel for kdb+](../ml/jupyterq/index.md) [:fontawesome-brands-superpowers:](../ml/index.md "Machine learning") ==new==</td>
<tr markdown="1"><td markdown="1">Kafka</td><td markdown="1">[Q client for Kafka](kafka/index.md)</td></tr>
<tr markdown="1"><td markdown="1">MQTT</td><td markdown="1">[Q client for MQTT](mqtt/index.md)</td></tr>
<tr markdown="1"><td markdown="1">Prometheus-Exporter</td><td markdown="1">[Exporter of kdb+ metrics to Prometheus](prom/exporter/index.md)</td></tr>
<tr markdown="1"><td markdown="1">Protobuf</td><td markdown="1">[Protobuf](protobuf/index.md) ==new==</td></tr>
<tr markdown="1"><td markdown="1">LDAP</td><td markdown="1">[Q client for LDAP](ldap/index.md) ==new==</td></tr>
<tr markdown="1"><td markdown="1">Python</td>
    <td markdown="1">
</i> [Using kdb+ within Python (PyQ)](pyq/index.md)<br/>
[Using Python within kdb+ (embedPy)](../ml/embedpy/index.md) [:fontawesome-brands-superpowers:](../ml/ "Machine learning")
    </td></tr>
<tr markdown="1"><td markdown="1">R</td><td markdown="1">[Using R with kdb+](r/index.md)</td>
<tr markdown="1"><td markdown="1">Solace</td><td markdown="1">[Interface to Solace PubSub+ broker](solace/index.md)</td></tr>
</tr>
</table>


## :fontawesome-solid-server: Kdb+ as server

<table class="kx-compact" markdown="1">
<tr markdown="1"><td markdown="1">Adobe Flex</td><td markdown="1">:fontawesome-brands-github: [quantbin/kdb](https://github.com/quantbin/kdb)</td></tr>
<tr markdown="1"><td markdown="1">Apache Spark</td><td markdown="1">:fontawesome-brands-github: [hughhyndman/kdbspark](https://github.com/hughhyndman/kdbspark) ==new==</td></tr>
<tr markdown="1">
<td markdown="1">ADO.Net</td>
<td markdown="1">
:fontawesome-brands-github: [ScottWeinstein/Linq2KdbQ](https://github.com/ScottWeinstein/Linq2KdbQ)<br/>
:fontawesome-brands-github: [sv/kp.net](https://github.com/sv/kp.net)
</td>
</tr>
<tr markdown="1"><td markdown="1">amCharts</td><td markdown="1">:fontawesome-brands-github: [kxcontrib/cburke/amcharts](https://github.com/kxcontrib/cburke/tree/master/amcharts/)</td></tr>
<tr markdown="1"><td markdown="1">AQuery</td><td markdown="1">:fontawesome-brands-github: [josepablocam/aquery](https://github.com/josepablocam/aquery)</td></tr>
<tr markdown="1"><td markdown="1">C</td><td markdown="1">[C client for kdb+](c-client-for-q.md)</td></tr>
<tr markdown="1"><td markdown="1">CZMQ</td><td markdown="1">:fontawesome-brands-github: [jaeheum/qzmq](https://github.com/jaeheum/qzmq)</i></td></tr>
<tr markdown="1"><td markdown="1">C#</td><td markdown="1">[C# client for kdb+](csharp-client-for-q.md)<br/>
:fontawesome-brands-github: [exxeleron/qSharp](https://github.com/exxeleron/qSharp)</td></tr>
<tr markdown="1">
<td markdown="1">:fontawesome-brands-erlang: Erlang</td>
<td markdown="1">
:fontawesome-brands-github: [exxeleron/qErlang](https://github.com/exxeleron/qErlang/)<br/>
:fontawesome-brands-github: [republicwireless-open/gen_q](https://github.com/republicwireless-open/gen_q)<br/>
:fontawesome-brands-github: [michaelwittig/erlang-q](https://github.com/michaelwittig/erlang-q)
</td>
</tr>
<tr markdown="1">
<td markdown="1">:fontawesome-solid-table: Excel</td>
<td markdown="1">
[Excel client for kdb+](excel-client-for-q.md)<br/>
:fontawesome-brands-github: [exxeleron/qXL](https://github.com/exxeleron/qXL)<br/>
:fontawesome-brands-github: [CharlesSkelton/excelrtd](https://github.com/exxeleron/qXL)
</td>
</tr>
<tr markdown="1"><td markdown="1">F#</td><td markdown="1">:fontawesome-brands-github: [kimtang/c.fs](https://github.com/kimtang/c.fs)</td></tr>
<tr markdown="1"><td markdown="1">Go</td><td markdown="1">:fontawesome-brands-github: [sv/kdbgo](https://github.com/sv/kdbgo)</td></tr>
<tr markdown="1">
<td markdown="1">Haskell</td>
<td markdown="1">
:fontawesome-brands-github: [carrutstick/hasq](https://github.com/carrutstick/hasq)<br/>
:fontawesome-brands-github: [jkozlowski/kdb-haskell](https://github.com/jkozlowski/kdb-haskell)
</td>
</tr>
<tr markdown="1"><td markdown="1">J</td><td markdown="1">[J client for kdb+](j-client-for-q.md)</td></tr>
<tr markdown="1">
<td markdown="1">:fontawesome-brands-java: Java</td>
<td markdown="1">
:fontawesome-brands-github: [CharlesSkelton/jshow](https://github.com/CharlesSkelton/jshow)<br/>
:fontawesome-brands-github: [exxeleron/qJava](https://github.com/exxeleron/qJava)<br/>
:fontawesome-brands-github: [michaelwittig/java-q](https://github.com/michaelwittig/java-q)
</td>
</tr>
<tr markdown="1">
<td markdown="1">JDBC</td>
<td markdown="1">[JDBC client for kdb+](jdbc-client-for-kdb.md)</td>
</tr>
<tr markdown="1">
<td markdown="1">JavaScript</td>
<td markdown="1">
[WebSockets](../kb//websockets.md)<br/>
:fontawesome-brands-github: [KxSystems/kdb/c/c.js](https://github.com/KxSystems/kdb/blob/master/c/c.js)<br/>
:fontawesome-brands-github: [kxcontrib/cbutler/ChartsForKdb](https://github.com/kxcontrib/cbutler/tree/master/ChartsForKdb)<br/>
:fontawesome-brands-github: [MdSalih/Kdb-Stuff/IPCWebParse](https://github.com/MdSalih/Kdb-Stuff/tree/master/IPCWebParse)<br/>
:fontawesome-brands-github: [michaelwittig/java-q](https://github.com/michaelwittig/java-q)
</td>
</tr>
<tr markdown="1"><td markdown="1">Lua</td><td markdown="1">:fontawesome-brands-github: [geocar/qlua](https://github.com/geocar/qlua)</td></tr>
<tr markdown="1">
<td markdown="1">Mathematica</td>
<td markdown="1">
:fontawesome-brands-github: [KxSystems/kdb/c/other/qmathematica.txt](https://github.com/KxSystems/kdb/blob/master/c/other/qmathematica.txt)
</td>
</tr>
<tr markdown="1"><td markdown="1">Matlab</td>
<td markdown="1">
[Matlab client for kdb+](matlab-client-for-q.md)<br/>
:fontawesome-brands-github: [dmarienko/kdbml](https://github.com/dmarienko/kdbml)</td></tr>
<tr markdown="1"><td markdown="1">NaCL</td><td markdown="1">:fontawesome-brands-github: [geocar/qsalt](https://github.com/geocar/qsalt)</td></tr>
<tr markdown="1">
<td markdown="1">:fontawesome-brands-node-js: NodeJS</td>
<td markdown="1">
:fontawesome-brands-github: [geocar/qnode](https://github.com/geocar/qnode)<br/>
:fontawesome-brands-github: [michaelwittig/node-q](https://github.com/michaelwittig/node-q)
</td>
</tr>
<tr markdown="1"><td markdown="1">ODBC</td><td markdown="1">[Kdb+ server for ODBC](q-server-for-odbc.md)<br/>
[Kdb+ server for ODBC3](q-server-for-odbc3.md)</td></tr>
<tr markdown="1">
<td markdown="1">Perl</td>
<td markdown="1">
[Perl client for kdb+](perl-client-for-q.md)<br/>
:fontawesome-brands-github: [wjackson/anyevent-k](https://github.com/wjackson/anyevent-k)<br/>
:fontawesome-brands-github: [wjackson/k-perl](https://github.com/wjackson/k-perl)
</td>
</tr>
<tr markdown="1">
<td markdown="1">:fontawesome-brands-php: PHP</td>
<td markdown="1">
:fontawesome-brands-github: [geocar/qphp](https://github.com/geocar/qphp)<br/>
:fontawesome-brands-github: [johnanthonyludlow/kdb/docs/phptoq.pdf](https://github.com/johnanthonyludlow/kdb/blob/master/docs/phptoq.pdf)
</td>
</tr>
<tr markdown="1"><td markdown="1">PLplot</td><td markdown="1">:fontawesome-brands-github: [jaeheum/qplplot](https://github.com/jaeheum/qplplot)</td></tr>
<tr markdown="1"><td markdown="1">Postgres</td><td markdown="1">:fontawesome-brands-github: [hughhyndman/pgtokdb](https://github.com/hughhyndman/pgtokdb)</td></tr>
<tr markdown="1"><td markdown="1">:fontawesome-brands-python: Python</td>
<td markdown="1">
:fontawesome-brands-github: [brogar/pykdb](https://github.com/brogar/pykdb)<br/>
:fontawesome-brands-github: [enlnt/pyk](https://github.com/enlnt/pyk)<br/>
<!-- :fontawesome-brands-github: [enlnt/pyq](https://github.com/enlnt/pyq)<br/> -->
:fontawesome-brands-github: [eschnapp/q](https://github.com/eschnapp/q)<br/>
:fontawesome-brands-github: [nugend/q](https://github.com/nugend/q)<br/>
:fontawesome-brands-github: [nugend/qPython](https://github.com/nugend/qPython)<br/>
:fontawesome-brands-github: [exxeleron/qPython](https://github.com/exxeleron/qPython)<br/>
:fontawesome-brands-github: [kingan/mongodb_kdb_python_connection](https://github.com/kingan/mongodb_kdb_python_connection)
</td></tr>
<tr markdown="1"><td markdown="1">:fontawesome-brands-r-project: R</td><td markdown="1">:fontawesome-brands-github: [yang-guo/qserver](https://github.com/yang-guo/qserver)</td></tr> 
<tr markdown="1">
<td markdown="1">Rust</td>
<td markdown="1">
:fontawesome-brands-github: [adwhit/krust](https://github.com/adwhit/krust)<br/>
:fontawesome-brands-github: [jnordwick/rik](https://github.com/jnordwick/rik)
</td>
</tr>
<tr markdown="1"><td markdown="1">Scala</td><td markdown="1">[Scala client for kdb+](scala-client-for-q.md)</td></tr>
</table>


## :fontawesome-regular-handshake: Kdb+ as client

<table class="kx-compact" markdown="1">
<tr markdown="1"><td markdown="1">Betfair</td><td markdown="1">:fontawesome-brands-github: [picoDoc/betfair-data-capture](https://github.com/picoDoc/betfair-data-capture)</td></tr>
<tr markdown="1">
<td markdown="1">:fontawesome-brands-bitcoin: Bitcoin</td>
<td markdown="1">
:fontawesome-brands-github: [bitmx/btceQ](https://github.com/bitmx/btceQ)<br/>
:fontawesome-brands-github: [jlucid/qbitcoind](https://github.com/jlucid/qbitcoind)<br/>
:fontawesome-brands-github: [jlucid/qexplorer](https://github.com/jlucid/qexplorer)
</td>
</tr>
<tr markdown="1"><td markdown="1">Bloomberg</td><td markdown="1">[Q client for Bloomberg](q-client-for-bloomberg.md)</td></tr>
<tr markdown="1"><td markdown="1">[BosonNLP](https://bosonnlp.com)</td><td markdown="1">:fontawesome-brands-github: [FlyingOE/q_BosonNLP](https://github.com/FlyingOE/q_BosonNLP)</td></tr>
<tr markdown="1"><td markdown="1">CUDA</td><td markdown="1">[GPUs](gpus.md)</td></tr>
<tr markdown="1"><td markdown="1">Expat XML parser</td><td markdown="1">:fontawesome-brands-github: [felixlungu/qexpat](https://github.com/felixlungu/qexpat)</td></tr>
<tr markdown="1">
<td markdown="1">[Factom](https://www.factom.com/) blockchain</td>
<td markdown="1">
:fontawesome-brands-github: [jlucid/qfactom](https://github.com/jlucid/qfactom)<br/>
:fontawesome-brands-github: [jlucid/qfactomconnect](https://github.com/jlucid/qfactomconnect)
</td>
</tr>
<tr markdown="1"><td markdown="1">ForexConnect</td><td markdown="1">:fontawesome-brands-github: [mortensorensen/qfxcm](https://github.com/mortensorensen/qfxcm)</td></tr>
<tr markdown="1"><td markdown="1">Interactive Brokers</td><td markdown="1">:fontawesome-brands-github: [mortensorensen/QInteractiveBrokers](https://github.com/mortensorensen/QInteractiveBrokers)</td></tr>
<tr markdown="1"><td markdown="1">[IEX](https://iextrading.com)</td><td markdown="1">:fontawesome-brands-github: [himoacs/iex_q](https://github.com/himoacs/iex_q)</td></tr>
<tr markdown="1"><td markdown="1">J</td><td markdown="1">[Q client for J](q-client-for-j.md)</td></tr>
<tr markdown="1"><td markdown="1">JDBC</td><td markdown="1">:fontawesome-brands-github: [CharlesSkelton/babel](https://github.com/CharlesSkelton/babel)</td></tr>
<tr markdown="1"><td markdown="1">Kafka</td><td markdown="1">:fontawesome-brands-github: [ajayrathore/krak](https://github.com/ajayrathore/krak) ==new==</td></tr>
<tr markdown="1"><td markdown="1">Lightning</td><td markdown="1">:fontawesome-brands-github: [jlucid/qlnd](https://github.com/jlucid/qlnd)</td></tr>
<tr markdown="1"><td markdown="1">MQTT</td><td markdown="1">:fontawesome-brands-github: [himoacs/mqtt-q](https://github.com/himoacs/mqtt-q)</td></tr>
<tr markdown="1"><td markdown="1">ODBC</td><td markdown="1">[Q client for ODBC](q-client-for-odbc.md)<br/>
:fontawesome-brands-github: [johnanthonyludlow/kdb/docs/odbc.pdf](https://github.com/johnanthonyludlow/kdb/blob/master/docs/odbc.pdf)</td></tr>
<tr markdown="1"><td markdown="1">Philips Hue</td><td markdown="1">:fontawesome-brands-github: [jparmstrong/qphue](https://github.com/jparmstrong/qphue)</td></tr>
<tr markdown="1"><td markdown="1">:fontawesome-brands-r-project: R</td><td markdown="1">[Using R with kdb+](r/r-and-q.md)</td></tr>
<tr markdown="1"><td markdown="1">Reuters</td><td markdown="1">:fontawesome-brands-github: [KxSystems/kdb/c/feed/rfa.zip](https://github.com/KxSystems/kdb/blob/master/c/feed/rfa.zip)</td></tr>
<tr markdown="1"><td markdown="1">TSE FLEX</td><td markdown="1">:fontawesome-brands-github: [Naoki-Yatsu/TSE-FLEX-Converter](https://github.com/Naoki-Yatsu/TSE-FLEX-Converter)</td></tr>
<tr markdown="1">
<td markdown="1"> :fontawesome-brands-twitter: Twitter</td>
<td markdown="1">
:fontawesome-brands-github: [gartinian/kdbTwitter](https://github.com/gartinian/kdbTwitter)<br/>
:fontawesome-brands-github: [timeseries/twitter-kdb](https://github.com/timeseries/twitter-kdb)
</td>
</tr>
<tr markdown="1"><td markdown="1">[Wind资讯](https://www.wind.com.cn/en/)</td><td markdown="1">:fontawesome-brands-github: [FlyingOE/q_Wind](https://github.com/FlyingOE/q_Wind)</td></tr>
<tr markdown="1"><td markdown="1">:fontawesome-brands-yahoo: Yahoo!</td><td markdown="1">:fontawesome-brands-github: [fdeleze/tickYahoo](https://github.com/fdeleze/tickYahoo)</td></tr>
</table>



## :fontawesome-solid-map-signs: Foreign functions 

<table class="kx-compact" markdown="1">
<tr markdown="1"><td markdown="1">[Boost](https://www.boost.org) math library</td><td markdown="1">:fontawesome-brands-github: [kimtang/bml](https://github.com/kimtang/bml)</td></tr>
<tr markdown="1">
<td markdown="1">C/C++</td>
<td markdown="1">
[Using C/C++ functions](using-c-functions.md)<br/>
:fontawesome-brands-github: [enlnt/ffiq](https://github.com/enlnt/ffiq)<br/>
:fontawesome-brands-github: [felixlungu/c](https://github.com/felixlungu/c)
</td>
</tr>
<tr markdown="1"><td markdown="1">Fortran</td><td markdown="1">:fontawesome-brands-github: [johnanthonyludlow/kdb/docs/fortran.pdf](https://github.com/kxcontrib/jludlow/blob/master/docs/fortran.pdf)</td></tr>
<tr markdown="1"><td markdown="1">gnuplot</td><td markdown="1">:fontawesome-brands-github: [kxcontrib/zuoqianxu/qgnuplot](https://github.com/kxcontrib/zuoqianxu/tree/master/qgnuplot)</td></tr>
<tr markdown="1"><td markdown="1">Google Charts</td><td markdown="1">:fontawesome-brands-github: [kxcontrib/zuoqianxu/qgooglechart](https://github.com/kxcontrib/zuoqianxu/tree/master/qgooglechart)</td></tr>
<tr markdown="1"><td markdown="1">LAPACK, Cephes and FDLIBM</td><td markdown="1">[althenia.net/qml](http://althenia.net/qml)</td></tr>
<tr markdown="1"><td markdown="1">Mathematica</td><td markdown="1">:fontawesome-brands-github: [kxcontrib/zuoqianxu/qmathematica](https://github.com/kxcontrib/zuoqianxu/tree/master/qmathematica)</td></tr>
<tr markdown="1"><td markdown="1">Matlab</td><td markdown="1">:fontawesome-brands-github: [kxcontrib/zuoqianxu/qmatlab](https://github.com/kxcontrib/zuoqianxu/tree/master/qmatlab)</td></tr>
<tr markdown="1"><td markdown="1">Perl</td><td markdown="1">:fontawesome-brands-github: [kxcontrib/zuoqianxu/qperl](https://github.com/kxcontrib/zuoqianxu/tree/master/qperl)</td></tr>
<tr markdown="1"><td markdown="1">:fontawesome-brands-python: Python</td><td markdown="1">
:fontawesome-brands-github: [kxcontrib/serpent.speak](https://github.com/kxcontrib/serpent.speak)<br/>
:fontawesome-brands-github: [kxcontrib/zuoqianxu/qpython](https://github.com/kxcontrib/zuoqianxu/tree/master/qpython)
</td></tr>
<tr markdown="1"><td markdown="1">Non-linear least squares</td><td markdown="1">:fontawesome-brands-github: [brogar/nls](https://github.com/brogar/nls)</td></tr>
<tr markdown="1"><td markdown="1">Regular Expressions</td><td markdown="1">[Regex libraries](../basics/regex.md#regex-libraries)</td></tr>
<tr markdown="1"><td markdown="1">:fontawesome-brands-r-project: R</td><td markdown="1">:fontawesome-brands-github: [kimtang/rinit](https://github.com/kimtang/rinit)<br/>
:fontawesome-brands-github: [rwinston/kdb-rmathlib](https://github.com/rwinston/kdb-rmathlib)</td></tr>
<tr markdown="1">
<td markdown="1">Rust</td>
<td markdown="1">
:fontawesome-brands-github: [adwhit/krust](https://github.com/adwhit/krust)<br>
:fontawesome-brands-github: [redsift/rkdb](https://github.com/redsift/rkdb) ==new==<br>
:fontawesome-brands-github: [redsift/kdb-rs-hash](https://github.com/redsift/kdb-rs-hash) ==new==<br>
</td>
</tr>
<tr markdown="1"><td markdown="1">TA-Lib</td><td markdown="1">:fontawesome-brands-github: [kxcontrib/zuoqianxu/qtalib](https://github.com/kxcontrib/zuoqianxu/tree/master/qtalib)</td></tr>
<tr markdown="1"><td markdown="1">ZeroMQ</td><td markdown="1">:fontawesome-brands-github: [wjackson/qzmq](https://github.com/wjackson/qzmq)</td></tr>
</table>


## :fontawesome-solid-plug: Editor integrations

<table class="kx-compact" markdown="1">
<tr markdown="1">
<td markdown="1">Atom</td>
<td markdown="1">
:fontawesome-brands-github: [derekwisong/atom-q](https://github.com/derekwisong/atom-q)<br/>
:fontawesome-brands-github: [quintanar401/atom-charts](https://github.com/quintanar401/atom-charts)<br/>
:fontawesome-brands-github: [quintanar401/connect-kdb-q](https://github.com/quintanar401/connect-kdb-q)
</td>
</tr>
<tr markdown="1"><td markdown="1">Eclipse</td><td markdown="1">[qkdt.org](http://www.qkdt.org/features.html)</td></tr>
<tr markdown="1"><td markdown="1">Emacs</td>
<td markdown="1">
:fontawesome-brands-github: [eepgwde/kdbp-mode](https://github.com/eepgwde/kdbp-mode)<br/>
:fontawesome-brands-github: [geocar/kq-mode](https://github.com/geocar/kq-mode)<br/>
:fontawesome-brands-github: [indiscible/emacs](https://github.com/indiscible/emacs)<br/>
:fontawesome-brands-github: [psaris/q-mode](https://github.com/psaris/q-mode)
</td>
</tr>
<tr markdown="1"><td markdown="1">Evolved</td><td markdown="1">:fontawesome-brands-github: [simongarland/Syntaxhighlighter-for-q](https://github.com/simongarland/Syntaxhighlighter-for-q)</td></tr>
<tr markdown="1"><td markdown="1">Heroku</td><td markdown="1">:fontawesome-brands-github: [gargraman/heroku-buildpack-kdb](https://github.com/gargraman/heroku-buildpack-kdb)</td></tr>
<tr markdown="1"><td markdown="1">IntelliJ IDEA</td>
<td markdown="1">
:fontawesome-brands-github: [a2ndrade/k-intellij-plugin](https://github.com/a2ndrade/q-intellij-plugin)<br/>
:fontawesome-brands-gitlab: [shupakabras/kdb-intellij-plugin](https://gitlab.com/shupakabras/kdb-intellij-plugin) 
</td>
</tr>
<tr markdown="1"><td markdown="1">Jupyter</td>
<td markdown="1">
:fontawesome-brands-github: [jvictorchen/IKdbQ](https://github.com/jvictorchen/IKdbQ)<br/>
:fontawesome-brands-github: [newtux/KdbQ_kernel](https://github.com/newtux/KdbQ_kernel)
</td></tr>
<tr markdown="1"><td markdown="1">Linux, macOS, Unix</td><td markdown="1">:fontawesome-brands-github: [enlnt/kdb-magic](https://github.com/enlnt/kdb-magic)</td></tr>
<tr markdown="1"><td markdown="1">Pygments</td><td markdown="1">:fontawesome-brands-github: [jasraj/q-pygments](https://github.com/jasraj/q-pygments)</td></tr>
<tr markdown="1">
<td markdown="1">Sublime Text</td>
<td markdown="1">
:fontawesome-brands-github: [smbody-mipt/kdb](https://github.com/smbody-mipt/kdb) <br/>
:fontawesome-brands-github: [kimtang/QStudio](https://github.com/kimtang/QStudio)<br/>
:fontawesome-brands-github: [kimtang/sublime-q](https://github.com/kimtang/sublime-q)<br/>
:fontawesome-brands-github: [kimtang/Q](https://github.com/kimtang/Q)<br/>
:fontawesome-brands-github: [komsit37/sublime-q](https://github.com/komsit37/sublime-q)
</td>
</tr>
<tr markdown="1">
<td markdown="1">TextMate</td><td markdown="1">:fontawesome-brands-github: [psaris/KX.tmbundle](https://github.com/psaris/KX.tmbundle) </td>
</tr>
<tr markdown="1">
<td markdown="1">vim</td>
<td markdown="1">
:fontawesome-brands-github: [katusk/vim-qkdb-syntax](https://github.com/katusk/vim-qkdb-syntax)<br/>
:fontawesome-brands-github: [patmok/qvim](https://github.com/patmok/qvim)<br/>
:fontawesome-brands-github: [simongarland/vim](https://github.com/simongarland/vim)
</td>
</tr>
<tr markdown="1">
<td markdown="1">Visual Studio Code</td>
<td markdown="1">
:fontawesome-brands-github: [jshinonome/vscode-q](https://github.com/jshinonome/vscode-q) ==new==<br>
:fontawesome-brands-github: [lwshang/vscode-q](https://github.com/lwshang/vscode-q)
</td>
</tr>
<tr markdown="1">
<td markdown="1">:fontawesome-brands-wordpress: WordPress</td><td markdown="1">:fontawesome-brands-github: [simongarland/Syntaxhighlighter-for-q](https://github.com/simongarland/Syntaxhighlighter-for-q) </td>
</tr>
</table>


??? warning "Salvaged repositories in kxcontrib"

    :fontawesome-brands-github: [kxcontrib](https://github.com/kxcontrib) contains repositories salvaged from the former Subversion server for which we have been unable to identify current versions on GitHub. These repositories are not maintained. 

