---
title: hcount returns file size | Reference | q and KDB-X documentation
description: Keyword hcount returns the size in bytes of a file
author: KX Systems, Inc., a subsidiary of KX Software Limited
date: December 2019
---
# `hcount`

_Size of a file in bytes_

```syntax
hcount x     hcount[x]
```

Where `x` is a [file symbol](glossary.md#file-symbol),
returns as a long the size of the file.

```q
q)hcount`:c:/q/test.txt
42
```

On a compressed/encrypted file returns the size of the original uncompressed/unencrypted file.

----

[File system](files.md)
<br>

[File compression](../how_to/interact_with_databases/file-compression.md)
<br>

[Data at rest encryption (DARE)](../how_to/interact_with_databases/dare.md)
