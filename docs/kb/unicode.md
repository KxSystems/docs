---
title: Unicode
description: Howto handle Unicode-encoded data in kdb+
keywords: byte, character, kdb+, q, text, unicode
---
# Unicode





Unicode text can be stored in symbol, byte and character datatypes.

Since the data is simply a sequence of bytes, any Unicode format can be stored. However, it is best to use an encoding such as UTF-8 or GBK that extends 7-bit ASCII, i.e. a single byte in the range 00–7f means the same thing in ASCII. Kdb+ will load a script with such encoding, but it will not load other formats. Note that if using these encodings, avoid having a byte-order-mark prefix on the data.

The q language itself uses only 7-bit ASCII. For example, the statement `2+3` should be given as the three decimal bytes 50 43 51, as in:

```q
q)`char$50 43 51
"2+3"
q)value `char$50 43 51
5
```

Fixed-width Unicode formats cannot be used, since for example, in UTF-16, `2+3` would be the six decimal bytes 50 0 43 0 51 0, and q does not recognize this:

```q
q)value `char$50 0 43 0 51 0
'char
```

The display console should have the matching code page set or you will not be able to view the data correctly. e.g. if you store in UTF-8 format, ensure that your code page for the display is also UTF-8.

Table and column names should be plain ASCII.

For example, the following has Chinese characters in symbol and character columns:

```q
sym:`apples`bananas`oranges
name:(`$"蘋果";`$"香蕉";`$"橙")
text:("每日一蘋果, 醫生遠離我";"香蕉船是一道可口的甜品";"從佛羅里達州來的鮮橙很甜美")
t:([]sym;name;text)
```

You can work with this table as usual, but note that the q console displays the text entries as their octal character numbers:

```q
q)select sym,name from t
sym     name
--------------
apples  蘋果
bananas 香蕉
oranges 橙

q)select from t where name=`$"香蕉"
sym     name   text                                      ..
---------------------------------------------------------..
bananas 香蕉 "\351\246\231\350\225\211\350\210\271\346\..
```

Display with `-1` to show formatted text:

```q
q)-1 text 0;
每日一蘋果, 醫生遠離我
```

Example assignments using the C interface:

```c
int main(){
  int c=khp("localhost",5001);
  k(c,"set",ks("a"),kp("香蕉"),(K)0);
  k(c,"set",ks("b"),kp("\351\246\231\350\225\211"),(K)0);
  close(c);
}
```

