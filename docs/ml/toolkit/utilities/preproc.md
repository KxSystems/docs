---
author: Conor McCarthy
description: The Machine Learning Toolkit contains functions used regularly within pipelines for the manipulation of data. Such functions are often applied prior to the application of algorithms. They ensure data is in the correct format and does not contain uninformative information or datatypes the algorithms cannot handle.
date: April 2019
keywords: preprocessing, linear combinations, polynomial creation, infinite replace, scaler, data filling, encoding, one-hot, frequency, lexigraphical, time splitting 
---
# :fontawesome-solid-share-alt: Data preprocessing 


<div markdown="1" class="typewriter">
.ml   **Data preprocessing**
  [applyLabelEncode](#mlapplylabelencode)           Transform integer data to label encode representation
  [dropConstant](#mldropconstant)               Constant columns removed
  [fillTab](#mlfilltab)                     Tailored filling of null values for a simple matrix
  [freqEncode](#mlfreqencode)                 Numerically encode frequency of category occurance
  [infReplace](#mlinfreplace)                 Replace +/- infinities with max/min of column

  labelEncode       Encode list of symbols to integer values and produce mapping
	[labelEncode.fit](#mllabelencodefit)           Fit a label encoder model
	[labelEncode.fitTransform](#mllabelencodefittransform)  Encode categorical data to an integer value 
                             representation

  lexiEncode        Label categories based on lexigraphical order
	[lexiEncode.fit](#mllexiencodefit)            Fit lexigraphical ordering model to cateogorical data
	[lexiEncode.fitTransform](#mllexiencodefittransform)   Encode categorical features based on lexigraphical order

  minMaxScaler      Data scaled between 0-1
	[minMaxScaler.fit](#mlminmaxscalerfit)          Fit min max scaling model
	[minMaxScaler.fitTransform](#mlminmaxscalerfittransform) Scale data between 0-1 based on fitted model

  oneHot            One-hot encoding of table or array
	[oneHot.fit](#mlonehotfit)                Fit one-hot encoding model to categorical data
	[oneHot.fitTransform](#mlonehotfittransform)       Encode categorical features using one-hot encoding
	
  polyTab           Polynomial features of degree n from a table
	[polyTab](#mlpolytab)                  Polynomial feature generation  

  stdScaler         Standard scaler transform-based representation of a table
	[stdScaler.fit](#mlstdscalerfit)             Fit standard scaler model
	[stdScaler.fitTransform](#mlstdscalerfittransform)    Standard scaler transform based representation of data

  timeSplit         Decompose time columns into constituent parts
    [timeSplit](#mltimesplit)                Split Time series data into constituent parts
</div>

:fontawesome-brands-github:
[KxSystems/ml/util/preproc.q](https://github.com/kxsystems/ml/blob/master/util/preproc.q)

The Machine Learning Toolkit contains functions used regularly within pipelines for the manipulation of data. Such functions are often applied prior to the application of algorithms. They ensure data is in the correct format and does not contain uninformative information or datatypes the algorithms cannot handle.


## `.ml.applyLabelEncode`

_Transform a list of integers based on a previously generated label encoding_

```syntax
.ml.applyLabelEncode[data;map]
```

Where

- `data` is a list of integers to be reverted to its original representation
- `map` is a dictionary mapping true representation to associated integer or the return from `.ml.labelEncode.fit`

returns a list with the integer values of `data` replaced by their appropriate 'true' representation. Values that do not appear in the mapping supplied by `map` are returned as null values

!!!Note
	This function is primarily used when attempting to convert classification predictions from a fitted model to their underlying representation. It is often the case that a user will convert a symbol list to an integer list in order to allow their machine learning model to fit the data appropriately.

```q
// List of symbols to be encoded
q)symList:`a`a`a`b`a`b`b`c`c`c`c

// Produced and display a symbol encoding schema
q)show schema:.ml.labelEncode.fit[symList]
modelInfo| `s#`a`b`c!0 1 2
transform| {[config;data]
  map:config`modelInfo;
  -1^map data
  }[(,`modelI..

// Generate a list of integers to apply the schema to
q)newList:0 0 1 2 2 2 0 1 4

// Apply the schema completely and the mapping itself to the new list
q).ml.applyLabelEncode[newList;schema]
`a`a`b`c`c`c`a`b`
q).ml.applyLabelEncode[newList;schema`modelInfo]
`a`a`b`c`c`c`a`b`
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.applylabelencode`.
    That is still callable but will be removed after version 3.0.


## `.ml.dropConstant`

_Remove constant columns_

```syntax
.ml.dropConstant data
```

Where `data` is a numerical table/dictionary,
returns `data` without constant columns.

```q
q)5#tab:([]1000?100f;1000#10;1000#0N)
x        x1 x2
--------------
95.25017 10
42.09728 10
98.80532 10
54.5461  10
51.7746  10
q)5#.ml.dropConstant tab	// tabular input
x
--------
95.25017
42.09728
98.80532
54.5461
51.7746
q).ml.dropConstant flip tab	// dictionary input
x| 33.35067 23.52469 95.13262 64.67595 57.13359 4.249854 34.68608 6..
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.dropconstant`.
    That is still callable but will be removed after version 3.0.


## `.ml.fillTab`

_Tunable filling of null data for a simple table_

```syntax 
.ml.fillTab[tab;groupCol;timeCol;dict]
```

Where

-   `tab` is a table containing numerical and non numerical data
-   `groupCol` is a grouping column for the fill
-   `timeCol` is a time column in the data
-   `dict` is a dictionary defining fill behavior, setting this to `::` will result in forward followed by reverse filling

returns a table with columns filled according to assignment of keys in the dictionary `dict`, the null values are also encoded within a new column to maintain knowledge of the null positions. 

```q
q)show tab:([]sym:10?`A`B;time:asc 10?0t;@[10?1f;0 1 8 9;:;0n];@[10?1f;4 5;:;0n];@[10?1f;2*til 5;:;0n])
sym time         x          x1        x2         
-------------------------------------------------
B   03:27:54.715            0.9976543            
B   05:38:20.749            0.2531291 0.004250957
A   07:54:57.322 0.7625179  0.4537337            
B   08:12:25.502 0.7505538  0.7209056 0.04499967 
A   10:13:43.703 0.487814                        
A   14:10:25.386 0.2057634            0.92978    
B   17:38:28.322 0.6288875  0.8751704            
A   17:44:20.022 0.02301354 0.4503539 0.8472568  
B   18:16:47.740            0.4052153            
B   23:10:44.297            0.5513535 0.2213819  
q)gc:`sym
q)tc:`time
q)dict:`x`x1`x2!`linear`median`mean
q).ml.fillTab[tab;gc;tc;dict] / tailored fills
sym time         x          x1        x2          x_null x1_null x2_null
------------------------------------------------------------------------
B   03:27:54.715 0.8117071  0.9976543 0.09021085  1      0       1      
B   05:38:20.749 0.7836716  0.2531291 0.004250957 1      0       0      
A   07:54:57.322 0.7625179  0.4537337 0.8885184   0      0       1      
B   08:12:25.502 0.7505538  0.7209056 0.04499967  0      0       0      
A   10:13:43.703 0.487814   0.4503539 0.8885184   0      1       1      
A   14:10:25.386 0.2057634  0.4503539 0.92978     0      1       0      
B   17:38:28.322 0.6288875  0.8751704 0.09021085  0      0       1      
A   17:44:20.022 0.02301354 0.4503539 0.8472568   0      0       0      
B   18:16:47.740 0.6206502  0.4052153 0.09021085  1      0       1      
B   23:10:44.297 0.5574701  0.5513535 0.2213819   1      0       0      
q).ml.fillTab[tab;gc;tc;::]  / default forward-backward filling
sym time         x          x1        x2          x_null x1_null x2_null
------------------------------------------------------------------------
B   03:27:54.715 0.7505538  0.9976543 0.004250957 1      0       1      
B   05:38:20.749 0.7505538  0.2531291 0.004250957 1      0       0      
A   07:54:57.322 0.7625179  0.4537337 0.92978     0      0       1      
B   08:12:25.502 0.7505538  0.7209056 0.04499967  0      0       0      
A   10:13:43.703 0.487814   0.4537337 0.92978     0      1       1      
A   14:10:25.386 0.2057634  0.4537337 0.92978     0      1       0      
B   17:38:28.322 0.6288875  0.8751704 0.04499967  0      0       1      
A   17:44:20.022 0.02301354 0.4503539 0.8472568   0      0       0      
B   18:16:47.740 0.6288875  0.4052153 0.04499967  1      0       1      
B   23:10:44.297 0.6288875  0.5513535 0.2213819   1      0       0      
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.filltab`.
    That is still callable but will be removed after version 3.0.


## `.ml.freqEncode`

_Encoded frequency of individual category occurences_

```syntax
.ml.freqEncode[tab;symCols]
```

Where

-  `tab` is a simple table
-  `symCols` is a list of columns to apply encoding to, setting as `::` encodes all sym columns.

returns table with frequency of occurrance of individual symbols within a column.

```q
q)show tab:([]10?`a`b`c;10?10f;10?3)
x x1        x2
--------------
c 4.429712  1 
a 0.4843617 0 
a 7.101809  1 
a 4.706552  1 
a 5.680263  1 
a 5.329865  2 
a 8.452182  1 
a 0.4821576 0 
b 4.755664  0 
c 8.35521   0 
q).ml.freqEncode[tab;::]    // default behavior
x1        x2 x_freq
-------------------
4.429712  1  0.2   
0.4843617 0  0.7   
7.101809  1  0.7   
4.706552  1  0.7   
5.680263  1  0.7   
5.329865  2  0.7   
8.452182  1  0.7   
0.4821576 0  0.7   
4.755664  0  0.1   
8.35521   0  0.2   
q).ml.freqEncode[tab;`x`x2] // customised encoding
x1        x_freq x2_freq
------------------------
4.429712  0.2    0.5    
0.4843617 0.7    0.4    
7.101809  0.7    0.5    
4.706552  0.7    0.5    
5.680263  0.7    0.5    
5.329865  0.7    0.1    
8.452182  0.7    0.5    
0.4821576 0.7    0.4    
4.755664  0.1    0.4    
8.35521   0.2    0.4    
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.freqencode`.
    That is still callable but will be removed after version 3.0.


## `.ml.infReplace`

_Replace +/- infinities with data max/min_

```syntax
.ml.infReplace data
```

Where `data` is a dictionary/table/list of numeric values,
returns the data with positive/negative infinities replaced by max/min values for the given key.

```q
q)show d:`A`B`C!(5 6 9 0w;10 -0w 0 50;0w 1 2 3)
A| 5  6   9 0w
B| 10 -0w 0 50
C| 0w 1   2 3
q).ml.infReplace d`A
5 6 9 9f
q).ml.infReplace d
A| 5  6 9 9
B| 10 0 0 50
C| 3  1 2 3
q).ml.infReplace flip d
A B  C
------
5 10 3
6 0  1
9 0  2
9 50 3
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.infreplace`.
    That is still callable but will be removed after version 3.0.


##`.ml.labelEncode.fit`

_Fit a label encoder model_

```syntax
.ml.labelEncode.fit data
```

Where `data` is a list of any type to encode,
returns a dictionary providing the schema mapping values for the input data (`modelInfo`) and a transform function to be used on new data (`transform`).

??? "Result dictionary"

	The schema mapping values are contained within `modelInfo` and map each symbol to its integer representation
	
	```
	`a`b`c!0 1 2
	```
	
	The transform functionality is contained within the `transform` key. The function takes as argument a list of any type to be encoded, and
	returns the data encoded to an integer representation based on the mapping schema created during the fitting of the model. Any values not contained within the schema mapping return -1.

```q
q)sym:`cab`acb`abc`bac`bca
q)show symEncode:.ml.labelEncode.fit[sym]
modelInfo| `s#`abc`acb`bac`bca`cab!0 1 2 3 4
transform| {[config;data]
  map:config`modelInfo;
  -1^map data
  }[(,`modelI..

// Extract the schema mapping
q)symEncode.modelInfo
abc| 0
acb| 1
bac| 2
bca| 3
cab| 4

// Transform new values using fitted model
q)newSym:`acb`acb`bca`bac
q)symEncode.transform[newSym]
1 1 3 2
// Values not included in the mapping return -1
q)symEncode.transform[newSym,`aaa]
1 1 3 2 -1
```


##`.ml.labelEncode.fitTransform`

_Encode categorical data to an integer value representation_

```syntax
.ml.labelEncode.fitTransform data
```

Where `data` is a list of any type to encode,
returns a list encoded to an integer representation.

```q
q)sym:`cab`acb`abc`bac`bca
q)show symEncode:.ml.labelEncode.fitTransform[sym]
4 1 0 2 3

q)show floats:5?1f
0.439081 0.5759051 0.5919004 0.8481567 0.389056
q)show floatEncode:.ml.labelEncode.fitTransform[floats]
1 2 3 4 0
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.labelencode`.
    That is still callable but will be removed after version 3.0.


## `.ml.lexiEncode.fit`

_Fit lexigraphical ordering model to cateogorical data_

```syntax
.ml.lexiEncode.fit[tab;symCols]
```
Where

-  `tab` is a simple table
-  `symCols` is a list of columns to apply encoding to, setting as `::` encodes all sym columns

returns a dictionary containing mapping information (`modelInfo`) and a projection of the transformation function to be used on new data (`transform`)

??? "Result dictionary"

	The schema mapping values are contained within `modelInfo` and map each symbol to its integer representation for each column in the input table
	
	```
	`col1!`a`b`c!0 1 2
	`col2!`e`f`g!0 1 2
	```
	
	The transform functionality is contained within the `transform` key. The function takes as arguments
	
	-  `tab` is a simple table
	-  `symDict` is a dictionary where each key indicates the columns in `tab` to be encoded, while the values indicate what mapping from the fitted data to use when encoding. If (::) is used, it is assumed that the columns in the fit and transform table are the same
	
	returns the table with lexigraphical ordering of symbol column. Any values not contained within the schema mapping return -1

```q
q)show tab:([]5?10f;5?`a`b`c;5?`e`f`g)
x        x1 x2
--------------
6.768181 b  g 
9.949169 b  f 
9.716633 c  g 
4.593937 b  e 
4.081315 a  g 

q)show lexi:.ml.lexiEncode.fit[tab;::]
modelInfo| `x1`x2!(`s#`a`b`c!0 1 2;`s#`e`f`g!0 1 2)
transform| {[config;tab;symDict]
  mapDict:config`modelInfo;
  symDict:i.mapp..

// Extract the schema mapping
q)lexi.modelInfo
x1| `s#`a`b`c!0 1 2
x2| `s#`e`f`g!0 1 2

// Transform new data
show tab2:([]5?10f;5?`a`b`c;5?`e`f`g)
x         x1 x2
---------------
8.946904  c  f 
0.3035461 b  g 
5.039259  c  g 
4.913808  b  e 
0.6653002 a  f 
q)lexi.transform[tab2;::]
x         x1_lexi x2_lexi
-------------------------
8.946904  2       1      
0.3035461 1       2      
5.039259  2       2      
4.913808  1       0      
0.6653002 0       1 

