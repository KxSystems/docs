---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, parsedTab, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# :fontawesome-solid-share-alt: Data preparation

<div markdown="1" class="typewriter">
.nlp   **Data preparation**
\  Preparing text
  [newParser](#nlpnewparser)    Creates a parser
  [parseURLs](#nlpparseurls)    Parse URLs into dictionaries containing their constituent components

\  Finding part-of-speech tags in a corpus
  [findPOSRuns](#nlpfindposruns)   Find tokens of specific POS types in a text
</div>


## Preparing text

Operations can be pre-run on a corpus, with the results cached to a table, which can be persisted, allowing for manipulation in q.

Operations undertaken to parse the dataset:

operation               | effect
------------------------|-------------------------------------------------
Tokenization            | Splits the words; e.g. `John’s` becomes `John` as one token, and `‘s` as a second
Sentence detection      | Characters at which a sentence starts and ends
Part-of-speech tagger   | Parses the sentences into tokens and gives each token a label e.g. `lemma`, `pos`, `tag` etc.
Lemmatization           | Converts to a base form e.g. `ran` (verb) to `run` (verb)

The text of `Moby Dick` was used in the examples.

:fontawesome-brands-github:
[KxSystems/mlnotebooks/data/mobydick.txt](https://github.com/KxSystems/mlnotebooks/blob/master/data/mobydick.txt)
<br>
:fontawesome-brands-github:
[KxSystems/mlnotebooks/notebooks/08 Natural Language Processing.ipynb](https://github.com/KxSystems/mlnotebooks/blob/master/notebooks/08%20Natural%20Language%20Processing.ipynb)

```txt
// Read in data
text:"\n"sv read0`:mobydick.txt
removeBadNewlines:{@[x;1+(raze string x="\n")ss"010";:;" "]}
mobyDick:(text ss "CHAPTER ")cut removeBadNewlines text
```


## Finding part-of-speech tags in a corpus

This is a quick way to find all of the nouns, adverbs, etc. in a corpus. There are two types of part-of-speech (POS) tags you can find:

-   [Penn Tree tags](https://www.ling.upenn.edu/courses/Fall_2003/ling001/penn_treebank_pos.html)
-   [Universal Tree tags](http://universaldependencies.org/docs/en/pos/all.html)


---


## `.nlp.findPOSRuns`

_Find tokens of specific POS types in a text_

```syntax
.nlp.findPOSRuns[tagtype;tags;parsedDict]
```

Where

-   `tagtype` is `` `uniPos`` or `` `pennPos`` (symbol atom)
-   `tags` is one or more POS tags (symbol atom or vector)
-   `parsedDict` is a dictionary containing a single parsed text (as returned by `nlp.newParser`)

returns a two-item list:

1.  Tokens in the text of type `tags` (symbol vector)
2.  Indexes of the first occurrence of each token (long vector)

Importing a novel from a plain text file, and finding all the proper nouns in the first chapter of _Moby Dick_:

```q
q)fields:`text`tokens`lemmas`pennPOS`isStop`sentChars`starts`sentIndices`keywords
q)myparser:.nlp.newParser[`en;fields]
q)parsedTab:myparser mobyDick
q)parsedDict:parsedTab 0;
q).nlp.findPOSRuns[`pennPOS;`NNP`NNPS;parsedDict]
`ishmael          ,5
`precisely--      ,13
`november         ,76
`cato             ,161
`manhattoes       ,213
`mole             ,247
```

!!! note "The `parsedDict` argument must contain keys: `tokens` and `pennPOS` or `uniPOS`"


## `.nlp.newParser`

_Create a parser_

```syntax
.nlp.newParser[spacyModel;fields]
```

Where

-   `spacyModel` is a spaCy [model or language](https://spacy.io/usage/models) (symbol)
-   `columns` are the columns you want in the result (symbol atom or vector)

returns a function to parse the text.

The optional fields are:

```txt
column       type                    content
---------------------------------------------------------------------------
text         list of characters      Original text
tokens       list of symbols         Tokenized text
sentChars    list of lists of longs  Indexes of starts and ends of sentences
sentIndices  list of integers        Indexes of first token of each sentence
pennPOS      list of symbols         The Penn Treebank tagset
uniPOS       list of symbols         The Universal tagset
lemmas       list of symbols         The base form of the word
isStop       boolean                 Is the token part of the stop list?
likeEmail    boolean                 Does the token resembles an email?
likeURL      boolean                 Does the token resembles a URL?
likeNumber   boolean                 Does the token resembles a number?
keywords     list of dictionaries    Significance of each term
starts       long                    Index that a token starts at
```

The resulting function is applied to a list of strings.

Spell check can also be performed on the text by passing in `spell` as a column name. This updates any misspelt words to their most likely alternative. This is performed on text prior to parsing. (SpaCy does not support spell check on Windows systems.)

Parsing the novel _Moby Dick_:

```q
// Creating a parsed table
q)fields:`text`tokens`lemmas`pennPOS`isStop`sentChars`starts`sentIndices`keywords
q)myparser:.nlp.newParser[`en;fields]
q)parsedTab:myparser mobyDick
q)cols parsedTab
`text`tokens`lemmas`pennPOS`isStop`sentChars`starts`sentIndices`keywords
```

??? tip "Chinese and Japanese language support"

	`.nlp.newParser` also supports Chinese (`zh`) and Japanese (`ja`) tokenization. These languages are only in the alpha stage of development within SpaCy so all functionality may not be available. 

    :fontawesome-brands-github:
    [KxSystems/nlp](https://github.com/KxSystems/nlp) for installation instructions



## `.nlp.parseURLs`

_Parse URLs into dictionaries containing their constituent components_

```syntax
.nlp.parseURLs url
```

Where `url` is a URL as string, returns a dictionary of information about the scheme, domain name, and other URL information.

```q
q).nlp.parseURLs "https://www.google.ca:1234/test/index.html;myParam?foo=bar&quux=blort#abc=123&def=456"
scheme    | "https"
domainName| "www.google.ca:1234"
path      | "/test/index.html"
parameters| "myParam"
query     | "foo=bar&quux=blort"
fragment  | "abc=123&def=456"
```

