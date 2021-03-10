---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# :fontawesome-solid-share-alt: Clustering 

<div markdown="1" class="typewriter">
.nlp.cluster   **Clustering functions**
\  Markox Cluster algorithm
    [MCL](#nlpclustermcl)               Cluster a subcorpus using graph clustering

\  Summarizing Cluster algorithm
    [summarize](#nlpclustersummarize)         Uses centroid values in order to cluster similar documents
                      together

\  K-means clustering
    [kmeans](#nlpclusterkmeans)            K-means clustering for documents

\  Bisecting K-means
    [bisectingKMeans](#nlpclusterbisectingkmeans)   Uses K-means repeatedly to split the most
                      cohesive clusters into two clusters 

\  Radix algorithm 
    [fastRadix](#nlpclusterfastradix)         Uses the Radix algorithm and bins by the most significant term
    [radix](#nlpclusterradix)             Uses the Radix algorithm and bins are taken from the
                      top 3 terms of each document

\  Grouping documents to centroids
    [groupByCentroids](#nlpclustergroupbycentroids)  Documents matched to their nearest centroid

\  Cohesion
    [MSE](#nlpclustermse)               Calculate the cohesiveness as measured by the mean sum
                      of squared error
</div>

Following the application of [data-processing procedures](preproc.md), it is possible to apply clustering methods to text.

The NLP library contains a variety of clustering algorithms, with different parameters and performance characteristics. Some of these are very fast on large data sets, though they look only at the most salient features of each document, and will create many small clusters. Others, such as bisecting k-means, look at all features present in the document, and allow you to specify the number of clusters. Other parameters can include a threshold for the minimum similarity to consider, or how many iterations the algorithm should take to refine the clusters. Some clustering algorithms are randomized, and will produce different clusters every time they are run. This can be very useful, as a data set will have many possible, equally valid, clusterings. Some algorithms will put every document in a cluster, whereas others will increase cluster cohesion by omitting outliers.

Clusters can be summarized by their centroids, which are the sum of the [feature vectors](feature-vector.md) of all the documents they contain. 

!!! tip "`parsedTab`"

    In the examples, the `parsedTab` arguments are tables as returne by the `.nlp.newParser` [example](#preproc/nlpnewparser) in the data-preprocessing section. 


Markox Cluster 

: The MCL clustering algorithm first generates an undirected graph of documents by classifying document pairs as related or unrelated, depending on whether their similarity exceeds a given threshold. If they are related, an edge will be created between these documents. It then runs a graph-clustering algorithm on the dataset.


Summarizing Cluster  

: This clustering algorithm finds the top ten keywords in each document, calculates the average of these keywords and determines the top keyword. This is set to be the centroid and therefore finds the closest document. This process is repeated until the number of clusters are found.


K-means clustering

: Given a set of documents, K-means clustering aims to partition the documents into a number of sets. Its objective is to minimize the residual sum of squares, a measure of how well the centroids represent the members of their clusters.

Bisecting K-means

: Bisecting K-means adopts the K-means algorithm and splits a cluster in two. This algorithm is more efficient when _k_ is large. For the K-means algorithm, the computation involves every data point of the data set and _k_ centroids. On the other hand, in each bisecting step of Bisecting K-means, only the data points of one cluster and two centroids are involved in the computation. Thus the computation time is reduced. Secondly, Bisecting K-means produce clusters of similar sizes, while K-means is known to produce clusters of widely differing sizes.

Radix  

: The Radix clustering algorithms are a set of non-comparison, binning-based clustering algorithms. Because they do no comparisons, they can be much faster than other clustering algorithms. In essence, they cluster via topic modeling, but without the complexity.

: Radix clustering is based on the observation that Bisecting K-means clustering gives the best cohesion when the centroid retains only its most significant dimension, and inspired by the canopy-clustering approach of pre-clustering using a very cheap distance metric.

: At its simplest, Radix clustering just bins on most significant term. A more accurate version uses the most significant _n_ terms in each document in the corpus as bins, discarding infrequent bins. Related terms can also be binned, and documents matching some percent of a bins keyword go in that bin.

: _Hard Clustering_ means that each datapoint either belongs to a cluster completely or not. 

: In _Soft Clustering_, a probability or likelihood of a data point to be in a clusters is assigned. This means that some clusters can overlap.

Cohesion

: In clustering, cohesion measures how close objects in a cluster are to each other. A higher cohesion score indicates that the documents in the corpus share similar keywords.




---


## `.nlp.cluster.bisectingKMeans` 

_Uses K-means repeatedly to split the most cohesive clusters into two clusters_

```syntax
.nlp.cluster.bisectingKMeans[parsedTab;k;iters]
```

Where

-  `parsedTab` is a table of parsed documents (return of `.nlp.newParser`)
-  `k` is the number of clusters 
-  `iters` is the number of times to iterate the refining step

returns the documents’ indexes, grouped into clusters.

```q
q)count each .nlp.cluster.bisectingKMeans[parsedTab;15;30]
16 54 8 11 39 3 1 1 1 1 1 1 1 10 2
```

!!! note "The `parsedTab` argument must contain a `keywords` column"


## `.nlp.cluster.fastRadix`

_Uses the Radix clustering algorithm and bins by the most significant term_

```syntax
.nlp.cluster.fastRadix[parsedTab;k]
```

Where

-  `parsedTab` is a table of parsed documents (return of `.nlp.newParser`)
-  `k` is the number of clusters, though fewer may be returned. This must be fairly high to cover a substantial amount of the corpus, as clusters are small

returns the documents’ indexes, grouped into clusters.

```q
q)count each .nlp.cluster.fastRadix[parsedTab;60]
3 3 3 5 8 2 6 2 2 2 2 2 3 2 2
```

!!! note "The `parsedTab` argument must contain a `keywords` column"


## `.nlp.cluster.groupByCentroids`

_Grouping documents to centroids_

```syntax
.nlp.cluster.groupByCentroids[centroid;parsedTab]
```

Where

-  `centroid` is a list of the centroids as keyword dictionaries
-  `parsedTab` is a table of parsed documents (return of `.nlp.newParser`)

returns the documents’ indexes, grouped into clusters.

!!! warning

    These do not line up with the number of centroids passed in, and the number of lists returned may not equal the number of centroids. There can be documents which match no centroids (all of which will end up in the same group), and centroids with no matching documents.

Matches the first centroid of the clusters with the rest of the corpus:

```q
q)show centroids:parsedTab[til 3]`keywords
`chapter`loomings`ishmael`years`ago`mind`long`precise..
`chapter`carpet`bag`stuffed`shirt`old`tucked`arm`star..
`chapter`spouter`inn`entering`gable`ended`found`wide`..

q).nlp.cluster.groupByCentroids[centroids;3_parsedTab`keywords]
,0
1 2 4 9 10
,3
,5
6 7
8 95 96
11 12
,13
...
```

!!! note "The `parsedTab` argument must contain a `keywords` column"

When you have a set of centroids and you would like to find out which centroid is closest to the documents, you can use this function.


## `.nlp.cluster.kmeans`

_K-means clustering for documents_

```syntax
.nlp.cluster.kmeans[parsedTab;k;iters]
```

Where

-  `parsedTab` is a table of parsed documents (return of `.nlp.newParser`)
-  `k` is the number of clusters to return
-  `iters` is the number of times to iterate the refining step

returns the document’s indexes, grouped into clusters.

Partition _Moby Dick_ into 15 clusters; we find there is one large cluster present in the book:

``` q
q)clusters:.nlp.cluster.kmeans[parsedTab;15;30]
q)count each clusters
7 4 4 17 49 17 30 4 2 6 3 1 4 1 1
```

!!! note "The `parsedTab` argument must contain a `keywords` column"


## `.nlp.cluster.MCL`

_Cluster a subcorpus using graph clustering_

```syntax
.nlp.cluster.MCL[parsedTab;minimum;sample]
```

Where

-  `parsedTab` is a table of parsed documents (return of `.nlp.newParser`)
-  `minimum` is the minimum similarity (float)
-  `sample` indicates whether a sample of `sqrt(n)` documents are used `(1b)`, otherwise all documents are to be used `(0b)`

returns the documents’ indexes, grouped into clusters.

Setting a minimum similarity of 0.25 results in 7 clusters out of Moby Dick's 150 chapters:

``` q
q)show 3#cluster:.nlp.cluster.MCL[parsedTab;0.25;0b]
8 96
15 17 19 21
18 20
q)count cluster
7
```

!!! note "The `parsedTab` argument must contain a `keywords` column"


## `.nlp.cluster.MSE`

_Uses the top 50 keywords of each document to calculate the cohesiveness as measured by the mean sum of squares_

```syntax
.nlp.cluster.MSE[keywords]
```

Where

- `keywords` is a dictionary of keywords and their significance scores in a corpus (return of `.nlp.newParser`)

returns the cohesion of the cluster

```q
q).nlp.cluster.MSE[parsedTab[1 2 3]`keywords]
0.07738149
```


## `.nlp.cluster.radix`

_Uses the Radix clustering algorithm and bins are taken from the top 3 terms of each document_

```txt
.nlp.cluster.radix[parsedTab;k]
```

Where

-  `parsedTab` is a table of parsed documents (return of `.nlp.newParser`)
-  `k` is the number of clusters, though fewer may be returned. This must be fairly high to cover a substantial amount of the corpus, as clusters are small

returns the documents’ indexes, grouped into clusters.

```q
q)count each .nlp.cluster.radix[parsedTab;60]
5 17 9 10 23 8 6 7 5 6
```

!!! note "The `parsedTab` argument must contain a `keywords` column"


## `.nlp.cluster.summarize`

_Uses the top ten keywords of each document as centroid values in order to cluster similar documents together_

```syntax
.nlp.cluster.summarize[parsedTab;k]
```

Where

-  `parsedTab` is a table of parsed documents (return of `.nlp.newParser`)
-  `k` is the number of clusters to return

returns the documents’ indexes, grouped into clusters.

```q
q)5#.nlp.cluster.summarize[parsedTab;30]
0 13 71 124
1 5 6 22 40 41 60..
2 46 75
3 4 9 10 11 12 14..
7 65 128
```

!!! note "The `parsedTab` argument must contain a `keywords` column"


