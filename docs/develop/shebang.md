---
title: Execute a q script as a shebang script | Development | kdb+ and q documentation
description: Execute a q script as a shebang script
---
# Execute a q script as a shebang script


```bash
$ more ./test.q
#!/usr/bin/env q
2+3
\\
$ chmod +x ./test.q
$ ./test.q
KDB+ 3.1 2013.11.20 Copyright (C) 1993-2013 Kx Systems
l64/ ...
5
```

---
:fontawesome-solid-globe:
[Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix) "wikipedia")


