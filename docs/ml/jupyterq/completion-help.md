---
hero: <i class="fa fa-share-alt"></i> Machine learning / Jupyterq
keywords: code, completion, jupyter, kdb+, learning, machine, notebook, python, q
---

# Code completion and getting help



The notebook supports code completion of q keywords and anything in the `.h`, `.Q`, `.z` and `.j` directories of q. 

Completion also works on user-defined variables, provided they exist on the server. If you’ve defined variables in the _same_ cell they won’t exist yet in the server process before the cell is first executed, but notebooks will complete these for you locally.

Code completion in notebooks is accessed via the Tab key.


## Completion

![completion](img/completion.gif "Completion")


## Help

Help is available on q keywords and built in commands, embedPy and Python foreign objects, and user defined variables.
For user defined variables the console representation along with datatype information is displayed.

In notebooks help is accessed with Shift+Tab. This should pop up a window in the notebook. To see an HTML version of the help, with links to the online documentation for the function, press Shift+Tab four times in succession (or use the buttons in the Help window).

![help](img/help.gif "Code help")


