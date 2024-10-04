# Historical database (HDB) analysis and maintenance

The historical database (hdb) is the backbone of the vast majority of kdb+ systems. This is the location for data storage (typically at the end of the day, sometimes intraday) and for fast retrieval later on (handling system/user queries). Maintaining the integrity of the hdb is crucial to any system functioning efficiently. There are two main aspects of a hdb, the sym file and the data itself. Others have already covered the importance of the sym file (https://code.kx.com/q/wp/symfiles), this paper will cover data quality and structural integrity.

There are many ways that a hdb can be broken, some less obvious than others. Investigating and analysing a broken hdb is a skill that all kdb+ deveolpers should have. However, this paper will aim to make this task easier by providing a utility script to assist with some common scenarios. The reader's familiarity with the hdb structure and its contents are assumed.

The script itself is broken into 3 components - analysis, maintenance and warnings.
1. Analysis interrogates and reports on issues found in the hdb
1. Maintenance attempts to fix any issues reported in the analysis section
1. Warnings will report issues that are beyond the scope of this paper to fix, or issues that might not break the hdb, but cause performance degradation if not rectified.
   
The analysis and appropriate maintenance will be covered together, followed by the warnings.

Let's first create a somewhat realistic hdb using the script provided in the Kx repository: https://github.com/KxSystems/cookbook/blob/master/start/buildhdb.q.

```bash
$ curl https://raw.githubusercontent.com/KxSystems/cookbook/master/start/buildhdb.q > $QHOME/buildhdb.q
$ q buildhdb.q
$ cd start/db
```

and download the script itself:

```bash
$ curl https://raw.githubusercontent.com/cillianreilly/qtools/master/start/ham.q > $QHOME/ham.q
```

Let's examine the inputs to the script and some of the functionalites before we get started:

```q

$ q ham.q -q

usage: q ham.q <path to hdb> -tables [tables] -par [partitions] -level [0-8] -dbmaint [01]
path to hdb is mandatory. all other flags are optional and defaults are described below
tables : tables to analyse. default is all partitioned tables in the hdb
par    : partitions to analyse. default is all partitions in the hdb, otherwise restricts using .Q.view
dbmaint: perform maintenance on the hdb. default is 0 (no maintenance)
level  : level of analysis, least to most intensive. default is 6
      0: check if specified tables exist in specified partitions
      1: check if .d files exist in specified partitions
      2: check if partition field (.Q.pf) exists in the .d file per partiton
      3: check if partition field (.Q.pf) exists on disk per partition
      4: check if all columns in the .d file exist in the same partition
      5: check if all columns from the latest partition exist in each partition
      6: check if the order of columns per partition matches that of the latest partition
      7: check if the column types per partition match that of the latest partition
      8: check if column counts are consistent across columns per partition
wlevel : level of warnings, least to most intensive. default is 2
      0: check if enumeration files exist in the hdb root e.g. sym
      1: check if all columns on disk exist in the .d file of the same partition
      2: check if all column attributes match those of the latest partition
      2: check if all foreign keys match those of the latest partition
```

Some of the utility functions exposed in the script are described here. Given a table name as input, `paths` and `dotd` return all paths to the table folder on disk and all the paths to the `.d` files espectively. `lastpath` and `lastdotd` return the last of these values respectively. The last partition is important, as this is the partition that kdb uses to build metadata from. It is assumed that the last partition is correct.

```q
q)paths`trade
`:./2013.05.01/trade`:./2013.05.02/trade`:./2013.05.03/trade`:./2013.05.06..
q)dotd`trade
`:./2013.05.01/trade/.d`:./2013.05.02/trade/.d`:./2013.05.03/trade/.d`:./2..
q)lastpath`trade
`:./2013.05.31/trade
q)lastdotd`trade
`:./2013.05.31/trade/.d
```

The `init` function runs the script. This calls several functions; in order:
* `lh` - load hdb; attempts to load the specified hdb and prints some general information if successful. Exits on failure.
* `pa` - parse arguments; parse command line arguments and supply defaults values, these are documented above.
* `rp` - restrict partitions; attempts to restrict the hdb view using `.Q.view`, but always includes the last partiton found on disk. Exits on failure.
* `ra` - run analysis; runs each of the `al?` functions found and populates the analysis results table (`ar`).
* `rw` - run warnings; runs each of the `wl?` functions found and populates the warning results table (`wr`).
* `ld` - load dbmaint; attempts to load `dbmaint.q`. Only called if the `dbmaint` flag is true. Exits on failure.
* `rm` - run maintenance; details below.
  
Most of the functions above are simple to follow, but some more information on the `rm` function here. The `rm` function takes a single argument, the analysis results table generated by `ar`. It first finds the lowest level of failure in the results table (exits early if none), then re-runs the analysis at that level. This is done as it may be the case that a lower level of maintenance has already resolved the issue at a higher level; in which case, there is no work to be done. If the issue persists, it will run the appropriate maintenance function. Finally, it will re-run the analysis at that level to confirm if the maintenance was successful. We iterate `rm` over the analysis results table; the iteration will be halted when either:

