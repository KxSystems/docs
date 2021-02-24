---
title: Example usage of interface | Arrow/Parquet interface
description: Examples of how to read and write Parquet files, Arrow files and Arrow streams from a kdb+ session
author: Neal McDonnell
date: February 2021
---
# Example usage of interface

_Examples of how to read and write Parquet files, Arrow files and Arrow streams from a kdb+ session_ 


The repository has examples with more functionality.

:fontawesome-brands-github: 
[KxSystems/arrowkdb/examples](https://github.com/KxSystems/arrowkdb/tree/master/examples)


## Inferred schemas

The data layout of an Arrow table is defined by its schema.  The schema is composed from a list of fields, one for each column in the table.  The field  describes the name of the column and its datatype.

If you are less familiar with Arrow or do not wish to use the more complex or nested Arrow datatypes, `arrowkdb` can infer the schema from a kdb+ table.  Each column in the table is mapped to a field in the schema.  The column’s name is used as the field name and the column’s kdb+ type is [mapped to an Arrow datatype](arrow-types.md#inferred-datatypes).


### Create a table

Create a kdb+ table contain temporal, floating, integer, boolean and string columns.

```q
// Create table with dummy data
q)N:5
q)table:([]tstamp:asc N?0p;temperature:N?100f;fill_level:N?100;pump_status:N?0b;comment:N?("start";"stop";"alert";"acknowledge";""))
q)table
tstamp                        temperature fill_level pump_status comment
------------------------------------------------------------------------
2001.11.14D02:41:59.687131048 40.31667    63         0           ""
2002.07.31D14:36:38.714581136 32.06061    75         1           "alert"
2003.01.09D08:10:33.261897408 57.81857    60         1           "start"
2003.03.03D18:09:25.390797712 57.62816    24         0           ""
2003.10.25D23:44:20.338068016 77.2916     37         1           "start"

// Pretty print the Arrow table populated from a kdb+ table
// The schema is inferred from the kdb+ table structure
q).arrowkdb.tb.prettyPrintTableFromTable[table]
tstamp: timestamp[ns] not null
temperature: double not null
fill_level: int64 not null
pump_status: bool not null
comment: string not null
----
tstamp:
  [
    [
      2001-11-14 02:41:59.687131048,
      2002-07-31 14:36:38.714581136,
      2003-01-09 08:10:33.261897408,
      2003-03-03 18:09:25.390797712,
      2003-10-25 23:44:20.338068016
    ]
  ]
temperature:
  [
    [
      40.3167,
      32.0606,
      57.8186,
      57.6282,
      77.2916
    ]
  ]
fill_level:
  [
    [
      63,
      75,
      60,
      24,
      37
    ]
  ]
pump_status:
  [
    [
      false,
      true,
      true,
      false,
      true
    ]
  ]
comment:
  [
    [
      "",
      "alert",
      "start",
      "",
      "start"
    ]
  ]
```


### Parquet files

Write the kdb+ table to a Parquet file then read it back

```q
// Use Parquet v2.0
// This is required otherwise the timestamp(ns) datatype will be converted to 
// timestamp(us) resulting in a loss of precision
q)parquet_write_options:(enlist `PARQUET_VERSION)!(enlist `V2.0)

// Write the table to a parquet file
q).arrowkdb.pq.writeParquetFromTable["inferred_schema.parquet";table;parquet_write_options]
q)show system "ls inferred_schema.parquet"
"inferred_schema.parquet"

// Read the parquet file into another table
q)new_table:.arrowkdb.pq.readParquetToTable["inferred_schema.parquet";::]

// Compare the kdb+ tables
q)show table~new_table
1b
```


### Arrow IPC files

Write the kdb+ table to an Arrow file then read it back

```q
// Write the table to an arrow file
q).arrowkdb.ipc.writeArrowFromTable["inferred_schema.arrow";table]
q)show system "ls inferred_schema.arrow"
"inferred_schema.arrow"

// Read the arrow file into another table
q)new_table:.arrowkdb.ipc.readArrowToTable["inferred_schema.arrow";::]

// Compare the kdb+ tables
q)show table~new_table
1b
```


### Arrow IPC streams

Write the kdb+ table to an Arrow stream then read it back

```q
// Serialize the table to an arrow stream
q)serialized:.arrowkdb.ipc.serializeArrowFromTable[table]
q)show serialized
0xffffffff500100001000000000000a000c000600050008000a000000000104000c000000080..

// Parse the arrow stream into another table
q)new_table:.arrowkdb.ipc.parseArrowToTable[serialized]

// Compare the kdb+ tables
q)show table~new_table
1b
```


## Constructed schemas

Although inferred schemas are easy to use, they support only a subset of the Arrow datatypes and are considerably less flexible. 
The inference works only for kdb+ tables where the columns contain simple datatypes. 
Only mixed lists of char arrays or byte arrays are supported, mapped to Arrow UTF8 and binary datatypes respectively.  Other mixed-list structures (e.g. those used by the nested arrow datatypes) cannot be interpreted.

More complex schemas should be manually constructed, in three steps:

1.  Create a datatype identifier for each column in the table by calling the appropriate datatype constructor
2.  Create a field identifier for each column in table by calling the field constructor, specifying the field’s name and its datatype identifier
3.  Create a schema identifier for the table by calling the schema constructor with the list of field identifiers


### Create the schema

For comparison we begin by creating explicitly the schema inferred above

```q
// Create the datatype identifiers
q)ts_dt:.arrowkdb.dt.timestamp[`nano]
q)f64_dt:.arrowkdb.dt.float64[]
q)i64_dt:.arrowkdb.dt.int64[]
q)bool_dt:.arrowkdb.dt.boolean[]
q)str_dt:.arrowkdb.dt.utf8[]

