# Amend At


   @[d; i; f; y]
   @[d; i; :; y]
   @[d; i; f]
Description
Modify the items of the list d at indices i with f and, if present, the atom or list y, and similarly for the dictionary d at entries i.
Arguments
The first argument d is either a symbol atom, dictionary, or any list, and the second argument i is either nonnegative integer or symbolic. The third argument f is any monadic or dyadic function; the first of the above expressions corresponds to dy- adic f and the third to monadic f. The argument y, if present, is any atom or list for which i and y are conformable, and where items-at-depth in y corresponding to atoms in i must be valid right arguments of f.
Definition
If the first argument is a symbol atom then it must be a handle, and the definition proceeds as if the value of the global variable named in the symbol is used as the first argument (but see Handle in the chapter Terminology). In addition, the modi- fied value becomes the new value of the global variable, and the symbol is the result. The first argument is assumed to be a dictionary or list for the remainder of this definition.
K Reference Manual 47
48
The description that follows starts with the case of dyadic f. The second of the above expressions can be viewed as a special case of the first expression, where the dyadic function represented by the colon simply returns its right argument, i.e. {[x;y] y}. The purpose of the first expression is to modify items of d selected by i with values of f applied to those items as left argument and items-at-depth in y as right argument. The second expression simply replaces those items with items- at-depth in y. The third expression, where there is no y and f is monadic, replaces each of those items with the values of f applied to it.
In the case of a left argument list d, Amend Item permits modification of one or more items of that list by a function f and, when f is dyadic, items-at-depth in y. The result is a copy of d with those modifications. For example:
  d:9 8 7 6 5 4 3 2 1 0
  i:2 7 1 8 2 8
  y:5 3 6 2 7 4
  @[d; i; +; y]
9 14 19 6 5 4 3 5 7 0
This result is developed as follows. Starting at index 0 of i, item d[i[0]] is replaced with d[i[0]]+y[0], i.e. d[2] becomes 7+5, or 12. Then d[i[1]] is replaced with d[i[1]]+y[1], i.e. d[7] becomes 2+3, or 5. Continuing in this manner, d[1] becomes 8+6, or 14, d[8] becomes 1+2, or 3, d[2] be- comes 12+7, or 19 (modifying the previously modified value 12), and d[8] be- comes 3+4, or 7 (modifying the previously modified value 3).
In general, i can be any atom or list whose atoms are valid indices of d, i.e. from the list !#d, and i and y must be conformable. However, the function is not an atom function. Instead, the function proceeds recursively through i and y as if they were the arguments of a dyadic atom function, but whenever an atom of i is encountered, say k, the current value of d[k] is replaced by f[d[k];z], where z is the item- at-depth in y that was arrived at the same time as k. The result is the modified list. For example:
  d: 9 8 7
  i: (0; (1;2 2))
  y: ("abc"
      ((1.5; `xyz)
       (100; (3.76; `efgh))))
Before evaluating Amend Item for this data, compare the structures of i and y to see that the 0 in i goes with "abc" in y, the 1 in i goes with (1.5;`xyz) in y, the first 2 of 2 2 in i goes with 100 in y, and the second 2 of 2 2 in i goes with (3.76;`efgh) in y. Now:
  @[d; i; ,; y]
((9;"a";"b";"c")
 (8;1.5;`xyz)
 (7;100;3.76;`efgh))
f is Join
Join 9 and "abc"
Join 8 and (1.5;`xyz)
Join 7 and 100, then join with (3.76;`efgh)
The general case of @[d; i; f; y]
The general case of Amend Item for dyadic f can be defined recursively as follows,
based on the definition for an atom second argument:
    AmendItem:{[d;i;f;y] :[ @ i; @[d; i; f; y]
                        AmendItem/[d; i; f; y]]]}
Note the application of Over to AmendItem, which requires that whenever i is not an atom, either y is an atom or #i equals #y. Over is used to accumulate all changes in the first argument d.
The case of @[d; i; :; y]
The second case simply replaces the items of d with items-at-depth in y. In effect, the dyadic case for the function that simply returns its right argument as its result, i.e. {[x;y] y}. For example:
    d:9 8 7 6 5 4 3 2 1 0
    i:2 7 1 8 2 8
    y:50 30 60 20 70 40
    @[d;i;:;y]
  9 60 70 6 5 4 3 30 40 0
This result is developed as follows. Starting at index 0 of i, item d[i[0]] is replaced with y[0], i.e. d[2] becomes 50. Then d[i[1]] is replaced with y[1],i.e. d[7]becomes30.Continuinginthismanner,d[1]becomes60,d[8] becomes 20, d[2] becomes 70 (overwriting the previous change to 50), and d[8] becomes 40 (overwriting the previous change to 20).
K Reference Manual 4: Verbs 49
50
The case of @[d; i; f]
The third case of Amend Item, for a monad f, is similar to the case for dyadic f, but simpler. As the function proceeds recursively through i, whenever an atom of i is encountered, say k, the current value of d[k] is replaced by f[d[k]]. The re- sult is the modified list. As in the dyadic case, if an index k of d appears more than once in i, then d[k] will be modified more than once.
Facts About Amend Item
If an index of d appears more than once in i, then that item of d will be modified more than once. The above definition in terms of Over gives the correct order in which the replacements are made.
The function f is applied separately for each atom in i.
The cases of Amend Item with a function f are sometimes called Accumulate Item because the new items-at-depth are computed in terms of the old, as in @[x;2 6;+;1], where items 2 and 6 are incremented by 1.
Error Reports
Domain Error if the symbol d is not a handle, i.e. does not hold the name of an existing global variable.
Index Error if any atom of the right argument is not a valid index of the left argu- ment.
Length Error if the second argument i and the last argument y are not conformable. Rank Error if the object being modified is a non-dictionary atom.
Type Error if any atom of i is not an integer, symbol or nil.
