---
title: Demonstration notebooks for machine learning – Machine Learning – kdb+ and q documentation
description: EmbedPy and JupyterQ can be used to solve all kind of machine-learning problems, from feature engineering to the training and testing of models. They also allow users to display results in a range of ways, giving a better understanding of the data and results. The notebooks described here provide examples that bring together these concepts and show what can be achieved.
keywords: embedPy, Jupyter, ml, machine learning, notebook, Python
---
# :fontawesome-solid-share-alt: Demonstration notebooks for machine learning

EmbedPy and JupyterQ can be used to solve all kind of machine-learning problems, from feature engineering to the training and testing of models. They also allow users to display results in a range of ways, giving a better understanding of the data and results.


The notebooks at 
:fontawesome-brands-github: 
[KxSystems/mlnotebooks](https://github.com/KxSystems/mlnotebooks)
provide examples that bring together these concepts and show what can be achieved.

The contents of the notebooks are as follows:

1. **Decision Trees**: A decision tree is trained to detect if a patient has either benign or malignant cancer. The performance of the model is measured by computing a confusion matrix and ROC curve.

2. **Random Forests**: Random forest and XGBoost classifiers are trained to identify satisfied and unsatisfied financial clients. Different parameters are tuned and tested, with classifier performance evaluated using the ROC curve.

3. **Neural Networks**: A neural network is trained to identify samples of handwritten digits from the MNIST database. Performance is calculated for a test set of images, with a variety of plots used to show the results.

4. **Dimensionality Reduction**: Principal Component Analysis (PCA) and t-distributed Stochastic Neighbor Embedding (t-SNE) are used to reduce the dimensionality of the original dataset. Several plots are used to visualize reduced features and infer differences between the distinct groups present in the data.

5. **Feature Engineering**: Examples of data preprocessing that can highly affect the performance of a model are demonstrated. The first section of the notebook focuses on the robustness of different scalers against k-nearest neighbours, while the second section demonstrates the importance of one-hot encoding labels when training a neural network.

6. **Feature Extraction and Selection**: The three examples provided explain how to effectively use the FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm to extract features and determine how significant each feature is in predicting a target vector. The examples make use of both random forest and gradient boosting models.

7. **Cross Validation**: Cross validation procedures are demonstrated against a random forest classifier, with the aim of classifying breast cancer data. Results produced for the different cross validation methods available in the toolkit are compared.

8. **Natural Language Processing**: Parsing, clustering, sentiment analysis and outlier detection are demonstrated on a range of corpora, including the novel Moby Dick, the emails of the Enron CEOs and the 2014 IEEE Vast Challenge articles.

9. **K-Nearest Neighbours**: The notebook details the steps to follow in a machine learning problem, prior to model training. These include feature scaling, data splitting and parameter tuning - performed by measuring the accuracy of a k-nearest neighbours model for different values of parameter k.

10. **Automated Machine Learning**: The notebook looks at predicting how likely a telecommunications customer is to churn based on behavior. The data and associated target is used throughout the notebook and is passed into the AutoML pipeline in both its default configuration and custom user-defined configuration, with the steps in the pipeline explained throughout.

11. **Clustering**: Examples of how to use the k-means, DBSCAN, affinity propagation, hierarchical and CURE algorithms available within the ML-Toolkit are provided. The notebook demonstrates how to effectively visualize results produced and make use of scoring functions contained within the toolkit. A real-world application is also included.