// Create the field identifiers
q)tstamp_fd:.arrowkdb.fd.field[`tstamp;ts_dt]
q)temp_fd:.arrowkdb.fd.field[`temperature;f64_dt]
q)fill_fd:.arrowkdb.fd.field[`fill_level;i64_dt]
q)pump_fd:.arrowkdb.fd.field[`pump_status;bool_dt]
q)comment_fd:.arrowkdb.fd.field[`comment;str_dt]

// Create the schema for the list of fields
q)schema:.arrowkdb.sc.schema[(tstamp_fd,temp_fd,fill_fd,pump_fd,comment_fd)]

// Print the schema
q).arrowkdb.sc.printSchema[schema]
tstamp: timestamp[ns] not null
temperature: double not null
fill_level: int64 not null
pump_status: bool not null
comment: string not null
```


### Create the array data

Create a mixed list of array data for each column in the table

```q
// Create data for each column in the table
q)tstamp_data:asc N?0p
q)temp_data:N?100f
q)fill_data:N?100
q)pump_data:N?0b
q)comment_data:N?("start";"stop";"alert";"acknowledge";"")

// Combine the data for all columns
q)array_data:(tstamp_data;temp_data;fill_data;pump_data;comment_data)

// Pretty print the Arrow table populated from the array data
q).arrowkdb.tb.prettyPrintTable[schema;array_data]
tstamp: timestamp[ns] not null
temperature: double not null
fill_level: int64 not null
pump_status: bool not null
comment: string not null
----
tstamp:
  [
    [
      2001-07-22 09:51:37.461634128,
      2001-10-03 11:56:09.607143848,
      2002-04-21 09:32:16.187244944,
      2002-05-14 18:23:48.381811824,
      2003-05-24 03:45:53.202889856
    ]
  ]
temperature:
  [
    [
      39.1543,
      8.12355,
      93.675,
      27.8212,
      23.9234
    ]
  ]
fill_level:
  [
    [
      23,
      12,
      66,
      36,
      37
    ]
  ]
pump_status:
  [
    [
      false,
      true,
      true,
      true,
      false
    ]
  ]
comment:
  [
    [
      "alert",
      "start",
      "alert",
      "",
      ""
    ]
  ]
```


### Parquet files

Write the schema and array data to a Parquet file then read them back

```q
// Use Parquet v2.0
// This is required otherwise the timestamp(ns) datatype will be converted to 
// timestamp(us) resulting in a loss of precision
q)parquet_write_options:(enlist `PARQUET_VERSION)!(enlist `V2.0)

// Write the schema and array data to a parquet file
q).arrowkdb.pq.writeParquet["constructed_schema.parquet";schema;array_data;parquet_write_options]
q)show system "ls constructed_schema.parquet"
"constructed_schema.parquet"

// Read the schema back from the parquet file
q)new_schema:.arrowkdb.pq.readParquetSchema["constructed_schema.parquet"]

// Compare the schemas
q)show .arrowkdb.sc.equalSchemas[schema;new_schema]
1b
q)show schema~new_schema
1b

// Read the array data back from the parquet file
q)new_array_data:.arrowkdb.pq.readParquetData["constructed_schema.parquet";::]

// Compare the array data
q)show array_data~new_array_data
1b
```


### Arrow IPC files

Write the schema and array data to an Arrow file then read them back

```q
// Write the schema and array data to an arrow file
q).arrowkdb.ipc.writeArrow["constructed_schema.arrow";schema;array_data]
q)show system "ls constructed_schema.arrow"
"constructed_schema.arrow"

// Read the schema back from the arrow file
q)new_schema:.arrowkdb.ipc.readArrowSchema["constructed_schema.arrow"]

// Compare the schemas
q)show .arrowkdb.sc.equalSchemas[schema;new_schema]
1b
q)show schema~new_schema
1b

// Read the array data back from the arrow file
q)new_array_data:.arrowkdb.ipc.readArrowData["constructed_schema.arrow";::]

// Compare the array data
q)show array_data~new_array_data
1b
```

### Arrow IPC streams

Write the schema and array data to an Arrow stream then read them back

```q
// Serialize the schema and array data to an arrow stream
q)serialized:.arrowkdb.ipc.serializeArrow[schema;array_data]
q)show serialized
0xffffffff500100001000000000000a000c000600050008000a000000000104000c000000080..

// Parse the schema back for the arrow stream
q)new_schema:.arrowkdb.ipc.parseArrowSchema[serialized]

// Compare the schemas
q)show .arrowkdb.sc.equalSchemas[schema;new_schema]
1b
q)show schema~new_schema
1b

// Read the array data back from the arrow file
q)new_array_data:.arrowkdb.ipc.parseArrowData[serialized]

// Compare the array data
q)show array_data~new_array_data
1b
```


## Constructed schemas with nested datatypes

Nested datatypes are constructed in two ways:

1.  List, Map and Dictionary datatypes are specified in terms of their child datatypes
2.  Struct and Union datatypes are specified in terms of their child fields

Continuing with the constructed schemas example, we update the schema as follows:

-   The `temperature` and `fill_level` fields will be combined under a struct datatype
-   The `utf8` `comment` field will be replaced with a `list<utf8>` field so that each array item can store multiple comments


### Create the schema

Create the new schema, reusing the datatype and field identifiers from the previous example

```q
// Taken from previous example:
q)ts_dt:.arrowkdb.dt.timestamp[`nano]
q)f64_dt:.arrowkdb.dt.float64[]
q)i64_dt:.arrowkdb.dt.int64[]
q)bool_dt:.arrowkdb.dt.boolean[]
q)str_dt:.arrowkdb.dt.utf8[]
q)tstamp_fd:.arrowkdb.fd.field[`tstamp;ts_dt]
q)temp_fd:.arrowkdb.fd.field[`temperature;f64_dt]
q)fill_fd:.arrowkdb.fd.field[`fill_level;i64_dt]
q)pump_fd:.arrowkdb.fd.field[`pump_status;bool_dt]

