---
title: Guide for using HDF5 with kdb+
author: Conor McCarthy
description: Lists functions available for use within the HDF5 API for kdb+ and gives limitations as well as examples of each being used 
date: March 2020
keywords: HDF5, kdb+, file-format, 
---
# <i class="fa fa-share-alt"></i> User guide 


As outlined in the overview for this API, the kdb+/HDF5 interface is a wrapper for kdb+ around the HDF Groups C API found [here](https://support.hdfgroup.org/HDF5/doc/RM/RM_H5Front.html). 

<i class="fab fa-github"></i>
[KxSystems/hdf5-kdb](https://github.com/KxSystems/hdf5-kdb)

The following functions are those exposed within the `.hdf5` namespace allowing users to convert data between the HDF5 data format and kdb+.

```txt
HDF5 interface functionality
  // Creation functions
  .hdf5.createFile             Create a named hdf5 file
  .hdf5.createGroup            Create a single or multiple group levels
 
  // Writing functions
  .hdf5.writeAttr              Write a named attribute associated to a group or dataset
  .hdf5.writeData              Write data to a named dataset
  
  // Reading functions
  .hdf5.readAttr               Read data from named attribute
  .hdf5.readData               Read data from a named dataset
  
  // Linking functions
  .hdf5.createExternal         Create a hard external link between locations in two files
  .hdf5.createHard             Create a hard link between two locations in a file
  .hdf5.createSoft             Create a soft link between two locations in a file
  .hdf5.delLink                Delete an existing soft or hard link

  // Utility functions
  .hdf5.copyObject             Copy a group or dataset to another file
  .hdf5.dataSize               Size of a HDF5 dataset in MB
  .hdf5.errorOn                Turn the HDF5 C api error signalling on
  .hdf5.errorOff               Turn the HDF5 C api error signalling off (default)
  .hdf5.fileSize               Size of a HDF5 in MB
  .hdf5.getAttrShape           Dimensionality of an attribute
  .hdf5.getDataShape           Dimensionality of a dataset
  .hdf5.gc                     Run garbage collect on free HDF5 lists of all types
  .hdf5.isAttr                 Does this attribute exist
  .hdf5.ishdf5                 Is a file of HDF5 format
  .hdf5.isObject               Does this object exist
  .hdf5.ls                     ls like representation of the structure of a hdf5 file
  .hdf5.version                Version of the HDF5 C api being used
```

For simplicity in each of the examples below it should be assumed that unless otherwise specified a file/group/dataset/attribute that is being manipulated exists and is valid and the results displayed coincide with correct execution in that example.

## Creation functions

The following function relates to the creation of files and groups.

### `.hdf5.createFile`

_Create an named HDF5 file_

Syntax: `.hdf5.createFile[fname]`

Where

-   `fname` name of a HDF5 file as a char string

returns null on successful creation of file. Attempting to create a file that already exists will result in an error

```q
// Create named file
q).hdf5.createFile["test.h5"]

// Attempt to create this file again
q).hdf5.createFile["test.h5"]
'error creating file
```

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

## Write Functions

The following functions relate to writing of kdb+ data to HDF5 files as either attributes or datasets.

### `.hdf5.writeAttr`

_Write a kdb+ dataset to a HDF5 attribute_

Syntax: `.hdf5.writeAttr[fname;oname;aname;dset]`

Where

-   `fname` name of a HDF5 file as a char string
-   `oname` name of the object (group/dataset) which the attribute is to be written to
-   `aname` name of the attribute to be written to
-   `dset`  dataset which is being written to HDF5 format

returns null on successful writing of data to attribute. Failure to write to the attribute will result in an appropriate error

!!!Warning
	* In order to write an attribute to a dataset/group the file and dataset/group specified must already exist

	* Attributes can only be written to with data types where the mapping `q -> HDF5 -> q` does not require a 'datatype_kdb' attribute to be associated with the data see, [here](hdf5-types.md)

```q
// Writing attribute whe file does not exist
q).hdf5.writeAttr["test.h5";"dset";"temperature";10 2#20?1f]
'error opening file

// Writing attribute when dataset or group does not exist
q).hdf5.writeAttr["test.h5";"dset";"temperature";10 2#20?1f]
'error opening dataset/group

// Writing data with an inappropriate type
q).hdf5.writeAttr["test.h5";"dset";"times";10 2#20?0t]
'kdb+ type can not be mapped to an appropriate attribute

// Successful execution
q).hdf5.writeAttr["test.h5";"dset";"temperature";10 2#20?1f]
```

### `.hdf5.writeData`

_Write a kdb+ dataset to a HDF5 dataset_

Syntax: `.hdf5.writeData[fname;dname;dset]`

Where

-   `fname` name of a HDF5 file as a char string
-   `dname` name of the dataset which is to be written to
-   `dset`  dataset which is being written to HDF5 format

returns null on successful writing of data to dataset. Failure to write to the dataset will result in an appropriate error

!!!Warning
	In order to write an dataset to a file this, file must already exist.

```q

// Writing dataset when file does not exist
q).hdf5.writeData["test.h5";"dset";10 2#20?10f]
'error opening file

// Write numeric dataset
q).hdf5.writeData["test.h5";"dset";10 2#20?10]

// Write string data
q).hdf5.writeData["test.h5";"strdset";enlist "test string"]

// Write tabular data
q).hdf5.writeData["test.h5";"table";([]100?1f;100?1f;100?0b;100?0t;100?`4)]