q)show tab3:([]5?10f;5?`e`f`g)
x         x1
------------
7.69514   e 
2.18553   f 
0.6951899 g 
6.086995  e 
6.389854  e 
// Define the columns to encode and what mapping to use
q)lexi.transform[tab3;enlist[`x1]!enlist`x2]
x         x1_lexi
-----------------
7.69514   0      
2.18553   1      
0.6951899 2      
6.086995  0      
6.389854  0   
```


## `.ml.lexiEncode.fitTransform`

_Encode categorical features based on lexigraphical order_

```syntax
.ml.lexiEncode.fitTransform[tab;symCols]
```

Where

-  `tab` is a simple table
-  `symCols` is a list of columns to apply encoding to, setting as `::` encodes all sym columns

returns table with lexigraphical ordering of symbol columns

```q
q)show tab:([]5?10f;5?`a`b`c;5?`e`f`g)
x         x1 x2
---------------
2.144001  a  e 
8.20994   c  e 
0.7424075 a  e 
8.202035  b  g 
6.618763  b  f 
q).ml.lexiEncode.fitTransform[tab;::] / default behaviour
x         x1_lexi x2_lexi
-------------------------
2.144001  0       0      
8.20994   2       0      
0.7424075 0       0      
8.202035  1       2      
6.618763  1       1      

q).ml.lexiEncode.fitTransform[tab;`x1] /custom behaviour
x         x2 x1_lexi
--------------------
2.144001  e  0      
8.20994   e  2      
0.7424075 e  0      
8.202035  g  1      
6.618763  f  1   
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.lexiencode`.
    That is still callable but will be removed after version 3.0.


## `.ml.minMaxScaler.fit`

_Fit min max scaling model_

```syntax 
.ml.minMaxScaler.fit data
```

Where `data` is a numerical table, matrix or list,
returns a dictionary containing the min and max values of the fitted data (`modelInfo`) along with a transform function projection (`transform`).

??? "Result dictionary"

	The min/max value of the data calculated during the fitting process is contained within `modelInfo`
	
	```
	`minData`maxData!5 10
	```
	
	The transform functionality is contained within the `transform` key. The function takes as argument a numerical table, matrix or list, and
	returns the min-max scaled representation of the new data based on the values of the fitted model.

```q
q)n:5
q)show tab:([]n?100f;n?1000;n?100f;n?50f)
x        x1  x2       x3      
------------------------------
54.97936 745 6.165008 3.673904
19.58467 362 28.5799  15.79763
56.15261 637 66.84724 17.05243
7.043811 494 91.33033 43.08986
21.24007 725 14.85357 27.74432

