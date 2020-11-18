Site-specific Markdown conventions
==================================

[Markdown](https://daringfireball.net/projects/markdown/) has many dialects or ‘flavors’. 
Some scripts that work on the site’s Markdown content files depend on our site-specific Markdown conventions.


Bold and italic
---------------

Use underscores for italic and double asterisks for bold. For example, 

```markdown
The _quick_ brown fox jumps over the **lazy** dog.
```

renders as: 

> The _quick_ brown fox jumps over the **lazy** dog.

Do not use single asterisks for italic, nor double underscores for bold, even though MkDocs will render them so. 


Lists
-----

Where a list item spans multiple paragraphs, or includes a code block, use indentation to keep all the list item’s children subordinate to it. 


Headings
--------

Use hash characters, not underlines, to mark H1s and H2s.


Code blocks
-----------

Use code fences and label them with the relevant language to enable [syntax highlighting](../syntax-highlighting.txt).

<pre class="language-markdown">
Start q

```bash
q showtable.q
```

to display the result
</pre>


Text code blocks with embedded hyperlinks
-----------------------------------------

Embed hyperlinks in a text code block by replacing the code fence with a `pre` element with 

-   a `markdown` attribute set to `1`
-   `class` set to `language-txt`

```txt
<pre markdown="1" class="language-txt">
[! Dict](../ref/dict.md)  make a dictionary         [key](../ref/key.md)      key list
[group](../ref/group.md)   group list by values      [value](../ref/value.md)    value list
</pre>
```


Hyperlink URIs
--------------

**Internal links** (i.e. to other pages in this repo) are _relative_ and must be to the _Markdown file_. 
They can include a bookmark:

```markdown
can be achieved with the [`set`](../ref/get.md#set) keyword
```

Links to **other subsites** of code.kx.com are regular URIs that begin with the _site root_.

```markdown
as described in [_Q for Mortals_ §8.3](/q4m3/8_Tables/#83-basic-select-and-update) and following
```

Only links to **external sites** are absolute URIs.

```markdown
[How to avoid excessive stat(/etc/localtime) calls in strftime() on Linux](https://stackoverflow.com/questions/4554271/how-to-avoid-excessive-stat-etc-localtime-calls-in-strftime-on-linux/4554302#4554302 "stackoverflow.com")
```

Note above use of the `title` attribute to produce a helpful popup on hover. 


Icons
-----

Icons help readers categorize content. 
We use FontAwesome 5 icons and the PyMdown emojis extension to [specify icons](https://squidfunk.github.io/mkdocs-material/reference/icons-emojis/#using-icons).


### External hyperlinks

Where an external hyperlink is set as its own para, prefix it with a solid globe:

```markdown
:fontawesome-solid-globe:
[How to avoid excessive stat(/etc/localtime) calls in strftime() on Linux](https://stackoverflow.com/questions/4554271/how-to-avoid-excessive-stat-etc-localtime-calls-in-strftime-on-linux/4554302#4554302 "stackoverflow.com")
```


### GitHub hyperlinks

Prefix _all_ GitHub hyperlinks, both block and inline, with the GitHub brand icon. 

```markdown
… use the :fontawesome-brands-github: [KxSystems/kafka](https://github.com/KxSystems/kafka) library …

:fontawesome-brands-github: 
[KxSystems/kafka](https://github.com/KxSystems/kafka)
<br>
:fontawesome-brands-github: 
[KxSystems/java](https://github.com/KxSystems/java)
```

Use the URL as the link text, omitting the protocol and site address. 


### Internal hyperlinks

Use icons to categorize block links:

```txt
:fontawesome-solid-book:           Reference
:fontawesome-solid-book-open:      Language
:fontawesome-solid-database:       Database
:fontawesome-solid-share-alt:      Machine learning
:fontawesome-solid-cloud:          Cloud deployment
:fontawesome-solid-handshake:      Interfaces
:fontawesome-solid-graduation-cap: Learn
```

Example:

```markdown
:fontawesome-solid-database:
[Database: tables in the filesystem](../database/index.md)
<br>
:fontawesome-solid-book-open:
[File system](../basics/files.md)
<br>
:fontawesome-solid-database:
[File compression](../kb/file-compression.md)
<br>
:fontawesome-regular-map:
[Compression in kdb+](../wp/compress/index.md)
```


Math
----

Set a LaTeX equation on its own line, starting and ending with `$$`.

Embrace a LaTeX expression in single dollar signs, e.g. `$n-1$`. 

Escape dollar signs in plain text, e.g. `this costs \$4.99 or less`.