// Create a struct datatype which bundles the temperature and fill level fields
q)struct_dt:.arrowkdb.dt.struct[(temp_fd,fill_fd)]

// Create a list datatype which repeats the utf8 datatype
q)list_dt:.arrowkdb.dt.list[str_dt]

// Create the struct and list field identifiers
q)sensors_fd:.arrowkdb.fd.field[`sensors_data;struct_dt]
q)multi_comments_fd:.arrowkdb.fd.field[`multi_comments;list_dt]

// Create the nested schema
q)nested_schema:.arrowkdb.sc.schema[(tstamp_fd,sensors_fd,pump_fd,multi_comments_fd)]

// Print the schema
q).arrowkdb.sc.printSchema[nested_schema]
tstamp: timestamp[ns] not null
sensors_data: struct<temperature: double not null, fill_level: int64 not null> not null
pump_status: bool not null
multi_comments: list<item: string> not null
```


### Create the array data

Create a mixed list of array data, reusing the data from the previous example

```q
// Taken from previous example:
q)tstamp_data:asc N?0p
q)temp_data:N?100f
q)fill_data:N?100
q)pump_data:N?0b

// The sensors struct array data is composed from its child arrays
q)sensors_data:(temp_data;fill_data);

// Generate the multi-comments array data as lists of strings
q)getCommentsSet:{[]
    n:(1?5)[0]+1;
    enlist (n?("start";"stop";"alert";"acknowledge"; ""))
    }
