---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# <i class="fas fa-share-alt"></i> Data interrogation

A number of functions allow users to interrogate text data. The areas covered are outlier detection, sentiment analysis and centroid analysis on sets of documents.


## Grouping documents to centroids

When you have a set of centroids and you would like to find out which centroid is closest to the documents, you can use this function.


### `.nlp.cluster.groupByCentroids`

_Documents matched to their nearest centroid_

Syntax: `.nlp.cluster.groupByCentroids[centroid;docs]`

Where

-   `centroid` is a list of the centroids as keyword dictionaries
-   `documents` is a list of document feature vectors

returns, as a list of lists of longs, document indexes where each list is a cluster.

Matches the first centroid of the clusters with the rest of the corpus:

```q
q).nlp.cluster.groupByCentroids[[corpus clusters][0][`keywords];corpus`keywords]
,0
1 2 4 9 10
,3
,5
6 7
8 95 96
11 12
,13
,14
15 19 21
,16
,17
18 20
,22
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

Syntax: `.nlp.explainSimilarity[doc1;doc2]`

Where 

-  `doc1` and `doc2` are dictionaries consisting of their associated documents’ keywords

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


## Sentiment analysis

Using a pre-built model of the degrees of positive and negative sentiment for English words and emoticons, as well as parsing to account for negation, adverbs and other modifiers, sentences can be scored for their negative, positive and neutral sentiment. The model included has been trained on social-media messages.


### `.nlp.sentiment`

_Sentiment of a sentence_

Syntax: `.nlp.sentiment x`

Where `x` is string or a list of strings returns a dictionary or table containing the sentiment of the text.

An run of sentences from _Moby Dick_:

```q
q).nlp.sentiment each ("Three cheers,men--all hearts alive!";"No,no! shame upon all cowards-shame upon them!")
compound   pos       neg       neu
----------------------------------------
0.7177249  0.5996797 0         0.4003203
-0.8802318 0         0.6910529 0.3089471
```


