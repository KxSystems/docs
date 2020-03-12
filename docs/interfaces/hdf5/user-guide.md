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
  .hdf5.datasetInfo            Information about type, number of dimension and dimensionality
  .hdf5.gc                     Garbage collect on free HDF5 lists of all types
  .hdf5.ls                     ls like representation of the structure of a hdf5 file
```

For simplicity in each of the examples below it should be assumed that unless otherwise specified a file/group/dataset/attribute that is being manipulated exists and is valid and the results displayed coincide with correct execution


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
	If the file does not exist it will be created, in this case the dataset can ONLY be written to the root directory of the file


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
        If a file already exists it will not be overwritten.


## Write Functions

The following functions relate to writing of kdb+ data to HDF5 files either contained in attributes or datasets.

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
-   `oname` name of the object dataset which is to be written to
-   `dset`  dataset which is being written to HDF5 format

returns null on successful writing of data to dataset. Failure to write to the dataset will result in an appropriate error

!!!Note
        The function `.hdf5.createDataset` can be used to create a dataset prior to writing. Use of this function in case where a file or dataset had not been previously been created will create the file and the datset, appropriately dimensioned and typed based on the provided dataset.

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


## Linking Functions

The following functions allow a user to link datasets/groups internally or externally to a hdf5 file.


## Group Functions

The following function is used to create an individual or set of intermediate groups.


## Utility Functions

The following are a number of utility functions which may be useful when dealing with HDF5 objects and files.
