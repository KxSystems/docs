---
hero: <i class="fa fa-share-alt"></i> Machine learning / Jupyterq
keywords: display, inline, kdb+, learning, machine, notebook, python, q
---

# Python and inline display


!!! warning "Experimental" 

Along with k and q code, python code can be run in a q process using [embedPy](https://github.com/kxsystems/embedpy), lines preceded by `p)` will be executed as Python code.
Charts created using matplotlib will be displayed inline in the notebook. 

![matplotlib](img/matplotlib.gif "Matplotlib inline display")

Cells with `/%python` anywhere in the cell at the start of a line will be evaluated entirely as Python code.
This is intended only to make it easier to copy and paste Python snippets into kdb+ notebooks.
The language for syntax highlighting, code completion and help is still q.

![python](img/python.png "Python code")