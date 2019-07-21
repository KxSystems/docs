---
title: Starting kdb+ – a tutorial
description: A quick-start guide to kdb+, aimed primarily at those learning independently. It covers system installation, the kdb+ environment, IPC, tables and typical databases, and where to find more material.
hero: <i class="fas fa-graduation-cap"></i> Starting kdb+
keywords: kdb+, q, start, tutorial, 
---
# Starting kdb+





This is a quick-start guide to kdb+, aimed primarily at those learning independently. It covers system installation, the kdb+ environment, IPC, tables and typical databases, and where to find more material. After completing this you should be able to follow the Borror textbook [Q for Mortals](/q4m3), and the wiki [Reference](../../ref/index.md) and consult the [Knowledge base](../../kb/index.md).

One caution: you can learn kdb+ reasonably well by independent study, but for serious deployment of the product you need the help of a consultant. This is because kdb+ is typically used for very demanding applications that require experience to set up properly. Contact Kx for help with such evaluations.


## Kdb+

The kdb+ system is both a database and a programming language:
  
**kdb+** the database (_k database plus_).

**q** the programming language for working with kdb+


## Resources

### <i class="fas fa-globe"></i> code.kx.com

The best resource for learning q. It includes:

-   Jeff Borror’s textbook [Q for Mortals](/q4m3)
-   a [Knowledge Base](../../kb/index.md) of common tasks
-   a [Reference](../../ref/index.md) for the built-in functions
-   [interfaces](../../interfaces/index.md) with other languages and processes


### <i class="fab fa-github"></i> GitHub

- the [KxSystems](https://github.com/KxSystems) repositories
- [user-contributed repositories](https:///kxsystems.github.io)


### Other material

Several background articles and links can be found in the [Archive](../archive.md). For example, the Thalesians’ [Knowledge Base Kdb](http://www.thalesians.com/finance/index.php/Knowledge_Base/Databases/Kdb) has a good overview.


### Discussion groups

-   The main discussion forum is the [k4 Topicbox](https://k4.topicbox.com/groups/k4). This is available only to licensed customers – please use a work email address to [apply for access](https://k4.topicbox.com/groups/k4?subscription_form=e1ca20f8-95f6-11e8-8090-9973fa3f0106).
-   The [Kdb+ Personal Developers](http://groups.google.com/group/personal-kdbplus) forum is an open Google discussion group for users of the free system.


## Install free system

If you do not already have access to a licensed copy, go to [Get started](../index.md) to download and install q.


## Example files

Two sets of scripts are referenced in this guide:

1. The free system is distributed with the following example scripts in the main directory:

    -   sp.q – the Suppliers and Parts sample database
    -   trade.q – a stock trades sample database

    If you do not have these scripts, get them from 
    <i class="fab fa-github"></i> [KxSystems/kdb](https://github.com/KxSystems/kdb) 
    and save them in your `QHOME` directory.

2. Other example files are in the <i class="fab fa-github"></i> [KxSystems/cookbook/start](https://github.com/KxSystems/cookbook/tree/master/start) directory. 

    Move the `start` directory under your `QHOME` directory, e.g. `q/start`. For example, there should be a file:

    <pre><code class="language-txt">
    c:\q\start\buildhdb.q         / Windows
    ~/q/start/buildhdb.q          / Linux and macOS
    </code></pre>

!!! tip "Text editor for <i class="fab fa-windows"></i> Windows"

    Since q source is in plain text files, it is worth installing a good text editor such as Notepad++ or Notepad2.

    Some text editors have extensions to provide e.g. syntax highlighting for q. See the [list of editor integrations](../../interfaces/index.md#editor-integrations)


## Graphical user interface

When q is run, it displays a console where you can enter commands and see the results. This is all you need to follow the tutorial, and if you just want to learn a little about q, then it is easiest to work in the console.

As you become more familiar with q, you may try one of the GUIs.

-   Most popular is Charlie Skelton’s **Studio for kdb+**, a cross-platform execution environment – worth having available even if you use another interface  
<i class="fab fa-github"></i> [CharlesSkelton/studio](https://github.com/CharlesSkelton/studio)
-   [**qStudio**](http://timestored.com/qStudio), a cross-platform IDE with charting and autocompletion by TimeStored 
-   [First Derivatives](http://www.firstderivatives.com) offer their clients the **qIDE** development system
-   [Q and K Development Tools](http://www.qkdt.org) has an Eclipse plugin
-   [**Q Insight Pad**](http://www.qinsightpad.com) is an IDE for Windows
-   [**Qconsole**](source:contrib/cburke/qconsole "wikilink") is an IDE using GTK
-   [**JupyterQ**](../../ml/jupyterq/index.md) lets you run q inside a [Jupyter](http://jupyter.org/) notebook 

