[from listbox](http://www.listbox.com/member/archive/1080/2007/10/sort/time_rev/page/1/entry/0:89/20071005195731:5FE568DA-739E-11DC-B011-44E0B46F41FF/)

Arguments to the functional form of exec (?\[;;;\]) must be passed in [parsed](Reference/parse "wikilink") form and, depending upon the desired results, in a particular data structure.

    q)\l sp.q
    q)exec qty from sp /list = ?[sp;();();`qty]
    300 200 400 200 100 100 300 400 200 200 300 400
    q)exec (qty;s) from sp /list per column = ?[sp;();();(enlist;`qty;`s)]
    300 200 400 200 100 100 300 400 200 200 300 400
    s1  s1  s1  s1  s4  s1  s2  s2  s3  s4  s4  s1
    q)exec qty, s from sp /dict by column name = ?[sp;();();`qty`s!`qty`s]
    qty| 300 200 400 200 100 100 300 400 200 200 300 400
    s  | s1  s1  s1  s1  s4  s1  s2  s2  s3  s4  s4  s1
    q)exec sum qty by s from sp /dict by key = ?[sp;();`s;(sum;`qty)]
    s1| 1600
    s2| 700
    s3| 200
    s4| 600
    q)exec q:sum qty by s from sp /xtab:list!table = ?[sp;();`s;(enlist `q)!enlist (sum;`qty)]
      | q
    --| ----
    s1| 1600
    s2| 700
    s3| 200
    s4| 600
    q)exec sum qty by s:s from sp /table!list = ?[sp;();(enlist `s)!enlist `s;(sum;`qty)]
    s |
    --| ----
    s1| 1600
    s2| 700
    s3| 200
    s4| 600
    q)exec qty, s by 0b from sp /table = ?[sp;();0b;`qty`s!`qty`s]
    qty s
    ------
    300 s1
    200 s1
    400 s1
    200 s1
    100 s4
    100 s1
    300 s2
    400 s2
    200 s3
    200 s4
    300 s4
    400 s1
    q)exec q:sum qty by s:s from sp /table!table = ?[sp;();(enlist `s)!enlist `s;(enlist `q)!enlist (sum;`qty)]
    s | q
    --| ----
    s1| 1600
    s2| 700
    s3| 200
    s4| 600

select is always 0b/dict, keyed select is always dict/dict (becomes the last two execs above)

Filters
-------

The filter condition can be functionally created by making a list of [parse trees](Reference/parse_tree "wikilink") for filter conditions. That is, if you have a query like

    select from sp where q > 0

The query would be represented as:

    ?[sp;enlist (>;`q;0);0b;()]

The conditions must be in a single list:

    ?[sp;((>;`q;0);(<;`q;1000));0b;()]

Literal Symbols
---------------

Special enlisting must be used when you want to use symbols as variables within the query

    ?[trade;enlist(in;`sym;enlist`AAPL`IBM);0b;()]

[Faster exec](http://www.kx.com/q/d/a/q.htm#Exec)

### See also

-   [triadic exec](Reference/QuestionSymbol#exec "wikilink")

