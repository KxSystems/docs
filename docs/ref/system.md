---
title: system – Reference – kdb+ and q documentation
description: system is a q keyword that executes a system command.
author: Stephen Taylor
keywords: command, kdb+, q, system, system command
---
# `system`




_Execute a system command_

Syntax: `system x`, `system[x]`

Where `x` is a string representing a [system command](../basics/syscmds.md) and any parameters to it, executes the command and returns any result.

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


### Directing output to a file

When redirecting output to a file, for efficiency purposes, avoiding using `>&nbsp;tmpout` needlessly; append a semi-colon to the command.

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

### Capture stderr output

Can I capture the stderr output from the system call? Not directly, but a workaround is

```q
/ force capture to a file, and cat the file
q)system"ls egg > file 2>&1;cat file"
"ls: egg: No such file or directory"        
/ try and fails to capture the text
q)@[system;"ls egg";{0N!"error - ",x;}]
ls: egg: No such file or directory
"error - os"
```

!!! warning "Changing working directory in Windows"

    In the event of an unexpected change to the working directory, Windows users please note <https://devblogs.microsoft.com/oldnewthing/?p=24433>

