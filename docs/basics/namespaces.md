---
title: Namespaces | Basics | kdb+ and q documentation
description: Namespaces are containers within the kdb+ workspace. Namespaces are a convenient way to divide an application between modules.
author: Stephen Taylor
---
# Namespaces





Namespaces are containers within the kdb+ workspace.
Names defined in a namespace are unique only within the namespace.

Namespaces are a convenient way to divide an application between modules; also to construct and share library code.

Namespaces are identified by a leading dot in their names.


## System namespaces

Kdb+ includes the following namespaces.

namespace       | contents
----------------|------------------------------------------------
[`.h`](../ref/doth.md) | Functions for converting files into various formats and for web-console display
[`.j`](../ref/dotj.md) | Functions for converting between JSON and q dictionaries
[`.m`](../ref/dotm.md) | Objects in memry domain 1
[`.Q`](../ref/dotq.md) | Utility functions
[`.q`](../ref/dotq.md) | Definitions of q keywords
[`.z`](../ref/dotz.md) | System variables and functions, and hooks for callbacks

The linked pages document some of the objects in these namespaces. 
(Undocumented objects are part of the namespace infrastructure and should not be used in kdb+ applications.) 

!!! warning "These and all single-character namespaces are reserved for use by KX."


## Names

Apart from the leading dot, namespace names follow the same rules as names for q objects.

Outside its containing namespace, an object is known by the full name of its containing namespace followed by a dot and its own name. 

Namespaces can contain other namespaces.

Thus `.fee.fi.fo`  is the name of object `fo` within namespace `fi` within namespace `foo`. 


## Dictionaries

Namespaces are implemented as dictionaries. 
To list the objects contained in namespace `.foo`:

```q
key `.foo
```

To list all the namespaces in the root:

```q
key `
```


## Construction

Referring to a namespace is sufficient to create it.

```q
q)key `
`q`Q`h`j`o
q).fee.fi.fo:42
q)key `
`q`Q`h`j`o`fee
q)key `.fee
``fi
q)key `.fee.fi
``fo
```

----
:fontawesome-solid-book-open:
[`\d`](syscmds.md#d-directory)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§12 Workspace Organization](/q4m3/12_Workspace_Organization/)