// Write dictionary data
q).hdf5.writeData["test.h5";"dict";`x1`x2`x3!(til 10;5?`4;100?0p)]

```

## Read Functions

The following functions relate to the reading of HDF5 datasets/attributes to an equivalent kdb+ representation.

### `.hdf5.readAttr`

_Read the data contained in a HDF5 attribute to kdb+_

Syntax: `.hdf5.readAttr[fname;oname;aname]`

Where

-   `fname` name of a HDF5 file as a char string
-   `oname` name of the group or dataset which the attribute being read from is associated
-   `aname` name of the attribute from which data is to be read

returns a kdb+ dataset containing the data associated with the named HDF5 attribute

```q
// Read numeric data from attribute
q).hdf5.readAttr["test.h5";"dset";"temperature"]
0.08123546 0.9367503 
0.2782122  0.2392341 
0.1508133  0.1567317 
0.9785     0.7043314 
0.9441671  0.7833686 

// Read string data from attribute 
q).hdf5.readAttr["test.h5";"dset";"Description"]
"This data relates to experiment 1"
"Time difference between values = 1ms"
```

### `.hdf5.readData`

_Read the data contained in a HDF5 dataset to kdb+_

Syntax: `.hdf5.readAttr[fname;dname]`

Where

-   `fname` name of a HDF5 file as a char string 
-   `dname` name of the dataset which is to be read from

returns a kdb+ dataset containing the data associated with a HDF5 dataset 
                                 

```q
// Read numeric data
q)5#.hdf5.readData["test.h5";"dset"]
7.263142  9.216436 
1.809536  6.434637 
2.907093  0.7347808
3.159526  3.410485 
8.617972  5.548864 

// Read string data
q).hdf5.readData["test.h5";"strdset"]
"Value 1 = 0.01"
"Value 2 = 0.02"
"Value 3 = 0.04"

// Read table
q).hdf5.readData["test.h5";"table"]
x          x1         x2 x3           x4  
------------------------------------------
0.2400771  0.7263287  1  08:12:43.345 apah
0.1039355  0.4886361  1  04:42:08.234 mlfb
0.2353326  0.6535973  0  17:54:05.495 fmbf
0.6423479  0.02810674 0  16:58:19.059 iibh
0.5778177  0.4449053  1  12:47:14.478 fpam

// Read dictionary
q).hdf5.readData["test.h5";"dict"]
x1| 0 1 2 3 4 5 6 7 8 9
x2| `nbmb`gbdn`ijca`khjj`gncf
x3| 2003.01.16D01:51:45.083828416 2002.11.25D05:50:34.964843088 2000.09.19D10.
```

