---
title: Example usage | HDF5 | Interfaces | Documentation for kdb+ and q
author: Conor McCarthy
description: Minimal examples showing the use of the HDF5 kdb+ interface 
date: March 2020
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
keywords: HDF5, kdb+, examples, read, write, link, group
---
# Example usage of interface 

Here is an example of how to read, write, modify and inspect a HDF5 dataset from a kdb+ session. The associated repository has examples with more functionality.

:fontawesome-brands-github: 
[KxSystems/hdf5-kdb/examples](https://github.com/KxSystems/hdf5-kdb/tree/master/examples)

A typical workflow when dealing with HDF5 data:

## Create a `.h5` file 

Create a `.h5` file to house experimental datasets.

```q
//create a file named appropriately
q)fname:"experiments.h5"
q).hdf5.createFile[fname]

//Check that this file exists
q).hdf5.ishdf5[fname]
1b
```

## Create a dataset 

Create a dataset containing experimental information and write to a file.

```q
// Create a dataset of floating point data and write to HDF5
q)show dset:dims#prd[dims:5*1+til 5]?10f
3.927524  5.170911 5.159796  4.066642  1.780839  3.017723 7.85033    5.347096..
1.572794   4.25421    2.573062  1.30827   1.930758  6.585985   3.227891 3.888..
9.822297  8.278122  6.610537 5.013077  8.215865 2.360797  6.881804 1.411613  ..
9.674024   9.491312  8.290642  8.987704  6.497505  1.057242   4.66386   8.425..
5.260983  4.556574   9.517531 5.659605  0.864824  0.8628434 4.824764  3.95274..
q)dset_name:"experiment1_data"
q).hdf5.writeData[fname;dset_name;dset]

// Inspect the content of the file to ensure the data has been written to file
q).hdf5.ls[fname]
/ {
  Dataset: experiment1_data
}
```


## Add attributes to the dataset 

Add attributes to the dataset indicating who collected the dataset and the temperature of the room at the start and end of data collection.


```q
// Add an attribute named for the scientists collecting data
q)user_attr:"Completed by"
q).hdf5.writeAttr[fname;dset_name;user_attr;"Alice and Bob"]

// Add an attribute indicating room temperature
q)temp_attr:"Temperatures"
q).hdf5.writeAttr[fname;dset_name;temp_attr;21.7 20.3]
```


## Create a group 

Create a group to contain tables related to another experiment.

```q
// Create a group within the dataset
q)gname:"experiment2_tables"
q).hdf5.createGroup[fname;gname]

// Inspect the content of the file
q).hdf5.ls[fname]
/ {
  Group: experiment2_tables {
  }
  Dataset: experiment_data
}
```


## Write a set of tabular data 

Write a set of tabular data collected from sensors into the `experiment2_tables` group

```q
// Create a kdb+ table and write this to a dataset in the appropriate group
q)N:10000
q)tname:gname,"/tab_dset"
q)5#dset_tab:([]tstamp:asc N?0p;voltage:N?1f;volume:N?100;class:N?10h;on_off:N?0b)
tstamp                        voltage   volume class on_off
-----------------------------------------------------------
2000.01.01D01:03:27.925513386 0.1458085 85     0     0     
2000.01.01D05:46:27.469021975 0.4981235 99     9     0     
2000.01.01D06:14:44.435858577 0.1976848 75     8     0     
2000.01.01D09:38:22.896863222 0.2246491 63     4     0     
2000.01.01D11:13:14.535212963 0.82371   45     1     0     
q).hdf5.writeData[fname;tname;dset_tab]

// Inspect the content of the file
q).hdf5.ls[fname]
/ {
  Group: experiment2_tables {
    Group: tab_dset {
      Dataset: class
      Dataset: on_off
      Dataset: tstamp
      Dataset: voltage
      Dataset: volume
    }
  }
  Dataset: experiment1_data
}
```


## Read data and attributes back into kdb+

Read the data and attributes written to the file back into kdb+.

```q
// Read back the dataset "experiment1_data"
q).hdf5.readData[fname;"experiment1_data"]
3.927524  5.170911 5.159796  4.066642  1.780839  3.017723 7.85033    5.347096..
1.572794   4.25421    2.573062  1.30827   1.930758  6.585985   3.227891 3.888..
9.822297  8.278122  6.610537 5.013077  8.215865 2.360797  6.881804 1.411613  ..
9.674024   9.491312  8.290642  8.987704  6.497505  1.057242   4.66386   8.425..
5.260983  4.556574   9.517531 5.659605  0.864824  0.8628434 4.824764  3.95274..

// Read the attributes outlining the scientists and temperatures at the time of the experiment
q).hdf5.readAttr[fname;dset_name;]each(user_attr;temp_attr)
"Alice and Bob"
21.7 20.3

// Read the table stored for in "experiment2_tables" back to kdb+
q)5#.hdf5.readData[fname;"experiment2_tables/tab_dset"]
tstamp                        fdata     jdata                hdata bdata
------------------------------------------------------------------------
2000.01.01D02:36:49.894041717 0.6629197 7562568519879588350  0     1    
2000.01.01D03:40:09.942953288 0.5822169 3403572723019440513  1     0    
2000.01.01D08:39:00.615521371 0.2564546 4273682761033353527  0     0    
2000.01.01D12:09:27.866282165 0.1936573 3462325873973710832  4     1    
2000.01.02D05:48:47.516824007 0.1653556 110707218304197100   3     1    
```