* there are no more failures to be rectified or
* maintenance has failed for a given level, and the analysis functions returns the same results as in the initial investigation

## Analysis and maintenance

### Level 0

Level 0 starts with the very basic - does the table exist in the partition in question? This manifests itself as a 'No such file or directory error' of the first column listed in the `.d` file of the latest partition.

```q
$ rm -r 2013.05.01/trade
$ q .
q)select from trade where date=2013.05.01
'./2013.05.01/trade/sym. OS reports: No such file or directory
  [0]  select from trade where date=2013.05.01
              ^
```

We can investigate the existence of files and folders from within kdb+ using the `key` keyword: https://code.kx.com/q/ref/key. For folders, `key` returns the folder name if it exists, or an empty general list otherwise. Counting the result is suffficient to tell us whether the folder exists. We wrap this into an `exists` helper function. `al0` (analysis level 0) takes a list or table names, and returns a dictionary of tables vs partitions that the table is missing from, if any. We index the variable `.Q.pv` to find the affected partitons: https://code.kx.com/q/ref/dotq/#pv-modified-partition-values
```q

exists:0<count key@
al0:{
        .log.out"analysis level 0: checking existence of table(s)...";
        t:x!.Q.pv where each not exists each'paths each x;
        if[any 0<count each t;.log.err"analysis level 0: table(s) missing from partition(s):";show t];
        t
        }
```
```

q)al0`trade`quote;
2024.05.18D07:34:20.041765 ### OUT ### analysis level 0: checking existence of table(s)...
2024.05.18D07:34:20.047586 ### ERR ### analysis level 0: table(s) missing from partition(s):
trade| ,2013.05.01
quote| `date$()
```

Maintenance for this is to run `.Q.chk` ( https://code.kx.com/q/ref/dotq/#chk-fill-hdb) against the hdb location. However, note that `.Q.chk` does not respect `.Q.view`, it will fill ALL partitions that it finds in the hdb directory. The maintenance functions take a table as input - the results table from analysis.

```q
ml0:{
        .log.out"maintenance level 0: running .Q.chk against hdb location...";
        .log.wrn"maintenance level 0: .Q.chk does not respect .Q.view - filling ALL partitions...";
        p:@[.Q.chk;`:.;{.log.err"error running .Q.chk: ",x;exit 1}];
        .log.out"maintenance level 0: successfully filled ",string[sum not()~/:p]," partition(s)";
        }
```

```q
q)ar
level| nbbo quote trade
-----| ---------------------
0    |            2013.05.01
q)ml0 ar
2024.05.18D07:50:24.687255 ### OUT ### maintenance level 0: running .Q.chk against hdb location...
2024.05.18D07:50:24.687335 ### WRN ### maintenance level 0: .Q.chk does not respect .Q.view - filling ALL partitions...
2024.05.18D07:50:24.701683 ### OUT ### maintenance level 0: successfully filled 1 partition(s)
q)exists`:2013.05.01/trade
1b
```

### Level 1

Does the `.d` file exist for all partitions? If the `.d` file is missing for a partition other than the last partition, queries can still be performed against the bad partition, as kdb+ will reference the `.d` file from the last partition to order the columns in the result:

```q
$ rm 2013.05.02/trade/.d
$ q .
q)count select from trade where date in 2013.05.02
26143
```

However, if an attempt is made to restrict the hdb such that a partition missing the `.d` file is the latest, then kdb+ will error:

```q
q).Q.view 2013.05.01 2013.05.02
'./2013.05.02/trade/.d. OS reports: No such file or directory
  [0]  .Q.view 2013.05.01 2013.05.02
       ^
```

We can again investigate the existence of the `.d` files using the `exists` function. 

```q
al1:{
        .log.out"analysis level 1: checking existence of .d file(s)...";
        d:x!.Q.pv where each not exists each'dotd each x;
        if[any 0<count each d;.log.err"analysis level 1: .d file missing from partition(s):";show d];
        d
        }
```

```q
q)al1`trade`quote;
2024.05.18D10:09:28.620940 ### OUT ### analysis level 1: checking existence of .d file(s)...
2024.05.18D10:09:28.622678 ### ERR ### analysis level 1: .d file missing from partition(s):
trade| ,2013.05.02
quote| `date$()
```

To fix this, we create the `.d` files by populating them with the intersection of columns from the latest `.d` file and the columns found on disk in that partition. Note that we don't populate them with the only the columns from the latest partition - further analysis will handle any discrepancies here. The `inter` keyword respects the ordering of the elements in the right argument, we use the value of the last `.d` file here:

```q
ml1:{
        .log.out"maintenance level 1: populating .d file(s) with columns found in partition...";
        x:dde x 1;
        d:dotd each key x;
        c0:(get last@)each d;
        (d@'i)set''c0 inter/:'key each'(paths each key x)@'i:.Q.pv?value x;
        .log.out"maintenance level 1: successfully wrote ",string[sum count each x]," .d file(s)";
        }
```

