/
	Word wheel
	http://rosettacode.org/wiki/Word_wheel
\
ce:count each
lc:count each group@
dict:system"curl http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"
d39:{x where(ce x)within 3 9}{x where all each x in .Q.a}dict

grid:9?.Q.a

solve:{[grid;dict]
  i:where(grid 4)in'dict;
  dict i where all each 0<=(lc grid)-/:lc each dict i }[;d39]

bust:{[dict]
  grids:distinct raze(til 9)rotate\:/:dict where(ce dict)=9;
  wc:(count solve@)each grids;
  grids where wc=max wc }

best:{[dict]
  dlc:lc each dict;                             	     / letter counts of dictionary words
  ig:where(ce dict)=9;                                   / find grids (9-letter words)
  igw:where each(all'')0<=(dlc ig)-/:\:dlc;              / find words composable from each grid (length ig)
  / igw:where each(all'')0<={x-/:y}[;dlc] peach dlc ig;  / find words composable from each grid: d9xdict 
  grids:raze(til 9)rotate\:/:dict ig;                    / 9 permutations of each grid
  iaz:(.Q.a)!where each .Q.a in'\:dict;                  / find words containing a, b, c etc
  ml:4 rotate'dict ig;                                   / mid letters for each grid
  wc:ce raze igw inter/:'iaz ml;                         / word counts for grids
  distinct grids where wc=max wc }                       / grids with most words


