---
title: Iterators in q | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Iterators in kdb+ and q
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Table operations (qSQL)


This section assumes you have some some familiarity with SQL. Q provides
a powerful dialect of SQL. 

!!! tip "In a script the first line of a qSQL query must be outdented, and continuation lines indented."

The basic syntax is:

```txt
select .. by .. from .. where ..
```

The From clause contains only one table, but this does not prevent joins, provided they are foreign-key joins. To understand foreign keys, consider the
following example.

A publisher has many authors. It holds author information in one table: author (author, name, address) where author is the key. Each author may have several books in print: bookauthor (book, author, …) where book and author together are a key, so that we can handle the case that a book has several authors and that an author has written several books.

Now, the publisher wants to send notices, checks, reviews and other good news about a book to its authors. For this to be possible, every author in the book table must have an entry in the author table. We say that “book.author is a foreign key for author”. It is foreign because it is in another table and it is a key because author is a key of the author table, i.e. no two rows can have
the same author ID. 

<i class="far fa-map"></i>
[The application of foreign keys and linked columns in kdb+](../../wp/foreign-keys.md)

With that understanding, we can present the following script:

```q
/ This example must be loaded as a file.
/ So copy it to a file, say foo.q.

/ Be careful to keep the indentations:
/ First line of an expression must not be indented; others must be.

/ Then type
/ q foo.q

/ Remember that keys are surrounded by brackets
author:([author:`king`hemingway`flaubert`lazere`shasha]
  address: `maine`expat`france`mamaroneck`newyork;
  area: `horror`suffering`psychology`journalism`puzzles)

book:([book:`forwhomthebelltolls`oldmanandthesea`shining`secretwindow`clouds`madambovary`salambo`outoftheirminds]
  language: `english`english`english`english`english`french`french`english;
  numprintings: 3 5 4 2 2 8 9 2)

/ Here we indicate that the author field is a foreign key to the table
/ author and book to the table book.
/ If we wished, we could also surround the two fields author and book
/ by brackets to indicate that they are keys.
bookauthor:([]
  author:`author$`hemingway`hemingway`king`king`king`flaubert`flaubert`shasha`lazere;
  book:`book$`forwhomthebelltolls`oldmanandthesea`shining`secretwindow`clouds`madambovary`salambo`outoftheirminds`outoftheirminds;
  numfansinmillions: 20 20 50 50 30 60 30 0.02 0.02)

/ SQL 92: select * from bookauthor
select from bookauthor

/ SQL 92: identical to this except that we use the symbol notation
select numfansinmillions from bookauthor where book=`forwhomthebelltolls
select author,numfansinmillions from bookauthor where book=`forwhomthebelltolls

/ Implicit join via the foreign key.
/ SQL92:
/ select bookauthor.author, book.language
/ from bookauthor, book
/ where book.book = bookauthor.book
/ and numfansinmillions< 30
select author,book.language from bookauthor where numfansinmillions< 30

/ Same idea, but note the outdented first line followed
/ by the indented later lines.
/ SQL92:
/ select bookauthor.author, book.language, author.address
/ from bookauthor, book, author
/ where book.book = bookauthor.book
/ and author.author = bookauthor.author
/ and author.area = "psychology"
select author,book.language,author.address
   from bookauthor
   where author.area = `psychology

/ SQL92:
/ select distinct bookauthor.author, book.language, author.address
/ from bookauthor, book author
/ where book.book = bookauthor.book
/ and author.author = bookauthor.author
/ and author.area = "psychology"
select distinct author,book.language,author.address
  from bookauthor
  where author.area = `psychology

/ Here we are doing implicit joins and also an implicit groupby
/ SQL92:
/ select book.language, sum(numfansinmillions)
/ from bookauthor, book
/ where bookauthor.book = book.book
/ group by book.language
select sum numfansinmillions by book.language from bookauthor
```

<i class="fas fa-book"></i>
[`$` Enumerate](../../ref/enumerate.md)
<br>
<i class="fas fa-book-open"></i>
[qSQL](../../basics/qsql.md),
[`\l` Load command](../../basics/syscmds.md#l-load-file-or-directory)


---
<i class="far fa-hand-point-right"></i>
[Semantic extensions to SQL](extensions-to-sql.md)