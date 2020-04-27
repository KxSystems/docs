---
author: Deanna Morgan
date: May 2019
keywords: machine learning, ml, clustering, k-means, dbscan, hierarchical, cure
---

# <i class="fas fa-share-alt"></i> Clustering Algorithms

<i class="fab fa-github"></i>
[KxSystems/ml/clust/clust.q](https://github.com/kxsystems/ml/clust/clust.q)

Clustering is a technique used in both data mining and machine learning to group similar data points together in order to identify patterns in their distributions. The task of clustering data can be carried out using a number of algorithms. Here we outline implementations of affinity propagation, CURE (Clustering Using REpresentatives), DBSCAN (Density-based spatial clustering of applications with noise), hierarchical and k-means clustering.

The algorithms defined here work based on distinct clustering methodologies namely; connectivity-based, centroid-based or density-based models.

-   Connectivity models, which include hierarchical and CURE, cluster data based on distances between individual data points.
-   Centroid models, such as affinity propagation and k-means, define clusters based on distances from single points which represent the cluster.
-   Density-based models such as DBSCAN define clusters based on data points being within a certain distance of each other and in defined concentrations.

Each algorithm works by iteratively joining, separating or reassigning points until the desired number of clusters have been achieved, or until the algorithm has determined the optimal number of clusters - which is the case for affinity propagation and DBSCAN. The process of finding the correct cluster for each data point is then a case of trial and error, where parameters must be altered in order to find the optimum solution.

Notebooks showing examples of the clustering algorithms mentioned above can be found at
<i class="fab fa-github"></i>
[KxSystems/mlnotebooks](https://github.com/kxsystems/mlnotebooks).

## Loading

Load the clustering library in isolation from the ML-toolkit using:

```q
q)\l ml/ml.q
q).ml.loadfile`:clust/init.q
```

## Affinity Propagation

Affinity Propagation groups data based on the similarity between points and subsequently finds k exemplars which best represent the points in each cluster. Similarly to DBSCAN, the algorithm does not require the user to input the number of clusters. The algorithm will determine the optimum solution by exchanging real-valued messages between points until high-valued set of exemplars is produced.

The algorithm uses a user specified damping coefficient to reduce the availability and responsibility of messages passed between points, while the preference value is used to set the diagonal values of the similarity matrix. A more detailed explanation of the algorithm can be found [here](https://towardsdatascience.com/unsupervised-machine-learning-affinity-propagation-algorithm-explained-d1fef85f22c8).

### `.ml.clust.ap`

_Cluster data using exemplars_

Syntax: `.ml.clust.ap[data;df;dmp;diag]`

Where

- `data` is the data points in a horizontal matrix format
- `df` is the distance function as a symbol: `nege2dist` commonly used for this algorithm, but can also be used with `e2dist` `edist` and `mdist` (see [section](##Disance Metrics))
- `dmp` is the damping coefficient to apply to the availability and responsibility matrices.
- `diag` is the preference for the diagonal of the similarity matrix, can be a function as a symbol (e.g. ``` `min`med`max ``` etc.).

returns a list indicating the cluster each data point belongs to

```q
show d:2 10#20?10.
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

## CURE (Clustering Using REpresentatives)

CURE clustering is a technique used to deal with datasets containing outliers and clusters of varying sizes and shapes. Each cluster is represented by a specified number of representative points. These points are chosen by taking the the most scattered points in each cluster and shrinking them towards the cluster centre by a fixed amount, known as the compression.

In the implementation below, a k-d tree is used in order to store the representative points of each cluster (more information [here](https://code.kx.com/v2/ml/toolkit/clustering/kdtree)). Both q and C implementations of the tree are available and are specified as an argument. 

### `.ml.clust.ccure`

_Cluster data using representative points_

Syntax: `.ml.clust.ccure[data;df;k;n;c]`

Where

- `data` is the data points in a horizontal matrix format
- `df`  is the distance function as a symbol: `e2dist `edist `mdist (see [section](##Distance Metrics))
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

## DBSCAN (Density-Based Spatial Clustering of Applications with Noise)

The DBSCAN algorithm groups points together that are closely packed in areas of high-density. Any points in low-density regions are seen as outliers.

Unlike other clustering algorithms which require the user to input the desired number of clusters, DBSCAN will decide how many clusters are in the dataset based on the minimum number of points required per cluster and the epsilon radius, both given by the user.

### `.ml.clust.dbscan`

_Cluster data based on areas of high-density_

Syntax: `.ml.clust.dbscan[data;df;minpts;eps]`

Where

-   `data` is the data points in a horizontal matrix format
-   `df` is the distance function as a symbol: `e2dist` `edist` `mdist` (see [section](##Disance Metrics))
-   `minpts` is the minimum number of points required in a given neighbourhood for it to be classified as a cluster
-   `eps` is the epsilon radius, the distance from each point within which points are defined as being in the same cluster

returns a list indicating the cluster each data point belongs to, any outliers in the data will return a null value as their cluster

```q
q)show d:2 10#20?5.
4.938922 1.933677 3.633905 2.023273 4.177532 3.213685 ..
3.875146 1.934909 3.162057 2.164267 1.215418 1.958976 ..
q).ml.clust.dbscan[d;`e2dist;2;1] /returns 3 clusters and 3 outliers
0 1 0 1 2 0N 0N 0N 2 0
q).ml.clust.dbscan[d;`e2dist;3;6]  / radius too larger - returns one cluster
0 0 0 0 0 0 0 0 0 0
q).ml.clust.dbscan[d;`e2dist;3;.5] / radius too small - clustering not possible, points returned as individual clusters
0N 0N 0N 0N 0N 0N 0N 0N 0N 0N
```

## Hierarchical

The implementation of hierarchical clustering described below groups data using an agglomerative/bottom-up approach which initially treats all data points as individual clusters.

There are 5 possible linkages in hierarchical clustering: single, complete, average, centroid and ward. Euclidean or manhattan distances can be used for with each linkage, except for ward which only works with euclidean squared distances. Additionally, a k-d tree has been used for the single and centroid implementations.

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
	Ward linkage only works in conjunction with euclidean squared distances (`e2dist`). If the user tries to input a different distance metric an error will result, as shown above.

!!! warning 
	If the user inputs a linkage function which is not contained within the `.ml.clust.i.ld` dictionary an error will occur.

## K-Means

K-means clustering begins by selecting k data points as cluster centres and assigning data to the cluster with the nearest centre. The algorithm follows an iterative refinement process which will run n times, updating the cluster centers and assigned points during each iteration.

### `.ml.clust.kmeans`

_Cluster data using k-means_

Syntax: `.ml.clust.kmeans[data;df;k;iter;kpp]`

Where

-   `data` is the data points in a horizontal matrix format
-   `df` is the distance function: `e2dist` `edist` `mdist` `cshev` (see [section](##Disance Metrics))
-   `k` is the number of clusters
-   `iter` is the number of iterations
-   `kpp` is a boolean flag indicating the initialisaton type: both select k points from the dataset as cluster centres, `1b` initialises the [k-means++](https://en.wikipedia.org/wiki/K-means%2B%2B) algorithm or `0b` selects k random points

returns a list indicating the cluster each data point belongs to

```q
q)show d:2 10#20?5.
1.963762 2.585456 2.579898  2.033321  0.8904193 1.508861 ...
2.465917 2.892601 0.4194429 0.9799536 1.87819   3.068726 ...
q).ml.clust.kmeans[d;`e2dist;3;10;1b]
0 0 1 1 0 0 2 0 2 0
q).ml.clust.kmeans[d;`e2dist;3;10;0b]
0 1 2 2 0 0 1 1 2 0
q).ml.clust.kmeans[d;`mdist;3;10;1b]
'kmeans must be used with edist/e2dist
```

!!! note
      K-Means only works in conjunction with euclidean squared distances (e2dist). If the user tries to input a different distance metric an error will result, as shown above.

!!! warning
    All the above clustering functions must have the input data as a floating point type

## Distance Metrics

The distance functions available in the clustering library are:

-   `edist` is the Euclidean distance
-   `e2dist` is the squared Euclidean distance
-   `nege2dist` is the negative squared Euclidean distance (used predominantly for affinity propagation)
-   `mdist` is the manhattan distance
-   `cshev` is the chebyshev distance (k-means only)

!!! warning
	If the user inputs a distance metric that is not contained within the `.ml.clust.i.dd` dictionary an error will occur.
