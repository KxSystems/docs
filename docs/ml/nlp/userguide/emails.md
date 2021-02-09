---
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---

# :fontawesome-solid-share-alt: Emails

<div markdown="1" class="typewriter">
.nlp.email   **Emails**
  loadEmails   an MBOX file as a table of parsed metadata
  getGraph     graph of who emailed whom, and how often
  parseMail    an email parsed in string format
</div>

One of the most important document formats for analysis in natural-language processing is emails, particularly for surveillance, and spam detection. The following functions form a basis for the handling of email-format data.


## `.nlp.email.getGraph`

_Get the graph of who emailed who, including the number of times they emailed_

Syntax: `.nlp.email.getGraph[emails]`

Where `emails` is a table (result from `.nlp.email.loadEmails`)

returns a table of to-from pairing.

```q
q).nlp.email.getGraph[emails]

sender                           to                               volume
------------------------------------------------------------------------
Donald.Hobern@csiro.au           tdwg-img@lists.tdwg.org          1
Donald.Hobern@csiro.au           tdwg@lists.tdwg.org              1
Donald.Hobern@csiro.au           vchavan@gbif.org                 1
RichardsK@landcareresearch.co.nz tdwg-img@lists.tdwg.org          1
Robert.Morris@cs.umb.edu         Tdwg-tag@lists.tdwg.org          1
Robert.Morris@cs.umb.edu         tdwg-img@lists.tdwg.org          1
mdoering@gbif.org                lee@blatantfabrications.com      1
mdoering@gbif.org                tdwg-img@lists.tdwg.org          1
morris.bob@gmail.com             tdwg-img@lists.tdwg.org          1
ram@cs.umb.edu                   RichardsK@landcareresearch.co.nz 1
ram@cs.umb.edu                   tdwg-img@lists.tdwg.org          2
ricardo@tdwg.org                 a.rissone@nhm.ac.uk              3
ricardo@tdwg.org                 leebel@netspace.net.au           3
ricardo@tdwg.org                 tdwg-img@lists.tdwg.org          3
ricardo@tdwg.org                 tdwg-lit@lists.tdwg.org          3
ricardo@tdwg.org                 tdwg-obs@lists.tdwg.org          3
ricardo@tdwg.org                 tdwg-process@lists.tdwg.org      3
ricardo@tdwg.org                 tdwg-tag@lists.tdwg.org          3
ricardo@tdwg.org                 tdwg-tapir@lists.tdwg.org        3
roger@tdwg.org                   Tdwg-img@lists.tdwg.org          1
```

## `.nlp.email.loadEmails`

_Convert an mbox file to a table of parsed metadata_

Syntax: `.nlp.email.loadEmails[filepath]`

Where `filepath` is a string of the path to the mbox file

returns a table containing parsed metadata and content of the mbox file.

column      | type                           | content
------------|--------------------------------|---------------------------
sender      | string                         | name and address of sender
to          | string                         | name and address of receiver/s
date        | timestamp                      | date
subject     | string                         | subject
text        | string                         | original text
contentType | string                         | content type
payload     | string or list of dictionaries | payload

The MBOX file is the most common format for storing email messages on a hard drive. All the messages for each mailbox are stored as a single, long, text file in a string of concatenated e-mail messages, starting with the _From_ header of the message. 

```q
q)email:.nlp.email.loadEmails["/home/kx/nlp/datasets/tdwg.mbox"]
q)cols email
`sender`to`date`subject`contentType`payload`text
```


## `.nlp.email.parseMail`

_Extract meta information from an email_

Syntax: `.nlp.email.parseMail[filepath]`

Where 

`filepath` is the path to where the email is stored

returns a dictionary containing meta information from the email.

```q
q)emailstring:"/home/kx/nlp/datasets/tdwg.mbox"
q)table:.nlp.email.parseMail emailString
q)cols table
`sender`to`date`subject`contentType`payload
```
