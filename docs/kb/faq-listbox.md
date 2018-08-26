# Frequently-asked questions from the k4 listbox

If you notice a question that is asked more then once on the list, please feel free to [add it here](https://github.com/kxsystems/docs).


## Where can I find archives of the k4 list?

Archives are available to subscribers at the [listbox](https://www.listbox.com/member/archive). When you follow that link, you will be asked for your e-mail address and the mailing list name. Use `k4` for the list name, and the e-mail address that you used to subscribe to the k4 list.


## How to post test data on the k4 list?

Always post your test data in the executable form. For example,
```q
q)foo:([]a:5?10;b:5?10;c:5?10)
```
You can generate an executable form of your data using `0N!`.
```q
q)0N!foo;
+`a`b`c!(4 3 7 1 1;6 1 7 9 8;4 7 5 0 9)
```
Note use of `;` to suppress the default display. If you use the latter form, prefix it with `k)` in your post, so that others could easily cut and paste it in their q session.
```q
q)k)+`a`b`c!(4 3 7 1 1;6 1 7 9 8;4 7 5 0 9)
a b c
-----
4 6 4
3 1 7
7 7 5
1 9 0
1 8 9
```


## What are the limits on the number of variables in q functions?

<table class="kx-tight">
<tr><td>params</td><td style="text-align: right">8</td></tr>
<tr><td>locals</td><td style="text-align: right">24</td></tr>
<tr><td>globals</td><td style="text-align: right">32</td></tr>
</table>

<i class="far fa-hand-point-right"></i> [Reference/Lambdas](/basics/syntax/#definition)


## What does `'error` mean?

<i class="far fa-hand-point-right"></i> [Reference/Errors](/basics/error-list)


## Why does `sg` work with `::` but not `:`? Also why does `{x.time}` not work?

Locals and globals are different: locals don’t have symbols associated with them, so for example `.Q.dpft` (you would have to pass in name of table) or `x.time` does not work with them. As a workaround for the second issue one can always use `` `time$x `` though.


## How do I query a column of strings for multiple values?

If you wish to query a column of strings for a single value either `like` or `~` (_match_) with an adverb can be used
```q
q)e:([]c:("ams";"lon";"amS";"bar")) 
q)select from e where ~\:"ams"
c
-----
"ams"
q)select from e where c like "ams"
c
-----
"ams"
q)select from e where c like "am*"
c
-----
"ams"
"amS"
```
To query for multiple strings you need to use another adverb, then aggregate the results into a single boolean value using `sum` or `any`. Generally the `like` form is easier to understand and more efficient.
```q
q)select from e where any c like/:("lon";"am*")
c
-----
"ams"
"lon"
"amS"
```


## How to kill long/invalid query on a server?

You can achieve that by sending SIGINT to the server process. In \*nix shell, try 
```bash
$ kill -INT <pid>
```
You can find the server process ID by examining `.z.i`.


## How do I recall and edit keyboard input?

Start q under `rlwrap` to get [readline](http://tiswww.case.edu/php/chet/readline/rltop.html) support, e.g.
```bash
$ rlwrap l64/q -p 5001
```
This is available in most Linux repositories, or from <i class="fab fa-linux"></i> [utopia.knoware.nl](http://utopia.knoware.nl/~hlub/rlwrap) or
<i class="fab fa-apple"></i> [darwinports.com](http://rlwrap.darwinports.com).

An alternative to `rlwrap` is tecla's [`enhance`](http://www.astro.caltech.edu/~mcs/tecla/enhance.html). This is good for vi-mode users who would like more of `vi`’s keys functionality – eg `d f x` will delete everything up to the next `x` and you can paste it back, too.  
