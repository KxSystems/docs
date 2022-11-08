---
title: Clustering | Machine Learning Toolkit | Documentation for kdb+ and q
author: Deanna Morgan
date: May 2019
keywords: machine learning, ml, clustering, k-means, dbscan, hierarchical, cure
---
# :fontawesome-solid-share-alt: Clustering 

Clustering is a technique used in both data mining and machine learning to group similar data points together, in order to identify patterns in their distributions. The task of clustering data can be carried out using a range of different algorithms. Each algorithm works by iteratively joining, separating and reassigning points until the desired number of clusters has been achieved, or until the algorithm has determined the optimal number of clusters.

The Machine Learning Toolkit contains a number of [clustering algorithms](algos.md), along with a set of [scoring functions](score.md) for determining the best model. The toolkit also provides an implementation of a [k-dimensional tree](kdtree.md), which underlies a number of the clustering algorithms and is also useful outside of clustering. 

Notebooks showing examples of the clustering algorithms mentioned above can be found at

:fontawesome-brands-github:
[KxSystems/mlnotebooks](https://github.com/kxsystems/mlnotebooks)

All code relating to the clustering section of the Machine Learning Toolkit is available at

:fontawesome-brands-github:
[KxSystems/ml/clust/](https://github.com/KxSystems/ml/tree/master/clust)


## Loading

The clustering library can be loaded independently of the ML Toolkit:

```q
q)\l ml/ml.q
q).ml.loadfile`:clust/init.q
```
