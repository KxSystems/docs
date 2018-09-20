---
hero: <i class="fa fa-share-alt"></i> Machine learning
keywords: email, kdb+, learning, machine, nlp, parse, parsing, q, string
---

# Parsing emails from a string format 


### `.nlp.email.parseMail`

_Parses an email in string format_

Syntax: `.nlp.email.parseMail x`

Where `x` is an email in a string format, returns a dictionary of the headers and content.

```q
q)table:.nlp.email.parseMail emailString
q)table 
`headers`content
```


