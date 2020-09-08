---
author: Conor McCarthy
title: Optimization functionality - Machine Learning – Machine Learning – kdb+ and q documentation
description: Functionality for the numerical optimization of user defined q functions.
date: September 2020
keywords: time-series, numerical optimization, quasi-Newton, nonlinear, kdb+, q
---
# <i class="fa fa-share-alt"></i> Numerical optimization


<pre markdown="1" class="language-txt">
.ml.optimize   **Optimization functions**
  [BFGS](#mloptimizebfgs)      The Broyden-Fletcher-Goldfarb-Shanno algorithm
</pre>

:fontawesome-brands-github:
[KxSystems/ml/optimize](https://github.com/kxsystems/ml/tree/master/optimize/)

The `.ml.optimize` namespace contains functions which relate to the application of numerical optimization techniques. Such techniques are used to find local or global minima of user provided objective functions and are central to many statistical models.

!!! Note
	Version 1.1.0 provides the initial versions of numerical optimization tools to the machine learning toolkit, the Broyden-Fletcher-Goldfarb-Shanno algorithm is provided initially due to its use in the generation of the SARIMA model provided with the toolkit. This functionality will be expanded on over time
    

## Broyden-Fletcher-Goldfarb-Shanno Algorithm

In numerical optimization, the Broyden-Fletcher-Goldfarb-Shanno(BFGS) algorithm is a quasi-Newton iterative method for solving unconstrained nonlinear optimization problems. This is a class of hill-climbing optimization technique which seeks to find a stationary, preferably twice differentiable solution to the objective function. An outline of the algorithm can be and the rationale behind its implementation can be found [here](https://en.wikipedia.org/wiki/Broyden-Fletcher-Goldfarb-Shanno_algorithm#Rationale).

### `.ml.optimize.BFGS`

_Optimize an objective function based on a provided intial guess using the BFGS algorithm_

Syntax: `.ml.optimize.BFGS[func;x0;args;params]`

Where

* `func` is a lambda/projection defining the objective function to be optimized. This function should take as input 1 or 2 items depending on if non changing additional arguments `args` are required.
* `x0` is a list of the initial guess for the numerical function arguments which are to be optimized
* `args` any additional non changing arguments required by the function, this can be a list or dictionary in the case that additional arguments are required or a `(::)`/`()` in the case they are not.
* `params` optional parameters which can be used to modify the behaviour of the algorithm as a dictionary. In the case that no modifications are to be made this should be `(::)`. The following keys outline all possible changes which can be made to the default system behaviour and the currently accepted default values

key          |  type   | default  | explanation
-------------|---------|----------|--------
`display`    | boolean |    0b    | are the results at each optimization iteration to be printed
`optimIter`  | integer |    0W    | maximum number of iterations before optimization procedure is terminated
`zoomIter`   | integer |    10    | maximum number of iterations when finding optimal zoom position
`wolfeIter`  | integer |    10    | maximum number of iterations when attempting to calculate strong Wolfe conditions
`norm`       | integer |    0W    | order of function used to calculate the gradient norm. This can be `0W = maximum value`, `-0W = minimum value` otherwise calculated via `sum[abs[vec]xexp norm]xexp 1%norm`
`gtol`       |  float  |   1e-5   | gradient norm must be less than this value before successful termination
`geps`       |  float  |  1.5e-8  | the absolute step size used for numerical approximation of the jacobian via forward differencing 
`stepSize`   |  float  |    0W    | the maximum allowable 'alpha' step size between calculations during the Wolfe condition search
`c1`         |  float  |   1e-4   | Armijo rule condition used in calculation of strong Wolfe conditions.
`c2`         |  float  |   0.9    | curvature rule condition used in calculation of the strong Wolfe condition search

returns a dictionary containing the following information

key       |  explanation
----------|-----------------------
`xVals`   | optimized parameters input for the functions based on initial `x0`
`funcRet` | return from the objective function at position `xVals`
`numIter` | number of iterations to reach the optimal values

The following examples outline the optimization algorithm in use across a number of functions and with various starting points in 1-D and 2-D space

**Example 1:**

1. Define a quadratic equation in to be minimized: $$f(x) = x**2 -4x$$
2. Test a starting point `x0 = 4`
3. Test a starting point `x0 = -4`
4. Plot results of both showing starting points and point of convergence

```q
// function definition
q)quadFunc:{xexp[x[0];2]-4*x[0]}
// define initial test starting condition for x0
q)xTest0:enlist 4
// apply the BFGS optimization algorithm
q).ml.optimize.BFGS[quadFunc;xTest0;();::]

```








