---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# <i class="fas fa-share-alt"></i> Clustering 

The NLP library contains a variety of clustering algorithms, with different parameters and performance characteristics. Some of these are very fast on large data sets, though they look only at the most salient features of each document, and will create many small clusters. Others, such as bisecting k-means, look at all features present in the document, and allow you to specify the number of clusters. Other parameters can include a threshold for the minimum similarity to consider, or how many iterations the algorithm should take to refine the clusters. Some clustering algorithms are randomized, and will produce different clusters every time they are run. This can be very useful, as a data set will have many possible, equally valid, clusterings. Some algorithms will put every document in a cluster, whereas others will increase cluster cohesion by omitting outliers.

Clusters can be summarized by their centroids, which are the sum of the feature vectors of all the documents they contain.


## Markox Cluster algorithm

MCL clustering, which takes document similarity as its only parameter other than the documents. This algorithm first generates an undirected graph of documents by classifying document pairs as related or unrelated, depending on whether their similarity exceeds a given threshold. If they are related, an edge will be created between these documents. It then runs a graph-clustering algorithm on the dataset.


#### `.nlp.cluster.MCL`

_Cluster a subcorpus using graph clustering_

Syntax: `.nlp.cluster.MCL[document;min;sample]`

Where

-   `document` is a table of documents
-   `min` is the minimum similarity (float)
-   `sample` is whether a sample of `sqrt[n]` documents is to be used (boolean)

returns as a list of longs the document’s indexes, grouped into clusters.

Setting a minimum similarity of 0.25 results in 370 clusters out of Jeff Skillings 2603 emails:

``` q
q)clusterjeff:.nlp.cluster.MCL[jeffcorpus;0.25;0b]
q)count clusterjeff
370
```


### Summarizing Cluster algorithm 

This clustering algorithm finds the top ten keywords in each document, finds the average of these keywords and determines the top keyword. This is set to be the centroid and therefore finds the closest document. This process is repeated until the number of clusters are found.


#### `.nlp.cluster.summarize`

_A clustering algorithm that works like many summarizing algorithms, by finding the most representative elements, then subtracting them from the centroid and iterating until the number of clusters has been reached_

Syntax: `.nlp.cluster.summarize[docs;noOfClusters]`

Where

-   `docs` is a list of documents or document keywords (table or list of dictionaries)
-   `noOfClusters` is the number of clusters to return (long)

returns the documents’ indexes, grouped into clusters.

```q
q).nlp.cluster.summarize[jeffcorpus;30]

0 18 22 25 32 33 38 51 54 66 83 87 92 95 100 101 111 112 142 150..
1 79 120 175 176 177 179 180 208 217 281 290 294 295 302 303 306..
2 5 6 12 13 14 16 17 21 26 28 36 46 48 56 60 62 72 73 75 78 85 89..
3 4 8 19 24 27 50 76 110 118 131 139 172 178 232 233 237 244 256..
7 9 10 11 20 108 109 153 201 202 225 255 262 328 344 347 354 463..
15 103 126 128 155 165 186 304 383 419 869 880 1023 1115 1175 1346..
23 86 240 253 701 724 725 727 1029 1037 1725 1932 2054 2528 2579
```

## K-means clustering

Given a set of documents, K-means clustering aims to partition the documents into a number of sets. Its objective is to minimize the residual sum of squares, a measure of how well the centroids represent the members of their clusters.


#### `.nlp.cluster.kmeans`

_K-means clustering for documents_

Syntax: `.nlp.cluster.kmeans[docs;k;iters]`

Where

-   `docs` is a table or a list of dictionaries
-   `k` is the number of clusters to return (long)
-   `iters` is the number of times to iterate the refining step (long)

returns the document’s indexes, grouped into clusters.

Partition _Moby Dick_ into 15 clusters; we find there is one large cluster present in the book:

``` q
q)clusters:.nlp.cluster.kmeans[corpus;15;30]
q)count each clusters
7 4 4 17 49 17 30 4 2 6 3 1 4 1 1
```


## Bisecting K-means

Bisecting K-means adopts the K-means algorithm and splits a cluster in two. This algorithm is more efficient when _k_ is large. For the K-means algorithm, the computation involves every data point of the data set and _k_ centroids. On the other hand, in each bisecting step of Bisecting K-means, only the data points of one cluster and two centroids are involved in the computation. Thus the computation time is reduced. Secondly, Bisecting K-means produce clusters of similar sizes, while K-means is known to produce clusters of widely differing sizes.


#### `.nlp.cluster.bisectingKMeans` 

_The Bisecting K-means algorithm uses K-means repeatedly to split the most cohesive clusters into two clusters_

Syntax: `.nlp.cluster.bisectingKMeans[docs;k;iters]`

Where

-    `docs` is a list of document keywords (table or list of dictionaries)
-    `k` is the number of clusters (long)
-    `iters` is the number of times to iterate the refining step

returns, as a list of lists of longs, the documents’ indexes, grouped into clusters.

```q
q)count each .nlp.cluster.bisectingKMeans[corpus;15;30]
16 54 8 11 39 3 1 1 1 1 1 1 1 10 2
```

## Radix algorithm 

The Radix clustering algorithms are a set of non-comparison, binning-based clustering algorithms. Because they do no comparisons, they can be much faster than other clustering algorithms. In essence, they cluster via topic modeling, but without the complexity.

Radix clustering is based on the observation that Bisecting K-means clustering gives the best cohesion when the centroid retains only its most significant dimension, and inspired by the canopy-clustering approach of pre-clustering using a very cheap distance metric.

At its simplest, Radix clustering just bins on most significant term. A more accurate version uses the most significant _n_ terms in each document in the corpus as bins, discarding infrequent bins. Related terms can also be binned, and documents matching some percent of a bins keyword go in that bin.



### Hard Clustering

Hard Clustering means that each datapoint either belongs to a cluster completely or not.


#### `.nlp.cluster.fastRadix`

_Uses the Radix clustering algorithm and bins by the most significant term_

Syntax: `.nlp.cluster.fastRadix[docs;numOfClusters]`

Where

-   `docs` is a list of documents or document keywords (table or a list of dictionaries)
-   `numOfClusters` is the number of clusters (long)

returns a list of longs, the documents’ indexes, grouped into clusters.

Group Jeff Skilling’s emails into 60 clusters:

```q
q)count each .nlp.cluster.fastRadix[jeffcorpus;60]
39 16 14 39 17 15 14 25 12 13 8 19 14 6 15 12 19 9 12.. 
```


### Soft Clustering

In Soft Clustering, a probability or likelihood of a data point to be in a clusters is assigned. This means that some clusters can overlap.


#### `.nlp.cluster.radix`

_Uses the Radix clustering algorithm and bins are taken from the top 3 terms of each document_

Syntax: `.nlp.cluster.radix[docs;numOfClusters]`

Where

-   `docs` is a list of documents or document keywords (table or a list of dictionaries)
-   `numOfClusters` is the number of clusters (long), which should be large to cover the substantial amount of the corpus, as the clusters are small

returns the documents’ indexes (as a list of longs), grouped into clusters.

Group Jeff Skilling’s emails into 60 clusters:

```q
q)count each .nlp.cluster.radix[jeffcorpus;60]
37 9 13 21 7 7 12 13 7 11 6 9 6 6 5 6 5 8 22 7 12..
```
