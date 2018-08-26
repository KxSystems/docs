Atoms
All data are atoms and lists composed ultimately of atoms. See Nouns in the chap- ter Syntax.
Atom Functions
There are several recursively-defined primitive functions, which for at least one argument apply to lists by working their way down to items of some depth, or all the way down to atoms. The ones where the recursion goes all the way down to atoms are called atom functions, or atomic functions .
A monad is said to be atomic if it applies to both atoms and lists, and in the case of a list, applies independently to every atom in the list. For example, the monad Negate, which is monadic - , is atomic. A result of Negate is just like its argument, except that each atom in an argument is replaced by its negation. For example:
- 3 4 5 -(5 2; 3; -8 0 2) -3 -4 -5 (-5 -2
-3
8 0 -2)
Negate applies to a list by applying independently to every item. Accessing the ith item of a list x is denoted by x[i] , and therefore the rule for how Negate applies to a list x is that the ith item of Negate x , which is (-x)[i] , is Negate applied to the ith item, that is -x[i] .
K Reference Manual 29
30
Negate can be defined recursively for lists in terms of its definition for atoms. To do so we need two language constructs. First, any function f can be applied inde- pendently to the items of a list by modifying the function with the Each adverb, as in f' . Secondly, the monadic primitive function denoted by @x is called Atom and has the value 1 when x is an atom, and 0 when x is a list. Using these con- structs, Negate can be defined as follows:
  Negate:{:[ @ x; - x; Negate' x]}
That is, if x is an atom then Negate x is -x, and otherwise Negate is applied independently to every item of the list x. One can see from this definition that Negate and Negate' are identical. In general, this is the definition of atomic: a function f of any number of arguments is atomic if f is identical to f' .
A dyad f is atomic if the following rules apply (these follow from the general defi- nition that was given just above, or can be taken on their own merit):
• f[x;y] is defined for atoms x and y ;
• for an atom x and a list y, the result f[x;y] is a list whose ith item is
f[x;y[i]] ;
• for a list x and an atom y, the result f[x;y] is a list whose ith item is
f[x[i];y] ;
• for lists x and y , the result f[x;y] is a list whose ith item is
f[x[i];y[i]] .
For example, the dyad Plus is atomic.
2 + 3 26+3 559
2 + 3 -8 2 6 + 3 -8 5 -6 5 -2
  (2; 3 4) + ((5 6; 7 8 9); (10; 11 12))
((7 8
9 10 11) (13
15 16))
In the last example both arguments have count 2. The first item of the left argu- ment, 2, is added to the first item of the right argument, (5 6; 7 8 9), while the second argument of the left argument, 3 4, is added to the second argument of the right argument, (10; 11 12). When adding the first items of the two lists, the atom 2 is added to every atom in (5 6; 7 8 9) to give (7 8; 9 10 11), and when adding the second items, 3 is added to 10 to give 13, and 4 is added to both atoms of 11 12 to give 15 16 .
Plus can be defined recursively in terms of Plus for atoms as follows:
  Plus:{:[(@ x) & @ y; x + y; Plus'[x;y]]}
The arguments of an atom function must be conformable, or else a Length Error is reported. The evaluation will also fail if the function is applied to atoms that are not in its domain. For example, 1 2 3 + (4;"a";5) will fail because 2 + "a" fails with a Type Error.
Atom functions are not restricted to monads and dyads. For example, the triadic function {x+y^z} is an atom function (“x plus y to the power z”).
A function can be atomic relative to some of its arguments but not all. For example, the Index primitive @[x;y] is an atom function of its right argument but not its left, and is said to be right-atomic, or atomic in its second argument ). That is, for every left argument x the projected monadic function x@ is an atom function. This primitive function, like x[y], selects items from x according to the atoms in y, and the result is structurally like y, except that every atom in y is replaced by the item of x that it selects. A simple example is:
  2 4 -23 8 7 @ (0 4 ; 2)
(2 7
-23)
Index 0 selects 2 , index 4 selects 7 , and index 2 selects -23 . Note that the items of x do not have to be atoms.
It is common in descriptions of atom functions elsewhere in this manual to restrict attention to atom arguments and assume that the reader understands how the de- scriptions extend to list arguments.
K Reference Manual 3: Terminology 31
Character Constant
A character constant is defined by entering the characters between double-quotes, as in "abcdefg" . If only one character is entered the constant is an atom, other- wise the constant is a list. For example, "a" is an atom. The notation ,"a" is required to indicate a one character list. See Escape Sequences for entering non- graphic characters in character constants.
Character String
Character string is another name for character vector.
Character Vector
A character vector is a simple list whose items are all character atoms. When dis- played in an interactive session, it appears as a string of characters surrounded by double-quotes, as in:
"abcdefg"
not as individual characters separated by semicolons and surrounded by parenthe- ses (that is, not in list notation). When a character vector contains only one charac- ter, this is distinguished from the atomic character by prepending the Enlist monad (comma), as in ,"x".
Comparison Tolerance
Because floating-point values resulting from computations are usually only ap- proximations to the true mathematical values, the Equal primitive is defined so that x = y is 1 (true) for two floating-point values that are either near one an- other or identical. To see how this works, first set the print precision so that all digits of floating-point numbers are displayed.
\p 18 see Print Precision in the chapter Commands
The result of the following computation is mathematically 1.0, but the computed value is different because the addend 0.001 cannot be represented exactly as a floating-point number.
32
1
yes
x: 0
do[1000;x+:.001]
x
initialize x to 0
increment x one thousand times by 0.001 the resulting x is not quite 1.000
0.9999999999999062
However, the expression x = 1 has the value 1, and x is said to be tolerantly
equal to 1:
x = 1 is x equal 1?
Moreover, two distinct floating-point values x and y for which x = y is 1 are said to be tolerantly equal. No nonzero value is tolerantly equal to 0. Formally, there is a system constant E called the comparison tolerance such that two non- zero values a and b are tolerantly equal if:
| a - b | £ E ¥ max( | a | , | b | )
but in practice the implementation is an efficient approximation to this test. Note that according to this inequality, no nonzero value is tolerantly equal to 0. That is, if a=0 is 1 then a must be 0. To see this, substitute 0 for b in the above inequality and it becomes:
| a | £ E ¥| a | which, since E is less than 1, can hold only if a is 0.
In addition to Equal, comparison tolerance is used in the verbs Find, Floor, More, Less, Match, the adverbs Over and Scan for monads, and the system function _in.
Conformable Data Objects
The idea of conformable objects is tied to atom functions like Plus, functions like Form with behavior very much like atom functions, and functions derived from Each. For example, the primitive function Plus can be applied to vectors of the same count, as in
1 2 3+456 57 9
but fails with a Length Error when applied to vectors that do not have the same count, such as:
K Reference Manual 3: Terminology 33
34
1 2 3 +4567 length error
1 2 3 + 4567
^
Thevectors 1 2 3 and 4 5 6 aresaidtobeconformable,while1 2 3 and
4 5 6 7 are not conformable.
Plus applies to conformable vectors in an item-by-item fashion. For example, 1 2 3+4 5 6 equals (1+4),(2+5),(3+6) , or 5 7 9 . Similarly, Plus of an atom and a list is obtained by adding the atom to each item of the list. For example, 1 2 3+5 equals (1+5),(2+5),(3+5) , or 6 7 8 .
If the argument lists of Plus have additional structure below the first level then Plus is applied item-by-item recursively, and for these lists to be conformable they must be conformable at every level; otherwise, a Length Error is reported. For example, the arguments in the following expression are conformable at the top level – they are both lists of count 2 – but are not conformable at every level.
  (1 2 3;(4;5 6 7 8)) + (10;(11 12;13 14 15))
Plus is applied to these arguments item-by-item, and therefore both 1 2 3+10 and (4;5 6 7 8)+(11 12;13 14 15) are evaluated, also item-by-item. When the latter is evaluated, 5 6 7 8+13 14 15 is evaluated in the process, and since 5 6 7 8 and 13 14 15 are not conformable, the evaluation fails.
All atoms in the arguments to Plus must be numeric, or else Plus will fail with a Type Error. However, the types of the atoms in two lists have nothing to do with conformability, which is only concerned with the lengths of various pairs of sub- lists from the two arguments.
The following function tests for conformability; its result is 1 if its arguments con- form at every level, and 0 otherwise.
  conform:{ :[ (@x) | @y ; 1
               (#x) = #y ; &/ x conform' y; 0]]}
That is, atoms conform to everything, and two lists conform if they have equal counts and are item-by-item conformable (see Over Dyad in the chapter Adverbs for the meaning of the derived function &/ ).
Two objects x and y are said to conform at the top level if they are atoms or lists, and have the same count when both are lists. For example, if f is a dyad then the arguments of f' (that is, f-Each) must conform at the top level. More generally, x and y are said to conform at the top two levels if they conform at the top level and when both are lists, the items x[i] and y[i] also conform at the top level for every index i; and so on.
These conformability concepts are not restricted to pairs of objects. For example, three objects x, y, and z conform if all pairs x,y and y,z and x,z are conform- able.
Console
Console refers to the source of messages to K and their responses that are typed in a K session.
Dependencies
Dependencies provide spreadsheet-like formulas within applications. A dependency is a global variable with an associated expression describing its relationship with other global variables. The expression is automatically evaluated whenever the variable is referenced and any of the global variables in the expression have changed value since the last time the variable was referenced. If evaluated, the result of the expression is the value of the variable. If not referenced, the value of this variable is the last value it received, either by ordinary specification or a previous evalua- tion of the dependency expression.
The dependency expression is an attribute of a global variable whose value is a character string holding the dependency expression, for example:
v..d: "b + c"
for “v is b+c”. For example:
  b: 10 20 30
  c: 100
  v..d: "b + c"
  v
110 120 130
vhasthevalue b + c
K Reference Manual
3: Terminology 35
v[2]: 1000
v
110 120 1000
b[1]: 25
v
110 120 130
v can be amended
amend any part of b or c onceagain,vhasthevalue b + c
And of course, b and c can also be dependencies. Note that relative referents like b and c are not resolved in the attribute dictionary of v, but are entries in the same directory as v. Moreover, the dependency expression on v cannot contain an ex- plicit reference to v itself.
Dependent Variables
If a dependency expression is defined for a variable v then v is said to be directly dependent on all those variables that appear in that expression and dependent on all those variables than can cause it to be re-evaluated when it is referenced. Not only is v dependent on all variables in its dependency expression, but on all vari- ables in the dependency expressions of those variables, and so on.
Depth
The depth of a list is the number of levels of nesting. For example, an atom has depth 0, a list of atoms has depth 1, a list of lists of atoms has depth 2, and so on. The following function computes the depth of any data object:
     depth:{:[ @ x; 0; 1 + |/ depth' x]}
That is, an atom has depth 0 and a list has depth equal to 1 plus the maximum depth of its items. The symbols |/ denote Max-Over. When applied to a list of numeric values, as in |/ w , the result is the largest value in w (see Over Dyad). For example:
depth 10 depth {x + y} 00
depth 10 20 depth (10 20;30) 12
Depth is a useful notion that appears in several examples elsewhere in this manual.
36
Dictionary
A dictionary is an atom that is created from a list of a special form, using the Make Dictionary verb, denoted by the dot (.) . Each item in the list is a list of three items, the entry, the value and the attributes. The entry is a symbol, holding a simple name, that is, a name with no dots. The value may be any atom or list. The at- tributes are themselves a dictionary, giving the attributes of the item. An entry may have no attributes, or equivalently an empty dictionary (.() ) or nil. A dictionary can be indexed by any one of its symbols, and the result is the value of the symbol. When a dictionary is a global variable it is also a directory on the K-tree, and its entries are the global variables in that directory. See Make/Unmake Dictionary and K-tree.
Dyad
A dyad (or dyadic function) is a function of two arguments. Dyadic verbs may be used in either infix or prefix notation. However, defined dyadic functions must be used in prefix notation only.
Empty List
The generic empty list has no items, has count 0, and is denoted by () . The empty character vector is denoted "", the empty integer vector !0, the empty floating- point vector 0#0.0, and the empty symbol vector 0#`. The distinction between () and the typed empty lists is relevant to certain verbs (e.g. Match) and also to formatting data on the screen.
Entry
The entries of a dictionary d are the symbols given by its enumeration, !d . A global dictionary is a directory on the K-tree, and its entries are the global variables in that directory.
K Reference Manual 3: Terminology 37
Escape Sequence
An escape sequence is a special sequence of characters representing a character atom. An escape sequence usually has some non-graphic meaning, for example the tab character. An escape sequence can be entered in a character constant and dis- played in character data. The escape sequences in K are the same as those in the C- language, but often have different meanings. As in C, the sequence \b denotes the backspace character, \n denotes the new-line character, \t denotes the horizon- tal tab character, \" denotes the double-quote character, and \\ denotes the back-slash character.
In addition, \o and \oo and \ooo where each o is one of the digits from 0 through 7, denotes an octal number. If the character with that ASCII value has graphic meaning, that graphic is displayed, or if that character is one that can be specified by one of the escape sequences in the first paragraph, that sequence is displayed. For example:
"\b\a\11" enter a character constant
"\ba\t" \b displays as \b, \a as a, \11 as \t
Floating-Point Vector
A floating-point vector is a simple list whose items are all floating-point numbers. When displayed in a K session, it appears as a string of numbers separated by blanks, as in:
     10.56 3.41e10 -20.5
not as individual numbers separated by semicolons and surrounded by parentheses (that is, not in list notation). The empty floating-point vector is denoted 0#0.0 .
Function Atom
A function can appear in an expression as data, and not be subject to immediate evaluation when the expression is executed, in which case it is an atom. For ex- ample:
38
f: + @ f
     (f;102)
   (+;102)
Handle
f is assigned Plus f is an atom
f can be used like any other atom
1
A handle is a symbol holding the name of a global variable, which is a node in the K-tree. For example, the handle of the name a_c..b is `a_c..b . The term “handle” is used to point out that a global variable is directly accessed. Both of the following expressions are used to amend x:
     x: .[x; i; f; y]
        .[`x; i; f; y]
In the first, referencing x as the first argument causes its entire value to be con- structed, even though only a small part may be needed. In the second, the symbol `x is used as the first argument. In this case, only the parts of x referred to by the index i will be referenced and reassigned. The second case is usually more efficient than the first, sometimes significantly so. In the case where the value of x is a directory, referencing the global variable x causes the entire dictionary value to be constructed, even though only a small part of it may be needed. Consequently, in the description of Amend, the symbol atoms holding global variable names are referred to as handles.
Homogeneous List
A homogeneous list is one whose atoms are all of the same type. For example, a character vector is a homogeneous list of depth 1. A list of integers is one whose atoms are all integers. Similarly for a list of characters, or floating-point numbers, or symbols.
Integer Vector
An integer vector is a simple list whose items are all integers. When displayed in a K session, it appears as a string of numbers separated by blanks, as in:
K Reference Manual 3: Terminology 39
10 20 -30 40
not as individual integers separated by semicolons and surrounded by parentheses (that is, not in list notation). The empty integer vector is denoted !0 .
Item
An item is a component of a list, and may be either an atom or a list. The item of x at index position i is called the ith item and is denoted by x[i].
If an item is a list then it also has items, and any of these items that are lists may have items, and so on. Items of a list are sometimes called top-level items to distin- guish them from items of items, items of items of items, etc., which are generally referred to as items-at-depth . When it is necessary to be more specific, top-level items are called items at level 1 or items at depth 1, items of items are called items at level 2 or items at depth 2, and so on. Generally, an item is at depth n if it requires n indices to reach it.
There is also the related concept of items of specified depth, meaning items-at- depth that are a specified level above the bottom. For example, items of depth 1 would be lists of atoms within another list, as in:
     (1 2 3;(4 5; ("a";`bc)))
where the items of depth 1 are 1 2 3 and 4 5 and ("a";`bc). (The items at depth 1 are 1 2 3 and (4 5;("a";`bc)) .) Generally, an item is of depth n if there is atom within it that is at depth n, but no atom at depth n+1.
A list may contain one or more empty items (i.e. the nil value _n), which are typically indicated by omission:
     (1 ; _n ; 2)
   (1;;2)
K-Tree
The K-tree is the hierarchical name space containing all global variables created in a K session. The initial state of the K-tree when K is started is a working directory whose absolute path name is .k together with a set of other top-level directories containing various utilities. The working directory is for interactive use and is the
40
default active, or current, directory. Each application should define its own top- level directory that serves as its logical root, using a name which will not conflict with any other top-level application or utility directories present. Every subdirectory in the K-tree is a dictionary that can be accessed like any other variable, simply by its name. The root directory has no name, but can be accessed by the expression .` (“dot back-quote”).
Left-Atomic Function
A left-atomic function f is a dyad f that is atomic in its left, or first, argument. That is, for every valid right argument y, the monad f[;y] is atomic.
List
A list is one of the two fundamental data types, the other being the atom. The components of a list are called items (see Item). See Nouns in the chapter Syntax.
Matrix
A matrix is a rectangular list of depth 2. An integer matrix is one whose atoms are all integer atoms. Similarly for character matrix, floating-point matrix, and symbol matrix.
Monad
A monad, or monadic function, has one argument.
Nil
Nil is the value of an unspecified item in a list formed with parentheses and semi- colons. For example, nil is the item at index position 2 of (1 2;"abc";;`xyz). Nil is an atom; its value is _n , or *(). Nils have special meaning in the right argument of the primitive function Index and in the bracket form of function appli- cation.
K Reference Manual 3: Terminology 41
Nilad
A nilad, or niladic function, has no arguments.
Numeric List
A numeric list is one whose atoms are either integers or floating-point numbers. For example, the arguments to Plus and Times are numeric lists.
Numeric Vector
A numeric vector is a list that is either an integer vector or a floating-point vector.
Primitive Function
A primitive function is either the dyad or monad of a simple verb, where a simple verb is one of the symbols + , - , * , % , | , & , ^ , < , > , = , ! , # , _,~ , $ , ? , @ , . and , .
Rank
The rank of x is the number of items in its shape, namely #^x . The rank of an atom is always 0, and that of a list is always 1 or more. If the rank of a list is n, then the list must be rectangular to depth n. The rank of a matrix is 2. The rank of a dictio- nary d is defined to be *^d[].
Rectangular List
A list of depth 2 is said to be rectangular if all its items are lists of the same count. For example:
     (1 2 3; "abc"; `x `y `z; 5.4 1.2 -3.56)
is a rectangular list. The shape of a rectangular list of depth 2 has two items, the first being the count of the list and the second the count of any item.
^ (1 2 3; "abc"; `x `y `z; 5.4 1.2 -3.56) 43
42
Analogously, a list of depth 3 is rectangular if all items have depth 2 and all items of items are lists of the same count. The shape of a rectangular list of depth 3 has three items, the first being the count of the list, the second the count of any item, and the third the count of any item of any item. For example:
     ((1 2; `a `b; "AB"); ("CD"; 3 4; `c `d))
is a rectangular list of depth 3 and its shape is:
^ ((1 2; `a `b; "AB"); ("CD"; 3 4; `c `d)) 2 32
Rectangular lists of any depth can be defined.
It is possible for a list of depth d to be rectangular to depth n, where n is less than d. For example, the following list is of depth 3 and is rectangular to depth 2:
     ((0 1 2; `a; "AB"); ("CD"; 3 4; `c `d))
This list has two items, each of which has three items, but the next level of items vary in count. The shape of this list has only two items, the first being the count of the list and the second the count of any item:
^ ((0 1 2; `a; "AB"); ("CD"; 3 4; `c `d)) 23
The list x is rectangular to depth n if its shape has n items, that is if n equals #^x . Right-Atomic Function
A right-atomic function f is a dyad that is atomic in its right, or second, argument. That is, for every valid left argument x, the monadic function f[x;] is an atom function (see Fixing Function Arguments in the chapter Functions).
Script
A script file, or script for short, is a source file for an application or utility. It is a text file of function definitions and statements for execution, possibly including commands to load other scripts or operating system commands (see Load and OS Command in the chapter Commands ). The typical way to start an application is to give the name of its start-up script in the command that starts the K process.
K Reference Manual 3: Terminology 43
Simple List
A simple list is a list whose items are all atoms, i.e. a list of depth 1 (see Depth). The atoms need not be of the same type.
Simple Vector
A simple vector is a list which is either a character vector, floating-point vector, integer vector, or symbol vector. See also Vector Notation.
String
See Character String.
String-Atomic Function
A string-atomic function f is like an atom function, except that the recursion stops at strings rather than their individual atomic characters.
String Vector
A string vector is a list whose items are all character strings.
Symbol
A symbol is an atom which holds a string of characters, much as an integer holds a string of digits. For example, `abc denotes a symbol atom. This method of form- ing symbols can only be used when the characters are those that can appear in names. To form symbols containing other characters, put the contents between double quotes, as in `"abc-345" .
A symbol is an atom, and as such has count 1; its count is not related to the number of characters that appear in its display. The individual characters in a symbol are not directly accessible, but symbols can be sorted and compared with other sym- bols. Symbols are analogous to integers and floating-point numbers, in that they are atoms but their displays may require more than one character. (If they are needed, the characters in a symbol can be accessed by converting it to a character string.)
44
Symbol Vector
A symbol vector is a simple list whose items are all symbols. When displayed in a K session, it appears as a string of symbols separated by blanks, as in:
     `a `b `x_y.z `"123"
not as individual symbols separated by semicolons and surrounded by parentheses (that is, not in list notation). The empty symbol vector is denoted 0#` .
Trigger
A trigger is an expression associated with a global variable that is executed imme- diately whenever the value of the variable is set or modified. The purpose of a trigger is to have side effects, such as setting the value of another global variable. For example, suppose that whenever the value of the global variable x changes, the new value is to be sent to another K process where it is to become the new value of the 0th item of the variable b. This trigger is set simply by placing the expression on the appropriate node of the K-tree:
     x..t: "pid 3: (`b; 0; :; x)"
where pid is the identifier of the other process. Note that relative referents like b are not resolved in the attribute dictionary of x, but are entries in the same directory as x.
Valence
The valence of a function is the number of its arguments. For example, the valence of a tetrad is 4, of a triad 3, of a dyad 2, of a monad 1, and of a nilad 0. A function called with the wrong number of arguments will cause a Valence Error to be re- ported.
Vector
A list whose items are all of the same type is called a vector of that type. Thus we have integer vectors, floating-point vectors, character vectors, symbol vectors, and string vectors.
K Reference Manual 3: Terminology 45
Vector Notation
An integer or floating-point vector constant can be defined by putting the atoms next to one another with at least one space between each atom. For example, for the integer vector 1 -2 3 :
46
3
# 1 -2 3
a vector with 3 items item 1 of the vector a vector with 4 items
1 -2 3[1] -2
  # 3 4 5.721 1.023e10
4
Note that only one item of a floating-point vector defined by vector notation has to be given in decimal or exponential notation. The other items, if whole numbers, can be given in integer format, such as the items 3 and 4 in the above floating-point vector. For example, 1 2 3.0 4 is a floating-point vector, while 1 2 3 4 is an integer vector.
Characters appear between double-quote marks for string vectors. Items in symbol vectors need not be delimited by spaces, since the back-quote character serves to distinguish them.
`one`two`three #"Kx Systems" `one `two `three 10
One-item vectors employ the comma in their notation, as in:
,"a" ,`abc ,3.14159265
Empty vectors are denoted as !0, 0#0.0, "" and 0#` for integer, floating-point,
string and symbol vectors, respectively.
