---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# <i class="fas fa-share-alt"></i> Utility functions

The NLP library contains functions useful for in-depth document analysis. They extract elements of the text that can be applied to NLP algorithms, or that can help you with your analysis.


## `.nlp.findTimes`

_All the times in a document_

Syntax: `.nlp.findTimes x`

Where `x` is a string, returns a general list:

1.  time
1.  text of the time (string)
1.  start index (long)
1.  index after the end index (long)

```q
q).nlp.findTimes "I went to work at 9:00am and had a coffee at 10:20"
09:00:00.000 "9:00am" 18 24
10:20:00.000 "10:20"  45 50
```


## `.nlp.findDates`

_All the dates in a document_

Syntax: `.nlp.findDates x`

Where `x` is a string, returns a general list:

1.  start date of the range
1.  end date of the range
1.  text of the range
1.  start index of the date (long)
1.  index after the end index (long)

```q
q).nlp.findDates "I am going on holidays on the 12/04/2018 to New York and come back on the 18.04.2018"
2018.04.12 2018.04.12 "12/04/2018" 30 40
2018.04.18 2018.04.18 "18.04.2018" 74 84
```


## `.nlp.getSentences`

_A document partitioned into sentences._

Syntax: `.nlp.getSentences x`

Where `x` is a dictionary or a table of document records or subcorpus, returns a list of strings.

```q
/finds the sentences in the first chapter of MobyDick
q) .nlp.getSentences corpus[0]
"CHAPTER 1\n\n  Loomings\n\n\n\nCall me Ishmael."
" Some years ago--never mind how long precisely-- having little or no money in my purse, and noth..
" It is a way I have of driving off the spleen and regulating the circulation."
```


## `.nlp.loadTextFromDir`

_All the files in a directory, imported recursively_

Syntax: `.nlp.loadTextFromDir x`

Where `x` is the directory’s filepath as a string, returns a table of filenames, paths and texts.

```q
q).nlp.loadTextFromDir["/home/kx/nlp/datasets/maildir/skilling-j"]

fileName path                                           text                 ..
-----------------------------------------------------------------------------..
1.       :./datasets/maildir/skilling-j/_sent_mail/1.   "Message-ID: <1461010..
10.      :./datasets/maildir/skilling-j/_sent_mail/10.  "Message-ID: <1371054..
100.     :./datasets/maildir/skilling-j/_sent_mail/100. "Message-ID: <47397.1..
101.     :./datasets/maildir/skilling-j/_sent_mail/101. "Message-ID: <2486283..
```

