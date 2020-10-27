---
title: Serialize a table as an object | Documentation for q and kdb+
description: The simplest way to serialize a table is as a single object.
author: Stephen Taylor
date: October 202
---
# Serialize a table as an object



_The simplest way to serialize a table is as a single object._


## `save` and `load`

Keywords [`save`](../ref/save.md) and [`load`](../ref/load.md) let you serialize and write any q object to a file of the same name in the working directory. That includes tables, and is the simplest way to persist one.

```q
q)cities:([]city:`Tokyo`Delhi`Shanghai;pop:37435191 29399141 26317104)

q)key `:.                       / nothing in working directory
`symbol$()
q)save `cities
`:cities
q)key `:.                       / file in working directory
,`cities

q)delete cities from `.         / delete from memory
`.
q)cities
'cities
  [0]  cities
       ^

q)load `cities                  / load from filesystem
`cities
q)cities
city     pop
-----------------
Tokyo    37435191
Delhi    29399141
Shanghai 26317104
```

Perfect for casual use. For more organized writing and reading we need the keywords used to define `save` and `load`.


## `set` and `get`

Keywords [`set` and `get`](../ref/get.md) differ from `save` and `load`:

-   `set` is a binary; its left argument says where in the filesystem to write
-   `get` returns the table value rather than the name of the variable it has been assigned to

Notice the similarity of reading a value from memory to reading it from the filesystem.

```q
q)get `:cities                      / from filesystem
Tokyo   | 37435191
Delhi   | 29399141
Shanghai| 26317104

q)get `cities                       / from memory
city     pop
-----------------
Tokyo    37435191
Delhi    29399141
Shanghai 26317104

q)`:foo/bar/bigcities set cities
`:foo/bar/bigcities
q)get `:foo/bar/bigcities
city     pop
-----------------
Tokyo    37435191
Delhi    29399141
Shanghai 26317104
```


## Enumerations and foreign keys

The `city` column is a symbol vector, that is, an enumeration. It is represented in memory as indexes into the sym table. Serialization and deserialization survives the session’s sym list.

```q
KDB+ 4.0 2020.10.02 Copyright (C) 1993-2020 Kx Systems
m64/ 12()core 65536MB sjt mackenzie.local 127.0.0.1 EXPIRE ..

q)get `:foo/bar/bigcities
city     pop
-----------------
Tokyo    37435191
Delhi    29399141
Shanghai 26317104
```

Similarly for foreign keys, enumerated against another table.

```q
q)countries:([country:`China`India`Japan];cont:3#`Asia;code:86 91 81)
q)cities:([]
    city:`Tokyo`Delhi`Shanghai;
    country: `countries$`Japan`India`China;
    pop:37435191 29399141 26317104)
q)`:linked/countries`:linked/cities set'(countries;cities)
`:linked/countries`:linked/cities
q)\\

❯ q
KDB+ 4.0 2020.10.02 Copyright (C) 1993-2020 Kx Systems
m64/ 12()core 65536MB sjt mackenzie.local 127.0.0.1 EXPIRE ..

q)countries:get`:linked/countries
q)cities:get`:linked/cities
q)select city,pop,country.code from cities
city     pop      code
----------------------
Tokyo    37435191 81
Delhi    29399141 91
Shanghai 26317104 86
```


## Use cases

Serialization as an object suits a table that is

-    small relative to memory
-    frequently read 
-    has most of its columns required by most queries

----
:fontawesome-solid-database:
[Splayed tables](../kb/splayed-tables.md)

