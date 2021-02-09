---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# :fontawesome-solid-share-alt: Text comparison

Following the application of [data-processing procedures](preproc.md), it is possible to compare feature vectors, corpora and documents.


## Comparing feature vectors  

A vector can be thought of either as

-   the co-ordinates of a point
-   describing a line segment from the origin to a point

The view of a vector as a line segment starting at the origin is useful, as any two vectors will have an angle between them, corresponding to their similarity, as calculated by cosine similarity.

The _cosine similarity_ of two vectors is the dot product of two vectors over the product of their magnitudes. It is a standard distance metric for comparing documents.

### `.nlp.cosineSimilarity`

_The cosine similarity of two vectors_

Syntax: `.nlp.cosineSimilarity[keywords1;keywords2]`

Where 

- `keywords1` is a dictionary of keywords and their significance scores in the corpus
- `keywords2` is a dictionary of keywords and their significance scores in the corpus

```q
.nlp.compareDocs[first corpus`keywords;last corpus`keywords]
0.03635309
```

## Comparing corpora

A quick way to compare corpora is to find words common to the whole dataset, but with a strong affinity to only one corpus. This is a function of how much higher their frequency is in that corpus than in the dataset.


### `.nlp.compareCorpora`

_Terms’ comparative affinities to two corpora_

Syntax: `.nlp.compareCorpora[corpus1;corpus2]`

Where 

- `corpus1` is a table containing a corpus of documents
- `corpus2` is a table containing a corpus of documents

returns a dictionary of terms and their affinity for `corpus2` over `corpus1`.

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

Where 

- `keywords1` is a dictionary of keywords and their significance scores in the corpus
- `keywords2` is a dictionary of keywords and their significance scores in the corpus

returns the cosine similarity of two documents.

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

Syntax:`.nlp.jaroWinkler[str1;str2]`

Where 

- `str1` is a string of text
- `str2` is a string of text

returns the Jaro-Winkler score of the two strings. The score is a number between 0 and 1, 1 being identical, and 0 being completely dissimilar.

```q
q).nlp.jaroWinkler[corpus[0]`text;corpus[1]`text]
0.835967
```

## Finding outliers, and representative documents

The _centroid_ of a collection of documents is the average of their feature vectors. As such, documents close to the centroid are representative, while those far away are the outliers. Given a collection of documents, finding outliers can be a quick way to find interesting documents, those that have been mis-clustered, or those not relevant to the collection.

The emails of former Enron CEO Ken Lay contain 1124 emails with a petition. Nearly all of these use the default text, only changing the name, address and email address. To find those petitions which have been modified, sorting by distance from the centroid gives emails where the default text has been completely replaced, added to, or has had portions removed, with the emails most heavily modified appearing first.


### `.nlp.compareDocToCentroid`

_Cosine similarity of a document and a centroid, subtracting the document from the centroid_

Syntax: `.nlp.compareDocToCentroid[centroid;document]`

Where

-   `centroid` is the sum of all documents in a cluster which is a dictionary
-   `document` is a document in a cluster which is a dictionary

returns the cosine similarity of the two documents as a float.

```q
q)petition:laycorpus where laycorpus[`subject] like "Demand Ken*"
q)centroid:sum petition`keywords
q).nlp.compareDocToCentroid[centroid]each petition`keywords
0.7578176 0.6816524 0.7749509 0.7046721 0.7882777 0.5808967 0.8139832 0.7567036..
q)outliers:petition iasc .nlp.i.compareDocToCentroid[centroid]each petition`keywords
```


## Searching

Searching can be done using words, documents, or collections of documents as the query or dataset. To search for documents similar to a given document, you can represent all documents as feature vectors using TF-IDF, then compare the cosine similarity of the query document to those in the dataset and find the most similar documents, with the cosine similarity giving a relevance score.

The following example searches using `.nlp.compareDocs` for the document most similar to the below email where former Enron CEO Jeff Skilling is discussing finding a new fire chief.

```q
q)queryemail:first jeffcorpus where jeffcorpus[`text] like "Fire Chief Committee*"
q)-1 queryemail`text;
q)mostsimilar:jeffcorpus first 1_idesc .nlp.compareDocs[queryemail`keywords]each jeffcorpus`keywords

Fire Chief Committee

Dear Jeff:

    Thank you again for extending me an invitation to be on your committee to
select the new Houston Fire Chief.  I look forward with much enthusiasm and
excitement to working with you and the committee members on this very
important project.

    I enjoyed our visit at the Doubletree immensely. It was great walking
down memory lane and recalling our days in Cambridge. We probably passed each
other at Harvard Square at some point during our time there.  As I said, I am
a great admirer of you and ENRON. The innovation, creativity and unique
(though soon to be widely copied) business plan make ENRON one of Houston's
(and the nation's, maybe also California's in the near future) great assets.

     Since the subject came up in our conversation, I will add a short
personal note. After reviewing several potential transactions this week, it
is quite possible that my partners and I will be entering into a "business
defining" transaction in the next two months. Since I am a lousy golfer, I
will be exploring new challenges.

    Thursday, at the fire station, should be fun. I can see you and the mayor
in one of the hook and ladder trucks for the photo op.

Take care,

Roel 
```


## Explaining similarities

For any pair of documents or centroids, the list of features can be sorted by how much they contribute to the similarity.

This example compares two of former Enron CEO Jeff Skilling’s emails, both of which have in common the subject of selecting Houston’s next fire chief.


### `.nlp.explainSimilarity`

Syntax: `.nlp.explainSimilarity[keywords1;keywords2]`

Where 

-  `keywords1` is a  dictionary of keywords and their significance scores
-  `keywords2` is a  dictionary of keywords and their significance scores

returns a dictionary of how much of the similarity score each token is responsible for.

```q
q)10#.nlp.explainSimilarity . jeffcorpus[`keywords]306 309
fire     | 0.3542747
committee| 0.2015475
chief    | 0.08861098
roel     | 0.06699533
station  | 0.04705624
mayor    | 0.04343555
houston  | 0.04181817
business | 0.03459796
select   | 0.02556851
thursday | 0.01825156
```
