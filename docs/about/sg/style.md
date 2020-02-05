---
title: Style Guide – Style – About – kdb+ and q documentation
hero: Site style guide
description: Usage and markup rules for inline style, such as bold and italic type, and for codeblocks and Lists
author: Stephen Taylor
keywords: bold, code, italic, kdb+, markdown, q, style
---
# <i class="fas fa-pen-nib"></i> Style


## Inline style

### Plain 

Everything in plain type should be American English or

-   a term in the [Glossary](https://code.kx.com/q/basics/glossary/)
-   a locally-defined usage 


### Italics

Use italics for:

-   emphasis, e.g. “the _best_ way to do this is…”
-   reference to, rather than use of, a word, e.g. “the word _short_ is itself short“
-   for definitions, e.g. “An iterator takes a function argument and returns a function: the  _derived function_.” 
-   citations of books or periodicals (but use double typographers’ quotes for the title of an article) e.g. “see “Functions and shadows” in _Vector_ 23:4” 
-   the names of GUI controls, using `>` to show descent through menus, e.g. “Click _File > New_ to…”

!!! tip "Foreign languages"

    Avoid using words or phrases in languages other than English. 
    Where one is necessary, set it in italics. 
    
    Your editor will try to remove it [_pour encourager les autres_](https://en.wikipedia.org/wiki/Battle_of_Minorca_(1756)).


### Bold

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


## Markdown

These rules apply to Markdown source files for code.kx.com. 

### Bold and italic

Use underscores for italic and double asterisks for bold. For example, 

```markdown
The _quick_ brown fox jumps over the **lazy** dog.
```

renders as: 

> The _quick_ brown fox jumps over the **lazy** dog.

Do not use single asterisks for italic, nor double underscores for bold, even though MkDocs will render them so. 


### Lists

Where a list item spans multiple paragraphs, or includes a code block, use indentation to keep all the list item’s children subordinate to it. 


