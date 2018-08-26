# `read1`




_Read bytes from a file or named pipe_

Syntax: `read1 x`, `read1[x]`

Where `x` has the form `(file; offset; length)`, returns corresponding bytes from `file`. 
Where only `file` is supplied, the content of the entire file is returned.

```q
q)`:test.txt 0:("hello";"goodbye")      / write some text to a file
q)read1`:test.txt                       / read in as bytes
0x68656c6c6f0a676f6f646279650a
q)"c"$read1`:test.txt                   / convert from bytes to char
"hello\ngoodbye\n"

q)/ read 500000 lines, chunks of (up to) 100000 at a time
q)d:raze{read1(`:/tmp/data;x;100000)}each 100000*til 5 
```

Since V3.4 you can specify how many bytes to read from a Fifo.

```q
q)h:hopen`$":fifo:///etc/redhat-release"
q)"c"$read1(h;8)
"Red Hat "
q)"c"$read1(h;8)
"Enterpri"
```


<i class="far fa-hand-point-right"></i>
[File system](../basics/files.md)
