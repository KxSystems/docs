---
hero: <i class="fa fa-share-alt"></i> Machine learning / embedPy
keywords: code, kdb+, python, q
---

# Running Python code


## Run the examples

To run the following examples, load `p.q`.

```q
q)\l p.q
```


## Execute Python code

The interface allows execution of Python code directly in a q console or from a script. In both console and scripts, prefix Python code with `p)`.

```q
q)p)print(1+2)
3
```

Q scripts (but not the console) can load and execute multiline Python code. Prefix the first line of the code with `p)` and indent subsequent lines of Python code according to the usual Python indentation rules.

```bash
$ cat embedPytest.q
a:1                   / q code
p)def add1(arg1):     # Python code
    return arg1+1     # still Python code
```

In a q session

```q
q)\l embedPytest.q
q)p)print(add1(12))
13
```

Full scripts of Python code can be executed in q, using the `.p` file extension (not `.py`). The script is loaded as usual.

```bash
$ cat helloq.p 
print("Hello q!")
```

```q
q)\l helloq.p
Hello q!
```


## Evaluate Python code

To evaluate Python code (as a string) and return results to q, use `.p.qeval`.  
```q
q).p.qeval"1+2"
3
```

**Side effects** Python evaluation (unlike Python _execution_) does not allow side effects. Any attempt at variable assignment or class definition will signal an error. To execute a string performing side effects, use `.p.e`. A more detailed explanation of the difference between `eval` and `exec` in Python can be found on 
<i class="fab fa-stack-overflow"></i>
[StackOverflow](https://stackoverflow.com/questions/2220699/whats-the-difference-between-eval-exec-and-compile-in-python).


