---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# :fontawesome-solid-share-alt: Utility functions


<div markdown="1" class="typewriter">
.nlp   **Utility functions**
  [detectLang](#nlpdetectlang)        Detect the language within a text
  [findDates](#nlpfinddates)         Find all the dates in a string of text
  [findRegex](#nlpfindregex)         Find regular expressions within a string
  [findTimes](#nlpfindtimes)         Find all the times in a string of text
  [getSentences](#nlpgetsentences)      Extract all sentences for a document
  [loadTextFromDir](#nlploadtextfromdir)   Import all files in a director
  [removeCustom](#nlpremoveCustom)      Remove aspects of a string of text containing certain characters or expressions
  [removeNonAscii](#nlpremoveNonAscii)    Remove non-ASCII characters from a string
  [removeReplace](#nlpremoveReplace)      Replace individual characters in a string
  [sentiment](#nlpsentiment)          Calculate the sentiment of a sentence
</div>


The NLP library contains functions useful for in-depth document analysis. They extract elements of the text that can be applied to NLP algorithms, or that can help you with your analysis.

In the below examples, the `parsedTab`/`parsedDict` variable is the output from the `.nlp.newParser` [example](#preproc/nlpnewparser) defined in the data-preprocessing section.

## `.nlp.detectLang`

```text
.nlp.detectLang[text]
```

Where

- `text` is a string of text

returns a symbol denoting the language of the text

```q
q).nlp.detectLang["This is a string of text"]
`en
q).nlp.detectLang["Ein, zwei, drei, vier"]
`de
```

!!! Note
	This function uses pythons [langdetect](#https://pypi.org/project/langdetect/) module. Information on the abbreviation codes used to classify the langugaes can be found [here](#https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)

## `.nlp.findDates`

_Find all the dates in a string of text_

```text
.nlp.findDates[text]
```

Where 

- `text` is a string of text, potentially containing many dates 

returns a general list:

1.  Start date of the range
1.  End date of the range
1.  Text of the range
1.  Start index of the date (long)
1.  Index after the end index (long)

```q
q).nlp.findDates "I am going on holidays on the 12/04/2018 to New York and come back on the 18.04.2018"
2018.04.12 2018.04.12 "12/04/2018" 30 40
2018.04.18 2018.04.18 "18.04.2018" 74 84
```

## `.nlp.findRegex`

_Find regular expressions within a string of text_

```text
.nlp.findRegex[text;expr]
```

Where

-  `text` is the string of text to extract the regular expressions from
-  `expr` is the expression type as a symbol to be searched for within the text

returns a dictionary, extracting the expression along with the indices within the expression occurs.

The optional expressions that can be searched for within the text are as follows:

```txt
`specialChars                 `year
`money                        `yearfull
`phoneNumber                  `am
`emailAddress                 `pm
`url                          `time12
`zipCode                      `time24
`postalCode                   `time
`postalOrZipCode              `yearmonthList
`dtsep (date separator)       `yearmonthdayList
`day                          `yearmonth
`month                        `yearmonthday
```

```q
q)txt:"You can call the number 123 456 7890 or email us on name@email.com in book an
   appoinment for January,February and March for £30.00"
q).nlp.findRegex[txt;`phoneNumber`emailAddress`yearmonthList`money]
phoneNumber  | ,(" 123 456 7890";23;36)
emailAddress | ,("name@email.com";52;66)
yearmonthList| (("January";97;104);("February";105;113);("March";118;123);("30";129;131);("00";13..
money        | ,("\302\24330.00";128;134)
```

## `.nlp.findTimes`

_Find any times in a string_

```text
.nlp.findTimes[text]
```

Where 

- `text` is a string of text potentially containing many times

returns a general list:

1.  Time
1.  Text of the time (string)
1.  Start index (long)
1.  Index after the end index (long)

```q
q).nlp.findTimes "I went to work at 9:00am and had a coffee at 10:20"
09:00:00.000 "9:00am" 18 24
10:20:00.000 "10:20"  45 50
```

## `.nlp.getSentences`

_Extract all sentences for a document_

```text
.nlp.getSentences[parsedDict]
```

Where 

-  `parsedDict` is a dictionary containing a single parsed text (return of `.nlp.newParser`)

returns a list of strings of all the sentences from a document.

```q
// Finds the sentences in the first chapter of MobyDick
q)parsedDict:parsedTab[0]
q).nlp.getSentences parsedDict
"CHAPTER 1\n\n  Loomings\n\n\n\nCall me Ishmael."
" Some years ago--never mind how long precisely-- having little or no money in my purse, and noth..
" It is a way I have of driving off the spleen and regulating the circulation."
"Whenever I find myself growing grim about the mouth; whenever it is a damp, drizzly November in ..
" This is my substitute for pistol and ball."
"With a philosophical flourish Cato throws himself upon his sword; I quietly take to the ship."
..
```

## `.nlp.loadTextFromDir`

_Import all files in a directory_

```text
.nlp.loadTextFromDir[filepath]
```

Where 

- `filepath` is the directory’s filepath as a string

returns a table of filenames, paths and texts contained within the filepath.

```q
q).nlp.loadTextFromDir["./datasets/maildir/skilling-j"]

fileName path                                           text                 ..
-----------------------------------------------------------------------------..
1.       :./datasets/maildir/skilling-j/_sent_mail/1.   "Message-ID: <1461010..
10.      :./datasets/maildir/skilling-j/_sent_mail/10.  "Message-ID: <1371054..
100.     :./datasets/maildir/skilling-j/_sent_mail/100. "Message-ID: <47397.1..
101.     :./datasets/maildir/skilling-j/_sent_mail/101. "Message-ID: <2486283..
```

## `.nlp.removeCustom`

_Remove certain characters from a string of text_

```text
.nlp.removeCustom[text;char]
```

Where

- `text` is a string of text
- `char` is a list of characters or expressions to be removed from the text

returns the string a text without anything that contains the defined characters.

```q
q)rmvList   :("*\n*";"*?!*";"*,";"*&*";"*[0-9]*")
q)(jeffemails`text)100
"Re:\n\nHow much to you have?!  SRS\n\n\n\n\nKevin Hannon @ ENRON COMMUNICATIONS on 04/20/2001 08..
q).nlp.removeCustom[(jeffemails`text)100;rmvList]
"much to you  SRS\n\n\n\n\nKevin Hannon ENRON COMMUNICATIONS on  \n\n\nOK Sherri how much do you ..
```

## `.nlp.removeNonAscii`

_Remove non-ASCII characters from a string of text_

```text
.nlp.removeNonAscii[text]
```

Where 

- `text` is a string of text 

returns the string of text with all non-ASCII characters removed.

```q
q).nlp.removeNonAscii["This is ä senteñcê"]
"This is  sentec"
```

## `.nlp.removeReplace`

_Remove and replace certain characters from a string of text_

```text
.nlp.removeReplace[text;char;replace]
```

Where

- `text` is a string of text
- `char` is the string of characters to be removed
- `replace` is the characters or expressions which will replace the removed character

returns the string of text with the characters removed and replaced.

```q
q).nlp.removeReplace[(jeffemails`text)100;",.:?!/@'\n";"??"]
"Re????????How much to you have????  SRS??????????Kevin Hannon ?? ENRON COMMUNICATIONS on 04??20?..
```

## `.nlp.sentiment`

_Calculate the sentiment of a sentence_

```text 
.nlp.sentiment[text]
```

Where 

- `text` is string of text to score 

returns a dictionary containing the sentiment score split up into compound, positive, negative and neutral components.

An run of sentences from _Moby Dick_:

```q
q).nlp.sentiment each ("Three cheers,men--all hearts alive!";"No,no! shame upon all cowards-shame upon them!")
compound   pos       neg       neu
----------------------------------------
0.7177249  0.5996797 0         0.4003203
-0.8802318 0         0.6910529 0.3089471
```
