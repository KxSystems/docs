---
title: inetd, xinetd – Knowledge Base – kdb+ and q documentation
description: On *nix-like operating systems, a q server can work under inetd to provide a private server for each connexion established on a designated port.
keywords: cygwin, inetd, kdb+, linux, microsoft, q, sfu, xinetd, unix, windows
---
# inetd, xinetd




On *nix-like operating systems, `inetd` (or its successor `xinetd`) maintains a list of passive sockets for various services configured to run on that particular machine.

When a client attempts to connect to one of the service, `inetd` will start a program to handle the connexion based on the configuration files.

This way, `inetd` will run the server programs as they are needed by spawning multiple processes to service multiple network connexions.

A kdb+ server can work under `inetd` to provide a private server for each connexion established on a designated port. (Since V2.4.)

For Windows you might be able to have kdb+ run under `inetd` using Cygwin.

-   [Cygwin](http://www.cygwin.com/)
-   [A useful page about configuring Cygwin `inetd`](https://wiki.zmanda.com/index.php/How_To%3ARun_Amanda_Server_on_Cygwin)


## Configuration

To configure a kdb+ server to work under `inetd` or `xinetd` you have to decide on the name of the service and port on which this server should run and declare it in the `/etc/services` configuration file.

!!! note

    This operation can be performed only by an administrative user (root).

`/etc/services`:

```txt
…
# Local services
kdbtaq          2015/tcp    # kdb server for the taq database
…
```

If you have multiple databases which should be served over `inetd`, add multiple entries in the /etc/services file and make sure you are using different ports for each service name.

Also, as a safety measure, create one applicative group (ex: `kdb`) and two applicative users on your system, one (e.g. `kdb`) owning the q programs and the databases and another one (e.g. `kdbuser`) having the rights to execute and read data from the database directories.

This can be achieved by assigning the two users to the applicative group mentioned above and setting the permissions on the programs to be readable and executable by the group, and the database directories readable and executable (search) by the group: `rwxr-x---`.

Once this is configured, you'll need to configure `inetd`/`xinetd` to make it  aware of the new service.

If you are running `inetd`, you’ll need to add the service configuration into /etc/inetd.conf (see the inedt.conf man page for more details).

`/etc/inetd.conf`:

```txt
…
kdbtaq   stream  tcp   nowait kdbuser  /home/kdb/q/l64/q   q /home/kdb/taq -s 4
…
```

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

After the configuration is finished, you will have to find your process ID for your `inetd`/`xinetd` server and send it the `SIGHUP` signal to read the new configuration:

```bash
$ ps -e|grep inetd
 3848 ?        00:00:00 xinetd
$ kill -HUP 3848
```

:fontawesome-regular-hand-point-right: 
[`\1` and `\2`](../basics/syscmds.md#1-2-redirect) for stdout/stderr redirect
