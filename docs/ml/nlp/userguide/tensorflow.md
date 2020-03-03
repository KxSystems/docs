---
author: Diane O'Donoghue
date: October 2019
keywords: tensorflow, algorithm, analysis,corpus, document, learning, machine, machine learning,  ml, nlp, token, tokenizing, q, sentiment, vector, wordshape, emoji, punctuation, symbol
---

# <i class="fas fa-share-alt"></i> Tensorflow Text

Tensorflow text can be used to perform preprocessing operations on text based data. This allows the preprocessed data to be integrated into a tensorflow machine learning workflow with ease. Operations exposed within the NLP library from tensorflow include tokenization, sentiment analysis and extracting textual attributes from strings.

## Tokenization

Tokenization can be performed using either a whitespace or unicode tokenizer. A whitespace tokenizer splits strings at whitespace characters( i.e spaces, new lines and tabs). A unicode script tokenizer splits the strings into tokens based on unicode script boundaries. These boundaries are defined by the International Components for Unicode (ICU) UScriptCode values. More details cna be found at http://icu-project.org/apiref/icu4c/uscript_8h.html.

### `.nlp.tf.tokenize`

_Break up strings into tokens_

Syntax: `.nlp.tf.tokenize[x;y]`

Where 

-  `x` is a string of text 
-  `y` is the form of applied tokenization

returns a list of the tokens extracted from the text

The two possible values for `y` are `whitespace` and `unicode`

```q
q)show 5#whiteToken:.nlp.tf.tokenize[;`whitespace]each mobyDick
q)show 5#uniToken:.nlp.tf.tokenize[;`unicode]each mobyDick

`CHAPTER`1`Loomings`Call`me`Ishmael.`Some`years`ago--never`mind`how`long..
`CHAPTER`2`The`Carpet-Bag`I`stuffed`a`shirt`or`two`into`my`old`carpet-ba..
`CHAPTER`3`The`Spouter-Inn`Entering`that`gable-ended`Spouter-Inn,`you`fo..
`CHAPTER`4`The`Counterpane`Upon`waking`next`morning`about`daylight,`I`fo..
`CHAPTER`5`Breakfast`I`quickly`followed`suit,`and`descending`into`the`ba..
..

`CHAPTER`1`Loomings`Call`me`Ishmael`.`Some`years`ago`--`never`mind`how`l..
`CHAPTER`2`The`Carpet`-`Bag`I`stuffed`a`shirt`or`two`into`my`old`carpet`..
`CHAPTER`3`The`Spouter`-`Inn`Entering`that`gable`-`ended`Spouter`-`Inn`,..
`CHAPTER`4`The`Counterpane`Upon`waking`next`morning`about`daylight`,`I`f..
`CHAPTER`5`Breakfast`I`quickly`followed`suit`,`and`descending`into`the`b..
..
```

## Text Properties

### `.nlp.tf.wordshape`

_Identifies if a string contains certain text attributes_

Syntax: `.nlp.tf.wordshape[txt;tok;att]`

Where

-  `txt` is a string of text
-  `tok` is the form of tokenization to be used
-  `att` are the attributes to be identified in the text 

returns a table with rows cotaining lists of indices at which the attribute defined by the column occurs. A token column is also added which includes the text split into its appropriate tokens.

The following are the optional attr values:

field       | token description
------------|-------------------------------------------------------
`is_punc    | Is an element of punctuation or symbol
`has_punc   | An element contains an element of  punctuation or symbols along with other characters.
`is_mixed   | Consists of both upper and lower case letters
`is_numeric | Is a numeric value
`has_numeric| An element contains numeric values along with other characters
`lower      | The element of text is all lower case
`title      | The first character of the token is of upper case, and remaining lower
`symbol     | Non-letter characters are found in the token
`math       | Contains a mathematical symbol
`currency   | Contains a currency symbol
`acronym    | Is a period separated acronym
`is_emoji   | Is an individual emoji
`has_emoji  | The token contains an emoji character

all available options can be found within the function `.nlp.tf.i.metaDict`

```q
q)show txtAtt:.nlp.tf.wordshape[;`unicode;key .nlp.tf.i.metaDict]each mobyDick
is_punc                                                                       ..
------------------------------------------------------------------------------..
6 10 16 25 34 51 67 77 83 89 99 110 123 140 145 149 151 166 175 186 193 200 20..
4 16 18 24 33 41 48 57 73 84 89 107 114 123 126 133 149 155 166 171 186 200 20..
4 9 12 14 21 23 28 31 42 55 60 71 86 93 106 114 125 134 141 150 155 170 182 18..
10 14 27 37 43 49 54 71 82 98 108 114 117 131 133 146 155 162 183 188 195 201 ..
7 13 21 28 45 47 56 64 67 71 73 78 84 93 99 115 126 140 143 159 172 178 181 18..
30 47 53 69 76 85 95 99 104 112 122 126 133 138 146 149 160 166 168 172 174 17..
13 16 23 32 43 51 58 67 74 77 83 95 104 106 115 118 122 127 138 149 159 166 18..
20 25 33 44 55 57 64 70 79 91 104 112 125 139 148 159 168 171 179 192 202 212 ..
7 22 26 28 33 38 40 42 51 56 64 67 73 80 85 91 94 103 108 128 131 136 155 165 ..
...

q)cols txtAtt
`is_punc`has_punc`is_mixed`is_numeric`has_numeric`lower`title`symbol`math`curr..
```

## Sentimental Analysis

Using the same pre built model used by `.nlp.sentiment`, sentences can be scored for their negative, positve and neutral sentiment on data tokenized using tensorflow. 

### `.nlp.tf.sentiment`

_Sentiments of a sentence using tensorflow tokenization_

Syntax: `.nlp.tf.sentiment[txt;tok]`

Where 

- `text` is a string 
- `tok` is the form of tokenization to be applied

returns a dictionary or table containing the sentiment of the text.

A run of sentences from _Moby Dick_

```q
q).nlp.tf.sent[;`unicode]each("Three cheers,men--all hearts alive!";"No,no! shame upon all cowards-shame upon them!")
compound   pos       neg       neu      
----------------------------------------
0.7177249  0.5996797 0         0.4003203
-0.8802318 0         0.6910529 0.3089471

q).nlp.tf.sent[;`whitespace]each("Three cheers,men--all hearts alive!";"No,no! shame upon all cowards-shame upon them!")
compound   pos neg      neu     
--------------------------------
0          0   0        1       
-0.5695978 0   0.551167 0.448833
```

