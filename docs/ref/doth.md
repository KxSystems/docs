---
title: The .h namespace
description: The .h namespace contains objects useful for marking up data for an HTTP response.
author: Stephen Taylor
keywords: html, kdb+, markup, q
---
# The .h namespace






The `.h` [namespace](../basics/namespaces.md) contains functions for converting files into various formats and for web-console display. 

!!! warning "Reserved"

    The `.h` namespace is reserved for use by Kx, as are all single-letter namespaces. 

    Consider all undocumented functions in the namespace as its private API – and do not use them. 


```txt
.h.br    linebreak                 .h.hu        URI escape
.h.c0    web color                 .h.hug       URI map
.h.c1    web color                 .h.hy        HTTP response
.h.cd    CSV from data             .h.HOME      webserver root
.h.code  code after Tab            .h.iso8601   ISO timestamp
.h.data                            .h.jx        table
.h.ed    Excel from data           .h.logo      Kx logo
.h.edsn  Excel from tables         .h.nbr       no break
.h.fram  frame                     .h.pre       pre
.h.ha    anchor                    .h.sa        style
.h.hb    anchor target             .h.sb        style
.h.hc    escape lt                 .h.sc        URI-safe
.h.he    HTTP 400                  .h.td        TSV
.h.hn    HTTP error                .h.text      paragraphs
.h.hp    HTTP response             .h.tx        filetypes
.h.hr    horizontal rule           .h.ty        MIME types
.h.ht    Marqdown to HTML          .h.uh        URI unescape
.h.hta   start tag                 .h.xd        XML
.h.htac  element                   .h.xmp       XMP
.h.htc   element                   .h.xs        XML escape
.h.html  document                  .h.xt        JSON
.h.http  hyperlinks
```




## `.h.br` (linebreak)

Syntax: `.h.br`

Returns the string `"<br>"`. 


## `.h.c0` (web color)

Syntax: `.h.c0`

Returns as a symbol a web color used by the web console.


## `.h.c1` (web color)

Syntax: `.h.c1`

Returns as a symbol a web color used by the web console.


## `.h.cd` (CSV from data)

Syntax: `.h.cd x`

CSV from data: where `x` is a table or a list of columns returns a matrix of comma-separated values.

```q
q).h.cd ([]a:1 2 3;b:`x`y`z)
"a,b"
"1,x"
"2,y"
"3,z"