```q
q)ar
level| nbbo quote trade
-----| ----------------------
0    |            `date$()
1    |            ,2013.05.02
q)ml1 ar
2024.05.18D10:18:24.105649 ### OUT ### maintenance level 1: populating .d file(s) with columns found in partition...
2024.05.18D10:18:24.107472 ### OUT ### maintenance level 1: successfully wrote 1 .d file(s)
q)exists`:2013.05.02/trade/.d
1b
```

### Level 2

Does the partition field exist as a column in the `.d` file? The partition field column should be a virtual column in the table - it should not appear in the `.d` file. Queries against such a partition can still be performed, but again, if an attempt is made to restrict the hdb such that a bad partition is the latest, then trouble will arise:

```q
q)@[`:2013.05.03/trade;`.d;,;`date]
`:2013.05.03/trade
q)\l .
q)count select from trade where date in 2013.05.03
26592
q).Q.view 2013.05.01 2013.05.02 2013.05.03
q)select from trade where date in 2013.05.03
'./2013.05.03/trade/date. OS reports: No such file or directory
  [0]  select from trade where date in 2013.05.03
              ^
q))\
q)meta trade
'./2013.05.03/trade/date. OS reports: No such file or directory
  [0]  meta trade
       ^
```

Investigation for this is simple to carry out. The variable `.Q.pf` https://code.kx.com/q/ref/dotq/#pf-partition-field contains the name of the partition field and the `in` keyword will tell us if it appears within the contents of a `.d` file.

```q
al2:{
        .log.out"analysis level 2: checking if partition field (",string[.Q.pf],") exists in .d file...";
        d:x!.Q.pv where each .Q.pf in''@[get;;`]each'dotd each x;
        if[any 0<count each d;.log.err"analysis level 2: partition field (",string[.Q.pf],") exists in .d file of partition(s):";show d];
        d
        }
```

```q
q)al2 `trade`quote;
2024.05.19D06:46:42.803356 ### OUT ### analysis level 2: checking if partition field (date) exists in .d file...
2024.05.19D06:46:42.805967 ### ERR ### analysis level 2: partition field (date) exists in .d file of partition(s):
trade| ,2013.05.03
quote| `date$()
```

Fixing this is just a matter of removing the offending column from the `.d` file using the `except` keyword. Note that we don't use dbamint's `deletecol` functionality here, as that expects the column to appear both in the `.d` file and on disk. This level of analysis is only concerned with `.d` files.

```q
ml2:{
        .log.out"maintenance level 2: removing partition field (",string[.Q.pf],") from .d file...";
        x:dde x 2;
        {x set except[;.Q.pf]get x}each'(dotd each key x)@'.Q.pv?value x;
        .log.out"maintenance level 2: successfully partition field from ",string[sum count each x]," .d files";
        }
```

```q
ar
level| nbbo quote trade
-----| ----------------------
0    |            `date$()
1    |            `date$()
2    |            ,2013.05.03
q)ml2 ar
2024.05.19D06:52:56.264742 ### OUT ### maintenance level 2: removing partition field (date) from .d file(s)...
2024.05.19D06:52:56.264881 ### OUT ### maintenance level 2: successfully removed partition field (date) from 1 .d file(s)
```

### Level 3

Does the partition field exist on disk in the partition? Similar to the level above, the partition field should be virtual. In this case, the existence of the column won't break the hdb, but it's still best practice that it doesn't exist on disk.

```q
q)c:2 first/select count i from trade where date in 2013.05.06
q)`:2013.05.06/trade/date set c#2013.05.06
`:2013.05.06/trade/date
```

This is also very straight forward to investigate. We create the path to each of the column files and then test for existence using our `exists` function:

```q
al3:{
        .log.out"analysis level 3: checking if partition field (",string[.Q.pf],") exists on disk...";
        d:x!.Q.pv where each exists each'paths each x,'.Q.pf;
        if[any 0<count each d;.log.err"analysis level 3: partition field (",string[.Q.pf],") exists on disk in partition(s):";show d];
        d
        }
```