q)show minMax:.ml.minMaxScaler.fit[tab]
modelInfo| `minData`maxData!+`x`x1`x2`x3!(7.043811 56.15261;362 745..
transform  | {[func;data]
  $[0=type data;
      func data;
    98=type data;
// Extract the min/max values calculated
q)minMax.modelInfo
       | x        x1  x2       x3      
-------| ------------------------------
minData| 7.043811 362 6.165008 3.673904
maxData| 56.15261 745 91.33033 43.08986

// Use the fitted model to scale new data
q)show tab2:([]n?100f;n?1000;n?100f;n?50f)
x        x1  x2       x3      
------------------------------
65.68734 879 84.39807 28.17527
96.25156 459 54.26371 44.19115
37.14973 494 7.757332 12.19597
17.44659 518 63.74637 33.59063
58.97202 457 97.61246 43.19796
q)minMax.transform tab2
x         x1        x2         x3       
----------------------------------------
1.194155  1.349869  0.9186024  0.6216103
1.816533  0.2532637 0.5647686  1.02794  
0.6130453 0.3446475 0.01869686 0.2162085
0.2118313 0.4073107 0.6761128  0.7590003
1.057411  0.2480418 1.073764   1.002742 
```


## `.ml.minMaxScaler.fitTransform`

_Scale data between 0-1_

```syntax 
.ml.minMaxScaler.fitTransform data
```

Where `data` is a numerical table, matrix or list,
returns a min-max scaled representation with values scaled between 0 and 1f.

```q
q)n:5
q)show tab:([]n?100f;n?1000;n?100f;n?50f)
x        x1  x2       x3      
------------------------------
95.16746 744 90.89531 47.75451
11.69475 701 20.62569 30.79257
81.58957 779 48.1821  35.12275
60.91539 340 20.65625 17.7519 
98.30794 153 52.29178 18.07572
q).ml.minMaxScaler.fitTransform[tab]
x         x1        x2           x3        
-------------------------------------------
0.9637413 0.9440895 1            1         
0         0.8753994 0            0.4346513 
0.8069766 1         0.3921525    0.578978  
0.5682811 0.298722  0.0004348562 0         
1         0         0.450637     0.01079286

