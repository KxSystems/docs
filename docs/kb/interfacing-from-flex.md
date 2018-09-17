# Interfacing from Flex/ActionScript

The <i class="far fa-github"></i> [AsQ](https://github.com/kxcontrib/aboudarov) library provides integration between a q instance and an ActionScript application. AsQ implements q’s IPC protocol and uses TCP sockets to communicate with a q instance. AsQ does not rely on third-party libraries and is self-contained.

-   define reference to **c** class

<!-- -->

    [Bindable] public var q:c;

-   create instance of c class, attach listeners and connect

<!-- -->

    q=new c(host, p, user);
    q.addEventListener(c.CONNECTED, _onKconnected);
    q.addEventListener(c.DISCONNECTED, _onKdisconnected);
    q.addEventListener(c.BEG_EXEC, _onBegExec);
    q.addEventListener(c.END_EXEC, _onEndExec);
    q.addEventListener(c.CONNECTION_ERROR, _onConnectionError);
    q.connect();

ActionScript is the language behind the Flex technology. Flex applications run in Flash Player (FP) virtual machine (in browser or standalone). FP is an asynchronous environment where calls to external services do not block, but rather rely on callbacks (aka events). Therefore it is necessary to define the event listeners that will be called by the FP when server responds to user's actions.

AsQ implements following events

::\* CONNECTED - connection to q established

::\* DISCONNECTED - connection to q is closed

::\* BEG\_EXEC - request has been sent to q (can be used to provide visual feedback)

::\* END\_EXEC - response has been received from q (can be used to provide visual feedback)

::\* CONNECTION\_ERROR - connection was closed as a result of an error

Send code to q for execution and process the response:

    q.ksync(cmd, this, "onKdata");

When response arrives from q, setter onKdata is called ('o' is q response deserialized into ActionScript native data structures):

    public function set onKdata(o:Object):void {
    ...
    }

Following is the full signature of ksync method:

    public function ksync(
      cmd:String,
      obj:Object,
      prop:String,
      error:String=null,
      warn:String=null,
      tr:Function=null,
      timer:String=null):Boolean {
    ...
    }

-   cmd - code to be executed
-   obj - reference to object that owns callback setters
-   prop - name of the setter that will receive the server response
-   error - name of the setter that will be called in case of error
-   warn - name of the setter that will be called in case of warning
-   tr - reference to trace function (receives debug info from AsQ)
-   timer - setter that receives the call duration in milliseconds

Flex application can call ksync() a number of times without waiting for response. AsQ will queue up the calls and execute them sequentially.

[AsQ](https://github.com/kxcontrib/aboudarov) also contains source code for two sample Flex applications that use AsQ library: **qui** and **taq**. **qui** is a q terminal, that includes namespace browser (shows variables and functions defined in each directory), sends code to q for execution and lists q idioms (qui's main purpose is to serve as a learning tool). **taq** is trade and quote browser. It allows to drill into taq database down to tick level.

-   Data types mapping between q and actionscript

|                                         |                  |
|-----------------------------------------|------------------|
| **Q**                                   | **ActionScript** |
| Dict                                    | Object           |
| lambdas                                 | “func”           |
| boolean                                 | Boolean          |
| int, short, month, minute, second, time | int              |
| long, float, double, timespan           | Number           |
| char, symbol                            | String           |
| timestamp, date, datetime               | Date             |

<Category:Interfaces>
