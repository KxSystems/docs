Typographical conventions
=========================

Inline style
------------

### Plain type

Everything in plain type should be American English or

-   a term in the [Glossary](https://code.kx.com/q/basics/glossary/)
-   a locally-defined term 


### Italic type

Use italic type for:

-   emphasis, e.g. “the _best_ way to do this is…”
-   reference to, rather than use of, a word, e.g. “the word _short_ is itself short“
-   first mention of a locally-defined term, e.g. “An iterator takes a function argument and returns a function: the  _derived function_.” 
-   citations of books or periodicals (but use double typographers’ quotes for the title of an article) e.g. “see “Functions and shadows” in _Vector_ 23:4” 
-   the names of GUI controls, using `>` to show descent through menus, e.g. “Click _File > New_ to…”

Avoid using words or phrases in languages other than English. 
Where one is necessary, set it in italics. 
    
Your editor will try to remove it [_pour encourager les autres_](https://en.wikipedia.org/wiki/Battle_of_Minorca_(1756)).


### Bold type

Use bold styling

-   for _very strong_ emphasis, e.g. “Do not **ever** commit without running the tests.”
-   to mark words that aid a visual search, e.g.

    Where `x` is

    -   a **numeric atom**, returns the `x`<sup>th</sup> product of `y` and `z`
    -   a **symbol vector**, returns dictionary `y` with the keys of `x` switched with their values


### Inline code

Use inline code style for

-   executable expressions, including lambdas e.g. `2+2`, `0b`, and `.qlint.lintItem["5?0Ng";::]`
-   the names of files, functions and variables, including built-in q functions and operators, e.g. `over` and `+`
-   numeric values of explicit type, e.g. “the count of an empty list is 0, but the boolean for _false_ is `0b` – otherwise set numeric values as plain type

Exception: where all items in a table column would have code style, use plain style instead. 


### Title case

Use title case for **proper names**, e.g. _Python_, _C#_, _Microsoft Windows_. 
Notable exceptions are _macOS_, _q_ and _kdb+_.

Also use title case for the names of **panels, tabs and dialogs** in a UI, e.g. _Dashboard Manager_, _Connection Editor_. 

Exceptions:

-   The **language** is _q_. 
-   The **database, process and product** are all known as _kdb+_. 

Although both are proper names they are set in lower case, except where they begin sentences or headings. 


Characters
----------

### Encoding

For Markdown source files use only UTF-8 encoding with no BOM (byte-order mark).

Prefer **actual Unicode characters** – which a modern text editor will display correctly – to both character entities and HTML character entities, which degrade the readability of the source. (HTML character entities are more readable than character entities, but different browsers support different subsets of them.) Thus, prefer `π` to `&#928;` or `&pi;`. 

-   Windows allows many characters to be typed as ASCII codes from the numeric keyboard, eg Alt+0215 for ×. (See the [W3C list of HTML character entity references](https://www.w3.org/TR/html401/sgml/entities.html#h-24.2) for codes.) 
-   Mac OS X provides a graphical palette of Unicode characters. 

If a character proves particularly difficult to source (for example, the romaji O-micron), try using its character entity, displaying the result in a browser, then copying and pasting the character from the browser back into the source. (It is a good idea in such cases to leave the character entity embedded as a comment.)


### Ellipses

Use real ellipses (…) because three periods can be broken across lines or pages. 

-   In Windows Alt+0133 on the numeric keypad 
-   On Mac, Opt+;


## Ligatures

[Ligatures](https://en.wikipedia.org/wiki/Glyph) are typesetters’ tools for setting two letters together. 

Sequences such as ae and oe are uncommon in American spellings, but reserve ligatures such as _æ_ and _œ_ for languages in which they are distinct characters. _Det glæder mig…_ (Danish)


### Quotation marks

Use **double typographer’s quotes** around 

-   reported speech, e.g. “Go away,” he said.
-   titles of articles, essays, and scholarly papers

Use **single typographer’s quotes** 

-   as [apostrophe](spelling.md)
-   to remove emphasis

Removing emphasis is the opposite of emphasis. 
The words de-emphasised are understood as not carrying their literal sense. 
(The convention is sometimes called “scare quotes”.)

> At the conference he said, “Today I’d like to talk to you about the ‘vision thing’ you’ve heard so much about.”


Use single and double **typewriter quotes** only in code elements, e.g. 

```txt
ssr'[x;y;z]
'<a href="' + $href + '">'
```


### Dashes

Use spaced endashes for parenthetical breaks – such as this – and not

-   doubled hyphens -- such as this--or this
-   spaced hyphens - such as this
-   emdashes, spaced — such as this — or unspaced—such as this—even though it is the usual style in American typography

The endash is Ctl+- on a Mac keyboard.


Block elements
--------------

### Headings

Set headings in sentence case, i.e., in lower case except for

-   the first letter
-   acronyms, e.g. _IPC_, _HTTP_, _API_
-   proper names, e.g. _Python_, _C#_, _WebSocket_, _GitHub_, _macOS_

Apply inline code style where appropriate. 

Minimize punctuation within a heading and end it without punctuation. 

Number headings in an article only when there are many references in the text to the numbers. Where there are a few references to heading numbers, replace them with the italicized heading texts, linked to the headings. 


### Ordered and unordered lists

Use numbered lists only 

-   where it is _necessary_ to refer to a list item, e.g. “as in (3) above”, but, where possible, avoid by replacing references to list item numbers
-   where the order is significant, e.g. in a sequence of instructions 

Where 

-   a list has no more than five items; 
-   the items are short; and
-   its items are clauses of a single sentence

suffix all but the last item with a semicolon, and use "and" or "or" before the last item if desired, as in this sentence. 

Otherwise, leave the ends of list items unpunctuated. 


### Admonitions

Use [admonitions](https://squidfunk.github.io/mkdocs-material/extensions/admonition/) for warnings, tips and notes.
Use them sparingly and avoid juxtaposing them. 

Prefer single-line admonitions; for example

```markdown
!!! example "This shows how it’s done.""
```

rather than

```markdown
!!! note "Example"

    This shows how it’s done.
```


### Tables

Set column headers in lower case, except for proper names and code objects. 

Prefer text code blocks for 

-   small tables 
-   tables with many columns
-   tables with columns that do not need to be wrapped

```txt
label          symbol
errorClass     symbol
description    string
problemText    string
errorMessage   string
startLine      long
endLine        long
startIndex     long
endIndex       long
```


