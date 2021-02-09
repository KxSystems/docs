---
title: system keyword executes a system command | Reference | kdb+ and q documentation
description: system is a q keyword that executes a system command.
author: Stephen Taylor
---
# :fontawesome-solid-bullhorn: `system`




_Execute a system command_

```txt
system x     system[x]
```

Where `x` is a string representing a [system command](../basics/syscmds.md) and any parameters to it, executes the command and returns any result.

!!! note "The system command does not include a leading `\`."

```q
q)\l sp.q
…
q)\a                     / tables in namespace
`p`s`sp
q)count \a               / \ must be the first character
'\
q)system "a"             / same command called with system
`p`s`sp
q)count system "a"       / this returns a result
3
```

As with `\`, if the argument is not a q command, it is executed in the shell:

```q
q)system "pwd"
"/home/guest/q"
```


## :fontawesome-solid-database: Directing output to a file

When redirecting output to a file, for efficiency purposes, avoiding using `>tmpout` needlessly; append a semi-colon to the command.

```q
q)system"cat x"
```

is essentially the same as the shell command

```bash
$ cat x > tmpout
```

as kdb+ tries to capture the output.
So if you do

```q
q)system"cat x > y"
```

under the covers that looks like

```bash
$ cat x > y > tmpout
```

Not good. So if you add the semicolon

```q
q)system"cat x > y;"
```

the shell interpreter considers it as two statements

```bash
$ cat x > y; > tmpout
```

## :fontawesome-solid-exclamation-triangle: Capture stderr output

You cannot capture the stderr output from the system call directly, but a workaround is

```q
/ force capture to a file, and cat the file
q)system"ls egg > file 2>&1;cat file"
"ls: egg: No such file or directory"        
/ try and fails to capture the text
q)@[system;"ls egg";{0N!"error - ",x;}]
ls: egg: No such file or directory
"error - os"
```


## :fontawesome-brands-windows: Changing working directory

In the event of an unexpected change to the working directory, Windows users please note <https://devblogs.microsoft.com/oldnewthing/?p=24433>

