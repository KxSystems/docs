---
title: Natural-language processing
description: The natural-language processing (NLP) library can be used to answer a variety of questions about unstructured text data, as well as facilitating open-ended exploration.
author: Fionnuala Carr
date: August 2018
keywords: algorithm, analysis, bisecting, centroid, cluster, clustering, comparison, corpora, corpus, document, email, feature, file, k-mean, kdbplus, learning, library, machine, machine learning, mbox, message, ml, nlp, parse, parsing, q, sentiment, similarity, string function, vector
---
# <i class="fas fa-share-alt"></i> Natural-language processing 



Natural-language processing (NLP) can be used to answer a variety of questions about unstructured text data, as well as facilitating open-ended exploration.

It can be applied to datasets such as emails, online articles and comments, tweets or novels. Although the source is text, transformations are applied to convert this data to vectors, dictionaries and symbols which can be handled very effectively by q. Many operations such as searching, clustering, and keyword extraction can all be done using very simple data structures, such as feature vectors and bag-of-words representations.

## Requirements

The following requirements cover those needed to initialize running of the NLP library

-   [embedPy](../embedpy/index.md)

A number of Python dependencies also exist for this library. These can be installed as outlined at

<i class="fab fa-github"></i>
[KxSystems/nlp](https://github.com/kxsystems/nlp)
using Pip

```bash
$ pip install -r requirements.txt
```

or via Conda

```bash
$ conda install --file requirements.txt
```

Besides those installed via the above code there is also a requirement that the English model be downloaded for Spacy:

```bash
$ python -m spacy download en
```


## Installation

The library is available from
<i class="fab fa-github"></i> [KxSystems/nlp](https://github.com/kxsystems/nlp)

Alternatively the library is available as a Docker image.

If you have [Docker installed](https://www.docker.com/products/docker-engine) you can run:

```bash
$ docker run -it --name mynlp kxsys/nlp
kdb+ on demand - Personal Edition

[snipped]

I agree to the terms of the license agreement for kdb+ on demand Personal Edition (N/y): y

If applicable please provide your company name (press enter for none): ACME Limited
Please provide your name: Bob Smith
Please provide your email (requires validation): bob@example.com
KDB+ 3.5 2018.04.25 Copyright (C) 1993-2018 Kx Systems
l64/ 4()core 7905MB kx 0123456789ab 172.17.0.2 EXPIRE 2018.12.04 bob@example.com KOD #0000000

Loading utils.q
Loading regex.q
Loading sent.q
Loading parser.q
Loading time.q
Loading date.q
Loading email.q
Loading cluster.q
Loading nlp.q
q).nlp.findTimes"I went to work at 9:00am and had a coffee at 10:20"
09:00:00.000 "9:00am" 18 24
10:20:00.000 "10:20"  45 50
```

<i class="fab fa-github"></i>
[Build instructions for the NLP Docker image](https://github.com/KxSystems/nlp/blob/master/docker/README.md)
