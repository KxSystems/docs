---
title: Namespaces
description: Namespaces are containers within the kdb+ workspace. Names defined in a namespace are unique only within the namespace. Namespaces are a convenient way to divide an application between modules; also to construct and share library code.
author: Stephen Taylor
keywords: kdb+, namespaces, q
---
# Namespaces





Namespaces are containers within the kdb+ workspace.
Names defined in a namespace are unique only within the namespace.

Namespaces are a convenient way to divide an application between modules; also to construct and share library code.

Namespaces are identified by a leading dot in their names.

Kdb+ includes the following namespaces.

namespace       | contents
----------------|------------------------------------------------
[`.h`](../ref/doth.md) | Functions for converting files into various formats and for web-console display
[`.j`](../ref/dotj.md) | Functions for converting between JSON and q dictionaries
[`.Q`](../ref/dotq.md) | Utility functions
[`.q`](../ref/dotq.md) | Definitions of q keywords
[`.z`](../ref/dotz.md) | System variables and functions, and hooks for callbacks

The linked pages document some of the objects in these namespaces. 
(Undocumented objects are part of the namespace infrastructure and should not be used in kdb+ applications.) 

!!! warning "These and all single-character namespaces are reserved for use by Kx."