---
title: Using HDF5 with kdb+ – Interfaces
description: Interface to allow the reading and writing of HDF5 data to and from kdb+  
date: March 2020
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
keywords: HDF5, api, fusion, interface, conversion, data formatting
---
# ![HDF5](../img/hdf5.jpeg) Using HDF5 data with kdb+

<i class="fab fa-github"></i> [KxSystems/hdf5](https://github.com/KxSystems/hdf5)

## Introduction

[Hierarchical Data Format 5(HDF5)](https://portal.hdfgroup.org/display/HDF5/HDF5) is a file format designed specifically for the storage and organisation of large amounts of data. It is supported by the HDF Group and free to use under a BSD-like licence. 

In many ways HDF5 acts like a truly hierarchical file system similar to that used by Linux or Windows. This structure contains two primary objects:

1. Datasets - These may contain multidimensional arrays of homogenously typed data or compound data containing a mixture of types. These act similar to files within a traditional POSIX file system.
2. Groups - These act as container structures which can hold datasets or other further groups. These act similar to folders in a traditional POSIX file system.

There are a number of secondary objects and structures which add complexity to the format and in doing so allow the format to be used for a wider number of use cases

* Attributes: These allow metadata information to be associated with a dataset or group i.e. Associate the date of data collection with a group or the room temperature at the time a set of results was collected.
* Linking functionality: Like a traditional POSIX file system it is possible to create links between objects (hard/soft/external), these allow datasets or groups relevant to multiple experiments or use-cases to be accessed via routes that a user may find more intuitive.

### Use-cases

This data format is used across a number of sectors with use-cases including but limited to the storage of

1. Neural network architectures (Python Keras)
2. Geological and Hydrological datasets.
3. Astrophysical earth observation data for NASA

Further information on sectors which make use of this technology can be found [here](https://support.hdfgroup.org/HDF5/users5.html)

### kdb+/HDF5 Integration

The purpose of this interface is to provide kdb+ users with the ability to convert data between HDF5 and kdb+ in order to allow users familiar with either technology to analyse data in a format which they may be more familiar with.

The interface follows closely the HDF5 C api available [here](https://support.hdfgroup.org/HDF5/doc/RM/RM_H5Front.html). In certain cases structures or types common in HDF5 or q may by necessity need to be modified to account for differences between the two data formats. In cases where this is necessary documentation will indicate the assumptions made and expected behaviour, this is particularly the case in the mapping of types as outlined [here](hdf5-types.md).

Exposed functionality includes

1. Creation of files/attributes/datasets/groups/links.
2. Read/Write HDF5 data or attributes from a kdb+ session.
3. Link locations within files.

A full outline of the available functionality is outlined [here](user-guide.md) with example inplementations outlined [here](examples.md).

Installation of this interface can be completed by following the install guide outlined [here](https://github.com/KxSystems/hdf5#installation).

## Status

This interface is currently available as a beta version under an Apache 2.0 licence and is supported on a best effort basis by the Fusion team. This interface is currently in active development, with additional functionality to be released on a rolling basis.

If you find issues with the interface or have feature requests please consider raising an issue [here](https://github.com/KxSystems/hdf5/issues). If you wish to contribure to this project please follow the contributing guide [here](https://github.com/KxSystems/hdf5/blob/master/CONTRIBUTING.md)
