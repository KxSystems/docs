---
hero: <i class="fa fa-share-alt"></i> Machine learning
keywords: document, kdb+, learning, machine, nlp, parsing, q, sentiment
---

# Sentiment analysis




Using a pre-built model of the degrees of positive and negative sentiment for English words and emoticons, as well as parsing to account for negation, adverbs and other modifiers, sentences can be scored for their negative, positive and neutral sentiment. The model included has been trained on social-media messages. 


### `.nlp.sentiment`

_Sentiment of a sentence_

Syntax: `.nlp.sentiment x`

Where `x` is string or a list of strings, returns a dictionary or table containing the sentiment of the text.

An run of sentences from _Moby Dick_:

```q
q).nlp.sentiment("Three cheers,men--all hearts alive!";"No,no! shame upon all cowards-shame upon them!")
compound   pos       neg       neu      
----------------------------------------
0.7177249  0.5996797 0         0.4003203
-0.8802318 0         0.6910529 0.3089471
```


