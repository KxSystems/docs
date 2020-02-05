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

-   `d` is a horizonal matrix of (float) data points (`value flip` table)
-   `r` is the maximum number of data points contained within each leaf of the tree. If no reoccuring values are present in `d`, the number of data points per leaf are restricted to `<=2*r`. 

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

	The k-d tree above has been flipped to give a clearer picture of the features present. The columns of `flip t` represent the following:


	-   Index of the parent node - `-1` is used for the root node as no parent exists
	-   Boolean indicating if node/leaf is to the left `1b` or to the right `0b` of the parent node
	-   Boolean indicating if leaf `1b` or node `0b`
	-   Indices of data points contained in a leaf or indices of the nodes/leaves which branch from a node 
	-   Pivot/splitting value of each node - null if leaf has been reached
	-   Splitting dimension from which the pivot value was obtained, e.g. x -> 0, y -> 1, z -> 2, etc.


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

	In the example above, the data points at indices 2 and 9 are merged into one cluster and passed in as `rp` to `.ml.clust.kd.nnc`. As these points now belong to the same cluster, the cluster indices change from `0123456789` to `0123456782`. The data point at index 9 has also been set to invalid.

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