```q
a)al3`trade`quote;
2024.05.22D03:50:37.804104 ### OUT ### analysis level 3: checking if partition field (date) exists on disk...
2024.05.22D03:50:37.809343 ### ERR ### analysis level 3: partition field (date) exists on disk in partition(s):
trade| ,2013.05.06
quote| `date$()
```

Remedying this is a matter of removing the column from disk. To do this, we leverage some of the functionality exposed by the `dbamint` script: `.os.del`. This is a wrapper around the appropriate operating system command to delete a file. Again, we don't use the `deletecol` function, as this expects the column to exist on disk and in the `.d` file. This analysis is only concerned with the existence of the column on disk.

```q
ml3:{
        .log.out"maintenance level 3: removing partition field (",string[.Q.pf],") file(s) from disk...";
        x:dde x 3;
        .os.del each'(paths each key[x],'`date)@'.Q.pv?value x;
        .log.out"maintenance level 3: successfully removed ",string[sum count each x]," partition field file(s) from disk";
        }
```

```q
q)ar
level| nbbo quote trade
-----| ----------------------
0    |            `date$()
1    |            `date$()
2    |            `date$()
3    |            ,2013.05.06
q)ml3 ar
2024.05.22D03:56:11.571042 ### OUT ### maintenance level 3: removing partition field (date) file(s) from disk...
2024.05.22D03:56:11.580781 ### OUT ### maintenance level 3: successfully removed 1 partition field file(s) from disk
```

### Level 4

Moving on from the partition field analysis, we now examine the contents of the `.d` file compared to the columns found on disk - these should be consistent. Similar to previous levels, this can cause issues, not immediately, but later on:

```q
q){x set get[x],`missingCol}`:2013.05.07/trade/.d
`:2013.05.07/trade/.d
q)\l .
q)count select from trade where date in 2013.05.07
27229
q).Q.view 2013.05.03 2013.05.06 2013.05.07
q)select from trade where date in 2013.05.07
'./2013.05.07/trade/missingCol. OS reports: No such file or directory
  [0]  select from trade where date in 2013.05.07
              ^
```

The investigation for this is straightforward, compare the columns on disk (returned by `key` and `paths`) to the content of the `.d` files (returned by `get` and `dotd`). The `except` keyword will return anything listed in `.d`, but not found on disk.

```q
al4:{
        .log.out"analysis level 4: comparing contents of .d file(s) to columns in the same partition...";
        c:key each'paths each x;
        d:@[get;;1#`]each'dotd each x;
        d:x!dde each .Q.pv!/:d except''c;
        if[any 0<count each d;.log.err"analysis level 4: .d file specifies columns not found in the same partition:";show d];
        d
        }
```

```q
q)al4`trade`quote;
2024.05.23D12:50:09.058624 ### OUT ### analysis level 4: comparing contents of .d file(s) to columns in the same partition...
2024.05.23D12:50:09.068628 ### ERR ### analysis level 4: .d file specifies columns not found in the same partition:
trade| (,2013.05.07)!,,`missingCol
quote| (`date$())!()
```

To fix this, we can simply remove the offending column from the `.d` file. Note, we can't use the `addcol` functionality offered by `dbmaint` here to populate an empty column file on disk, as it first checks the `.d` file for the existence of the column to be added, and if it finds it, does nothing. Since we already know the offending columns from the results of the analysis, we can use `except` again to remove these from the `.d` files and `set` them back to disk:

```q
ml4:{
        .log.out"maintenance level 4: removing missing columns from .d file(s)...";
        x:dde x 4;
        d:(dotd each key x)@'.Q.pv?key each value x;
        d set''(get each'd)except''value each value x;
        .log.out"maintenance level 4: successfully removed columns from ",string[sum count each x]," .d file(s)";
        }
```

```q
q)ar
level| nbbo          quote         trade
-----| -------------------------------------------------------
0    | `date$()      `date$()      `date$()
1    | `date$()      `date$()      `date$()
2    | `date$()      `date$()      `date$()
3    | `date$()      `date$()      `date$()
4    | (`date$())!() (`date$())!() (,2013.05.07)!,,`missingCol
q)ml4 ar
2024.05.23D12:54:45.381881 ### OUT ### maintenance level 4: removing missing columns from .d file(s)...
2024.05.23D12:54:45.383888 ### OUT ### maintenance level 4: successfully removed columns from 1 .d file(s)
```

### Level 5

Now that the columns in each partition are consistent with their respective `.d` files, we turn our attention to ensuring that partitions are consistent across the hdb, by comparing to the latest. As mentioned already, the latest partition found is what kdb+ uses to construct the metadata for partitioned tables. kdb+ (and this script) assumes that the metadata found in the last partition is correct.
```q
$ rm 2013.05.08/trade/ex
$ q .
q){x set get[x]except`ex}`:2013.05.08/trade/.d
`:2013.05.08/trade/.d
q)select from trade where date in 2013.05.08
'./2013.05.08/trade/ex. OS reports: No such file or directory
  [0]  select from trade where date in 2013.05.08
              ^
```

Diagnosing this is straightforward. `dotd` returns the paths to all `.d` files. We simply comapre the contents of each to the last entry per table. Remember that at this point, each partition `.d` should match the columns found on disk. `except` returns any entries from the latest `.d` file not present in another `.d` file. `al5` returns a dictionary per table of any partitions missing a column, and that column.

```q
al5:{
        .log.out"analysis level 5: checking for existence of columns from latest partition...";
        c:x!dde each .Q.pv!/:{last[c]except/:c:get each dotd x}each x;
        if[any 0<count each c;.log.err"analysis level 5: column(s) missing from partition(s):";show c];
        c
        }
