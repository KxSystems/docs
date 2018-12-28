---
keywords: kdb+, nt, q, service, srvany, windows
---

# Running kdb+ as a service on Windows

<!-- FIXME -->
==Rewrite for Windows 7+==



SrvAny is a tool from the Windows NT Resource Kit, used for running Windows NT applications as services. 

<i class="fa fa-download"></i> 
[ftp.microsoft.com](ftp://ftp.microsoft.com/bussys/winnt/winnt-public/reskit/nt40/i386/srvany_x86.exe)

To create a Windows NT user-defined service: 

1.  Copy `srvany.exe` to `c:\\q` 

2.  At command prompt, type ``instsrv.exe q5010 c:\q\srvany.exe``. This will create a service named `q5010`. We will use it to run kdb+ on port 5010 (tickerplant)

3.  Prepare the Windows Registry to set up parameters for the `q5010` service:

    <pre><code class="language-ini"> 
    Windows Registry Editor Version 5.00

    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\q5010\Parameters]
    "Application"="c:\\q\\w32\\q.exe"
    "AppParameters"="-p 5010 -q"
    "AppDirectory"="c:\\q"
    </code></pre>

4.  Now you can use the `q5010` service as a normal Windows service:

    <pre><code class="language-dos"> 
    C:\> sc start q5010
    </code></pre>

    or

    <pre><code class="language-dos"> 
    C:\> net start q5010
    </code></pre>

    To stop:

    <pre><code class="language-dos"> 
    C:\> sc stop q5010
    </code></pre>

    or

    <pre><code class="language-dos"> 
    C:\> net stop q5010
    </code></pre>


If you want to set up several instances, repeat steps 2-3 for different service names and ports. If you run tickerplant, real-time and historical databases you will have three services at minimum: `q5010`, `q5011`, `q5012`. To start in appropriate order you can setup dependencies between `q5011` and `q5010`.

```dos
C:\> sc.exe q5011 depend= q5010
```

Note that `=` must be immediately after `depend` with a space before the service name.

In this way you can set up on Windows a complete kdb+ process that starts and stops in the right way.


## Output redirect

If you need to redirect output you must modify application using following reg file.

```txt
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\q5010\Parameters]
"Application"="c:\\WINDOWS\\system32\\cmd.exe"
"AppParameters"="/c c:\\q\\w32\\q.exe -p 5010 -q >c:\\q\\logs\\q.5010.log"
"AppDirectory"="c:\\q"
```

!!! warning "Redirecting output"

    I’ve experienced some problems redirecting output, so it would be great if someone can improve this article. 


## Environment setup

1.  Start `regedit` and go to the following subkey: 
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\q5010\Parameters` 


2.  _Add Value_ with name `AppEnvironment` and type `REG_MULTI_SZ`. 


3. In the Multi-String Editor, enter environment variables:  
`TZ=GMT`  
`QHOME=c:\q`  
(Remember to add a new line after the last line, else the value will be ignored.)


## <i class="far fa-hand-point-right"></i> Further reading

-   [How To Create a User-Defined Service](http://support.microsoft.com/kb/137890)
-   [Troubleshooting SrvAny Using Cmd.exe](http://support.microsoft.com/kb/152460)
-   [Passing Environment Variables to Applications Started by SRVANY](http://support.microsoft.com/kb/197178)
-   [You receive an “An operation was attempted on something that is not a socket” error message when you try to connect to a network](http://support.microsoft.com/kb/817571)
