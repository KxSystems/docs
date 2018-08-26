# Maps


> But, as the passage now presents no hindrance  
> To the spirit unappeased and peregrine  
> Between two worlds become much like each other  
> — _T.S. Eliot_, “Little Gidding”


Q uses square brackets both for indexing into lists and for applying functions. This is not an accident. 

A core insight, on which q is founded, is that _arrays are functions of their indexes_. This has deep implications, which we need to explore.

Consider the simple function `{x*x}`, which calculates the square of its argument.
```q
q)sqrs:{x*x}
q)sqrs[3 4]
9 16
```
Or we could use a vector of squares to look them up.
```q
q)sqrz:0 1 4 9 16 25 36 49
q)sqrz[3 4]
9 16
```
Over the domain of integers 0-7, `sqrs` and `sqrz` return exactly the same result. Function and array are both _maps_ – mappings from a domain to a range. The syntax reflects this. 

And just as a function can be applied by juxtaposition, so too can a list.
```q
q)sqrz 3 4
9 16
```
A dictionary is a map from its keys to its values.
```q
q)cities:`Birmingham`London`NewYork`Paris`Vienna!`UK`UK`USA`France`Austria
q)cities
Birmingham| UK
London    | UK
NewYork   | USA
Paris     | France
Vienna    | Austria
q)addr:`London`Paris`London`NewYork`Paris`Vienna`Birmingham
q)cities addr
`UK`France`UK`USA`France`Austria`UK
q)conts:`Austria`France`UK`USA!`Europe`Europe`Europe`NorthAmerica
q)conts cities addr
`Europe`Europe`Europe`NorthAmerica`Europe`Europe`Europe
```
The isomorphism extends to matrixes and binary functions.
```q
q)tt          / times table
0 0 0 0  0
0 1 2 3  4
0 2 4 6  8
0 3 6 9  12
0 4 8 12 16
q)tt[3;4]
12
q)*[3;4]
12
```
Over the domain of integers 0-4, `tt` and `*` return exactly the same result. 

Where all items of a matrix are conformable, it can be thought of as having three dimensions or axes – or as a rank-three map.
```q
q)m3
"aA" "aB" "aC" "aD" "aE"
"bA" "bB" "bC" "bD" "bE"
"cA" "cB" "cC" "cD" "cE"
"dA" "dB" "dC" "dD" "dE"
"eA" "eB" "eC" "eD" "eE"
q)m3[3;2;1]
"C"
```
We shall use the term _map_ to denote a function _or_ a list. 




## Exercises

==FIXME==