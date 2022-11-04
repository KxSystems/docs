/generate TXTs for code.kx.com/q/ref
t:flip`kwd`url`txt`cat`itn!("***SS";",")0:read0`:ref.csv
lk:{"[",(x`kwd),"](",(x`url)," \"",(x`txt),"\")"}  / link
update lnk:lk each t from `t
nr:ceiling count[t]%nc:10  / # rows, # cols
/ t,:(n-count t)#enlist("";`;"")where 3 2 1  / pad last column
/ `:ref0.txt 0:raze each flip(n cut t`lnk){x,y#"  "}''2+{(max each x)-x}(count'')n cut t`kwd
htc:{e:string x;$[count y;"<",e," markdown>",y,"</",e,">";"<",e,"/>"]}
`:kwds.txt 0:`tr htc'raze each flip nr cut `td htc'(t`lnk),((nr*nc)-count t)#enlist""
`:kwdcat.txt 0:{htc[`tr]raze`td htc'(string x`cat;", "sv x`lnk)}each 0!select lnk by cat from `t