q)show mat:value flip tab
95.16746 11.69475 81.58957 60.91539 98.30794
744      701      779      340      153     
90.89531 20.62569 48.1821  20.65625 52.29178
47.75451 30.79257 35.12275 17.7519  18.07572
q).ml.minMaxScaler.fitTransform[mat]
0.9637413 0         0.8069766 0.5682811    1         
0.9440895 0.8753994 1         0.298722     0         
1         0         0.3921525 0.0004348562 0.450637  
1         0.4346513 0.578978  0            0.01079286

q)list:100?100
q).ml.minMaxScaler.fitTransform[list]
0.2525253 0.7373737 0 0.06060606 0.3838384 0.7272727 0.1313131 0.7777778 0.64..
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.minmaxscaler`.
    That is still callable but will be removed after version 3.0.


## `.ml.oneHot.fit`

_Fit one-hot encoding model to categorical data_

```syntax
oneHot.fit[tab;symCols]
```

Where

-  `tab` a table containing numeric and non numerical data
-  `symCols` is a list of columns as symbols to apply encoding to, setting as `::` will encode all symbol columns

returns a dictionary containing mapping information (`modelInfo`) and a projection of the transformation function to be applied to new data (`transform`).

??? "Result dictionary"

	The mapping values are contained within `modelInfo`. These values map the distinct symbol values found within each column
	
	```
	`col1`col2!(`a`b;`c`d)
	```
	
	The transform functionality is contained within the `transform` key. The function takes as arguments
	
	-  `tab` is a simple table
	-  `symDict` is a dictionary where each key indicates the columns in `tab` to be encoded, while the values indicate what mapping to use when encoding. If (::) is used, it is assumed that the columns in the fit and transform table are the same 

	returns the one hot encoded version of the data based on the values of the fitted model. Any values not contained within the schema mapping return a zero vector in the ohe feature space. 

```q
q)5#tab:([]5?`a`b`c;5?2;5?10f)
x x1 x2       
--------------
c 0  1.200717 
b 1  4.089565 
c 1  5.700753 
b 1  0.8786376
b 0  4.219038 
q)show oneHot:.ml.oneHot.fit[tab;::]
modelInfo| (,`x)!,`s#`b`c
transform| {[config;tab;symDict]
  mapDict:config`modelInfo;
  symDict:i.mapp..

// Extract the mapping info per column
q)oneHot.modelInfo
x| b c

// One hot encode new data
q)5#tab2:([]5?2;5?`a`b`c;5?10f)
x x1 x2      
-------------
1 b  4.988226
0 a  8.207332
0 b  6.44946 
1 b  3.695111
0 b  6.620432
// The x1 column in the new data will be encoded
// based off the mapping from `x in the fitted model
q)oneHot.transform[tab2;enlist[`x1]!enlist `x]
x x2       x1_a x1_b
--------------------
1 6.168275 1    0   
0 6.876426 0    1   
0 6.123797 0    0   
0 9.363029 1    0   
1 2.188574 0    0 
```


## `.ml.oneHot.fitTransform`

_Encode categorical features using one-hot encoded fitted model_

```syntax
oneHot.fitTransform[tab;symCols]
```

Where

-  `tab` a table containing numeric and non numerical data
-  `symCols` is a list of columns as symbols to apply encoding to, setting as `::` will encode all symbol columns

returns a one-hot encoded representation of categorical data as a table

```q
q)5#tab:([]5?`a`b`c;5?2;5?10f)
x x1 x2       
--------------
b 0  2.032099 
a 1  2.310648 
a 1  3.138309 
a 0  0.1974141
a 0  5.611439 
q).ml.oneHot.fitTransform[tab;::]
x1 x2        x_a x_b
--------------------
0  2.032099  0   1  
1  2.310648  1   0  
1  3.138309  1   0  
0  0.1974141 1   0  
0  5.611439  1   0  
q).ml.oneHot.fitTransform[tab;`x`x1]
x2        x_a x_b x1_0 x1_1
---------------------------
2.032099  0   1   1    0   
2.310648  1   0   0    1   
3.138309  1   0   0    1   
0.1974141 1   0   1    0   
5.611439  1   0   1    0 
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.onehot`.
    That is still callable but will be removed after version 3.0.


## `.ml.polyTab`

_Tunable polynomial features from an input table_

```syntax
.ml.polyTab[tab;n]
```

Where

-   `tab` is a table of numerical values
-   `n` is the order of the polynomial feature being created

returns the polynomial derived features of degree `n` in the form of a table.

```q
q)n:100
q)5#tab:([]val:sin 0.001*til n;til n;n?100f;n?1000f;n?10)
val          n  x        x1       x2
------------------------------------
0            0  68.5896  20.67882 2
0.0009999998 1  41.60588 752.6717 1
0.001999999  2  19.6753  479.5434 3
0.002999996  3  76.81172 463.5728 3
0.003999989  4  45.02587 694.5211 8

