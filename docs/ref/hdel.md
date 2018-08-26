# `hdel`



_Delete a file or folder_

Syntax: `hdel x`, `hdel[x]`

Where `x` is a file or folder symbol, deletes it.

```q
q)hdel`:test.txt   / delete test.txt in current working directory
`:test.txt
q)hdel`:test.txt   / should generate an error
'test.txt: No such file or directory
```

!!! warning "`hdel` can delete folders only if empty"

    <pre><code class="language-q">
    q)hdel\`:mydir
    '​mydir​. OS reports: Directory not empty
      [0]  hdel\`:​mydir​
    </code></pre>

!!! tip "Delete a folder and its contents"

    To delete a folder and its contents, [recursively](dotz/.md

    <pre><code class="language-q">
    ​/diR gets recursive dir listing​
    q)diR:{$[11h=type d:key x;raze x,.z.s each\` sv/:x,/:d;d]}
    ​/hide power behind nuke​
    q)​nuke:hdel​ ​each​ ​​desc diR​@​ / desc sort!​
    ​q)nuke\`:mydir
    </code></pre>

For a general visitor pattern with `hdel`

```q
​q)visitNode:{if[11h=type d:key y;.z.s[x]each` sv/:y,/:d;];x y}
q)nuke:visitNode[hdel]
```


<i class="far fa-hand-point-right"></i>
[File system](../basics/files.md)
