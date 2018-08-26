## `rand` 

Syntax: `rand x`

Where `x` is 

- a positive numeric atom, returns a numeric atom in the range [0,x).
```q
q)rand 100
10
q)rand each 20#6  /roll twenty 6-sided dice
2 5 4 5 1 0 5 2 4 5 1 2 0 1 1 2 1 0 0 5
q)rand 3.14159
1.277572
q)rand 2012.09.12
2008.02.04
```

- a list, returns an item chosen randomly from `x`
```q
q)rand 1 30 45 32
32
```

!!! tip "First roll"
    `rand` is exactly equivalent to `{first 1?x}`. If you need a vector result, consider using _roll_ instead of `rand`. The following expressions all roll 100 six-sided dice.
    <pre><code class="language-q">
    rand each 100#6
    {first 1?x} each 6
    100?6
    </code></pre>


## `?` (roll)

Syntax: `x ? y`

_Roll_ returns a list of random selections. Where `x` is a positive int atom and 

- `y` is a numeric atom, returns `x` values randomly chosen from the range `til y`.
```q
q)20?5
4 3 3 4 1 2 2 0 1 3 1 4 0 2 2 1 4 4 2 4
q)5?4.5
3.13239 1.699364 2.898484 1.334554 3.085937 
q)4?2012.09m
2006.02 2007.07 2007.07 2008.06m
```

!!! tip "Short symbols"
    There is a shorthand special case for generating short symbols (length between 1 and 8) using the first 16 lower-case letters of the alphabet.

        q)10?`3
        `bon`dec`nei`jem`pgm`kei`lpn`bjh`flj`npo
        q)rand `6
        `nemoad

- `y` is a list, returns `x` items randomly chosen from `y`. 
```q
q)10?`Arthur`Steve`Dennis
`Arthur`Arthur`Steve`Dennis`Arthur`Arthur`Arthur`Dennis`Arthur`Dennis
q)2?("a";0101b;`abc;`the`quick;2012.06m)
`abc
2012.06m
```



## `?` (deal)

Syntax: `-x ? y`

_Deal_ returns random selections **without repetition**. Where `-x` is a _negative_ int atom, and

- `y` is an int atom such that `y>=x`, returns `x` integers chosen randomly and without repetition from the range `til y`.
```q
q)-20?100  /20 different integers from 0-99
2 40 66 52 86 45 94 84 38 26 33 23 78 49 51 59 44 37 48 53
q)-20?20.  /first 20 integers in random order
10 19 2 6 17 16 14 8 3 12 13 1 5 11 4 9 18 15 0 7
q)(asc -20?20)~asc -20?20
1b
```

!!! tip "GUIDs"
    To deal a list of distinct GUIDs, use the null GUID for `y`.
    <pre><code class="language-q">
    q)-1?0Ng 
    ,fd2db048-decb-0008-0176-01714e5eeced
    q)count distinct -1000?0Ng
    1000
    </code></pre>
    **Watch out** _Deal_ of GUID uses a mix of process ID, current time and IP address to generate the GUID, and successive calls may not allow enough time for the current time reading to change. 
    <pre><code class="language-q">
    q)count distinct {-1?0ng}each til 10
    5
    </code></pre>

- `y` is a list of unique values, and `x>=count y`, returns `x` items randomly chosen without repetition from `y`. 
```q
q)-3?`Arthur`Steve`Dennis
`Steve`Arthur`Dennis
q)-4?`Arthur`Steve`Dennis
'length
```



## Sowing the seed

_Deal_, `rand` and _roll_ use a constant seed on q invocation: scripts using them can be repeated with the same results. You can see and change the value of the seed by using system command ["\S"](syscmds/#s-random-seed).)

!!! warning
    To use GUIDs as identifiers, ensure `x` is negative. Otherwise, you will get duplicates, given the same seed:
    <pre><code class="language-q">
    $ q
    q)1?0Ng
    ,8c6b8b64-6815-6084-0a3e-178401251b68
    q)\\
    $ q
    q)1?0Ng
    ,8c6b8b64-6815-6084-0a3e-178401251b68
    </code></pre>