q)5#.ml.polyTab[tab;2]
val_n        val_x      val_x1    val_x2       n_x      n_x1     n_x2..
---------------------------------------------------------------------..
0            0          0         0            0        0        0   ..
0.0009999998 0.04160587 0.7526715 0.0009999998 41.60588 752.6717 1   ..
0.003999997  0.03935058 0.9590862 0.005999996  39.35061 959.0868 6   ..
0.008999987  0.2304348  1.390716  0.008999987  230.4352 1390.719 9   ..
0.01599996   0.180103   2.778077  0.03199991   180.1035 2778.084 32  ..

q)5#.ml.polyTab[tab;3]
val_n_x    val_n_x1  val_n_x2     val_x_x1 val_x_x2   val_x1_x2 n_x_x..
---------------------------------------------------------------------..
0          0         0            0        0          0         0    ..
0.04160587 0.7526715 0.0009999998 31.31556 0.04160587 0.7526715 31315..
0.07870116 1.918172  0.01199999   18.87031 0.1180517  2.877259  18870..
0.6913044  4.172149  0.02699996   106.8233 0.6913044  4.172149  10682..
0.7204121  11.11231  0.1279997    125.0853 1.440824   22.22462  12508..

/this can be integrated with the original data via the syntax
q)5#newTab:tab^.ml.polyTab[tab;2]^.ml.polyTab[tab;3]
val          n  x        x1       x2 val_n        val_x      val_x1  ..
---------------------------------------------------------------------..
0            0  68.5896  20.67882 2  0            0          0       ..
0.0009999998 1  41.60588 752.6717 1  0.0009999998 0.04160587 0.752671..
0.001999999  2  19.6753  479.5434 3  0.003999997  0.03935058 0.959086..
0.002999996  3  76.81172 463.5728 3  0.008999987  0.2304348  1.390716..
0.003999989  4  45.02587 694.5211 8  0.01599996   0.180103   2.778077..
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.polytab`.
    That is still callable but will be removed after version 3.0.


## `.ml.stdScaler.fit`

_Fit standard scaler model_

```syntax
.ml.stdScaler.fit data
```

Where `data` is a simple numerical table, matrix or list,
returns a dictionary containing average and deviation values of the fitted data (`modelInfo`) along with a transform function projection to be used on new data (`transform`).

??? "Result dictionary"

	The avg/dev value of the data used during the fitting process is contained within `modelInfo`
	
	```
	`avgData`devData!8 2
	```
	
	The transform functionality is contained within the `transform` key. The function takes as argument a numerical table, matrix or list, and
	returns the standard scaled representation of the data based on the input values of the fitted model

```q
q)n:5
q)show tab:([]n?100f;n?1000;n?100f;n?50f)
x        x1  x2       x3      
------------------------------
63.0036  503 70.51033 11.2785 
31.65436 102 14.97004 42.62871
65.49844 34  24.00771 38.60175
26.43322 809 10.39355 39.7236 
31.14316 415 23.53326 48.96199

