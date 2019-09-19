---
title: Demonstration notebooks for machine learning – Machine Learning – kdb+ and q documentation
description: EmbedPy and JupyterQ can be used to solve all kind of machine-learning problems, from feature engineering to the training and testing of models. They also allow users to display results in a range of ways, giving a better understanding of the data and results. The notebooks described here provide examples that bring together these concepts and show what can be achieved.
keywords: embedPy, Jupyter, ml, machine learning, notebook, Python
---
# <i class="fas fa-share-alt"></i> Demonstration notebooks for machine learning

EmbedPy and JupyterQ can be used to solve all kind of machine-learning problems, from feature engineering to the training and testing of models. They also allow users to display results in a range of ways, giving a better understanding of the data and results.


The notebooks at 
<i class="fab fa-github"></i> 
[KxSystems/mlnotebooks](https://github.com/KxSystems/mlnotebooks)
provide examples that bring together these concepts and show what can be achieved.


### Decision Trees

A decision tree is trained to detect if a patient has either a benign or malignant cancerous tumour. The performance of the model is measured by computing both a confusion matrix and ROC curve. The data for this notebook is sourced from the [Wisconsin breast cancer dataset](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic)).

### Random Forests

 Random-forest and XGBoost classifiers are trained to discern satisfied or unsatisfied bank customers within the [Santander Customer Satisfaction dataset](https://www.kaggle.com/c/santander-customer-satisfaction). Different parameters are tuned and tested and the classifier performance is evaluated using the ROC curve.

### Neural Networks 

A neural network is trained to identify handwritten digits from the [MNIST dataset](https://keras.io/datasets/). Once the neural network has been trained, the performance is measured on the test dataset, a variety of metrics are used to evaluate the performance of the model.

### Dimensionality Reduction

Principal Component Analysis (PCA) and t-distributed Stochastic Neighbor Embedding (t-SNE) are used to try and reduce the dimensionality of the original dataset. Several plots are also employed to visualize the obtained reduced features and infer whether differences between the distinct groups are present within this data.

### Feature Engineering

Examples of data preprocessing, such as feature scaling and one-hot categorical encoding, which can highly impact the performance of a model are demonstrated. The robustness of different scalers against KNN are demonstrated in the first part of the notebook while in a second part, the importance of one-hot encoding labels when training a neural network is shown.

### Feature Extraction and Selection

Three examples are provided explaining how to effectively use the FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm to extract features and determine how significant each feature is in predicting a target vector. A random-forest classifier is trained in the first and third examples, which a gradient boosting model is used in the second.

### 7. Cross Validation

A variety of cross-validation methods are used with a random forest classifer to see how results compare across the methods when classifying tumour prognosis within the [Wisconsin breast cancer dataset](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic)).

### Natural Language Processing

Parsing, clustering, sentiment analysis and outlier detection are demonstated on a range of corpora, including the novel [*Moby Dick*](https://www.gutenberg.org/files/2701/2701-h/2701-h.htm), the emails of the [Enron CEOs](https://www.cs.cmu.edu/~enron/), and the [2014 IEEE Vast Challenge articles](http://vacommunity.org/VAST+Challenge+2014%3A+Mini-Challenge+1#Available_Data).

### K Nearest Neighbours

The basic steps to follow in a standard machine-learning problem previous to final model training are performed: features are scaled, data is split into training and test datasets and parameter tuning is done by measuring accuracy of a K-Nearest Neighbours model for different values of parameter K.
