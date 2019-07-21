---
title: Compacting the HDB sym file
description: Under some scenarios, the sym enum file in a HDB can become bloated – this is the sym file sitting in the root of the HDB folder. This is due to symbols no longer being used as earlier parts of a HDB may have been archived. Some users have expressed interest in being able to compact this sym enum file. This essentially requires re-enumeration of all enumerated columns against a new empty sym file. It can take some time to execute, and nothing else should try to read or write to the HDB area whilst this is running.
keywords: compact, hdb, kdb+, q
---
# Compacting the HDB sym file



Under some scenarios, the sym enum file in a HDB can become bloated – this is the sym file sitting in the root of the HDB folder. This is due to symbols no longer being used as earlier parts of a HDB may have been archived.

Some users have expressed interest in being able to compact this sym enum file. This essentially requires re-enumeration of all enumerated columns against a new empty sym file. It can take some time to execute, and nothing else should try to read or write to the HDB area whilst this is running.

The code below is for a vanilla HDB, with date partitions, a single enumeration (sym), and only splayed tables present.

This is an all-or-nothing approach. If you choose to run the code below, it is at your own risk, and you should make sure you understand everything it is doing, and test it against a dev HDB that you are happy to destroy in the event that it goes wrong.

This should really ever only be a one-off process. If you find that your sym file is growing beyond reasonable sizes, you very likely have non-repeating strings which would be better stored as char vectors than symbols. This process is not a fix for a poor choice of schema!

```q
/cd hdb
/q
system "mv sym zym";
`:sym set `symbol$(); / create a new empty sym file
files:key `:.;
dates:files where files like "????.??.??";
{[d]
  root:":",string d;
  tableNames:string key `$root;
  tableRoot:root,/:"/",/:tableNames;
  files:raze {`$x,/:"/",/:string key `$x}each tableRoot;
  files:files where not files like "*#";
  types:type each get each files;
  enumeratedFiles:files where types within 20 76h;
  / if we have more than one enum better get help
  if[any types within 21 76h;'"too difficult"];  
  {
      `sym set get `:zym;
      s:get x;
      a:attr s;
      s:value s;
      `sym set get `:sym;
      s:a#.Q.en[`:.;([]s:s)]`s;
      x set s;
      -1 "re-enumerated ", string x;
  }each enumeratedFiles;
 }each dates
```

!!! tip

    Remember to `rm` the zym file at the end of processing.


## Back up the sym file

The sym file is found in the root of your HDB.
It is the key to the default enums. 

!!! tip "Regularly back up the sym file _outside_ the HDB."


## Multi-threaded sym rewrite code

Here’s some multi-threaded (can run single threaded) and more memory-intensive but hugely faster sym file rewrite code that handles partitioned and splayed tables and `par.txt`. 

Note you lose the `` `g#``, which isn’t supported in threads, so you’ll have to apply it later.

```q
system"l ." /load the HDB - can change this if you don't start Q from your hdb root
allpaths:{[dbdir;table] / from dbmaint.q + an extra check for paths that exist (to support .Q.bv)
 files:key dbdir;
 if[any files like"par.txt";:raze allpaths[;table]each hsym each`$read0(`)sv dbdir,`par.txt];
 files@:where files like"[0-9]*";
 files:(`)sv'dbdir,'files,'table;
 files where 0<>(count key@)each files}
sym:oldSym:get`:sym /to unenumerate
symFiles:raze` sv/:/:raze{allpaths[`:.;x],/:\:exec c from meta[x] where t in "s"}peach tables[] where {1b~.Q.qp value x}each tables[] /sym files from parted tables
symFiles,:raze{` sv/: hsym[x],/:exec c from meta x where t in "s"}each tables[] where {0b~.Q.qp value x}each tables[] /sym files from splayed tables
allsyms:distinct raze{[file] :distinct @[value get@;file;`symbol$()] } peach symFiles; /symbol files we're dealing with - memory intensive
.Q.gc[] /memory intensive so gc
/*** the part above this line doesn't make changes to the HDB. You can estimate the savings with
/count[allsyms]%count sym
/*** the rest of the script makes changes so there is no going back once you start. There shouldn't be anything writing to the HDB while the script is in progress
system"mv sym zym" /make backup of sym file
`:sym set `symbol$() /reset sym file - scary part
`sym set get`:sym 
.Q.en[`:.;([]allsyms)] /enumerate all syms at once
{[file]
  s:get file; /file contents
  a:first `p`s inter attr s; /attributes - due to no`g# error in threads - this can be just a:attr s if your version of kdb+ does support setting `g# in threads
  s:oldSym`int$s; /unenumerate against old sym file
  file set a#`sym$s; /enumerate against new sym file & add attrib & write to disk
  0N!"re-enumerated ", string file;
  } peach symFiles
```

[<i class="fas fa-download"></i> 
Multi-threaded sym rewrite code](assets/multi-threaded-sym-rewrite-code.q)

!!! tip "Take backups!"

!!! warning "Error writing file?"

    In the multi-threaded script, a `'cast` could happen if this line fails on a file:

    <pre><code class="language-q">
    allsyms:distinct raze{[file] :distinct @[value get@;file;`symbol$()] } peach symFiles; 
    /symbol files we're dealing with - memory intensive
    </code></pre>

    So perhaps check the integrity of your HDB (perhaps change the above to help debug):

    <pre><code class="language-q">
    allsyms:distinct raze{[file] 
      :distinct @[value get@; file; {0N!(x;y); `symbol$()}[file;]] 
      } peach symFiles; 
    </code></pre>

    would print the file and error.


!!! tip 
    The script deliberately has no `;` at the end of lines. 
    It’s important you understand what’s going on, not just run the whole thing blindly.

