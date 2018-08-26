# `hsym`



_Convert symbol to file handle_

Syntax: `hsym x`,`hsym[x]`

Converts symbol `x` into a file name, or valid hostname, or IP address. Since V3.1, `x` can be a symbol list.

```q
q)hsym`c:/q/test.txt
`:c:/q/test.txt
q)hsym`10.43.23.197
`:10.43.23.197
```


<i class="far fa-hand-point-right"></i>
[File system](../basics/files.md)
