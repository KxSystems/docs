---
title: Searching Kx documentation site
description: How to use the custom search tool on the Kx documentation site
author: Stephen Taylor
keywords: kdb+, keyword, namespace, operator, overload, q, search, space, term
---
# Search




Our search engine is customized to the q language. 

**Operators** are recognized: a search for `*` becomes a search for `Multiply`. 

A search for an **overloaded** operator such as `@` takes you to a disambiguation table. 

Kx **namespaces** are recognized: a search for `.z.pd` takes you to the `.z` page.

By default, searches ignore the content of code listings and inline code elements.

You can direct a search to **code elements**. Prefix your search term with `code:` and the engine will search only code blocks, inline code elements, and headings. So, a search for `code:compress` will ignore the word _compress_ in body text. 

A search for a **keyword** is always performed as a code search. For example a search for `and` looks only in page titles, headings, inline code elements and code listings. 

Our search engine is designed for single words, keywords and symbols. If your query contains **spaces** it will be handled by Google Search.