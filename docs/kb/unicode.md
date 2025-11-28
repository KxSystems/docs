---
title: Unicode – Knowledge Base – kdb+ and q documentation
description: How-to handle Unicode-encoded data in kdb+
keywords: byte, character, kdb+, q, text, unicode
---
# Unicode

Unicode text can be stored in symbol, byte list and character list (string) datatypes.

Since the data is simply a sequence of bytes, any Unicode format can be stored. 
However, it is best to use an encoding such as UTF-8 or GBK that extends 7-bit ASCII, i.e. a single byte in the range `00`–`7f` means the same thing in ASCII. 

The display console should have the matching code page set or you will not be able to view the data correctly.
For example, if you store in UTF-8 format, ensure that your code page for the display is also UTF-8.

## Examples processing Unicode data

### Storing UTF-8 in a char vector

The two Chinese characters "香蕉" each use 3 bytes in UTF-8. 
In this example, the two chinese characters are stored in a char vector, which is then shown to using six 1-byte characters (i.e. 2 x 3 bytes). 
[Comparison](../ref/match.md) with the original UTF-8 characters return true.
Contents are printed in octal format, showing the 6 bytes.
When printed to stdout via [`-1`](../basics/handles.md#file-stdout-stderr), the UTF-8 representation of the characters are shown.

```q
q)t:"香蕉"
q)type t
10h
q)count t
6
q)t
"\351\246\231\350\225\211"
q)t~"香蕉"
1b
q)-1 t;
香蕉
```


### Storing data in tables

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

Writing to stdout with [`-1`](../basics/handles.md#file-stdout-stderr) shows the formatted text:

```q
q)-1 text 0;
每日一蘋果, 醫生遠離我
```

### Using external interfaces

Sending non-ascii data can be done using the various programming interfaces, such as C or Python.

The following example using the [C interface](../interfaces/capiref.md) connects over TCP and sets two variables, each being char vectors representing UTF-8 strings.

```c
int main(){
  int c=khp("localhost",5001);
  k(c,"set",ks("a"),kp("香蕉"),(K)0);
  k(c,"set",ks("b"),kp("\351\246\231\350\225\211"),(K)0);
  close(c);
}
```

## Using Unicode scripts or statements

kdb+ will load a script with such encoding, but it will not load other formats. Note that if using these encodings, avoid having a byte-order-mark prefix on the data.

The q language itself uses only 7-bit ASCII. 
For example, the statement `2+3` should be given as the three decimal bytes 50 43 51, as in:

```q
q)`char$50 43 51
"2+3"
```
Using [`value`](../ref/value.md) to evaluate the statement `2+3` results in 5:
```q
q)value `char$50 43 51
5
```
Fixed-width Unicode formats cannot be used, since for example, in UTF-16, `2+3` would be the six decimal bytes 50 0 43 0 51 0, and q does not recognize this:

```q
q)value `char$50 0 43 0 51 0
'char
```


