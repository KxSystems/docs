---
title: Interfaces and editor integrations
description: Interfaces between kdb+ and other languages and services; also extensions to text editors for writing q code
keywords: editor, github, integration, interface, kdb+, q, repository
---
# <i class="far fa-handshake"></i> Interfaces and editor integrations





<i class="far fa-hand-point-right"></i> [General index](../github.md) of other kdb+ repositories

Repositories at <i class="fab fa-github"></i> [KxSystems](https://github.com/KxSystems) are maintained and supported by Kx Systems. 
Other repositories are maintained by their owners. 

<div style="background-color: #efefef; border: 1px solid #005499; border-radius: 10px; display: inline-block; padding: 0 1em;" markdown="1">Please tell [librarian@kx.com](mailto:librarian@kx.com)
about new repositories.</div>


## <i class="fab fa-superpowers"></i> Fusion interfaces

The [Fusion interfaces](fusion.md) to kdb+ are

-   written for non-kdb+ programmers to use
-   well documented, with understandable and useful examples
-   maintained and supported by Kx on a best-efforts basis, at no cost to customers
-   released under the [Apache 2 license](https://www.apache.org/licenses/LICENSE-2.0)
-   free for all use cases, including 64-bit and commercial use
<!-- -   written from the perspective of the ‘remote’ technology: e.g. a Java interface that is intelligible to a Java programmer -->

<table class="kx-compact" markdown="1">
<tr><td>FFI</td><td>[Using foreign functions with kdb+](ffi.md)</td></tr>
<tr><td>Java</td><td> [Java client for kdb+](java-client-for-q.md)</td>
<tr><td>Jupyter</td><td>[Jupyter kernel for kdb+](../ml/jupyterq/index.md) [<i class="fab fa-superpowers"></i>](../ml/index.md "Machine learning") ==new==</td>
<tr><td>Kafka</td><td>[Q client for Kafka](kafka.md)</td></tr>
<tr><td>Python</td>
    <td>
</i> [Using kdb+ within Python (PyQ)](pyq/index.md)<br/>
[Using Python within kdb+ (embedPy)](../ml/embedpy/index.md) [<i class="fab fa-superpowers"></i>](../ml/ "Machine learning")
    </td></tr>
<tr><td>R</td><td>[Using R with kdb+](with-r.md#calling-q-from-r)</td>
</tr>
</table>


## <i class="fas fa-server"></i> Kdb+ as server

<table class="kx-compact" markdown="1">
<tr><td>Adobe Flex</td><td><i class="fab fa-github"></i> [quantbin/kdb](https://github.com/quantbin/kdb)</td></tr>
<tr>
    <td>ADO.Net</td>
    <td>
<i class="fab fa-github"></i> [ScottWeinstein/Linq2KdbQ](https://github.com/ScottWeinstein/Linq2KdbQ)<br/>
<i class="fab fa-github"></i> [sv/kp.net](https://github.com/sv/kp.net)
    </td>
</tr>
<tr><td>amCharts</td><td><i class="fab fa-github"></i> [kxcontrib/cburke/amcharts](https://github.com/kxcontrib/cburke/tree/master/amcharts/)</td></tr>
<tr><td>AQuery</td><td><i class="fab fa-github"></i> [josepablocam/aquery](https://github.com/josepablocam/aquery) ==new==</td></tr>
<tr><td>C</td><td>[C client for kdb+](c-client-for-q.md)</td></tr>
<tr><td>CZMQ</td><td><i class="fab fa-github"></i> [jaeheum/qzmq](https://github.com/jaeheum/qzmq)</i></td></tr>
<tr><td>C#</td><td>[C# client for kdb+](csharp-client-for-q.md)<br/>
<i class="fab fa-github"></i> [exxeleron/qSharp](https://github.com/exxeleron/qSharp)</td></tr>
<tr>
    <td><i class="fab fa-erlang"></i> Erlang</td>
    <td>
<i class="fab fa-github"></i> [exxeleron/qErlang](https://github.com/exxeleron/qErlang/)<br/>
<i class="fab fa-github"></i> [republicwireless-open/gen_q](https://github.com/republicwireless-open/gen_q)<br/>
<i class="fab fa-github"></i> [michaelwittig/erlang-q](https://github.com/michaelwittig/erlang-q)
    </td>
</tr>
<tr>
    <td><i class="fas fa-table"></i> Excel</td>
    <td>
[Excel client for kdb+](excel-client-for-q.md)<br/>
<i class="fab fa-github"></i> [exxeleron/qXL](https://github.com/exxeleron/qXL)<br/>
<i class="fab fa-github"></i> [CharlesSkelton/excelrtd](https://github.com/exxeleron/qXL)
    </td>
</tr>
<tr><td>F#</td><td><i class="fab fa-github"></i> [kimtang/c.fs](https://github.com/kimtang/c.fs)</td></tr>
<tr><td>Go</td><td><i class="fab fa-github"></i> [sv/kdbgo](https://github.com/sv/kdbgo)</td></tr>
<tr>
    <td>Haskell</td>
    <td>
<i class="fab fa-github"></i> [carrutstick/hasq](https://github.com/carrutstick/hasq)<br/>
<i class="fab fa-github"></i> [jkozlowski/kdb-haskell](https://github.com/jkozlowski/kdb-haskell)
    </td>
</tr>
<tr><td>J</td><td>[J client for kdb+](j-client-for-q.md)</td></tr>
<tr>
    <td><i class="fab fa-java"></i> Java</td>
    <td>
<i class="fab fa-github"></i> [CharlesSkelton/jshow](https://github.com/CharlesSkelton/jshow)<br/>
<i class="fab fa-github"></i> [exxeleron/qJava](https://github.com/exxeleron/qJava)<br/>
<i class="fab fa-github"></i> [michaelwittig/java-q](https://github.com/michaelwittig/java-q)
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
<i class="fab fa-github"></i> [KxSystems/kdb/c/c.js](https://github.com/KxSystems/kdb/blob/master/c/c.js)<br/>
<i class="fab fa-github"></i> [kxcontrib/cbutler/ChartsForKdb](https://github.com/kxcontrib/cbutler/tree/master/ChartsForKdb)<br/>
<i class="fab fa-github"></i> [MdSalih/Kdb-Stuff/IPCWebParse](https://github.com/MdSalih/Kdb-Stuff/tree/master/IPCWebParse)<br/>
<i class="fab fa-github"></i> [michaelwittig/java-q](https://github.com/michaelwittig/java-q)
    </td>
</tr>
<tr><td>Lua</td><td><i class="fab fa-github"></i> [geocar/qlua](https://github.com/geocar/qlua)</td></tr>
<tr>
    <td>Mathematica</td>
    <td>
        <i class="fab fa-github"></i> [KxSystems/kdb/c/other/qmathematica.txt](https://github.com/KxSystems/kdb/blob/master/c/other/qmathematica.txt)
    </td>
</tr>
<tr><td>Matlab</td>
<td>
[Matlab client for kdb+](matlab-client-for-q.md)<br/>
<i class="fab fa-github"></i> [dmarienko/kdbml](https://github.com/dmarienko/kdbml)</td></tr>
<tr><td>NaCL</td><td><i class="fab fa-github"></i> [geocar/qsalt](https://github.com/geocar/qsalt)</td></tr>
<tr>
    <td><i class="fab fa-node-js"></i> NodeJS</td>
    <td>
<i class="fab fa-github"></i> [geocar/qnode](https://github.com/geocar/qnode)<br/>
<i class="fab fa-github"></i> [michaelwittig/node-q](https://github.com/michaelwittig/node-q)
    </td>
</tr>
<tr><td>ODBC</td><td>[Kdb+ server for ODBC](q-server-for-odbc.md)<br/>
[Kdb+ server for ODBC3](q-server-for-odbc3.md)</td></tr>
<tr>
    <td>Perl</td>
    <td>
[Perl client for kdb+](perl-client-for-q.md)<br/>
<i class="fab fa-github"></i> [wjackson/anyevent-k](https://github.com/wjackson/anyevent-k)<br/>
<i class="fab fa-github"></i> [wjackson/k-perl](https://github.com/wjackson/k-perl)
    </td>
</tr>
<tr>
    <td><i class="fab fa-php"></i> PHP</td>
    <td>
<i class="fab fa-github"></i> [geocar/qphp](https://github.com/geocar/qphp)<br/>
<i class="fab fa-github"></i> [johnanthonyludlow/kdb/docs/phptoq.pdf](https://github.com/johnanthonyludlow/kdb/blob/master/docs/phptoq.pdf)
    </td>
</tr>
<tr><td>PLplot</td><td><i class="fab fa-github"></i> [jaeheum/qplplot](https://github.com/jaeheum/qplplot)</td></tr>
<tr><td><i class="fab fa-python"></i> Python</td>
    <td>
<i class="fab fa-github"></i> [brogar/pykdb](https://github.com/brogar/pykdb)<br/>
<i class="fab fa-github"></i> [enlnt/pyk](https://github.com/enlnt/pyk)<br/>
<!-- <i class="fab fa-github"></i> [enlnt/pyq](https://github.com/enlnt/pyq)<br/> -->
<i class="fab fa-github"></i> [eschnapp/q](https://github.com/eschnapp/q)<br/>
<i class="fab fa-github"></i> [nugend/q](https://github.com/nugend/q)<br/>
<i class="fab fa-github"></i> [nugend/qPython](https://github.com/nugend/qPython)<br/>
<i class="fab fa-github"></i> [exxeleron/qPython](https://github.com/exxeleron/qPython)<br/>
<i class="fab fa-github"></i> [kingan/mongodb_kdb_python_connection](https://github.com/kingan/mongodb_kdb_python_connection)
    </td></tr>
<tr><td><i class="fab fa-r-project"></i> R</td><td><i class="fab fa-github"></i> [yang-guo/qserver](https://github.com/yang-guo/qserver)</td></tr> 
<tr>
    <td>Rust</td>
    <td>
<i class="fab fa-github"></i> [adwhit/krust](https://github.com/adwhit/krust)<br/>
<i class="fab fa-github"></i> [jnordwick/rik](https://github.com/jnordwick/rik)
    </td>
</tr>
<tr><td>Scala</td><td>[Scala client for kdb+](scala-client-for-q.md)</td></tr>
</table>


## <i class="far fa-handshake"></i> Kdb+ as client

<table class="kx-compact" markdown="1">
<tr><td>Betfair</td><td><i class="fab fa-github"></i> [picoDoc/betfair-data-capture](https://github.com/picoDoc/betfair-data-capture)</td></tr>
<tr>
    <td><i class="fab fa-bitcoin"></i> Bitcoin</td>
    <td>
        <i class="fab fa-github"></i> [bitmx/btceQ](https://github.com/bitmx/btceQ)<br/>
        <i class="fab fa-github"></i> [jlucid/qbitcoind](https://github.com/jlucid/qbitcoind)<br/>
        <i class="fab fa-github"></i> [jlucid/qexplorer](https://github.com/jlucid/qexplorer)
    </td>
</tr>
<tr><td>Bloomberg</td><td>[Q client for Bloomberg](q-client-for-bloomberg.md)</td></tr>
<tr><td>[BosonNLP](http://bosonnlp.com/)</td><td><i class="fab fa-github"></i> [FlyingOE/q_BosonNLP](https://github.com/FlyingOE/q_BosonNLP)</td></tr>
<tr><td>CUDA</td><td>[GPUs](gpus.md)</td></tr>
<tr><td>Expat XML parser</td><td><i class="fab fa-github"></i> [felixlungu/qexpat](https://github.com/felixlungu/qexpat)</td></tr>
<tr>
    <td>[Factom](https://www.factom.com/) blockchain</td>
    <td>
        <i class="fab fa-github"></i> [jlucid/qfactom](https://github.com/jlucid/qfactom)<br/>
        <i class="fab fa-github"></i> [jlucid/qfactomconnect](https://github.com/jlucid/qfactomconnect)
    </td>
</tr>
<tr><td>ForexConnect</td><td><i class="fab fa-github"></i> [mortensorensen/qfxcm](https://github.com/mortensorensen/qfxcm)</td></tr>
<tr><td>Interactive Brokers</td><td><i class="fab fa-github"></i> [mortensorensen/QInteractiveBrokers](https://github.com/mortensorensen/QInteractiveBrokers)</td></tr>
<tr><td>[IEX](https://iextrading.com)</td><td><i class="fab fa-github"></i> [himoacs/iex_q](https://github.com/himoacs/iex_q)</td></tr>
<tr><td>J</td><td>[Q client for J](q-client-for-j.md)</td></tr>
<tr><td>JDBC</td><td><i class="fab fa-github"></i> [CharlesSkelton/babel](https://github.com/CharlesSkelton/babel)</td></tr>
<tr><td>Lightning</td><td><i class="fab fa-github"></i> [jlucid/qlnd](https://github.com/jlucid/qlnd)</td></tr>
<tr><td>MQTT</td><td><i class="fab fa-github"></i> [himoacs/mqtt-q](https://github.com/himoacs/mqtt-q)</td></tr>
<tr><td>ODBC</td><td>[Q client for ODBC](q-client-for-odbc.md)<br/>
<i class="fab fa-github"></i> [johnanthonyludlow/kdb/docs/odbc.pdf](https://github.com/johnanthonyludlow/kdb/blob/master/docs/odbc.pdf)</td></tr>
<tr><td>Philips Hue</td><td><i class="fab fa-github"></i> [jparmstrong/qphue](https://github.com/jparmstrong/qphue)</td></tr>
<tr><td><i class="fab fa-r-project"></i> R</td><td>[Using R with kdb+](with-r.md#calling-r-from-q)</td></tr>
<tr><td>Reuters</td><td><i class="fab fa-github"></i> [KxSystems/kdb/c/feed/rfa.zip](https://github.com/KxSystems/kdb/blob/master/c/feed/rfa.zip)</td></tr>
<tr><td>TSE FLEX</td><td><i class="fab fa-github"></i> [Naoki-Yatsu/TSE-FLEX-Converter](https://github.com/Naoki-Yatsu/TSE-FLEX-Converter)</td></tr>
<tr>
    <td> <i class="fab fa-twitter"></i> Twitter</td>
    <td>
        <i class="fab fa-github"></i> [gartinian/kdbTwitter](https://github.com/gartinian/kdbTwitter)<br/>
        <i class="fab fa-github"></i> [timeseries/twitter-kdb](https://github.com/timeseries/twitter-kdb) ==new==
    </td>
</tr>
<tr><td>[Wind资讯](http://www.wind.com.cn/en/)</td><td><i class="fab fa-github"></i> [FlyingOE/q_Wind](https://github.com/FlyingOE/q_Wind)</td></tr>
<tr><td><i class="fab fa-yahoo"></i> Yahoo!</td><td><i class="fab fa-github"></i> [fdeleze/tickYahoo](https://github.com/fdeleze/tickYahoo)</td></tr>
</table>



## <i class="fas fa-map-signs"></i> Foreign functions 

<table class="kx-compact" markdown="1">
<tr><td>[Boost](http://www.boost.org/) math library</td><td><i class="fab fa-github"></i> [kimtang/bml](https://github.com/kimtang/bml)</td></tr>
<tr>
    <td>C/C++</td>
    <td>
[Using C/C++ functions](using-c-functions.md)<br/>
<i class="fab fa-github"></i> [enlnt/ffiq](https://github.com/enlnt/ffiq)<br/>
<i class="fab fa-github"></i> [felixlungu/c](https://github.com/felixlungu/c)
    </td>
</tr>
<tr><td>Fortran</td><td><i class="fab fa-github"></i> [johnanthonyludlow/kdb/docs/fortran.pdf](https://github.com/kxcontrib/jludlow/blob/master/docs/fortran.pdf)</td></tr>
<tr><td>gnuplot</td><td><i class="fab fa-github"></i> [kxcontrib/zuoqianxu/qgnuplot](https://github.com/kxcontrib/zuoqianxu/tree/master/qgnuplot)</td></tr>
<tr><td>Google Charts</td><td><i class="fab fa-github"></i> [kxcontrib/zuoqianxu/qgooglechart](https://github.com/kxcontrib/zuoqianxu/tree/master/qgooglechart)</td></tr>
<tr><td>LAPACK, Cephes and FDLIBM</td><td>[althenia.net/qml](http://althenia.net/qml)</td></tr>
<tr><td>Mathematica</td><td><i class="fab fa-github"></i> [kxcontrib/zuoqianxu/qmathematica](https://github.com/kxcontrib/zuoqianxu/tree/master/qmathematica)</td></tr>
<tr><td>Matlab</td><td><i class="fab fa-github"></i> [kxcontrib/zuoqianxu/qmatlab](https://github.com/kxcontrib/zuoqianxu/tree/master/qmatlab)</td></tr>
<tr><td>Perl</td><td><i class="fab fa-github"></i> [kxcontrib/zuoqianxu/qperl](https://github.com/kxcontrib/zuoqianxu/tree/master/qperl)</td></tr>
<tr><td><i class="fab fa-python"></i> Python</td><td>
<i class="fab fa-github"></i> [kxcontrib/serpent.speak](https://github.com/kxcontrib/serpent.speak)<br/>
<i class="fab fa-github"></i> [kxcontrib/zuoqianxu/qpython](https://github.com/kxcontrib/zuoqianxu/tree/master/qpython)
</td></tr>
<tr><td>Non-linear least squares</td><td><i class="fab fa-github"></i> [brogar/nls](https://github.com/brogar/nls)</td></tr>
<tr><td>Regular Expressions</td><td>[Regex libraries](../kb/regex.md#regex-libraries)</td></tr>
<tr><td><i class="fab fa-r-project"></i> R</td><td><i class="fab fa-github"></i> [kimtang/rinit](https://github.com/kimtang/rinit)<br/>
<i class="fab fa-github"></i> [rwinston/kdb-rmathlib](https://github.com/rwinston/kdb-rmathlib)</td></tr>
<tr>
    <td>Rust</td>
    <td>
        <i class="fab fa-github"></i> [adwhit/krust](https://github.com/adwhit/krust)<br>
        <i class="fab fa-github"></i> [redsift/rkdb](https://github.com/redsift/rkdb) ==new==<br>
        <i class="fab fa-github"></i> [redsift/kdb-rs-hash](https://github.com/redsift/kdb-rs-hash) ==new==<br>
    </td>
</tr>
<tr><td>TA-Lib</td><td><i class="fab fa-github"></i> [kxcontrib/zuoqianxu/qtalib](https://github.com/kxcontrib/zuoqianxu/tree/master/qtalib)</td></tr>
<tr><td>ZeroMQ</td><td><i class="fab fa-github"></i> [wjackson/qzmq](https://github.com/wjackson/qzmq)</td></tr>
</table>


## <i class="fas fa-plug"></i> Editor integrations

<table class="kx-compact" markdown="1">
<tr>
    <td>Atom</td>
    <td>
<i class="fab fa-github"></i> [derekwisong/atom-q](https://github.com/derekwisong/atom-q)<br/>
<i class="fab fa-github"></i> [quintanar401/atom-charts](https://github.com/quintanar401/atom-charts)<br/>
<i class="fab fa-github"></i> [quintanar401/connect-kdb-q](https://github.com/quintanar401/connect-kdb-q)
    </td>
</tr>
<tr><td>Eclipse</td><td>[qkdt.org](http://www.qkdt.org/features.html)</td></tr>
<tr><td>Emacs</td>
    <td>
<i class="fab fa-github"></i> [eepgwde/kdbp-mode](https://github.com/eepgwde/kdbp-mode)<br/>
<i class="fab fa-github"></i> [geocar/kq-mode](https://github.com/geocar/kq-mode)<br/>
<i class="fab fa-github"></i> [indiscible/emacs](https://github.com/indiscible/emacs)<br/>
<i class="fab fa-github"></i> [psaris/q-mode](https://github.com/psaris/q-mode)
    </td>
</tr>
<tr><td>Evolved</td><td><i class="fab fa-github"></i> [simongarland/Syntaxhighlighter-for-q](https://github.com/simongarland/Syntaxhighlighter-for-q)</td></tr>
<tr><td>Heroku</td><td><i class="fab fa-github"></i> [gargraman/heroku-buildpack-kdb](https://github.com/gargraman/heroku-buildpack-kdb)</td></tr>
<tr><td>IntelliJ IDEA</td>
    <td>
<i class="fab fa-github"></i> [a2ndrade/k-intellij-plugin](https://github.com/a2ndrade/k-intellij-plugin)<br/>
<i class="fab fa-gitlab"></i> [shupakabras/kdb-intellij-plugin](https://gitlab.com/shupakabras/kdb-intellij-plugin) ==new==
    </td>
</tr>
<tr><td>Jupyter</td>
    <td>
<i class="fab fa-github"></i> [jvictorchen/IKdbQ](https://github.com/jvictorchen/IKdbQ)<br/>
<i class="fab fa-github"></i> [newtux/KdbQ_kernel](https://github.com/newtux/KdbQ_kernel)
    </td></tr>
<tr><td>Linux, macOS, Unix</td><td><i class="fab fa-github"></i> [enlnt/kdb-magic](https://github.com/enlnt/kdb-magic)</td></tr>
<tr><td>Pygments</td><td><i class="fab fa-github"></i> [jasraj/q-pygments](https://github.com/jasraj/q-pygments)</td></tr>
<tr>
    <td>Sublime Text</td>
    <td>
<i class="fab fa-github"></i> [smbody-mipt/kdb](https://github.com/smbody-mipt/kdb) ==new==<br/>
<i class="fab fa-github"></i> [kimtang/QStudio](https://github.com/kimtang/QStudio)<br/>
<i class="fab fa-github"></i> [kimtang/sublime-q](https://github.com/kimtang/sublime-q)<br/>
<i class="fab fa-github"></i> [kimtang/Q](https://github.com/kimtang/Q)<br/>
<i class="fab fa-github"></i> [komsit37/sublime-q](https://github.com/komsit37/sublime-q)
    </td>
</tr>
<tr>
    <td>TextMate</td><td><i class="fab fa-github"></i> [psaris/KX.tmbundle](https://github.com/psaris/KX.tmbundle) ==new==</td>
</tr>
<tr>
    <td>vim</td>
    <td>
<i class="fab fa-github"></i> [katusk/vim-qkdb-syntax](https://github.com/katusk/vim-qkdb-syntax)<br/>
<i class="fab fa-github"></i> [patmok/qvim](https://github.com/patmok/qvim)<br/>
<i class="fab fa-github"></i> [simongarland/vim](https://github.com/simongarland/vim)
    </td>
</tr>
<tr>
    <td>Visual Studio Code</td><td><i class="fab fa-github"></i> [lwshang/vscode-q](https://github.com/lwshang/vscode-q)</td>
</tr>
<tr>
    <td><i class="fab fa-wordpress"></i> WordPress</td><td><i class="fab fa-github"></i> [simongarland/Syntaxhighlighter-for-q](https://github.com/simongarland/Syntaxhighlighter-for-q) ==new==</td>
</tr>
</table>


!!! warning "Salvaged repositories"

    <i class="fab fa-github"></i> [kxcontrib](https://github.com/kxcontrib) contains repositories salvaged from the former Subversion server for which we have been unable to identify current versions on GitHub. These repositories are not maintained. 

