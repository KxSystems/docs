---
title: Guide for using HDF5 with kdb+
author: Conor McCarthy
description: Lists functions available for use within the HDF5 API for kdb+ and gives limitations as well as examples of each being used 
date: March 2020
keywords: HDF5, kdb+, file-format, 
---
# <i class="fa fa-share-alt"></i> User guide 


As outlined in the overview for this API, the kdb+/HDF5 interface is a wrapper for kdb+ around the HDF Groups C API for HDF5 found [here](https://support.hdfgroup.org/HDF5/doc/RM/RM_H5Front.html). 

<i class="fab fa-github"></i>
[KxSystems/kafka](https://github.com/KxSystems/hdf5)

## Type Mapping

The following outlines the mapping which takes place between HDF5 and q datatypes. Where there is no exact mapping available between the two types every effort has been made to provide the most appropriate conversion possible.

|            kdb+ type|            HDF5 type|      Note|
|--------------------:|--------------------:|--------------:|
|         boolean (1h)|       H5T_NATIVE_INT| q->hdf5->q conversion limited by types |
|           short (5h)|     H5T_NATIVE_SHORT|               |
|             int (6h)|       H5T_NATIVE_INT|               |
|            long (7h)|      H5T_NATIVE_LONG|               |
|            real (8h)|      H5T_NATIVE_REAL|               |
|           float (9h)|    H5T_NATIVE_DOUBLE|               |
|           char (10h)|             H5T_C_S1|               |
|         symbol (11h)|             H5T_C_S1| q->hdf5->q conversion limited by types |

!!!Note
	Conversions are at present limited to the above types, over time, as appropriate additional types will be added. Due to restrictions in the available types in HDF5 it is unlikely that it will always be possible to create a direct mapping as such additions will be on a best effort basis. If the mapping is not direct this will be highlighted in the documentation.

## Functionality

The following functions are those exposed within the `.hdf5` namespace allowing users to convert data between the HDF5 data format and kdb+.

```txt
HDF5 interface functionality
  // Creation functions
  .hdf5.createAttr             Create an empty typed and dimensioned attribute
  .hdf5.createDataset          Create an empty typed and dimensioned dataset
  .hdf5.createFile             Create a named hdf5 file
 
  // Writing functions
  .hdf5.writeAttr              Write to an named attribute associated with a group or dataset
  .hdf5.writeData              Write data to a named dataset
  
  // Reading functions
  .hdf5.readAttr               Read data from named attribute
  .hdf5.readData               Read data from a named dataset
  
  // Linking functions
  .hdf5.createExternal         Create a hard external link between locations in two files
  .hdf5.createHard             Create a hard link between two locations in a file
  .hdf5.createSoft             Create a soft link between two locations in a file
  .hdf5.delLink                Delete an existing soft or hard link

  // Group functions
  .hdf5.createGroup            Create a single or multiple group levels

  // Utility functions
  .hdf5.isAttr                 Does this attribute exist
  .hdf5.ishdf5                 Is a file of HDF5 format
  .hdf5.isObject               Does this object exist
  .hdf5.getAttrShape           Dimensionality of an attribute
  .hdf5.getAttrPoints          Number of points associated with an attribute
  .hdf5.getDataShape           Dimensionality of a dataset
  .hdf5.getDataPoints          Number of points associated with a dataset
  .hdf5.datasetInfo            Information about type, number of dimensions and dimensionality
  .hdf5.gc                     Run garbage collect on free HDF5 lists of all types
  .hdf5.ls                     ls like representation of the structure of a hdf5 file
```

For simplicity in each of the examples below it should be assumed that unless otherwise specified a file/group/dataset/attribute that is being manipulated exists and is valid and the results displayed coincide with correct execution in that example.


## Creation functions

The following functions relate to the creation of files, datasets and attributes.

### `.hdf5.createAttr`

_Create an attribute associated with an existing dataset/group_

Syntax: `.hdf5.createAttr[fname;oname;aname;dims;typ]`

Where

-   `fname` name of a HDF5 file as a symbol/char string
-   `oname` name of the object (group/datset) to which the attribute is linked
-   `aname` name of the attribute being created
-   `dims`  dimensionality of the attribute as a list of integers
-   `typ`   type of the dataset "f"/"i" ...

returns null on successful addition of attribute, failure to execute will result in display of appropriate error. 

```q
// File does not exist
q).hdf5.createAttr["test.h5";"obj/";"attr name";4 5i;"f"]
'file does not exist

// Dataset/Group does not exist
q).hdf5.createAttr["test1.h5";"obj/";"attr name";4 5i;"f"]
'dataset/group which attribute is to be written to does not exist

// Successful execution
q).hdf5.createAttr["test1.h5";"obj1/";"attr name";4 5i;"f"]
```

### `.hdf5.createDataset`

_Create an typed and dimensioned dataset_

Syntax: `.hdf5.createDataset[fname;oname;dims;typ]`

Where

-   `fname` name of a HDF5 file as a symbol/char string
-   `oname` name of the dataset to be created
-   `dims`  dimensionality of the dataset as a list of integers
-   `typ`   type of the dataset "f"/"i" ...

returns null on successful creation of the dataset.

```q
// Create both file and dataset 
q).hdf5.createDataset["test.h5";"dset";4 5i;"f"]
// Create a dataset within a defined group
q).hdf5.createDataset["test.h5";"G1/G2/dset";1 5i;"i"]
```

!!!Note
	If the file does not exist it will be created, in this case the dataset can **ONLY** be written to the root directory of the file


### `.hdf5.createFile`

_Create an named HDF5 file_

Syntax: `.hdf5.createFile[fname]`

Where

-   `fname` name of a HDF5 file as a symbol/char string

returns null on successful creation of file.

```q
// Create named file
q).hdf5.createFile["test.h5"]
```

!!!Note 
        If a file already exists it will **not** be overwritten.


## Write Functions

The following functions relate to writing of kdb+ data to HDF5 files as either attributes or datasets.

### `.hdf5.writeAttr`

_Write a kdb+ dataset to a HDF5 attribute_

Syntax: `.hdf5.writeAttr[fname;oname;aname;dset]`

Where

-   `fname` name of a HDF5 file as a symbol/char string
-   `oname` name of the object (group/dataset) which the attribute is to be written to
-   `aname` name of the attribute to be written to
-   `dset`  dataset which is being written to HDF5 format

returns null on successful writing of data to attribute. Failure to write to the attribute will result in an appropriate error

!!!Note
	The function `.hdf5.createAttr` can be used to create an attribute prior to writing. Use of this function in the case that an attribute has not been previously created will create the attribute, appropriately dimensioned and typed based on the provided dataset.

```q
// Successful execution
q).hdf5.writeAttr["test.h5";"dset";"temperature";10 2#20?1f]

// File does not exist
q).hdf5.writeAttr["test1.h5";"dset";"temperature";10 2#20?1f]
'file does not exist

// Dataset/group does not exist
q).hdf5.writeAttr["test.h5";"dset1";"temperature";10 2#20?1f]
'dataset/group you are attempting to write attribute to does not exist
```

### `.hdf5.writeData`

_Write a kdb+ dataset to a HDF5 dataset_

Syntax: `.hdf5.writeData[fname;oname;dset]`

Where

-   `fname` name of a HDF5 file as a symbol/char string
-   `oname` name of the dataset which is to be written to
-   `dset`  dataset which is being written to HDF5 format

returns null on successful writing of data to dataset. Failure to write to the dataset will result in an appropriate error

!!!Note
        The function `.hdf5.createDataset` can be used to create a dataset prior to writing. Use of this function in case a where a file or dataset had not been previously been created will create the file and the dataset, appropriately dimensioned and typed based on the provided dataset. It should be noted that if the file did not exist the data can only be written to the root location.

```q
// Write numeric dataset
q).hdf5.writeData["test.h5";"dset";10 2#20?10]

// Create a dataset to hold a list of strings
q).hdf5.writeData["test.h5";"strdset";enlist "test string"]

// File does not exist
q).hdf5.writeAttr["test1.h5";"dset";"temperature";10 2#20?1f]
'file does not exist

// Dataset/group does not exist
q).hdf5.writeAttr["test.h5";"dset1";"temperature";10 2#20?1f]
'dataset/group you are attempting to write attribute to does not exist
```

## Read Functions

The following functions relate to the reading of HDF5 datasets/attributes to an equivalent kdb+ representation.

### `.hdf5.readAttr`

_Read the data contained in a HDF5 attribute to kdb+_

Syntax: `.hdf5.readAttr[fname;oname;aname]`

Where

-   `fname` name of a HDF5 file as a symbol/char string
-   `oname` name of the object dataset which the attribute being read from is connected
-   `aname` name of the attribute from which data is to be read

returns a kdb+ dataset containing the data associated with the named HDF5 attribute

```q
// Read numeric data from attribute
q).hdf5.readAttr["test.h5";"dset";"Temperatures"]
10.0696 10.45295 10.97325 12.04377 12.04978 12.24866 12.48825 13.05441 13.574..

// Read string data from attribute 
q).hdf5.readAttr["test.h5";"dset";"Description"]
"This data relates to experiment 1"
"Time difference between values = 1ms"
```

### `.hdf5.readData`

_Read the data contained in a HDF5 dataset to kdb+_

Syntax: `.hdf5.readAttr[fname;oname]`

Where

-   `fname` name of a HDF5 file as a symbol/char string 
-   `oname` name of the dataset which is to be read from

returns a kdb+ dataset containing the data associated with a HDF5 dataset 
                                 

```q
// Read numeric data
q).hdf5.readData["test.h5";"dset"]
0.4707883 0.6346716 
0.9672398 0.2306385 
0.949975  0.439081  
0.5759051 0.5919004 
0.8481567 0.389056  
0.391543  0.08123546
0.9367503 0.2782122 
0.2392341 0.1508133 
0.1567317 0.9785    
0.7043314 0.9441671

// Read string data
q).hdf5.readData["test.h5";"strdset"]
"Value 1 = 0.01"
"Value 2 = 0.02"
"Value 3 = 0.04"
```

## Linking Functions

The following functions allow a user to link datasets/groups internally or externally to a hdf5 file. The explicit definitions of external, hard and soft links as they pertain to the HDF5 data format can be found [here](http://davis.lbl.gov/Manuals/HDF5-1.8.7/UG/09_Groups.html)

### `.hdf5.createExternal`

_Creates an external link to an object in a different file_

Syntax: `.hdf5.createExternal[fname;lname;tname;tobj]`

Where

-   `fname` HDF5 file containing end point for the external link     
-   `lname` object acting as the end point for the link
-   `tname` target file containing the target object
-   `tobj`  target object which is linked to lname

returns null on successful execution and creates the external link

```q
// Produce a new .h5 file and link a path within this to a dataset in another h5 file
// using the create external link functionality within the api
q).hdf5.createFile["test_external.h5"]
q).hdf5.createExternal["test_external.h5";"/dset";"test.h5";"/dset"]
// Access the data from this new link
q).hdf5.readDataset["test_external.h5";"/dset"]
0.4707883 0.6346716
0.9672398 0.2306385
0.949975  0.439081
0.5759051 0.5919004
0.8481567 0.389056
0.391543  0.08123546
0.9367503 0.2782122
0.2392341 0.1508133
0.1567317 0.9785
0.7043314 0.9441671
```

### `.hdf5.createHard`

_Create a hard link to a physical address in a file_ 
                    
Syntax: `.hdf5.createHard[fname;lname;tname]`
                    
Where               
                    
-   `fname` HDF5 file within which link objects are contained            
-   `lname` object being linked from
-   `tname` target address as an end point to the link
                    
returns null on successful execution and creates the hard link.

```q
// Create a hard link from existing 'dset' to 'G1/dset'
q).hdf5.createHard["test.h5";"/dset";"G1/dset"]
// Access the data using the new link
q).hdf5.readData["test";"/G1/dset"]
8 1 9 5 4 6
6 1 8 5 4 9
2 7 0 1 9 2
1 8 8 1 7 2
```

### `.hdf5.createSoft`

_Create a soft/symbolic link between two locations in a HDF5 file_

Syntax: `.hdf5.createSoft[fname;lname;tname]`

Where      

-   `fname` HDF5 file within which link objects are contained  
-   `lname` object being linked from
-   `tname` target address as an end point to the link
                    
returns null on successful execution and creates the specified soft link.

!!!Note
	Neither `lname` or `tname` need to exist prior to the creation of the soft link. They can be populated after its creation
```q
// Create a soft link (symbolic link) between two unpopulated points in the file
q).hdf5.createSoft["test.h5";"/G1/dset1";"/G1/dset2"]
// Create a hard link between an existing file and /G1/dset1
q).hdf5.createHard["test.h5";"dset";"/G1/dset1"]
// Read from the location pointed to using the soft link
q).hdf5.readData["tets.h5";"/G1/dset2"]
8 1 9 5 4 6
6 1 8 5 4 9
2 7 0 1 9 2
1 8 8 1 7 2
```

### `.hdf5.delLink`

_Delete an assigned external hard or soft link_

Syntax: `.hdf5.delLink[fname;lname]`

Where

-   `fname` HDF5 file within which the link to be deleted is contained
-   `lname` name of the link to be deleted within a HDF5 file

returns a message indicating successful deletion of a link.

```q
// Create a delete a soft link
q).hdf5.delLink["test.h5";"/G1/dset1"]
"Successfully deleted the link"
// Attempt to delete the link again
q).hdf5.delLink["test.h5";"/G1/dset1"]
'could not delete specified link 
```

## Group Functions

The following function is used to create either individual or sets of intermediate groups.

### `.hdf5.createGroup`

_Create a group or set of groups within a file_

Syntax: `.hdf5.createGroup[fname;gname]`

Where

-   `fname` HDF5 file within which groups are to be created
-   `gname` Structure of the groups to be created within the file

returns null on successful execution and creates the desired groups.

```q
// Create a single group
q).hdf5.createGroup["test.h5";"SingleGroup"]
// Create a set of groups
q).hdf5.createGroup["test.h5";"Group1/SubGroup1/SubGroup2"]
```


## Utility Functions

The following are a number of utility functions which may be useful when dealing with HDF5 objects and files.

### `.hdf5.datasetInfo`

_Relevant information about a dataset_

Syntax: `.hdf5.datasetInfo[fname;oname]`

Where

-   `fname` HDF5 file containing the dataset of interest
-   `oname` Dataset about which information is to be displayed

returns a dictionary outlining the type, rank and dimensionality of the dataset

```q
q).hdf5.datasetInfo["test.h5";"dset"]
type | `float
ndims| 2i
dims | 10 2i
```

### `.hdf5.gc`

_Garbage collect on free HDF5 lists of all types_

Syntax: `.hdf5.gc[]`

returns 0i on successful execution

```q
q).hdf5.gc[]
0i
```

### `.hdf5.getAttrShape`

_Get the shape of an attribute dataset_

Syntax: `.hdf5.getAttrShape[fname;oname;aname]`

Where

-   `fname` is the HDF5 containing the attribute
-   `oname` object to which the attribute is associated
-   `aname` attribute name of interest

returns an numerical list indicating the attribute shape

```q
q).hdf5.getAttrShape["test.h5";"dset";"Temperatures"]
1 10
```

### `.hdf5.getAttrPoints`

_Get the total number of data points in an attribute dataset_

Syntax: `.hdf5.getAttrPoints[fname;oname;aname]`

-   `fname` is the HDF5 file containing the attribute
-   `oname` object to which the attribute is associated
-   `aname` attribute name of interest

returns the number of data points associated with an attribute

```q
q).hdf5.getAttrPoints["test.h5";"dset";"Temperatures"]
10
```

### `.hdf5.getDataShape`

_Get the shape of a dataset_

Syntax: `.hdf5.getDataShape[fname;oname]`

Where

-   `fname` is the HDF5 file containing the dataset 
-   `oname` name of the dataset of interest 

returns an numerical list indicating the shape of the dataset

```q
q).hdf5.getDataShape["test.h5";"dset"]
2 4
```

### `.hdf5.getDataPoints`

_Get the total number of data points in an attribute dataset_

Syntax: `.hdf5.getDataPoints[fname;oname]`

Where

-   `fname` is the HDF5 file containing the dataset
-   `oname` name of the dataset of interest 

returns the number of data points associated with a dataset

```q
q).hdf5.getDataPoints["test.h5";"dset"]
20
```

### `.hdf5.isAttr`

_Does the named attribute exist_

Syntax: `.hdf5.isAttr[fname;oname;aname]`

-   `fname` is the HDF5 file containing the attribute
-   `oname` is the object to which the attribute is associated
-   `aname` name of the attribute

returns a boolean indicating if the attribute exists or not

```q
q).hdf5.isAttr["test.h5";"dset";"Temperatures"]
1b
q).hdf5.isAttr["test.h5";"dset";"Temps"]
0b
```

### `.hdf5.ishdf5`

_Is the specified file a HDF5 file_

Syntax: `.hdf5.ishdf5[fname]`

Where

-   `fname` is a file path

returns a boolean indicating if the file is a hdf5 file or not

```q
q).hdf5.ishdf5["test.h5"]
1b
q).hdf5.ishdf5["test.txt"]
0b
```

### `.hdf5.isObject`

_Is the object specified a group/dataset_

Syntax: `.hdf5.isObject[fname;oname]`

Where

-   `fname` is a HDF5 file
-   `oname` is the path to an object (dataset/group) within the file

returns a boolean indicating if the object exists or not

```q
// Dataset exists
q).hdf5.isObject["test.h5";"dset"]
1b
// Group exists
q).hdf5.isObject["test.h5";"G1"]
1b
// Object doesn't exist
q).hdf5.isObject["test.h5";"not_obj"]
0b
```
 
### `.hdf5.ls`

_Display the structure of a HDF5 file_

Syntax: `.hdf5.ls[fname]`

Where

-   `fname` is a file name of interest

returns a print out of the overall structure of the HDF5 file

```q
q).hdf5.ls["test.h5"]
/ {
  Group: G1 {
    Group: G2 {
      Dataset: group_dset
    }
    Dataset: dset1
  }
  Dataset: dset
}
```
