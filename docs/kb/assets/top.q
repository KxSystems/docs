if[2=count .z.x;(`$"::",.z.x 0).z.i;system"l ",.z.x 1;exit 0]
if[1<>count .z.x;-2"usage: q ",string[.z.f]," script.q|pid";exit 1]

i:0p;T:([name:();file:();line:();col:();text:()]total:0#0;self:0#0)
pct:{.01*"j"$1e4*x};nm:{[n;f;l;c;t] -20 sublist$[""~n;$[""~f;t;f,":",string[l],":",string c];n]}
top:{x xdesc `total`self xcols 0!update total:pct total%sum self,pct self%sum self,name:nm'[name;file;line;col;text]from T}

.z.ts:{@[{t:``pos _ select from .Q.prf0 p where not .Q.fqk each file;
 T+:select total:1 by name,file,line,col,text from t;
 T[last[t]`name`file`line`col`text;`self]+:1;
 if[00:00:01<.z.p-i;i::.z.p;1"\033c";show top`self]};::;{system"t 0";'x}]}

$[null p:"I"$.z.x 0;[system"p 0W";.z.pg:{p::x;system"p 0";system"t 10"};system"q "," "sv string[(.z.f;"j"$system"p")],.z.x];system"t 10"]
