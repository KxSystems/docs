---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, parsedTab, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# :fontawesome-solid-share-alt: Data preparation

## Preparing text

Operations can be pre-run on a corpus, with the results cached to a table, which can be persisted thus allowing for manipulation in q.

Operations undertaken to parse the dataset:

operation               | effect
------------------------|-------------------------------------------------
Tokenization            | splits the words; e.g. `John’s` becomes `John` as one token, and `‘s` as a second
Sentence detection      | characters at which a sentence starts and ends
Part of speech tagger   | parses the sentences into tokens and gives each token a label e.g. `lemma`, `pos`, `tag` etc.
Lemmatization           | converts to a base form e.g. `ran` (verb) to `run` (verb)

In the below examples, the text of `Moby Dick` was used. This [text](https://github.com/KxSystems/mlnotebooks/blob/master/data/mobydick.txt) can be found in the data folder of the mlnotebooks, along with a [notebook](https://github.com/KxSystems/mlnotebooks/blob/master/notebooks/08%20Natural%20Language%20Processing.ipynb) demonstrating how the functions described in this section can be implemented.

```txt
// Read in data
text:"\n"sv read0`:mobydick.txt
removeBadNewlines:{@[x;1+(raze string x="\n")ss"010";:;" "]}
mobyDick:(text ss "CHAPTER ")cut removeBadNewlines text
```

<!-- 
All function-name headers set as H4 (regardless of level of parent header)
to ensure uniform typography for these headings.
 -->

#### `.nlp.newParser`

_Creates a parser_

```txt
.nlp.newParser[spacyModel;fields]
```

Where

-   `spacyModel` is a [model or language](https://spacy.io/usage/models) (symbol)
-   `fields` is the field/s you want in the output (symbol atom or vector)

returns a function to parse the text.

The optional fields are:

field         | type                   | content
--------------|------------------------|---------------------------------------
`text`        | list of characters     | Original text
`tokens`      | list of symbols        | The tokenized text
`sentChars`   | list of lists of longs | Indexes of start and end of sentences
`sentIndices` | list of integers       | Indexes of the first token of each sentences
`pennPOS`     | list of symbols        | The Penn Treebank tagset
`uniPOS`      | list of symbols        | The Universal tagset
`lemmas`      | list of symbols        | The base form of the word
`isStop`      | boolean                | Is the token part of the stop list?
`likeEmail`   | boolean                | Does the token resembles an email?
`likeURL`     | boolean                | Does the token resembles a URL?
`likeNumber`  | boolean                | Does the token resembles a number?
`keywords`    | list of dictionaries   | Significance of each term
`starts`      | long                   | Index that a token starts at


The resulting function is applied to a list of strings.

Spell check can also be performed on the text by passing in `spell` as in input field. This updates any misspelt words to their most likely alternative. This is performed on text prior to parsing. SpaCy does not support spell check on windows systems.

Parsing the novel _Moby Dick_:

```q
// Creating a parsed table
fields:`text`tokens`lemmas`pennPOS`isStop`sentChars`starts`sentIndices`keywords
myparser:.nlp.newParser[`en;fields]
parsedTab:myparser mobyDick
cols parsedTab
`text`tokens`lemmas`pennPOS`isStop`sentChars`starts`sentIndices`keywords
```

!!! Note "Language support"

	`.nlp.newParser` also supports Chinese (`zh`) and Japanese (`ja`) tokenization. These languages are only in the alpha stage of developement within SpaCy so all functionality may not be available. Instructions on how to install these languages can be found at
    :fontawesome-brands-github: 
    [KxSystems/nlp](https://github.com/KxSystems/nlp).



#### `.nlp.parseURLs`

_Parse URLs into dictionaries containing the constituent components_

```txt
.nlp.parseURLs[url]
```

Where 

- `url` is text containing the URL to decompose into its components

returns a dictionary information about the scheme, domain name and other URL information.

```q
q).nlp.parseURLs["https://www.google.ca:1234/test/index.html;myParam?foo=bar&quux=blort#abc=123&def=456"]
scheme    | "https"
domainName| "www.google.ca:1234"
path      | "/test/index.html"
parameters| "myParam"
query     | "foo=bar&quux=blort"
fragment  | "abc=123&def=456"
```

## Finding part-of-speech tags in a corpus

This is a quick way to find all of the nouns, adverbs, etc. in a corpus. There are two types of part-of-speech (POS) tags you can find: [Penn Tree tags](https://www.ling.upenn.edu/courses/Fall_2003/ling001/penn_treebank_pos.html) and [Universal Tree tags](http://universaldependencies.org/docs/en/pos/all.html).


#### `.nlp.findPOSRuns`

_Find tokens of specific POS types_

```txt
.nlp.findPOSRuns[tagtype;tags;parsedDict]
```

Where

-   `tagtype` is `uniPos` or `pennPos`
-   `tags` is one or more POS tags (symbol atom or vector)
-   `parsedDict` is dictionary containing a single parsed text (return of `nlp.newParser`)

returns a two item list containing :

1. The token of POS type indicated within `tag` (symbol vector)
2. Indexes of the first occurrence of each token (long vector)

Importing a novel from a plain text file, and finding all the proper nouns in the first chapter of _Moby Dick_:

```q
fields:`text`tokens`lemmas`pennPOS`isStop`sentChars`starts`sentIndices`keywords
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

!!! Note
	The `parsedDict` input value must contain the following attributes: ``` `tokens`pennPOS/`uniPOS ```

	
