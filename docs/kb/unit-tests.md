The goal of unit tests is to check that the individual parts of a program are correct. 
Unit tests provide a written contract that a piece of code must satisfy.  
<i class="fas fa-wikipedia-w"></i> [Unit testing](http://en.wikipedia.org/wiki/Unit_testing)

Q supports unit testing with the script k4unit.q. 
K4unit loads test descriptions from CSV files, runs the tests, and writes results to a table.  
<i class="fab fa-github"></i> [simongarland/k4unit](https://github.com/simongarland/k4unit)


## Starting

To use k4unit, you first have to load the script file
```bash
q k4unit.q -p 5001
```


## Test descriptions

### Writing descriptions

Tests descriptions are written in a CSV file, with the following format:
```csv
action, ms, lang, code
```
The meaning of each column is as follows.

| Column | Description                                                                | Notes                                                           |
|--------|----------------------------------------------------------------------------|-----------------------------------------------------------------|
| code   | code to be executed                                                        | if your code contains commas enclose it all in quotes.          |
| lang   | `k` or `q`                                                                 | if empty, default is q                                          |
| ms     | max milliseconds it should take to run                                     | if 0, ignore                                                    |
| action | `beforeany`, `beforeeach`, `before`, `run`, `true`, `fail`, `after`, `aftereach`, `afterall` | See below for description                     |

Where the actions have the following meaning:

| Action            | Description                               |
|-------------------|-------------------------------------------|
| `` `beforeany ``  | one time, run code before any tests       |
| `` `beforeeach `` | run code before tests in every file       |
| `` `before ``     | run code before tests in this file        |
| `` `run ``        | run code, check execution time against ms |
| `` `true ``       | run code, check if returns true(`1b`)       |
| `` `fail ``       | run code, it should fail (e.g. `2+two`)     |
| `` `after ``      | run code after tests in this file         |
| `` `aftereach ``  | run code after tests in each file         |
| `` `afterall ``   | one time, run code after all tests        |

!!! note "Fail is not false"
    `` `fail`` is not `"false"`, nor the opposite of `` `true``. 
    If your code returns `0b` when correct, use `not` to make it true. 


### Example descriptions
```csv
comment,0,,this will be ignored
before,,k,aa::22
before,0,k,aa::22
before,0,q,aa::22
before,0,q,aa::22
true,0,k,2=+/1 1
true,0,q,2=sum 1 1
true,0,k,2=sum 1 1
true,0,k,(*/2 2)~+/2 2
true,0,k,(*/2 2)~+/2 3
run,10,k,do[100;+/1.1+!10000]
fail,0,q,2=`aa
after,0,k,bb::33
before,0,k,aa::22
before,0,k,aa::22
```


### Loading descriptions

Invoke the function `KUltf` (load test file) with a file name as its argument.
```q
KUltf `:unitExample.csv
```
When the script k4unit.q is loaded, it creates the table `KUT` (KUnit Tests). It's empty initially:
```q
q)KUT
action ms lang code file
------------------------
```
and will contain test descriptions after tests are loaded with `KUltf`.
```q
q)KUT
action  ms lang code                 file
-----------------------------------------------------
comment 0  q    this will be ignored :unitExample.csv
before  0  k    aa::22               :unitExample.csv
before  0  k    aa::22               :unitExample.csv
before  0  q    aa::22               :unitExample.csv
before  0  q    aa::22               :unitExample.csv
true    0  k    2=+/1 1              :unitExample.csv
true    0  q    2=sum 1 1            :unitExample.csv
true    0  k    2=sum 1 1            :unitExample.csv
true    0  k    (*/2 2)~+/2 2        :unitExample.csv
true    0  k    (*/2 2)~+/2 3        :unitExample.csv
run     10 k    do[100;+/1.1+!10000] :unitExample.csv
fail    0  q    2=`aa                :unitExample.csv
after   0  k    bb::33               :unitExample.csv
before  0  k    aa::22               :unitExample.csv
before  0  k    aa::22               :unitExample.csv
```
It is possible to load multiple description files in the same directory with `KUltd` (load test dir). This
```q
KUltd `:dirname
```
loads all CSVs in that directory into table `KUT`.


## Running unit tests

Invoke `KUrt` (run tests) with an empty argument list
```q
q) KUrt[]
q)KUrt[]
2006.10.04T13:07:36.328 start
2006.10.04T13:07:36.328 :unitExample.csv 7 test(s)
2006.10.04T13:07:36.453 end
7
```


## Test results


### Inspecting results

When k4unit is loaded, it creates the table `KUTR` (KUnit Test Results). It's empty initially
```q
q)KUTR
action ms lang code file msx ok okms valid timestamp
----------------------------------------------------
```
and will contain results of unit tests after `KUrt[]` is invoked. Results can be inspected by showing the whole table
```q
q)KUT
q)KUTR
action ms lang code                 file             msx ok okms valid timest..
-----------------------------------------------------------------------------..
run    10 k    do[100;+/1.1+!10000] :unitExample.csv 124 1  0    1     2006.1..
true   0  k    2=+/1 1              :unitExample.csv 0   1  1    1     2006.1..
true   0  q    2=sum 1 1            :unitExample.csv 0   1  1    1     2006.1..
true   0  k    2=sum 1 1            :unitExample.csv 0   1  1    1     2006.1..
true   0  k    (*/2 2)~+/2 2        :unitExample.csv 0   1  1    1     2006.1..
true   0  k    (*/2 2)~+/2 3        :unitExample.csv 0   0  1    1     2006.1..
fail   0  q    2=`aa                :unitExample.csv 0   1  1    1     2006.1..
```
or by using q queries. For instance:
```q
q)show select from KUTR where not ok
q)show select from KUTR where not okms
q)show select count i by ok,okms,action from KUTR
q)show select count i by ok,okms,action,file from KUTR
```
The fields `action`, `ms`, `lang`, and `code` are as described above. The rest are as follows:

| Column    | Description                                                 | Notes                                 |
|-----------|-------------------------------------------------------------|---------------------------------------|
| file      | name of test descriptions file                              |                                       |
| msx       | milliseconds taken to eXecute code                          |                                       |
| ok        | true if the test completes correctly                        | it is correct for a fail task to fail |
| okms      | true if msx is not greater than ms, ie if performance is ok |                                       |
| valid     | true if the code is valid (ie doesn't crash)                | fail code is valid if it fails        |
| timestamp | when test was run                                           |                                       |


### Saving results to disk

Invoking the function `KUstr[]` saves the table `KUtr` to a file KUTR.csv.


## Restarting

The functions `KUit` and `KUitr` initialize the tables `KUT` and `KUTR` to empty.


## Configuration parameters

When the script k4unit.q is loaded, two configuration variables are defined in namespace `.KU`.
```q
q).KU
       | ::
VERBOSE| 1
DEBUG  | 0
```
The values allowed for `VERBOSE` are
```
0  - no logging to console
1  - log filenames
>1 - log tests
```
The values allowed for DEBUG are
```
0 - trap errors, press on regardless
1 - suspend if errors (except if action=`fail)
```

