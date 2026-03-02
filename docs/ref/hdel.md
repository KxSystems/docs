---
title: hdel deletes a file or folder | reference | q and kdb+ documentation
description: Keyword hdel deletes a file or folder
author: KX Systems, Inc., a subsidiary of KX Software Limited
date: December 2019
---
# `hdel`

_Delete a file or folder_

```syntax
hdel x     hdel[x]
```

Where `x` is a [file symbol](glossary.md#file-symbol) atom, deletes the file or folder and returns `x`.

```q
q)hdel`:test.txt   / delete test.txt in current working directory
`:test.txt
q)hdel`:test.txt   / should generate an error
'test.txt: No such file or directory
```

`hdel` can delete folders only if empty.

To delete a folder and its contents, [recursively](dotz.md#zs-self)

```q
​/diR gets recursive dir listing​
q)diR:{$[11h=type d:key x;raze x,.z.s each` sv/:x,/:d;d]}
​/hide power behind nuke​
q)​nuke:hdel​ ​each​ ​​desc diR​@​ / desc sort!​
​q)nuke`:mydir
```

For a general visitor pattern with `hdel`

```q
​q)visitNode:{if[11h=type d:key y;.z.s[x]each` sv/:y,/:d;];x y}
q)nuke:visitNode[hdel]
```

!!! warning "Unlike Linux, Windows doesn’t allow one to overwrite files which are memory mapped, and it takes some mS after unmapping for that to become possible."

----

[File system](files.md)
