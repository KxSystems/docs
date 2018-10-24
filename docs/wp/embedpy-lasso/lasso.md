---
author: Samantha Gallagher
title: Machine learning – using embedPy to apply LASSO regression
date: October 2018
keywords: embedpy, house, jupyter, kdb+, lasso, learning, machine, notebook, price, python, q, regression
---

# Applying LASSO regression for analysing housing prices




This analysis uses LASSO regression to determine the prices of homes in
Ames, Iowa. The dataset used in this demonstration is the Ames Housing
Dataset, compiled by Dean De Cock for use in data-science education. It
contains 79 explanatory variables describing various aspects of
residential homes which influence their sale prices. 

<i class="far fa-hand-point-right"></i>
[kaggle.com](https://www.kaggle.com/c/house-prices-advanced-regression-techniques/data)

The Least Absolute Shrinkage and Selection Operator (LASSO) method was
used for the data analysis. LASSO is a method that improves the accuracy
and interpretability of multiple linear regression models by adapting
the model fitting process to use only a subset of _relevant_ features.

It performs L1 regularization, adding a penalty equal to the absolute
value of the magnitude of coefficients, which reduces the less-important
features’ coefficients to zero. This leaves only the most relevant
feature vectors to contribute to the target (sale price), which is
useful given the high dimensionality of this dataset.

A kdb+ Jupyter notebook on GitHub accompanies this paper.

<i class="fab fa-github"></i>
[kxcontrib/embedpy-lasso](https://github.com/kxcontrib/embedpy-lasso)


