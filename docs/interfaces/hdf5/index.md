---
title: Using HDF5 with kdb+ – Interfaces
description: Interface to allow the reading and writing of HDF5 data to and from kdb+  
date: March 2020
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
keywords: HDF5, api, fusion, interface, conversion, data formatting
---
# ![HDF5](../img/hdf5.jpeg) Using HDF5 data with kdb+


<i class="fab fa-github"></i> [KxSystems/hdf5](https://github.com/KxSystems/hdf5)

`hdf5` is a wrapper for kdb+ around the HDF5 C API outlined in detail [here](https://support.hdfgroup.org/HDF5/doc/RM/RM_H5Front.html)

## Introduction

Hierarchical Data Format 5(HDF5) is a file format designed explicitely for the storage and organisation of large amounts of data. It is supported by the HDF Group and free to use under a BSD-like licence. This data format is used extensively in scientific research and in particular astronomy. 

HDF5 data acts in many ways like a truely hierarchical filesystem-like data format and consists of two major types of object:

1. Datasets which contain multidimensional arrays of homogenous type
2. Groups which act as container structures which can hold datasets or other groups

There are a number of secondary objects and structures which add complexity to the format but in doing so allow the format to be used for a wider number of use cases

* Attributes: These allow metadata information to be associated with a dataset or group i.e. Associate the date of data collection with a group or a room temperature at the time of a set of results being collected.
* Linking functionality: Like a traditional unix-like file system it is possible to create symbolic links between objects (hard/soft/external), these allow datasets or groups pertinent to multiple experiments or use-cases to be accessed via routes that a user may find more logical.

## API

The library follows the `HDF5` C API closely where possible however structures or types common in HDF5 or q may by necessity need to be modified to account for discrepencies between the two data formats.

In cases where this is necessary documentation will indicate the assumptions made and expected behaviour in the current interface.

## Status

This interface is currently available as a beta version and is supported on a best effort basis by the Fusion team. This interface is currently in active development, with additional functionality to be added over time.
