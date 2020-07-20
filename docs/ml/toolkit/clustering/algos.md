---
title: Clustering algorithms reference | Clustering | Machine Learning Toolkit | Documentation for kdb+ and q
author: Deanna Morgan
date: May 2019
keywords: machine learning, ml, clustering, k-means, dbscan, hierarchical, cure
---

# :fontawesome-solid-share-alt: Clustering algorithms reference


<pre markdown="1" class="language-txt">
.ml.clust   **Clustering**

Algorithms
  [kmeans](#mlclustkmeans)             K-Means clustering
  [ap](#mlclustap)                 Affinity Propagation
  [dbscan](#mlclustdbscan)             Density-based clustering
  [hc](#mlclusthc)                 Hierarchical clustering
  [cure](#mlclustcure)               CURE algorithm

Cutting dendograms into
  [hccutk](#mlclusthccutk)             k clusters
  [hccutdist](#mlclusthccutdist)          clusters based on a distance threshold
</pre>

<i class="fab fa-github"></i>
[KxSystems/ml/clust](https://github.com/KxSystems/ml/tree/master/clust)

The clustering library provides q implementations of a number of common clustering algorithms.

Hierarchical clustering methods (including CURE) produce dendrograms, which can then be _cut_ at a given count or distance to produce a clustering.

## `.ml.clust.ap`

_Affinity Propagation_

Syntax: `.ml.clust.ap[data;df;dmp;diag]`

Where

-   `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
-   `df` is the distance function as a symbol: `nege2dist` is recommended for this algorithm. (see [Distance Metrics](#distance-metrics))
-   `dmp` is the damping coefficient to be applied to the availability and responsibility matrixes
-   `diag` is the preference function for the diagonal of the similarity matrix (e.g.  `min` `med` `max` etc.)

returns a list indicating the cluster each datapoint belongs to.

```q
q)show d:2 10#20?10.
0.8123546 9.367503 2.782122 2.392341 1.508133 ..
4.099561  6.108817 4.976492 4.087545 4.49731  ..

q)show APclt:.ml.clust.ap[d;`nege2dist;.3;med]
0 1 2 2 0 2 1 3 3 1

q)// Group indices into their calculated clusters
q)group APclt
0| 0 4
1| 1 6 9
2| 2 3 5
3| 7 8
```

Affinity Propagation groups data based on the similarity between points and subsequently finds _exemplars_, which best represent the points in each cluster. The algorithm does not require the number of clusters, but determines the optimum solution by exchanging real-valued messages between points until a high-valued set of exemplars is produced.

The algorithm uses a user-specified damping coefficient to reduce the availability and responsibility of messages passed between points, while a preference value is used to set the diagonal values of the similarity matrix. A more detailed explanation of the algorithm can be found [here](https://towardsdatascience.com/unsupervised-machine-learning-affinity-propagation-algorithm-explained-d1fef85f22c8).


## `.ml.clust.cure`

_CURE algorithm_

Syntax: `.ml.clust.cure[data;df;n;c]`

Where

-   `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
-   `df`  is the distance function as a symbol: `e2dist` `edist` `mdist` – see [Distance Metrics](#distance-metrics)
-   `n` is the number of representative points
-   `c` is the compression ratio

returns a dendrogram table, describing the order in which clusters are joined, and the distance between the clusters as they are joined.

```q
q)show d:2 10#20?20.
15.66737 8.199122 12.21763 9.952983 8.175089 8.994621 0.2784152 14.29756 3.89..
12.40603 18.65263 5.494133 1.150503 5.121315 4.620216 1.744803  2.048864 17.3..

q).ml.clust.cure[d;`e2dist;2;0]
i1 i2 dist      n
------------------
4  5  0.9227319 2
2  10 11.15155  3
8  9  12.08844  2
11 7  16.19596  4
13 3  18.92826  5
1  12 20.25978  3
14 6  73.7583   6
0  15 94.79481  4
17 16 109.1472  10

q).ml.clust.cure[d;`mdist;5;0.5]
i1 i2 dist     n
-----------------
4  5  1.320631 2
2  10 4.176539 3
11 3  4.256665 4
8  9  4.866351 2
12 7  4.978184 5
1  13 6.833131 3
14 6  10.73582 6
0  16 13.04284 7
17 15 14.39012 10
```

CURE (Clustering Using REpresentatives) is a technique used to deal with datasets containing outliers and clusters of varying sizes and shapes. Each cluster is represented by a specified number of representative points. These points are chosen by taking the most scattered points in each cluster and shrinking them towards the cluster center using a compression ratio.


## `.ml.clust.dbscan`

_Density-based clustering_

Syntax: `.ml.clust.dbscan[data;df;minpts;eps]`

Where

-   `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
-   `df` is the distance function as a symbol: `e2dist` `edist` `mdist` (see [section](##Distance Metrics))
-   `minpts` is the minimum number of points required in a given neighborhood to define a cluster
-   `eps` is the epsilon radius, the distance from each point within which points are defined as being in the same cluster

returns a list indicating the cluster each datapoint belongs to, any outliers in the data will return a null value as their cluster.

```q
q)show d:2 10#20?5.
4.938922 1.933677 3.633905 2.023273 4.177532 3.213685 ..
3.875146 1.934909 3.162057 2.164267 1.215418 1.958976 ..

q)// returns 3 clusters and 3 outliers
q).ml.clust.dbscan[d;`e2dist;2;1]
0 1 0 1 2 0N 0N 0N 2 0

q)// radius too larger - returns one cluster
q).ml.clust.dbscan[d;`e2dist;3;6]
0 0 0 0 0 0 0 0 0 0

q)// radius too small - clustering not possible, points returned as individual clusters
q).ml.clust.dbscan[d;`e2dist;3;.5]
0N 0N 0N 0N 0N 0N 0N 0N 0N 0N
```

The DBSCAN (Density-Based Spatial Clustering of Applications with Noise) algorithm, groups points that are closely packed in areas of high density. Any points in low-density regions are seen as outliers.

Unlike many clustering algorithms, which require the user to input the desired number of clusters, DBSCAN calculates how many clusters are in the dataset based two criteria

-   The minimum number of points required within a neighborhood in order for a cluster to be defined
-   The epsilon radius: the distance from each point within which points will be defined as being part of the same cluster


## `.ml.clust.hc`

_Hierarchical clustering_

Syntax: `.ml.clust.hc[data;df;lf]`

Where

-   `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
-   `df` is the distance function as a symbol: `e2dist` `edist` `mdist` (see [section](##Distance Metrics))
-   `lf` is the linkage function as a symbol: `single`  `complete` `average` `centroid` `ward`

returns a dendrogram table, describing the order in which clusters are joined, and the distance between the clusters as they are joined.

```q
q)show d:2 10#20?5.
3.916843 2.049781 3.054409 2.488246  2.043772 2.248655..
3.101507 4.663158 1.373533 0.2876258 1.280329 1.155054..

q).ml.clust.hc[d;`e2dist;`single]
i1 i2 dist       n
-------------------
4  5  0.05767075 2
2  10 0.6969718  3
8  9  0.7555276  2
11 3  0.8098354  4
13 7  1.012247   5
1  12 1.266236   3
0  14 3.729687   6
16 6  4.609894   7
17 15 5.924676   10

q).ml.clust.hc[d;`mdist;`complete]
i1 i2 dist      n
------------------
4  5  0.3301577 2
2  10 1.103841  3
8  9  1.216588  2
3  7  1.310734  2
11 13 2.29873   5
1  12 2.620724  3
14 6  3.922137  6
0  15 4.177629  4
17 16 6.512546  10

q).ml.clust.hc[d;`mdist;`ward]
'ward must be used with e2dist
```

Agglomerative hierarchical clustering iteratively groups data, using a bottom-up approach that initially treats all datapoints as individual clusters.

There are five possible linkages in hierarchical clustering: single, complete, average, centroid and ward. Euclidean or Manhattan distances can be used with each linkage except for ward (which only works with Euclidean squared distances) and centroid (which only works with Euclidean distances).

In the single and centroid implementations, a k-d tree is used to store the representative points of each cluster (see [k-d tree](kdtree.md)).

The dendrogram returned can be passed to a mixture of MatPlotLib and SciPy functions which plot the dendrogram structure represented in the table. For example:

```q
plt:.p.import`matplotlib.pyplot
.p.import[`scipy.cluster][`:hierarchy][`:dendrogram]flip value flip r1
plt[`:title]"Dendrogram"
plt[`:xlabel]"Data Points"
plt[`:ylabel]"Distance"
plt[`:show][]
```

![dendro_plot](img/dendrogram_example.png)

!!! warning "Ward linkage"
    Ward linkage only works in conjunction with Euclidean squared distances (`e2dist`), while centroid linkage only works with Euclidean distances (`e2dist`, `edist`). If the user tries to input a different distance metric an error will result, as shown above.


## `.ml.clust.hccutdist`

_Cut dendrogram into clusters based on a distance threshold_

Syntax: `.ml.clust.hccutdist[t;dist]`

Where

-   `t` is the dendrogram table produced by the hierarchical clustering functions
-   `dist` is the distance threshold applied when cutting the dendrogram into clusters

returns a list indicating the cluster each datapoint belongs to.

```q
q)show d:2 10#20?10.
3.927524 5.170911 5.159796  4.066642 1.780839 3.017723 7.85033  5.347096 7.11..
4.931835 5.785203 0.8388858 1.959907 3.75638  6.137452 5.294808 6.916099 2.29..

q)show dgram:.ml.clust.hc[d;`mdist;`complete]
i1 i2 dist     n
-----------------
7  9  1.234559 2
0  1  2.096755 2
2  3  2.214176 2
11 5  2.505438 3
13 10 3.403836 5
12 8  3.40965  3
14 6  5.675252 6
15 4  6.790642 4
16 17 7.93483  10

q)// cut dendrogram using a distance threshold of 6
q).ml.clust.hccutdist[dgram;6]
1 1 0 0 2 1 1 1 0 1
```


## `.ml.clust.hccutk`

_Cut dendrogram into k clusters_

Syntax: `.ml.clust.hccutk[t;k]`

Where

-   `t` is the dendrogram table produced by the hierarchical clustering functions
-   `k` is the number of clusters to be produced from cutting the dendrogram

returns a list indicating the cluster each datapoint belongs to.

```q
q)show d:2 10#20?5.
2.353941 3.173358  4.836199 1.153192 4.749875 2.195405  2.879526  2.959502 4...
1.957715 0.4061773 4.683752 1.391061 1.196171 0.7540665 0.7836585 4.8925   3...

q)show dgram:.ml.clust.hc[d;`e2dist;`single]
i1 i2 dist      n
------------------
1  6  0.2288295 2
10 5  0.4688969 3
7  9  1.058115  2
0  11 1.473903  4
13 3  1.491969  5
2  8  1.704984  2
14 4  3.109495  6
15 12 3.520892  4
16 17 5.667062  10

q)// cut the dendrogram into 2 clusters
q).ml.clust.hccutk[dgram;2]
0 0 1 0 0 0 0 1 1 1
```


## `.ml.clust.kmeans`

_K-Means clustering_

Syntax: `.ml.clust.kmeans[data;df;k;iter;kpp]`

Where

-   `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
-   `df` is the distance function: `e2dist` `edist` (see [section](##Distance Metrics))
-   `k` is the number of clusters
-   `iter` is the number of iterations to be completed
-   `kpp` is a boolean flag indicating the initializaton type: random (`0b`) or using [k-means++](https://en.wikipedia.org/wiki/K-means%2B%2B) (`1b`)

returns a list indicating the cluster each datapoint belongs to.

```q
q)show d:2 10#20?5.
1.963762 2.585456 2.579898  2.033321  0.8904193 1.508861 ...
2.465917 2.892601 0.4194429 0.9799536 1.87819   3.068726 ...

q)// Initialize using the k++ algorithm
q).ml.clust.kmeans[d;`e2dist;3;10;1b]
0 0 1 1 0 0 2 0 2 0

q)// Initialize using random centers
q).ml.clust.kmeans[d;`e2dist;3;10;0b]
0 1 2 2 0 0 1 1 2 0
q).ml.clust.kmeans[d;`mdist;3;10;1b]
'kmeans must be used with edist/e2dist
```

K-means clustering begins by selecting k datapoints as cluster centers and assigning data to the cluster with the nearest center.

The algorithm follows an iterative refinement process which runs a specified number of times, updating the cluster centers and assigned points with each iteration.

The distance metrics that can be used with the K-Means algorithm are the Euclidean distances (`e2dist`,`edist`). The use of any other distance metric will result in an error.


## Distance metrics

The distance functions available in the clustering library are:

```txt
edist       Euclidean distance
e2dist      squared Euclidean distance
nege2dist   negative squared Euclidean distance (predominantly for affinity propagation)
mdist       Manhattan distance
```

!!! warning "If you use  an invalid distance metric, an error will occur."
