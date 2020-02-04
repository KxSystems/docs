---
author: Deanna Morgan
date: May 2019
keywords: machine learning, ml, clustering, k-means, dbscan, hierarchical, cure, scoring, davies-bouldin, dunn, silhouette, homogeneity, elbow
---

# <i class="fas fa-share-alt"></i> Scoring Metrics

<i class="fab fa-github"></i>
[KxSystems/ml/clust/score.q](https://github.com/kxsystems/ml/clust/score.q)

# Unsupervised Learning

Each of the scoring metrics described below are used in unsupervised learning to analyze how well groups of data have been assigned to clusters. The metrics measure the intra-cluster similarity (cohesion) and inter-cluster differences (separation) of data. It is therefore preferred that clusters are well-spaced and densely packed.

## Davies-Bouldin Index

### `.ml.clust.daviesbouldin`

_Calculate the Davies-Bouldin index for clustered data. Minimum value of zero, where lower values indicate better clustering._

Syntax: `.ml.clust.daviesbouldin[x]`

Where

- `x` is the results table (`idx`, `clt`, `pts`) produced by `.clust.ml.cure/dbscan/hc/kmeans`

returns the Davies-Bouldin index.

```q
q)show d:10 2#20?10.
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
q)show r1:.ml.clust.hc[d;3;`edist;`single;0b]
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
q)show r2:.ml.clust.kmeans[d;3;3;0b;`e2dist]
idx clt pts                 
----------------------------
0   0   0.891041  6.348263  
1   1   8.345194  7.66752   
2   1   3.621949  9.281844  
3   2   9.99934   2.035925  
4   0   3.837986  7.747888  
5   1   8.619188  9.667728  
6   0   0.9183638 8.225125  
7   0   2.530883  9.088765  
8   0   2.504566  6.458066  
9   2   7.517286  0.08962677
q).ml.clust.daviesbouldin[r2]
0.6920524
q).ml.clust.daviesbouldin[r1]    / lower values indicate better clustering
0.3970272
```

!!! note
	The Davies-Bouldin index can only be used with Euclidean distances.
    
## Dunn Index

### `.ml.clust.dunn`

_Calculate the Dunn index for clustered data. Minimum value of 0, where higher values indicate better clustering._

Syntax: `.ml.clust.dunn[x;y]`

Where

- `x` is the results table (`idx`, `clt`, `pts`) produced by `.clust.ml.cure/dbscan/hc/kmeans`
- `y` is the distance function as a symbol: `e2dist` `edist` `mdist`

returns the Dunn index.

```q
q)d
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
q)r1
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
q)r2
idx clt pts
----------------------------
0   0   0.891041  6.348263
1   1   8.345194  7.66752
2   1   3.621949  9.281844
3   2   9.99934   2.035925
4   0   3.837986  7.747888
5   1   8.619188  9.667728
6   0   0.9183638 8.225125
7   0   2.530883  9.088765
8   0   2.504566  6.458066
9   2   7.517286  0.08962677
q).ml.clust.dunn[r1;`edist]
1.124743
q).ml.clust.dunn[r2;`edist]
0.221068
```

## Silhouette Coefficient

### `.ml.clust.silhouette`

_Calculate the Silhouette coefficient for clustered data. `+1` indicates correct clustering, `0` indicates that clusters are close to each other, if not overlapping and `-1` indicates incorrect clustering._

Syntax: `.ml.clust.silhouette[x;y]`

Where

- `x` is the results table (`idx`, `clt`, `pts`) produced by `.clust.ml.cure/dbscan/hc/kmeans`
- `y` is the distance function as a symbol: `e2dist` `edist` `mdist`
- `z` is a boolean, `1b` indicates that the user wants to return the average coefficient

returns the Silhouette coefficient.

```q
q)d
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
q)r1
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
q)r2
idx clt pts
----------------------------
0   0   0.891041  6.348263
1   1   8.345194  7.66752
2   1   3.621949  9.281844
3   2   9.99934   2.035925
4   0   3.837986  7.747888
5   1   8.619188  9.667728
6   0   0.9183638 8.225125
7   0   2.530883  9.088765
8   0   2.504566  6.458066
9   2   7.517286  0.08962677
q).ml.clust.silhouette[r1;`edist;1b]
0.6180839
q).ml.clust.silhouette[r2;`edist;1b]
0.4330343
```

# Supervised Learning

If the correct cluster is known for each data point in a chosen dataset, the problem of clustering the data can be treated as supervised learning. The true and predicted labels can be compared using scores such as the homogeneity score detailed below.

## Homogeneity Score

### `.ml.clust.homogeneity`

_Returns a score between 0 and 1, where 1 indicates correct clustering_

Syntax: `.ml.clust.homogeneity[x;y]`

Where

-  `x` is the predicted cluster labels
-  `y` is the true cluster labels

returns the homogeneity score.

```q
q)true
2 1 0 0 0 0 2 0 1 2
q)pred
2 1 2 0 1 0 1 2 0 1
q).ml.clust.homogeneity[pred;true]
0.225179
q).ml.clust.homogeneity[true;true]
1f
```

# Optimum Number of Clusters

## Elbow Method

The elbow method is used to find the optimum number of clusters for data grouped using k-means clustering. k-means is applied to a dataset for a range of k values and the average score for each set of clusters is calculated. Traditionally, the distortion score is used in the elbow method. This score calculates the sum of square distances from each point to its assigned center.

Plotting the average cluster score against the k values, the line graph produced will resemble an arm, where the value at the elbow indicates the optimum number of clusters for the chosen dataset.

### `.ml.clust.elbow`

_Returns a distortion score for each value of k applied to data using k-means clustering_

Syntax: `.ml.clust.elbow[x;y;z]`

Where

-   `x` is data in matrix form
-   `y` is the distance metric
-   `z` is the maximum number of clusters

returns the distortion score for each set of clusters produced in k-means with a different value of k.

```q
q)show d:100 2#200?10. 
4.784272  9.534398 
6.30036   3.165436 
6.549844  2.643322 
3.114316  9.103693 
0.7540168 7.423834 
7.414441  7.074521 
8.872926  3.763147 
3.88313   4.84379  
0.7841939 1.943085 
3.213079  4.090672 
..
q).ml.clust.elbow[d;`mdist;5]
365.4611 262.1237 239.9233 196.0932
```

!!! note
	If the values produced by `.ml.clust.elbow` are plotted it is possible to determine the optimum number of clusters. The above example produces the following graph

	![elbow_graph](img/elbow_example.png)

	It is clear that the elbow score occurs when the data has been clustered into 3 distinct clusters.
