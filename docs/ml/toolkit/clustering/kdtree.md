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

### `.ml.clust.kd.newtree`

_Build tree with median data point as root and remaining points subsequently added_

Syntax: `.ml.clust.kd.newtree[data;leafsz]`

-   `data` is a horizonal matrix of (float) data points
-   `leafsz` is the maximum number of data points contained within each leaf of the tree. If no reoccuring values are present in `data`, the number of data points per leaf are restricted to `<=2*r`. 

returns a k-d tree table with the following columns

- `leaf` Boolean indicating if leaf 1b or node 0b
- `left` Boolean indicating if node/leaf is to the left 1b or to the right 0b of the parent node
- `self `Tree index
- `parent` Index of the parent node
- `children` Indices of the nodes/leaves which branch from a node
- `axis` Splitting dimension from which the pivot value was obtained, e.g. x -> 0, y -> 1, z -> 2, etc.
- `midval` Pivot/splitting value of each node - null if leaf has been reached
- `idxs` Indices of data points contained in a leaf

```q
q)show d:2 10#20?10.
5.497936 1.958467   5.615261 0.7043811 2.124007 7.77882 ...
4.57328  0.08062521 1.039343 1.044512  3.380097 4.861546...
q).ml.clust.kd.newtree[d;2]
leaf left self parent children axis midval   idxs    
-----------------------------------------------------
0    0    0           1 4      1    4.57328  `long$()
0    1    1    0      2 3      0    2.124007 `long$()
1    1    2    1      `long$()               1 3     
1    0    3    1      `long$()               2 4 9   
0    0    4    0      5 6      0    5.497936 `long$()
1    1    5    4      `long$()               6 8     
1    0    6    4      `long$()               0 5 7   
q).ml.clust.kd.newtree[d;4]
leaf left self parent children axis midval  idxs     
-----------------------------------------------------
0    0    0           1 2      1    4.57328 `long$() 
1    1    1    0      `long$()              1 2 3 4 9
1    0    2    0      `long$()              0 5 6 7 8
```


!!! note

	The value of `r` can affect the speed when searching for nearest neighbours


## Find the nearest neighouring cluster

### `.ml.clust.kd.nn`

_Find the nearest neighbouring cluster to a data point, returning the index and distance of the nearest cluster_

Syntax: `.ml.clust.kd.nn[tree;data;df;xidxs;pt]`

-   `tree` is a k-d tree
-   `data` is the data points within the tree in a horizontal matrix format
-   `df` is the distance function: `e2dist` `edist` `mdist`
-   `xidxs` are the indices in the tree that are not to be chosen as the nearest neighbour of the point
-   `pt` is the floating data point to be searched

returns a dictionary containing the index (`closestPoint`) and distance (`closestPoint`) of the closest point

```q
q)show d:2 10#20?10.
4.244877 9.025784 4.470818  1.387079 9.409523 0.0283353...
8.851612 4.358676 0.7788199 4.233767 6.228321 1.972122 ...
q)show tree:.ml.clust.kd.newtree[d;3]
leaf left self parent children axis midval   idxs     
------------------------------------------------------
0    0    0           1 2      0    4.470818 `long$() 
1    1    1    0      `long$()               0 3 5 7 8
1    0    2    0      `long$()               1 2 4 6 9
q).ml.clust.kd.nnc[2 9;t;0 1 2 3 4 5 6 7 8 2;d;`e2dist]
q).ml.clust.kd.nn[tree;d;`e2dist;0 1;1 2f]
closestPoint| 7
closestDist | 0.2017758
q).ml.clust.kd.nn[tree;d;`e2dist;0 1 7;1 2f]
closestPoint| 5
closestDist | 0.9449095
```

## Find where point belongs in tree

### `.ml.clust.kd.findleaf`

_Search the tree and find the index of the leaf that each datapoint belongs to_

Syntax: `.ml.clust.kd.findleaf[tree;pt;node]`

-   `tree` is a k-d tree
-   `pt` is the point to search
-   `node` is a node in the k-d tree to start the search

returns the row of the kd-tree that the data point belongs to

```q
q)show d:2 10#20?10.
8.132478 1.291938  1.477547 2.74227  5.635053 8.83823 ...
5.426371 0.7757332 6.374637 9.761246 5.396816 7.162858...
q)show tree:.ml.clust.kd.newtree[d;2]
leaf left self parent children axis midval   idxs    
-----------------------------------------------------
0    0    0           1 4      0    6.718125 `long$()
0    1    1    0      2 3      1    5.396816 `long$()
1    1    2    1      `long$()               1 6     
1    0    3    1      `long$()               2 3 4   
0    0    4    0      5 6      1    6.568734 `long$()
1    1    5    4      `long$()               0 7     
1    0    6    4      `long$()               5 8 9   
// Point to search
q)show pt:2?10f
3.414991 9.516746
q).ml.clust.kd.findleaf[tree;pt;first tree]
leaf    | 1b
left    | 0b
self    | 3
parent  | 1
children| `long$()
axis    | 0N
midval  | 0n
idxs    | 2 3 4
```
