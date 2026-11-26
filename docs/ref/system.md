---
title: system keyword executes a system command | Reference | kdb+ and q documentation
description: system is a q keyword that executes a system command.
keywords: command, system, shell, os, kdb+, q
author: KX Systems, Inc., a subsidiary of KX Software Limited
---

# `system`

_Execute a system command_

```syntax
system x     system[x]
```

Where `x` is a string representing a [kdb+ system command](../basics/syscmds.md) or operating system shell command, and any parameters to it, executes the command and returns its result.

## kdb+ system commands

Refer to the [system commands reference](../basics/syscmds.md) for a full list of available commands.

!!! note "The argument to `system` does not include a leading `\`."

If you enter a system command with `\`, q passes any trailing comment to the command as part of its argument, so put comments on a separate line.

```q
q)s:([]a:1 2);p:([]b:3 4);sp:([]c:5 6)
q)/ tables in namespace
q)\a
`p`s`sp
q)/ \ must be the first character
q)count \a
'\
  [0]  count \a
             ^
q)system "a"             / same command called with system
`p`s`sp
q)count system "a"       / this returns a result
3
```

### Working directory changes on Windows

If the working directory changes unexpectedly on Windows, refer to [why the current directory can change](https://devblogs.microsoft.com/oldnewthing/20071121-00/?p=24433) on _The Old New Thing_.

## Operating system shell commands

As with `\`, if the argument is not a q command, `system` runs it in the shell and returns the output of the command as a list of strings:

```q
q)system "pwd"
"/home/guest/q"
```

If the shell command exits with a nonzero status, `system` signals an `os` error.

!!! warning "Binary output"

    `system` expects the result to be text and captures it as a list of character vectors.
    During capture, it removes line feeds and their associated carriage returns.

    This transformation makes it impractical to capture binary data from the result of the system call.
    In such cases, redirect the output to a file or FIFO and [read the file with `read1`](read1.md).

### Direct output to a file

To capture the output, kdb+ redirects it to a temporary file. If you redirect the output to a file yourself, append a semicolon to the command to avoid an unnecessary redirection.

```q
q)system"cat x"
```

is essentially the same as the shell command:

```bash
cat x > tmpout
```

because kdb+ captures the output. If you redirect the output yourself:

```q
q)system"cat x > y"
```

the shell receives:

```bash
cat x > y > tmpout
```

which redirects the output twice. If you add the semicolon:

```q
q)system"cat x > y;"
```

the shell treats it as two statements:

```bash
cat x > y; > tmpout
```

The same mechanism means that, for several commands separated by semicolons, only the output of the last command is captured.

### Capture `stderr` output

You cannot capture `stderr` from `system` directly. As a workaround, redirect it to a file and read the file:

```q
q)/ Force capture to a file, and cat the file
q)system"ls egg > file 2>&1;cat file"
"ls: egg: No such file or directory"

q)/ Try and fail to capture the text
q)@[system;"ls egg";{0N!"error - ",x;}]
ls: egg: No such file or directory
"error - os"
```

----

[System commands](../basics/syscmds.md)
