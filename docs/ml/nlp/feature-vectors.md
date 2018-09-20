---
hero: <i class="fa fa-share-alt"></i> Machine learning
keywords: feature, kdb+, learning, machine, nlp, q, vector
---

# Feature vectors

We can generate a dictionary of descriptive terms, which consist of terms and their associated weights. These dictionaries are called _feature vectors_ and they are very useful as they give a uniform representation that can describe words, sentences, paragraphs, documents, collections of documents, clusters, concepts and queries. 


## Calculating feature vectors for documents

The values associated with each term in a feature vector are how significant that term is as a descriptor of the entity. For documents, this can be calculated by comparing the frequency of words in that document to the frequency of words in the rest of the corpus. 

Sorting the terms in a feature vector by their significance, you get the keywords that distinguish a document most from the corpus, forming a terse summary of the document. This shows the most significant terms in the feature vector for one of Enron CEO Jeff Skilling’s email’s describing a charity bike ride.

TF-IDF is an algorithm that weighs a term’s frequency (TF) and its inverse document frequency (IDF). Each word or term has its respective TF and IDF score. The product of the TF and IDF scores of a term is called the TF-IDF weight of that term. 


### `.nlp.TFIDF`

_TF-IDF scores for all terms in the document_

Syntax: `.nlp.TFIDF x`

Where `x` is a table of documents, returns for each document, a dictionary with the tokens as keys, and relevance as values.

Extract a specific document and find the most significiant words in that document:

```q
q)queriedemail:jeffcorpus[where jeffcorpus[`text] like "*charity bike*"]`text;
q)5#desc .nlp.TFIDF[jeffcorpus]1928
bikers   | 17.7979
biker    | 17.7979
strenuous| 14.19154
route    | 14.11932
rode     | 14.11136
```

In cases where the dataset is more similar to a single document than a collection of separate documents, a different algorithm can be used. This algorithm is taken from 
Carpena, P., et al. “Level statistics of words: Finding keywords in literary texts and symbolic sequences.”. 
The idea behind the algorithm is that more important words occur in clusters and less important words follow a random distribution. 


### `.nlp.keywordsContinuous`

_For an input which is conceptually a single document, such as a book, this will give better results than TF-IDF_

Syntax: `.nlp.keywordsContinuous x`

Where `x` is a table of documents, returns a dictionary where the keys are keywords and the values are their significance.

Treating all of _Moby Dick_ as a single document, the most significant keywords are _Ahab_, _Bildad_, _Peleg_ (the three captains on the boat) and _whale_.

```q
q)10#keywords:.nlp.keywordsContinuous corpus
ahab     | 65.23191
peleg    | 52.21875
bildad   | 46.56072
whale    | 42.72953
stubb    | 38.11739
queequeg | 35.34769
steelkilt| 33.96713
pip      | 32.90067
starbuck | 32.05286
thou     | 32.05231
```



## Calculating feature vectors for words

The feature vector for a word can be calculated as a collection of how well other words predict the given keyword. The weight given to these words is a function of how much higher the actual co-occurrence rate is from the expected co-occurrence rate the terms would have if they were randomly distributed.



### `.nlp.findRelatedTerms`

_Feature vector for a term_

Syntax: `.nlp.findRelatedTerms[x;y]`

Where 

-   `x` is a list of documents
-   `y` is a symbol which is the token for which to find related terms 

returns a dictionary of the related tokens and their relevances.

```q
q).nlp.findRelated[corpus;`captain]
peleg | 1.653247
bildad| 1.326868
ahab  | 1.232073
ship  | 1.158671
cabin | 0.9743517
```

Phrases can be found by looking for runs of words with an above-average significance to the query term.


### `.nlp.extractPhrases`

_Runs of tokens that contain the term where each consecutive word has an above-average co-occurrence with the term_

Syntax: `.nlp.extractPhrases[corpus;term]`

Where 

-   `corpus` is a subcorpus (table)
-   `term` is the term to extract phrases around (symbol)

returns a dictionary with phrases as the keys and their relevance as the values.

Search for the phrases that contain `captain` and see which phrase has the largest occurrence; we find `captain ahab` occurs most often in the book: 31 times.

```q
q).nlp.extractPhrases[corpus;`captain]  
"captain ahab"        | 31
"captain peleg"       | 12
"captain bildad"      | 7
"captain sleet"       | 5
"stranger captain"    | 4
"said the captain"    | 3
"sea-captain"         | 2
"whaling captain"     | 2
"captain's cabin"     | 2
"captain ahab,\" said"| 2
"captain pollard"     | 2
"captain d'wolf"      | 2
"way, captain"        | 2
```