q)multi_comments_data:getCommentsSet[]
q)x:N
q)while[x-:1;multi_comments_data:multi_comments_data,getCommentsSet[]]

// Combine the arrays data for all columns, including the struct and list data
q)nested_array_data:(tstamp_data;sensors_data;pump_data;multi_comments_data)

// Pretty print the Arrow table populated from the array data
q).arrowkdb.tb.prettyPrintTable[nested_schema;nested_array_data]
tstamp: timestamp[ns] not null
  -- field metadata --
  PARQUET:field_id: '1'
sensors_data: struct<temperature: double not null, fill_level: int64 not null> not null
  child 0, temperature: double not null
    -- field metadata --
    PARQUET:field_id: '2'
  child 1, fill_level: int64 not null
    -- field metadata --
    PARQUET:field_id: '3'
pump_status: bool not null
  -- field metadata --
  PARQUET:field_id: '4'
multi_comments: list<item: string> not null
  child 0, item: string
----
tstamp:
  [
    [
      2000-08-25 19:14:03.975714596,
      2002-10-02 20:42:32.814873312,
      2002-11-29 09:25:44.198182224,
      2003-04-09 17:45:03.539744768,
      2003-06-20 20:19:57.851794208
    ]
  ]
sensors_data:
  [
    -- is_valid: all not null
    -- child 0 type: double
      [
        75.201,
        10.8682,
        95.9896,
        3.66834,
        64.3098
      ]
    -- child 1 type: int64
      [
        52,
        66,
        24,
        60,
        69
      ]
  ]
pump_status:
  [
    [
      false,
      true,
      true,
      true,
      true
    ]
  ]
multi_comments:
  [
    [
      [
        "alert",
        "alert",
        "start",
        "stop"
      ],
      [
        "start"
      ],
      [
        "acknowledge"
      ],
      [
        "stop",
        "alert",
        "acknowledge",
        "acknowledge",
        ""
      ],
      [
        "stop",
        "alert",
        "stop",
        "",
        ""
      ]
    ]
  ]
```

It is left as an exercise to write the schema and array data to Parquet or Arrow files. 

??? tip "Remember to use Parquet v2.0"

    Otherwise the `timestamp(ns)` datatype will be converted to `timestamp(us)` resulting in a loss of precision.