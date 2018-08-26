/- Transitive Closure (to infinity) found using over (/) by ...
/-    (bridge/) mat
/- or, show stepwise results by using scan (\)...
/-    (bridge\) mat

\c 28 120

/- Create sample datasets
/- For 6 nodes
node6:`a`b`c`d`e`f
dist6:([]src:`a`a`a`b`b`b`b`d`d`e`e`f`f`f;
         dst:`b`d`c`a`d`e`f`a`e`d`f`b`c`e;
         dist:30 40 80 21 25 16 23 12 30 23 25 17 18 22)

/- And a check case for 5 nodes, but with long distances instead of float
node5:5#node6
dist5:update dist:`long$dist from delete from dist6 where (src=`f) or (dst=`f)

/- Now to load the sample data set and put in same form
\curl -s https://us-east.manta.joyent.com/edgemesh/public/net_dist -o dist
\l dist
node:asc distinct dist[`src],dist[`dst]

/- <cm> creates connectivity matrix from a list of nodes (n), distance table (d) and 'nopath' value
/- Result is a square matrix where a cell contains distance to travel between nodes (from row i to column j)
/- An unreachable node (nopath) is marked with the infinity value (0w for minimum path distance, or 0 for credit matrix).
cm:{[n;d;nopath]
  nn:count n;                         / number of nodes
  res:(2#nn)#(0 0w)`zero`inf?nopath;  / default whole matrix to nopath
  ip:flip n?/:d`src`dst;              / index pairs
  res:./[res;ip;:;`float$d`dist];     / set reachable index pairs
  ./[res;til[nn],'til[nn];:;0f]       / zero on diagonal to exclude a node with itself
  }

/- Table view of a connection matrix, using node`id for relevant sized connectivity matrix, or defaults.
tview:{[mat]
  $[(`$nodes:"node",string[count mat])in key `.;
    nodes:value nodes;
    nodes:`$string til count mat];
  ((1,1+count nodes)#`,nodes),((count[nodes],1)#nodes),'mat
  }

/- Matrix Multiply (MAXIMUM.MINIMUM) is used to traverse (or 'bridge') a 'hop' through counterparties
/- Note: | <> OR (as greater of APL ceiling)     & <> AND (lesserof or APL floor)
/- The beauty of the below is that:
/- If x is boolean, this returns the 'expanded' connections including the next hop
/- If x is integer, this returns the 'expanded' limits including the next hop (same solution !!)
/- Nice notational solution, less cluttered with nuances for tuning ...
bridge0:{x & (&/) each' x+/:\: flip x}
bridge1:{x & x(min@+)/:\: flip x}       /pierre
bridge2:{x & x((&/)@+)\: x}             /pierre

bridge:{x & x('[min;+])\: x}

bridgef:{x & x('[min;+])/:\: flip x}    / fastest

/- Parallel version (multithreaded run q -s 6)
bridgep: {x & {min each x +\: y}[flip x;] peach x}

/- .Q.fc version (fastest) with input from Jonny Press
bridgejp:{x & .Q.fc[{{{min x+y}[x] each y}[;y] each x}[;flip x];x]}

/ cumulative inner product -- generalised
cip:{[f;g;x] f[x;] x('[f/;g])\: x}
bridgeMS:cip[&;+;]  / Minimum.Sum (minimum path)
bridgeCM:cip[|;&;]  / Maximum.Minimum (credit matrix)
bridgeMM:cip[+;*;]  / Sum.Times (matrix multiplication)
