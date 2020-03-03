---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# <i class="fas fa-share-alt"></i> Data preparation

## Preparing text

Operations can be pre-run on a corpus, with the results cached to a table, which can be persisted thus allowing for manipulation in q.

Operations undertaken to parse the dataset:

operation               | effect
------------------------|-------------------------------------------------
Tokenization            | splits the words; e.g. `John’s` becomes `John` as one token, and `‘s` as a second
Sentence detection      | characters at which a sentence starts and ends
Part of speech tagger   | parses the sentences into tokens and gives each token a label e.g. `lemma`, `pos`, `tag` etc.
Lemmatization           | converts to a base form e.g. `ran` (verb) to `run` (verb)


<!-- 
All function-name headers set as H4 (regardless of level of parent header)
to ensure uniform typography for these headings.
 -->
#### `.nlp.newParser`

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

Spell check can also be performed on the text by passing in `spell` as in input field. This updates any misspelt words to their most likely alternative. This is performed on text prior to parsing. Spacy does not support spell check on windows systems.

Parsing the novel _Moby Dick_:

```q
/ creating a parsed table
fields:`text`tokens`lemmas`pennPOS`isStop`sentChars`starts`sentIndices`keywords
myparser:.nlp.newParser[`en;fields]
corpus:myparser mobyDick
cols corpus
`text`tokens`lemmas`pennPOS`isStop`sentChars`starts`sentIndices`keywords
```

!!! Note "Language support"

	`.nlp.newParser` also supports Chinese (`zh`) and Japanese (`ja`) tokenization. These languages are only in the alpha stage of developement within Spacy so all functionality may not be available. Instructions on how to install these languages can be found at
    <i class="fab fa-github"></i> 
    [KxSystems/nlp](https://github.com/KxSystems/nlp).



#### `.nlp.parseURLs`

_parses URLS to dictionaries_

Syntax: `.nlp.parseURLs x`

Where `x` is text containing a URL, returns a dictionary parsing the URL.

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
q)myparser:.nlp.newParser[`en;fields]
q)corpus:myparser mobyDick

