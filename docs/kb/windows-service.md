# Running q as a service on Windows

SrvAny is a tool from the Windows NT Resource Kit, used for running Windows NT applications as services.  
<i class="fas fa-download"></i> [ftp.microsoft.com](ftp://ftp.microsoft.com/bussys/winnt/winnt-public/reskit/nt40/i386/srvany_x86.exe)

To create a Windows NT user-defined service: 

1. Copy srvany.exe to c:\\q 

2. At command prompt, type
    ```dos
    instsrv.exe q5010 c:\q\srvany.exe
    ```
    This will create service named `q5010`. We will use it to run q on port 5010 (tickerplant)

3. Prepare the Windows Registry to set up parameters for q5010 service:
```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\q5010\Parameters]
"Application"="c:\\q\\w32\\q.exe"
"AppParameters"="-p 5010 -q"
"AppDirectory"="c:\\q"
```

4. Now you can use q5010 service as a normal Windows service:
```dos
C:\> sc start q5010
```
or
```dos
C:\> net start q5010
```
To stop:
```dos
C:\> sc stop q5010
```
or
```dos
C:\> net stop q5010
```


If you want to set up several instances repeat steps 2-3 for different service names and ports. If you run tickerplant, realtime and historical database you will have 3 services at minimum, q5010, q5011, q5012. To start in appropriate order you can setup dependencies between q5011 and q5010
```dos
C:\> sc.exe q5011 depend= q5010
```
Note that `=` must be immediately after `depend` with a space before the service name.

In this way you can set up on Windows a complete q process that starts and stops in the right way.


## Output redirect

If you need to redirect output you must modify application using following reg file.
```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\q5010\Parameters]
"Application"="c:\\WINDOWS\\system32\\cmd.exe"
"AppParameters"="/c c:\\q\\w32\\q.exe -p 5010 -q >c:\\q\\logs\\q.5010.log"
"AppDirectory"="c:\\q"
```

!!! warning
    I’ve experienced some problems redirecting output, so it would be great if someone can improve this article. 


## Environment setup

1. Start `regedit` and go to the following subkey: 
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\q5010\Parameters` 


2. _Add Value_ with name `AppEnvironment` and type `REG_MULTI_SZ`. 


3. In the Multi-String Editor, enter environment variables:  
`TZ=GMT`  
`QHOME=c:\q`  
(Remember to add a new line after the last line, else the value will be ignored.)


## <i class="far fa-hand-point-right"></i> Further reading

- [How To Create a User-Defined Service](http://support.microsoft.com/kb/137890)
- [Troubleshooting SrvAny Using Cmd.exe](http://support.microsoft.com/kb/152460)
- [Passing Environment Variables to Applications Started by SRVANY](http://support.microsoft.com/kb/197178)
- [You receive an “An operation was attempted on something that is not a socket” error message when you try to connect to a network](http://support.microsoft.com/kb/817571)
