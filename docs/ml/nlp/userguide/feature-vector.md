---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# :fontawesome-solid-share-alt: Feature vectors
<div markdown="1" class="typewriter">
.nlp   **Feature vector functions**
\  Feature vectors for documents
  [keywordsContinuous](#nlpkeywordscontinuous) Relevance scores for tokens in a text
  [TFIDF](#nlptfidf)              TF-IDF scores for terms in each document of a corpus

\  Feature vectors for words
  [biGram](#nlpbigram)             Probability of a word appearing next in a sequence
  [extractPhrases](#nlpextractphrases)     Tokens that contain the term where each consecutive word
                     has an above-average co-occurrence
  [findRelatedTerms](#nlpfindrelatedterms)    Find related terms and their significance to a word
  [nGram](#nlpngram)              Probability of n tokens appearing together
</div>


After applying [data-processing procedures](preproc.md), you can treat pieces of text as feature vectors.

You can generate a dictionary of descriptive terms, which consist of terms and their associated weights. These dictionaries are called _feature vectors_ and they are very useful as they give a uniform representation that can describe words, sentences, paragraphs, documents, collections of documents, clusters, concepts and queries.

!!! tip "`parsedTab`"

    In the examples below, the `parsedTab` variable is the result from the `.nlp.newParser` [example](#preproc/nlpnewparser) in the data-preprocessing section.  


## Feature vectors for documents

The values associated with each term in a feature vector are how significant that term is as a descriptor of the entity. For documents, this can be calculated by comparing the frequency of words in that document to the frequency of words in the rest of the corpus.

Sorting the terms in a feature vector by their significance, you get the keywords that distinguish a document most from the corpus, forming a terse summary of the document. This shows the most significant terms in the feature vector for one of the chapters in Moby Dick is `whale`.

TF-IDF is an algorithm that weighs a term’s frequency (TF) and its inverse document frequency (IDF). Each word or term has its respective TF and IDF score. The product of the TF and IDF scores of a term is called the TF-IDF weight of that term.


## Feature vectors for words

The feature vector for a word can be calculated as a collection of how well other words predict the given keyword. The weight given to these words is a function of how much higher the actual co-occurrence rate is from the expected co-occurrence rate the terms would have if they were randomly distributed.

---


## `.nlp.biGram`

_Probability of a word appearing next in a sequence of words_

```syntax
.nlp.biGram parsedTab
```

Where `parsedTab` is a table of parsed documents (as returned by `.nlp.newParser`) returns a dictionary containing the probability that the secondary word in the sequence follows the primary word.

```q
q).nlp.biGram parsedTab
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

!!! note "The `parsedTab` argument must contain column/s `tokens` and `isStop`"


## `.nlp.extractPhrases`

_Tokens that contain the term where each consecutive word has an above-average co-occurrence with the term_

```syntax
.nlp.extractPhrases[parsedTab;term]
```

Where

-  `parsedTab` is a table of parsed documents (as returned by `.nlp.newParser`)
-  `term` is the term as a symbol to extract phrases around

returns a dictionary with phrases as the keys and their relevance as the values.

Search for the phrases that contain `captain` and see which phrase has the largest occurrence; we find `captain ahab` occurs most often in the book: 50 times.

```q
q).nlp.extractPhrases[parsedTab;`captain]
`captain`ahab      | 50
`captain`peleg     | 25
`captain`bildad    | 10
`stranger`captain  | 6
`captain`sleet     | 5
`sea`captain       | 3
...
```

!!! note "The `parsedTab` argument must contain column `tokens`"


## `.nlp.findRelatedTerms`

_Related terms and their significance to a word_

```syntax
.nlp.findRelatedTerms[parsedTab;term]
```

Where

-  `parsedTab` is a table of parsed documents (as returned by `.nlp.newParser`)
-  `term` is a symbol which is the token for which to find related terms

returns a dictionary of the related tokens and their relevances.

```q
q).nlp.findRelatedTerms[parsedTab;`captain]
peleg   | 1.665086
bildad  | 1.336501
ahab    | 1.236744
ship    | 1.154238
cabin   | 0.9816231
```

Phrases can be found by looking for runs of words with an above-average significance to the query term.

!!! note "The `parsedTab` argument must contain columns `tokens`, `isStop`, and `sentIndices`"


## `.nlp.keywordsContinuous`

_Relevance scores for tokens in a text_

```syntax
.nlp.keywordsContinuous parsedTab
```

Where `parsedTab` is a table of parsed documents (as returned by `.nlp.newParser`) returns a dictionary of keywords and their significance.

Treating all of _Moby Dick_ as a single document, the most significant keywords are _Ahab_, _Bildad_, _Peleg_ (the three captains on the boat) and _whale_.

```q
q)5#keywords:.nlp.keywordsContinuous parsedTab
ahab      | 64.24125
peleg     | 52.37642
bildad    | 46.86506
whale     | 42.41664
stubb     | 37.82133
```

For an input which is conceptually a single document, such as a book, this will give better results than using TF-IDF.

!!! note "The `parsedTab` argument must contain columns `tokens` and `isStop`"


## `.nlp.nGram`

_Probability of `n` tokens appearing together in a text_

```syntax
.nlp.nGram[parsedTab;n]
```

Where

-  `parsedTab` is a table of parsed documents (as returned by `.nlp.newParser`)
-  `n` is the number of words to occur together

returns a dictionary containing the the probability of `n` tokens appearing together in a text.

```q
q).nlp.nGram[parsedTab;3]
chapter  loomings ishmael    | 1
loomings ishmael  years      | 1
ishmael  years    ago        | 1
years    ago      mind       | 0.05882353
years    ago      poor       | 0.05882353
years    ago      nathan     | 0.05882353
years    ago      know       | 0.05882353
years    ago      plan       | 0.05882353
years    ago      scoresby   | 0.05882353
years    ago      commodore  | 0.05882353
```

!!! note "The `parsedTab` argument must contain columns `tokens` and `isStop`"


## `.nlp.TFIDF`

_TF-IDF scores for terms in each document of a corpus_

```syntax
.nlp.TFIDF parsedTab
```

Where `parsedTab` is a table of parsed documents (as returned by `.nlp.newParser`) returns for each document, a dictionary of tokens and their relevance.

Extract a specific document and find the most significiant words in that document:

```q
q)5#desc .nlp.TFIDF[parsedTab]100
whales | 0.02578393
straits| 0.02454199
herd   | 0.01933972
java   | 0.01729666
sunda  | 0.01675828
```

!!! note "The `parsedTab` argument must contain columns `tokens` and `isStop`"


