if[2=count .z.x;(`$"::",.z.x 0).z.i;system"l ",.z.x 1;exit 0]
if[1<>count .z.x;-2"usage: q ",string[.z.f]," script.q|pid";exit 1]

nm:{[n;f;l;c;t] -20 sublist$[""~n;$[""~f;t;f,":",string[l],":",string[c]];n]}

if[count key`:prof/;-2"'prof/ already exists";exit 1]

N:0;T:();.z.exit:wr:{`:prof/ upsert T}
.z.ts:{@[{`T upsert enlist flip update name:nm'[name;file;line;col;text]from select from .Q.prf0 p where not .Q.fqk each file;
 if[999<n:count T;N+:n;wr`;delete from`T;1"\r",string["v"$.z.p-i]," ",string[N]," samples"]};::;{exit 0}]}

go:{i::.z.p;system"t 10"}

$[null p:"I"$.z.x 0;[system"p 0W";.z.pg:{p::x;system"p 0";go`};system"q "," "sv string[(.z.f;"j"$system"p")],.z.x];go`]