q).h.cd (`a`b`c;1 2 3;"xyz")
"a,1,x"
"b,2,y"
"c,3,z"
```


## `.h.code` (code after Tab)

Syntax: `.h.code x`

Where `x` is a string with embedded Tab characters, returns the string with alternating segments marked up as 

-   plain text
-   `code` and `nobr`.

```q
q).h.code "foo\tbar"
"foo <code><nobr>bar</nobr></code>"
q).h.code "foo\tbar\tabc\tdef"
"foo <code><nobr>bar</nobr></code> abc <code><nobr>def</nobr></code>"
q).h.code "foo"
"foo"
```


<!-- 
## `.h.data`

==FIXME==
 -->


## `.h.ed` (Excel from data)

Syntax: `.h.ed x`

Where `x` is a table, returns as a list of strings the XML for an Excel workbook. 

```q
q).h.ed ([]a:1 2 3;b:`x`y`z)
"<?xml version=\"1.0\"?><?mso-application progid=\"Excel.Sheet\"?>"
"<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"u..
```


## `.h.edsn` (Excel from tables)

Syntax: `.h.edsn x!y`

Where 

-   `x` is a symbol vector
-   `y` is a conformable list of tables

returns as a list of strings an XML document describing an Excel spreadsheet.

```q
q)show t1:([]sym:`a`b`c`d`e`f;price:36.433 30.327 31.554 29.277 30.965 33.028)
sym price
----------
a   36.433
b   30.327
c   31.554
d   29.277
e   30.965
f   33.028
q)show t2:([]sym:`a`b`c`d`e`f;price:30.0 40.0 50.0 60.0 70.0 80.0)
sym price
---------
a   30
b   40
c   50
d   60
e   70
f   80
q).h.edsn `test1`test2!(t1;t2)
"<?xml version=\"1.0\"?><?mso-application progid=\"Excel.Sheet\"?>"
"<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:ss=\"..
q)`:/Users/sjt/tmp/excel.xls 0: .h.edsn `test1`test2!(t1;t2)
`:/Users/sjt/tmp/excel.xls
```

![excel.xls](../img/h.edsn.png "Excel spreadsheet")



## `.h.fram` (frame)

Syntax: `.h.fram[x;y;z]`

Creates an HTML page with two frames. Takes three string arguments: the title; the location of the left frame; the location of the right frame.


## `.h.ha` (anchor)

Syntax: `.h.ha[x;y]`

Where `x` is the `href` attribute as a symbol atom or a string, and `y` is the link text as a string, returns as a string an HTML `A` element.

```q
q).h.ha[`http://www.example.com;"Example.com Main Page"]
"<a href=http://www.example.com>Example.com Main Page</a>"
q).h.ha["http://www.example.com";"Example.com Main Page"]
"<a href=\"http://www.example.com\">Example.com Main Page</a>"
```


## `.h.hb` (anchor target)

Syntax: `.h.hb[x;y]`

Same as `.h.ha`, but adds a `target=v` attribute to the tag.

```q
q).h.hb["http://www.example.com";"Example.com Main Page"]
"<a target=v href=\"http://www.example.com\">Example.com Main Page</a>"
```


## `.h.hc` (escape lt)

Syntax: `.h.hc x`

Where `x` is a string, returns `x` with any `<` chars escaped.

```q
q).h.hc "<foo>"
"&lt;foo>"
```


## `.h.he` (HTTP 400)

Syntax: `.h.he x`

Where `x` is a string, escapes `"<"` characters, adds a `"'"` at the front, and returns an HTTP 400 error (Bad Request) with that content.

```q
q).h.he "<rubbish>"
"HTTP/1.1 400 Bad Request\r\nContent-Type: text/plain\r\nConnection: close\r\..
```


## `.h.hn` (HTTP error)

Syntax: `.h.hn[x;y;z]`

Where 

-   `x` is the [type of error](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) (string) 
-   `y` is the [content type](#hty-mime-types) (symbol) 
-   `z` is the error message (string) 

returns as a string an HTTP error response.

```q
q).h.hn["404";`txt;"Not found: favicon.ico"]
"HTTP/1.1 404\r\nContent-Type: text/plain\r\nConnection: close\r\nContent-Len..
```
<i class="far fa-hand-point-right"></i> [Content types](#hty-mime-types)


## `.h.hp` (HTTP response)

Syntax: `.h.hp x`

Where `x` is a list of strings, returns as a string a valid HTTP response displaying them.

```q
q).h.hp("foo";"bar")
"HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nConnection: close\r\nContent-L..
```


## `.h.hr` (horizontal rule)

Syntax: `.h.hr x`

Where `x` is a string, returns a string of the same length filled with `"-"`.
```q
q).h.hr "foo"
"---"
```


## `.h.ht` (Marqdown to HTML)

Syntax: `.h.ht x`

HTML documentation generator: <!-- for <http://kx.com/q/d/> --> 
where `x` is a symbol atom, reads file `:src/x.txt` and writes file `:x.htm`.
(Marqdown is a rudimentary form of Markdown.)

- edit `src/mydoc.txt`
- ``q).h.ht`mydoc``
- browse `mydoc.htm` (`a/_mydoc.htm` is navigation frame, `a/mydoc.htm` is content frame)

Basic Marqdown formatting rules:

- Paragraph text starts at the beginning of the line.
- Lines beginning with `"."` are treated as section headings.
- Lines beginning with `"\t"` get wrapped in `code` tags
- Line data beginning with `" "` get wrapped in `xmp` tags
- If second line of data starts with `"-"`, draw a horizontal rule to format the header
- Aligns two-column data if 2nd column starts with `"\t "`


## `.h.hta` (start tag)

Syntax: `.h.hta[x;y]`

Where `x` is the element as a symbol atom, and `y` is a dictionary of attributes and values, returns as a string an opening HTML tag for element `x`. 

```q
q).h.hta[`a;(`href`target)!("http://www.example.com";"_blank")]
"<a href=\"http://www.example.com\" target=\"_blank\">"
```


## `.h.htac` (element)

Syntax: `.h.htac[x;y;z]`

Where `x` is the element as a symbol atom, `y` is a dictionary of attributes and their values, and `z` is the content of the node as a string, returns as a string the HTML element. 

```q
q).h.htac[`a;(`href`target)!("http://www.example.com";"_blank");"Example.com Main Page"]
"<a href=\"http://www.example.com\" target=\"_blank\">Example.com Main Page</..
```


## `.h.htc` (element)

Syntax: `.h.htc[x;y]`

Where `x` is the HTML element as a symbol atom, and `y` is the content of the node as a string, returns as a string the HTML node. 

```q
q).h.htc[`tag;"value"]
"<tag>value</tag>"
```


## `.h.html` (document)

Syntax: `.h.html x`

Where `x` is the body of an HTML document as a string, returns as a string an HTML document with fixed style rules. 

```html
<html>
  <head>
    <style>
      a{text-decoration:none}a:link{color:024C7E}a:visited{color:024C7E}a:active{color:958600}body{font:10pt verdana;text-align:justify}
    </style>
   </head>
   <body>
     BODY
   </body>