q).nlp.findPOSRuns[`pennPOS;`NNP`NNPS;corpus 0][;0]
`ishmael`november`cato`manhattoes`sabbath`corlears hook`coenties slip
```

## Feature vectors

We can generate a dictionary of descriptive terms, which consist of terms and their associated weights. These dictionaries are called _feature vectors_ and they are very useful as they give a uniform representation that can describe words, sentences, paragraphs, documents, collections of documents, clusters, concepts and queries.


### Calculating feature vectors for documents

The values associated with each term in a feature vector are how significant that term is as a descriptor of the entity. For documents, this can be calculated by comparing the frequency of words in that document to the frequency of words in the rest of the corpus.

Sorting the terms in a feature vector by their significance, you get the keywords that distinguish a document most from the corpus, forming a terse summary of the document. This shows the most significant terms in the feature vector for one of Enron CEO Jeff Skilling’s email’s describing a charity bike ride.

TF-IDF is an algorithm that weighs a term’s frequency (TF) and its inverse document frequency (IDF). Each word or term has its respective TF and IDF score. The product of the TF and IDF scores of a term is called the TF-IDF weight of that term.


#### `.nlp.TFIDF`

_TF-IDF scores for terms in each document of a corpus_

Syntax: `.nlp.TFIDF x`

Where 

-  `x` is a table of parsed documents

returns for each document, a dictionary with the tokens as keys, and relevance as values.

Extract a specific document and find the most significiant words in that document:

```q
q)queriedemail:jeffcorpus[where jeffcorpus[`text] like "*charity bike*"]`text;
q)5#desc .nlp.TFIDF[jeffcorpus]1346
ride  | 0.100777
bike  | 0.09897329
bikers| 0.05344036
biker | 0.05344036
miles | 0.04910715
```

#### `.nlp.TFIDF_tot`

_Total TF-IDF scores for all terms within a corpus of documents_

Syntax: `.nlp.TFIDF_tot x`

Where `x` is a table of parsed documents returns a dictionary with the tokens as keys, and relevance as values across all documents within the corpus

```q
q)desc .nlp.TFIDF_tot[jeffcorpus]
enron       | 12.66209
jeff        | 11.0934
notification| 8.962226
..
```

In cases where the dataset is more similar to a single document than a collection of separate documents, a different algorithm can be used. This algorithm is taken from
Carpena, P., et al. “Level statistics of words: Finding keywords in literary texts and symbolic sequences”.
The idea behind the algorithm is that more important words occur in clusters and less important words follow a random distribution.


#### `.nlp.keywordsContinuous`

_For an input which is conceptually a single document, such as a book, this will give better results than TF-IDF_

Syntax: `.nlp.keywordsContinuous x`

Where `x` is a table of parsed documents, returns a dictionary where the keys are keywords and the values are their significance.

Treating all of _Moby Dick_ as a single document, the most significant keywords are _Ahab_, _Bildad_, _Peleg_ (the three captains on the boat) and _whale_.

```q
q)10#keywords:.nlp.keywordsContinuous corpus
ahab      | 64.24125
peleg     | 52.37642
bildad    | 46.86506
whale     | 42.41664
stubb     | 37.82133
queequeg  | 35.50147
steelkilt | 33.94292
ye        | 33.43198
pip       | 32.90571
starbuck  | parseURLs["http://www.google.com"]31.63382
captain   | 29.1811
thou      | 28.27945
```

### Calculating feature vectors for words

The feature vector for a word can be calculated as a collection of how well other words predict the given keyword. The weight given to these words is a function of how much higher the actual co-occurrence rate is from the expected co-occurrence rate the terms would have if they were randomly distributed.



#### `.nlp.findRelatedTerms`

_Feature vector for a term_

Syntax: `.nlp.findRelatedTerms[x;y]`

Where

- `x` is a table of parsed documents
- `y` is a symbol which is the token for which to find related terms

returns a dictionary of the related tokens and their relevances.

```q
q).nlp.findRelatedTerms[corpus;`captain]
peleg   | 1.665086
bildad  | 1.336501
ahab    | 1.236744
ship    | 1.154238
cabin   | 0.9816231
```

Phrases can be found by looking for runs of words with an above-average significance to the query term.

#### `.nlp.extractPhrases`

_Runs of tokens that contain the term where each consecutive word has an above-average co-occurrence with the term_

Syntax: `.nlp.extractPhrases[corpus;term]`

Where

- `corpus` is a table of parsed documents
-   `term` is the term to extract phrases around (symbol)

returns a dictionary with phrases as the keys and their relevance as the values.

Search for the phrases that contain `captain` and see which phrase has the largest occurrence; we find `captain ahab` occurs most often in the book: 50 times.

```q
q).nlp.extractPhrases[corpus;`captain]
`captain`ahab      | 50
`captain`peleg     | 25
`captain`bildad    | 10
`stranger`captain  | 6
`captain`sleet     | 5
`sea`captain       | 3
`captain`pollard   | 3
`captain`mayhew    | 3
`whaling`captain   | 2
`captain`ahab`stood| 2
`captain`stood     | 2
`captain`d'wolf    | 2
`way`captain       | 2
```

#### `.nlp.bi_gram`

_Determine the probability of a word appearing next in a sequence of words_

Syntax: `.nlp.bi_gram corpus`

Where `corpus` is a table of parsed documents returns a dictionary containing the probability that the secondary word in the sequence follows the primary word.

```q
q).nlp.bi_gram corpus
chapter     loomings   | 0.005780347
loomings    ishmael    | 1
ishmael     years      | 0.05
years       ago        | 0.1770833
ago         mind       | 0.03030303
mind        long       | 0.02597403
long        precisely--| 0.003003003
precisely-- little     | 1
little      money      | 0.004016064
money       purse      | 0.07692308
purse       particular | 0.1428571
```
