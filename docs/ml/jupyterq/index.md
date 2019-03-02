---
keywords: anaconda, jupyter, kdb+, kernel, notebook, python, q
---

# ![Jupyter](/interfaces/img/jupyter.png) JupyterQ

<div class="fusion" markdown="1">
<i class="fa fa-superpowers"></i> [Fusion for kdb+](/interfaces/fusion)
</div>


Jupyter kernel for kdb+. 

-   Syntax highlighting for q
-   Code completion for q keywords, `.z`, `.h`, `.Q`, `.j` namespace functions, and user-defined variables
-   Code help for q keywords and basic help (display and type information) for user-defined objects
-   Script-like execution of code (multiline input)
-   Inline display of charts created using embedPy and matplotlib
-   Console stdout/stderr capture and display in notebooks
-   Inline loading and saving of scripts into and from notebook cells


## Requirements 

-   kdb+ ≥ v3.5 64-bit
-   Anaconda Python 3.x
-   [embedPy](https://github.com/KxSystems/embedPy)


## Build and install

<i class="fa fa-download"></i> Download the code from <i class="fa fa-github"></i> [KxSystems/JupyterQ](https://github.com/kxsystems/jupyterq) and follow the instructions there.


## Using notebooks

See the notebook `kdb+Notebooks.ipynb` for full interactive examples and explanation, also [viewable on GitHub](https://github.com/KxSystems/jupyterq/blob/master/kdb%2BNotebooks.ipynb).


## Running code

The simplest case is running some code and getting a result. Note here:

-   Each line of code which would produce output at a console produces output in the notebook.
-   stderr/stdout are printed separately to the output in the usual way for notebooks. Note that if your print statement, such as `-1"hello world!"`, has an output (here `-1`) then the output will be displayed. You can suppress this with a semicolon at the end of a statement as usual.
-   Execution is script-like, i.e. you can use the normal rules of indentation for functions, if/while blocks, and select/update/delete statements.

![runningcode](img/running_code.png "Running code")


### System commands

System commands can be used with the `\` escape character at the start of a line in a code cell.

!!! warning "`\d` does not currently work."# Code completion and getting help

The notebook supports code completion of q keywords and anything in the `.h`, `.Q`, `.z` and `.j` directories of q. 

Completion also works on user-defined variables, provided they exist on the server. If you’ve defined variables in the _same_ cell they won’t exist yet in the server process before the cell is first executed, but notebooks will complete these for you locally.

Code completion in notebooks is accessed via the Tab key.


### Completion

![completion](img/completion.gif "Completion")


### Help

Help is available on q keywords and built in commands, embedPy and Python foreign objects, and user defined variables.
For user defined variables the console representation along with datatype information is displayed.

In notebooks help is accessed with Shift+Tab. This should pop up a window in the notebook. To see an HTML version of the help, with links to the online documentation for the function, press Shift+Tab four times in succession (or use the buttons in the Help window).

![help](img/help.gif "Code help")


## Errors

Errors are displayed in red and fall into two classes.


### Parse errors

Parsing of the cell content is checked by the kernel before sending to the server for evaluation. The usual q parsing rules apply. Note that for foreign languages (lines preceded by `p)` for example) parsing is not checked.


### Evaluation errors

Runtime errors are reported from the server. One important thing to note is that as with q scripts, lines up to where the error occurred will have been executed.
```q
a:1
b:a+`
a:2
```
will result in `a` having a value of 1.


### Examples

![errors](img/errors.png "Errors")



## Loading and saving code


### Load

In addition to loading code with `\l` , code from a script _on the server_ can be loaded directly into a cell using a ‘magic’ command
```q
/%loadscript filename
```
This will not attempt to execute the code and any code in the rest of the cell will not execute.

![loading](img/loadscript.gif "Loading scripts inline")


### Save

```q
/%savescript filename [overwrite]
```
Will save contents of the cell as a script, optionally overwriting the script if it already exists

![saving](img/savescript.gif "Saving code as script")


## Python and inline display

!!! warning "Experimental" 

Along with k and q code, python code can be run in a q process using [embedPy](https://github.com/kxsystems/embedpy), lines preceded by `p)` will be executed as Python code.
Charts created using matplotlib will be displayed inline in the notebook. 

![matplotlib](img/matplotlib.gif "Matplotlib inline display")

Cells with `/%python` anywhere in the cell at the start of a line will be evaluated entirely as Python code.
This is intended only to make it easier to copy and paste Python snippets into kdb+ notebooks.
The language for syntax highlighting, code completion and help is still q.

![python](img/python.png "Python code")


## Server command-line arguments

When opening a notebook or running a console, Jupyter starts the kdb+ kernel. 
(You do not connect to an existing kdb+ process.) 
The kdb+ kernel is split into two processes: 

-   one handles all communication with the Jupyter front end (`jupyterq_kernel.q`)
-   another is where code is actually executed (`jupyterq_server.q`)

To set command-line arguments for these q processes, edit the Jupyter configuration file `kernel.json`. Here you can set arguments for either the kernel process or the server process. In practice you will likely only want to modify options for the server process as it is where all your code and data reside. The kernel process only manages communication with the Jupyter front end. 

!!! note "Restrict connections using passwords"

    The command-line argument `-u` is not supported but `-U` is. See next section for how to restrict the access to the notebooks to authorised users.


Suppose you wanted to set the default timer interval to 1 second, and a workspace limit of 500 MB. You would change the `kernel.json` file from the default:

```json
{
 "argv": [
  "q",
  "jupyterq_kernel.q",
  "-cds",
  "{connection_file}"
 ],
 "display_name": "Q 3.5",
 "language": "q",
 "env": {"JUPYTERQ_SERVERARGS":""}
}
```

To this:

```json
{
 "argv": [
  "q",
  "jupyterq_kernel.q",
  "-cds",
  "{connection_file}"
 ],
 "display_name": "Q 3.5",
 "language": "q",
 "env": {"JUPYTERQ_SERVERARGS":"-t 1000 -w 500"}
}
```

To locate the config file after install run:

```bash
jupyter kernelspec list
```

The `kernel.json` file is located in the directory listed for the `qpk` kernel.


## Restrict access to a notebook using passwords

To open a port for the server or kernel process with user authentication enabled, specify `-U` (not `-u`) in command-line options for the server and kernel. You need to provide a valid username and password to allow connections to the kernel and server, in an environment variable `JUPYTERQ_LOGIN` e.g. `kernel.json` might look like this:

```json
{
 "argv": [
  "q",
  "jupyterq_kernel.q",
  "-U",
  "kernuser.txt",
  "-cds",
  "{connection_file}"
 ],
 "display_name": "Q (kdb+)",
 "language": "q",
 "env": {"JUPYTERQ_SERVERARGS":"-U servuser.txt","MPLBACKEND":"Agg"}
}
```

You can then use separate password files for the kernel and server, but `JUPYTERQ_LOGIN` must contain a username password combination valid for both processes.

```txt
$ cat servuser.txt # password stored hashed
user1:5f4dcc3b5aa765d61d8327deb882cf99
user2:5f4dcc3b5aa765d61d8327deb882cf99
$ cat kernuser.txt # passwords can also be stored in plaintext
user1:password
$ export JUPYTERQ_LOGIN=user1:password
#should work
$ jupyter-console --kernel=qpk
…
Jupyter console 5.1.0

KDB+ v3.6 2018.06.01 kdb+ kernel for jupyter, jupyterQ vdevelopment
In [1]: 

…
#shouldn't work as login not valid for both kernel and server 
$ JUPYTERQ_LOGIN=user2:password jupyter-console --kernel=qpk processes
*******************************************
** Wrong user:password in JUPYTERQ_LOGIN **
*******************************************
Press Ctrl+C
```


### Opening a connection

Set the listening port before opening a connection with another process (as it is set to 0 for both kernel and server processes when JupyterQ is initialized), e.g. `\p 1234`

```bash
$ jupyter-console --kernel=qpk
…
Jupyter console 5.1.0

KDB+ v3.6 2018.06.01 kdb+ kernel for jupyter, jupyterQ vdevelopment
In [1]: \p 
Out[1]:
0i

In [2]: \p 1234

…
```


## Frequently-asked questions


### Can I run the kernel remotely?

Yes, see the [Jupyter documentation](http://jupyter-notebook.readthedocs.io/en/stable/public_server.html). To set up a notebook server for multiple users Jupyter recommends [JupyterHub](http://jupyterhub.readthedocs.io/en/latest/index.html)


#### Additional setup for JupyterQ under JupyterHub

If you see this error when running the Jupyter console on the server you’re installing on:

```txt
You may need to set LD_LIBRARY_PATH/DYLD_LIBRARY_PATH to your 
python distribution's library directory: $HOME/anaconda3/lib
```

You will need to export the `LD_LIBRARY_PATH` and add this to your configuration file for JupyterHub 

```python
c.Spawner.env_keep.append('LD_LIBRARY_PATH')
```

### Why is setting `LD_LIBRARY_PATH/DYLD_LIBRARY_PATH` required with Anaconda python?

Anaconda packages libraries which may conflict with the system versions of these libraries loaded by q at startup e.g. `libssl` or `libz`. There is a `conda` packaged version of `q` which doesn't require setting `LD_LIBRARY_PATH`, if you are already using Anaconda then you can install it with

```bash
conda install -c kx kdb
```

### How can I save the contents of a notebook to a q script?

To dump the entire contents of the code cells in a notebook to a q script use
_File > Download as > Q (.q)_.

![save q script](img/save_qscript.png)
 
To save the contents of individual cells as q scripts use `/%savescript` in a cell.

<i class="fa fa-hand-o-right"></i> 
[Loading and saving scripts](#loading-and-saving-code)


### Can I mix Python and q code in the same notebook? 

Yes, either with `p)` or `/%python`.

<i class="fa fa-hand-o-right"></i> 
[Examples](#python-and-inline-display)


### Is there a Docker image available?

Yes, if you have [Docker](https://www.docker.com/community-edition) installed, you can run:

```bash
docker run -it --rm -p 8888:8888 kxsys/jupyterq
```

Further instructions for running headless and building the image are [available](https://github.com/KxSystems/jupyterq/blob/master/README.md#docker)

!!! note "Always Linux"

    Even if you are running Docker on macOS or Windows the version of kdb+ is 64-bit Linux, and the Docker image is Linux.


### Can I restrict the access to my notebook using passwords?
 
Yes, you can initialise a notebook which requires other processes to provide a valid *username:password* pair when trying to open a connection with the notebook. 

<i class="fa fa-hand-o-right"></i> 
[Restrict access](#restrict-access-to-a-notebook-using-passwords)