## Linking Functions

The following functions allow a user to link datasets/groups internally or externally to a hdf5 file. The explicit definitions of external, hard and soft links as they pertain to the HDF5 data format can be found [here](http://davis.lbl.gov/Manuals/HDF5-1.8.7/UG/09_Groups.html)

### `.hdf5.createExternal`

_Creates an external link to an object in a different file_

Syntax: `.hdf5.createExternal[lfile;lpath;tfile;tpath]`

Where

-   `lfile` HDF5 file containing end point for the new external link     
-   `lpath` object acting as the end point for the link
-   `tfile` target file containing the target object
-   `tpath` target object which is linked to lpath

returns null on successful execution and creates the external link

```q
// Produce a new .h5 file and link a path within this to a dataset in another h5 file
// using the create external link functionality within the api
q).hdf5.createFile["test_external.h5"]
q).hdf5.createExternal["test_external.h5";"/dset";"test.h5";"/dset"]
// Access the data from this new link
q).hdf5.readData["test_external.h5";"/dset"]
0.4707883 0.6346716
0.9672398 0.2306385
0.949975  0.439081
0.5759051 0.5919004
0.8481567 0.389056
```

### `.hdf5.createHard`

_Create a hard link to a physical address in a file_ 

Syntax: `.hdf5.createHard[lfile;lpath;tpath]`
                    
Where               
                    
-   `lfile` HDF5 file within which hard linking takes place
-   `lpath` object acting as the end point for the link
-   `tpath` name of the target path for the new hard link
                    
returns null on successful execution and creates the hard link.

```q
// Create a Group 'G1' to house the new hard link to the dataset
q).hdf5.createGroup["test.h5";"G1"]
// Create a hard link from existing 'dset' to 'G1/dset'
q).hdf5.createHard["test.h5";"G1/dset";"dset"]
// Access the data using the new link
q)5#.hdf5.readData["test.h5";"/G1/dset"]
0.4707883 0.6346716
0.9672398 0.2306385
0.949975  0.439081
0.5759051 0.5919004
0.8481567 0.389056
```

### `.hdf5.createSoft`

_Create a soft/symbolic link between two locations in a HDF5 file_

Syntax: `.hdf5.createSoft[lfile;lpath;tpath]`

Where      

-   `lfile` HDF5 file within which the soft linking takes place 
-   `lpath` object acting as the end point for the link
-   `tpath` name of the target path for the new soft link
                    
returns null on successful execution and creates the specified soft link.

!!!Note
	Neither `lname` or `tname` need to exist prior to the creation of the soft link. They can be populated after its creation. If the links are to be contained within a group this group however must exist

```q
// Create a group 'G1' within the file 'test.h5'
q).hdf5.createGroup["test.h5";"G1"]

// Create a soft link (symbolic link) between two unpopulated points in the file
q).hdf5.createSoft["test.h5";"/G1/dset1";"/G1/dset2"]

// Write data to 'G1/dset2'
.hdf5.writeData["test.h5";"G1/dset2";4 5#20?10]

// Read the data from the location 'G1/dset1'
q).hdf5.readData["tets.h5";"/G1/dset1"]
8 1 9 5 4 6
6 1 8 5 4 9
2 7 0 1 9 2
1 8 8 1 7 2
```

### `.hdf5.delLink`

_Delete an assigned external hard or soft link_

Syntax: `.hdf5.delLink[lfile;lpath]`

Where

-   `lfile` HDF5 file within which the link to be deleted is contained
-   `lpath` name of the link to be deleted within a HDF5 file

returns a message indicating successful deletion of a link.

```q
// Create a delete a soft link
q).hdf5.delLink["test.h5";"/G1/dset1"]
"Successfully deleted the link"
// Attempt to delete the link again
q).hdf5.delLink["test.h5";"/G1/dset1"]
'could not delete specified link 
```

## Utility Functions

The following are a number of utility functions which may be useful when dealing with HDF5 objects and files.

### `.hdf5.copyObject`

_Copy a hdf5 dataset or group from one file to another_

Syntax: `.hdf5.copyObject[fname;oname;fdest;odest]`

Where

- `fname` is the name of the file containing the object to be copied
- `oname` is the name of the object to be copied
- `fdest` is the destination file for the copied object
- `odest` it the path in the destination file to which the copied object is associated

return null on successful execution, will error if there are issues accessing files

```q
q).hdf5.writeData["test.h5";"dset";100?5]
q).hdf5.createFile["testing.h5"]
// Copy original object to a new file
q).hdf5.copyObject["test.h5";"dset";"testing.h5";"data"]
q).hdf5.readData["testing.h5";"data"]
4 0 2 1 2 1 2 3 2 4 1 0 2 4 1 2 0 1 1 2 1 0 0 1 ..
```

### `.hdf5.fileSize`

_Size of a HDF5 file in MB_

Syntax: `.hdf5.fileSize[fname]`

Where

- `fname` is the name of a HDF5 file

return the size of a HDF5 in MB

```q
q).hdf5.fileSize["test.h5"]
8.002048
```

### `.hdf5.dataSize`

_Size of an uncompressed HDF5 dataset in MB_

Syntax: `.hdf5.dataSize[fname;dname]`

Where

- `fname` is the name of the file containing a dataset
- `dname` is the name of the dataset

return the size of a HDF5 dataset in MB

```q
q).hdf5.dataSize["test.h5";"dset"]
8f
```

### `.hdf5.errorOff`

_Turn off printing of errors from HDF5 C api_

Syntax: `.hdf5.errorOff[]`

returns null on successful execution

!!!Note
        This interface by default is initialized with HDF5 erroring turned off.

```q
// Failing function called with HDF5 error ons
q).hdf5.createFile["test.h5"]
HDF5-DIAG: Error detected in HDF5 (1.10.5) thread 0:
  #000: H5F.c line 444 in H5Fcreate(): unable to create file
    major: File accessibilty
    minor: Unable to open file
  #001: H5Fint.c line 1558 in H5F_open(): unable to open file
    major: File accessibilty
    minor: Unable to open file
  #002: H5FD.c line 734 in H5FD_open(): open failed
    major: Virtual File Layer
    minor: Unable to initialize object
  #003: H5FDsec2.c line 346 in H5FD_sec2_open(): unable to open file:
    major: File accessibilty
    minor: Unable to open file
'error creating file
  [0]  .hdf5.createFile["test.h5"]

// Turn off errors and repeat the above function call
q).hdf5.errorOff[]
q).hdf5.createFile["test.h5"]
'error creating file
```

### `.hdf5.errorOn`

_Turns on printing of errors from HDF5 C api_

Syntax: `.hdf5.errorOn[]`

returns null on successful execution

!!!Note
        This interface by default is initialized with HDF5 erroring turned off.

```q
// Execute an invalid command with error printing off
q).hdf5.createFile["test.h5"]
'error creating file

// Turn error printing on and repeat command
q).hdf5.errorOn[]
q).hdf5.createFile["test.h5"]
HDF5-DIAG: Error detected in HDF5 (1.10.5) thread 0:
  #000: H5F.c line 444 in H5Fcreate(): unable to create file
    major: File accessibilty
    minor: Unable to open file
  #001: H5Fint.c line 1558 in H5F_open(): unable to open file
    major: File accessibilty
    minor: Unable to open file
  #002: H5FD.c line 734 in H5FD_open(): open failed
    major: Virtual File Layer
    minor: Unable to initialize object
  #003: H5FDsec2.c line 346 in H5FD_sec2_open(): unable to open file:
    major: File accessibilty
    minor: Unable to open file
'error creating file
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

### `.hdf5.version`

_Display C api major/minor/release versions_

Syntax: `.hdf5.version[]`

returns a dictionary with the major/minor and release versions of the HDF groups C api

```q
q).hdf5.version[]
Major  | 1
Minor  | 10
Release| 5
```
