---
title: Example usage | LDAP | Interfaces | Docuemntation for q and kdb+
author: Simon Shanks
description: Examples showing the use of the LDAP kdb+ interface
date: March 2020
---
# LDAP interface examples



:fontawesome-brands-github:
[KxSystems/ldap](https://github.com/KxSystems/ldap)

The scripts below are in the `examples` folder of the [interface](https://github.com/KxSystems/ldap/tree/master/examples). 
They provide insight into the different capabilities of the interface.

## Requirements

1. The LDAP interface installed as described in the interface’s [`README.md`](https://github.com/kxsystems/ldap/blob/master/README.md)
2. The folder `q/` containing `ldap.q` placed either in the examples folder or (preferably) in the your `QHOME` directory.


## Root DSE query

Queries the server’s `rootDSE`. Depending on the functionality your server supports, and its config, it may show attributes such as `supportedSASLMechanisms` (supported security mechanisms for use in bind). 

:fontawesome-solid-globe:
[Other attributes that may be populated](https://ldapwiki.com/wiki/RootDSE "ldapwiki.com") 

The `rootDSE` is often used to discover what functionality an LDAP server may support, and information to identify the type of LDAP server, e.g. vendor details. The `rootDSE` may be subject to access restrictions, so your server may require you to do a specific bind to retrieve these details.

The connection details within the script may need altering to communicate with your LDAP server.

```bash
q root_dse.q
```

## Search

Shows a search that works with the example LDAP server at: 

:fontawesome-brands-github:
[rroemhild/docker-test-openldapi](https://github.com/rroemhild/docker-test-openldapi)

The script includes searches such as searching for a user’s email. 
(This example server does not require a bind with user dn/password.)

```bash
q search.q
```