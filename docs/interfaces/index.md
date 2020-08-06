---
title: Interfaces and editor integrations | Interfaces | kdb+ and q documentation
description: Interfaces between kdb+ and other languages and services; also extensions to text editors for writing q code
keywords: editor, github, integration, interface, kdb+, q, repository
---
# :fontawesome-regular-handshake: Interfaces and editor integrations

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
<!-- -   written from the perspective of the ‘remote’ technology: e.g. a Java interface that is intelligible to a Java programmer -->

<table class="kx-compact" markdown="1">
<tr><td>FFI</td><td>[Using foreign functions with kdb+](ffi.md)</td></tr>
<tr><td>HDF5</td><td>[Handling HDF5 data with kdb+](hdf5/index.md) ==new==</td></tr>
<tr><td>Java</td><td> [Java client for kdb+](java-client-for-q.md)</td>
<tr><td>Jupyter</td><td>[Jupyter kernel for kdb+](../ml/jupyterq/index.md) [:fontawesome-brands-superpowers:](../ml/index.md "Machine learning") ==new==</td>
<tr><td>Kafka</td><td>[Q client for Kafka](kafka/index.md)</td></tr>
<tr><td>MQTT</td><td>[Q client for MQTT](mqtt/index.md) ==new==</td></tr>
<tr><td>Prometheus-Exporter</td><td>[Exporter of kdb+ metrics to Prometheus](prom/exporter/index.md) ==new==</td></tr>
<tr><td>Python</td>
    <td>
</i> [Using kdb+ within Python (PyQ)](pyq/index.md)<br/>
[Using Python within kdb+ (embedPy)](../ml/embedpy/index.md) [:fontawesome-brands-superpowers:](../ml/ "Machine learning")
    </td></tr>
<tr><td>R</td><td>[Using R with kdb+](r/index.md)</td>
<tr><td>Solace</td><td>[Interface to Solace PubSub+ broker](solace/index.md) ==new==</td></tr>
</tr>
</table>


## :fontawesome-solid-server: Kdb+ as server

