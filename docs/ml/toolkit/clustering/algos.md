---
author: Deanna Morgan
date: May 2019
keywords: machine learning, ml, clustering, k-means, dbscan, hierarchical, cure
---

# <i class="fas fa-share-alt"></i> Clustering Algorithms

The clustering library provides a number of implementations of the common clustering algorithms in q. These algorithms are based on three distinct clustering methodologies

1. Centroid-based models: cluster based on the distances of data points from central points which represent the cluster - Affinity Propagation and K-Means.
2. Connectivity-based models: cluster based on the distances between individual data points - Hierarchical clustering and CURE.
3. Density-based models: cluster based on data points being within a certain distance of each other and in defined concentrations - DBSCAN.

The following are the models provided within this library

```txt
.ml.clust - Clustering Algorithms
  // Centroid-based models
  .ap                 Affinity Propogation
  .kmeans             K-Means clustering

  // Connectivity-based models
  .cure               Implementation of the CURE algorithm
  .hc                 Implemenation of hierarchical clustering

  // Density-based models
  .dbscan             Implementation of density-based 
```

<i class="fab fa-github"></i>
[KxSystems/ml/clust/clust.q](https://github.com/kxsystems/ml/clust/clust.q)

## Centroid-Based Models

Two centroid-based models are provided within this library

1. **Affinity Propagation**:
	
	This algorithm groups data based on the similarity between points and subsequently finds k exemplars which best represent the points in each cluster. Similarly to DBSCAN, the algorithm does not require the user to input the number of clusters. The algorithm will determine the optimum solution by exchanging real-valued messages between points until high-valued set of exemplars is produced.

	The algorithm uses a user specified damping coefficient to reduce the availability and responsibility of messages passed between points, while a preference value is used to set the diagonal values of the similarity matrix. A more detailed explanation of the algorithm can be found [here](https://towardsdatascience.com/unsupervised-machine-learning-affinity-propagation-algorithm-explained-d1fef85f22c8).

2. **K-Means**:

	K-means clustering begins by selecting k data points as cluster centres and assigning data to the cluster with the nearest centre.

	The algorithm follows an iterative refinement process which runs a specified number of times, updating the cluster centers and assigned points at each iteration.


### `.ml.clust.ap`

_Affinity Propagation: Cluster data using exemplars_

Syntax: `.ml.clust.ap[data;df;dmp;diag]`

Where

- `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
- `df` is the distance function as a symbol: `nege2dist` is recommended for this algorithm. (see [section](## Distance Metrics))
- `dmp` is the damping coefficient to be applied to the availability and responsibility matrices.
- `diag` is the preference function for the diagonal of the similarity matrix (e.g.  `min` `med` `max` etc.).

returns a list indicating the cluster to which each data point belongs

```q
q)show d:2 10#20?10.
0.8123546 9.367503 2.782122 2.392341 1.508133 ..
4.099561  6.108817 4.976492 4.087545 4.49731  ..
q)show APclt:.ml.clust.ap[d;`nege2dist;.3;med]
0 1 2 2 0 2 1 3 3 1
// Group indices into their calculated clusters
q)group APclt
0| 0 4
1| 1 6 9
2| 2 3 5
3| 7 8
```

### `.ml.clust.kmeans`

_Cluster data using k-means_

Syntax: `.ml.clust.kmeans[data;df;k;iter;kpp]`

Where

-   `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
-   `df` is the distance function: `e2dist` `edist` (see [section](##Distance Metrics))
-   `k` is the number of clusters
-   `iter` is the number of iterations to be completed
-   `kpp` is a boolean flag indicating the initialisaton type: The initial cluster points are chosen using the [k-means++](https://en.wikipedia.org/wiki/K-means%2B%2B) algorithm or by selecting k random points using 1b/0b respectively

returns a list indicating the cluster each data point belongs to

```q
q)show d:2 10#20?5.
1.963762 2.585456 2.579898  2.033321  0.8904193 1.508861 ...
2.465917 2.892601 0.4194429 0.9799536 1.87819   3.068726 ...
// Initialise using the k++ algorithm
q).ml.clust.kmeans[d;`e2dist;3;10;1b]
0 0 1 1 0 0 2 0 2 0
// Initialise using random centers
q).ml.clust.kmeans[d;`e2dist;3;10;0b]
0 1 2 2 0 0 1 1 2 0
q).ml.clust.kmeans[d;`mdist;3;10;1b]
'kmeans must be used with edist/e2dist
```

!!! note
      The distance metrics which can be used with the K-Means algorithm are the euclidean squared distances (`e2dist`,`edist`). The use of any other distance metric will result in a error being flagged.

## Connectivity-based models

Two connectivity-based models are provided with this library

1. **CURE**:

	CURE clustering is a technique used to deal with datasets containing outliers and clusters of varying sizes and shapes. Each cluster is represented by a specified number of representative points. These points are chosen by taking the the most scattered points in each cluster and shrinking them towards the cluster centre by a fixed amount, known as the compression.

	In the implementation below, a k-d tree is used in order to store the representative points of each cluster (more information [here](https://code.kx.com/v2/ml/toolkit/clustering/kdtree)). Both q and C implementations of the tree are available. Instructions to build the C code can be found [here](https://github.com/Dianeod/ml-1/blob/cluster/clust/README.md) on the github repo.

2. **Hierarchical Clustering**:

	The implementation of hierarchical clustering described below groups data using an agglomerative/bottom-up approach which initially treats all data points as individual clusters.

	There are 5 possible linkages in hierarchical clustering: single, complete, average, centroid and ward. Euclidean or manhattan distances can be used for with each linkage, except for ward which only works with euclidean squared distances. Additionally, a k-d tree has been used for the single and centroid implementations.
	

### `.ml.clust.ccure`

_Cluster data using representative points_

Syntax: `.ml.clust.ccure[data;df;k;n;c]`

Where

- `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
- `df`  is the distance function as a symbol: `e2dist` `edist` `mdist` (see [section](##Distance Metrics))
- `k` is the number of clusters
- `n` is the number of representative points
- `c` is the compression

returns a list indicating the cluster each data point belongs to

```q
q)show d:2 10#20?20.
8.24634 19.75569 7.734706 14.53562 8.093092 16.71013 ..
18.0615 15.50058 7.739636 12.64823 8.657069 4.861672 ..
q).ml.clust.cure[d;`e2dist;3;2;0]
0 1 1 1 1 1 1 2 1 1
q).ml.clust.cure[d;`mdist;3;5;0.5]
0 1 2 2 2 2 2 2 2 2
```

### `.ml.clust.hc`

_Cluster data using hierarchical methods_

Syntax: `.ml.clust.hc[data;df;lf;k]`

Where

-   `data` is the data points in a horizontal matrix format
-   `df` is the distance function as a symbol: `e2dist` `edist` `mdist` (see [section](##Disance Metrics))
-   `lf` is the linkage function as a symbol: `single`  `complete` `average` `centroid` `ward`
-   `k` is the number of clusters

returns a list indicating the cluster each data point belongs to

```q
q)show d:2 10#20?5.
4.608218 0.9047679 3.217318 1.453547  0.3673904 1.579763 ...
1.428995 3.342362  4.566516 0.7426785 2.428773  3.561801 ...
q).ml.clust.hc[d;`e2dist;`single;3]
0 1 2 1 1 1 1 0 1 1
q).ml.clust.hc[d;`mdist;`complete;3]
0 1 2 0 1 1 0 0 0 1
q).ml.clust.hc[d;`edist;`average;3]
0 1 2 1 1 1 1 0 1 1
q).ml.clust.hc[d;`mdist;`centroid;3]
0 1 2 0 1 1 0 0 0 1
q).ml.clust.hc[d;`e2dist;`ward;3]
0 1 1 2 1 1 2 0 2 1
q).ml.clust.hc[d;`mdist;`ward;3]
'ward must be used with e2dist
  [0]  .ml.clust.hc[d;3;`mdist;`ward;()]

       ^
