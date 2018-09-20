---
hero: <i class="fa fa-share-alt"></i> Machine learning / Jupyterq
keywords: jupyter, kdb+, learning, load, machine, notebook, python, q, save
---

# Loading and saving code


## Load

In addition to loading code with `\l` , code from a script _on the server_ can be loaded directly into a cell using a ‘magic’ command

```q
/%loadscript filename
```

This will not attempt to execute the code and any code in the rest of the cell will not execute.

![loading](img/loadscript.gif "Loading scripts inline")


## Save

```q
/%savescript filename [overwrite]
```

Will save contents of the cell as a script, optionally overwriting the script if it already exists

![saving](img/savescript.gif "Saving code as script")

