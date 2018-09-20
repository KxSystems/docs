---
hero: <i class="fa fa-share-alt"></i> Machine learning / Jupyterq
keywords: argument, command, jupyter, kdb+, learning, line, notebook, python, q, server
---

# Server command-line arguments
 


When opening a notebook or running a console, Jupyter starts the kdb+ kernel. 
(You do not connect to an existing kdb+ process.) 
The kdb+ kernel is split into two processes: 

-   one handles all communication with the Jupyter front end (`jupyterq_kernel.q`)
-   another is where code is actually executed (`jupyterq_server.q`)

To set command-line arguments for these q processes, edit the Jupyter configuration file `kernel.json`. Here you can set arguments for either the kernel process or the server process. In practice you will likely only want to modify options for the server process as it is where all your code and data reside. The kernel process only manages communication with the Jupyter front end.

As an example, suppose you wanted to set the default timer interval to 1 second, and a workspace limit of 500 MB. You would change the `kernel.json` file from the default:

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