```

```q
q)al5`trade`quote;
2024.05.25D04:27:41.365479 ### OUT ### analysis level 5: checking for existence of columns from latest partition...
2024.05.25D04:27:41.371561 ### ERR ### analysis level 5: column(s) missing from partition(s):
trade| (,2013.05.08)!,,`ex
quote| (`date$())!()
```

At this point, we can leverage the ultilty of `dbmaint` to fix. In general, `addcol` is used to add a new column to all partitions of the hdb; in this case we have already diagnosed which partitions need a new column, so we can use `add1col` and only specify those partitions. This will create a column file on disk of the appropriate length and add the new column to the `.d` file of the partition. It does require that we pass a null value of the desired type, which is used to populate the column file. This can be found by looking up the type of each column against the latest partition. The function `ml5` implements this. Indexing the path to the last partition (`lastpath[x]`), works like indexing any other context in kdb+ e.g. list, dictionary or namespace and returns the data at that index. `.Q.ty` is a utility function that returns the type of a list. Lastly, toking (`$`) a null character `" "` to these types will give the appropriately typed null. `add1col` will then selectively update the partitions we're interested in:

```q
ml5:{
        .log.out"maintenance level 5: adding missing columns to partition(s) and .d file(s)...";
        x:dde x 5;
        { p:paths[x].Q.pv?key y;
          t:c!$[;" "]upper .Q.ty each lastpath[x]c:distinct raze value y;
          add1col''[p;value y;t value y]
          }'[key x;value x];
        .log.out"maintenance level 5: successfully wrote all missing column(s)";
        }