```

!!! warning
        * Ward linkage only works in conjunction with euclidean squared distances (`e2dist`). If the user tries to input a different distance metric an error will result, as shown above.

	* If the user inputs a linkage function which is not contained within the `.ml.clust.i.ld` dictionary an error will occur.


## Density-based models

This library contains an impmlementation of the **DBSCAN** (Density-Based Spatial Clustering of Applications with Noise) algorithm. The DBSCAN algorithm groups points together that are closely packed in areas of high-density. Any points in low-density regions are seen as outliers.

Unlike many clustering algorithms which require the user to input the desired number of clusters, DBSCAN caluculates how many clusters are in the dataset based two criteria

1. The minimum number of points required within a neighbourhood in order for a cluster to be defined

2. The epsilon radius, this is the distance from each point within which points will be defined as being part of the same cluster

### `.ml.clust.dbscan`

_Cluster data based on areas of high-density_

Syntax: `.ml.clust.dbscan[data;df;minpts;eps]`

Where

-   `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
-   `df` is the distance function as a symbol: `e2dist` `edist` `mdist` (see [section](##Distance Metrics))
-   `minpts` is the minimum number of points required in a given neighbourhood to define a cluster
-   `eps` is the epsilon radius, the distance from each point within which points are defined as being in the same cluster

returns a list indicating the cluster each data point belongs to, any outliers in the data will return a null value as their cluster

```q
q)show d:2 10#20?5.
4.938922 1.933677 3.633905 2.023273 4.177532 3.213685 ..
3.875146 1.934909 3.162057 2.164267 1.215418 1.958976 ..
// returns 3 clusters and 3 outliers
q).ml.clust.dbscan[d;`e2dist;2;1] 
0 1 0 1 2 0N 0N 0N 2 0
// radius too larger - returns one cluster
q).ml.clust.dbscan[d;`e2dist;3;6]
0 0 0 0 0 0 0 0 0 0
// radius too small - clustering not possible, points returned as individual clusters
q).ml.clust.dbscan[d;`e2dist;3;.5]
0N 0N 0N 0N 0N 0N 0N 0N 0N 0N
```

## Distance Metrics

The distance functions available in the clustering library are:

-   `edist` is the Euclidean distance
-   `e2dist` is the squared Euclidean distance
-   `nege2dist` is the negative squared Euclidean distance (used predominantly for affinity propagation)
-   `mdist` is the Manhattan distance

!!! warning
	If the user inputs a distance metric that is not contained within the `.ml.clust.i.dd` dictionary an error will occur.
