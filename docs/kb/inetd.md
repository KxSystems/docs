---
title: inetd, xinetd – Knowledge Base – kdb+ and q documentation
description: On *nix-like operating systems, a q server can work under inetd to provide a private server for each connection established on a designated port.
keywords: inetd, kdb+, linux, q, sfu, xinetd, unix
---
# inetd, xinetd


On *nix-like operating systems, `inetd` (or its successor `xinetd`) maintains a list of passive sockets for various services configured to run on that particular machine.

When a client attempts to connect to one of the service, `inetd` will start a program to handle the connection based on the configuration files.

This way, `inetd` will run the server programs as they are needed by spawning multiple processes to service multiple network connections.

A kdb+ server can work under `inetd` to provide a private server for each connection established on a designated port.

Only the kdb+ IPC protocol is supported when running with inetd or xinetd. SSL/TLS is supported since 4.1 2025.11.25, kdbx 5.0 2025.10.24.

## Assigning a TCP port

To configure a kdb+ server to work under `inetd` or `xinetd` you have to decide on the name of the service and port on which this server should run and declare it in the `/etc/services` configuration file.

!!! note "This operation can be performed only by an administrative user (root)."

`/etc/services`:

```txt
…
# Local services
kdbtaq          2015/tcp    # kdb server for the taq database
…
```

If you have multiple databases which should be served over `inetd`, add multiple entries in the /etc/services file and make sure you are using different ports for each service name.

## Logging

Any logging that goes to stdout or stderr will be sent directly to the connected client by the inetd/xinetd service manager.
As this isnt an IPC message, the client can generate a `badmsg` error when trying to decode it.

There are different options for dealing with logging:

* Use the system commands [`\1`](../basics/syscmds.md#1-2-redirect) for stdout redirect, [`\2`](../basics/syscmds.md#1-2-redirect) for stderr redirect. By passing a q script on the command line to kdb+ which contain these instructions, each instance can log to a specific file.
* Implement a logging framework. Note that any 3rd party library that is loaded into kdb+ may contain code to log to stdout/stderr without using the logging framework, so this may need accounted for (see next point).
* Create a shell script to run kdb+, redirecting stdout and stderr. The shell script should be used in the inetd/xinetd configuration instead of directly running the q binary.

## Configuring a service manager

Also, as a safety measure, create one applicative group (ex: `kdb`) and two applicative users on your system, one (e.g. `kdb`) owning the q programs and the databases and another one (e.g. `kdbuser`) having the rights to execute and read data from the database directories.

This can be achieved by assigning the two users to the applicative group mentioned above and setting the permissions on the programs to be readable and executable by the group, and the database directories readable and executable (search) by the group: `rwxr-x---`.

Once this is configured, you'll need to configure `inetd`/`xinetd` to make it  aware of the new service.

### Inetd configuration

If you are running `inetd`, you’ll need to add the service configuration into /etc/inetd.conf (see the inedt.conf man page for more details).

`/etc/inetd.conf`:

```txt
…
kdbtaq   stream  tcp   nowait kdbuser  /home/kdb/q/l64/q   q /home/kdb/taq -s 4
…
```

### Xinetd configuration

For `xinetd`, you’ll need to create a configuration file (`kdbtaq` for example) for the new service in the `/etc/xinetd.d` directory (see the  `xinetd.conf` man page for more details).

`/etc/xinetd.d/kdbtaq`:

```txt
# default: on

service kdbtaq
{
    flags       = REUSE
    socket_type = stream
    wait        = no
    user        = kdbuser
    env         = QHOME=/home/kdb/q QLIC=/home/kdb/q
    server      = /home/kdb/q/l64/q
    server_args = /home/kdb/taq -s 4 -q -g 1
# use taskset to conform to license
#    server      = /bin/taskset
#    server_args = -c 0,1 /home/kdb/q/l64/q -q -g 1
#    only_from   = 127.0.0.1 localhost
#    bind        = 127.0.0.1
#    instances   = 5
#    per_source  = 2
}
```

### Reloading configuration

If the service manager is already running, you can force it to reload an updated configuration file by sending the process a `SIGHUP` signal.

For example, the following finds the process ID of inetd, in order to send a `SIGHUP` signal to it.

```bash
$ ps -e|grep inetd
 3848 ?        00:00:00 xinetd
$ kill -HUP 3848
```

