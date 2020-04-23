---
keywords: api, interface, kdb+, library, q, scala
---

# ![Scala](img/scala.png) Scala client for kdb+


Download 
:fontawesome-brands-github: [KxSystems/kdb/c/kx/c.java](https://github.com/KxSystems/kdb/blob/master/c/kx/c.java) to subfolder `kx` and compile it.

```bash
$ javac kx/c.java
```

Create a file `a.scala` containing

```scala
object KxTest {
 def main(args: Array[String])
 {
      val conn=new kx.c("localhost",5001)
      println(conn k("2+2"))
      conn close
 }
}
KxTest.main(null)
```

Start a kdb+ process listening on port 5001, e.g.

```bash
$ q -p 5001
```

and execute the above program using

```ash
$ scala -cp . a.scala
```

and it should print `4`.
