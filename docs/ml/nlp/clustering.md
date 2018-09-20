---
hero: <i class="fa fa-share-alt"></i> Machine learning
keywords: algorithm, bisecting, centroid, cluster, clustering, feature, k-mean, kdb+, learning, machine, nlp, q, similarity, vector
---

# Clustering

The NLP library contains a variety of clustering algorithms, with different parameters and performance characteristics. Some of these are very fast on large data sets, though they look only at the most salient features of each document, and will create many small clusters. Others, such as bisecting k-means, look at all features present in the document, and allow you to specify the number of clusters. Other parameters can include a threshold for the minimum similarity to consider, or how many iterations the algorithm should take to refine the clusters. Some clustering algorithms are randomized, and will produce different clusters every time they are run. This can be very useful, as a data set will have many possible, equally valid, clusterings. Some algorithms will put every document in a cluster, whereas others will increase cluster cohesion by omitting outliers.  

Clusters can be summarized by their centroids, which are the sum of the feature vectors of all the documents they contain. 


## Markox Cluster algorithm

MCL clustering, which takes document similarity as its only parameter other than the documents. This algorithm first generates an undirected graph of documents by classifying document pairs as related or unrelated, depending on whether their similarity exceeds a given threshold. If they are related, an edge will be created between these documents. Then it runs a graph-clustering algorithm on the dataset.


### `.nlp.cluster.MCL`

_Cluster a subcorpus using graph clustering_

Syntax: `.nlp.cluster.similarity[document;min;sample]`

Where 

-   `document` is a table of documents
-   `min` is the minimum similarity (float)
-   `sample` is whether a sample of `sqrt[n]` documents is to be used (boolean)

returns as a list of longs the document’s indexes, grouped into clusters.

Cluster 2603 of Jeff Skillings emails, creating 398 clusters with the minimum threshold at 0.25:

``` q
q)clusterjeff:.nlp.cluster.similarity[jeffcorpus;0.25;0b]
q)count clusterjeff
398
```


## Summarizing Cluster algorithm 

This clustering algorithm finds the top ten keywords in each document, finds the average of these keywords and determines the top keyword. This is set to be the centroid and therefore finds the closest document. This process is repeated until the number of clusters are found. 


### `.nlp.cluster.summarize`

_A clustering algorithm that works like many summarizing algorithms, by finding the most representative elements, then subtracting them from the centroid and iterating until the number of clusters has been reached_

Syntax: `.nlp.cluster.summarize[docs;noOfClusters]`

Where 

-   `docs` is a list of documents or document keywords (table or list of dictionaries)
-   `noOfClusters` is the number of clusters to return (long)

returns the documents’ indexes, grouped into clusters. 

```q
q).nlp.cluster.summarize[jeffcorpus;30]

0 31 47 127 361 431 513 615 724 786 929 933 1058..
1 40 44 189 507 514 577 585 746 805 869 1042.. 
2 3 4 6 7 9 10 13 16 17 19 20 22 23 24 28 33 34..
5 27 30 39 393 611 641 654 670 782 820 1358..
8 73 147 427 592 660 743 794 850
11 26 113 236 263 280 281 340 391 414 429 478..
12 14 38 43 49 52 89 173 232 278 325 328 
15 18 21 25 32 45 100 119 168 202 285 298..
29 159 386 430 459 499 508 597 659 731 
68 83 105 132 141 152 177 182 185 226 257.. 
78 91 219 225 231 239 244 255 401 477 524 551..
```


## K-means clustering
 
Given a set of documents, K-means clustering aims to partition the documents into a number of sets. Its objective is to minimize the residual sum of squares, a measure of how well the centroids represent the members of their clusters. 