</html>
```

```q
q).h.html "<p>Hello world!</p>"
"<html><head><style>a{text-decoration:none}a:link{color:024C7E}a:visited{colo..
```


## `.h.http` (hyperlinks)

Syntax: `.h.http x`

Where `x` is a string, returns `x` with embedded URLs beginning `"http://"` converted to HTML hyperlinks.

```q
q).h.http "The main page is http://www.example.com"
"The main page is <a href=\"http://www.example.com\">http://www.example.com</..
```


## `.h.hu` (URI escape)

Syntax: `.h.hu x`

Where `x` is a string, returns `x` with URI-unsafe characters replaced with safe equivalents.

```q
q).h.hu "http://www.kx.com"
"http%3a%2f%2fwww.kx.com"
```


## `.h.hug` (URI map)

Syntax: `.h.hug x`

Where `x` is a char vector, returns a mapping from characters to `%`*xx* escape sequences *except* for the chars in `x`, which get mapped to themselves. 


## `.h.hy` (HTTP response)

Syntax: `.h.hy[x;y]`

Where `x` is a symbol atom and `y` is a string, returns as a string `y` as an HTTP response for content-type `x`.

```q
q)show t:([]idx: 1 2 3 4 5;val: `a`b`c`d`e)
idx val
-------
1   a
2   b
3   c
4   d
5   e
q)show r: .h.hy[`json] .j.j 0! select count i by val from t
"HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nConnection: close\r\nCo..
q)`:test.txt 0: enlist r
`:test.txt
q)\head test.txt
"HTTP/1.1 200 OK"
"Content-Type: application/json"
"Connection: close"
"Content-Length: 99"
""
"[{\"val\":\"a\",\"x\":1},"
" {\"val\":\"b\",\"x\":1},"
" {\"val\":\"c\",\"x\":1},"
" {\"val\":\"d\",\"x\":1},"
" {\"val\":\"e\",\"x\":1}]"
```


## `.h.HOME` (webserver root)

Syntax: `.h.HOME`

String: location of the webserver root. 

<i class="far fa-hand-point-right"></i>
[Customizing the default webserver](../kb/custom-web.md)


## `.h.iso8601` (ISO timestamp)

Syntax: `.h.iso8601 x`

Where `x` is nanoseconds since 2000.01.01 as an int atom, returns as a string a timestamp in ISO-8601 format.

```q
q).h.iso8601 100
"2000-01-01T00:00:00.000000100"
```


## `.h.jx` (table)

Syntax: `.h.jx[x;y]`

Where `x` is an int atom, and `y` is the name of a table, returns a list of strings representing the records of `y`, starting from row `x`.

```q
q)a:([] a:100*til 1000;b:1000?1000;c:1000?1000)
q){(where x="<")_x}first .h.jx[0;`a]
"<a href=\"?[0\">home"
"</a> "
"<a href=\"?[0\">up"
"</a> "
"<a href=\"?[32\">down"
"</a> "
"<a href=\"?[968\">end"
"</a> 1000[0]"
q)1_.h.jx[5;`a]
""
"a    b   c  "
"------------"
"500  904 34 "
"600  251 912"
"700  584 388"
"800  810 873"
"900  729 430"
"1000 210 148"
"1100 645 499"
"1200 898 285"
"1300 20  279"
"1400 686 267"
"1500 894 668"
"1600 879 611"
"1700 350 352"
"1800 254 600"
"1900 145 257"
"2000 666 101"
"2100 757 132"
"2200 601 910"
"2300 794 637"
..
```


## `.h.logo` (Kx logo)

Syntax: `.h.logo`

Returns as a string the kx.com logo in HTML format.


## `.h.nbr` (no break)

Syntax: `.h.nbr x`

Where `x` is a string, returns `x` as the content of a `nobr` element.

```q
q).h.nbr "foo bar"
"<nobr>foo bar</nobr>"
```


## `.h.pre` (pre)

Syntax: `.h.pre x`

Where `x` is a list of strings, returns `x` as a string with embedded newlines with a `pre` HTML element.

```q
q).h.pre("foo";"bar")
"<pre>foo\nbar\n</pre>"
```


## `.h.sa` (style)

Syntax: `.h.sa`

Returns CSS style rules used in the web console.

```q
q).h.sa
"a{text-decoration:none}a:link{color:024C7E}a:visited{color:024C7E}a:active{c..
```


## `.h.sb` (style)

Syntax: `.h.sb`

Returns CSS style rules used in the web console.
```q
q).h.sb
"body{font:10pt verdana;text-align:justify}"
```


## `.h.sc` (URI-safe)

Syntax: `.h.sc`

Returns as a char vector a list of characters that do not need to be escaped in URIs.  

```q
q).h.sc
"$-.+!*'(),abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"
```

<i class="fa-hand-point-right"></i> [`.h.hu`](#hhu-uri-escape)


## `.h.td` (TSV)

Syntax: `.h.td x`

Where `x` is a table, returns it as a list of tab-separated value strings 

```q
q).h.td ([]a:1 2 3;b:`x`y`z)
"a\tb"
"1\tx"
"2\ty"
"3\tz"
```


## `.h.text` (paragraphs)

Syntax: `.h.text x`

Where `x` is a list of strings, returns as a string, `x` with each item as the content of a `p` element. 

```q
q).h.text("foo";"bar")
"<p>foo</p>\n<p>bar</p>\n"
```


## `.h.tx` (filetypes)

Syntax: `.h.tx`

Returns a dictionary of file types and corresponding conversion functions (`.h.cd`, `.h.td`, `.h.xd`, `.h.ed`).

```q
q).h.tx
raw | ,:
json| k){$[10=abs t:@x;s@,/{$[x in r:"\t\n\r\"\\";"\\","tnr\"\\"r?x;x]}'x;(::..
csv | k){.q.csv 0:x}
txt | k){"\t"0:x}
xml | k){g:{(#*y)#'(,,"<",x),y,,,"</",x:($x),">"};(,"<R>"),(,/'+g[`r]@,/(!x)g..
xls | k){ex eb es[`Sheet1]x}
```

!!! tip "Streaming and static JSON"

    The result of ``.h.tx[`json]`` is designed for streaming as [JSON Lines](http://jsonlines.org/). For static JSON, enlist its argument:

    <pre><code class="language-q">
    q).h.tx[`json] ([] 0 1)  / JSON Lines
    "{\"x\":0}"
    "{\"x\":1}"
    q).h.tx[`json] enlist ([] 0 1) / static JSON
    "[{\"x\":0},\n {\"x\":1}]"
    q)show t:flip`items`sales`prices!(`nut`bolt`cam`cog;6 8 0 3;10 20 15 20)
    items sales prices
    ------------------
    nut   6     10
    bolt  8     20
    cam   0     15
    cog   3     20
    q).h.tx[`json] t  / JSON Lines
    "{\"items\":\"nut\",\"sales\":6,\"prices\":10}"
    "{\"items\":\"bolt\",\"sales\":8,\"prices\":20}"
    "{\"items\":\"cam\",\"sales\":0,\"prices\":15}"
    "{\"items\":\"cog\",\"sales\":3,\"prices\":20}"
    q).h.tx[`json] enlist t // static JSON
    "[{\"items\":\"nut\",\"sales\":6,\"prices\":10},\n {\"items\":\"bolt\",\"sale..
    </code></pre>


## `.h.ty` (MIME types)

Syntax: `.h.ty`

Returns a dictionary of content types (e.g. `` `csv``, `` `bmp``, `` `doc``) and corresponding [Media Types](https://en.wikipedia.org/wiki/MIME).

```q
q).h.ty
htm | "text/html"
html| "text/html"
csv | "text/comma-separated-values"
txt | "text/plain"
xml | "text/plain"
xls | "application/msexcel"
gif | "image/gif"
..
```


## `.h.uh` (URI unescape)

Syntax: `.h.uh x`

Where `x` is a string, returns `x` with `%`*xx* hex sequences replaced with character equivalents.

```q
q).h.uh "http%3a%2f%2fwww.kx.com"
"http://www.kx.com"
```


## `.h.xd` (XML)

Syntax: `.h.xd x`

Where `x` is a table, returns as a list of strings, `x` as an XML table. 

```q
q).h.xd ([]a:1 2 3;b:`x`y`z)
"<R>"
"<r><a>1</a><b>x</b></r>"
"<r><a>2</a><b>y</b></r>"
"<r><a>3</a><b>z</b></r>"
"</R>"
```


## `.h.xmp` (XMP)

Syntax: `.h.xmp x`

Where `x` is a list of strings, returns as a string `x` as the newline-separated content of an HTML `xmp` element.

```q
q).h.xmp("foo";"bar")
"<xmp>foo\nbar\n</xmp>"
```


## `.h.xs` (XML escape)

Syntax: `.h.xs x`

Where `x` is a string, returns `x` with characters XML-escaped where necessary. 

```q
q).h.xs "Arthur & Co."
"Arthur &amp; Co."
```


## `.h.xt` (JSON)

Syntax: `.h.xt[x;y]`

Where `x` is `` `json`` and `y` is a list of JSON strings, returns `y` as a list of dictionaries.

```q
q).h.xt[`json;("{\"foo\":\"bar\"}";"{\"this\":\"that\"}")]
(,`foo)!,"bar"
(,`this)!,"that"
q)first .h.xt[`json;("{\"foo\":\"bar\"}";"{\"this\":\"that\"}")]
foo| "bar"
```

