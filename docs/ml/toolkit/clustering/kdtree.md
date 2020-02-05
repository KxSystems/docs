---
author: Deanna Morgan
date: May 2019
keywords: machine learning, ml, clustering, k-means, dbscan, hierarchical, cure
---

# <i class="fas fa-share-alt"></i> K-D Tree

<i class="fab fa-github"></i>
[KxSystems/ml/clust/kdtree.q](https://github.com/kxsystems/ml/clust/kdtree.q)

A k-d tree (k-dimensional tree) is a special case of a binary search tree with constraints applied. It is a data structure commonly used in computer science to organize data points in k-dimensional space. Each leaf node in the tree represents a k-dimensional point, while each non-leaf node generates a splitting hyperplane that divides the surrounding space.

The median of a dataset is used as the root node of the tree, with the root splitting dimension chosen to reflect the axis with highest variance. At the root node, the dataset is split in two. This process of finding the axis with the widest spread and splitting the remaining data then repeats recursively throughout the tree until a leaf is reached. Leaves can contain more than one data point depending on the construction of the tree.

The placement of each node in the tree is determined by whether the node is less than (to the left) or greater than (to the right) of the proceeding node value.

## Build k-d tree

### `.ml.clust.kd.buildtree`

_Build tree with median data point as root and remaining points subsequently added_

Syntax: `.ml.clust.kd.buildtree[d;r]`

-   `d` is data points (floating values) in horizontal matrix format (`flip value` table)
-   `r` is a value that restricts how many datapoints can be contained at each leaf within the tree. If no reoccuring values are present in the dataset, the datapoints per leaf are restricted to <=2*r. 

returns a k-d tree

```q
q)show d:10 2#20?5.
0.8138311 3.442378
4.088774  3.760051
0.5434121 4.799482
0.183417  3.215491
3.354369  3.394541
2.061585  4.938922
1.933677  3.633905
2.023273  4.177532
3.213685  2.915131
0.7124676 4.574941
q)show t:.ml.clust.kd.buildtree[flip d;3]
-1       0         0        
0        1         0        
0        1         1        
1 2      3 2 9 0 6 7 5 8 4 1
2.023273                    
0                           
q)flip t
-1 0b 0b 1 2       2.023273 0 
0  1b 1b 3 2 9 0 6 0n       0N
0  0b 1b 7 5 8 4 1 0n       0N
```

!!! note

	The k-d tree is shown above and has been flipped to give a clearer picture of the features present. Each column within `flip t` above represent respectively:


	-   The parent node (if at the root node, -1 is given  as no parent exists)
 
	-   Boolean indicating if the node/leaf is to the left `1b` or to the right `0b` of the parent node

	-   Boolen indicating if it is a leaf `1b` or a node `0b`

	-   If at a leaf, the indices of the datapoints contained at that leaf are returned. Otherwise the indices of the nodes/leaves which branch from the node are given 

	-   Pivot point/value of each node (this is a null value if a leaf is reached)

	-   Pivot axis/splitting dimension from which the pivot value was obtained, e.g. x -> 0, y -> 1, z -> 2, etc.


!!! note

	The value of `r` can affect the speed when searching for nearest neighbours in function [.ml.clust.kd.searchfrom](#mlclustkdnnc)


## Find the nearest neighouring cluster

### `.ml.clust.kd.nnc`

_Find the nearest neighbouring cluster to a group of datapoints within a single cluster, returning the index and distance of the nearest cluster_

Syntax: `.ml.clust.kd.nnc[rp;t;cl;d;df]`

-   `rp` is a list of representative points (indices) of the cluster
-   `t` is a k-d tree
-   `cl` is the cluster index of each data point in the tree
-   `d` are the data points within the tree
-   `df` is the distance function: `e2dist` `edist` `mdist`

returns the index and distance of the closest cluster to the current cluster.

```q
q)d
0.8138311 3.442378
4.088774  3.760051
0.5434121 4.799482
0.183417  3.215491
3.354369  3.394541
2.061585  4.938922
1.933677  3.633905
2.023273  4.177532
3.213685  2.915131
0.7124676 4.574941
q)t
-1       0         0        
0        1         0        
0        1         1        
1 2      3 2 9 0 6 7 5 8 4 1
2.023273                    
0          
q)/inputs         [rp ;t;clt inds           ;d;distfnc]
q).ml.clust.kd.nnc[2 9;t;0 1 2 3 4 5 6 7 8 2;d;`e2dist]
0
1.292973
q).ml.clust.kd.nnc[enlist 0;t;0 1 2 3 4 5 6 7 8 2;d;`e2dist]
3
0.4488996
```

!!! note

	In the above example the inputs to `.ml.clust.kd.nnc` data points at indices 2 and 9 have been merged into one cluster. This means that cluster indices have changed from `0123456789` to `0123456782`. Additionally, the data point at index 9 has been set to invalid.

## Find where point belongs in tree

### `.ml.clust.kd.searchfrom`

_Search the tree and find the index of the leaf that each datapoint belongs to_

Syntax: `.ml.clust.kd.searchfrom[x;y;z]`

-   `x` is a k-d tree
-   `y` is the point to search
-   `z` is a node in the k-d tree to start the search

returns the leaf index within the tree that the datapoint belongs to

```q
q)d
0.8138311 3.442378
4.088774  3.760051
0.5434121 4.799482
0.183417  3.215491
3.354369  3.394541
2.061585  4.938922
1.933677  3.633905
2.023273  4.177532
3.213685  2.915131
0.7124676 4.574941
q)t
-1       0         0
0        1         0
0        1         1
1 2      3 2 9 0 6 7 5 8 4 1
2.023273
0
q).ml.clust.kd.searchfrom[t;;0]each d
1 2 1 1 2 2 1 2 2 1
```