### `.nlp.cluster.kmeans`

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
32 9 13 9 12 5 12 8 6 8 7 11 11 5 2
```


## Bisecting K-means

Bisecting K-means adopts the K-means algorithm and splits a cluster in two. This algorithm is more efficient when _k_ is large. For the K-means algorithm, the computation involves every data point of the data set and _k_ centroids. On the other hand, in each bisecting step of Bisecting K-means, only the data points of one cluster and two centroids are involved in the computation. Thus the computation time is reduced. Secondly, Bisecting K-means produce clusters of similar sizes, while K-means is known to produce clusters of widely differing sizes. 
 

### `.nlp.cluster.bisectingKmeans` 

_The Bisecting K-means algorithm uses K-means repeatedly to split the most cohesive clusters into two clusters_

Syntax: `.nlp.cluster.bisectingKmeans[docs;k;iters]`

Where 

-    `docs` is a list of document keywords (table or list of dictionaries)
-    `k` is the number of clusters (long)
-    `iters` is the number of times to iterate the refining step

returns, as a list of lists of longs, the documents’ indexes, grouped into clusters.

```q
q)count each .nlp.cluster.bisectingKMeans[corpus;15;30]
8 5 13 5 12 8 10 10 1 12 5 15 1 37 8
```


## Radix algorithm 

The Radix clustering algorithms are a set of non-comparison, binning-based clustering algorithms. Because they do no comparisons, they can be much faster than other clustering algorithms. In essence, they cluster via topic modeling, but without the complexity.

Radix clustering is based on the observation that Bisecting K-means clustering gives the best cohesion when the centroid retains only its most significant dimension, and inspired by the canopy-clustering approach of pre-clustering using a very cheap distance metric.

At its simplest, Radix clustering just bins on most significant term. A more accurate version uses the most significant _n_ terms in each document in the corpus as bins, discarding infrequent bins. Related terms can also be binned, and documents matching some percent of a bins keyword go in that bin. 



### Hard Clustering

Hard Clustering means that each datapoint belongs to a cluster completely or not.


### `.nlp.cluster.fastradix`

_Uses the Radix clustering algorithm and bins by the most significant term_

Syntax: `.nlp.cluster.fastradix[docs;numOfClusters]`

Where

-   `docs` is a list of documents or document keywords (table or a list of dictionaries)
-   `numOfClusters` is the number of clusters (long)

returns a list of list of longs, the documents’ indexes, grouped into clusters.

Group Jeff Skilling’s emails into 60 clusters: 

```q
q)count each .nlp.cluster.radix1[jeffcorpus;60]
15 14 10 9 8 13 9 8 8 6 5 6 6 8 5 6 5 4 4 4 4 4 4 8 4 5 4 4 5 4 4 4 3 3 3 3 3..
```


### Soft Clustering

In Soft Clustering, a probability or likelihood of a data point to be in a clusters is assigned. This mean that some clusters can overlap.


### `.nlp.cluster.radix`

_Uses the Radix clustering algorithm and bins are taken from the top 3 terms of each document_

Syntax: `.nlp.cluster.radix[docs;numOfClusters]`

Where

-   `docs` is a list of documents or document keywords (table or a list of dictionaries)
-   `numOfClusters` is the number of clusters (long), which should be large to cover the substantial amount of the corpus, as the clusters are small

returns the documents’ indexes (as a list of longs), grouped into clusters.

Group Jeff Skilling’s emails into 60 clusters:

```q
q)count each .nlp.cluster.radix2[jeffcorpus;60]
9 7 6 7 10 12 6 5 5 5 6 8 6 5 8 5 6 5 5 5 6 7 5 5 5 6 9 6 5 5 9 5 5 8 17 7 37.
```



## Cluster cohesion

The cohesiveness of a cluster is a measure of how similar the documents are within that cluster.  It is calculated as the mean sum-of-squares error, which aggregates each document’s distance from the centroid. Sorting by cohesiveness will give very focused clusters first.


### `.nlp.cluster.MSE`

_Cohesiveness of a cluster as measured by the mean sum-of-squares error_

Syntax: `.nlp.cluster.MSE x`

Where `x` is a list of dictionaries which are a document’s keyword field, returns as a float the cohesion of the cluster.

```q
q)/16 emails related to donating to charity
q)charityemails:jeffcorpus where jeffcorpus[`text] like "*donate*"
q).nlp.cluster.MSE charityemails`keywords
0.1177886

q)/10 emails chosen at random
q).nlp.cluster.MSE (-10?jeffcorpus)`keywords
0.02862244
```


## Grouping documents to centroids

When you have a set of centroids and you would like to find out which centroid is closest to the documents, you can use this function.  


### `.nlp.cluster.groupByCentroid`

_Documents matched to their nearest centroid_

Syntax: `.nlp.cluster.matchDocswithCentroid[centroid;docs]`

Where

-   `centroid` is a list of the centroids as keyword dictionaries
-   `documents` is a list of document feature vectors

returns, as a list of lists of longs, document indexes where each list is a cluster.

Matches the first centroid of the clusters with the rest of the corpus:

```q
q).nlp.cluster.groupByCentroids[[corpus clusters][0][`keywords];corpus`keywords]
0 23 65 137
1 5 14 45 81
2 6 7 13 15 16 17 19 20 21 26 27 31 40 44 47 48 49 50 54 57 58 62 63 66 67 68..
3 9 10
,4
8 51 55 95 96 108 112 117 129 132 136 146 148
11 12
,18
22 25
,24
28 53 61 72 82 83 86 91 113 130 147
,29
,30
32 33 79 98 104 105 107 131
34 97
35 37 38 39 41 42
36 133 149
43 60 64 74 106 115
```



