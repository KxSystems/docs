---
title: man.q help page | About | q and kdb+ documentation
description: Help for man.q documentation script for q programmers
author: Stephen Taylor
date: November 2020
---
# Help for `man.q`


The `man.q` script mimics the Unix `man` command.


:fontawesome-brands-github:
[KxSystems/man](https://github.com/kxsystems/man)

## Examples
```txt
man "$"               / operator glyph
man "enum extend"     / operator name
man "read0"           / keyword
man ".z"              / namespace
man "-b"              / command-line option
man "\\b"             / system command
```


## Special pages
```txt
man ""                / reference card
man "cmdline"         / command-line options
man "errors"
man "datatypes"
man "debug"
man "interfaces"
man "internal"
man "iterators"
man "db"              / database
man "database"        / database
man "syscmds"         / system commands
man "wp"              / White Papers
```

## Arguments to `man`
```txt
man "--list"
man "--help"
```

---
:fontawesome-solid-book:
[Reference](../ref/index.md)
