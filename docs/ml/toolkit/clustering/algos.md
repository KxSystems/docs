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

Syntax: `.ml.clust.ap[d;df;dmp;p]`

Where

- `d` is data points in matrix form
- `df` is the distance function as a symbol: `nege2dist` commonly used for this algorithm, but can also be used with `e2dist` `edist` and `mdist` (see [section](##Disance Metrics))
- `dmp` is the damping coefficient to apply to the availability and responsibility matrices.
- `p` is the preference for the diagonal of the similarity matrix, can be a function as a symbol (e.g. ``` `min`med`max ``` etc.) or a floating point value.

returns a table.

```q
q)show d:flip 2 10#20?10.
0.891041  6.348263  
8.345194  7.66752   
3.621949  9.281844  
9.99934   2.035925  
3.837986  7.747888  
8.619188  9.667728  
0.9183638 8.225125  
2.530883  9.088765  
2.504566  6.458066  
7.517286  0.08962677
q).ml.clust.ap[d;`nege2dist;.3;`med]
idx clt pts                 
----------------------------
0   0   0.891041  6.348263  
1   1   8.345194  7.66752   
2   0   3.621949  9.281844  
3   2   9.99934   2.035925  
4   0   3.837986  7.747888  
5   1   8.619188  9.667728  
6   0   0.9183638 8.225125  
7   0   2.530883  9.088765  
8   0   2.504566  6.458066  
9   2   7.517286  0.08962677
q).ml.clust.ap[d;`nege2dist;.4;-6.]
idx clt pts                 
----------------------------
0   0   0.891041  6.348263  
1   1   8.345194  7.66752   
2   2   3.621949  9.281844  
3   3   9.99934   2.035925  
4   2   3.837986  7.747888  
5   1   8.619188  9.667728  
6   0   0.9183638 8.225125  
7   2   2.530883  9.088765  
8   0   2.504566  6.458066  
9   3   7.517286  0.08962677
```

## CURE (Clustering Using REpresentatives)

CURE clustering is a technique used to deal with datasets containing outliers and clusters of varying sizes and shapes. Each cluster is represented by a specified number of representative points. These points are chosen by taking the the most scattered points in each cluster and shrinking them towards the cluster centre by a fixed amount, known as the compression.

In the implementation below, a k-d tree is used in order to store the representative points of each cluster (more information [here](https://code.kx.com/v2/ml/toolkit/clustering/kdtree)). Both q and C implementations of the tree are available and are specified as an argument. 

### `.ml.clust.ccure`

_Cluster data using representative points_

Syntax: `.ml.clust.ccure[d;k;r;i]`

Where

- `d` is data points in matrix form
- `k` is the number of clusters
- `r` is the number of representative points
- `i` is a dictionary of inputs in the form:
    - `df` is the distance function as a symbol: `e2dist` `edist` `mdist` (see [section](##Disance Metrics)) 
    - `c` is the compression
    - `b` is a boolean, `1b` for C, `0b` for q implementation of the tree
    - `s` is a boolean, `1b` to return a dictionary, `0b` to return a table of clusters

returns a dictionary or a table.

```q
q)show d:10 2#20?5.
1.963762  2.585456 
2.579898  2.033321 
0.8904193 1.508861 
3.925165  2.673548 
3.555858  2.057985 
2.465917  2.892601 
0.4194429 0.9799536
1.87819   3.068726 
2.647404  3.458049 
1.148308  3.459765 
q).ml.clust.cure[d;3;2;()]
idx clt pts                
---------------------------
0   0   1.963762  2.585456 
1   0   2.579898  2.033321 
2   1   0.8904193 1.508861 
3   0   3.925165  2.673548 
4   0   3.555858  2.057985 
5   0   2.465917  2.892601 
6   1   0.4194429 0.9799536
7   0   1.87819   3.068726 
8   0   2.647404  3.458049 
9   2   1.148308  3.459765 
q).ml.clust.cure[d;3;2;`df`c!(`mdist;1b)]
idx clt pts                
---------------------------
0   0   1.963762  2.585456 
1   0   2.579898  2.033321 
2   1   0.8904193 1.508861 
3   2   3.925165  2.673548 
4   2   3.555858  2.057985 
5   0   2.465917  2.892601 
6   1   0.4194429 0.9799536
7   0   1.87819   3.068726 
8   0   2.647404  3.458049 
9   0   1.148308  3.459765 
q)show t:.ml.clust.cure[d;3;2;enlist[`s]!enlist 1b]
reps| (3.925165 2.673548;1.87819 3.068726;0.8904193 1.508861;0.4194429 0.9799..
tree| (-1 0 1 1 0 4 4;0110010b;0011011b;(1 4;2 3;2 3;4 1;5 6;`long$();,0);2.4..
r2c | 0 0 1 1 2
r2l | 6 3 2 2 3
```

!!! note
	Using `()` for the input dictionary will use default inputs, where `df = e2dist`, `c = 0`,`b = 0b` and `s = 0b`. To alter these inputs, the user must specify the parameters and their new values in dictionary format, shown above.

!!! note
	If the parameter `s` is set to 1b the function will return a dictionary as output. This can be used in conjuction with live streaming data and has the form

	-  `reps` are the representative points
	-  `tree` is a k-d tree
	-  `r2c` is the cluster indices
	-  `r2l` is the leaf indices

	New points can be added to the tree, with representative points updated (see [notebooks](https://github.com/kxsystems/ml/clust/notebooks/streaming.ipynb)). 

### `.ml.clust.clustnew`

_Cluster new data points using previously defined tree_

Syntax: `.ml.clust.clustnew[t;df;p]`

Where

-   `t` is a dictionary with the information of the tree
-   `df` is the distance function as a symbol: `e2dist` `edist` `mdist` (see [section](##Disance Metrics))
-   `d` is a new point to be classified

returns the cluster of the new point.

```q
q)t
reps| (3.925165 2.673548;1.87819 3.068726;0.8904193 1.508861;0.4194429 0.9799..
tree| (-1 0 1 1 0 4 4;0110010b;0011011b;(1 4;2 3;2 3;4 1;5 6;`long$();,0);2.4..
r2c | 0 0 1 1 2
r2l | 6 3 2 2 3
q)show new:5 2#10?5.
1.957715  0.4061773
4.683752  1.391061 
1.196171  0.7540665
0.7836585 4.8925   
3.521657  4.720835 
q).ml.clust.clustnew[t;`e2dist]each enlist each new
1 0 1 2 0
```

## DBSCAN (Density-Based Spatial Clustering of Applications with Noise)

The DBSCAN algorithm groups points together that are closely packed in areas of high-density. Any points in low-density regions are seen as outliers.

Unlike other clustering algorithms which require the user to input the desired number of clusters, DBSCAN will decide how many clusters are in the dataset based the minimum number of points required per cluster and the epsilon radius, both given by the user.

### `.ml.clust.dbscan`

_Cluster data based on areas of high-density_

Syntax: `.ml.clust.dbscan[d;df;p;e]`

Where

-   `d` is data points in matrix form
-   `df` is the distance function as a symbol: `e2dist` `edist` `mdist` (see [section](##Disance Metrics))
-   `p` is minimum number of points required in a given neighbourhood for it to be classified as a cluster
-   `e` is the epsilon radius, the distance from each point within which points are defined as being in the same cluster

returns a table with the index, cluster and original data points.

```q
q)show d:10 2#20?5.
3.916843   2.049781 
3.054409   2.488246 
2.043772   2.248655 
0.06960381 3.57439  
0.9732546  0.4529513
3.101507   4.663158 
1.373533   0.2876258
1.280329   1.155054 
0.4362008  0.5122161
4.335548   3.639264 
q).ml.clust.dbscan[d;`e2dist;3;3] / returns 2 clusters and 2 outliers
idx clt pts                 
----------------------------
0   0   3.916843   2.049781 
1   1   3.054409   2.488246 
2   1   2.043772   2.248655 
3   2   0.06960381 3.57439  
4   3   0.9732546  0.4529513
5   1   3.101507   4.663158 
6   3   1.373533   0.2876258
7   3   1.280329   1.155054 
8   3   0.4362008  0.5122161
9   1   4.335548   3.639264 
q).ml.clust.dbscan[d;`e2dist;3;6]  / radius too larger - returns one cluster
idx clt pts                 
----------------------------
0   0   3.916843   2.049781 
1   0   3.054409   2.488246 
2   0   2.043772   2.248655 
3   0   0.06960381 3.57439  
4   0   0.9732546  0.4529513
5   0   3.101507   4.663158 
6   0   1.373533   0.2876258
7   0   1.280329   1.155054 
8   0   0.4362008  0.5122161
9   0   4.335548   3.639264 
q).ml.clust.dbscan[d;`e2dist;3;.5] / radius too small - clustering not possible, points returned as individual clusters
idx clt pts                 
----------------------------
0   0   3.916843   2.049781 
1   1   3.054409   2.488246 
2   2   2.043772   2.248655 
3   3   0.06960381 3.57439  
4   4   0.9732546  0.4529513
5   5   3.101507   4.663158 
6   6   1.373533   0.2876258
7   7   1.280329   1.155054 
8   8   0.4362008  0.5122161
9   9   4.335548   3.639264 
```

## Hierarchical

The implementation of hierarchical clustering described below groups data using an agglomerative/bottom-up approach which initially treats all data points as individual clusters.

There are 5 possible linkages in hierarchical clustering: single, complete, average, centroid and ward. Euclidean or manhattan distances can be used for with each linkage, except for ward which only works with euclidean squared distances. Additionally, a k-d tree has been used for the single and centroid implementations.

### `.ml.clust.hc`

_Cluster data using hierarchical methods_

Syntax: `.ml.clust.hc[d;k;df;lf]`

Where

-   `d` is data points in matrix form
-   `k` is the number of clusters
-   `df` is the distance function as a symbol: `e2dist` `edist` `mdist` (see [section](##Disance Metrics))
-   `lf` is the linkage function as a symbol: `single`  `complete` `average` `centroid` `ward`
-   `bc` is a boolean flag indicating whether to use the C or q implementations of the k-d tree for the centroid and single models. Can be `1b` for C and `0b` or `()` for q.

returns a table with the index, cluster and original data points.

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
q).ml.clust.hc[d;3;`e2dist;`single;1b]
idx clt pts               
--------------------------
0   0   0.8138311 3.442378
1   1   4.088774  3.760051
2   2   0.5434121 4.799482
3   0   0.183417  3.215491
4   1   3.354369  3.394541
5   0   2.061585  4.938922
6   0   1.933677  3.633905
7   0   2.023273  4.177532
8   1   3.213685  2.915131
9   2   0.7124676 4.574941
q).ml.clust.hc[d;3;`e2dist;`ward;()]
idx clt pts               
--------------------------
0   0   0.8138311 3.442378
1   1   4.088774  3.760051
2   0   0.5434121 4.799482
3   0   0.183417  3.215491
4   1   3.354369  3.394541
5   5   2.061585  4.938922
6   5   1.933677  3.633905
7   5   2.023273  4.177532
8   1   3.213685  2.915131
9   0   0.7124676 4.574941
q).ml.clust.hc[d;3;`mdist;`ward;()]
'ward must be used with e2dist
  [0]  .ml.clust.hc[d;3;`mdist;`ward;()]
       ^
```

!!! warning
	Ward linkage only works in conjunction with euclidean squared distances (`e2dist`). If the user tries to input a different distance metric an error will result, as shown above.

!!! warning 
	If the user inputs a linkage function which is not contained within the `.ml.clust.i.ld` dictionary an error will occur.

### `.ml.clust.dgram`

_Return the hierarchichal clustering dendrogram_

Syntax: `.ml.clust.dgram[d;df;lf]`

Where

-   `d` is data points in matrix form
-   `df` is the distance function as a symbol: `e2dist` `edist` `mdist` (see [section](##Disance Metrics))
-   `lf` is the linkage function as a symbol: `single`  `complete` `average` `centroid` `ward`

returns a table where `i1` and `i2` represent the clusters merged at step `i`, `dist` is the distance between the merged clusters and `n` is the number of point in the new cluster.

```q
q)show d:10 2#20?5.
2.353941  3.173358
4.836199  1.153192
4.749875  2.195405
2.879526  2.959502
4.240783  1.94528
1.957715  0.4061773
4.683752  1.391061
1.196171  0.7540665
0.7836585 4.8925
3.521657  4.720835
q).ml.clust.dgram[d;`edist;`complete;()]
i1 i2 dist      n
------------------
1  6  0.2825272 2
2  4  0.5672187 2
0  3  0.567427  2
5  7  0.8372435 2
10 11 1.045781  4
12 9  1.93862   3
15 8  2.851165  4
14 13 3.834876  6
16 17 5.514119  10
```

!!! note
       The dendrogram can be plotted to give an idea of the hierarchichal relationship between the points. Examples can be seen in [notebooks](https://github.com/kxsystems/ml/clust/notebooks/dendrograms.ipynb).

## K-Means

K-means clustering begins by selecting k data points as cluster centres and assigning data to the cluster with the nearest centre. The algorithm follows an iterative refinement process which will run n times, updating the cluster centers and assigned points during each iteration.

### `.ml.clust.kmeans`

_Cluster data using k-means_

Syntax: `.ml.clust.kmeans[d;k;n;i;df]`

Where

-   `d` is data points in matrix form
-   `k` is the number of clusters
-   `n` is the number of iterations
-   `i` is a boolean flag indicating the initialisaton type: both select k points from the dataset as cluster centres, `1b` initialises the [k-means++](https://en.wikipedia.org/wiki/K-means%2B%2B) algorithm or `0b` selects k random points
-   `df` is the distance function: `e2dist` `edist` `mdist` `cshev` (see [section](##Disance Metrics))

returns a table with the index, cluster and original data points.

```q
q)show d:10 2#20?5.
2.353941  3.173358 
4.836199  1.153192 
4.749875  2.195405 
2.879526  2.959502 
4.240783  1.94528  
1.957715  0.4061773
4.683752  1.391061 
1.196171  0.7540665
0.7836585 4.8925   
3.521657  4.720835 
q).ml.clust.kmeans[d;3;`mdist;10;1b]
idx clt pts                
---------------------------
0   0   2.353941  3.173358 
1   1   4.836199  1.153192 
2   1   4.749875  2.195405 
3   0   2.879526  2.959502 
4   1   4.240783  1.94528  
5   2   1.957715  0.4061773
6   1   4.683752  1.391061 
7   2   1.196171  0.7540665
8   0   0.7836585 4.8925   
9   0   3.521657  4.720835 
q).ml.clust.kmeans[d;3;`e2dist;10;0b]
idx clt pts                
---------------------------
0   0   2.353941  3.173358 
1   1   4.836199  1.153192 
2   1   4.749875  2.195405 
3   0   2.879526  2.959502 
4   1   4.240783  1.94528  
5   0   1.957715  0.4061773
6   1   4.683752  1.391061 
7   0   1.196171  0.7540665
8   2   0.7836585 4.8925   
9   2   3.521657  4.720835 
```

## Distance Metrics

The distance functions available in the clustering library are:

-   `edist` is the Euclidean distance
-   `e2dist` is the squared Euclidean distance
-   `nege2dist` is the negative squared Euclidean distance (used predominantly for affinity propagation)
-   `mdist` is the manhattan distance
-   `cshev` is the chebyshev distance (k-means only)

!!! warning
	If the user inputs a distance metric that is not contained within the `.ml.clust.i.dd` dictionary an error will occur.
