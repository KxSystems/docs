---
hero: <i class="fa fa-share-alt"></i> Machine learning
keywords: file, kdb+, learning, machine, mbox, message, nlp, q
---

# Importing and parsing MBOX files 




The MBOX file is the most common format for storing email messages on a hard drive. All the messages for each mailbox are stored as a single, long, text file in a string of concatenated e-mail messages, starting with the _From_ header of the message. The NLP library allows the user to import these files and creates a kdb+ table. 


Column        | Type                              | Content
--------------|-----------------------------------|---------------------------
`sender`      | list of characters                | The name and email address of the sender
`to`          | list of characters                | The name and email address of the reciever/recievers
`date`        | timestamp                         | The date
`subject`     | list of characters                | The subject of the email
`text`        | list of characters                | The original text of the email
`contentType` | list of characters                | The content type of the email
`payload`     | list of characters or dictionaries| The payload of the email


### `.nlp.loadEmails`

_An MBOX file as a table of parsed metadata_

Syntax: `.nlp.loadEmails x`

Where `x` is a string of the filepath, returns a table.

```q
q)email:.nlp.loadEmails["/home/kx/nlp/datasets/tdwg.mbox"]
q)cols email
`sender`to`date`subject`contentType`payload`text
```


### `.nlp.email.getGraph`

_Graph of who emailed whom, with the number of times they emailed_

Syntax: `.nlp.email.getGraph x`

Where `x` is a table (result from `.nlp.email.i.parseMbox`), returns a table of to-from pairing.

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


