---
author: Deanna Morgan
date: May 2019
keywords: machine learning, ml, clustering, k-means, dbscan, hierarchical, cure, scoring, davies-bouldin, dunn, silhouette, homogeneity, elbow
---

# <i class="fas fa-share-alt"></i> Scoring Metrics

The scoring metrics provided for the clustering section of the machine learning toolkit allow users to validate the performance of their clustering algorithms. These metrics cover three distinct use-cases

1. Unsupervised Learning: 

	These metrics analyze how well groups of data have been assigned to clusters. The metrics measure the intra-cluster similarity (cohesion) and inter-cluster differences (separation) of data. In general clustering is said to be successful if clusters are well-spaced and densely packed.

2. Supervised Learning:

	If the labels of the clusters are known for each data point in a chosen dataset, the problem of clustering the data can be analysed in a supervised manner. The true and predicted labels can be compared using metrics such as the homogeneity score detailed below.

3. Optimum number of cluster:

	If the correct number of clusters is not known prior to the application of a clustering method it is possible to use the **Elbow Method** to estimate the optimum number of clusters within the dataset using K-means clustering.

The following are the scoring metrics and analysis function provided within this library

```txt
.ml.clust - Scoring Metrics
  // Unsupervised Learning
  .daviesbouldin      Davies-Bouldin Index
  .dunn               Dunn Index
  .silhouette         Silhouette score

  // Supervised Learning
  .homogeneity        Homogeneity score between predictions and actual value

  // Cluster Optimisation
  .elbow              Distortion scores for increasing numbers of clusters
```

<i class="fab fa-github"></i>
[KxSystems/ml/clust/score.q](https://github.com/kxsystems/ml/clust/score.q)


## Unsupervised Learning

The following scoring methods are provided for use when the true cluster assignment is not known.

1. **Davies-Bouldin Index**:

	This index works by calculating the ratio of how scattered data points are within a cluster, to the separation that exists between clusters. A lower value indicates that the clusters are well separated and tightly packed.

2. **Dunn Index**:

	This index is calculated based on the minimum inter-cluster distance divided by the maximum size of a cluster. A higher Dunn Index indicates better clustering, where the definition of better is that clusters are compact and well-separated.

3. **Silhouette Score**:

	This score measures how similar an object is to the members of its own cluster when compared to other clusters. This metric ranges from -1 to +1 with a high value indicating that objects are well matched to their own clusters and poorly matched to neighbouring clusters. A value of -1 indicates clusters are overlapping, 0 indicates that clusters are close to one another and +1 indicates clusters are separated from one another.

### `.ml.clust.daviesbouldin`

_Calculate the Davies-Bouldin index for clustered data._

Syntax: `.ml.clust.daviesbouldin[data;clt]`

Where

- `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
- `clt` is the list of clusters returned by one of the clustering algorithms in `.ml.clust`

returns the Davies-Bouldin index.

```q
q)show d:2 10#20?10.
3.927524 5.170911 5.159796  4.066642 1.780839 3.017723 7.85033  5.347096..
4.931835 5.785203 0.8388858 1.959907 3.75638  6.137452 5.294808 6.916099..
q)show r1:.ml.clust.hc[d;`edist;`single;3]
0 0 1 1 0 0 2 0 1 0
q)show r2:.ml.clust.kmeans[d;`e2dist;3;10;0b]
0 0 1 1 0 2 0 2 1 2

// lower values indicate better clustering
q).ml.clust.daviesbouldin[d;r1] 
0.56649
q).ml.clust.daviesbouldin[d;r2]
1.424637
```

### `.ml.clust.dunn`

_Calculate the Dunn index for clustered data._

Syntax: `.ml.clust.dunn[data;df;clt]`

Where

- `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
- `df` is the distance function as a symbol, e.g. `e2dist` `edist` `mdist` etc.
- `clt` is the list of clusters returned by the clustering algorithms in `.ml.clust`

returns the Dunn index.

```q
q)show d:2 10#20?10.
3.927524 5.170911 5.159796  4.066642 1.780839 3.017723 7.85033  5.347096..
4.931835 5.785203 0.8388858 1.959907 3.75638  6.137452 5.294808 6.916099..
q)show r1:10?3
0 0 1 1 0 0 2 0 1 0
q)show r2:10?3
0 0 1 1 0 2 0 2 1 2

