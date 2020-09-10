---
title: Pipeline | Machine Learning Toolkit | Documentation for kdb+ and q
author: Conor McCarthy
date: August 2020
keywords: machine learning, ml, pipeline, execution, optimization
---

# :fontawesome-solid-share-alt: Pipeline

## Outline

Following the generation of a graph as outlined [here](./graph.md), a user must convert this graph into an executable code structure, described in this library as a pipeline. For this library a pipeline can be validated, generated and executed as follows 

### Graph Validation

1. For a graph to be valid all inputs to a node must be connected to an output either sourced from a configuration node or another functional node in the graph.
2. The inputs to a node and the outputs to which they connect must have the same 'type' defined at the time the graph was created.

### Pipeline Structure

1. Once the graph has been validated, generate the optimal execution path for the graph. This path is created according to the following algorithm.
	1. Generate all paths required by each node to be executed.
	2. Retrieve the longest path for each node in the graph.
	3. Find all dependencies for each of the longest paths.
	4. Reverse the ordering of the longest paths to ensure they are in the correct execution order.
	5. Retrieve the optimal execution order of nodes defined by 'razing' the longest paths (longest first) together and taking the distinct elements.
2. Based on the graph structure generate a schema containing the following information
	1. Boolean highlighting if the node has been executed successfully.
	2. Any issues which arise in execution and what was the error.
	3. The outputs of individual nodes at intermediate steps in execution and following complete execution of the pipeline.
	4. The inputs required for the execution of a node in the order they are to be applied to the functionality contained within the node.
	5. The expected input and output types of a node.
	6. The function to be applied on the relevant datasets.
	7. The mapping required to correctly populate the inputs to a node with required outputs from another node.
	8. The expected ordering of inputs to the node to ensure that the variable ordering is correct on node execution.
3. Populate the pipeline schema with the node function, inputs, outputs and output mapping, with rows populated based on ordering retrieved from the generation of the optimal path.

### Pipeline Execution

1. Retrieve the first incomplete node within the pipeline.
2. Apply the required inputs to the node function, stop execution if this results in an error and highlight the error to the user.
3. Add the outputs from the current node execution to any rows that require this data for future executions.
4. Repeat steps 1 -> 3 stopping either on condition that all rows in the graph have been successfully executed or an error has arisen.


## Functionality

<pre markdown="1" class="language-txt">
Pipeline
  [.ml.createPipeline](#mlcreatepipeline)      Generate a pipeline from a graph
  [.ml.execPipeline](#mlexecpipeline)        Execute a valid pipeline
</pre>


### `.ml.createPipeline`

_Generate a execution pipeline based on a valid graph_

Syntax: `.ml.createPipeline[graph]`

Where:

* `graph` is a graph originally generated using `.ml.createGraph`, which has all relevant input edges connected validly.

returns an optimal execution pipeline with all required information to allow successful execution of the pipeline appropriately populated

```q
// Generate a simple valid graph
q)graph:.ml.createGraph[]

// Configuration containing x data
q)graph:.ml.addCfg[graph;`xData;enlist[`xData]!enlist desc 100?1f]

// Configuration containing y data
q)graph:.ml.addCfg[graph;`yData;enlist[`yData]!enlist asc 100?1f]

// Node to randomize y dataset
q)yRandInput:"!"
q)yRandOutput:"F"
q)yRandFunction:{yData:x`yData;neg[count yData]?yData}
q)yRandNode:`inputs`outputs`function!(yRandInput;yRandOutput;yRandFunction)
q)graph:.ml.addNode[graph;`yRand;yRandNode]

// Node to calculate correlation between two float vectors
q)corrInput:`xData`yData!"!F"
q)corrOutput:"f"
q)corrFunction:{x[`xData] cor y}
q)corrNode:`inputs`outputs`function!(corrInput;corrOutput;corrFunction)
q)graph:.ml.addNode[graph;`corr;corrNode]

// Connect edges together
q)graph:.ml.connectEdge[graph;`xData;`output;`corr;`xData]
q)graph:.ml.connectEdge[graph;`yData;`output;`yRand;`input]
q)graph:.ml.connectEdge[graph;`yRand;`output;`corr;`yData]

// Generate pipeline
q)show pipeline:.ml.createPipeline[graph]
nodeId| complete error function                                              ..
------| ---------------------------------------------------------------------..
yData | 0              @[;(,`yData)!,`s#0.00969842 0.01596794 0.02054163 0.02..
yRand | 0              ![,`output]@[enlist]{yData:x`yData;neg[count yData]?yD..
xData | 0              @[;(,`xData)!,0.9988041 0.9936284 0.9880844 0.9789487 ..
corr  | 0              ![,`output]@[enlist]{x[`xData] cor y}                 ..
```

### `.ml.execPipeline`

_Execute a generated pipeline_

Syntax: `.ml.execPipeline[pipeline]`

Where:

* `pipeline` is a pipeline created using the function [`.ml.createPipeline`](#mlcreatepipeline)

returns, on valid execution, the pipeline with each node executed and appropriate `outputs` populated allowing a user to retrieve relevant data from execution. In the case that an issue arises in execution highlight this to the user. 

!!!Note
	The below example uses the pipeline generated in the [`.ml.createPipeline`](#mlcreatepipeline) example above.

```q
// Valid pipeline execution
q)pipeline:.ml.execPipeline[pipeline]
Executing node: yData
Executing node: yRand
Executing node: xData
Executing node: corr

// Display the pipeline
q)show pipeline
nodeId| complete error function                                              ..
------| ---------------------------------------------------------------------..
yData | 1              @[;(,`yData)!,`s#0.00969842 0.01596794 0.02054163 0.02..
yRand | 1              ![,`output]@[enlist]{yData:x`yData;neg[count yData]?yD..
xData | 1              @[;(,`xData)!,0.9988041 0.9936284 0.9880844 0.9789487 ..
corr  | 1              ![,`output]@[enlist]{x[`xData] cor y}                 ..

// Retrieve the outputs of the pipeline
q)exec outputs from pipeline
(,`)!,::
(,`)!,::
(,`)!,::
``output!(::;0.225908)

// Invalid example modifying the corr node the produce improper execution
q)pipeline:.ml.execPipeline[invalidPipeline]
Executing node: yData
Executing node: yRand
Executing node: xData
Executing node: corr
Error: rank

// Display the pipeline
q)show pipeline
nodeId| complete error function                                              ..
------| ---------------------------------------------------------------------..
yData | 1              @[;(,`yData)!,`s#0.004194243 0.006855978 0.01139698 0...
yRand | 1              ![,`output]@[enlist]{yData:x`yData;neg[count yData]?yD..
xData | 1              @[;(,`xData)!,0.9847626 0.9823238 0.9796802 0.9788011 ..
corr  | 0        rank  ![,`output]@[enlist]{x[`xData] cor string y}          ..
```
