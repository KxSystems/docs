---
author: Deanna Morgan
date: May 2019
keywords: machine learning, ml, clustering, k-means, dbscan, hierarchical, cure
---

# <i class="fas fa-share-alt"></i> Clustering Algorithms

Clustering is a technique used in both data mining and machine learning to group similar data points together in order to identify patterns in their distributions. The task of clustering data can be carried out using a number of algorithms. Each algorithm works by iteratively joining, separating or reassigning points until the desired number of clusters have been achieved, or until the algorithm has determined the optimal number of clusters. The process of finding the correct cluster for each data point is then a case of trial and error, where parameters must be altered in order to find the optimum solution.

The machine learning toolkit provides a number of clustering algorithms outlined [here](algos.md), a set of [scoring functions](score.md) which can be used to determine the best model and an implementation of a [k-d tree](kdtree.md) which underlies a number of the clustering algorithms in this toolkit and is useful in a wide range of use cases outside of clustering. 

Notebooks showing examples of the clustering algorithms mentioned above can be found at
<i class="fab fa-github"></i>
[KxSystems/mlnotebooks](https://github.com/kxsystems/mlnotebooks).

All code relating to the clustering section of the machine learning toolkit is available at
<i class="fab fa-github"></i>
[KxSystems/ml/clust/](https://github.com/kxsystems/ml/clust/)

## Loading

The clustering library can be loaded independently of the ML-toolkit using the following:

```q
q)\l ml/ml.q
q).ml.loadfile`:clust/init.q
```