// higher values indicate better clustering
q).ml.clust.dunn[d;`edist;r1]
0.5716933
q).ml.clust.dunn[d;`e2dist;r2]
0.03341283
```

### `.ml.clust.silhouette`

_Calculate the Silhouette coefficient for clustered data._

Syntax: `.ml.clust.silhouette[data;df;clt;isavg]`

Where

- `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
- `df` is the distance function as a symbol, e.g. `e2dist` `edist` `mdist` etc.
- `clt` is the list of clusters returned by the clustering algorithms in `.ml.clust`
- `isavg` is a boolean - `1b` to return the average coefficient, `0b` to return a list of coefficients

returns the Silhouette coefficient.

```q
q)show d:2 10#20?10.
3.927524 5.170911 5.159796  4.066642 1.780839 3.017723 7.85033  5.347096..
4.931835 5.785203 0.8388858 1.959907 3.75638  6.137452 5.294808 6.916099..
q)show r1:10?3
0 0 1 1 0 0 2 0 1 0
q)show r2:10?3
0 0 1 1 0 2 0 2 1 2

// Return the averaged coefficients across all points
q).ml.clust.silhouette[d;`edist;r1;1b]
0.3698386
q).ml.clust.silhouette[d;`e2dist;r2;1b]
0.2409856

// Return the individual coefficients for each point
q).ml.clust.silhouette[d;`e2dist;r2;0b]
-0.4862092 -0.6652588 0.8131323 0.595948 -0.2540023 0.5901292 -0.2027718 0.61..
```


## Supervised Learning

The following metrics are provided in the case that the true and predicted labels of the clusters are known

1. **Homogeneity Score**:

	This metric works on the basis that a cluster should contain only samples belonging to a single class. The metric is bounded between 0 and 1 with high value indicating more homogenous (more accurate) labeling of clusters

### `.ml.clust.homogeneity`

_Homogeneity score between predicted and true labels_

Syntax: `.ml.clust.homogeneity[pred;true]`

Where

-  `pred` is the predicted cluster labels
-  `true` is the true cluster labels

returns the homogeneity score.

```q
q)show true:10?3
2 1 0 0 0 0 2 0 1 2
q)show pred:10?3
2 1 2 0 1 0 1 2 0 1
q).ml.clust.homogeneity[pred;true]
0.225179
q).ml.clust.homogeneity[true;true]
1f
```

## Optimum Number of Clusters

The optimum number of clusters can be found manually in a number of ways using techniques above. Within the toolkit we provide an implementation of one of the most common methods for caluculating the optimum number of clusters:

1. **Elbow Method**:

	The elbow method is used to find the optimum number of clusters for data grouped using k-means clustering. K-means is applied to a dataset for a range of k values and the average score for each set of clusters is calculated. Traditionally, the distortion score is used in the elbow method. This score calculates the sum of square distances from each point to its assigned center.

	Plotting the average cluster score against the k values, the line graph produced will resemble an arm, where the value at the elbow indicates the optimum number of clusters for the chosen dataset.

### `.ml.clust.elbow`

_Returns a distortion score for each value of k applied to data using k-means clustering_

Syntax: `.ml.clust.elbow[data;df;k]`

Where

- `data` represents the points being analyzed in matrix format, where each column is an individual datapoint
- `df` is the distance function as a symbol, e.g. `e2dist` `edist`.
- `k` is the maximum number of clusters

returns the distortion score for each set of clusters produced in k-means with a different value of k.

```q
q)show d:2 10#20?10.
3.927524 5.170911 5.159796  4.066642 1.780839 3.017723 7.85033  5.347096..
4.931835 5.785203 0.8388858 1.959907 3.75638  6.137452 5.294808 6.916099.. 
q).ml.clust.elbow[d;`edist;5]
16.74988 13.01954 10.91546 9.271871
```

!!! note
	If the values produced by `.ml.clust.elbow` are plotted it is possible to determine the optimum number of clusters. The above example produces the following graph

	![elbow_graph](img/elbow_example.png)

	It is clear that the elbow score occurs when the data should be grouped into 3 clusters.
