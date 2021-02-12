---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# :fontawesome-solid-share-alt: Text comparison

Following the application of [data-processing procedures](preproc.md), it is possible to compare feature vectors, corpora and documents.

In the below examples, the `parsedTab` variable is the output from the `.nlp.newParser` [example](#preproc/nlpnewparser) defined in the data-preprocessing section.  

## Comparing feature vectors  

By extracting the keywords in a corpus and calculating their associated significance scores, we are able to treat pieces of text as feature vectors to further analyze the content. Feature vectors in NLP are explained [here](featVector.md)

A vector can be thought of either as

-   The co-ordinates of a point
-   Describing a line segment from the origin to a point

The view of a vector as a line segment starting at the origin is useful, as any two vectors will have an angle between them, corresponding to their similarity, as calculated by cosine similarity.

The _cosine similarity_ of two vectors is the dot product of two vectors over the product of their magnitudes. It is a standard distance metric for comparing documents.

### `.nlp.cosineSimilarity`

_Calculates the cosine similarity of two vectors_

```txt
.nlp.cosineSimilarity[keywords1;keywords2]
```

Where 

- `keywords1` is a dictionary of keywords and their significance scores in the corpus
- `keywords2` is a dictionary of keywords and their significance scores in the corpus

```q
q).nlp.compareDocs[first parsedTab`keywords;last parsedTab`keywords]
0.03635309
```

## Comparing corpora

A quick way to compare corpora is to find words common to the whole dataset, but with a strong affinity to only one corpus. This can be used to find key words in the corpora which differentiate one corpus from another


### `.nlp.compareCorpora`

_Calculates the affinity between terms in two corpus'_

```txt
.nlp.compareCorpora[parsedTab1;parsedTab2]
```

Where 

-  `parsedTab1` is a table of parsed documents (return of `.nlp.newParser`)
-  `parsedTab2` is a table of parsed documents (return of `.nlp.newParser`)


returns a dictionary of terms and their affinity for `parsedTab2` over `parsedTab1`.

Below we can compare the chapters in the novel that contain the term "whale" with the remaining chapters

```q
// Seperate text containing the term "whale"
q)whaleText:parsedTab i:where (parsedTab[`text] like "*whale*")
q)remaining:parsedTab til[count parsedTab]except i

q)show compare:.nlp.compareCorpora[whaleText;remaining]
`whale`whales`sperm`fish`boat`white`boats`great`oil`far`..
`night`queequeg`bed`man`aye`sleeping`ahab`morning`sat`th..
q)5#first compare
whale | 26.16359
whales| 12.40908
sperm | 10.20464
fish  | 7.951354
boat  | 7.824179
q)5#last compare
night   | 23.62646
queequeg| 19.54203
bed     | 15.60707
man     | 14.87776
aye     | 13.4208
```
!!! Note
	The `parsedTab` input must contain the following attributes: ``` `tokens`isStop ```

## Comparing documents

This function allows you to calculate the similarity of two different documents. It finds the keywords that are present in both the corporas, and calculates the cosine similarity.


### `.nlp.compareDocs`

_Cosine similarity of two documents_

```txt
.nlp.compareDocs[keywords1;keywords2]
```

Where 

- `keywords1` is a dictionary of keywords and their significance scores in the corpus
- `keywords2` is a dictionary of keywords and their significance scores in the corpus

returns the cosine similarity of two documents.

```q
q).nlp.compareDocs[first parsedTab`keywords;last parsedTab`keywords]
0.0362958
```

## Comparing documents to corpus


### `.nlp.compareDocToCorpus`

_Cosine similarity between a document and other documents in the corpus_

```txt
.nlp.compareDocToCorpus[keywords;idx]
```

Where

- `keywords` is a list of dictionaries containing keywords and their significance scores in the corpus
- `idx` is the index of the `keywords` to compare with the rest of the corpus' keywords

returns as a float the document’s significance to the rest of the corpus.

Comparing the first chapter with the rest of the book:

```q
q).nlp.compareDocToCorpus[parsedTab`keywords;0]
0.078517 0.1048744 0.06266384 0.07095197 0.08974005..
```
## Comparing strings of text

### `.nlp.jaroWinkler`

_Calculate the Jaro-Winkler distance of two sctrinfs, scored between 0 and 1_

Syntax:`.nlp.jaroWinkler[str1;str2]`

Where 

- `str1` is a string of text
- `str2` is a string of text

returns the Jaro-Winkler score of the two strings. The score is a number between 0 and 1, 1 being identical, and 0 being completely dissimilar.

```q
q).nlp.jaroWinkler[parsedTab[0]`text;parsedTab[1]`text]
0.835967
```

## Finding outliers, and representative documents

The _centroid_ of a collection of documents is the average of their feature vectors. As such, documents close to the centroid are representative, while those far away are the outliers. Given a collection of documents, finding outliers can be a quick way to find interesting documents, those that have been mis-clustered, or those not relevant to the collection.


### `.nlp.compareDocToCentroid`

_Cosine similarity of a document and a centroid_

```txt
.nlp.compareDocToCentroid[centroid;keywords]
```

Where

-  `centroid` is the sum of all the keywords significance scores as a dictionary
-  `keywords` is a dictionary of keywords and their significance scores in the corpus

returns the cosine similarity of the two documents as a float.

Below all the chapters containing the term "whale" will be extracted and the centroid calculated. The chapters furthest from the centroids will be identified 

```q
q)whaleText:parsedTab i:where (parsedTab[`text] like "*whale*")
q)centroid:sum whaleText`keywords
q)show compare:.nlp.compareDocToCentroid[centroid]each whaleText`keywords 
0.3849759 0.3286244 0.3994688 0.3833975 0.2
q)5#whaleText iasc compare
text                                                              ..
------------------------------------------------------------------..
"CHAPTER 6\n\nThe Street\n\n\nIf I had been astonished at first ca..
"CHAPTER 88\n\nSchools and Schoolmasters\n\n\nThe previous chapter..
"CHAPTER 107\n\nThe Carpenter\n\n\nSeat thyself sultanically among..
"CHAPTER 95\n\nThe Cassock\n\n\nHad you stepped on board the Pequo..
"CHAPTER 15\n\nChowder\n\n\nIt was quite late in the evening when ..
```

## Explaining similarities

For any pair of documents or centroids, the list of features can be sorted by how much they contribute to the similarity.


### `.nlp.explainSimilarity`
_Calculate how much each term contributes to the cosine similarity_

```txt
.nlp.explainSimilarity[keywords1;keywords2]
```

Where 

-  `keywords1` is a  dictionary of keywords and their significance scores
-  `keywords2` is a  dictionary of keywords and their significance scores

returns a dictionary of how much of the similarity score each token is responsible for.

```q
q)5#.nlp.explainSimilarity . parsedTab[`keywords]0 100
whale| 0.1864428
time | 0.06867081
sea  | 0.02967095
ship | 0.02693201
long | 0.02690912
```