q)show stdScale:.ml.stdScaler.fit[tab]
modelInfo| `avgData`devData!+`x`x1`x2`x3!(43.54656 17.02114;372.6 281..
transform| {[func;data]
  $[0=type data;
      func data;
    98=type data;
 ..
// Extract the avg/dev information per column
q)stdScale.modelInfo
       | x        x1       x2       x3      
-------| -----------------------------------
avgData| 43.54656 372.6    28.68298 36.23891
devData| 17.02114 281.8231 21.54276 12.9881 

// Scale new data based on fitted model
1)show tab2:([]n?100f;n?1000;n?100f;n?50f)
x        x1  x2       x3      
------------------------------
35.20493 557 19.43085 44.36463
70.96579 296 32.13079 18.81573
46.24471 288 40.90672 19.41565
8.077328 421 63.22979 24.21895
5.367945 760 49.65883 3.92097 
q)stdScale.transform[tab2]
x          x1         x2         x3        
-------------------------------------------
-0.4900747 0.6543112  -0.4294775 0.625628  
1.610893   -0.2718017 0.1600452  -1.341472 
0.1585179  -0.3001883 0.5674178  -1.295282 
-2.083834  0.171739   1.603639   -0.9254592
-2.243011  1.374621   0.9736847  -2.488272 
```


## `.ml.stdScaler.fitTransform`

_Standard scaler transform-based representation of data_

```syntax
.ml.stdScaler.fitTransform data
```

Where `data` is a simple numerical table, matrix or list,
returns a table, matrix or list where all data has undergone standard scaling.

```q
q)n:5
q)show tab:([]n?100f;n?1000;n?100f;n?50f)
x        x1  x2       x3      
------------------------------
63.0036  503 70.51033 11.2785 
31.65436 102 14.97004 42.62871
65.49844 34  24.00771 38.60175
26.43322 809 10.39355 39.7236 
31.14316 415 23.53326 48.96199
q).ml.stdScaler.fitTransform[tab]
x          x1         x2         x3       
------------------------------------------
1.14311    0.4627017  1.941597   -1.92179 
-0.698672  -0.9601769 -0.6365448 0.4919733
1.289683   -1.201463  -0.2170228 0.1819231
-1.005416  1.548489   -0.8489826 0.2682987
-0.7287051 0.150449   -0.2390463 0.9795947

