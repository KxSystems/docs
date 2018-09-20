---
hero: <i class="fa fa-share-alt"></i> Machine learning / Jupyterq
keywords: error, jupyter, kdb+, learning, machine, notebook, parse, python, q
---

# Errors


Errors are displayed in red and fall into two classes.


## Parse errors

Parsing of the cell content is checked by the kernel before sending to the server for evaluation. The usual q parsing rules apply. Note that for foreign languages (lines preceded by `p)` for example) parsing is not checked.


## Evaluation errors

Runtime errors are reported from the server. One important thing to note is that as with q scripts, lines up to where the error occurred will have been executed.

```q
a:1
b:a+`
a:2
```

will result in `a` having a value of 1.


## Examples

![errors](img/errors.png "Errors")



