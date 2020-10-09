---
title: Using HDF5 with kdb+ | Interfaces | Documentation for kdb+ and q
description: Interface to allow the reading and writing of HDF5 data to and from kdb+  
date: March 2020
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
keywords: HDF5, api, fusion, interface, conversion, data formatting
---
# ![HDF5](../img/hdf5.jpeg) Using HDF5 data with kdb+

:fontawesome-brands-github:
[KxSystems/hdf5](https://github.com/KxSystems/hdf5)


[Hierarchical Data Format 5 (HDF5)](https://portal.hdfgroup.org/display/HDF5/HDF5) is a file format designed specifically for the storage and organization of large amounts of data. It is supported by the HDF Group and free to use under a BSD-like licence. 

In many ways HDF5 acts like a truly hierarchical file system similar to that used by Linux or Windows. This structure contains two primary objects:

Datasets 

: These may contain multidimensional arrays of homogenously-typed data or compound data containing a mixture of types. These act similarly to files within a traditional POSIX file system.

Groups 

: These act as container structures which can hold datasets or other further groups. These act similarly to folders in a traditional POSIX file system.

A number of secondary objects and structures add complexity to the format and in doing so allow the format to be used for a wider number of use cases.

Attributes

: Allow metadata information to be associated with a dataset or group, i.e. associate the date of data collection with a group or the room temperature at the time a set of results was collected.

Linking functionality

: Like a traditional POSIX file system, it is possible to create links between objects (hard/soft/external); these allow datasets or groups relevant to multiple experiments or use cases to be accessed via routes that a user may find more intuitive.

### Use cases

This data format is used across a number of sectors with use-cases including but limited to the storage of

-   Neural network architectures (Python Keras)
-   Geological and Hydrological datasets.
-   Astrophysical earth observation data for NASA

Further information on sectors which make use of this technology can be found [here](https://support.hdfgroup.org/HDF5/users5.html)

### Kdb+/HDF5 integration

This interface lets kdb+ users convert data between HDF5 and kdb+ in order to allow users familiar with either technology to analyze data in a format which they may be more familiar with.

The interface follows closely the [HDF5 C API](https://support.hdfgroup.org/HDF5/doc/RM/RM_H5Front.html). In certain cases structures or types common in HDF5 or q may by necessity need to be modified to account for differences between the two data formats. In cases where this is necessary, documentation will indicate the assumptions made and expected behavior. This is particularly the case in the [mapping of types](hdf5-types.md).

Exposed functionality includes

-   creation of files/attributes/datasets/groups/links
-   read/write HDF5 data or attributes from a kdb+ session
-   link locations within files

:fontawesome-regular-hand-point-right:
[Full outline of the available functionality](reference.md)
with [example implementations](examples.md)
<br>
:fontawesome-brands-github:
[Install guide](https://github.com/KxSystems/hdf5#installation)

## Status

This interface is currently available under an Apache 2.0 licence and is supported on a best-efforts basis by the Fusion team. This interface is currently in active development, with additional functionality to be released on a rolling basis.

If you find issues with the interface or have feature requests please 
:fontawesome-brands-github:
[raise an issue](https://github.com/KxSystems/hdf5/issues). 

To contribute to this project follow the 
:fontawesome-brands-github:
[contributing guide](https://github.com/KxSystems/hdf5/blob/master/CONTRIBUTING.md).