---
title: Clustering algorithms reference | Clustering | Machine Learning Toolkit | Documentation for kdb+ and q
author: Deanna Morgan
date: May 2019
keywords: machine learning, ml, clustering, k-means, dbscan, hierarchical, cure, affinity propagation, dendrogram
---

# :fontawesome-solid-share-alt: Clustering algorithms 


<div markdown="1" class="typewriter">
.ml.clust   **Clustering**

**Algorithms**
    
\  Affinity Propagation (AP):
    [ap.fit](#mlclustapfit)                   Fit AP algorithm
    
\  Clustering Using REpresentatives (CURE):
    [cure.fit](#mlclustcurefit)                 Fit CURE algorithm
    [cure.fitPredict](#mlclustcurefitpredict)          Fit CURE algorithm to data and convert dendrogram to 
                            clusters
    
\  Density-Based Spatial Clustering of Applications with Noise (DBSCAN):
    [dbscan.fit](#mlclustdbscanfit)               Fit DBSCAN algorithm
    
\  Hierarchical Clustering (HC):
    [hc.fit](#mlclusthcfit)                   Fit HC algorithm
    [hc.fitPredict](#mlclustcurefitpredict)   	       Fit HC algorithm to data and convert dendrogram to 
                            clusters
    
\  K-Means:
    [kmeans.fit](#mlclustkmeansfit)               Fit K-Means algorithm

**Dendrogram cutting functionality**

\  Clustering Using REpresentatives (CURE):
    [cure.cutK](#mlclustcurecutk)               Cut dendrogram to k clusters
    [cure.cutDist](#mlclustcurecutdist)            Cut dendrogram to clusters based on distance threshold
    
\  Hierarchical Clustering (HC):
    [hc.cutK](#mlclusthccutk)                 Cut dendrogram to k clusters
    [hc.cutDist](#mlclusthccutdist)              Cut dendrogram to clusters based on distance threshold
    
</div>

:fontawesome-brands-github:
[KxSystems/ml/clust](https://github.com/KxSystems/ml/tree/master/clust)

The clustering library provides q implementations of a number of common clustering algorithms, with fit and predict functions provided for each. Update functions are also available for K-Means and DBSCAN.

In addition to the fit/predict functionality provided for all methods, for hierarchical clustering methods (including CURE) which produce dendrograms, functions to _cut_ the dendrogram at a given count or distance are also provided allowing a user to produce appropriate clusters.


## Affinity Propagation

Affinity Propagation groups data based on the similarity between points and subsequently finds _exemplars_, which best represent the points in each cluster. The algorithm does not require the number of clusters be provided at run time, but determines the optimum solution by exchanging real-valued messages between points until a high-valued set of exemplars is produced.

The algorithm uses a user-specified damping coefficient to reduce the availability and responsibility of messages passed between points, while a preference value is used to set the diagonal values of the similarity matrix. 

:fontawesome-solid-globe:
[Affinity Propagation Algorithm Explained](https://towardsdatascience.com/unsupervised-machine-learning-affinity-propagation-algorithm-explained-d1fef85f22c8)


## Clustering Using Representatives

Clustering Using REpresentatives (CURE) is a technique used to deal with datasets containing outliers and clusters of varying sizes and shapes. Each cluster is represented by a specified number of representative points. These points are chosen by taking the most scattered points in each cluster and shrinking them towards the cluster center using a compression ratio. 

:fontawesome-solid-globe:
[Introduction to Clustering Techniques, Ch.7](http://infolab.stanford.edu/~ullman/mmds/ch7a.pdf) p.242


## Density-Based Spatial Clustering of Applications with Noise

The Density-Based Spatial Clustering of Applications with Noise ([DBSCAN](https://en.wikipedia.org/wiki/DBSCAN)) algorithm groups points that are closely packed in areas of high density. Any points in low-density regions are seen as outliers.

Unlike many clustering algorithms, which require the user to input the desired number of clusters, DBSCAN calculates how many clusters are in the dataset based on two criteria.

1. The minimum number of points required within a neighborhood in order for a cluster to be defined.
2. The _epsilon radius_: The distance from each point within which points will be defined as being part of the same cluster.


## Hierarchical clustering

Agglomerative hierarchical clustering iteratively groups data, using a bottom-up approach that initially treats all data points as individual clusters. 

:fontawesome-solid-globe:
[Introduction to Clustering Techniques, Ch.7](http://infolab.stanford.edu/~ullman/mmds/ch7a.pdf) p.225

There are five possible linkages in hierarchical clustering: single, complete, average, centroid and ward. Euclidean or Manhattan distances can be used with each linkage except for ward (which only works with Euclidean squared distances) and centroid (which only works with Euclidean distances).

In the single and centroid implementations, a k-d tree is used to store the representative points of each cluster (see [k-d tree](kdtree.md)).

The dendrogram returned can be passed to a mixture of MatPlotLib and SciPy functions which plot the dendrogram structure represented in the table. For example:

```q
q)data:2 10#20?5.
q)HCfit:.ml.clust.hc.fit[data;`e2dist;`complete]
q)show dgram:HCfit[`modelInfo;`dgram]
i1 i2 dist      n
------------------
2  7  0.3069262 2
0  8  0.6538798 2
10 4  0.8766167 3
1  5  1.018976  2
11 6  1.409634  3
3  9  2.487168  2
14 12 4.015938  6
16 13 17.68578  8
17 15 30.19258  10
q)plt:.p.import`matplotlib.pyplot
q).p.import[`scipy.cluster][`:hierarchy][`:dendrogram]flip value flip dgram;
q)plt[`:title]"Dendrogram";
q)plt[`:xlabel]"Data Points";
q)plt[`:ylabel]"Distance";
q)plt[`:show][];
```

![dendro_plot](img/dendrogram_example.png)

!!! warning "Ward linkage"

    Ward linkage only works in conjunction with Euclidean squared distances (`e2dist`), while centroid linkage only works with Euclidean distances (`e2dist`, `edist`). If use a different distance metric as argument, an error is signalled, as shown in the examples.


## K-means

K-means clustering begins by selecting $k$ data points as cluster centers and assigning data to the cluster with the nearest center. 

The algorithm follows an iterative refinement process which runs a specified number of times, updating the cluster centers and assigned points to a cluster at each iteration based on the nearest cluster center.

:fontawesome-solid-globe:
[The K-means algorithm](https://www.edureka.co/blog/k-means-clustering/)

The distance metrics that can be used with the K-means algorithm are the Euclidean distances (`e2dist`,`edist`). The use of any other distance metric will result in an error.



## Distance metrics

The distance functions available in the clustering library are:

```syntax
edist       Euclidean distance
e2dist      squared Euclidean distance
nege2dist   negative squared Euclidean distance 
            (predominantly for affinity propagation)
mdist       Manhattan distance
```

!!! danger "If you use an invalid distance metric, an error will occur."




---

!!! detail "Point matrix: a matrix in which  each column represents a single datapoint"


## `.ml.clust.ap.fit`

_Fit Affinity Propagation algorithm_

```syntax
.ml.clust.ap.fit[data;df;damp;diag;iter]
```

Where

-   `data` is a point matrix
-   `df` is the distance function as a symbol: `nege2dist` is recommended for this algorithm. (see [Distance Metrics](#distance-metrics))
-   `damp` is the damping coefficient to be applied to the availability and responsibility matrices
-   `diag` is the preference function for the diagonal of the similarity matrix (e.g.  `min` `med` `max` etc.)
-   `iter` is a dictionary containing the max allowed iterations and the max iterations without a change in clusters, with default values ``` `total`noChange!200 50``` (to use the defaults, pass in `(::)`)

returns a dictionary containing information collected during the fitting process (`modelInfo`) along with a projection of the prediction function to use on new data (`predict`).

??? "Result dictionary"

	All relevant information needed to evaluate the model is contained within `modelInfo`. This includes
	
	-   `data`      – original data used to fit the model
	-   `inputs`    – original input parameters to the fitted model
	-   `clust`     – cluster index each data point belongs to
	-   `exemplars` – indices of the exemplar points
	
	The predict functionality is contained within the `predict` key. 
    This function takes a point matrix argument and returns the predicted clusters of the new data.

```q
q)show data:2 10#20?10.
4.353367 2.253873 0.3467574 7.672766 3.332201 7.319711 1.692002 1.7..
1.552261 1.904628 2.108777  9.994787 3.753674 4.77256  6.354137 6.1..

// Fit an Affinity model
q)show APfit:.ml.clust.ap.fit[data;`nege2dist;.3;med;(::)]
modelInfo| `data`inputs`clust`exemplars!((4.353367 2.253873 0.3467 ..
predict  | {[config;data]
  config:config`modelInfo;
  data:clust.i.floatConv..

// Information generated during the fitting of the model
q)APfit.modelInfo
data     | (4.353367 2.253873 0.3467574 7.672766 3.332201 7.319711 ..
inputs   | `df`damp`diag`iter!(`nege2dist;0.3;k){avg x(<x)@_.5*-1 0..
clust    | 0 0 0 1 0 2 3 3 3 3
exemplars| 1 1 1 3 1 5 6 6 6 6

// Predict on new data
q)show newData:2 5#10?10.
4.457843 1.588047 8.627901 1.187397   7.657092
2.781109 7.581456 5.733454 0.02703805 1.695153
q)APfit.predict newData
0 3 2 0 2
```


## `.ml.clust.cure.fit`

_Fit CURE algorithm_

```syntax
.ml.clust.cure.fit[data;df;n;c]
```

Where

-   `data` is a point matrix
-   `df`  is the distance function as a symbol: ``` `e2dist`edist`mdist ``` – see [Distance Metrics](#distance-metrics)
-   `n` is the number of representative points
-   `c` is the compression ratio

returns a dictionary containing information collected during the fitting process (`modelInfo`), along with a projection of the prediction function to use on new data (`predict`)

??? "Result dictionary"

	All relevant information needed to evaluate the model is contained within `modelInfo`. This includes the following information:
	
	- `data`   – original data used to fit the model
	- `inputs` – original input parameters to the fitted model
	- `dgram`  – dendrogram generated during the fitting process
	
	The predict functionality is contained within the `predict` key. This function takes arguments
	
	-   `data` is a point matrix
	-   `cutDict` is a dictionary where the key defines what cutting algo to use when splitting the data into clusters (`k`/`dist`) and the value defines the cutting threshold. (See [cutDist](#mlclustcurecutDist) and [cutK](#mlclustcurecutK))
	
	and returns the predicted clusters of the new data.

```q
q)show data:2 10#20?10.
6.12576 9.773429 6.538218 2.012211 1.841789 8.267402 7.237186 2.68311..
9.73078 8.271735 9.635953 5.188231 5.815475 3.546833 3.189686 6.27793..

// Fit a CURE model
q)show CUREfit:.ml.clust.cure.fit[data;`e2dist;2;0.]
modelInfo| `data`inputs`dgram!((6.12576 9.773429 6.538218 2.012211 1...
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..

// Information generated during the fitting of the model
q)CUREfit.modelInfo
data  | (6.12576 9.773429 6.538218 2.012211 1.841789 8.267402 7.23718..
inputs| `df`n`c!(`e2dist;2;0f)
dgram | +`idx1`idx2`dist`n!(0 3 11 5 10 14 13 15 17i;2 4 7 6 9 1 8 12..

// Dendrogram created
q)CUREfit[`modelInfo;`dgram]
idx1 idx2 dist      n 
----------------------
0    2    0.1791135 2 
3    4    0.4224797 2 
11   7    0.9216997 3 
5    6    1.1889    2 
10   9    3.063088  3 
14   1    4.208402  4 
13   8    10.06965  3 
15   12   23.77395  7 
17   16   24.59282  10

// Predict on new data
q)show newData:2 5#10?10.
6.619148  7.345548 6.878925 7.044121 6.007517
0.9989967 5.158208 9.662082 8.046487 3.449115

// Create 2 clusters
q)CUREfit.predict[newData;enlist[`k]!enlist 2]
1 1 0 0 1

// Create clusters based on distance threshold
q)CUREfit.predict[test;enlist[`dist]!enlist 1]
6 2 0 0 3
```


## `.ml.clust.cure.cutDist`

_Generate clusters - cutting the dendrogram based on a threshold distance_

```syntax
.ml.clust.cure.cutDist[config;dist]
```

Where

-   `config` is the output dictionary produced by the CURE fit function
-   `dist` is the threshold distance applied when cutting the dendrogram into clusters

returns an updated `config` containing a new key `clust` indicating the cluster to which each data point belongs.

```q
q)show data:2 10#20?10.
0.8501293 9.66548  9.718821 9.04914  0.6350621 7.396237 6.32245  4.2..
7.106457  7.385984 2.024464 3.601803 1.818919  3.010721 4.025844 8.7..

// Fit CURE algorithm
q)show CUREfit:.ml.clust.cure.fit[data;`e2dist;2;0.]
modelInfo| `data`inputs`dgram!((0.8501293 9.66548 9.718821 9.04914 0..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..

// Dendrogram created
q)CUREfit[`modelInfo;`dgram]
idx1 idx2 dist     n 
---------------------
5    6    2.183492 2 
10   9    2.197704 3 
2    3    2.936469 2 
12   11   3.081467 5 
7    8    5.345063 2 
1    13   13.03234 6 
15   14   13.18999 8 
0    16   14.45383 9 
17   4    28.00431 10

// Cut the dendrogram using a distance threshold of 5
q)show cutDgram:.ml.clust.cure.cutDist[CUREfit;5]
modelInfo| `data`inputs`dgram!((0.8501293 9.66548 9.718821 9.04914 0..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..
clust    | 3 2 0 0 5 0 0 1 4 0
q)cutDgram`clust
3 2 0 0 5 0 0 1 4 0
```


## `.ml.clust.cure.cutK`

_Generate clusters - cutting dendrogram into k clusters_

```syntax
.ml.clust.hc.cutK[config;k]
```

Where

-   `config` is the output dictionary produced by the CURE fit function
-   `k` is the number of clusters to be produced from cutting the dendrogram

returns an updated `config` containing a new key `clust` indicating the cluster to which each data point belongs.

```q
q)show data:2 10#20?10.
0.8501293 9.66548  9.718821 9.04914  0.6350621 7.396237 6.32245  4.26..
7.106457  7.385984 2.024464 3.601803 1.818919  3.010721 4.025844 8.77..

// Fit CURE algorithm
q)show CUREfit:.ml.clust.cure.fit[data;`e2dist;2;0.]
modelInfo| `data`inputs`dgram!((0.8501293 9.66548 9.718821 9.04914 0..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..

// Dendrogram created
q)CUREfit[`modelInfo;`dgram]
idx1 idx2 dist     n 
---------------------
5    6    2.183492 2 
10   9    2.197704 3 
2    3    2.936469 2 
12   11   3.081467 5 
7    8    5.345063 2 
1    13   13.03234 6 
15   14   13.18999 8 
0    16   14.45383 9 
17   4    28.00431 10

// Cut the dendrogram into 3 clusters
q)show cutDgram:.ml.clust.cure.cutK[CUREfit;3]
modelInfo| `data`inputs`dgram!((0.8501293 9.66548 9.718821 9.04914 0..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..
clust    | 1 0 0 0 2 0 0 0 0 0
q)cutDgram`clust
1 0 0 0 2 0 0 0 0 0
```


## `.ml.clust.cure.fitPredict`

_Fit CURE algorithm to data and convert dendrogram to clusters_

```syntax
.ml.clust.cure.fitPredict[data;df;n;c;cutDict]
```

Where

-   `data` is a point matrix
-   `df`  is the distance function as a symbol: `` `e2dist`edist`mdist `` – see [Distance Metrics](#distance-metrics)
-   `n` is the number of representative points
-   `c` is the compression ratio
-   `cutDict` is a dictionary where the key defines what cutting algo to use when splitting the data into clusters (`k`/`dist`) and the value defines the cutting threshold. (See [cutDist](#mlclustcurecutDist) and [cutK](#mlclustcurecutK))

returns a dictionary containing information collected during the fitting process (`modelInfo`), a projection of the prediction function to use on new data (`predict`) and the cluster to which each data point belongs (`clust`)

??? "Result dictionary"

	All relevant information needed to evaluate the model is contained within `modelInfo`. This includes the following information:

	-   `data`   – original data used to fit the model
	-   `inputs` – original input parameters to the fitted model
	-   `dgram`  – dendrogram generated during the fitting process
	
	The predict functionality is contained within the `predict` key. This function takes arguments
	
	-   `data` is a point matrix
	-   `cutDict` is a dictionary where the key defines what cutting algo to use when splitting the data into clusters (`k`/`dist`) and the value defines the cutting threshold. (See [cutDist](#mlclustcurecutDist) and [cutK](#mlclustcurecutK))
	
	and returns the predicted clusters of the new data.

	The cluster each data point belongs to is contained within ` clust`.

```q
q)show data:2 10#20?10.
1.473702 4.080537 3.03448  9.659883  7.874197 4.734442 8.423141 2.7..
0.72077  5.450964 4.625792 0.6486378 6.951865 9.674697 7.26315  2.4..

// Fit a CURE model and cut the dendrogram into 3 clusters
q).ml.clust.cure.fitPredict[data;`e2dist;2;0.;enlist[`k]!enlist 3]
modelInfo| `data`inputs`dgram!((1.473702 4.080537 3.03448 9.659883 ..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..
clust    | 0 0 0 1 1 2 1 0 1 0
```


## `.ml.clust.dbscan.fit`

_Fit DBSCAN algorithm_

```syntax
.ml.clust.dbscan.fit[data;df;minPts;eps]
```

Where

-   `data` is a point matrix
-   `df` is the distance function as a symbol: ``` `e2dist`edist`mdist ``` (see [Distance Metrics](##Distance Metrics))
-   `minPts` is the minimum number of points required in a given neighborhood to define a cluster
-   `eps` is the epsilon radius, the distance from each point within which points are defined as being in the same cluster

returns a dictionary containing information collected during the fitting process (`modelInfo`), a projection of the prediction function to use on new data (`predict`) along with a projection of the update function (`update`)

??? "Result dictionary"

	All relevant information needed to evaluate the model is contained within `modelInfo`. This includes
	
	-   `data`   – original data used to fit the model
	-   `inputs` – original input parameters to the fitted model
	-   `clust`  – cluster index each data point belongs to. Any outliers in the data will return a value of -1 as their cluster.
	-   `tab`    – neighborhood table defining information about the clusters

	The predict functionality is contained within the `predict` key. This function takes a point matrix argument, and returns the predicted clusters of the new data.

	The `update` function can be used to update the cluster centres such that the model can react to new data. This function takes a point matrix argument, and returns the updated dictionary (the result of `.ml.clust.dbscan.fit`) with new data points added.

```q
q)show data:2 10#20?10.
2.210442 8.001283 9.50319  7.346766 3.633887 5.076864 4.483854 4.28..
3.247794 7.064748 5.497131 1.792938 5.106208 2.162566 7.440406 3.08..

// Fit a DBSCAN model
q)show DBSCANfit:.ml.clust.dbscan.fit[data;`e2dist;2;1]
modelInfo| `data`inputs`clust`tab!((5.17263 5.250215 3.552399 1.58..
predict  | {[config;data]
  config:config[`modelInfo];
  data:clust.i.floatCo..
update   | {[config;data]
  modelConfig:config[`modelInfo];
  data:clust.i.fl..

// Information generated during the fitting of the model
q)DBSCANfit.modelInfo
data  | (5.17263 5.250215 3.552399 1.588559 5.040167 9.484854 3.11..
inputs| `df`minPts`eps!(`e2dist;2;1)
clust | -1 -1 0 -1 -1 -1 0 -1 -1 -1
tab   | +`nbhood`cluster`corePoint!((`long$();`long$();,6;`long$()..;
q)DBSCANfit[`modelInfo;`clust]
-1 -1 0 -1 -1 -1 0 -1 -1 -1

// Update model using new data
q)show newData:2 10#20?10.
3.369498 9.356007   1.147945 2.684219 1.860831 3.774197 6.081109 3..
3.415333 0.03463214 6.797509 6.255361 7.520247 5.643469 7.430837 9..
q)show updDBSCAN:DBSCANfit.update[newData]
modelInfo| `data`inputs`clust`tab!((5.17263 5.250215 3.552399 1.58..
predict  | {[config;data]
  config:config[`modelInfo];
  data:clust.i.floatCo..
update   | {[config;data]
  modelConfig:config[`modelInfo];
  data:clust.i.fl..

// Clusters from updated model
q)updDBSCAN[`modelInfo;`clust]
0 -1 1 -1 -1 2 1 0 3 0 -1 2 -1 -1 -1 1 0 -1 -1 3

// Predict on new data
q)DBSCANfit.predict[newData]
-1 -1 -1 -1 -1 0 -1 -1 -1 -1
```


## `.ml.clust.hc.fit`

_Fit HC Algorithm_

```syntax
.ml.clust.hc.fit[data;df;lf]
```

Where

-   `data` is a point matrix
-   `df` is the distance function as a symbol: ``` `e2dist`edist`mdist ``` (see [Distance Metrics](##Distance Metrics))
-   `lf` is the linkage function as a symbol: ``` `single`complete`average`centroid`ward ```

returns a dictionary containing information collected during the fitting process (`modelInfo`), along with a projection of the prediction function to use on new data (`predict`)

??? "Result dictionary"

	All relevant information needed to evaluate the model is contained within `modelInfo`. This includes

	-   `data`   – original data used to fit the model
	-   `inputs` – original input parameters to the fitted model
	-   `dgram`  – dendrogram generated during the fitting process
	
	The predict functionality is contained within the `predict` key. This function takes arguments
	
	-   `data` is a point matrix
	-   `cutDict` is a dictionary where the key defines what cutting algo to use when splitting the data into clusters (`k`/`dist`) and the value defines the cutting threshold. (See [cutDist](#mlclustcurecutDist) and [cutK](#mlclustcurecutK))
	
	and returns the predicted clusters of the new data.

```q
q)show data:2 10#20?10.
4.799813 5.330975 3.083698 2.415329 3.472484 4.094012 0.5718782 9.2..
1.897236 6.968966 2.173592 4.644757 8.286445 3.946073 1.496389  8.0..

// Fit single hierarchial model
q)show HCfit:.ml.clust.hc.fit[data;`e2dist;`single]
modelInfo| `data`inputs`dgram!((5.17263 5.250215 3.552399 1.588559 ..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..

// Information generated during the fitting of the model
q)HCfit.modelInfo
data  | (5.17263 5.250215 3.552399 1.588559 5.040167 9.484854 3.11..
inputs| `df`lf!`e2dist`single
dgram | +`idx1`idx2`dist`n!(2 7 0 4 10 1 15 12 17i;6 9 11 8 13 14 ..

// Dendrogram created
q)HCfit[`modelInfo;`dgram]
idx1 idx2 dist      n 
----------------------
2    6    0.7045331 2 
7    9    1.274268  2 
0    11   1.355958  3 
4    8    1.46799   2 
10   13   4.666131  4 
1    14   7.598059  5 
15   3    7.880744  6 
12   16   8.508274  9 
17   5    18.10505  10

// Predict on new data
q)show newData:2 10#20?10.
8.655105 2.809443 1.733521 3.591677 9.347341 9.735056 6.817983 7.624..
2.809547 4.501989 4.289929 4.224477 4.106569 3.559825 1.712474 5.554..

// Create 3 clusters
q)HCfit.predict[newData;enlist[`k]!enlist 3]
2 1 1 1 2 2 1 0 2 0

// Fit complete hierarchial model
q)show HCfitComp:.ml.clust.hc.fit[data;`e2dist;`complete]
modelInfo| `data`inputs`dgram!((5.17263 5.250215 3.552399 1.588559 5..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict.

// Dendrogram created
q)HCfitComp[`modelInfo;`dgram]
idx1 idx2 dist      n 
----------------------
2    6    0.7045331 2 
7    9    1.274268  2 
4    8    1.46799   2 
0    11   1.904437  3 
10   12   7.164842  4 
1    3    15.32325  2 
15   14   29.27081  6 
16   5    63.28895  7 
13   17   72.8679   10
```


## `.ml.clust.hc.cutDist`

_Generate clusters - cutting the dendrogram based on a threshold distance_

```syntax
.ml.clust.hc.cutDist[config;dist]
```

Where

-   `config` is the output dictionary produced by the hierarchical clustering fit function
-   `dist` is the threshold distance applied when cutting the dendrogram into clusters

returns an updated `config` containing a new key `clust` indicating the cluster to which each data point belongs.

```q
q)show data:2 10#20?10.
7.263153 2.624281 8.388946 7.931885 6.323605 9.69682  4.856966 9.1..
4.637059 7.549387 2.165773 7.280013 4.368342 5.276732 4.636653 1.0..

// Fit HC algorithm
q)show HCfit:.ml.clust.hc.fit[data;`e2dist;`single]
modelInfo| `data`inputs`dgram!((5.17263 5.250215 3.552399 1.588559..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..

// Dendrogram of data
q)HCfit[`modelInfo;`dgram]
idx1 idx2 dist      n 
----------------------
2    6    0.7045331 2 
7    9    1.274268  2 
0    11   1.355958  3 
4    8    1.46799   2 
10   13   4.666131  4 
1    14   7.598059  5 
15   3    7.880744  6 
12   16   8.508274  9 
17   5    18.10505  10

// Cut the dendrogram using a distance threshold of 3
q)show cutDgram:.ml.clust.hc.cutDist[HCfit;3]
modelInfo| `data`inputs`dgram!((5.17263 5.250215 3.552399 1.588559 ..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..
clust    | 1 3 0 4 2 5 0 1 2 1
q)cutDgram`clust
1 3 0 4 2 5 0 1 2 1
```


## `.ml.clust.hc.cutK`

_Generate clusters - cutting the dendrogram into k clusters_

```syntax
.ml.clust.hc.cutK[config;k]
```

Where

-   `config` is the output dictionary produced by the hierarchical clustering fit function
-   `k` is the number of clusters to be produced from cutting the dendrogram

returns an updated `config` containing a new key `clust` indicating the cluster to which each data point belongs.

```q
q)show data:2 10#20?10.
7.263153 2.624281 8.388946 7.931885 6.323605 9.69682  4.856966 9.1..
4.637059 7.549387 2.165773 7.280013 4.368342 5.276732 4.636653 1.0..

// Fit HC algorithm
q)show HCfit:.ml.clust.hc.fit[data;`e2dist;`single]
modelInfo| `data`inputs`dgram!((5.17263 5.250215 3.552399 1.588559..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..

// Dendrogram of data
q)HCfit[`modelInfo;`dgram]
idx1 idx2 dist      n 
----------------------
2    6    0.7045331 2 
7    9    1.274268  2 
0    11   1.355958  3 
4    8    1.46799   2 
10   13   4.666131  4 
1    14   7.598059  5 
15   3    7.880744  6 
12   16   8.508274  9 
17   5    18.10505  10

// Cut the dendrogram into 4 clusters
q)show cutDgram:.ml.clust.hc.cutK[HCfit;4]
modelInfo| `data`inputs`dgram!((5.17263 5.250215 3.552399 1.588559..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..
clust    | 1 0 0 2 0 3 0 1 0 1
q)cutDgram`clust
1 0 0 2 0 3 0 1 0 1
```


## `.ml.clust.hc.fitPredict`

_Fit HC algorithm to data and convert dendrogram to clusters_

```syntax
.ml.clust.hc.fitPredict[data;df;lf]
```

Where

-   `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
-   `df` is the distance function as a symbol: ``` `e2dist`edist`mdist ``` (see [Distance Metrics](##Distance Metrics))
-   `lf` is the linkage function as a symbol: ``` `single`complete`average`centroid`ward ```

returns a dictionary containing information collected during the fitting process (`modelInfo`), a projection of the prediction function to use on new data (`predict`) and the cluster to which each data point belongs (`clust`).

??? "Result dictionary"

	All relevant information needed to evaluate the model is contained within `modelInfo`. This includes

	-   `data`   – original data used to fit the model
	-   `inputs` – original input parameters to the fitted model
	-   `dgram`  – dendrogram generated during the fitting process
	
	The predict functionality is contained within the `predict` key. This function takes arguments
	
	-   `data` is a point matrix
	-   `cutDict` is a dictionary where the key defines what cutting algo to use when splitting the data into clusters (`k`/`dist`) and the value defines the cutting threshold. (See [cutDist](#mlclustcurecutDist) and [cutK](#mlclustcurecutK))
	
	and returns the predicted clusters of the new data.

	The cluster each data point belongs to is contained in `clust`.

```q
q)show data:2 10#20?10.
6.01551  9.775468 9.809354 4.237163 5.424916 1.994707 2.496307 2.599..
1.046143 7.154895 8.098937 2.546309 6.298331 0.249301 5.341463 4.106..

// Fit a HC model and cut the dendrogram into 4 clusters
q).ml.clust.hc.fitPredict[data;`e2dist;`single;enlist[`k]!enlist 4]
modelInfo| `data`inputs`dgram!((6.01551 9.775468 9.809354 4.237163 5..
predict  | {[config;data;cutDict]
  updConfig:clust.i.prepPred[config;cutDict..
clust    | 0 2 2 0 1 3 0 0 0 1
```


## `.ml.clust.kmeans.fit`

_Fit K-means Algorithm_

```syntax
.ml.clust.kmeans.fit[data;df;k;config]
```

Where

-   `data` is a point matrix
-   `df` is the distance function: ``` `e2dist`edist ``` (see [Distance Metrics](##Distance Metrics))
-   `k` is the number of clusters
-   `config` is a dictionary allowing a user to change the following model parameters (for entirely default values use `(::)`)
	- `iter` the number of iterations to be completed. Default = `100`
	- `init` the algorithm used to initialise cluster centers. This is either random (`0b`) or uses [k-means++](https://en.wikipedia.org/wiki/K-means%2B%2B) (`1b`). Default = `1b`
	- `thresh` if a cluster center moves by more than this value along any axis continue algorithm, otherwise stop. Default = `1e-5`.

returns a dictionary containing information collected during the fitting process (`modelInfo`), a projection of the prediction function to use on new data (`predict`) along with a projection of the update function (`update`)

??? "Result dictionary"

	All relevant information needed to evaluate the model is contained within `modelInfo`. This includes
	
	-   `data`   – original data used to fit the model
	-   `df`     – distance metric used
	-   `repPts` – calculated k centers 
	-   `clust`  – cluster index each data point belongs to.

	The predict functionality is contained within the `predict` key. This function takes a matrix argument representing the points being analyzed in matrix format, where each column is an individual datapoint, and returns the predicted clusters of the new data.

	The `update` function can be used to update the cluster centres such that the model can react to new data. This function takes a point matrix argument, and returns the updated dictionary (the result of `.ml.clust.kmeans.fit`) with new data points added.

```q
show data:2 10#20?10.
9.906212  5.073676 9.560646 6.719448 3.42593 6.010412 6.137498 6.56..
0.2663305 7.935343 1.485224 8.540814 5.74697 2.619185 1.379876 3.23..

// Fit a kmeans model
show kmeansFit:.ml.clust.kmeans.fit[data;`e2dist;3;::]
modelInfo| `repPts`clust`data`inputs!((4.888017 5.941845;7.367534 ..
predict  | {[config;data]
  config:config[`modelInfo];
  data:clust.i.floatCo..
update   | {[config;data]
  modelConfig:config[`modelInfo];
  data:clust.i.fl..

// Information generated during the fitting of the model
q)kmeansFit.modelInfo
repPts| (4.888017 5.941845;7.367534 0.2570141;2.870303 2.005258)
clust | 0 1 0 2 0 1 0 0 2 0
data  | (5.17263 5.250215 3.552399 1.588559 5.040167 9.484854 3.1..
inputs| `df`k`iter`kpp!(`e2dist;3;100;1b)
q)kmeansFit[`modelInfo;`clust]
0 1 0 2 0 1 0 0 2 0

// Update model using new data
q)show newData:2 10#20?10.
1.09627  6.292455 5.072447 2.393823 9.210309  3.421872  5.107752  9..
8.593928 2.928818 8.618995 4.764543 0.1244285 0.1204939 0.8363438 8..
q)show updKmeans:kmeansFit.update[newData]
modelInfo| `repPts`clust`data`inputs!((5.10427 6.862332;7.057065 1..
predict  | {[config;data]
  config:config[`modelInfo];
  data:clust.i.floatCo..
update   | {[config;data]
  modelConfig:config[`modelInfo];
  data:clust.i.fl..

// Clusters from updated model
q)updKmeans[`modelInfo;`clust]
0 1 0 2 2 1 2 0 2 0 0 1 0 0 1 2 1 0 1 0

// Predict on new data
q)kmeansFit.predict[newData]
0 1 0 0 1 2 1 0 1 0
```

