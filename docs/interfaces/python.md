---
title: Python client for kdb+ | Interfaces | kdb+ and q documentation
description: How to call kdb+ from Python
keywords: python, pykx, embedpy, api, ipc
---

# Python client for kdb+

**[KDB-X Python](https://code.kx.com/pykx/getting-started/installing.html)** (`pykx>=4.0`) is the Python interface for **[KDB-X](https://developer.kx.com/products/kdb-x/install)**, the evolution of kdb+. It exposes q as a domain-specific language (DSL) embedded within Python, and permits IPC connectivity from Python applications. It supports:

1. Storing, querying, manipulating and using q objects within a Python process.
2. Querying external KDB-X processes via an IPC interface.
3. Embedding Python functionality within a native q session via the under q functionality.

The previous [PyKX](https://code.kx.com/pykx/3.2/getting-started/installing.html) (`pykx<4.0`) is powered by kdb+. If you're migrating from PyKX to KDB-X Python, refer to the [migration guide](https://code.kx.com/pykx/upgrades/3040.html).

