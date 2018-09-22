hero: <i class="fa fa-cloud"></i> Cloud


# Historical data layouts and performance testing

The typical kdb+ database layout for a stock tick-based system is
partitioned by date, although integer partitioning is also possible.
Partitioning allows for quicker lookup and increases the ability to
parallelize queries. Kdb+ splays in-memory table spaces into
representative directories and files for long-term retention. Here is
an example of an on-disk layout for quote and trade tables, with date
partitions:

<style type="text/css">
  .foo {
    float: right;
    margin: 0 0 1em 1em;
  }
</style>
![On-disk layout for quote and trade tables with date
partitions](img/media/image5.jpg){.foo}

Usually, updates to the HDB are made by writing today’s or the last
day’s in-memory columns of data to a new HDB partition. Q programmers
can use a utility built into q for this which creates the files and
directories organized as in the table above. Kdb+ requires the support
of a POSIX-compliant file system in order to access and process HDB
data.

Kdb+ maps the entire HDB into the runtime address space of kdb+. This
means the Linux kernel is responsible for fetching HDB data. If,
for example, you are expecting a query that scans an entire day’s trade
price for a specific stock symbol range, the file system will load this
data into the host memory as required. So, for porting this to EC2, if
you expect it to match the performance you see on your in-house
infrastructure you will need to look into the timing differences between
this and EC2.

Our testing measured the time to load and unload data from arrays,
ignoring the details of structuring columns, partitions and segments –
we focused on just the raw throughput measurements.

All of these measurements will directly correlate to the final
operational latencies for your full analytics use-case, written in q. In
other words, if a solution reported here shows throughput of 100&nbsp;MB/sec
for solution A, and shows 200&nbsp;MB/sec for solution B, this will reflect
the difference in time to complete the data fetch from backing store. Of
course, as with any solution, you get what you pay for, but the
interesting question is: how much more could you get within the
constraints of one solution?

To give an example: assuming a retrieval on solution A takes 50 ms for a
query comprised of 10 ms to compute against the data, and 40 ms to fetch
the data, with half the throughput rates, it might take 90 ms (10+80) to
complete on solution B. Variations may be seen depending on metadata and
random read values.

This is especially important for solutions that use networked file
systems to access a single namespace that contains your HDB. This may
well exhibit a significantly different behavior when run at scale.