<table class="kx-compact" markdown="1">
<tr><td>Adobe Flex</td><td>:fontawesome-brands-github: [quantbin/kdb](https://github.com/quantbin/kdb)</td></tr>
<tr><td>Apache Spark</td><td>:fontawesome-brands-github: [hughhyndman/kdbspark](https://github.com/hughhyndman/kdbspark) ==new==</td></tr>
<tr>
    <td>ADO.Net</td>
    <td>
:fontawesome-brands-github: [ScottWeinstein/Linq2KdbQ](https://github.com/ScottWeinstein/Linq2KdbQ)<br/>
:fontawesome-brands-github: [sv/kp.net](https://github.com/sv/kp.net)
    </td>
</tr>
<tr><td>amCharts</td><td>:fontawesome-brands-github: [kxcontrib/cburke/amcharts](https://github.com/kxcontrib/cburke/tree/master/amcharts/)</td></tr>
<tr><td>AQuery</td><td>:fontawesome-brands-github: [josepablocam/aquery](https://github.com/josepablocam/aquery)</td></tr>
<tr><td>C</td><td>[C client for kdb+](c-client-for-q.md)</td></tr>
<tr><td>CZMQ</td><td>:fontawesome-brands-github: [jaeheum/qzmq](https://github.com/jaeheum/qzmq)</i></td></tr>
<tr><td>C#</td><td>[C# client for kdb+](csharp-client-for-q.md)<br/>
:fontawesome-brands-github: [exxeleron/qSharp](https://github.com/exxeleron/qSharp)</td></tr>
<tr>
    <td>:fontawesome-brands-erlang: Erlang</td>
    <td>
:fontawesome-brands-github: [exxeleron/qErlang](https://github.com/exxeleron/qErlang/)<br/>
:fontawesome-brands-github: [republicwireless-open/gen_q](https://github.com/republicwireless-open/gen_q)<br/>
:fontawesome-brands-github: [michaelwittig/erlang-q](https://github.com/michaelwittig/erlang-q)
    </td>
</tr>
<tr>
    <td>:fontawesome-solid-table: Excel</td>
    <td>
[Excel client for kdb+](excel-client-for-q.md)<br/>
:fontawesome-brands-github: [exxeleron/qXL](https://github.com/exxeleron/qXL)<br/>
:fontawesome-brands-github: [CharlesSkelton/excelrtd](https://github.com/exxeleron/qXL)
    </td>
</tr>
<tr><td>F#</td><td>:fontawesome-brands-github: [kimtang/c.fs](https://github.com/kimtang/c.fs)</td></tr>
<tr><td>Go</td><td>:fontawesome-brands-github: [sv/kdbgo](https://github.com/sv/kdbgo)</td></tr>
<tr>
    <td>Haskell</td>
    <td>
:fontawesome-brands-github: [carrutstick/hasq](https://github.com/carrutstick/hasq)<br/>
:fontawesome-brands-github: [jkozlowski/kdb-haskell](https://github.com/jkozlowski/kdb-haskell)
    </td>
</tr>
<tr><td>J</td><td>[J client for kdb+](j-client-for-q.md)</td></tr>
<tr>
    <td>:fontawesome-brands-java: Java</td>
    <td>
:fontawesome-brands-github: [CharlesSkelton/jshow](https://github.com/CharlesSkelton/jshow)<br/>
:fontawesome-brands-github: [exxeleron/qJava](https://github.com/exxeleron/qJava)<br/>
:fontawesome-brands-github: [michaelwittig/java-q](https://github.com/michaelwittig/java-q)
    </td>
</tr>
<tr>
    <td>JDBC</td>
    <td>[JDBC client for kdb+](jdbc-client-for-kdb.md)</td>
</tr>
<tr>
    <td>JavaScript</td>
    <td>
[WebSockets](../kb//websockets.md)<br/>
:fontawesome-brands-github: [KxSystems/kdb/c/c.js](https://github.com/KxSystems/kdb/blob/master/c/c.js)<br/>
:fontawesome-brands-github: [kxcontrib/cbutler/ChartsForKdb](https://github.com/kxcontrib/cbutler/tree/master/ChartsForKdb)<br/>
:fontawesome-brands-github: [MdSalih/Kdb-Stuff/IPCWebParse](https://github.com/MdSalih/Kdb-Stuff/tree/master/IPCWebParse)<br/>
:fontawesome-brands-github: [michaelwittig/java-q](https://github.com/michaelwittig/java-q)
    </td>
</tr>
<tr><td>Lua</td><td>:fontawesome-brands-github: [geocar/qlua](https://github.com/geocar/qlua)</td></tr>
<tr>
    <td>Mathematica</td>
    <td>
        :fontawesome-brands-github: [KxSystems/kdb/c/other/qmathematica.txt](https://github.com/KxSystems/kdb/blob/master/c/other/qmathematica.txt)
    </td>
</tr>
<tr><td>Matlab</td>
<td>
[Matlab client for kdb+](matlab-client-for-q.md)<br/>
:fontawesome-brands-github: [dmarienko/kdbml](https://github.com/dmarienko/kdbml)</td></tr>
<tr><td>NaCL</td><td>:fontawesome-brands-github: [geocar/qsalt](https://github.com/geocar/qsalt)</td></tr>
<tr>
    <td>:fontawesome-brands-node-js: NodeJS</td>
    <td>
:fontawesome-brands-github: [geocar/qnode](https://github.com/geocar/qnode)<br/>
:fontawesome-brands-github: [michaelwittig/node-q](https://github.com/michaelwittig/node-q)
    </td>
</tr>
<tr><td>ODBC</td><td>[Kdb+ server for ODBC](q-server-for-odbc.md)<br/>
[Kdb+ server for ODBC3](q-server-for-odbc3.md)</td></tr>
<tr>
    <td>Perl</td>
    <td>
[Perl client for kdb+](perl-client-for-q.md)<br/>
:fontawesome-brands-github: [wjackson/anyevent-k](https://github.com/wjackson/anyevent-k)<br/>
:fontawesome-brands-github: [wjackson/k-perl](https://github.com/wjackson/k-perl)
    </td>
</tr>
<tr>
    <td>:fontawesome-brands-php: PHP</td>
    <td>
:fontawesome-brands-github: [geocar/qphp](https://github.com/geocar/qphp)<br/>
:fontawesome-brands-github: [johnanthonyludlow/kdb/docs/phptoq.pdf](https://github.com/johnanthonyludlow/kdb/blob/master/docs/phptoq.pdf)
    </td>
</tr>
<tr><td>PLplot</td><td>:fontawesome-brands-github: [jaeheum/qplplot](https://github.com/jaeheum/qplplot)</td></tr>
<tr><td>Postgres</td><td>:fontawesome-brands-github: [hughhyndman/pgtokdb](https://github.com/hughhyndman/pgtokdb)</td></tr>
<tr><td>:fontawesome-brands-python: Python</td>
    <td>
:fontawesome-brands-github: [brogar/pykdb](https://github.com/brogar/pykdb)<br/>
:fontawesome-brands-github: [enlnt/pyk](https://github.com/enlnt/pyk)<br/>
<!-- :fontawesome-brands-github: [enlnt/pyq](https://github.com/enlnt/pyq)<br/> -->
:fontawesome-brands-github: [eschnapp/q](https://github.com/eschnapp/q)<br/>
:fontawesome-brands-github: [nugend/q](https://github.com/nugend/q)<br/>
:fontawesome-brands-github: [nugend/qPython](https://github.com/nugend/qPython)<br/>
:fontawesome-brands-github: [exxeleron/qPython](https://github.com/exxeleron/qPython)<br/>
:fontawesome-brands-github: [kingan/mongodb_kdb_python_connection](https://github.com/kingan/mongodb_kdb_python_connection)
    </td></tr>
<tr><td>:fontawesome-brands-r-project: R</td><td>:fontawesome-brands-github: [yang-guo/qserver](https://github.com/yang-guo/qserver)</td></tr> 
<tr>
    <td>Rust</td>
    <td>
:fontawesome-brands-github: [adwhit/krust](https://github.com/adwhit/krust)<br/>
:fontawesome-brands-github: [jnordwick/rik](https://github.com/jnordwick/rik)
    </td>
</tr>
<tr><td>Scala</td><td>[Scala client for kdb+](scala-client-for-q.md)</td></tr>
</table>


## :fontawesome-regular-handshake: Kdb+ as client

<table class="kx-compact" markdown="1">
<tr><td>Betfair</td><td>:fontawesome-brands-github: [picoDoc/betfair-data-capture](https://github.com/picoDoc/betfair-data-capture)</td></tr>
<tr>
    <td>:fontawesome-brands-bitcoin: Bitcoin</td>
    <td>
        :fontawesome-brands-github: [bitmx/btceQ](https://github.com/bitmx/btceQ)<br/>
        :fontawesome-brands-github: [jlucid/qbitcoind](https://github.com/jlucid/qbitcoind)<br/>
        :fontawesome-brands-github: [jlucid/qexplorer](https://github.com/jlucid/qexplorer)
    </td>
</tr>
<tr><td>Bloomberg</td><td>[Q client for Bloomberg](q-client-for-bloomberg.md)</td></tr>
<tr><td>[BosonNLP](https://bosonnlp.com)</td><td>:fontawesome-brands-github: [FlyingOE/q_BosonNLP](https://github.com/FlyingOE/q_BosonNLP)</td></tr>
<tr><td>CUDA</td><td>[GPUs](gpus.md)</td></tr>
<tr><td>Expat XML parser</td><td>:fontawesome-brands-github: [felixlungu/qexpat](https://github.com/felixlungu/qexpat)</td></tr>
<tr>
    <td>[Factom](https://www.factom.com/) blockchain</td>
    <td>
        :fontawesome-brands-github: [jlucid/qfactom](https://github.com/jlucid/qfactom)<br/>
        :fontawesome-brands-github: [jlucid/qfactomconnect](https://github.com/jlucid/qfactomconnect)
    </td>
</tr>
<tr><td>ForexConnect</td><td>:fontawesome-brands-github: [mortensorensen/qfxcm](https://github.com/mortensorensen/qfxcm)</td></tr>
<tr><td>Interactive Brokers</td><td>:fontawesome-brands-github: [mortensorensen/QInteractiveBrokers](https://github.com/mortensorensen/QInteractiveBrokers)</td></tr>
<tr><td>[IEX](https://iextrading.com)</td><td>:fontawesome-brands-github: [himoacs/iex_q](https://github.com/himoacs/iex_q)</td></tr>
<tr><td>J</td><td>[Q client for J](q-client-for-j.md)</td></tr>
<tr><td>JDBC</td><td>:fontawesome-brands-github: [CharlesSkelton/babel](https://github.com/CharlesSkelton/babel)</td></tr>
<tr><td>Kafka</td><td>:fontawesome-brands-github: [ajayrathore/krak](https://github.com/ajayrathore/krak) ==new==</td></tr>
<tr><td>Lightning</td><td>:fontawesome-brands-github: [jlucid/qlnd](https://github.com/jlucid/qlnd)</td></tr>
<tr><td>MQTT</td><td>:fontawesome-brands-github: [himoacs/mqtt-q](https://github.com/himoacs/mqtt-q)</td></tr>
<tr><td>ODBC</td><td>[Q client for ODBC](q-client-for-odbc.md)<br/>
:fontawesome-brands-github: [johnanthonyludlow/kdb/docs/odbc.pdf](https://github.com/johnanthonyludlow/kdb/blob/master/docs/odbc.pdf)</td></tr>
<tr><td>Philips Hue</td><td>:fontawesome-brands-github: [jparmstrong/qphue](https://github.com/jparmstrong/qphue)</td></tr>
<tr><td>:fontawesome-brands-r-project: R</td><td>[Using R with kdb+](r/r-and-q.md)</td></tr>
<tr><td>Reuters</td><td>:fontawesome-brands-github: [KxSystems/kdb/c/feed/rfa.zip](https://github.com/KxSystems/kdb/blob/master/c/feed/rfa.zip)</td></tr>
<tr><td>TSE FLEX</td><td>:fontawesome-brands-github: [Naoki-Yatsu/TSE-FLEX-Converter](https://github.com/Naoki-Yatsu/TSE-FLEX-Converter)</td></tr>
<tr>
    <td> :fontawesome-brands-twitter: Twitter</td>
    <td>
        :fontawesome-brands-github: [gartinian/kdbTwitter](https://github.com/gartinian/kdbTwitter)<br/>
        :fontawesome-brands-github: [timeseries/twitter-kdb](https://github.com/timeseries/twitter-kdb)
    </td>
</tr>
<tr><td>[Wind资讯](https://www.wind.com.cn/en/)</td><td>:fontawesome-brands-github: [FlyingOE/q_Wind](https://github.com/FlyingOE/q_Wind)</td></tr>
<tr><td>:fontawesome-brands-yahoo: Yahoo!</td><td>:fontawesome-brands-github: [fdeleze/tickYahoo](https://github.com/fdeleze/tickYahoo)</td></tr>
</table>



## :fontawesome-solid-map-signs: Foreign functions 

<table class="kx-compact" markdown="1">
<tr><td>[Boost](https://www.boost.org) math library</td><td>:fontawesome-brands-github: [kimtang/bml](https://github.com/kimtang/bml)</td></tr>
<tr>
    <td>C/C++</td>
    <td>
[Using C/C++ functions](using-c-functions.md)<br/>
:fontawesome-brands-github: [enlnt/ffiq](https://github.com/enlnt/ffiq)<br/>
:fontawesome-brands-github: [felixlungu/c](https://github.com/felixlungu/c)
    </td>
</tr>
<tr><td>Fortran</td><td>:fontawesome-brands-github: [johnanthonyludlow/kdb/docs/fortran.pdf](https://github.com/kxcontrib/jludlow/blob/master/docs/fortran.pdf)</td></tr>
<tr><td>gnuplot</td><td>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qgnuplot](https://github.com/kxcontrib/zuoqianxu/tree/master/qgnuplot)</td></tr>
<tr><td>Google Charts</td><td>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qgooglechart](https://github.com/kxcontrib/zuoqianxu/tree/master/qgooglechart)</td></tr>
<tr><td>LAPACK, Cephes and FDLIBM</td><td>[althenia.net/qml](http://althenia.net/qml)</td></tr>
<tr><td>Mathematica</td><td>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qmathematica](https://github.com/kxcontrib/zuoqianxu/tree/master/qmathematica)</td></tr>
<tr><td>Matlab</td><td>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qmatlab](https://github.com/kxcontrib/zuoqianxu/tree/master/qmatlab)</td></tr>
<tr><td>Perl</td><td>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qperl](https://github.com/kxcontrib/zuoqianxu/tree/master/qperl)</td></tr>
<tr><td>:fontawesome-brands-python: Python</td><td>
:fontawesome-brands-github: [kxcontrib/serpent.speak](https://github.com/kxcontrib/serpent.speak)<br/>
:fontawesome-brands-github: [kxcontrib/zuoqianxu/qpython](https://github.com/kxcontrib/zuoqianxu/tree/master/qpython)
</td></tr>
<tr><td>Non-linear least squares</td><td>:fontawesome-brands-github: [brogar/nls](https://github.com/brogar/nls)</td></tr>
<tr><td>Regular Expressions</td><td>[Regex libraries](../kb/regex.md#regex-libraries)</td></tr>
<tr><td>:fontawesome-brands-r-project: R</td><td>:fontawesome-brands-github: [kimtang/rinit](https://github.com/kimtang/rinit)<br/>
:fontawesome-brands-github: [rwinston/kdb-rmathlib](https://github.com/rwinston/kdb-rmathlib)</td></tr>
<tr>
    <td>Rust</td>
    <td>
        :fontawesome-brands-github: [adwhit/krust](https://github.com/adwhit/krust)<br>
        :fontawesome-brands-github: [redsift/rkdb](https://github.com/redsift/rkdb) ==new==<br>
        :fontawesome-brands-github: [redsift/kdb-rs-hash](https://github.com/redsift/kdb-rs-hash) ==new==<br>
    </td>
</tr>
<tr><td>TA-Lib</td><td>:fontawesome-brands-github: [kxcontrib/zuoqianxu/qtalib](https://github.com/kxcontrib/zuoqianxu/tree/master/qtalib)</td></tr>
<tr><td>ZeroMQ</td><td>:fontawesome-brands-github: [wjackson/qzmq](https://github.com/wjackson/qzmq)</td></tr>
</table>


## :fontawesome-solid-plug: Editor integrations

<table class="kx-compact" markdown="1">
<tr>
    <td>Atom</td>
    <td>
:fontawesome-brands-github: [derekwisong/atom-q](https://github.com/derekwisong/atom-q)<br/>
:fontawesome-brands-github: [quintanar401/atom-charts](https://github.com/quintanar401/atom-charts)<br/>
:fontawesome-brands-github: [quintanar401/connect-kdb-q](https://github.com/quintanar401/connect-kdb-q)
    </td>
</tr>
<tr><td>Eclipse</td><td>[qkdt.org](http://www.qkdt.org/features.html)</td></tr>
<tr><td>Emacs</td>
    <td>
:fontawesome-brands-github: [eepgwde/kdbp-mode](https://github.com/eepgwde/kdbp-mode)<br/>
:fontawesome-brands-github: [geocar/kq-mode](https://github.com/geocar/kq-mode)<br/>
:fontawesome-brands-github: [indiscible/emacs](https://github.com/indiscible/emacs)<br/>
:fontawesome-brands-github: [psaris/q-mode](https://github.com/psaris/q-mode)
    </td>
</tr>
<tr><td>Evolved</td><td>:fontawesome-brands-github: [simongarland/Syntaxhighlighter-for-q](https://github.com/simongarland/Syntaxhighlighter-for-q)</td></tr>
<tr><td>Heroku</td><td>:fontawesome-brands-github: [gargraman/heroku-buildpack-kdb](https://github.com/gargraman/heroku-buildpack-kdb)</td></tr>
<tr><td>IntelliJ IDEA</td>
    <td>
:fontawesome-brands-github: [a2ndrade/k-intellij-plugin](https://github.com/a2ndrade/q-intellij-plugin)<br/>
:fontawesome-brands-gitlab: [shupakabras/kdb-intellij-plugin](https://gitlab.com/shupakabras/kdb-intellij-plugin) 
    </td>
</tr>
<tr><td>Jupyter</td>
    <td>
:fontawesome-brands-github: [jvictorchen/IKdbQ](https://github.com/jvictorchen/IKdbQ)<br/>
:fontawesome-brands-github: [newtux/KdbQ_kernel](https://github.com/newtux/KdbQ_kernel)
    </td></tr>
<tr><td>Linux, macOS, Unix</td><td>:fontawesome-brands-github: [enlnt/kdb-magic](https://github.com/enlnt/kdb-magic)</td></tr>
<tr><td>Pygments</td><td>:fontawesome-brands-github: [jasraj/q-pygments](https://github.com/jasraj/q-pygments)</td></tr>
<tr>
    <td>Sublime Text</td>
    <td>
:fontawesome-brands-github: [smbody-mipt/kdb](https://github.com/smbody-mipt/kdb) <br/>
:fontawesome-brands-github: [kimtang/QStudio](https://github.com/kimtang/QStudio)<br/>
:fontawesome-brands-github: [kimtang/sublime-q](https://github.com/kimtang/sublime-q)<br/>
:fontawesome-brands-github: [kimtang/Q](https://github.com/kimtang/Q)<br/>
:fontawesome-brands-github: [komsit37/sublime-q](https://github.com/komsit37/sublime-q)
    </td>
</tr>
<tr>
    <td>TextMate</td><td>:fontawesome-brands-github: [psaris/KX.tmbundle](https://github.com/psaris/KX.tmbundle) </td>
</tr>
<tr>
    <td>vim</td>
    <td>
:fontawesome-brands-github: [katusk/vim-qkdb-syntax](https://github.com/katusk/vim-qkdb-syntax)<br/>
:fontawesome-brands-github: [patmok/qvim](https://github.com/patmok/qvim)<br/>
:fontawesome-brands-github: [simongarland/vim](https://github.com/simongarland/vim)
    </td>
</tr>
<tr>
    <td>Visual Studio Code</td>
    <td>
:fontawesome-brands-github: [jshinonome/vscode-q](https://github.com/jshinonome/vscode-q) ==new==<br>
:fontawesome-brands-github: [lwshang/vscode-q](https://github.com/lwshang/vscode-q)
    </td>
</tr>
<tr>
    <td>:fontawesome-brands-wordpress: WordPress</td><td>:fontawesome-brands-github: [simongarland/Syntaxhighlighter-for-q](https://github.com/simongarland/Syntaxhighlighter-for-q) </td>
</tr>
</table>


!!! warning "Salvaged repositories"

    :fontawesome-brands-github: [kxcontrib](https://github.com/kxcontrib) contains repositories salvaged from the former Subversion server for which we have been unable to identify current versions on GitHub. These repositories are not maintained. 