```

```q
q)ar
level| nbbo          quote         trade
-----| -----------------------------------------------
0    | `date$()      `date$()      `date$()
1    | `date$()      `date$()      `date$()
2    | `date$()      `date$()      `date$()
3    | `date$()      `date$()      `date$()
4    | (`date$())!() (`date$())!() (`date$())!()
5    | (`date$())!() (`date$())!() (,2013.05.08)!,,`ex
q)ml5 ar
2024.05.25D04:43:20.146836 ### OUT ### maintenance level 5: adding missing columns to partition(s) and .d file(s)...
2024.05.25D04:43:20.152112 ### OUT ### maintenance level 5: successfully wrote all missing column(s)
```

### Level 6
Once we know that each partition has the correct columns on disk and in each `.d` file, we can check that the ordering of each `.d` file matches that of the latest. This won't break the hdb, kdb+ will use the latest partition to construct the column order, so even if you restrict the hdb such that a disordered `.d` file is latest, then the columns will appear in that order in query results:

```q
q){x set 2 rotate get x}`:2013.05.09/trade/.d
`:2013.05.09/trade/.d
q)\l .
q)cols trade
`date`sym`time`price`size`stop`cond`ex`newCol
q).Q.view 2013.05.07 2013.05.08 2013.05.09
q)cols trade
`date`price`size`stop`cond`ex`newCol`sym`time
```

At this point, since we know that all `.d` files have the same columns, we can use match `~` to ensure that they are all exactly the same as the latest. Similar to level 5, we can read each `.d` file, and compare the last per table to the rest of the entries, flagging those that don't match exactly:

```q
al6:{
        .log.out"analysis level 6: checking order of columns vs latest partition...";
        d:@[get;;`]each'dotd each x;
        d:x!.Q.pv where each not(last each d)~/:'d;
        if[any 0<count each d;.log.err"analysis level 6: order of columns is incorrect in partition(s):";show d];
        d
        }
```

```q
q)al6`trade`quote;
2024.05.25D04:55:38.476924 ### OUT ### analysis level 6: checking order of columns vs latest partition...
2024.05.25D04:55:38.481659 ### ERR ### analysis level 6: order of columns is incorrect in partition(s):
trade| ,2013.05.09
quote| `date$()
```

We can leverage `dbamint` again here, this time the `reordercols` functionality. Similar to `addcol` in level 5 above, `reordercols` would attempt to reorder all `.d` files in the hdb. But as we already know which files are out of order, we can selectively apply this using `reordercols0`. We can also simply overwrite offending `.d` files with that of the latest, as we know that each partition already contains all of the appropriate columns:

```q
ml6:{
        .log.out"maintenance level 6: re-ordering columns to match latest partition...";
        x:dde x 6;
        p:(paths each key x)@'.Q.pv?x;
        d:get each'lastdotd each key x;
        reordercols0\:'[p;d];
        .log.out"maintenance level 6: successfully re-ordered ",string[sum count each x]," partitions";
        }
```

```q
q)ar
level| nbbo          quote         trade
-----| -----------------------------------------
0    | `date$()      `date$()      `date$()
1    | `date$()      `date$()      `date$()
2    | `date$()      `date$()      `date$()
3    | `date$()      `date$()      `date$()
4    | (`date$())!() (`date$())!() (`date$())!()
5    | (`date$())!() (`date$())!() (`date$())!()
6    | `date$()      `date$()      ,2013.05.09
q)ml6 ar
2024.05.25D05:03:46.284871 ### OUT ### maintenance level 6: re-ordering columns to match latest partition...
2024.05.25D05:03:46.286887 ### OUT ### maintenance level 6: successfully re-ordered 1 partitions
```

### Level 7
At this point of analysis, we are done with the columnar aspect. Each partition is consistent across columns existing in the `.d` file, column files existing on disk, and the ordering of those columns inside each of the `.d` files. We now move on to some type checking. We require that the type of each column per partition matches that of the latest partition. If one partition type is different, that partition itself is still queryable, and can even be returned alongside data from other partitions. However, this is unadvisable as now the data is of a mixed type and may lead to issues further on.

```q
q){x set`float$get x}`:2013.05.10/trade/size
`:2013.05.10/trade/size
q)count select from trade where date in 2013.05.10
26863
q)meta select size from trade where date in 2013.05.10
c   | t f a
----| -----
size| f
q)meta select size from trade where date in 2013.05.10 2013.05.13
c   | t f a
----| -----
size|
```

Analysing this is more involved than the previous levels. We need to check each the type of each column of each partition against that of the latest. `.Q.V` is a utility function that returns a dictionary of table columns to table data, given the path to a certain partition. We can use `.Q.ty` again to document the type of each column. Note that this operation is error protected and that if a failure occurs, we return a compostion: `#[;" "]count@`. Once we have the types for all columns (`t`), we index this using the columns found in the last partition. Each entry in `t` will either be a dictionary of columns and type, or the composition returned from the error protection. In the case of the dictionary, we get back the type of each column per partition. In the case of the compostion, we get back a character list, matching the length of the columns in the last partition where each entry is a null (`" "`). Once each partition is normalized to the match the last partition, we can do a like for like comparision of the entries and flag any discrepancies. `al7` returns a dictionary per table of any partitions where a column is mistyped, and that column:

```q
al7:{
        .log.out"analysis level 7: comparing column types to latest...";
        t:@[.Q.ty each .Q.V@;;{#[;" "]count@}]each'paths each x;
        t:x!dde each .Q.pv!/:where each'not t0=/:'t@\:'key each t0:last each t;
        if[any 0<count each t;.log.err"analysis level 7: column type(s) not matching latest partition:";show t];
        t
        }
```

```q
q)al7`trade`quote;
2024.05.25D06:39:37.224003 ### OUT ### analysis level 7: comparing column types to latest...
2024.05.25D06:39:37.294967 ### ERR ### analysis level 7: column type(s) not matching latest partition:
trade| (,2013.05.10)!,,`size
quote| (`date$())!()
```

Fixing this programatically is not straightforward. The maintenance function presented here (`ml7`), is limited in scope and will only handle numeric to numeric datatype conversions. Handling everything else is beyond the scope of this paper.

`dbamint` offers the `castcol` function for the scenario of converting from one datatype to another. As usual though, this will attempt to cast all partitions, while we already know the afflicated partitions. So we can jump to using `fn1col` to apply a function to selected partitions only. Similar to level 5 above, we need to first look up the target datatype of the columns in question by referencing the latest partition. We retrieve this via the same method of indexing as `ml5`. `fn1col` expects a composition as its final arguement, so once we have the target datatype, we need to use some trickery to turn this into a casting composition dynamically. `eval` comes to the rescue here; we first manually create a parse tree of a casting compostion, then use `eval` to assemble that into an actual composition which can be applied to data. Once that is done, it's just a mattter of calling `fn1col` on the appropriate partitions and columns:

```q
ml7:{
        .log.out"maintenance level 7: casting columns to match latest partition...";
        x:dde x 7;
        { p:paths[x].Q.pv?key y;
          t:c!(eval($;)@)each'type each lastpath[x]c:distinct raze value y;
          fn1col''[p;value y;t value y]
          }'[key x;value x];
        .log.out"maintenance level 7: sucessfully cast ",string[sum count each x]," column(s)"
        }
```

```q
q)f:eval($;)type`:2013.05.31/trade `size
q)type f
104h
q)type f 1 2 3 4.0
7h
q)ar
level| nbbo          quote         trade
-----| -------------------------------------------------
0    | `date$()      `date$()      `date$()
1    | `date$()      `date$()      `date$()
2    | `date$()      `date$()      `date$()
3    | `date$()      `date$()      `date$()
4    | (`date$())!() (`date$())!() (`date$())!()
5    | (`date$())!() (`date$())!() (`date$())!()
6    | `date$()      `date$()      `date$()
7    | (`date$())!() (`date$())!() (,2013.05.10)!,,`size
q)ml7 ar
2024.05.25D07:03:54.838348 ### OUT ### maintenance level 7: casting columns to match latest partition...
2024.05.25D07:03:54.846555 ### OUT ### maintenance level 7: sucessfully cast 1 column(s)
```

### Level 8

Finally, we ensure that the length of each column is consistent per partition. In older versions of kdb+. this would break the hdb as queries against the partition would fail with a length error. However, in newer versions, kdb+ will silently truncate the result of the query to the length of the shortest column. This can cause problems for trading data for example, where you might expect the last record to be close price for the day. If another column is truncated for some reason, then this close price will be dropped:

```q
q)count select from trade where date in 2013.05.13
26270
q){x set -1_get x}`:2013.05.13/trade/sym
`:2013.05.13/trade/sym
q)count select from trade where date in 2013.05.13
26269
```

Ensuring consistent lengths is straightforward but involved; we need to read each column file in each partition. We use the `.d` file from the last partition to retrive the columns of interest. The `paths` function constructs the full path to the file. Once the column has been read, `differ` tells us if any of the counts do not match the previous entry.

```q
al8:{
        .log.out"analysis level 8: checking column counts per partition...";
        c:flip each paths each'x,/:'get each lastdotd each x;
        c:x!.Q.pv where each{any 1_differ(count get@)each x}each'c;
        if[any 0<count each c;.log.err"analysis level 8: column counts not consistent per partition(s):";show c];
        c
        }
```

```q
q)
al8`trade`quote;
2024.06.16D06:45:50.890181 ### OUT ### analysis level 8: checking column counts per partition...
2024.06.16D06:45:50.968035 ### ERR ### analysis level 8: column counts not consistent per partition(s):
trade| ,2013.05.13
quote| `date$()
```

To fix this, we can pad truncated columns with nulls of the appropriate type; this is the best we can do here without explicitly knowing what data what was dropped. A trick in kdb+ to retrieve the null of a list is to index that list outside of its range, i.e. -1 will always return the null of the appropriate type. By subtracting the count of each column from the max count, we find how many entries we need to pad by; we then take (`#`) the appropriate amount of nulls. kdb+ also lets us manipulate columns on disk, in this case we append the values using an overload of amend (`@`):

```q
ml8:{
        .log.out"maintenance level 8: padding short column(s) with nulls to max column length per partition...";
        x:dde x 8;
        p:(paths each key x)@'.Q.pv?value x;
        d0:get each lastdotd each key x;
        a:{(max[c]-c:count each x)#'x[;-1]}each'p@\:'d0;
        @'[;d0;,;]'[p;a];
        .log.out"maintenance level 8: successfully padded short column(s)";
        }
```

```q
q)(10?`3) -1
`
q)(100?10f) -1
0n
q)ar
level| nbbo          quote         trade
-----| -----------------------------------------
0    | `date$()      `date$()      `date$()
1    | `date$()      `date$()      `date$()
2    | `date$()      `date$()      `date$()
3    | `date$()      `date$()      `date$()
4    | (`date$())!() (`date$())!() (`date$())!()
5    | (`date$())!() (`date$())!() (`date$())!()
6    | `date$()      `date$()      `date$()
7    | (`date$())!() (`date$())!() (`date$())!()
8    | `date$()      `date$()      ,2013.05.13
q)ml8 ar
2024.06.16D06:58:16.132209 ### OUT ### maintenance level 8: padding truncated column(s) with nulls to max column length per partition...
2024.06.16D06:58:16.135560 ### OUT ### maintenance level 8: successfully padded truncated column(s)
q)count select from trade where date in 2013.05.13
26270
```

## Warnings

The analysis and maintenance section above covers most of the common issues, however there are other scenarios that won't neccesarily break the hdb, but may impact performance etc. These are included as warnings.

### Level 0

The first warning is a warning only because we can't actually do anything about with this script if it fails. It checks for the existence of the enumeration file in the hdb root directory (e.g. the `sym` file). If this file is missing, you have big problems and you need more help than this script can offer. If you query against a hdb missing an enumeration file, you'll see the underlying enumeration values:

```q
$ mv sym .sym
$ q .
q)`sym in key`.
0b
q)3#select distinct sym from trade where date=2013.05.31
sym
---
0
1
2
```

This is easy to check, the function only needs to check the latest partition for enumerated columns. In theory, the hdb could have several enumeration files (e.g. one per table) or even one per column per table, but this would be highly irregular. In any case, the script will check for the existence of any enumerations found. Enumerated columns will have a type between 20 and 76 and `exists` can tell us if the file exists in the hdb directory:
```q

wl0:{
        .log.out"warning level 0: checking for existence of enumeration(s)...";
        e:{distinct key each d where(type each d:.Q.V x)within 20 76}each x;
        e:x!e(where not exists each hsym@)each e;
        if[any 0<count each e;.log.err"warning level 0: enumeration(s) missing from hdb directory: ";show e];
        e
        }
```

```q
q)wl0`trade`quote;
2024.06.16D07:18:35.808486 ### OUT ### warning level 0: checking for existence of enumeration(s)...
2024.06.16D07:18:35.812924 ### ERR ### warning level 0: enumeration(s) missing from hdb directory:
trade| sym
quote| sym
```

### Level 1

This is opposite to analysis level 4. While the hdb requires that all columns mentioned in the `.d` file exist in that partition, it does not require that all column files in the partition exist in the `.d` file. This offers an easy, non-permament method to delete columns; we can simply remove it from the latest `.d` file, but preserve the data on disk. For this reason, this is flagged as a warning only.

```q
q)cols trade
`date`sym`time`price`size`stop`cond`ex
q){x set -1_get x}lastdotd `trade
`:./2013.05.31/trade/.d
q)l .
q)cols trade
`date`sym`time`price`size`stop`cond
```

The functionality is similar to that used in `al4`, the main difference is that we reverse the arguments to `except` in order to return anything found on disk, but listed in the `.d` file.

```q
wl1:{
        .log.out"warning level 1: comparing columns to .d file in the same partition...";
        c:1_''key each'paths each x;
        d:@[get;;1#`]each'dotd each x;
        c:x!dde each .Q.pv!/:c except''d;
        if[any 0<count each c;.log.out"warning level 1: columns found on disk not specified in .d file of the same partition...";show c];
        c
        }
```

```q
q)wl1`trade`quote;
2024.06.16D07:37:25.271639 ### OUT ### warning level 1: comparing columns to .d file in the same partition...
2024.06.16D07:37:25.276433 ### OUT ### warning level 1: columns found on disk not specified in .d file of the same partition...
trade| (,2013.05.31)!,,`ex
quote| (`date$())!()
```

### Level 2

This checks the attributes of of each column against the same column in the latest partition. This won't break a query but it will degrade performance against columns without an attribute. This could be handled by the script but applying attributes to large tables can take some time, so it's left as a warning here.

```q
q)attr get`:2013.05.14/trade/sym
`p
q){x set`#get x}`:2013.05.14/trade/sym
q)attr get`:2013.05.14/trade/sym
`
```

The functionality here is similar to that descirbed in `al7`. The `attr` keyword returns the attributes applied to any kdb+ object. We just compare all attributes to those in the last partition:

```q
wl2:{
        .log.out"warning level 2: comparing column attributes to latest...";
        a:@[attr each .Q.V@;;{{count[x]#`}}]each'paths each x;
        a:x!dde each .Q.pv!/:where each'not a0=/:'a@\:'key each a0:last each a;
        if[any 0<count each a;.log.out"warning level 2: column attribute(s) not matching latest partition:";show a];
        a
        }
```

```q
q)wl2`trade`quote;
2024.06.16D08:55:17.417040 ### OUT ### warning level 2: comparing column attributes to latest...
2024.06.16D08:55:17.502858 ### OUT ### warning level 2: column attribute(s) not matching latest partition:
trade| 2013.05.01 2013.05.13 2013.05.14!(,`sym;,`sym;,`sym)
quote| (`date$())!()
```

Note that 2013.05.01 and 2013.05.13 also appear in the result here because:
* 2013.05.01 had an empty schema filled in during analysis level 0 - no need to applu an attribute to an empty column.
* 2013.05.13 had a null symbol appended during analysis level 8 - the parted attribute is never preserved on append.
  
#### Level 3

The final warning checks that foreign keys are consistent against partitions. The logic is similar to `wl2` above:

```q
wl3:{
        .log.out"warning level 3: comparing foreign keys to latest...";
        f:@[.Q.fk each .Q.V@;;{{count[x]#`}}]each'paths each x;
        f:x!dde each .Q.pv!/:where each'not f0=/:'f@\:'key each f0:last each f;
        if[any 0<count each f;.log.out"warning level 3: foreign key(s) not matching latest partition:";show f];
        f
        }
```

```q
q)wl3`trade`quote
2024.06.16D09:01:07.303546 ### OUT ### warning level 3: comparing foreign keys to latest...
trade| (`date$())!()
quote| (`date$())!()
```

## Profiles

Profile of analyis and warnings for speed and memory usage. The number of repitions used was 1380 - this simulates a 5 year hdb using this sample data set `60*count .Q.pv`. Of course, there is some small additional small overhead in this method vs querying an actual hdb of 5 years (logging etc).

```q
   | time  space
---| -------------
al0| 3213  4194880
al1| 849   4194880
al2| 3632  4198256
al3| 700   4195136
al4| 6442  4201520
al5| 3270  4196944
al6| 3554  4198256
al7| 50765 4201568
al8| 45770 4194880
```

```q
   | time  space
---| -------------
wl0| 2587  4194992
wl1| 7334  4201520
wl2| 50163 4203008
wl3| 49800 4203008
```

Analyis levels 7 and 8 are the most time consuming, for this reason, the default analysis level is set to 6. Similar for warnings, levels 2 and 3 are the most comsumptive, the default is set to 1 here.

## Future improvements

Some ideas for improvements:

* run `paths`,`dotd` etc once on startup and store the results for lookup rather than regenerating at each step.
* recovery mode if loading the hdb fails; if there is an issue with the latest partition, the hdb can fail to load. Most of the hdb variables in the `.Q` namespace (.e.g. `.Q.pv`) could be constructed on load error. However, as so much is dependent on the structure of the latest partition, it may be better to leave this to be manually investigated and fixed first.
