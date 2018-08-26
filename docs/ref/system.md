# `system`



Syntax: `system x`, `system[x]`

Where `x` is a char vector representing a system command and any parameters to it, executes the command and returns any result.

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

<i class="far fa-hand-point-right"></i> [System commands](../basics/syscmds.md)
