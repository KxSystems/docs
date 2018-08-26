# 1. Introduction


## 1.1 Overview

This is a quick start guide to kdb+, aimed primarily at those learning independently. It covers system installation, the kdb+ environment, IPC, tables and typical databases, and where to find more material. After completing this you should be able to follow the Borror textbook [Q for Mortals](http://code.kx.com/q4m3), and the wiki [Reference](/ref) and [Knowledge Base](/kb/).

One caution: you can learn kdb+ reasonably well by independent study, but for serious evaluation of the product you need the help of a consultant. This is because kdb+ is typically used for very demanding applications that require experience to set up properly. Contact Kx Systems or one of its partners for help with such evaluations.


## 1.2 Kdb+

The kdb+ system is both a database and a programming language:
  
**kdb+** the database (_k database plus_).

**q** the programming language for working with kdb+

Both kdb+ and q are written in the k programming language. You do not need to know k to work with kdb+, but will occasionally see references to it. For example, q is defined in the distributed script q.k.


## 1.3 Resources

### code.kx.com

This site is the best resource for learning q, and includes:

- Jeff Borror’s textbook [Q for Mortals](http://code.kx.com/q4m3)
- the [Knowledge Base](/kb/)
- a [reference](/ref) for the built-in functions
- [interfaces](/interfaces) with other languages and processes


### <i class="fab fa-github"></i> GitHub

- the [KxSystems](https://github.com/KxSystems) repositories
- [user-contributed repositories](https:///kxsystems.github.io)


<!--
### Kx Html Pages

Some older, but still useful, html pages are at [kx.com/documentation.php](http://kx.com/documentation.php). 
See in particular, Dennis Shasha’s <i class="fab fa-github"></i> [Kdb+ Database and Language Primer](https://github.com/KxSystems/kdb/blob/master/d/primer.htm).
-->


### Other material

Several background articles and links can be found in the [Archive](/archive). For example, the Thalesians’ [Knowledge Base Kdb](http://www.thalesians.com/finance/index.php/Knowledge_Base/Databases/Kdb) has a good overview.


### Discussion groups

- The main discussion forum is the [k4 listbox](http://www.listbox.com/subscribe/?listname=k4). This is available only to licensed customers – please use a work email address to apply for access.
- The [Kdb+ Personal Developers](http://groups.google.com/group/personal-kdbplus) forum is an open Google discussion group for users of the free 32-bit system.

<!--
### Additional files

The [kx.com/q](http://www.kx.com/q) directory has various supporting files, for example the script sp.q referenced in this guide (which is also included with the free 32-bit system). These files are also copied to the svn repository, so for example, the sp.q script can also be found at [kx/kdb+/sp.q](source:kx/kdb%2B/sp.q "wikilink").
-->


## 1.4 Install free 32-bit system

If you do not already have access to a licensed copy, go to [Get started](/learn) to download and install q.


## 1.5 Example files

Two sets of scripts are referenced in this guide:

1. The free 32-bit system is distributed with the following example scripts in the main directory:

    - sp.q – the Suppliers and Parts sample database
    - trade.q – a stock trades sample database

    If you do not have these scripts, get them from <i class="fab fa-github"></i> [KxSystems/kdb](https://github.com/KxSystems/kdb) and save them in your q directory.

2. Other example files are in the <i class="fab fa-github"></i> [KxSystems/cookbook/start](https://github.com/KxSystems/cookbook/tree/master/start) directory. 

    Move the start directory under your q directory, i.e. q/start. For example, there should be a file:
    ```
    c:\q\start\buildhdb.q         / Windows
    ~/q/start/buildhdb.q          / Linux and macOS
    ```

!!! tip "Text editor for Windows"
    <i class="fab fa-windows"></i> Since q source is in plain text files, it is worthwhile installing a good text editor such as Notepad++ or Notepad2.


## 1.6 GUI

When q is run, it displays a console where you can enter commands and see the results. This is all you need to follow the tutorial, and if you just want to learn a little about q, then it is easiest to work in the console.

As you become more familiar with q, you may try one of the GUIs.

- Most popular is Charlie Skelton’s **Studio for kdb+**, a cross-platform execution environment – worth having available even if you use another interface  
<i class="fab fa-github"></i> [CharlesSkelton/studio](https://github.com/CharlesSkelton/studio)
- [**qStudio**](http://timestored.com/qStudio), a cross-platform IDE with charting and autocompletion by TimeStored 
- [First Derivatives](http://www.firstderivatives.com) offer their clients the **qIDE** development system
- [Q and K Development Tools](http://www.qkdt.org) has an Eclipse plugin
- [**Q Insight Pad**](http://www.qinsightpad.com) is an IDE for Windows
- [**Qconsole**](source:contrib/cburke/qconsole "wikilink") is an IDE using GTK
- [**PyQ**](http://pyq.enlnt.com/slides) lets you run q inside a [Jupyter](http://jupyter.org/) notebook 