q)show mat:value flip tab
63.0036  31.65436 65.49844 26.43322 31.14316
503      102      34       809      415     
70.51033 14.97004 24.00771 10.39355 23.53326
11.2785  42.62871 38.60175 39.7236  48.96199
q).ml.stdScaler.fitTransform[mat]
1.14311   -0.698672  1.289683   -1.005416  -0.7287051
0.4627017 -0.9601769 -1.201463  1.548489   0.150449  
1.941597  -0.6365448 -0.2170228 -0.8489826 -0.2390463
-1.92179  0.4919733  0.1819231  0.2682987  0.9795947

q)list:100?100
q).ml.stdScaler.fitTransform[list]
-0.1968835 1.653525 0.06217373 -1.455161 0.2842228 -1.418153 1.542501 -0.5669..
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.stdscaler`.
    That is still callable but will be removed after version 3.0.


## `.ml.timeSplit`

_Break specified time columns into constituent components_

```syntax
.ml.timeSplit[tab;timeCols]
```

Where

-  `tab` is a simple table containing time columns
-  `timeCols` is a list of columns as symbols to apply encoding to, if set to `::` all columns with date/time types will be encoded

returns a table with the columns with all time or date types broken into labeled versions of their constituent components.

```q
q)show timeTab:([]`timestamp$(2000.01.01+til 5);5?0u;5?10;5?10)
x                             x1    x2 x3
-----------------------------------------
2000.01.01D00:00:00.000000000 21:51 7  6 
2000.01.02D00:00:00.000000000 02:55 5  7 
2000.01.03D00:00:00.000000000 09:48 7  6 
2000.01.04D00:00:00.000000000 16:50 7  5 
2000.01.05D00:00:00.000000000 13:50 4  5 
q).ml.timeSplit[timeTab;::]  / default behavior
x2 x3 x_dow x_year x_mm x_dd x_qtr x_wd x_hh x_uu x_ss x1_hh x1_uu
------------------------------------------------------------------
7  6  0     2000   1    1    1     0    0    0    0    21    51   
5  7  1     2000   1    2    1     0    0    0    0    2     55   
7  6  2     2000   1    3    1     1    0    0    0    9     48   
7  5  3     2000   1    4    1     1    0    0    0    16    50   
4  5  4     2000   1    5    1     1    0    0    0    13    50   
q).ml.timeSplit[timeTab;`x]  / tailored application of encoding
x1    x2 x3 x_dow x_year x_mm x_dd x_qtr x_wd x_hh x_uu x_ss
------------------------------------------------------------
21:51 7  6  0     2000   1    1    1     0    0    0    0   
02:55 5  7  1     2000   1    2    1     0    0    0    0   
09:48 7  6  2     2000   1    3    1     1    0    0    0   
16:50 7  5  3     2000   1    4    1     1    0    0    0   
13:50 4  5  4     2000   1    5    1     1    0    0    0   
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.timesplit`.
    That is still callable but will be removed after version 3.0.
