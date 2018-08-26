# `hclose`





_Close a file or process handle_

Syntax: `hclose x`, `hclose[x]`

Close file or process handle `x`.

```q
q)h:hopen `::5001
q)h"til 5"
0 1 2 3 4
q)hclose h
q)h"til 5"
': Bad file descriptor
```


<i class="far fa-hand-point-right"></i>
[File system](../basics/files.md)
[IPC](../basics/ipc.md)
