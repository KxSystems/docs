---
title: K-dimensional tree reference | Clustering | Machine Learning Toolkit | Documentation for kdb+ and q
author: Deanna Morgan
date: May 2019
keywords: machine learning, ml, clustering, k-means, dbscan, hierarchical, cure, kdtree, k-dimensional tree
---

# :fontawesome-solid-share-alt: K-D tree reference

<div markdown="1" class="typewriter">
.ml.clust.kd   **k-d tree functions**

\  [newtree](#mlclustkdnewtree)       build a k-d tree
  [nn](#mlclustkdnn)            find the nearest neighbor for a datapoint
  [findleaf](#mlclustkdfindleaf)      find the leaf node to which a datapoint belongs
</div>

:fontawesome-brands-github:
[KxSystems/ml/clust/kdtree.q](https://github.com/kxsystems/ml/blob/master/clust/kdtree.q)

A k-dimensional tree (k-d tree) is a special case of a binary search tree, commonly used in computer science to organize data points in k-dimensional space. Each leaf node in the tree contains a set of k-dimensional points, while each non-leaf node generates a splitting hyperplane which divides the surrounding space.

At each non-leaf node, the dataset is split roughly in two. A splitting dimension is chosen to reflect the axis with highest variance, and the median value for the dataset is used to split the data along this axis. The placement of each node in the tree is determined by whether the node is less than (to the left of) or greater than (to the right of) the proceeding median value. This splitting process repeats recursively throughout the tree, until a small enough number of points remain to form a leaf.


## `.ml.clust.kd.findleaf`

_Find the tree index of the leaf that a datapoint belongs to_

```txt
.ml.clust.kd.findleaf[tree;pt;node]
```

Where

-   `tree` is a k-d tree
-   `pt` is the point to search
-   `node` is a node in the k-d tree to start the search

returns the index (row) of the kd-tree that the datapoint belongs to.

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

q)// Point to search
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

Both `.ml.clust.kd.nn` and `.ml.clust.kd.findleaf` functions can use either q or C code in their implementations. 

:fontawesome-brands-github:
[Instructions to build C code](https://github.com/KxSystems/ml/blob/master/clust/README.md)

To switch between the implementations, `.ml.clust.kd.qC[b]` can be used, where `b` is a boolean indicating whether to use the q (`1b`) or C (`0b`) code. If the C code is not available, the function will default to q regardless of the input.


## `.ml.clust.kd.newtree`

_Build k-d tree_

```txt
.ml.clust.kd.newtree[data;leafsz]
```

Where

-   `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
-   `leafsz` is the minimum number of datapoints contained within each leaf of the tree.

returns a k-d tree table with columns:

```txt
leaf        whether leaf (boolean)
left        whether node/leaf is to the left of its parent node (boolean)
self        tree index of current node
parent      tree index of the parent node
children    tree indexes of any child nodes
axis        splitting dimension of current node (null if leaf node)
midval      splitting value of current node (null if leaf node)
idxs        indexes (column in data) of datapoints contained in a leaf
```

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

!!! tip "The value of `leafsz` can affect the speed when searching for nearest neighbors."


## `.ml.clust.kd.nn`

_Find the nearest neighbor for a data point_

```txt
.ml.clust.kd.nn[tree;data;df;xidxs;pt]
```

Where

-   `tree` is a k-d tree
-   `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
-   `df` is the distance function: `e2dist` `edist` `mdist`
-   `xidxs` are the indices (columns in `data`) to be excluded from the nearest neighbor search (`()` if any point can be chosen)
-   `pt` is the floating data point to be searched

returns a dictionary containing the distance (`closestDist`) and the column index in `data` (`closestPoint`) of the nearest neighbor.

```q
q)show d:2 10#20?10.
3.927524 5.170911 5.159796  4.066642 1.780839 3.017723 ..
4.931835 5.785203 0.8388858 1.959907 3.75638  6.137452 ..

q)show tree:.ml.clust.kd.newtree[d;3]
leaf left self parent children axis midval   idxs
------------------------------------------------------
0    0    0           1 2      1    5.294808 `long$()
1    1    1    0      `long$()               0 2 3 4 8
1    0    2    0      `long$()               1 5 6 7 9
q).ml.clust.kd.nn[tree;d;`e2dist;();1 2f]
closestPoint| 4
closestDist | 3.694579

q)// finds nearest neighbor excluding point 4
q).ml.clust.kd.nn[tree;d;`e2dist;4;1 2f]
closestPoint| 3
closestDist | 9.4059
```


