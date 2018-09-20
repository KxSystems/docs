---
hero: <i class="fa fa-share-alt"></i> Machine learning
author: Fionnuala Carr
title: Natural-language processing toolkit
date: May 2018
keywords: analysis, machine learning, ml, nlp, sentiment 
---

# Natural-language processing 



Natural-language processing (NLP) can be used to answer a variety of questions about unstructured text data, as well as facilitating open-ended exploration. 

It can be applied to datasets such as emails, online articles and comments, tweets, or novels. Although the source is text, transformations are applied to convert this data to vectors, dictionaries and symbols which can be handled very effectively by q. Many operations such as searching, clustering, and keyword extraction can all be done using very simple data structures, such as feature vectors and bag-of-words representations.


## Preparing text

Operations can be pre-run on a corpus, with the results cached to a table, which can be persisted.

Operations undertaken to parse the dataset:

operation               | effect
------------------------|-------------------------------------------------
Tokenization            | splits the words; e.g. `John’s` becomes `John` as one token, and `‘s` as a second
Sentence detection      | characters at which a sentence starts and ends
Part of speech tagger   | parses the sentences into tokens and gives each token a label e.g. `lemma`, `pos`, `tag` etc.
Lemmatization           | converts to a base form e.g. `ran` (verb) to `run` (verb)


<!-- 
All function-name headers set as H3 (regardless of level of parent header)
to ensure uniform typography for these headings.
 -->


### `.nlp.newParser`

_Creates a parser_

Syntax: `.nlp.newParser[spacymodel;fields]`

Where 

-   `spacymodel` is a [model or language](https://spacy.io/usage/models) (symbol)
-   `fields` is the field/s you want in the output (symbol atom or vector)

returns a function to parse the text.
   
The optional fields are:

field         | type                   | content
--------------|------------------------|---------------------------------------
`text`        | list of characters     | original text 
`tokens`      | list of symbols        | the tokenized text 
`sentChars`   | list of lists of longs | indexes of start and end of sentences 
`sentIndices` | list of integers       | indexes of the first token of each sentences
`pennPOS`     | list of symbols        | the Penn Treebank tagset 
`uniPOS`      | list of symbols        | the Universal tagset 
`lemmas`      | list of symbols        | the base form of the word
`isStop`      | boolean                | is the token part of the stop list?
`likeEmail`   | boolean                | does the token resembles an email?
`likeURL`     | boolean                | does the token resembles a URL?
`likeNumber`  | boolean                | does the token resembles a number?
`keywords`    | list of dictionaries   | significance of each term 
`starts`      | long                   | index that a token starts at

The resulting function is applied to a list of strings. 

Parsing the novel _Moby Dick_: 

```q
/ creating a parsed table  
fields:`text`tokens`lemmas`pennPOS`isStop`sentChars`starts`sentIndices`keywords
myparser:.nlp.newParser[`en;fields] 
corpus:myparser mobyDick 
cols corpus
`tokens`lemmas`pennPOS`isStop`sentChars`starts`sentIndices`keywords`text
```


## Finding part-of-speech tags in a corpus

This is a quick way to find all of the nouns, adverbs, etc. in a corpus. There are two types of part-of-speech (POS) tags you can find: [Penn Tree tags](https://www.ling.upenn.edu/courses/Fall_2003/ling001/penn_treebank_pos.html) and [Universal Tree tags](http://universaldependencies.org/docs/en/pos/all.html).


### `.nlp.findPOSRuns`

_Runs of tokens whose POS tags are in the set passed_

Syntax: `.nlp.findPOSRuns[tagtype;tags;document]`

Where 

-   `tagtype` is `uniPos` or `pennPos`
-   `tags` is one or more POS tags (symbol atom or vector)
-   `document` is parsed text (dictionary)

returns a general list:

1. text of the run (symbol vector)
2. indexes of the first occurrence of each token (long vector)

Importing a novel from a plain text file, and finding all the proper nouns in the first chapter of _Moby Dick_:

```q
fields:`text`tokens`lemmas`pennPOS`isStop`sentChars`starts`sentIndices`keywords
q)myparser:.nlp.parser.i.newParser[`en;fields] 
q)corpus:myparser mobyDick 

q).nlp.findPOSRuns[`pennPOS;`NNP`NNPS;corpus 0][;0]
`loomings`ishmael`november`cato`manhattoes`circumambulate`sabbath`go`corlears`hook`coenties
```

