---
title: Compacting the HDB sym file – Knowledge Base – kdb+ and q documentation
description: Under some scenarios, the sym enum file in a HDB can become bloated – this is the sym file sitting in the root of the HDB folder. This is due to symbols no longer being used as earlier parts of a HDB may have been archived. Some users have expressed interest in being able to compact this sym enum file. This essentially requires re-enumeration of all enumerated columns against a new empty sym file. It can take some time to execute, and nothing else should try to read or write to the HDB area whilst this is running.
keywords: compact, hdb, kdb+, q
---
# Compacting the HDB sym file



Under some scenarios, the sym enum file sitting in the root of the HDB folder can become bloated with symbols no longer used since earlier parts of a HDB were archived.

To compact the file requires re-enumeration of all enumerated columns against a new empty sym file. That can take some time to execute; nothing else should  read or write to the HDB whilst this is running.

The code below is for a simple HDB, with 

-   date partitions
-   a single sym list
-   only splayed tables

!!! danger "Use at your own risk"

    This is an all-or-nothing approach. Run the code below at your own risk. 

    Ensure you understand what it does, and test it against a dev HDB you are happy to destroy in the event of an error.

This should really ever only be a one-time process. If you find your sym file growing beyond reasonable size, you very likely have non-repeating strings which would be better stored as char vectors than symbols. 

This process is not a fix for a poor choice of schema!

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

!!! tip "Remember to `rm` the zym file at the end of processing."


## Back up the sym file

The sym file is found in the root of your HDB.
It is the key to the default enums. 

!!! tip "Regularly back up the sym file _outside_ the HDB."


## Multi-threaded sym rewrite code

Here’s some multi-threaded (can run single threaded) and more memory-intensive but hugely faster sym file rewrite code that handles partitioned and splayed tables and `par.txt`. 

Note you lose the `` `g#``, which isn’t supported in threads, so you have to apply it later.

```q
system"l ." /load the HDB - can change this if you don't start q from your HDB root

allpaths:{[dbdir;table] 
  / from dbmaint.q + an extra check for paths that exist (to support .Q.bv)
  files:key dbdir;
  if[any files like"par.txt";
    :raze allpaths[;table]each hsym each`$read0(`)sv dbdir,`par.txt];
  files@:where files like"[0-9]*";
  files:(`)sv'dbdir,'files,'table;
  files where 0<>(count key@)each files}

sym:oldSym:get`:sym /to unenumerate

/sym files from parted tables
symFiles:raze` sv/:/:raze
  {allpaths[`:.;x],/:\:exec c from meta[x] where t in "s"} peach tables[] 
  where {1b~.Q.qp value x}each tables[]

/sym files from splayed tables
symFiles,:raze{` sv/: hsym[x],/:exec c from meta x where t in "s"}each tables[] 
  where {0b~.Q.qp value x}each tables[]

/symbol files we're dealing with - memory intensive
allsyms:distinct raze {[file] distinct @[value get@;file;`symbol$()]} peach symFiles

.Q.gc[] /memory intensive so gc

/
  The preceding code makes no changes to the HDB. 
  You can estimate the savings with count[allsyms]%count sym.
  The rest of the script makes changes; there is no going back once you start. 
  Let nothing write to the HDB while the script runs.
\

system"mv sym zym"      / make backup of sym file
`:sym set `symbol$()    / reset sym file - scary part
`sym set get`:sym 
.Q.en[`:.;([]allsyms)]  / enumerate all syms at once

{[file]
  s:get file;                       / file contents
  a:first `p`s inter attr s;        / attributes - due to no`g# error in threads
                                    / can be just a:attr s if your version of kdb+ 
                                    / supports setting `g# in threads
  s:oldSym`int$s;                   / unenumerate against old sym file
  file set a#`sym$s;                / enumerate against new sym; add attrib; write
  0N!"re-enumerated ", string file;
  } peach symFiles
```

[:fontawesome-solid-download: 
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


!!! tip "It’s important to understand what’s going on, not just run the whole thing blindly."

----
:fontawesome-regular-map:
[Working with sym files](../wp/symfiles.md)