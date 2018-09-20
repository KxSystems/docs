---
hero: <i class="fa fa-share-alt"></i> Machine learning
keywords: centroid, document, feature, kdb+, learning, machine, nlp, q, similarity, vector
---

# Explaining similarities

For any pair of documents or centroids, the list of features can be sorted by how much they contribute to the similarity. 

This example compares two of former Enron CEO Jeff Skilling’s emails, both of which have in common the subject of selecting Houston’s next fire chief.


### `.nlp.explainSimilarity`

Syntax: `.nlp.explainSimilarity[doc1;doc2]`

Where `doc1` and `doc2` are dictionaries consisting of their associated documents’ keywords, returns a dictionary of how much of the similarity score each token is responsible for.

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


