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
0 23 65 137
1 5 14 45 81
2 6 7 13 15 16 17 19 20 21 26 27 31 40 44 47 48 49 50 54 57 58 62 63 66 67 68..
3 9 10
,4
8 51 55 95 96 108 112 117 129 132 136 146 148
11 12
,18
22 25
,24
28 53 61 72 82 83 86 91 113 130 147
,29
,30
32 33 79 98 104 105 107 131
34 97
35 37 38 39 41 42
36 133 149
43 60 64 74 106 115
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
0.2374891 0.2308969 0.2383573 0.2797052 0.2817323 0.3103245 0.279753 0.2396462 0.3534717 0.369767
q)outliers:petition iasc .nlp.i.compareDocToCentroid[centroid]each petition`keywords
```


## Searching

Searching can be done using words, documents, or collections of documents as the query or dataset. To search for documents similar to a given document, you can represent all documents as feature vectors using TF-IDF, then compare the cosine similarity of the query document to those in the dataset and find the most similar documents, with the cosine similarity giving a relevance score.

The following example searches using `.nlp.compareDocs` for the document most similar to the below email where former Enron CEO Jeff Skilling is discussing finding a new fire chief.

```q
q)queryemail:first jeffcorpus where jeffcorpus[`text] like "Fire Chief Committee*"
q)-1 queryemail`text;
q)mostsimilar:jeffcorpus first 1_idesc .nlp.compareDocs[queryemail`keywords]each jeffcorpus`keywords

Select Comm AGENDA - Jan 25-Febr 1

Houston Fire Chief Selection Committee Members: Jeff Skilling - Chairperson,
Troy Blakeney, Gerald Smith, Roel Campos and James Duke.

Congratulations selection committee members! We have a very important and
exciting task ahead of us.

On the agenda for the next week are two important items - (1) the Mayor's
February 1 news conference announcing the Houston Fire Chief selection
committee and its members; and (2) coordination of an action plan, which we
should work out prior to the news conference.

News Conference specifics:
speakers - Mayor Brown and Jeff Skilling
in attendance - all selection committee members
location - Fire Station #6, 3402 Washington Ave.
date - Thursday, February 1, 2001
time - 2pm
duration - approximately 30 minutes

I'd like to emphasize that it would be ideal if all selection committee
members were present at the news conference.

I will need bios on each committee member emailed to me by close of business
Monday, January 29, 2001. These bios will be attached to a press release the
Mayor's Office is compiling.

Coordination of action plan:
Since we have only 1 week between now and the news conference, Jeff has
proposed that he take a stab at putting together an initial draft. He will
then email to all committee members for comments/suggestions and make changes
accordingly. Hope this works for everyone - if not, give me a call
(713)-345-4840.

Thanks,
Lisa
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
q)10#.nlp.explainSimilarity . jeffcorpus[`keywords]568 358
fire     | 0.2588778
roel     | 0.1456685
committee| 0.1298068
mayor    | 0.1295087
station  | 0.09342764
chief    | 0.06948782
select   | 0.04325209
important| 0.03838308
members  | 0.03530552
plan     | 0.02459828
```


## Sentiment analysis

Using a pre-built model of the degrees of positive and negative sentiment for English words and emoticons, as well as parsing to account for negation, adverbs and other modifiers, sentences can be scored for their negative, positive and neutral sentiment. The model included has been trained on social-media messages.


### `.nlp.sentiment`

_Sentiment of a sentence_

Syntax: `.nlp.sentiment x`

Where 

-  `x` is string or a list of strings

returns a dictionary or table containing the sentiment of the text.

An run of sentences from _Moby Dick_:

```q
q).nlp.sentiment("Three cheers,men--all hearts alive!";"No,no! shame upon all cowards-shame upon them!")
compound   pos       neg       neu
----------------------------------------
0.7177249  0.5996797 0         0.4003203
-0.8802318 0         0.6910529 0.3089471
```

