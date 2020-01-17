---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# <i class="fas fa-share-alt"></i> Text comparison

Following the application of [data-processing procedures](preproc.md), it is possible to compare feature vectors, corpora and documents.


## Comparing feature vectors  

A vector can be thought of either as

-   the co-ordinates of a point
-   describing a line segment from the origin to a point

The view of a vector as a line segment starting at the origin is useful, as any two vectors will have an angle between them, corresponding to their similarity, as calculated by cosine similarity.

The _cosine similarity_ of two vectors is the dot product of two vectors over the product of their magnitudes. It is a standard distance metric for comparing documents.

### `.nlp.cosineSimilarity`

_The cosine similarity of two vectors_

Syntax: `.nlp.cosineSimilarity[x;y]`

Where `x` and `y` are two vectors, returns the cosine similarity between the vectors

```q
.nlp.compareDocs[first corpus`keywords;last corpus`keywords]
0.03635309
```

## Comparing corpora

A quick way to compare corpora is to find words common to the whole dataset, but with a strong affinity to only one corpus. This is a function of how much higher their frequency is in that corpus than in the dataset.


### `.nlp.compareCorpora`

_Terms’ comparative affinities to two corpora_

Syntax: `.nlp.compareCorpora[corpus1;corpus2]`

Where `corpus1` and `corpus2` are tables of lists of documents, returns a dictionary of terms and their affinity for `corpus2` over `corpus1`.

Enron CEO Jeff Skillings was a member of the Beta Theta Pi fraternity at Southern Methodist University (SMU). If we want to find secret fraternity code words used by the Betas, we can compare his fraternity emails (those containing _SMU_ or _Betas_) to his other emails.

```q
q)fraternity:jeffcorpus i:where (jeffcorpus[`text] like "*Betas*")|jeffcorpus[`text] like "*SMU*"
q)remaining:jeffcorpus til[count jeffcorpus]except i
q)summaries:key each 10#/:.nlp.compareCorpora[fraternity;remaining]
q)summaries 0  / summary of the fraternity corpus
`beta`homecoming`betas`smu`yahoo`groups`tent`reunion`forget`crowd
q)summaries 1  / summary of the remaining corpus
`enron`jeff`business`information`please`market`services`energy`management`company
```


## Comparing documents

This function allows you to calculate the similarity of two different documents. It finds the keywords that are present in both the corporas, and calculates the cosine similarity.


### `.nlp.compareDocs`

_Cosine similarity of two documents_

Syntax: `.nlp.compareDocs[dict1;dict2]`

Where `dict1` and `dict2` are dictionaries that consist of the document‘s keywords, returns the cosine similarity of two documents.

Given the queried email defined above, and a random email from the corpus, we can calculate the cosine similarity between them.

```q
q)email1:jeffcorpus[rand count jeffcorpus]
q)email2:jeffcorpus[rand count jeffcorpus] 
q).nlp.compareDocs[email1`keywords;email2`keywords]
0.1163404
```



## Comparing documents to corpus


### `.nlp.compareDocToCorpus`

_Cosine similarity between a document and other documents in the corpus_

Syntax: `.nlp.compareDocToCorpus[keywords;idx]`

Where

-   `keywords` is a list of dictionaries of keywords and coefficients
-   `idx` is the index of the feature vector to compare with the rest of the corpus

returns as a float the document’s significance to the rest of the corpus.

Comparing the first chapter with the rest of the book:

```q
q).nlp.compareDocToCorpus[corpus`keywords;0]
0.078517 0.1048744 0.06266384 0.07095197 0.08974005 0.05909442 0.06855744..
```
## Comparing strings of text

### `.nlp.jaroWinkler`

_The similarity between two strings of text, scored between 0 and 1_

Syntax:`.nlp.jaroWinkler[x;y]`

Where `x` and `y` are both strings, returns the Jaro-Winkler score of the two strings. The score is a number between 0 and 1, 1 being identical, and 0 being completely dissimilar.

```q
q).nlp.jaroWinkler[corpus[0]`text;corpus[1]`text]
0.835967
```

