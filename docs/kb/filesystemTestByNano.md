# Choosing the Right File System for kdb+: A Case Study with KX Nano

The performance of a kdb+ system is critically dependent on the throughput and latency of its underlying storage. In a Linux environment, the file system is the foundational layer that enables data management on a given storage partition.

This paper presents a comparative performance analysis of various file systems using the [KX Nano](https://github.com/KxSystems/nano) benchmarking utility. The evaluation was conducted across two distinct test environments, each with different operating systems and storage bandwidth (6500 vs 14000 MB/s) and IOPS (700K vs 2500K).

File systems tested:

   1. ext4 (rev 1)
   2. XFS (V5)
   3. Btrfs (v6.6.3, compression off)
   4. F2FS (v1.16.0, compression off)
   5. ZFS (c2.2.2, compression off)

### Summary

No single file system demonstrated superior performance across all tested metrics; the optimal choice depends on the primary workload characteristics. The optimal choice depends on the specific operations you need to accelerate. Furthermore, the host operating system (e.g., Red Hat Enterprise Linux vs. Ubuntu) constrains the set of available and supported file systems.

Our key recommendations are as follows:

   * For **write-intensive workloads** where **data ingestion rate is the primary driver**, XFS is the recommended file system.
      * XFS consistently demonstrated the highest write throughput, particularly under concurrent write scenarios. For instance, a kdb+ [set](https://code.kx.com/q/ref/get/#set) operation on a large float vector (31 million elements) executed **5.6x faster on XFS than on ext4** and nearly **70x faster than on ZFS**.
      * This superior write performance **translates to significant speedups** in other I/O-heavy operations. Parallel disk sorting was **3.1x faster**, and applying the `p#` (parted) attribute was **6.9x faster** on XFS compared to ext4. Consequently, workloads like end-of-day (EOD) data processing will achieve the best performance with XFS.

   * For **read-intensive workloads** where **query latency is paramount**, the choice is nuanced:
      * On Red Hat Enterprise Linux 9, ext4 holds a slight advantage for queries dominated by **sequential reads**. For random reads, its performance was comparable to XFS.
      * On Ubuntu, **F2FS demonstrated a performance margin** in random read operations. However, this advantage shifted decisively to XFS when the data was already resident in the operating system's page cache.

kdb+ also supports **tiering**. For tiered data architectures (e.g., hot, mid, cold tiers), a hybrid approach is advisable.

   * **Hot tier**: Data is frequently queried and often resides in the page cache. For this tier, a read-optimized file system like ext4 or XFS is effective.
   * **Mid Tier**: Data is queried less often, meaning reads are more likely to come directly from storage. In this scenario, F2FS's stronger random read performance from storage provides some advantage.
   * **Cold Tier**: Data is typically compressed and stored on high-latency, cost-effective media like HDDs or object storage. While kdb+ has built-in compression support, file systems like Btrfs, F2FS, and ZFS also offer this feature. The performance implications of file-system-level compression warrant a separate, dedicated study.

**Disclaimer**: These guidelines are specific to the tested hardware and workloads. We strongly encourage readers to perform their own benchmarks that reflect their specific application profiles. To facilitate this, the benchmarking suite used in this study is [included with the KX Nano codebase](https://github.com/KxSystems/nano/tree/master/scripts/fsBenchmark), available on GitHub.

### Details

All benchmarks were executed in September 2025 using kdb+ 4.1 (2025.04.28) and [KX Nano 6.4.5](https://github.com/KxSystems/nano/releases/tag/v6.4.5). Each kdb+ process was configured to use 8 worker threads (`-s 8`).

We used the default vector length of KX Nano, which are:

      * tiny: 2047
      * small: 63k
      * medium: 127k
      * large: 31m
      * huge: 1000m

## Test 1: Red Hat Enterprise Linux 9 with Intel NVMe SSD (PCIe 4.0)

This first test configuration utilized an Intel NVMe SSD on a server running Red Hat Enterprise Linux (RHEL) 9.3. Following RHEL 9's [official supported](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/managing_file_systems/index) file systems, the comparison was limited to **ext4** and **XFS**.

### Test Setup

| Component	| Specification|
| --- | --- |
| Storage | * **Type**: 3.84 TB [Intel SSD D7-P5510](https://www.solidigmtechnology.com/products/data-center/d7/p5510.html) <br/>    * **Interface**: PCIe 4.0 x4, NVMe <br> * **Sequential R/W**: 6500 MB/s / 3400 MB/s <br/> * **Random Read**: 700K IOPS (4K) </br> * **Latency**: Random Read: 82 µs (4K), Sequential Read / Write: 10 µs / 13 µs (4K) |
| CPU | Intel(R) Xeon(R) [6747P](https://www.intel.com/content/www/us/en/products/sku/241825/intel-xeon-6747p-processor-288m-cache-2-70-ghz/specifications.html) (2 sockets, 48 cores per socket, 2 threads per core) |
| Memory | 502GiB, DDR5 @ 6400 MT/s |
| OS| RHEL 9.3 (kernel 5.14.0-362.8.1.el9_3.x86_64) |

The values presented in the result tables represent throughput in MB/s, where higher figures indicate better performance. The "Ratio" column quantifies the performance of XFS relative to ext4 (e.g., a value of 2 indicates XFS was twice as fast).

### Write

We split the write results into two tables. The first table contains the "high-impact" tests and should be considered with more weight. These test are related to EOD (write, sort, applying attribute) and EOI (append) works that is often the bottleneck of ingestion.


#### Single kdb+ process:

<style type="text/css">
#T_ce0e9 th, #T_ce0e9 td,
#T_5ec32 th, #T_5ec32 td,
#T_12a7e th, #T_12a7e td,
#T_294aa th, #T_294aa td,
#T_690b7 th, #T_690b7 td,
#T_65b19 th, #T_65b19 td,
#T_5f1d5 th, #T_5f1d5 td,
#T_d0109 th, #T_d0109 td,
#T_e1132 th, #T_e1132 td,
#T_38c70 th, #T_38c70 td,
#T_7df70 th, #T_7df70 td,
#T_b2eac th, #T_b2eac td,
#T_6be41 th, #T_6be41 td,
#T_22d49 th, #T_22d49 td,
#T_1214c th, #T_1214c td,
#T_5f94e th, #T_5f94e td{
  padding: 2px 4px;
	font-size: 12px;
	min-width: 30px;
}


<style type="text/css">
#T_ce0e9 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_ce0e9_row0_col2 {
  background-color: #f2FFf2;
  color: black;
}
#T_ce0e9_row1_col2 {
  background-color: #f5FFf5;
  color: black;
}
#T_ce0e9_row2_col2 {
  background-color: #ecFFec;
  color: black;
}
#T_ce0e9_row3_col2 {
  background-color: #f3FFf3;
  color: black;
}
#T_ce0e9_row4_col2 {
  background-color: #ccFFcc;
  color: black;
}
#T_ce0e9_row5_col2, #T_ce0e9_row6_col2 {
  background-color: #d3FFd3;
  color: black;
}
#T_ce0e9_row7_col2 {
  background-color: #FFd5d5;
  color: black;
}
#T_ce0e9_row8_col2, #T_ce0e9_row11_col2 {
  background-color: #bdFFbd;
  color: black;
}
#T_ce0e9_row9_col2 {
  background-color: #f0FFf0;
  color: black;
}
#T_ce0e9_row10_col2 {
  background-color: #e4FFe4;
  color: black;
}
</style>
<table id="T_ce0e9">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_ce0e9_level0_col0" class="col_heading level0 col0" >XFS (MB/s)</th>
      <th id="T_ce0e9_level0_col1" class="col_heading level0 col1" >ext4 (MB/s)</th>
      <th id="T_ce0e9_level0_col2" class="col_heading level0 col2" >Ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_ce0e9_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_ce0e9_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_ce0e9_row0_col0" class="data row0 col0" >259</td>
      <td id="T_ce0e9_row0_col1" class="data row0 col1" >231</td>
      <td id="T_ce0e9_row0_col2" class="data row0 col2" >1.12</td>
    </tr>
    <tr>
      <th id="T_ce0e9_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_ce0e9_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_ce0e9_row1_col0" class="data row1 col0" >105</td>
      <td id="T_ce0e9_row1_col1" class="data row1 col1" >97</td>
      <td id="T_ce0e9_row1_col2" class="data row1 col2" >1.09</td>
    </tr>
    <tr>
      <th id="T_ce0e9_level0_row2" class="row_heading level0 row2" rowspan="8">write disk</th>
      <th id="T_ce0e9_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_ce0e9_row2_col0" class="data row2 col0" >1038</td>
      <td id="T_ce0e9_row2_col1" class="data row2 col1" >870</td>
      <td id="T_ce0e9_row2_col2" class="data row2 col2" >1.19</td>
    </tr>
    <tr>
      <th id="T_ce0e9_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_ce0e9_row3_col0" class="data row3 col0" >932</td>
      <td id="T_ce0e9_row3_col1" class="data row3 col1" >841</td>
      <td id="T_ce0e9_row3_col2" class="data row3 col2" >1.11</td>
    </tr>
    <tr>
      <th id="T_ce0e9_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_ce0e9_row4_col0" class="data row4 col0" >2170</td>
      <td id="T_ce0e9_row4_col1" class="data row4 col1" >1304</td>
      <td id="T_ce0e9_row4_col2" class="data row4 col2" >1.66</td>
    </tr>
    <tr>
      <th id="T_ce0e9_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_ce0e9_row5_col0" class="data row5 col0" >3338</td>
      <td id="T_ce0e9_row5_col1" class="data row5 col1" >2157</td>
      <td id="T_ce0e9_row5_col2" class="data row5 col2" >1.55</td>
    </tr>
    <tr>
      <th id="T_ce0e9_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_ce0e9_row6_col0" class="data row6 col0" >3070</td>
      <td id="T_ce0e9_row6_col1" class="data row6 col1" >1999</td>
      <td id="T_ce0e9_row6_col2" class="data row6 col2" >1.54</td>
    </tr>
    <tr>
      <th id="T_ce0e9_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_ce0e9_row7_col0" class="data row7 col0" >910</td>
      <td id="T_ce0e9_row7_col1" class="data row7 col1" >1119</td>
      <td id="T_ce0e9_row7_col2" class="data row7 col2" >0.81</td>
    </tr>
    <tr>
      <th id="T_ce0e9_level1_row8" class="row_heading level1 row8" >write int tiny</th>
      <td id="T_ce0e9_row8_col0" class="data row8 col0" >100</td>
      <td id="T_ce0e9_row8_col1" class="data row8 col1" >50</td>
      <td id="T_ce0e9_row8_col2" class="data row8 col2" >2.01</td>
    </tr>
    <tr>
      <th id="T_ce0e9_level1_row9" class="row_heading level1 row9" >write sym large</th>
      <td id="T_ce0e9_row9_col0" class="data row9 col0" >1480</td>
      <td id="T_ce0e9_row9_col1" class="data row9 col1" >1289</td>
      <td id="T_ce0e9_row9_col2" class="data row9 col2" >1.15</td>
    </tr>
    <tr>
      <th id="T_ce0e9_level0_row10" class="row_heading level0 row10" >GEOMETRIC MEAN</th>
      <th id="T_ce0e9_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_ce0e9_row10_col0" class="data row10 col0" >776</td>
      <td id="T_ce0e9_row10_col1" class="data row10 col1" >605</td>
      <td id="T_ce0e9_row10_col2" class="data row10 col2" >1.28</td>
    </tr>
    <tr>
      <th id="T_ce0e9_level0_row11" class="row_heading level0 row11" >MAX RATIO</th>
      <th id="T_ce0e9_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_ce0e9_row11_col0" class="data row11 col0" >3338</td>
      <td id="T_ce0e9_row11_col1" class="data row11 col1" >2157</td>
      <td id="T_ce0e9_row11_col2" class="data row11 col2" >2.01</td>
    </tr>
  </tbody>
</table>






**Observation**: XFS is almost always faster than ext4. **In critical tests, the advantage is almost 28%** on average with a **maximal difference  101%**.

The performance of the less critical write operations is below. The Linux `sync` command synchronizes cached data to permanent storage. This data includes modified superblocks, modified inodes, delayed reads and writes, and others. EOD and EOI solutions often use `sync` operations to improve resiliency by ensuring data is persisted to storage and not held temporarily in caches. The `sync` operation is typically much faster than the `set` command because Linux executes it behind the scenes (compare the speed of `write float large` and `sync float large`). The throughput for `sync` operation is not always helpful because `sync` does not necessarily need to handle the entire vector.






<style type="text/css">
#T_5ec32 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_5ec32_row0_col2, #T_5ec32_row22_col2 {
  background-color: #d2FFd2;
  color: black;
}
#T_5ec32_row1_col2 {
  background-color: #d6FFd6;
  color: black;
}
#T_5ec32_row2_col2 {
  background-color: #efFFef;
  color: black;
}
#T_5ec32_row3_col2 {
  background-color: #FFf5f5;
  color: black;
}
#T_5ec32_row4_col2 {
  background-color: #FFfdfd;
  color: black;
}
#T_5ec32_row5_col2, #T_5ec32_row18_col2 {
  background-color: #f9FFf9;
  color: black;
}
#T_5ec32_row6_col2 {
  background-color: #eeFFee;
  color: black;
}
#T_5ec32_row7_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_5ec32_row8_col2 {
  background-color: #FFf8f8;
  color: black;
}
#T_5ec32_row9_col2 {
  background-color: #f8FFf8;
  color: black;
}
#T_5ec32_row10_col2 {
  background-color: #FF2121;
  color: white;
}
#T_5ec32_row11_col2, #T_5ec32_row19_col2 {
  background-color: #e5FFe5;
  color: black;
}
#T_5ec32_row12_col2, #T_5ec32_row17_col2 {
  background-color: #fbFFfb;
  color: black;
}
#T_5ec32_row13_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_5ec32_row14_col2 {
  background-color: #f7FFf7;
  color: black;
}
#T_5ec32_row15_col2 {
  background-color: #ebFFeb;
  color: black;
}
#T_5ec32_row16_col2 {
  background-color: #f1FFf1;
  color: black;
}
#T_5ec32_row20_col2 {
  background-color: #f6FFf6;
  color: black;
}
#T_5ec32_row21_col2 {
  background-color: #FFe2e2;
  color: black;
}
</style>
<table id="T_5ec32">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_5ec32_level0_col0" class="col_heading level0 col0" >XFS (MB/s)</th>
      <th id="T_5ec32_level0_col1" class="col_heading level0 col1" >ext4 (MB/s)</th>
      <th id="T_5ec32_level0_col2" class="col_heading level0 col2" >Ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_5ec32_level0_row0" class="row_heading level0 row0" rowspan="21">write disk</th>
      <th id="T_5ec32_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_5ec32_row0_col0" class="data row0 col0" >753</td>
      <td id="T_5ec32_row0_col1" class="data row0 col1" >484</td>
      <td id="T_5ec32_row0_col2" class="data row0 col2" >1.55</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_5ec32_row1_col0" class="data row1 col0" >549</td>
      <td id="T_5ec32_row1_col1" class="data row1 col1" >368</td>
      <td id="T_5ec32_row1_col2" class="data row1 col2" >1.49</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_5ec32_row2_col0" class="data row2 col0" >937</td>
      <td id="T_5ec32_row2_col1" class="data row2 col1" >812</td>
      <td id="T_5ec32_row2_col2" class="data row2 col2" >1.15</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_5ec32_row3_col0" class="data row3 col0" >200</td>
      <td id="T_5ec32_row3_col1" class="data row3 col1" >210</td>
      <td id="T_5ec32_row3_col2" class="data row3 col2" >0.96</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row4" class="row_heading level1 row4" >open replace int tiny</th>
      <td id="T_5ec32_row4_col0" class="data row4 col0" >261</td>
      <td id="T_5ec32_row4_col1" class="data row4 col1" >263</td>
      <td id="T_5ec32_row4_col2" class="data row4 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row5" class="row_heading level1 row5" >open replace random float large</th>
      <td id="T_5ec32_row5_col0" class="data row5 col0" >16</td>
      <td id="T_5ec32_row5_col1" class="data row5 col1" >15</td>
      <td id="T_5ec32_row5_col2" class="data row5 col2" >1.05</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row6" class="row_heading level1 row6" >open replace random int huge</th>
      <td id="T_5ec32_row6_col0" class="data row6 col0" >5</td>
      <td id="T_5ec32_row6_col1" class="data row6 col1" >4</td>
      <td id="T_5ec32_row6_col2" class="data row6 col2" >1.16</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row7" class="row_heading level1 row7" >open replace random int medium</th>
      <td id="T_5ec32_row7_col0" class="data row7 col0" >561</td>
      <td id="T_5ec32_row7_col1" class="data row7 col1" >550</td>
      <td id="T_5ec32_row7_col2" class="data row7 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row8" class="row_heading level1 row8" >open replace random int small</th>
      <td id="T_5ec32_row8_col0" class="data row8 col0" >784</td>
      <td id="T_5ec32_row8_col1" class="data row8 col1" >809</td>
      <td id="T_5ec32_row8_col2" class="data row8 col2" >0.97</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row9" class="row_heading level1 row9" >open replace sorted int huge</th>
      <td id="T_5ec32_row9_col0" class="data row9 col0" >5</td>
      <td id="T_5ec32_row9_col1" class="data row9 col1" >5</td>
      <td id="T_5ec32_row9_col2" class="data row9 col2" >1.06</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row10" class="row_heading level1 row10" >sync column after parted attribute</th>
      <td id="T_5ec32_row10_col0" class="data row10 col0" >183027</td>
      <td id="T_5ec32_row10_col1" class="data row10 col1" >30812020</td>
      <td id="T_5ec32_row10_col2" class="data row10 col2" >0.01</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row11" class="row_heading level1 row11" >sync float large</th>
      <td id="T_5ec32_row11_col0" class="data row11 col0" >159533</td>
      <td id="T_5ec32_row11_col1" class="data row11 col1" >124762</td>
      <td id="T_5ec32_row11_col2" class="data row11 col2" >1.28</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row12" class="row_heading level1 row12" >sync float large after replace</th>
      <td id="T_5ec32_row12_col0" class="data row12 col0" >158292</td>
      <td id="T_5ec32_row12_col1" class="data row12 col1" >153759</td>
      <td id="T_5ec32_row12_col2" class="data row12 col2" >1.03</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row13" class="row_heading level1 row13" >sync int huge</th>
      <td id="T_5ec32_row13_col0" class="data row13 col0" >82528</td>
      <td id="T_5ec32_row13_col1" class="data row13 col1" >82383</td>
      <td id="T_5ec32_row13_col2" class="data row13 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row14" class="row_heading level1 row14" >sync int huge after replace</th>
      <td id="T_5ec32_row14_col0" class="data row14 col0" >1148164</td>
      <td id="T_5ec32_row14_col1" class="data row14 col1" >1076351</td>
      <td id="T_5ec32_row14_col2" class="data row14 col2" >1.07</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row15" class="row_heading level1 row15" >sync int huge after sorted replace</th>
      <td id="T_5ec32_row15_col0" class="data row15 col0" >1151184</td>
      <td id="T_5ec32_row15_col1" class="data row15 col1" >958083</td>
      <td id="T_5ec32_row15_col2" class="data row15 col2" >1.20</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row16" class="row_heading level1 row16" >sync int medium</th>
      <td id="T_5ec32_row16_col0" class="data row16 col0" >44866</td>
      <td id="T_5ec32_row16_col1" class="data row16 col1" >39724</td>
      <td id="T_5ec32_row16_col2" class="data row16 col2" >1.13</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row17" class="row_heading level1 row17" >sync int small</th>
      <td id="T_5ec32_row17_col0" class="data row17 col0" >6890</td>
      <td id="T_5ec32_row17_col1" class="data row17 col1" >6655</td>
      <td id="T_5ec32_row17_col2" class="data row17 col2" >1.04</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row18" class="row_heading level1 row18" >sync int tiny</th>
      <td id="T_5ec32_row18_col0" class="data row18 col0" >232</td>
      <td id="T_5ec32_row18_col1" class="data row18 col1" >221</td>
      <td id="T_5ec32_row18_col2" class="data row18 col2" >1.05</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row19" class="row_heading level1 row19" >sync sym large</th>
      <td id="T_5ec32_row19_col0" class="data row19 col0" >232276</td>
      <td id="T_5ec32_row19_col1" class="data row19 col1" >182916</td>
      <td id="T_5ec32_row19_col2" class="data row19 col2" >1.27</td>
    </tr>
    <tr>
      <th id="T_5ec32_level1_row20" class="row_heading level1 row20" >sync table after sort</th>
      <td id="T_5ec32_row20_col0" class="data row20 col0" >61306010</td>
      <td id="T_5ec32_row20_col1" class="data row20 col1" >56924120</td>
      <td id="T_5ec32_row20_col2" class="data row20 col2" >1.08</td>
    </tr>
    <tr>
      <th id="T_5ec32_level0_row21" class="row_heading level0 row21" >GEOMETRIC MEAN</th>
      <th id="T_5ec32_level1_row21" class="row_heading level1 row21" ></th>
      <td id="T_5ec32_row21_col0" class="data row21 col0" >5325</td>
      <td id="T_5ec32_row21_col1" class="data row21 col1" >6116</td>
      <td id="T_5ec32_row21_col2" class="data row21 col2" >0.87</td>
    </tr>
    <tr>
      <th id="T_5ec32_level0_row22" class="row_heading level0 row22" >MAX RATIO</th>
      <th id="T_5ec32_level1_row22" class="row_heading level1 row22" ></th>
      <td id="T_5ec32_row22_col0" class="data row22 col0" >61306010</td>
      <td id="T_5ec32_row22_col1" class="data row22 col1" >56924120</td>
      <td id="T_5ec32_row22_col2" class="data row22 col2" >1.55</td>
    </tr>
  </tbody>
</table>




#### 64 kdb+ processes:




<style type="text/css">
#T_12a7e th.col_heading.level0 {
  font-size: 1.5em;
}
#T_12a7e_row0_col2 {
  background-color: #75FF75;
  color: black;
}
#T_12a7e_row1_col2 {
  background-color: #9dFF9d;
  color: black;
}
#T_12a7e_row2_col2 {
  background-color: #FFfbfb;
  color: black;
}
#T_12a7e_row3_col2 {
  background-color: #f6FFf6;
  color: black;
}
#T_12a7e_row4_col2 {
  background-color: #7dFF7d;
  color: black;
}
#T_12a7e_row5_col2 {
  background-color: #FFfcfc;
  color: black;
}
#T_12a7e_row6_col2, #T_12a7e_row11_col2 {
  background-color: #6eFF6e;
  color: black;
}
#T_12a7e_row7_col2 {
  background-color: #82FF82;
  color: black;
}
#T_12a7e_row8_col2 {
  background-color: #FFe8e8;
  color: black;
}
#T_12a7e_row9_col2 {
  background-color: #96FF96;
  color: black;
}
#T_12a7e_row10_col2 {
  background-color: #a9FFa9;
  color: black;
}
</style>
<table id="T_12a7e">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_12a7e_level0_col0" class="col_heading level0 col0" >XFS (MB/s)</th>
      <th id="T_12a7e_level0_col1" class="col_heading level0 col1" >ext4 (MB/s)</th>
      <th id="T_12a7e_level0_col2" class="col_heading level0 col2" >Ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_12a7e_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_12a7e_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_12a7e_row0_col0" class="data row0 col0" >12858</td>
      <td id="T_12a7e_row0_col1" class="data row0 col1" >1876</td>
      <td id="T_12a7e_row0_col2" class="data row0 col2" >6.86</td>
    </tr>
    <tr>
      <th id="T_12a7e_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_12a7e_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_12a7e_row1_col0" class="data row1 col0" >2847</td>
      <td id="T_12a7e_row1_col1" class="data row1 col1" >903</td>
      <td id="T_12a7e_row1_col2" class="data row1 col2" >3.15</td>
    </tr>
    <tr>
      <th id="T_12a7e_level0_row2" class="row_heading level0 row2" rowspan="8">write disk</th>
      <th id="T_12a7e_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_12a7e_row2_col0" class="data row2 col0" >1347</td>
      <td id="T_12a7e_row2_col1" class="data row2 col1" >1368</td>
      <td id="T_12a7e_row2_col2" class="data row2 col2" >0.98</td>
    </tr>
    <tr>
      <th id="T_12a7e_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_12a7e_row3_col0" class="data row3 col0" >2300</td>
      <td id="T_12a7e_row3_col1" class="data row3 col1" >2118</td>
      <td id="T_12a7e_row3_col2" class="data row3 col2" >1.09</td>
    </tr>
    <tr>
      <th id="T_12a7e_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_12a7e_row4_col0" class="data row4 col0" >62892</td>
      <td id="T_12a7e_row4_col1" class="data row4 col1" >11133</td>
      <td id="T_12a7e_row4_col2" class="data row4 col2" >5.65</td>
    </tr>
    <tr>
      <th id="T_12a7e_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_12a7e_row5_col0" class="data row5 col0" >2455</td>
      <td id="T_12a7e_row5_col1" class="data row5 col1" >2488</td>
      <td id="T_12a7e_row5_col2" class="data row5 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_12a7e_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_12a7e_row6_col0" class="data row6 col0" >47404</td>
      <td id="T_12a7e_row6_col1" class="data row6 col1" >5879</td>
      <td id="T_12a7e_row6_col2" class="data row6 col2" >8.06</td>
    </tr>
    <tr>
      <th id="T_12a7e_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_12a7e_row7_col0" class="data row7 col0" >28002</td>
      <td id="T_12a7e_row7_col1" class="data row7 col1" >5433</td>
      <td id="T_12a7e_row7_col2" class="data row7 col2" >5.15</td>
    </tr>
    <tr>
      <th id="T_12a7e_level1_row8" class="row_heading level1 row8" >write int tiny</th>
      <td id="T_12a7e_row8_col0" class="data row8 col0" >2637</td>
      <td id="T_12a7e_row8_col1" class="data row8 col1" >2934</td>
      <td id="T_12a7e_row8_col2" class="data row8 col2" >0.90</td>
    </tr>
    <tr>
      <th id="T_12a7e_level1_row9" class="row_heading level1 row9" >write sym large</th>
      <td id="T_12a7e_row9_col0" class="data row9 col0" >60629</td>
      <td id="T_12a7e_row9_col1" class="data row9 col1" >17170</td>
      <td id="T_12a7e_row9_col2" class="data row9 col2" >3.53</td>
    </tr>
    <tr>
      <th id="T_12a7e_level0_row10" class="row_heading level0 row10" >GEOMETRIC MEAN</th>
      <th id="T_12a7e_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_12a7e_row10_col0" class="data row10 col0" >9057</td>
      <td id="T_12a7e_row10_col1" class="data row10 col1" >3420</td>
      <td id="T_12a7e_row10_col2" class="data row10 col2" >2.65</td>
    </tr>
    <tr>
      <th id="T_12a7e_level0_row11" class="row_heading level0 row11" >MAX RATIO</th>
      <th id="T_12a7e_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_12a7e_row11_col0" class="data row11 col0" >62892</td>
      <td id="T_12a7e_row11_col1" class="data row11 col1" >17170</td>
      <td id="T_12a7e_row11_col2" class="data row11 col2" >8.06</td>
    </tr>
  </tbody>
</table>






**Observation**: The results show that **XFS consistently and significantly outperformed ext4 in write-intensive operations**.
In critical ingestion and EOD tasks, write throughput on XFS was on average **2.6% times higher**.
This advantage peaked in specific operations, such as applying the `p#` attribute and persisting a medium length integer vector, where XFS was a remarkable **7x and 8x** faster than ext4.

The performance of the less critical write operations is below.






<style type="text/css">
#T_294aa th.col_heading.level0 {
  font-size: 1.5em;
}
#T_294aa_row0_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_294aa_row1_col2, #T_294aa_row15_col2 {
  background-color: #f6FFf6;
  color: black;
}
#T_294aa_row2_col2, #T_294aa_row12_col2, #T_294aa_row13_col2 {
  background-color: #FFfdfd;
  color: black;
}
#T_294aa_row3_col2, #T_294aa_row22_col2 {
  background-color: #ceFFce;
  color: black;
}
#T_294aa_row4_col2 {
  background-color: #FFe9e9;
  color: black;
}
#T_294aa_row5_col2 {
  background-color: #f9FFf9;
  color: black;
}
#T_294aa_row6_col2 {
  background-color: #f4FFf4;
  color: black;
}
#T_294aa_row7_col2 {
  background-color: #FFf6f6;
  color: black;
}
#T_294aa_row8_col2, #T_294aa_row14_col2 {
  background-color: #FFe3e3;
  color: black;
}
#T_294aa_row9_col2 {
  background-color: #FFfcfc;
  color: black;
}
#T_294aa_row10_col2 {
  background-color: #FF2020;
  color: white;
}
#T_294aa_row11_col2 {
  background-color: #fdFFfd;
  color: black;
}
#T_294aa_row16_col2 {
  background-color: #f2FFf2;
  color: black;
}
#T_294aa_row17_col2 {
  background-color: #FFf1f1;
  color: black;
}
#T_294aa_row18_col2 {
  background-color: #FFe2e2;
  color: black;
}
#T_294aa_row19_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_294aa_row20_col2 {
  background-color: #FF6262;
  color: white;
}
#T_294aa_row21_col2 {
  background-color: #FFb7b7;
  color: black;
}
</style>
<table id="T_294aa">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_294aa_level0_col0" class="col_heading level0 col0" >XFS (MB/s)</th>
      <th id="T_294aa_level0_col1" class="col_heading level0 col1" >ext4 (MB/s)</th>
      <th id="T_294aa_level0_col2" class="col_heading level0 col2" >Ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_294aa_level0_row0" class="row_heading level0 row0" rowspan="21">write disk</th>
      <th id="T_294aa_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_294aa_row0_col0" class="data row0 col0" >1726</td>
      <td id="T_294aa_row0_col1" class="data row0 col1" >1686</td>
      <td id="T_294aa_row0_col2" class="data row0 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_294aa_row1_col0" class="data row1 col0" >2294</td>
      <td id="T_294aa_row1_col1" class="data row1 col1" >2120</td>
      <td id="T_294aa_row1_col2" class="data row1 col2" >1.08</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_294aa_row2_col0" class="data row2 col0" >1391</td>
      <td id="T_294aa_row2_col1" class="data row2 col1" >1399</td>
      <td id="T_294aa_row2_col2" class="data row2 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_294aa_row3_col0" class="data row3 col0" >2385</td>
      <td id="T_294aa_row3_col1" class="data row3 col1" >1463</td>
      <td id="T_294aa_row3_col2" class="data row3 col2" >1.63</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row4" class="row_heading level1 row4" >open replace int tiny</th>
      <td id="T_294aa_row4_col0" class="data row4 col0" >12298</td>
      <td id="T_294aa_row4_col1" class="data row4 col1" >13634</td>
      <td id="T_294aa_row4_col2" class="data row4 col2" >0.90</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row5" class="row_heading level1 row5" >open replace random float large</th>
      <td id="T_294aa_row5_col0" class="data row5 col0" >232</td>
      <td id="T_294aa_row5_col1" class="data row5 col1" >220</td>
      <td id="T_294aa_row5_col2" class="data row5 col2" >1.06</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row6" class="row_heading level1 row6" >open replace random int huge</th>
      <td id="T_294aa_row6_col0" class="data row6 col0" >114</td>
      <td id="T_294aa_row6_col1" class="data row6 col1" >103</td>
      <td id="T_294aa_row6_col2" class="data row6 col2" >1.11</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row7" class="row_heading level1 row7" >open replace random int medium</th>
      <td id="T_294aa_row7_col0" class="data row7 col0" >18188</td>
      <td id="T_294aa_row7_col1" class="data row7 col1" >18922</td>
      <td id="T_294aa_row7_col2" class="data row7 col2" >0.96</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row8" class="row_heading level1 row8" >open replace random int small</th>
      <td id="T_294aa_row8_col0" class="data row8 col0" >28371</td>
      <td id="T_294aa_row8_col1" class="data row8 col1" >32363</td>
      <td id="T_294aa_row8_col2" class="data row8 col2" >0.88</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row9" class="row_heading level1 row9" >open replace sorted int huge</th>
      <td id="T_294aa_row9_col0" class="data row9 col0" >59</td>
      <td id="T_294aa_row9_col1" class="data row9 col1" >60</td>
      <td id="T_294aa_row9_col2" class="data row9 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row10" class="row_heading level1 row10" >sync column after parted attribute</th>
      <td id="T_294aa_row10_col0" class="data row10 col0" >139202</td>
      <td id="T_294aa_row10_col1" class="data row10 col1" >199845700</td>
      <td id="T_294aa_row10_col2" class="data row10 col2" >0.00</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row11" class="row_heading level1 row11" >sync float large</th>
      <td id="T_294aa_row11_col0" class="data row11 col0" >98447</td>
      <td id="T_294aa_row11_col1" class="data row11 col1" >97428</td>
      <td id="T_294aa_row11_col2" class="data row11 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row12" class="row_heading level1 row12" >sync float large after replace</th>
      <td id="T_294aa_row12_col0" class="data row12 col0" >192094</td>
      <td id="T_294aa_row12_col1" class="data row12 col1" >193340</td>
      <td id="T_294aa_row12_col2" class="data row12 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row13" class="row_heading level1 row13" >sync int huge</th>
      <td id="T_294aa_row13_col0" class="data row13 col0" >230644</td>
      <td id="T_294aa_row13_col1" class="data row13 col1" >231697</td>
      <td id="T_294aa_row13_col2" class="data row13 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row14" class="row_heading level1 row14" >sync int huge after replace</th>
      <td id="T_294aa_row14_col0" class="data row14 col0" >6272368</td>
      <td id="T_294aa_row14_col1" class="data row14 col1" >7152017</td>
      <td id="T_294aa_row14_col2" class="data row14 col2" >0.88</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row15" class="row_heading level1 row15" >sync int huge after sorted replace</th>
      <td id="T_294aa_row15_col0" class="data row15 col0" >7883493</td>
      <td id="T_294aa_row15_col1" class="data row15 col1" >7317134</td>
      <td id="T_294aa_row15_col2" class="data row15 col2" >1.08</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row16" class="row_heading level1 row16" >sync int medium</th>
      <td id="T_294aa_row16_col0" class="data row16 col0" >194125</td>
      <td id="T_294aa_row16_col1" class="data row16 col1" >173236</td>
      <td id="T_294aa_row16_col2" class="data row16 col2" >1.12</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row17" class="row_heading level1 row17" >sync int small</th>
      <td id="T_294aa_row17_col0" class="data row17 col0" >132313</td>
      <td id="T_294aa_row17_col1" class="data row17 col1" >140824</td>
      <td id="T_294aa_row17_col2" class="data row17 col2" >0.94</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row18" class="row_heading level1 row18" >sync int tiny</th>
      <td id="T_294aa_row18_col0" class="data row18 col0" >5592</td>
      <td id="T_294aa_row18_col1" class="data row18 col1" >6402</td>
      <td id="T_294aa_row18_col2" class="data row18 col2" >0.87</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row19" class="row_heading level1 row19" >sync sym large</th>
      <td id="T_294aa_row19_col0" class="data row19 col0" >148040</td>
      <td id="T_294aa_row19_col1" class="data row19 col1" >147264</td>
      <td id="T_294aa_row19_col2" class="data row19 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_294aa_level1_row20" class="row_heading level1 row20" >sync table after sort</th>
      <td id="T_294aa_row20_col0" class="data row20 col0" >111869100</td>
      <td id="T_294aa_row20_col1" class="data row20 col1" >373266900</td>
      <td id="T_294aa_row20_col2" class="data row20 col2" >0.30</td>
    </tr>
    <tr>
      <th id="T_294aa_level0_row21" class="row_heading level0 row21" >GEOMETRIC MEAN</th>
      <th id="T_294aa_level1_row21" class="row_heading level1 row21" ></th>
      <td id="T_294aa_row21_col0" class="data row21 col0" >29819</td>
      <td id="T_294aa_row21_col1" class="data row21 col1" >43975</td>
      <td id="T_294aa_row21_col2" class="data row21 col2" >0.68</td>
    </tr>
    <tr>
      <th id="T_294aa_level0_row22" class="row_heading level0 row22" >MAX RATIO</th>
      <th id="T_294aa_level1_row22" class="row_heading level1 row22" ></th>
      <td id="T_294aa_row22_col0" class="data row22 col0" >111869100</td>
      <td id="T_294aa_row22_col1" class="data row22 col1" >373266900</td>
      <td id="T_294aa_row22_col2" class="data row22 col2" >1.63</td>
    </tr>
  </tbody>
</table>




ext4 is faster in sync but this difference was negligible compared to the much longer write times required for sorting and applying attributes.

### Read

We divide read tests into two categories depending on the source of the data (hot vs cold), disk vs memory (page cache).

#### Single kdb+ process:




<style type="text/css">
#T_690b7 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_690b7_row0_col2, #T_690b7_row6_col2 {
  background-color: #fdFFfd;
  color: black;
}
#T_690b7_row1_col2 {
  background-color: #f9FFf9;
  color: black;
}
#T_690b7_row2_col2 {
  background-color: #faFFfa;
  color: black;
}
#T_690b7_row3_col2, #T_690b7_row5_col2 {
  background-color: #f1FFf1;
  color: black;
}
#T_690b7_row4_col2 {
  background-color: #f4FFf4;
  color: black;
}
#T_690b7_row7_col2, #T_690b7_row8_col2, #T_690b7_row13_col2 {
  background-color: #b1FFb1;
  color: black;
}
#T_690b7_row9_col2 {
  background-color: #e1FFe1;
  color: black;
}
#T_690b7_row10_col2 {
  background-color: #e7FFe7;
  color: black;
}
#T_690b7_row11_col2 {
  background-color: #f0FFf0;
  color: black;
}
#T_690b7_row12_col2 {
  background-color: #e6FFe6;
  color: black;
}
</style>
<table id="T_690b7">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_690b7_level0_col0" class="col_heading level0 col0" >XFS (MB/s)</th>
      <th id="T_690b7_level0_col1" class="col_heading level0 col1" >ext4 (MB/s)</th>
      <th id="T_690b7_level0_col2" class="col_heading level0 col2" >Ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_690b7_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_690b7_level1_row0" class="row_heading level1 row0" >mmap, random read 1M</th>
      <td id="T_690b7_row0_col0" class="data row0 col0" >597</td>
      <td id="T_690b7_row0_col1" class="data row0 col1" >590</td>
      <td id="T_690b7_row0_col2" class="data row0 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_690b7_level1_row1" class="row_heading level1 row1" >mmap, random read 4k</th>
      <td id="T_690b7_row1_col0" class="data row1 col0" >20</td>
      <td id="T_690b7_row1_col1" class="data row1 col1" >19</td>
      <td id="T_690b7_row1_col2" class="data row1 col2" >1.05</td>
    </tr>
    <tr>
      <th id="T_690b7_level1_row2" class="row_heading level1 row2" >mmap, random read 64k</th>
      <td id="T_690b7_row2_col0" class="data row2 col0" >200</td>
      <td id="T_690b7_row2_col1" class="data row2 col1" >192</td>
      <td id="T_690b7_row2_col2" class="data row2 col2" >1.05</td>
    </tr>
    <tr>
      <th id="T_690b7_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_690b7_row3_col0" class="data row3 col0" >616</td>
      <td id="T_690b7_row3_col1" class="data row3 col1" >546</td>
      <td id="T_690b7_row3_col2" class="data row3 col2" >1.13</td>
    </tr>
    <tr>
      <th id="T_690b7_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_690b7_row4_col0" class="data row4 col0" >21</td>
      <td id="T_690b7_row4_col1" class="data row4 col1" >19</td>
      <td id="T_690b7_row4_col2" class="data row4 col2" >1.10</td>
    </tr>
    <tr>
      <th id="T_690b7_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_690b7_row5_col0" class="data row5 col0" >207</td>
      <td id="T_690b7_row5_col1" class="data row5 col1" >184</td>
      <td id="T_690b7_row5_col2" class="data row5 col2" >1.13</td>
    </tr>
    <tr>
      <th id="T_690b7_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_690b7_row6_col0" class="data row6 col0" >689</td>
      <td id="T_690b7_row6_col1" class="data row6 col1" >681</td>
      <td id="T_690b7_row6_col2" class="data row6 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_690b7_level0_row7" class="row_heading level0 row7" rowspan="5">read disk write mem</th>
      <th id="T_690b7_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_690b7_row7_col0" class="data row7 col0" >1991</td>
      <td id="T_690b7_row7_col1" class="data row7 col1" >845</td>
      <td id="T_690b7_row7_col2" class="data row7 col2" >2.36</td>
    </tr>
    <tr>
      <th id="T_690b7_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_690b7_row8_col0" class="data row8 col0" >2039</td>
      <td id="T_690b7_row8_col1" class="data row8 col1" >870</td>
      <td id="T_690b7_row8_col2" class="data row8 col2" >2.34</td>
    </tr>
    <tr>
      <th id="T_690b7_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_690b7_row9_col0" class="data row9 col0" >624</td>
      <td id="T_690b7_row9_col1" class="data row9 col1" >472</td>
      <td id="T_690b7_row9_col2" class="data row9 col2" >1.32</td>
    </tr>
    <tr>
      <th id="T_690b7_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_690b7_row10_col0" class="data row10 col0" >318</td>
      <td id="T_690b7_row10_col1" class="data row10 col1" >254</td>
      <td id="T_690b7_row10_col2" class="data row10 col2" >1.25</td>
    </tr>
    <tr>
      <th id="T_690b7_level1_row11" class="row_heading level1 row11" >sequential read int tiny</th>
      <td id="T_690b7_row11_col0" class="data row11 col0" >26</td>
      <td id="T_690b7_row11_col1" class="data row11 col1" >23</td>
      <td id="T_690b7_row11_col2" class="data row11 col2" >1.14</td>
    </tr>
    <tr>
      <th id="T_690b7_level0_row12" class="row_heading level0 row12" >GEOMETRIC MEAN</th>
      <th id="T_690b7_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_690b7_row12_col0" class="data row12 col0" >259</td>
      <td id="T_690b7_row12_col1" class="data row12 col1" >205</td>
      <td id="T_690b7_row12_col2" class="data row12 col2" >1.26</td>
    </tr>
    <tr>
      <th id="T_690b7_level0_row13" class="row_heading level0 row13" >MAX RATIO</th>
      <th id="T_690b7_level1_row13" class="row_heading level1 row13" ></th>
      <td id="T_690b7_row13_col0" class="data row13 col0" >2039</td>
      <td id="T_690b7_row13_col1" class="data row13 col1" >870</td>
      <td id="T_690b7_row13_col2" class="data row13 col2" >2.36</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS reads the data faster from disk sequentially than ext4. Apart from this, the differences are negligible.




<style type="text/css">
#T_65b19 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_65b19_row0_col2, #T_65b19_row6_col2, #T_65b19_row9_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_65b19_row1_col2 {
  background-color: #FFfdfd;
  color: black;
}
#T_65b19_row2_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_65b19_row3_col2 {
  background-color: #fdFFfd;
  color: black;
}
#T_65b19_row4_col2, #T_65b19_row12_col2 {
  background-color: #e4FFe4;
  color: black;
}
#T_65b19_row5_col2, #T_65b19_row8_col2 {
  background-color: #FFfefe;
  color: black;
}
#T_65b19_row7_col2 {
  background-color: #FFfcfc;
  color: black;
}
#T_65b19_row10_col2, #T_65b19_row11_col2 {
  background-color: #fbFFfb;
  color: black;
}
</style>
<table id="T_65b19">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_65b19_level0_col0" class="col_heading level0 col0" >XFS (MB/s)</th>
      <th id="T_65b19_level0_col1" class="col_heading level0 col1" >ext4 (MB/s)</th>
      <th id="T_65b19_level0_col2" class="col_heading level0 col2" >Ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_65b19_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_65b19_level1_row0" class="row_heading level1 row0" >mmap, random read 1M</th>
      <td id="T_65b19_row0_col0" class="data row0 col0" >2468</td>
      <td id="T_65b19_row0_col1" class="data row0 col1" >2451</td>
      <td id="T_65b19_row0_col2" class="data row0 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_65b19_level1_row1" class="row_heading level1 row1" >mmap, random read 4k</th>
      <td id="T_65b19_row1_col0" class="data row1 col0" >261</td>
      <td id="T_65b19_row1_col1" class="data row1 col1" >263</td>
      <td id="T_65b19_row1_col2" class="data row1 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_65b19_level1_row2" class="row_heading level1 row2" >mmap, random read 64k</th>
      <td id="T_65b19_row2_col0" class="data row2 col0" >1743</td>
      <td id="T_65b19_row2_col1" class="data row2 col1" >1704</td>
      <td id="T_65b19_row2_col2" class="data row2 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_65b19_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_65b19_row3_col0" class="data row3 col0" >3040</td>
      <td id="T_65b19_row3_col1" class="data row3 col1" >2997</td>
      <td id="T_65b19_row3_col2" class="data row3 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_65b19_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_65b19_row4_col0" class="data row4 col0" >1272</td>
      <td id="T_65b19_row4_col1" class="data row4 col1" >983</td>
      <td id="T_65b19_row4_col2" class="data row4 col2" >1.29</td>
    </tr>
    <tr>
      <th id="T_65b19_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_65b19_row5_col0" class="data row5 col0" >3001</td>
      <td id="T_65b19_row5_col1" class="data row5 col1" >3003</td>
      <td id="T_65b19_row5_col2" class="data row5 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_65b19_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_65b19_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_65b19_row6_col0" class="data row6 col0" >2527</td>
      <td id="T_65b19_row6_col1" class="data row6 col1" >2513</td>
      <td id="T_65b19_row6_col2" class="data row6 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_65b19_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_65b19_row7_col0" class="data row7 col0" >15041</td>
      <td id="T_65b19_row7_col1" class="data row7 col1" >15229</td>
      <td id="T_65b19_row7_col2" class="data row7 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_65b19_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_65b19_row8_col0" class="data row8 col0" >33832</td>
      <td id="T_65b19_row8_col1" class="data row8 col1" >33912</td>
      <td id="T_65b19_row8_col2" class="data row8 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_65b19_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_65b19_row9_col0" class="data row9 col0" >8185</td>
      <td id="T_65b19_row9_col1" class="data row9 col1" >8119</td>
      <td id="T_65b19_row9_col2" class="data row9 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_65b19_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_65b19_row10_col0" class="data row10 col0" >2143</td>
      <td id="T_65b19_row10_col1" class="data row10 col1" >2070</td>
      <td id="T_65b19_row10_col2" class="data row10 col2" >1.03</td>
    </tr>
    <tr>
      <th id="T_65b19_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_65b19_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_65b19_row11_col0" class="data row11 col0" >3141</td>
      <td id="T_65b19_row11_col1" class="data row11 col1" >3050</td>
      <td id="T_65b19_row11_col2" class="data row11 col2" >1.03</td>
    </tr>
    <tr>
      <th id="T_65b19_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_65b19_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_65b19_row12_col0" class="data row12 col0" >33832</td>
      <td id="T_65b19_row12_col1" class="data row12 col1" >33912</td>
      <td id="T_65b19_row12_col2" class="data row12 col2" >1.29</td>
    </tr>
  </tbody>
</table>




**Observation**: There is no significant performance difference between XFS and ext4 with a single kdb+ reader if the data is coming from page cache.

#### 64 kdb+ processes:




<style type="text/css">
#T_5f1d5 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_5f1d5_row0_col2, #T_5f1d5_row2_col2, #T_5f1d5_row3_col2, #T_5f1d5_row4_col2, #T_5f1d5_row5_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_5f1d5_row1_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_5f1d5_row6_col2, #T_5f1d5_row13_col2 {
  background-color: #52FF52;
  color: black;
}
#T_5f1d5_row7_col2 {
  background-color: #FFb9b9;
  color: black;
}
#T_5f1d5_row8_col2 {
  background-color: #FFf6f6;
  color: black;
}
#T_5f1d5_row9_col2 {
  background-color: #FF7575;
  color: white;
}
#T_5f1d5_row10_col2 {
  background-color: #FF5858;
  color: white;
}
#T_5f1d5_row11_col2 {
  background-color: #FF5252;
  color: white;
}
#T_5f1d5_row12_col2 {
  background-color: #FFe9e9;
  color: black;
}
</style>
<table id="T_5f1d5">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_5f1d5_level0_col0" class="col_heading level0 col0" >XFS (MB/s)</th>
      <th id="T_5f1d5_level0_col1" class="col_heading level0 col1" >ext4 (MB/s)</th>
      <th id="T_5f1d5_level0_col2" class="col_heading level0 col2" >Ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_5f1d5_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_5f1d5_level1_row0" class="row_heading level1 row0" >mmap, random read 1M</th>
      <td id="T_5f1d5_row0_col0" class="data row0 col0" >2825</td>
      <td id="T_5f1d5_row0_col1" class="data row0 col1" >2821</td>
      <td id="T_5f1d5_row0_col2" class="data row0 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level1_row1" class="row_heading level1 row1" >mmap, random read 4k</th>
      <td id="T_5f1d5_row1_col0" class="data row1 col0" >544</td>
      <td id="T_5f1d5_row1_col1" class="data row1 col1" >534</td>
      <td id="T_5f1d5_row1_col2" class="data row1 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level1_row2" class="row_heading level1 row2" >mmap, random read 64k</th>
      <td id="T_5f1d5_row2_col0" class="data row2 col0" >1075</td>
      <td id="T_5f1d5_row2_col1" class="data row2 col1" >1073</td>
      <td id="T_5f1d5_row2_col2" class="data row2 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_5f1d5_row3_col0" class="data row3 col0" >2793</td>
      <td id="T_5f1d5_row3_col1" class="data row3 col1" >2786</td>
      <td id="T_5f1d5_row3_col2" class="data row3 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_5f1d5_row4_col0" class="data row4 col0" >547</td>
      <td id="T_5f1d5_row4_col1" class="data row4 col1" >544</td>
      <td id="T_5f1d5_row4_col2" class="data row4 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_5f1d5_row5_col0" class="data row5 col0" >1072</td>
      <td id="T_5f1d5_row5_col1" class="data row5 col1" >1069</td>
      <td id="T_5f1d5_row5_col2" class="data row5 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_5f1d5_row6_col0" class="data row6 col0" >99058</td>
      <td id="T_5f1d5_row6_col1" class="data row6 col1" >5114</td>
      <td id="T_5f1d5_row6_col2" class="data row6 col2" >19.37</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level0_row7" class="row_heading level0 row7" rowspan="5">read disk write mem</th>
      <th id="T_5f1d5_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_5f1d5_row7_col0" class="data row7 col0" >1947</td>
      <td id="T_5f1d5_row7_col1" class="data row7 col1" >2825</td>
      <td id="T_5f1d5_row7_col2" class="data row7 col2" >0.69</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_5f1d5_row8_col0" class="data row8 col0" >3123</td>
      <td id="T_5f1d5_row8_col1" class="data row8 col1" >3250</td>
      <td id="T_5f1d5_row8_col2" class="data row8 col2" >0.96</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_5f1d5_row9_col0" class="data row9 col0" >2043</td>
      <td id="T_5f1d5_row9_col1" class="data row9 col1" >5358</td>
      <td id="T_5f1d5_row9_col2" class="data row9 col2" >0.38</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_5f1d5_row10_col0" class="data row10 col0" >1537</td>
      <td id="T_5f1d5_row10_col1" class="data row10 col1" >6036</td>
      <td id="T_5f1d5_row10_col2" class="data row10 col2" >0.25</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level1_row11" class="row_heading level1 row11" >sequential read int tiny</th>
      <td id="T_5f1d5_row11_col0" class="data row11 col0" >421</td>
      <td id="T_5f1d5_row11_col1" class="data row11 col1" >1847</td>
      <td id="T_5f1d5_row11_col2" class="data row11 col2" >0.23</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level0_row12" class="row_heading level0 row12" >GEOMETRIC MEAN</th>
      <th id="T_5f1d5_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_5f1d5_row12_col0" class="data row12 col0" >1896</td>
      <td id="T_5f1d5_row12_col1" class="data row12 col1" >2100</td>
      <td id="T_5f1d5_row12_col2" class="data row12 col2" >0.90</td>
    </tr>
    <tr>
      <th id="T_5f1d5_level0_row13" class="row_heading level0 row13" >MAX RATIO</th>
      <th id="T_5f1d5_level1_row13" class="row_heading level1 row13" ></th>
      <td id="T_5f1d5_row13_col0" class="data row13 col0" >99058</td>
      <td id="T_5f1d5_row13_col1" class="data row13 col1" >6036</td>
      <td id="T_5f1d5_row13_col2" class="data row13 col2" >19.37</td>
    </tr>
  </tbody>
</table>




**Observation**: Despite the edge of XFS with a single reader, ext4 outperforms XFS sequential read if multiple kdb+ processes are reading various data in parallel. This scenario is common in a pool of HDBs where multiple concurrent queries with non-selective filters result in numerous parallel sequential reads from disk.

For random reads that require accessing the storage device directly (a cache miss), we observed no meaningful performance difference between ext4 and XFS.




<style type="text/css">
#T_d0109 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_d0109_row0_col2 {
  background-color: #FFaaaa;
  color: black;
}
#T_d0109_row1_col2, #T_d0109_row5_col2 {
  background-color: #fdFFfd;
  color: black;
}
#T_d0109_row2_col2, #T_d0109_row6_col2 {
  background-color: #FFf5f5;
  color: black;
}
#T_d0109_row3_col2 {
  background-color: #f0FFf0;
  color: black;
}
#T_d0109_row4_col2, #T_d0109_row12_col2 {
  background-color: #d4FFd4;
  color: black;
}
#T_d0109_row7_col2 {
  background-color: #FFe8e8;
  color: black;
}
#T_d0109_row8_col2 {
  background-color: #FFf6f6;
  color: black;
}
#T_d0109_row9_col2 {
  background-color: #FFe6e6;
  color: black;
}
#T_d0109_row10_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_d0109_row11_col2 {
  background-color: #FFfafa;
  color: black;
}
</style>
<table id="T_d0109">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_d0109_level0_col0" class="col_heading level0 col0" >XFS (MB/s)</th>
      <th id="T_d0109_level0_col1" class="col_heading level0 col1" >ext4 (MB/s)</th>
      <th id="T_d0109_level0_col2" class="col_heading level0 col2" >Ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_d0109_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_d0109_level1_row0" class="row_heading level1 row0" >mmap, random read 1M</th>
      <td id="T_d0109_row0_col0" class="data row0 col0" >24627</td>
      <td id="T_d0109_row0_col1" class="data row0 col1" >39646</td>
      <td id="T_d0109_row0_col2" class="data row0 col2" >0.62</td>
    </tr>
    <tr>
      <th id="T_d0109_level1_row1" class="row_heading level1 row1" >mmap, random read 4k</th>
      <td id="T_d0109_row1_col0" class="data row1 col0" >5617</td>
      <td id="T_d0109_row1_col1" class="data row1 col1" >5525</td>
      <td id="T_d0109_row1_col2" class="data row1 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_d0109_level1_row2" class="row_heading level1 row2" >mmap, random read 64k</th>
      <td id="T_d0109_row2_col0" class="data row2 col0" >22215</td>
      <td id="T_d0109_row2_col1" class="data row2 col1" >23249</td>
      <td id="T_d0109_row2_col2" class="data row2 col2" >0.96</td>
    </tr>
    <tr>
      <th id="T_d0109_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_d0109_row3_col0" class="data row3 col0" >151307</td>
      <td id="T_d0109_row3_col1" class="data row3 col1" >132294</td>
      <td id="T_d0109_row3_col2" class="data row3 col2" >1.14</td>
    </tr>
    <tr>
      <th id="T_d0109_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_d0109_row4_col0" class="data row4 col0" >98365</td>
      <td id="T_d0109_row4_col1" class="data row4 col1" >64205</td>
      <td id="T_d0109_row4_col2" class="data row4 col2" >1.53</td>
    </tr>
    <tr>
      <th id="T_d0109_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_d0109_row5_col0" class="data row5 col0" >161306</td>
      <td id="T_d0109_row5_col1" class="data row5 col1" >158559</td>
      <td id="T_d0109_row5_col2" class="data row5 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_d0109_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_d0109_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_d0109_row6_col0" class="data row6 col0" >27536</td>
      <td id="T_d0109_row6_col1" class="data row6 col1" >28720</td>
      <td id="T_d0109_row6_col2" class="data row6 col2" >0.96</td>
    </tr>
    <tr>
      <th id="T_d0109_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_d0109_row7_col0" class="data row7 col0" >1135453</td>
      <td id="T_d0109_row7_col1" class="data row7 col1" >1265438</td>
      <td id="T_d0109_row7_col2" class="data row7 col2" >0.90</td>
    </tr>
    <tr>
      <th id="T_d0109_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_d0109_row8_col0" class="data row8 col0" >1459501</td>
      <td id="T_d0109_row8_col1" class="data row8 col1" >1518556</td>
      <td id="T_d0109_row8_col2" class="data row8 col2" >0.96</td>
    </tr>
    <tr>
      <th id="T_d0109_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_d0109_row9_col0" class="data row9 col0" >568919</td>
      <td id="T_d0109_row9_col1" class="data row9 col1" >637707</td>
      <td id="T_d0109_row9_col2" class="data row9 col2" >0.89</td>
    </tr>
    <tr>
      <th id="T_d0109_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_d0109_row10_col0" class="data row10 col0" >120474</td>
      <td id="T_d0109_row10_col1" class="data row10 col1" >120112</td>
      <td id="T_d0109_row10_col2" class="data row10 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_d0109_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_d0109_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_d0109_row11_col0" class="data row11 col0" >107897</td>
      <td id="T_d0109_row11_col1" class="data row11 col1" >110161</td>
      <td id="T_d0109_row11_col2" class="data row11 col2" >0.98</td>
    </tr>
    <tr>
      <th id="T_d0109_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_d0109_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_d0109_row12_col0" class="data row12 col0" >1459501</td>
      <td id="T_d0109_row12_col1" class="data row12 col1" >1518556</td>
      <td id="T_d0109_row12_col2" class="data row12 col2" >1.53</td>
    </tr>
  </tbody>
</table>




**Observation**: There is no clear winner in read performance if the data is coming from page cache and there are multiple readers.

## Test 2: Ubuntu with Samsung NVMe SSD (PCIe 5.0)

### Test setup

| Component	| Specification|
| --- | --- |
| Storage | * **Type**: 3.84 TB [SAMSUNG MZWLO3T8HCLS-00A07](https://semiconductor.samsung.com/ssd/enterprise-ssd/pm1743/mzwlo3t8hcls-00a07-00b07/) </br> * **Interface**: PCIe 5.0 x4 <br/> * **Sequential R/W**: 14000 MB/s / 6000 MB/s <br/> * **Random Read**: 2500K IOPS (4K) <br/>
| CPU | [AMD EPYC 9575F (Turin)](https://www.amd.com/en/products/processors/server/epyc/9005-series/amd-epyc-9575f.html), 2 sockets, 64 cores per socket, 2 threads per core, 256 MB L3 cache, [SMT](https://en.wikipedia.org/wiki/Simultaneous_multithreading) off |
| Memory | 2.2 TB, DDR5@6400 MT/s (12 channels per socket) |
| OS| Ubuntu 24.04.3 LTS (kernel: 6.8.0-83-generic) |

Since compression is enabled by default in ZFS, we disabled it during the pool creation (`-O compression=off`) to ensure a fair comparison with the other file systems.

The values presented in the result tables represent throughput ratios to XFS throughput (e.g., a value of 2 indicates XFS was twice as fast).

### Write

#### Single kdb+ process:




<style type="text/css">
#T_e1132 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_e1132_row0_col0, #T_e1132_row9_col2 {
  background-color: #f2FFf2;
  color: black;
}
#T_e1132_row0_col1 {
  background-color: #f1FFf1;
  color: black;
}
#T_e1132_row0_col2, #T_e1132_row0_col3 {
  background-color: #fcFFfc;
  color: black;
}
#T_e1132_row1_col0, #T_e1132_row9_col1 {
  background-color: #f6FFf6;
  color: black;
}
#T_e1132_row1_col1 {
  background-color: #f3FFf3;
  color: black;
}
#T_e1132_row1_col2 {
  background-color: #f9FFf9;
  color: black;
}
#T_e1132_row1_col3 {
  background-color: #f7FFf7;
  color: black;
}
#T_e1132_row2_col0 {
  background-color: #caFFca;
  color: black;
}
#T_e1132_row2_col1 {
  background-color: #d0FFd0;
  color: black;
}
#T_e1132_row2_col2 {
  background-color: #c4FFc4;
  color: black;
}
#T_e1132_row2_col3 {
  background-color: #d1FFd1;
  color: black;
}
#T_e1132_row3_col0, #T_e1132_row3_col1, #T_e1132_row8_col3, #T_e1132_row9_col0 {
  background-color: #efFFef;
  color: black;
}
#T_e1132_row3_col2, #T_e1132_row8_col0 {
  background-color: #e8FFe8;
  color: black;
}
#T_e1132_row3_col3 {
  background-color: #FFfefe;
  color: black;
}
#T_e1132_row4_col0 {
  background-color: #a5FFa5;
  color: black;
}
#T_e1132_row4_col1, #T_e1132_row5_col1 {
  background-color: #c3FFc3;
  color: black;
}
#T_e1132_row4_col2 {
  background-color: #a7FFa7;
  color: black;
}
#T_e1132_row4_col3 {
  background-color: #FFe3e3;
  color: black;
}
#T_e1132_row5_col0 {
  background-color: #a1FFa1;
  color: black;
}
#T_e1132_row5_col2, #T_e1132_row5_col3 {
  background-color: #a9FFa9;
  color: black;
}
#T_e1132_row6_col0 {
  background-color: #aeFFae;
  color: black;
}
#T_e1132_row6_col1 {
  background-color: #c7FFc7;
  color: black;
}
#T_e1132_row6_col2 {
  background-color: #a8FFa8;
  color: black;
}
#T_e1132_row6_col3 {
  background-color: #FFf6f6;
  color: black;
}
#T_e1132_row7_col0 {
  background-color: #e6FFe6;
  color: black;
}
#T_e1132_row7_col1 {
  background-color: #89FF89;
  color: black;
}
#T_e1132_row7_col2 {
  background-color: #f0FFf0;
  color: black;
}
#T_e1132_row7_col3 {
  background-color: #d9FFd9;
  color: black;
}
#T_e1132_row8_col1 {
  background-color: #FFbfbf;
  color: black;
}
#T_e1132_row8_col2 {
  background-color: #FFd6d6;
  color: black;
}
#T_e1132_row9_col3 {
  background-color: #FFfcfc;
  color: black;
}
#T_e1132_row10_col0 {
  background-color: #d2FFd2;
  color: black;
  background: lightblue;
}
#T_e1132_row10_col1, #T_e1132_row10_col2 {
  background-color: #d7FFd7;
  color: black;
  background: lightblue;
}
#T_e1132_row10_col3 {
  background-color: #ebFFeb;
  color: black;
  background: lightblue;
}
#T_e1132_row11_col0 {
  background-color: #a1FFa1;
  color: black;
  background: lightblue;
}
#T_e1132_row11_col1 {
  background-color: #89FF89;
  color: black;
  background: lightblue;
}
#T_e1132_row11_col2 {
  background-color: #a7FFa7;
  color: black;
  background: lightblue;
}
#T_e1132_row11_col3 {
  background-color: #a9FFa9;
  color: black;
  background: lightblue;
}
</style>
<table id="T_e1132">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_e1132_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_e1132_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_e1132_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_e1132_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_e1132_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_e1132_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_e1132_row0_col0" class="data row0 col0" >1.1</td>
      <td id="T_e1132_row0_col1" class="data row0 col1" >1.1</td>
      <td id="T_e1132_row0_col2" class="data row0 col2" >1.0</td>
      <td id="T_e1132_row0_col3" class="data row0 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_e1132_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_e1132_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_e1132_row1_col0" class="data row1 col0" >1.1</td>
      <td id="T_e1132_row1_col1" class="data row1 col1" >1.1</td>
      <td id="T_e1132_row1_col2" class="data row1 col2" >1.1</td>
      <td id="T_e1132_row1_col3" class="data row1 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_e1132_level0_row2" class="row_heading level0 row2" rowspan="8">write disk</th>
      <th id="T_e1132_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_e1132_row2_col0" class="data row2 col0" >1.7</td>
      <td id="T_e1132_row2_col1" class="data row2 col1" >1.6</td>
      <td id="T_e1132_row2_col2" class="data row2 col2" >1.8</td>
      <td id="T_e1132_row2_col3" class="data row2 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_e1132_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_e1132_row3_col0" class="data row3 col0" >1.2</td>
      <td id="T_e1132_row3_col1" class="data row3 col1" >1.2</td>
      <td id="T_e1132_row3_col2" class="data row3 col2" >1.2</td>
      <td id="T_e1132_row3_col3" class="data row3 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_e1132_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_e1132_row4_col0" class="data row4 col0" >2.8</td>
      <td id="T_e1132_row4_col1" class="data row4 col1" >1.9</td>
      <td id="T_e1132_row4_col2" class="data row4 col2" >2.7</td>
      <td id="T_e1132_row4_col3" class="data row4 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_e1132_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_e1132_row5_col0" class="data row5 col0" >2.9</td>
      <td id="T_e1132_row5_col1" class="data row5 col1" >1.9</td>
      <td id="T_e1132_row5_col2" class="data row5 col2" >2.6</td>
      <td id="T_e1132_row5_col3" class="data row5 col3" >2.6</td>
    </tr>
    <tr>
      <th id="T_e1132_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_e1132_row6_col0" class="data row6 col0" >2.4</td>
      <td id="T_e1132_row6_col1" class="data row6 col1" >1.8</td>
      <td id="T_e1132_row6_col2" class="data row6 col2" >2.7</td>
      <td id="T_e1132_row6_col3" class="data row6 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_e1132_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_e1132_row7_col0" class="data row7 col0" >1.3</td>
      <td id="T_e1132_row7_col1" class="data row7 col1" >4.4</td>
      <td id="T_e1132_row7_col2" class="data row7 col2" >1.1</td>
      <td id="T_e1132_row7_col3" class="data row7 col3" >1.4</td>
    </tr>
    <tr>
      <th id="T_e1132_level1_row8" class="row_heading level1 row8" >write int tiny</th>
      <td id="T_e1132_row8_col0" class="data row8 col0" >1.2</td>
      <td id="T_e1132_row8_col1" class="data row8 col1" >0.7</td>
      <td id="T_e1132_row8_col2" class="data row8 col2" >0.8</td>
      <td id="T_e1132_row8_col3" class="data row8 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_e1132_level1_row9" class="row_heading level1 row9" >write sym large</th>
      <td id="T_e1132_row9_col0" class="data row9 col0" >1.2</td>
      <td id="T_e1132_row9_col1" class="data row9 col1" >1.1</td>
      <td id="T_e1132_row9_col2" class="data row9 col2" >1.1</td>
      <td id="T_e1132_row9_col3" class="data row9 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_e1132_level0_row10" class="row_heading level0 row10" >GEOMETRIC MEAN</th>
      <th id="T_e1132_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_e1132_row10_col0" class="data row10 col0" >1.6</td>
      <td id="T_e1132_row10_col1" class="data row10 col1" >1.5</td>
      <td id="T_e1132_row10_col2" class="data row10 col2" >1.5</td>
      <td id="T_e1132_row10_col3" class="data row10 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_e1132_level0_row11" class="row_heading level0 row11" >MAX RATIO</th>
      <th id="T_e1132_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_e1132_row11_col0" class="data row11 col0" >2.9</td>
      <td id="T_e1132_row11_col1" class="data row11 col1" >4.4</td>
      <td id="T_e1132_row11_col2" class="data row11 col2" >2.7</td>
      <td id="T_e1132_row11_col3" class="data row11 col3" >2.6</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS outperforms all other file systems if a single kdb+ process writes the data.

The performance of the less critical write operations is below.




<style type="text/css">
#T_38c70 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_38c70_row0_col0 {
  background-color: #9eFF9e;
  color: black;
}
#T_38c70_row0_col1 {
  background-color: #bdFFbd;
  color: black;
}
#T_38c70_row0_col2 {
  background-color: #b7FFb7;
  color: black;
}
#T_38c70_row0_col3, #T_38c70_row12_col0 {
  background-color: #e2FFe2;
  color: black;
}
#T_38c70_row1_col0 {
  background-color: #beFFbe;
  color: black;
}
#T_38c70_row1_col1 {
  background-color: #deFFde;
  color: black;
}
#T_38c70_row1_col2 {
  background-color: #e4FFe4;
  color: black;
}
#T_38c70_row1_col3 {
  background-color: #ebFFeb;
  color: black;
}
#T_38c70_row2_col0 {
  background-color: #d6FFd6;
  color: black;
}
#T_38c70_row2_col1, #T_38c70_row13_col1 {
  background-color: #d4FFd4;
  color: black;
}
#T_38c70_row2_col2 {
  background-color: #cfFFcf;
  color: black;
}
#T_38c70_row2_col3 {
  background-color: #FFf1f1;
  color: black;
}
#T_38c70_row3_col0 {
  background-color: #e9FFe9;
  color: black;
}
#T_38c70_row3_col1, #T_38c70_row10_col2 {
  background-color: #faFFfa;
  color: black;
}
#T_38c70_row3_col2, #T_38c70_row10_col0, #T_38c70_row16_col3 {
  background-color: #f2FFf2;
  color: black;
}
#T_38c70_row3_col3 {
  background-color: #afFFaf;
  color: black;
}
#T_38c70_row4_col0, #T_38c70_row12_col1 {
  background-color: #eeFFee;
  color: black;
}
#T_38c70_row4_col1 {
  background-color: #e8FFe8;
  color: black;
}
#T_38c70_row4_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_38c70_row4_col3 {
  background-color: #FFf6f6;
  color: black;
}
#T_38c70_row5_col0 {
  background-color: #52FF52;
  color: black;
}
#T_38c70_row5_col1 {
  background-color: #4cFF4c;
  color: black;
}
#T_38c70_row5_col2 {
  background-color: #55FF55;
  color: black;
}
#T_38c70_row5_col3 {
  background-color: #3fFF3f;
  color: black;
}
#T_38c70_row6_col0 {
  background-color: #48FF48;
  color: black;
}
#T_38c70_row6_col1 {
  background-color: #43FF43;
  color: black;
}
#T_38c70_row6_col2 {
  background-color: #49FF49;
  color: black;
}
#T_38c70_row6_col3 {
  background-color: #36FF36;
  color: black;
}
#T_38c70_row7_col0 {
  background-color: #FFdfdf;
  color: black;
}
#T_38c70_row7_col1 {
  background-color: #dfFFdf;
  color: black;
}
#T_38c70_row7_col2, #T_38c70_row17_col3 {
  background-color: #FFeded;
  color: black;
}
#T_38c70_row7_col3 {
  background-color: #FFd6d6;
  color: black;
}
#T_38c70_row8_col0 {
  background-color: #FFdede;
  color: black;
}
#T_38c70_row8_col1 {
  background-color: #daFFda;
  color: black;
}
#T_38c70_row8_col2 {
  background-color: #FFe2e2;
  color: black;
}
#T_38c70_row8_col3 {
  background-color: #FFc6c6;
  color: black;
}
#T_38c70_row9_col0 {
  background-color: #5bFF5b;
  color: black;
}
#T_38c70_row9_col1 {
  background-color: #40FF40;
  color: black;
}
#T_38c70_row9_col2 {
  background-color: #5fFF5f;
  color: black;
}
#T_38c70_row9_col3 {
  background-color: #67FF67;
  color: black;
}
#T_38c70_row10_col1 {
  background-color: #dbFFdb;
  color: black;
}
#T_38c70_row10_col3, #T_38c70_row11_col2 {
  background-color: #ecFFec;
  color: black;
}
#T_38c70_row11_col0 {
  background-color: #FFf3f3;
  color: black;
}
#T_38c70_row11_col1 {
  background-color: #d9FFd9;
  color: black;
}
#T_38c70_row11_col3 {
  background-color: #78FF78;
  color: black;
}
#T_38c70_row12_col2 {
  background-color: #fbFFfb;
  color: black;
}
#T_38c70_row12_col3 {
  background-color: #FF6565;
  color: white;
}
#T_38c70_row13_col0, #T_38c70_row14_col0 {
  background-color: #FF4949;
  color: white;
}
#T_38c70_row13_col2 {
  background-color: #FF3d3d;
  color: white;
}
#T_38c70_row13_col3 {
  background-color: #86FF86;
  color: black;
}
#T_38c70_row14_col1 {
  background-color: #c8FFc8;
  color: black;
}
#T_38c70_row14_col2 {
  background-color: #FF3c3c;
  color: white;
}
#T_38c70_row14_col3 {
  background-color: #81FF81;
  color: black;
}
#T_38c70_row15_col0 {
  background-color: #edFFed;
  color: black;
}
#T_38c70_row15_col1 {
  background-color: #e1FFe1;
  color: black;
}
#T_38c70_row15_col2 {
  background-color: #caFFca;
  color: black;
}
#T_38c70_row15_col3 {
  background-color: #FFe7e7;
  color: black;
}
#T_38c70_row16_col0 {
  background-color: #FFdada;
  color: black;
}
#T_38c70_row16_col1 {
  background-color: #f5FFf5;
  color: black;
}
#T_38c70_row16_col2 {
  background-color: #eaFFea;
  color: black;
}
#T_38c70_row17_col0 {
  background-color: #f3FFf3;
  color: black;
}
#T_38c70_row17_col1, #T_38c70_row18_col2 {
  background-color: #ddFFdd;
  color: black;
}
#T_38c70_row17_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_38c70_row18_col0 {
  background-color: #c5FFc5;
  color: black;
}
#T_38c70_row18_col1 {
  background-color: #d8FFd8;
  color: black;
}
#T_38c70_row18_col3 {
  background-color: #dcFFdc;
  color: black;
}
#T_38c70_row19_col0 {
  background-color: #f6FFf6;
  color: black;
}
#T_38c70_row19_col1 {
  background-color: #FFbbbb;
  color: black;
}
#T_38c70_row19_col2 {
  background-color: #93FF93;
  color: black;
}
#T_38c70_row19_col3 {
  background-color: #6cFF6c;
  color: black;
}
#T_38c70_row20_col0 {
  background-color: #d2FFd2;
  color: black;
  background: lightblue;
}
#T_38c70_row20_col1 {
  background-color: #b6FFb6;
  color: black;
  background: lightblue;
}
#T_38c70_row20_col2 {
  background-color: #d3FFd3;
  color: black;
  background: lightblue;
}
#T_38c70_row20_col3 {
  background-color: #aeFFae;
  color: black;
  background: lightblue;
}
#T_38c70_row21_col0 {
  background-color: #48FF48;
  color: black;
  background: lightblue;
}
#T_38c70_row21_col1 {
  background-color: #40FF40;
  color: black;
  background: lightblue;
}
#T_38c70_row21_col2 {
  background-color: #49FF49;
  color: black;
  background: lightblue;
}
#T_38c70_row21_col3 {
  background-color: #36FF36;
  color: black;
  background: lightblue;
}
</style>
<table id="T_38c70">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_38c70_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_38c70_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_38c70_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_38c70_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_38c70_level0_row0" class="row_heading level0 row0" rowspan="20">write disk</th>
      <th id="T_38c70_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_38c70_row0_col0" class="data row0 col0" >3.1</td>
      <td id="T_38c70_row0_col1" class="data row0 col1" >2.0</td>
      <td id="T_38c70_row0_col2" class="data row0 col2" >2.2</td>
      <td id="T_38c70_row0_col3" class="data row0 col3" >1.3</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_38c70_row1_col0" class="data row1 col0" >2.0</td>
      <td id="T_38c70_row1_col1" class="data row1 col1" >1.4</td>
      <td id="T_38c70_row1_col2" class="data row1 col2" >1.3</td>
      <td id="T_38c70_row1_col3" class="data row1 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_38c70_row2_col0" class="data row2 col0" >1.5</td>
      <td id="T_38c70_row2_col1" class="data row2 col1" >1.5</td>
      <td id="T_38c70_row2_col2" class="data row2 col2" >1.6</td>
      <td id="T_38c70_row2_col3" class="data row2 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_38c70_row3_col0" class="data row3 col0" >1.2</td>
      <td id="T_38c70_row3_col1" class="data row3 col1" >1.0</td>
      <td id="T_38c70_row3_col2" class="data row3 col2" >1.1</td>
      <td id="T_38c70_row3_col3" class="data row3 col3" >2.4</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row4" class="row_heading level1 row4" >open replace int tiny</th>
      <td id="T_38c70_row4_col0" class="data row4 col0" >1.2</td>
      <td id="T_38c70_row4_col1" class="data row4 col1" >1.2</td>
      <td id="T_38c70_row4_col2" class="data row4 col2" >1.0</td>
      <td id="T_38c70_row4_col3" class="data row4 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row5" class="row_heading level1 row5" >open replace random float large</th>
      <td id="T_38c70_row5_col0" class="data row5 col0" >19.1</td>
      <td id="T_38c70_row5_col1" class="data row5 col1" >24.7</td>
      <td id="T_38c70_row5_col2" class="data row5 col2" >17.6</td>
      <td id="T_38c70_row5_col3" class="data row5 col3" >51.6</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row6" class="row_heading level1 row6" >open replace random int huge</th>
      <td id="T_38c70_row6_col0" class="data row6 col0" >30.0</td>
      <td id="T_38c70_row6_col1" class="data row6 col1" >40.3</td>
      <td id="T_38c70_row6_col2" class="data row6 col2" >28.5</td>
      <td id="T_38c70_row6_col3" class="data row6 col3" >99.2</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row7" class="row_heading level1 row7" >open replace random int medium</th>
      <td id="T_38c70_row7_col0" class="data row7 col0" >0.9</td>
      <td id="T_38c70_row7_col1" class="data row7 col1" >1.4</td>
      <td id="T_38c70_row7_col2" class="data row7 col2" >0.9</td>
      <td id="T_38c70_row7_col3" class="data row7 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row8" class="row_heading level1 row8" >open replace random int small</th>
      <td id="T_38c70_row8_col0" class="data row8 col0" >0.9</td>
      <td id="T_38c70_row8_col1" class="data row8 col1" >1.4</td>
      <td id="T_38c70_row8_col2" class="data row8 col2" >0.9</td>
      <td id="T_38c70_row8_col3" class="data row8 col3" >0.7</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row9" class="row_heading level1 row9" >open replace sorted int huge</th>
      <td id="T_38c70_row9_col0" class="data row9 col0" >14.0</td>
      <td id="T_38c70_row9_col1" class="data row9 col1" >48.5</td>
      <td id="T_38c70_row9_col2" class="data row9 col2" >12.5</td>
      <td id="T_38c70_row9_col3" class="data row9 col3" >9.7</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row10" class="row_heading level1 row10" >sync float large</th>
      <td id="T_38c70_row10_col0" class="data row10 col0" >1.1</td>
      <td id="T_38c70_row10_col1" class="data row10 col1" >1.4</td>
      <td id="T_38c70_row10_col2" class="data row10 col2" >1.0</td>
      <td id="T_38c70_row10_col3" class="data row10 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row11" class="row_heading level1 row11" >sync float large after replace</th>
      <td id="T_38c70_row11_col0" class="data row11 col0" >0.9</td>
      <td id="T_38c70_row11_col1" class="data row11 col1" >1.5</td>
      <td id="T_38c70_row11_col2" class="data row11 col2" >1.2</td>
      <td id="T_38c70_row11_col3" class="data row11 col3" >6.4</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row12" class="row_heading level1 row12" >sync int huge</th>
      <td id="T_38c70_row12_col0" class="data row12 col0" >1.3</td>
      <td id="T_38c70_row12_col1" class="data row12 col1" >1.2</td>
      <td id="T_38c70_row12_col2" class="data row12 col2" >1.0</td>
      <td id="T_38c70_row12_col3" class="data row12 col3" >0.3</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row13" class="row_heading level1 row13" >sync int huge after replace</th>
      <td id="T_38c70_row13_col0" class="data row13 col0" >0.2</td>
      <td id="T_38c70_row13_col1" class="data row13 col1" >1.5</td>
      <td id="T_38c70_row13_col2" class="data row13 col2" >0.1</td>
      <td id="T_38c70_row13_col3" class="data row13 col3" >4.7</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row14" class="row_heading level1 row14" >sync int huge after sorted replace</th>
      <td id="T_38c70_row14_col0" class="data row14 col0" >0.2</td>
      <td id="T_38c70_row14_col1" class="data row14 col1" >1.8</td>
      <td id="T_38c70_row14_col2" class="data row14 col2" >0.1</td>
      <td id="T_38c70_row14_col3" class="data row14 col3" >5.2</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row15" class="row_heading level1 row15" >sync int medium</th>
      <td id="T_38c70_row15_col0" class="data row15 col0" >1.2</td>
      <td id="T_38c70_row15_col1" class="data row15 col1" >1.3</td>
      <td id="T_38c70_row15_col2" class="data row15 col2" >1.7</td>
      <td id="T_38c70_row15_col3" class="data row15 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row16" class="row_heading level1 row16" >sync int small</th>
      <td id="T_38c70_row16_col0" class="data row16 col0" >0.8</td>
      <td id="T_38c70_row16_col1" class="data row16 col1" >1.1</td>
      <td id="T_38c70_row16_col2" class="data row16 col2" >1.2</td>
      <td id="T_38c70_row16_col3" class="data row16 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row17" class="row_heading level1 row17" >sync int tiny</th>
      <td id="T_38c70_row17_col0" class="data row17 col0" >1.1</td>
      <td id="T_38c70_row17_col1" class="data row17 col1" >1.4</td>
      <td id="T_38c70_row17_col2" class="data row17 col2" >1.0</td>
      <td id="T_38c70_row17_col3" class="data row17 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row18" class="row_heading level1 row18" >sync sym large</th>
      <td id="T_38c70_row18_col0" class="data row18 col0" >1.8</td>
      <td id="T_38c70_row18_col1" class="data row18 col1" >1.5</td>
      <td id="T_38c70_row18_col2" class="data row18 col2" >1.4</td>
      <td id="T_38c70_row18_col3" class="data row18 col3" >1.4</td>
    </tr>
    <tr>
      <th id="T_38c70_level1_row19" class="row_heading level1 row19" >sync table after sort</th>
      <td id="T_38c70_row19_col0" class="data row19 col0" >1.1</td>
      <td id="T_38c70_row19_col1" class="data row19 col1" >0.7</td>
      <td id="T_38c70_row19_col2" class="data row19 col2" >3.7</td>
      <td id="T_38c70_row19_col3" class="data row19 col3" >8.5</td>
    </tr>
    <tr>
      <th id="T_38c70_level0_row20" class="row_heading level0 row20" >GEOMETRIC MEAN</th>
      <th id="T_38c70_level1_row20" class="row_heading level1 row20" ></th>
      <td id="T_38c70_row20_col0" class="data row20 col0" >1.6</td>
      <td id="T_38c70_row20_col1" class="data row20 col1" >2.2</td>
      <td id="T_38c70_row20_col2" class="data row20 col2" >1.5</td>
      <td id="T_38c70_row20_col3" class="data row20 col3" >2.5</td>
    </tr>
    <tr>
      <th id="T_38c70_level0_row21" class="row_heading level0 row21" >MAX RATIO</th>
      <th id="T_38c70_level1_row21" class="row_heading level1 row21" ></th>
      <td id="T_38c70_row21_col0" class="data row21 col0" >30.0</td>
      <td id="T_38c70_row21_col1" class="data row21 col1" >48.5</td>
      <td id="T_38c70_row21_col2" class="data row21 col2" >28.5</td>
      <td id="T_38c70_row21_col3" class="data row21 col3" >99.2</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS significantly outperformed all other file systems if only some random part of a vector needs to be overwritten (see `open replace` tests)

#### 64 kdb+ processes:




<style type="text/css">
#T_7df70 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_7df70_row0_col0 {
  background-color: #a0FFa0;
  color: black;
}
#T_7df70_row0_col1 {
  background-color: #a2FFa2;
  color: black;
}
#T_7df70_row0_col2 {
  background-color: #9cFF9c;
  color: black;
}
#T_7df70_row0_col3 {
  background-color: #9bFF9b;
  color: black;
}
#T_7df70_row1_col0 {
  background-color: #b4FFb4;
  color: black;
}
#T_7df70_row1_col1 {
  background-color: #95FF95;
  color: black;
}
#T_7df70_row1_col2 {
  background-color: #b0FFb0;
  color: black;
}
#T_7df70_row1_col3 {
  background-color: #b5FFb5;
  color: black;
}
#T_7df70_row2_col0, #T_7df70_row5_col0 {
  background-color: #f7FFf7;
  color: black;
}
#T_7df70_row2_col1 {
  background-color: #FFdddd;
  color: black;
}
#T_7df70_row2_col2 {
  background-color: #a7FFa7;
  color: black;
}
#T_7df70_row2_col3 {
  background-color: #cdFFcd;
  color: black;
}
#T_7df70_row3_col0, #T_7df70_row9_col0 {
  background-color: #ecFFec;
  color: black;
}
#T_7df70_row3_col1 {
  background-color: #FFeeee;
  color: black;
}
#T_7df70_row3_col2 {
  background-color: #b7FFb7;
  color: black;
}
#T_7df70_row3_col3 {
  background-color: #d2FFd2;
  color: black;
}
#T_7df70_row4_col0 {
  background-color: #9fFF9f;
  color: black;
}
#T_7df70_row4_col1, #T_7df70_row6_col0 {
  background-color: #a1FFa1;
  color: black;
}
#T_7df70_row4_col2 {
  background-color: #40FF40;
  color: black;
}
#T_7df70_row4_col3 {
  background-color: #3aFF3a;
  color: black;
}
#T_7df70_row5_col1 {
  background-color: #c9FFc9;
  color: black;
}
#T_7df70_row5_col2 {
  background-color: #87FF87;
  color: black;
}
#T_7df70_row5_col3 {
  background-color: #96FF96;
  color: black;
}
#T_7df70_row6_col1 {
  background-color: #a8FFa8;
  color: black;
}
#T_7df70_row6_col2 {
  background-color: #41FF41;
  color: black;
}
#T_7df70_row6_col3 {
  background-color: #a5FFa5;
  color: black;
}
#T_7df70_row7_col0 {
  background-color: #e2FFe2;
  color: black;
}
#T_7df70_row7_col1 {
  background-color: #8dFF8d;
  color: black;
}
#T_7df70_row7_col2 {
  background-color: #5cFF5c;
  color: black;
}
#T_7df70_row7_col3 {
  background-color: #c0FFc0;
  color: black;
}
#T_7df70_row8_col0 {
  background-color: #d8FFd8;
  color: black;
}
#T_7df70_row8_col1, #T_7df70_row9_col2 {
  background-color: #64FF64;
  color: black;
}
#T_7df70_row8_col2 {
  background-color: #97FF97;
  color: black;
}
#T_7df70_row8_col3 {
  background-color: #81FF81;
  color: black;
}
#T_7df70_row9_col1 {
  background-color: #f4FFf4;
  color: black;
}
#T_7df70_row9_col3 {
  background-color: #5bFF5b;
  color: black;
}
#T_7df70_row10_col0 {
  background-color: #cbFFcb;
  color: black;
  background: lightblue;
}
#T_7df70_row10_col1 {
  background-color: #b1FFb1;
  color: black;
  background: lightblue;
}
#T_7df70_row10_col2 {
  background-color: #75FF75;
  color: black;
  background: lightblue;
}
#T_7df70_row10_col3 {
  background-color: #8cFF8c;
  color: black;
  background: lightblue;
}
#T_7df70_row11_col0 {
  background-color: #9fFF9f;
  color: black;
  background: lightblue;
}
#T_7df70_row11_col1 {
  background-color: #64FF64;
  color: black;
  background: lightblue;
}
#T_7df70_row11_col2 {
  background-color: #40FF40;
  color: black;
  background: lightblue;
}
#T_7df70_row11_col3 {
  background-color: #3aFF3a;
  color: black;
  background: lightblue;
}
</style>
<table id="T_7df70">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_7df70_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_7df70_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_7df70_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_7df70_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_7df70_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_7df70_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_7df70_row0_col0" class="data row0 col0" >3.0</td>
      <td id="T_7df70_row0_col1" class="data row0 col1" >2.9</td>
      <td id="T_7df70_row0_col2" class="data row0 col2" >3.2</td>
      <td id="T_7df70_row0_col3" class="data row0 col3" >3.3</td>
    </tr>
    <tr>
      <th id="T_7df70_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_7df70_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_7df70_row1_col0" class="data row1 col0" >2.3</td>
      <td id="T_7df70_row1_col1" class="data row1 col1" >3.6</td>
      <td id="T_7df70_row1_col2" class="data row1 col2" >2.4</td>
      <td id="T_7df70_row1_col3" class="data row1 col3" >2.2</td>
    </tr>
    <tr>
      <th id="T_7df70_level0_row2" class="row_heading level0 row2" rowspan="8">write disk</th>
      <th id="T_7df70_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_7df70_row2_col0" class="data row2 col0" >1.1</td>
      <td id="T_7df70_row2_col1" class="data row2 col1" >0.8</td>
      <td id="T_7df70_row2_col2" class="data row2 col2" >2.7</td>
      <td id="T_7df70_row2_col3" class="data row2 col3" >1.7</td>
    </tr>
    <tr>
      <th id="T_7df70_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_7df70_row3_col0" class="data row3 col0" >1.2</td>
      <td id="T_7df70_row3_col1" class="data row3 col1" >0.9</td>
      <td id="T_7df70_row3_col2" class="data row3 col2" >2.2</td>
      <td id="T_7df70_row3_col3" class="data row3 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_7df70_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_7df70_row4_col0" class="data row4 col0" >3.1</td>
      <td id="T_7df70_row4_col1" class="data row4 col1" >2.9</td>
      <td id="T_7df70_row4_col2" class="data row4 col2" >48.4</td>
      <td id="T_7df70_row4_col3" class="data row4 col3" >69.2</td>
    </tr>
    <tr>
      <th id="T_7df70_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_7df70_row5_col0" class="data row5 col0" >1.1</td>
      <td id="T_7df70_row5_col1" class="data row5 col1" >1.7</td>
      <td id="T_7df70_row5_col2" class="data row5 col2" >4.6</td>
      <td id="T_7df70_row5_col3" class="data row5 col3" >3.5</td>
    </tr>
    <tr>
      <th id="T_7df70_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_7df70_row6_col0" class="data row6 col0" >3.0</td>
      <td id="T_7df70_row6_col1" class="data row6 col1" >2.7</td>
      <td id="T_7df70_row6_col2" class="data row6 col2" >45.5</td>
      <td id="T_7df70_row6_col3" class="data row6 col3" >2.8</td>
    </tr>
    <tr>
      <th id="T_7df70_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_7df70_row7_col0" class="data row7 col0" >1.3</td>
      <td id="T_7df70_row7_col1" class="data row7 col1" >4.1</td>
      <td id="T_7df70_row7_col2" class="data row7 col2" >13.7</td>
      <td id="T_7df70_row7_col3" class="data row7 col3" >1.9</td>
    </tr>
    <tr>
      <th id="T_7df70_level1_row8" class="row_heading level1 row8" >write int tiny</th>
      <td id="T_7df70_row8_col0" class="data row8 col0" >1.5</td>
      <td id="T_7df70_row8_col1" class="data row8 col1" >10.7</td>
      <td id="T_7df70_row8_col2" class="data row8 col2" >3.5</td>
      <td id="T_7df70_row8_col3" class="data row8 col3" >5.2</td>
    </tr>
    <tr>
      <th id="T_7df70_level1_row9" class="row_heading level1 row9" >write sym large</th>
      <td id="T_7df70_row9_col0" class="data row9 col0" >1.2</td>
      <td id="T_7df70_row9_col1" class="data row9 col1" >1.1</td>
      <td id="T_7df70_row9_col2" class="data row9 col2" >10.6</td>
      <td id="T_7df70_row9_col3" class="data row9 col3" >14.2</td>
    </tr>
    <tr>
      <th id="T_7df70_level0_row10" class="row_heading level0 row10" >GEOMETRIC MEAN</th>
      <th id="T_7df70_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_7df70_row10_col0" class="data row10 col0" >1.7</td>
      <td id="T_7df70_row10_col1" class="data row10 col1" >2.4</td>
      <td id="T_7df70_row10_col2" class="data row10 col2" >6.9</td>
      <td id="T_7df70_row10_col3" class="data row10 col3" >4.2</td>
    </tr>
    <tr>
      <th id="T_7df70_level0_row11" class="row_heading level0 row11" >MAX RATIO</th>
      <th id="T_7df70_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_7df70_row11_col0" class="data row11 col0" >3.1</td>
      <td id="T_7df70_row11_col1" class="data row11 col1" >10.7</td>
      <td id="T_7df70_row11_col2" class="data row11 col2" >48.4</td>
      <td id="T_7df70_row11_col3" class="data row11 col3" >69.2</td>
    </tr>
  </tbody>
</table>






**Observation**: XFS significantly outperformed all other file systems in writing. Its margin can be significant, for example, persisting a large float vector (the `set` operation) is **over 69 times faster on XFS than on ZFS**.

The performance of the less critical write operations is below.






<style type="text/css">
#T_b2eac th.col_heading.level0 {
  font-size: 1.5em;
}
#T_b2eac_row0_col0, #T_b2eac_row7_col3 {
  background-color: #efFFef;
  color: black;
}
#T_b2eac_row0_col1 {
  background-color: #f1FFf1;
  color: black;
}
#T_b2eac_row0_col2 {
  background-color: #99FF99;
  color: black;
}
#T_b2eac_row0_col3 {
  background-color: #e4FFe4;
  color: black;
}
#T_b2eac_row1_col0 {
  background-color: #FFc4c4;
  color: black;
}
#T_b2eac_row1_col1 {
  background-color: #c4FFc4;
  color: black;
}
#T_b2eac_row1_col2, #T_b2eac_row7_col2 {
  background-color: #73FF73;
  color: black;
}
#T_b2eac_row1_col3 {
  background-color: #e0FFe0;
  color: black;
}
#T_b2eac_row2_col0, #T_b2eac_row17_col1, #T_b2eac_row18_col3 {
  background-color: #fcFFfc;
  color: black;
}
#T_b2eac_row2_col1 {
  background-color: #FFf9f9;
  color: black;
}
#T_b2eac_row2_col2 {
  background-color: #93FF93;
  color: black;
}
#T_b2eac_row2_col3 {
  background-color: #d0FFd0;
  color: black;
}
#T_b2eac_row3_col0 {
  background-color: #ddFFdd;
  color: black;
}
#T_b2eac_row3_col1 {
  background-color: #beFFbe;
  color: black;
}
#T_b2eac_row3_col2 {
  background-color: #52FF52;
  color: black;
}
#T_b2eac_row3_col3 {
  background-color: #a9FFa9;
  color: black;
}
#T_b2eac_row4_col0 {
  background-color: #FFecec;
  color: black;
}
#T_b2eac_row4_col1 {
  background-color: #40FF40;
  color: black;
}
#T_b2eac_row4_col2 {
  background-color: #7eFF7e;
  color: black;
}
#T_b2eac_row4_col3 {
  background-color: #a3FFa3;
  color: black;
}
#T_b2eac_row5_col0 {
  background-color: #7cFF7c;
  color: black;
}
#T_b2eac_row5_col1 {
  background-color: #24FF24;
  color: black;
}
#T_b2eac_row5_col2 {
  background-color: #2fFF2f;
  color: black;
}
#T_b2eac_row5_col3 {
  background-color: #3bFF3b;
  color: black;
}
#T_b2eac_row6_col0, #T_b2eac_row6_col2, #T_b2eac_row6_col3, #T_b2eac_row9_col0, #T_b2eac_row9_col3 {
  background-color: #FF2020;
  color: white;
}
#T_b2eac_row6_col1 {
  background-color: #FF2323;
  color: white;
}
#T_b2eac_row7_col0 {
  background-color: #FFe8e8;
  color: black;
}
#T_b2eac_row7_col1 {
  background-color: #32FF32;
  color: black;
}
#T_b2eac_row8_col0 {
  background-color: #FFd8d8;
  color: black;
}
#T_b2eac_row8_col1 {
  background-color: #30FF30;
  color: black;
}
#T_b2eac_row8_col2 {
  background-color: #44FF44;
  color: black;
}
#T_b2eac_row8_col3 {
  background-color: #FFf5f5;
  color: black;
}
#T_b2eac_row9_col1 {
  background-color: #ffFFff;
  color: black;
}
#T_b2eac_row9_col2 {
  background-color: #FF2d2d;
  color: white;
}
#T_b2eac_row10_col0, #T_b2eac_row10_col1 {
  background-color: #feFFfe;
  color: black;
}
#T_b2eac_row10_col2 {
  background-color: #FF9393;
  color: black;
}
#T_b2eac_row10_col3 {
  background-color: #FF9696;
  color: black;
}
#T_b2eac_row11_col0 {
  background-color: #FF9797;
  color: black;
}
#T_b2eac_row11_col1 {
  background-color: #d8FFd8;
  color: black;
}
#T_b2eac_row11_col2 {
  background-color: #FF3d3d;
  color: white;
}
#T_b2eac_row11_col3 {
  background-color: #c1FFc1;
  color: black;
}
#T_b2eac_row12_col0 {
  background-color: #FFfcfc;
  color: black;
}
#T_b2eac_row12_col1 {
  background-color: #FF2828;
  color: white;
}
#T_b2eac_row12_col2 {
  background-color: #FF9f9f;
  color: black;
}
#T_b2eac_row12_col3 {
  background-color: #FF2a2a;
  color: white;
}
#T_b2eac_row13_col0 {
  background-color: #48FF48;
  color: black;
}
#T_b2eac_row13_col1 {
  background-color: #60FF60;
  color: black;
}
#T_b2eac_row13_col2 {
  background-color: #7fFF7f;
  color: black;
}
#T_b2eac_row13_col3 {
  background-color: #38FF38;
  color: black;
}
#T_b2eac_row14_col0 {
  background-color: #FF2f2f;
  color: white;
}
#T_b2eac_row14_col1 {
  background-color: #FF2b2b;
  color: white;
}
#T_b2eac_row14_col2 {
  background-color: #FF2222;
  color: white;
}
#T_b2eac_row14_col3 {
  background-color: #FF4444;
  color: white;
}
#T_b2eac_row15_col0 {
  background-color: #f0FFf0;
  color: black;
}
#T_b2eac_row15_col1, #T_b2eac_row16_col1 {
  background-color: #caFFca;
  color: black;
}
#T_b2eac_row15_col2 {
  background-color: #79FF79;
  color: black;
}
#T_b2eac_row15_col3 {
  background-color: #9dFF9d;
  color: black;
}
#T_b2eac_row16_col0 {
  background-color: #FFeeee;
  color: black;
}
#T_b2eac_row16_col2 {
  background-color: #adFFad;
  color: black;
}
#T_b2eac_row16_col3 {
  background-color: #a5FFa5;
  color: black;
}
#T_b2eac_row17_col0 {
  background-color: #FFd6d6;
  color: black;
}
#T_b2eac_row17_col2 {
  background-color: #e3FFe3;
  color: black;
}
#T_b2eac_row17_col3 {
  background-color: #acFFac;
  color: black;
}
#T_b2eac_row18_col0 {
  background-color: #fdFFfd;
  color: black;
}
#T_b2eac_row18_col1 {
  background-color: #f8FFf8;
  color: black;
}
#T_b2eac_row18_col2 {
  background-color: #FF9090;
  color: black;
}
#T_b2eac_row19_col0 {
  background-color: #eeFFee;
  color: black;
}
#T_b2eac_row19_col1 {
  background-color: #FFe6e6;
  color: black;
}
#T_b2eac_row19_col2 {
  background-color: #f5FFf5;
  color: black;
}
#T_b2eac_row19_col3 {
  background-color: #33FF33;
  color: black;
}
#T_b2eac_row20_col0 {
  background-color: #FF8e8e;
  color: white;
  background: lightblue;
}
#T_b2eac_row20_col1 {
  background-color: #b3FFb3;
  color: black;
  background: lightblue;
}
#T_b2eac_row20_col2 {
  background-color: #dbFFdb;
  color: black;
  background: lightblue;
}
#T_b2eac_row20_col3 {
  background-color: #f3FFf3;
  color: black;
  background: lightblue;
}
#T_b2eac_row21_col0 {
  background-color: #48FF48;
  color: black;
  background: lightblue;
}
#T_b2eac_row21_col1 {
  background-color: #24FF24;
  color: black;
  background: lightblue;
}
#T_b2eac_row21_col2 {
  background-color: #2fFF2f;
  color: black;
  background: lightblue;
}
#T_b2eac_row21_col3 {
  background-color: #33FF33;
  color: black;
  background: lightblue;
}
</style>
<table id="T_b2eac">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_b2eac_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_b2eac_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_b2eac_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_b2eac_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_b2eac_level0_row0" class="row_heading level0 row0" rowspan="20">write disk</th>
      <th id="T_b2eac_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_b2eac_row0_col0" class="data row0 col0" >1.2</td>
      <td id="T_b2eac_row0_col1" class="data row0 col1" >1.1</td>
      <td id="T_b2eac_row0_col2" class="data row0 col2" >3.4</td>
      <td id="T_b2eac_row0_col3" class="data row0 col3" >1.3</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_b2eac_row1_col0" class="data row1 col0" >0.7</td>
      <td id="T_b2eac_row1_col1" class="data row1 col1" >1.8</td>
      <td id="T_b2eac_row1_col2" class="data row1 col2" >7.1</td>
      <td id="T_b2eac_row1_col3" class="data row1 col3" >1.3</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_b2eac_row2_col0" class="data row2 col0" >1.0</td>
      <td id="T_b2eac_row2_col1" class="data row2 col1" >1.0</td>
      <td id="T_b2eac_row2_col2" class="data row2 col2" >3.8</td>
      <td id="T_b2eac_row2_col3" class="data row2 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_b2eac_row3_col0" class="data row3 col0" >1.4</td>
      <td id="T_b2eac_row3_col1" class="data row3 col1" >2.0</td>
      <td id="T_b2eac_row3_col2" class="data row3 col2" >19.5</td>
      <td id="T_b2eac_row3_col3" class="data row3 col3" >2.6</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row4" class="row_heading level1 row4" >open replace int tiny</th>
      <td id="T_b2eac_row4_col0" class="data row4 col0" >0.9</td>
      <td id="T_b2eac_row4_col1" class="data row4 col1" >47.7</td>
      <td id="T_b2eac_row4_col2" class="data row4 col2" >5.6</td>
      <td id="T_b2eac_row4_col3" class="data row4 col3" >2.9</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row5" class="row_heading level1 row5" >open replace random float large</th>
      <td id="T_b2eac_row5_col0" class="data row5 col0" >5.8</td>
      <td id="T_b2eac_row5_col1" class="data row5 col1" >2262.0</td>
      <td id="T_b2eac_row5_col2" class="data row5 col2" >196.7</td>
      <td id="T_b2eac_row5_col3" class="data row5 col3" >66.0</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row6" class="row_heading level1 row6" >open replace random int huge</th>
      <td id="T_b2eac_row6_col0" class="data row6 col0" >0.0</td>
      <td id="T_b2eac_row6_col1" class="data row6 col1" >0.0</td>
      <td id="T_b2eac_row6_col2" class="data row6 col2" >0.0</td>
      <td id="T_b2eac_row6_col3" class="data row6 col3" >0.0</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row7" class="row_heading level1 row7" >open replace random int medium</th>
      <td id="T_b2eac_row7_col0" class="data row7 col0" >0.9</td>
      <td id="T_b2eac_row7_col1" class="data row7 col1" >138.8</td>
      <td id="T_b2eac_row7_col2" class="data row7 col2" >7.2</td>
      <td id="T_b2eac_row7_col3" class="data row7 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row8" class="row_heading level1 row8" >open replace random int small</th>
      <td id="T_b2eac_row8_col0" class="data row8 col0" >0.8</td>
      <td id="T_b2eac_row8_col1" class="data row8 col1" >182.6</td>
      <td id="T_b2eac_row8_col2" class="data row8 col2" >38.1</td>
      <td id="T_b2eac_row8_col3" class="data row8 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row9" class="row_heading level1 row9" >open replace sorted int huge</th>
      <td id="T_b2eac_row9_col0" class="data row9 col0" >0.0</td>
      <td id="T_b2eac_row9_col1" class="data row9 col1" >1.0</td>
      <td id="T_b2eac_row9_col2" class="data row9 col2" >0.1</td>
      <td id="T_b2eac_row9_col3" class="data row9 col3" >0.0</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row10" class="row_heading level1 row10" >sync float large</th>
      <td id="T_b2eac_row10_col0" class="data row10 col0" >1.0</td>
      <td id="T_b2eac_row10_col1" class="data row10 col1" >1.0</td>
      <td id="T_b2eac_row10_col2" class="data row10 col2" >0.5</td>
      <td id="T_b2eac_row10_col3" class="data row10 col3" >0.5</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row11" class="row_heading level1 row11" >sync float large after replace</th>
      <td id="T_b2eac_row11_col0" class="data row11 col0" >0.5</td>
      <td id="T_b2eac_row11_col1" class="data row11 col1" >1.5</td>
      <td id="T_b2eac_row11_col2" class="data row11 col2" >0.1</td>
      <td id="T_b2eac_row11_col3" class="data row11 col3" >1.9</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row12" class="row_heading level1 row12" >sync int huge</th>
      <td id="T_b2eac_row12_col0" class="data row12 col0" >1.0</td>
      <td id="T_b2eac_row12_col1" class="data row12 col1" >0.0</td>
      <td id="T_b2eac_row12_col2" class="data row12 col2" >0.6</td>
      <td id="T_b2eac_row12_col3" class="data row12 col3" >0.0</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row13" class="row_heading level1 row13" >sync int huge after replace</th>
      <td id="T_b2eac_row13_col0" class="data row13 col0" >29.7</td>
      <td id="T_b2eac_row13_col1" class="data row13 col1" >11.8</td>
      <td id="T_b2eac_row13_col2" class="data row13 col2" >5.5</td>
      <td id="T_b2eac_row13_col3" class="data row13 col3" >86.3</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row14" class="row_heading level1 row14" >sync int huge after sorted replace</th>
      <td id="T_b2eac_row14_col0" class="data row14 col0" >0.1</td>
      <td id="T_b2eac_row14_col1" class="data row14 col1" >0.1</td>
      <td id="T_b2eac_row14_col2" class="data row14 col2" >0.0</td>
      <td id="T_b2eac_row14_col3" class="data row14 col3" >0.2</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row15" class="row_heading level1 row15" >sync int medium</th>
      <td id="T_b2eac_row15_col0" class="data row15 col0" >1.1</td>
      <td id="T_b2eac_row15_col1" class="data row15 col1" >1.7</td>
      <td id="T_b2eac_row15_col2" class="data row15 col2" >6.3</td>
      <td id="T_b2eac_row15_col3" class="data row15 col3" >3.1</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row16" class="row_heading level1 row16" >sync int small</th>
      <td id="T_b2eac_row16_col0" class="data row16 col0" >0.9</td>
      <td id="T_b2eac_row16_col1" class="data row16 col1" >1.7</td>
      <td id="T_b2eac_row16_col2" class="data row16 col2" >2.5</td>
      <td id="T_b2eac_row16_col3" class="data row16 col3" >2.8</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row17" class="row_heading level1 row17" >sync int tiny</th>
      <td id="T_b2eac_row17_col0" class="data row17 col0" >0.8</td>
      <td id="T_b2eac_row17_col1" class="data row17 col1" >1.0</td>
      <td id="T_b2eac_row17_col2" class="data row17 col2" >1.3</td>
      <td id="T_b2eac_row17_col3" class="data row17 col3" >2.5</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row18" class="row_heading level1 row18" >sync sym large</th>
      <td id="T_b2eac_row18_col0" class="data row18 col0" >1.0</td>
      <td id="T_b2eac_row18_col1" class="data row18 col1" >1.1</td>
      <td id="T_b2eac_row18_col2" class="data row18 col2" >0.5</td>
      <td id="T_b2eac_row18_col3" class="data row18 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_b2eac_level1_row19" class="row_heading level1 row19" >sync table after sort</th>
      <td id="T_b2eac_row19_col0" class="data row19 col0" >1.2</td>
      <td id="T_b2eac_row19_col1" class="data row19 col1" >0.9</td>
      <td id="T_b2eac_row19_col2" class="data row19 col2" >1.1</td>
      <td id="T_b2eac_row19_col3" class="data row19 col3" >131.5</td>
    </tr>
    <tr>
      <th id="T_b2eac_level0_row20" class="row_heading level0 row20" >GEOMETRIC MEAN</th>
      <th id="T_b2eac_level1_row20" class="row_heading level1 row20" ></th>
      <td id="T_b2eac_row20_col0" class="data row20 col0" >0.5</td>
      <td id="T_b2eac_row20_col1" class="data row20 col1" >2.3</td>
      <td id="T_b2eac_row20_col2" class="data row20 col2" >1.4</td>
      <td id="T_b2eac_row20_col3" class="data row20 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_b2eac_level0_row21" class="row_heading level0 row21" >MAX RATIO</th>
      <th id="T_b2eac_level1_row21" class="row_heading level1 row21" ></th>
      <td id="T_b2eac_row21_col0" class="data row21 col0" >29.7</td>
      <td id="T_b2eac_row21_col1" class="data row21 col1" >2262.0</td>
      <td id="T_b2eac_row21_col2" class="data row21 col2" >196.7</td>
      <td id="T_b2eac_row21_col3" class="data row21 col3" >131.5</td>
    </tr>
  </tbody>
</table>




### Read

#### Single kdb+ process:




<style type="text/css">
#T_6be41 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_6be41_row0_col0 {
  background-color: #f6FFf6;
  color: black;
}
#T_6be41_row0_col1 {
  background-color: #8aFF8a;
  color: black;
}
#T_6be41_row0_col2, #T_6be41_row3_col2 {
  background-color: #efFFef;
  color: black;
}
#T_6be41_row0_col3, #T_6be41_row3_col1, #T_6be41_row3_col3 {
  background-color: #8bFF8b;
  color: black;
}
#T_6be41_row1_col0, #T_6be41_row4_col0 {
  background-color: #fcFFfc;
  color: black;
}
#T_6be41_row1_col1, #T_6be41_row8_col0 {
  background-color: #e6FFe6;
  color: black;
}
#T_6be41_row1_col2, #T_6be41_row3_col0 {
  background-color: #f8FFf8;
  color: black;
}
#T_6be41_row1_col3, #T_6be41_row11_col0 {
  background-color: #ccFFcc;
  color: black;
}
#T_6be41_row2_col0 {
  background-color: #FFfdfd;
  color: black;
}
#T_6be41_row2_col1 {
  background-color: #77FF77;
  color: black;
}
#T_6be41_row2_col2, #T_6be41_row5_col2 {
  background-color: #fdFFfd;
  color: black;
}
#T_6be41_row2_col3 {
  background-color: #bcFFbc;
  color: black;
}
#T_6be41_row4_col1 {
  background-color: #e9FFe9;
  color: black;
}
#T_6be41_row4_col2 {
  background-color: #f9FFf9;
  color: black;
}
#T_6be41_row4_col3 {
  background-color: #c5FFc5;
  color: black;
}
#T_6be41_row5_col0, #T_6be41_row8_col1 {
  background-color: #FFf7f7;
  color: black;
}
#T_6be41_row5_col1 {
  background-color: #76FF76;
  color: black;
}
#T_6be41_row5_col3 {
  background-color: #baFFba;
  color: black;
}
#T_6be41_row6_col0, #T_6be41_row10_col2 {
  background-color: #bbFFbb;
  color: black;
}
#T_6be41_row6_col1 {
  background-color: #89FF89;
  color: black;
}
#T_6be41_row6_col2 {
  background-color: #e1FFe1;
  color: black;
}
#T_6be41_row6_col3 {
  background-color: #FFd1d1;
  color: black;
}
#T_6be41_row7_col0 {
  background-color: #eeFFee;
  color: black;
}
#T_6be41_row7_col1 {
  background-color: #FFdbdb;
  color: black;
}
#T_6be41_row7_col2, #T_6be41_row8_col2 {
  background-color: #dfFFdf;
  color: black;
}
#T_6be41_row7_col3, #T_6be41_row8_col3 {
  background-color: #9fFF9f;
  color: black;
}
#T_6be41_row9_col0 {
  background-color: #72FF72;
  color: black;
}
#T_6be41_row9_col1 {
  background-color: #84FF84;
  color: black;
}
#T_6be41_row9_col2 {
  background-color: #66FF66;
  color: black;
}
#T_6be41_row9_col3 {
  background-color: #59FF59;
  color: black;
}
#T_6be41_row10_col0 {
  background-color: #a0FFa0;
  color: black;
}
#T_6be41_row10_col1 {
  background-color: #a3FFa3;
  color: black;
}
#T_6be41_row10_col3 {
  background-color: #75FF75;
  color: black;
}
#T_6be41_row11_col1 {
  background-color: #c2FFc2;
  color: black;
}
#T_6be41_row11_col2 {
  background-color: #ecFFec;
  color: black;
}
#T_6be41_row11_col3 {
  background-color: #93FF93;
  color: black;
}
#T_6be41_row12_col0 {
  background-color: #d6FFd6;
  color: black;
  background: lightblue;
}
#T_6be41_row12_col1 {
  background-color: #a9FFa9;
  color: black;
  background: lightblue;
}
#T_6be41_row12_col2 {
  background-color: #d8FFd8;
  color: black;
  background: lightblue;
}
#T_6be41_row12_col3 {
  background-color: #9fFF9f;
  color: black;
  background: lightblue;
}
#T_6be41_row13_col0 {
  background-color: #72FF72;
  color: black;
  background: lightblue;
}
#T_6be41_row13_col1 {
  background-color: #76FF76;
  color: black;
  background: lightblue;
}
#T_6be41_row13_col2 {
  background-color: #66FF66;
  color: black;
  background: lightblue;
}
#T_6be41_row13_col3 {
  background-color: #59FF59;
  color: black;
  background: lightblue;
}
</style>
<table id="T_6be41">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_6be41_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_6be41_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_6be41_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_6be41_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_6be41_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_6be41_level1_row0" class="row_heading level1 row0" >mmap, random read 1M</th>
      <td id="T_6be41_row0_col0" class="data row0 col0" >1.1</td>
      <td id="T_6be41_row0_col1" class="data row0 col1" >4.4</td>
      <td id="T_6be41_row0_col2" class="data row0 col2" >1.2</td>
      <td id="T_6be41_row0_col3" class="data row0 col3" >4.3</td>
    </tr>
    <tr>
      <th id="T_6be41_level1_row1" class="row_heading level1 row1" >mmap, random read 4k</th>
      <td id="T_6be41_row1_col0" class="data row1 col0" >1.0</td>
      <td id="T_6be41_row1_col1" class="data row1 col1" >1.3</td>
      <td id="T_6be41_row1_col2" class="data row1 col2" >1.1</td>
      <td id="T_6be41_row1_col3" class="data row1 col3" >1.7</td>
    </tr>
    <tr>
      <th id="T_6be41_level1_row2" class="row_heading level1 row2" >mmap, random read 64k</th>
      <td id="T_6be41_row2_col0" class="data row2 col0" >1.0</td>
      <td id="T_6be41_row2_col1" class="data row2 col1" >6.5</td>
      <td id="T_6be41_row2_col2" class="data row2 col2" >1.0</td>
      <td id="T_6be41_row2_col3" class="data row2 col3" >2.0</td>
    </tr>
    <tr>
      <th id="T_6be41_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_6be41_row3_col0" class="data row3 col0" >1.1</td>
      <td id="T_6be41_row3_col1" class="data row3 col1" >4.3</td>
      <td id="T_6be41_row3_col2" class="data row3 col2" >1.2</td>
      <td id="T_6be41_row3_col3" class="data row3 col3" >4.3</td>
    </tr>
    <tr>
      <th id="T_6be41_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_6be41_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_6be41_row4_col1" class="data row4 col1" >1.2</td>
      <td id="T_6be41_row4_col2" class="data row4 col2" >1.1</td>
      <td id="T_6be41_row4_col3" class="data row4 col3" >1.8</td>
    </tr>
    <tr>
      <th id="T_6be41_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_6be41_row5_col0" class="data row5 col0" >1.0</td>
      <td id="T_6be41_row5_col1" class="data row5 col1" >6.6</td>
      <td id="T_6be41_row5_col2" class="data row5 col2" >1.0</td>
      <td id="T_6be41_row5_col3" class="data row5 col3" >2.1</td>
    </tr>
    <tr>
      <th id="T_6be41_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_6be41_row6_col0" class="data row6 col0" >2.1</td>
      <td id="T_6be41_row6_col1" class="data row6 col1" >4.5</td>
      <td id="T_6be41_row6_col2" class="data row6 col2" >1.3</td>
      <td id="T_6be41_row6_col3" class="data row6 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_6be41_level0_row7" class="row_heading level0 row7" rowspan="5">read disk write mem</th>
      <th id="T_6be41_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_6be41_row7_col0" class="data row7 col0" >1.2</td>
      <td id="T_6be41_row7_col1" class="data row7 col1" >0.8</td>
      <td id="T_6be41_row7_col2" class="data row7 col2" >1.4</td>
      <td id="T_6be41_row7_col3" class="data row7 col3" >3.0</td>
    </tr>
    <tr>
      <th id="T_6be41_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_6be41_row8_col0" class="data row8 col0" >1.3</td>
      <td id="T_6be41_row8_col1" class="data row8 col1" >1.0</td>
      <td id="T_6be41_row8_col2" class="data row8 col2" >1.4</td>
      <td id="T_6be41_row8_col3" class="data row8 col3" >3.0</td>
    </tr>
    <tr>
      <th id="T_6be41_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_6be41_row9_col0" class="data row9 col0" >7.3</td>
      <td id="T_6be41_row9_col1" class="data row9 col1" >4.9</td>
      <td id="T_6be41_row9_col2" class="data row9 col2" >10.1</td>
      <td id="T_6be41_row9_col3" class="data row9 col3" >14.9</td>
    </tr>
    <tr>
      <th id="T_6be41_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_6be41_row10_col0" class="data row10 col0" >3.0</td>
      <td id="T_6be41_row10_col1" class="data row10 col1" >2.9</td>
      <td id="T_6be41_row10_col2" class="data row10 col2" >2.0</td>
      <td id="T_6be41_row10_col3" class="data row10 col3" >6.9</td>
    </tr>
    <tr>
      <th id="T_6be41_level1_row11" class="row_heading level1 row11" >sequential read int tiny</th>
      <td id="T_6be41_row11_col0" class="data row11 col0" >1.7</td>
      <td id="T_6be41_row11_col1" class="data row11 col1" >1.9</td>
      <td id="T_6be41_row11_col2" class="data row11 col2" >1.2</td>
      <td id="T_6be41_row11_col3" class="data row11 col3" >3.7</td>
    </tr>
    <tr>
      <th id="T_6be41_level0_row12" class="row_heading level0 row12" >GEOMETRIC MEAN</th>
      <th id="T_6be41_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_6be41_row12_col0" class="data row12 col0" >1.5</td>
      <td id="T_6be41_row12_col1" class="data row12 col1" >2.6</td>
      <td id="T_6be41_row12_col2" class="data row12 col2" >1.5</td>
      <td id="T_6be41_row12_col3" class="data row12 col3" >3.1</td>
    </tr>
    <tr>
      <th id="T_6be41_level0_row13" class="row_heading level0 row13" >MAX RATIO</th>
      <th id="T_6be41_level1_row13" class="row_heading level1 row13" ></th>
      <td id="T_6be41_row13_col0" class="data row13 col0" >7.3</td>
      <td id="T_6be41_row13_col1" class="data row13 col1" >6.6</td>
      <td id="T_6be41_row13_col2" class="data row13 col2" >10.1</td>
      <td id="T_6be41_row13_col3" class="data row13 col3" >14.9</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS excels in reading from disk if there is a single kdb+ reader.




<style type="text/css">
#T_22d49 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_22d49_row0_col0, #T_22d49_row0_col3 {
  background-color: #f0FFf0;
  color: black;
}
#T_22d49_row0_col1 {
  background-color: #f1FFf1;
  color: black;
}
#T_22d49_row0_col2, #T_22d49_row5_col2 {
  background-color: #eaFFea;
  color: black;
}
#T_22d49_row1_col0 {
  background-color: #FFeded;
  color: black;
}
#T_22d49_row1_col1 {
  background-color: #FFfbfb;
  color: black;
}
#T_22d49_row1_col2, #T_22d49_row4_col0 {
  background-color: #FFfefe;
  color: black;
}
#T_22d49_row1_col3 {
  background-color: #FFdddd;
  color: black;
}
#T_22d49_row2_col0 {
  background-color: #f8FFf8;
  color: black;
}
#T_22d49_row2_col1, #T_22d49_row4_col1, #T_22d49_row5_col3 {
  background-color: #faFFfa;
  color: black;
}
#T_22d49_row2_col2 {
  background-color: #f5FFf5;
  color: black;
}
#T_22d49_row2_col3 {
  background-color: #feFFfe;
  color: black;
}
#T_22d49_row3_col0 {
  background-color: #e0FFe0;
  color: black;
}
#T_22d49_row3_col1 {
  background-color: #ddFFdd;
  color: black;
}
#T_22d49_row3_col2 {
  background-color: #e9FFe9;
  color: black;
}
#T_22d49_row3_col3 {
  background-color: #d9FFd9;
  color: black;
}
#T_22d49_row4_col2 {
  background-color: #f3FFf3;
  color: black;
}
#T_22d49_row4_col3 {
  background-color: #FFc1c1;
  color: black;
}
#T_22d49_row5_col0 {
  background-color: #f4FFf4;
  color: black;
}
#T_22d49_row5_col1, #T_22d49_row6_col0, #T_22d49_row6_col3 {
  background-color: #fcFFfc;
  color: black;
}
#T_22d49_row6_col1 {
  background-color: #f9FFf9;
  color: black;
}
#T_22d49_row6_col2 {
  background-color: #FFfdfd;
  color: black;
}
#T_22d49_row7_col0 {
  background-color: #cbFFcb;
  color: black;
}
#T_22d49_row7_col1 {
  background-color: #afFFaf;
  color: black;
}
#T_22d49_row7_col2 {
  background-color: #adFFad;
  color: black;
}
#T_22d49_row7_col3 {
  background-color: #b5FFb5;
  color: black;
}
#T_22d49_row8_col0 {
  background-color: #c0FFc0;
  color: black;
}
#T_22d49_row8_col1 {
  background-color: #baFFba;
  color: black;
}
#T_22d49_row8_col2 {
  background-color: #b3FFb3;
  color: black;
}
#T_22d49_row8_col3 {
  background-color: #c2FFc2;
  color: black;
}
#T_22d49_row9_col0 {
  background-color: #96FF96;
  color: black;
}
#T_22d49_row9_col1 {
  background-color: #98FF98;
  color: black;
}
#T_22d49_row9_col2 {
  background-color: #93FF93;
  color: black;
}
#T_22d49_row9_col3 {
  background-color: #aaFFaa;
  color: black;
}
#T_22d49_row10_col0 {
  background-color: #FFe2e2;
  color: black;
}
#T_22d49_row10_col1 {
  background-color: #FFf5f5;
  color: black;
}
#T_22d49_row10_col2 {
  background-color: #FFeeee;
  color: black;
}
#T_22d49_row10_col3 {
  background-color: #FFdede;
  color: black;
}
#T_22d49_row11_col0 {
  background-color: #e3FFe3;
  color: black;
  background: lightblue;
}
#T_22d49_row11_col1 {
  background-color: #dfFFdf;
  color: black;
  background: lightblue;
}
#T_22d49_row11_col2 {
  background-color: #dbFFdb;
  color: black;
  background: lightblue;
}
#T_22d49_row11_col3 {
  background-color: #e8FFe8;
  color: black;
  background: lightblue;
}
#T_22d49_row12_col0 {
  background-color: #96FF96;
  color: black;
  background: lightblue;
}
#T_22d49_row12_col1 {
  background-color: #98FF98;
  color: black;
  background: lightblue;
}
#T_22d49_row12_col2 {
  background-color: #93FF93;
  color: black;
  background: lightblue;
}
#T_22d49_row12_col3 {
  background-color: #aaFFaa;
  color: black;
  background: lightblue;
}
</style>
<table id="T_22d49">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_22d49_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_22d49_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_22d49_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_22d49_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_22d49_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_22d49_level1_row0" class="row_heading level1 row0" >mmap, random read 1M</th>
      <td id="T_22d49_row0_col0" class="data row0 col0" >1.1</td>
      <td id="T_22d49_row0_col1" class="data row0 col1" >1.1</td>
      <td id="T_22d49_row0_col2" class="data row0 col2" >1.2</td>
      <td id="T_22d49_row0_col3" class="data row0 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_22d49_level1_row1" class="row_heading level1 row1" >mmap, random read 4k</th>
      <td id="T_22d49_row1_col0" class="data row1 col0" >0.9</td>
      <td id="T_22d49_row1_col1" class="data row1 col1" >1.0</td>
      <td id="T_22d49_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_22d49_row1_col3" class="data row1 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_22d49_level1_row2" class="row_heading level1 row2" >mmap, random read 64k</th>
      <td id="T_22d49_row2_col0" class="data row2 col0" >1.1</td>
      <td id="T_22d49_row2_col1" class="data row2 col1" >1.0</td>
      <td id="T_22d49_row2_col2" class="data row2 col2" >1.1</td>
      <td id="T_22d49_row2_col3" class="data row2 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_22d49_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_22d49_row3_col0" class="data row3 col0" >1.3</td>
      <td id="T_22d49_row3_col1" class="data row3 col1" >1.4</td>
      <td id="T_22d49_row3_col2" class="data row3 col2" >1.2</td>
      <td id="T_22d49_row3_col3" class="data row3 col3" >1.5</td>
    </tr>
    <tr>
      <th id="T_22d49_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_22d49_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_22d49_row4_col1" class="data row4 col1" >1.0</td>
      <td id="T_22d49_row4_col2" class="data row4 col2" >1.1</td>
      <td id="T_22d49_row4_col3" class="data row4 col3" >0.7</td>
    </tr>
    <tr>
      <th id="T_22d49_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_22d49_row5_col0" class="data row5 col0" >1.1</td>
      <td id="T_22d49_row5_col1" class="data row5 col1" >1.0</td>
      <td id="T_22d49_row5_col2" class="data row5 col2" >1.2</td>
      <td id="T_22d49_row5_col3" class="data row5 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_22d49_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_22d49_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_22d49_row6_col0" class="data row6 col0" >1.0</td>
      <td id="T_22d49_row6_col1" class="data row6 col1" >1.0</td>
      <td id="T_22d49_row6_col2" class="data row6 col2" >1.0</td>
      <td id="T_22d49_row6_col3" class="data row6 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_22d49_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_22d49_row7_col0" class="data row7 col0" >1.7</td>
      <td id="T_22d49_row7_col1" class="data row7 col1" >2.4</td>
      <td id="T_22d49_row7_col2" class="data row7 col2" >2.5</td>
      <td id="T_22d49_row7_col3" class="data row7 col3" >2.2</td>
    </tr>
    <tr>
      <th id="T_22d49_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_22d49_row8_col0" class="data row8 col0" >1.9</td>
      <td id="T_22d49_row8_col1" class="data row8 col1" >2.1</td>
      <td id="T_22d49_row8_col2" class="data row8 col2" >2.3</td>
      <td id="T_22d49_row8_col3" class="data row8 col3" >1.9</td>
    </tr>
    <tr>
      <th id="T_22d49_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_22d49_row9_col0" class="data row9 col0" >3.6</td>
      <td id="T_22d49_row9_col1" class="data row9 col1" >3.4</td>
      <td id="T_22d49_row9_col2" class="data row9 col2" >3.7</td>
      <td id="T_22d49_row9_col3" class="data row9 col3" >2.6</td>
    </tr>
    <tr>
      <th id="T_22d49_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_22d49_row10_col0" class="data row10 col0" >0.9</td>
      <td id="T_22d49_row10_col1" class="data row10 col1" >1.0</td>
      <td id="T_22d49_row10_col2" class="data row10 col2" >0.9</td>
      <td id="T_22d49_row10_col3" class="data row10 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_22d49_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_22d49_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_22d49_row11_col0" class="data row11 col0" >1.3</td>
      <td id="T_22d49_row11_col1" class="data row11 col1" >1.4</td>
      <td id="T_22d49_row11_col2" class="data row11 col2" >1.4</td>
      <td id="T_22d49_row11_col3" class="data row11 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_22d49_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_22d49_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_22d49_row12_col0" class="data row12 col0" >3.6</td>
      <td id="T_22d49_row12_col1" class="data row12 col1" >3.4</td>
      <td id="T_22d49_row12_col2" class="data row12 col2" >3.7</td>
      <td id="T_22d49_row12_col3" class="data row12 col3" >2.6</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS excels in (sequential) reading from page cache if there is a single kdb+ reader.

#### 64 kdb+ processes:




<style type="text/css">
#T_1214c th.col_heading.level0 {
  font-size: 1.5em;
}
#T_1214c_row0_col0, #T_1214c_row3_col0, #T_1214c_row4_col1 {
  background-color: #feFFfe;
  color: black;
}
#T_1214c_row0_col1, #T_1214c_row3_col1 {
  background-color: #b5FFb5;
  color: black;
}
#T_1214c_row0_col2 {
  background-color: #FFeeee;
  color: black;
}
#T_1214c_row0_col3 {
  background-color: #eeFFee;
  color: black;
}
#T_1214c_row1_col0 {
  background-color: #FFfcfc;
  color: black;
}
#T_1214c_row1_col1 {
  background-color: #f3FFf3;
  color: black;
}
#T_1214c_row1_col2 {
  background-color: #FFf2f2;
  color: black;
}
#T_1214c_row1_col3 {
  background-color: #d1FFd1;
  color: black;
}
#T_1214c_row2_col0 {
  background-color: #FFd1d1;
  color: black;
}
#T_1214c_row2_col1, #T_1214c_row5_col1 {
  background-color: #d5FFd5;
  color: black;
}
#T_1214c_row2_col2 {
  background-color: #FFc6c6;
  color: black;
}
#T_1214c_row2_col3 {
  background-color: #FFe4e4;
  color: black;
}
#T_1214c_row3_col2 {
  background-color: #FFefef;
  color: black;
}
#T_1214c_row3_col3 {
  background-color: #ecFFec;
  color: black;
}
#T_1214c_row4_col0 {
  background-color: #FFfefe;
  color: black;
}
#T_1214c_row4_col2 {
  background-color: #FFf1f1;
  color: black;
}
#T_1214c_row4_col3 {
  background-color: #cfFFcf;
  color: black;
}
#T_1214c_row5_col0 {
  background-color: #FFd2d2;
  color: black;
}
#T_1214c_row5_col2 {
  background-color: #FFc8c8;
  color: black;
}
#T_1214c_row5_col3 {
  background-color: #FFe8e8;
  color: black;
}
#T_1214c_row6_col0, #T_1214c_row6_col2 {
  background-color: #6aFF6a;
  color: black;
}
#T_1214c_row6_col1 {
  background-color: #6eFF6e;
  color: black;
}
#T_1214c_row6_col3 {
  background-color: #64FF64;
  color: black;
}
#T_1214c_row7_col0 {
  background-color: #FFbfbf;
  color: black;
}
#T_1214c_row7_col1 {
  background-color: #FFa8a8;
  color: black;
}
#T_1214c_row7_col2 {
  background-color: #FFc0c0;
  color: black;
}
#T_1214c_row7_col3 {
  background-color: #FFdcdc;
  color: black;
}
#T_1214c_row8_col0, #T_1214c_row8_col1 {
  background-color: #FFe7e7;
  color: black;
}
#T_1214c_row8_col2 {
  background-color: #FFf0f0;
  color: black;
}
#T_1214c_row8_col3 {
  background-color: #f0FFf0;
  color: black;
}
#T_1214c_row9_col0 {
  background-color: #FFfafa;
  color: black;
}
#T_1214c_row9_col1 {
  background-color: #FFa0a0;
  color: black;
}
#T_1214c_row9_col2 {
  background-color: #FFfdfd;
  color: black;
}
#T_1214c_row9_col3 {
  background-color: #d9FFd9;
  color: black;
}
#T_1214c_row10_col0 {
  background-color: #f8FFf8;
  color: black;
}
#T_1214c_row10_col1 {
  background-color: #FFb7b7;
  color: black;
}
#T_1214c_row10_col2, #T_1214c_row11_col0 {
  background-color: #f9FFf9;
  color: black;
}
#T_1214c_row10_col3 {
  background-color: #d0FFd0;
  color: black;
}
#T_1214c_row11_col1 {
  background-color: #ceFFce;
  color: black;
}
#T_1214c_row11_col2 {
  background-color: #c9FFc9;
  color: black;
}
#T_1214c_row11_col3 {
  background-color: #a4FFa4;
  color: black;
}
#T_1214c_row12_col0 {
  background-color: #f2FFf2;
  color: black;
  background: lightblue;
}
#T_1214c_row12_col1 {
  background-color: #e0FFe0;
  color: black;
  background: lightblue;
}
#T_1214c_row12_col2 {
  background-color: #f1FFf1;
  color: black;
  background: lightblue;
}
#T_1214c_row12_col3 {
  background-color: #d3FFd3;
  color: black;
  background: lightblue;
}
#T_1214c_row13_col0, #T_1214c_row13_col2 {
  background-color: #6aFF6a;
  color: black;
  background: lightblue;
}
#T_1214c_row13_col1 {
  background-color: #6eFF6e;
  color: black;
  background: lightblue;
}
#T_1214c_row13_col3 {
  background-color: #64FF64;
  color: black;
  background: lightblue;
}
</style>
<table id="T_1214c">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_1214c_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_1214c_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_1214c_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_1214c_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_1214c_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_1214c_level1_row0" class="row_heading level1 row0" >mmap, random read 1M</th>
      <td id="T_1214c_row0_col0" class="data row0 col0" >1.0</td>
      <td id="T_1214c_row0_col1" class="data row0 col1" >2.2</td>
      <td id="T_1214c_row0_col2" class="data row0 col2" >0.9</td>
      <td id="T_1214c_row0_col3" class="data row0 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_1214c_level1_row1" class="row_heading level1 row1" >mmap, random read 4k</th>
      <td id="T_1214c_row1_col0" class="data row1 col0" >1.0</td>
      <td id="T_1214c_row1_col1" class="data row1 col1" >1.1</td>
      <td id="T_1214c_row1_col2" class="data row1 col2" >0.9</td>
      <td id="T_1214c_row1_col3" class="data row1 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_1214c_level1_row2" class="row_heading level1 row2" >mmap, random read 64k</th>
      <td id="T_1214c_row2_col0" class="data row2 col0" >0.8</td>
      <td id="T_1214c_row2_col1" class="data row2 col1" >1.5</td>
      <td id="T_1214c_row2_col2" class="data row2 col2" >0.7</td>
      <td id="T_1214c_row2_col3" class="data row2 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_1214c_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_1214c_row3_col0" class="data row3 col0" >1.0</td>
      <td id="T_1214c_row3_col1" class="data row3 col1" >2.2</td>
      <td id="T_1214c_row3_col2" class="data row3 col2" >0.9</td>
      <td id="T_1214c_row3_col3" class="data row3 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_1214c_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_1214c_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_1214c_row4_col1" class="data row4 col1" >1.0</td>
      <td id="T_1214c_row4_col2" class="data row4 col2" >0.9</td>
      <td id="T_1214c_row4_col3" class="data row4 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_1214c_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_1214c_row5_col0" class="data row5 col0" >0.8</td>
      <td id="T_1214c_row5_col1" class="data row5 col1" >1.5</td>
      <td id="T_1214c_row5_col2" class="data row5 col2" >0.8</td>
      <td id="T_1214c_row5_col3" class="data row5 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_1214c_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_1214c_row6_col0" class="data row6 col0" >8.9</td>
      <td id="T_1214c_row6_col1" class="data row6 col1" >8.2</td>
      <td id="T_1214c_row6_col2" class="data row6 col2" >8.9</td>
      <td id="T_1214c_row6_col3" class="data row6 col3" >10.5</td>
    </tr>
    <tr>
      <th id="T_1214c_level0_row7" class="row_heading level0 row7" rowspan="5">read disk write mem</th>
      <th id="T_1214c_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_1214c_row7_col0" class="data row7 col0" >0.7</td>
      <td id="T_1214c_row7_col1" class="data row7 col1" >0.6</td>
      <td id="T_1214c_row7_col2" class="data row7 col2" >0.7</td>
      <td id="T_1214c_row7_col3" class="data row7 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_1214c_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_1214c_row8_col0" class="data row8 col0" >0.9</td>
      <td id="T_1214c_row8_col1" class="data row8 col1" >0.9</td>
      <td id="T_1214c_row8_col2" class="data row8 col2" >0.9</td>
      <td id="T_1214c_row8_col3" class="data row8 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_1214c_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_1214c_row9_col0" class="data row9 col0" >1.0</td>
      <td id="T_1214c_row9_col1" class="data row9 col1" >0.6</td>
      <td id="T_1214c_row9_col2" class="data row9 col2" >1.0</td>
      <td id="T_1214c_row9_col3" class="data row9 col3" >1.5</td>
    </tr>
    <tr>
      <th id="T_1214c_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_1214c_row10_col0" class="data row10 col0" >1.1</td>
      <td id="T_1214c_row10_col1" class="data row10 col1" >0.7</td>
      <td id="T_1214c_row10_col2" class="data row10 col2" >1.1</td>
      <td id="T_1214c_row10_col3" class="data row10 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_1214c_level1_row11" class="row_heading level1 row11" >sequential read int tiny</th>
      <td id="T_1214c_row11_col0" class="data row11 col0" >1.0</td>
      <td id="T_1214c_row11_col1" class="data row11 col1" >1.6</td>
      <td id="T_1214c_row11_col2" class="data row11 col2" >1.7</td>
      <td id="T_1214c_row11_col3" class="data row11 col3" >2.8</td>
    </tr>
    <tr>
      <th id="T_1214c_level0_row12" class="row_heading level0 row12" >GEOMETRIC MEAN</th>
      <th id="T_1214c_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_1214c_row12_col0" class="data row12 col0" >1.1</td>
      <td id="T_1214c_row12_col1" class="data row12 col1" >1.3</td>
      <td id="T_1214c_row12_col2" class="data row12 col2" >1.1</td>
      <td id="T_1214c_row12_col3" class="data row12 col3" >1.5</td>
    </tr>
    <tr>
      <th id="T_1214c_level0_row13" class="row_heading level0 row13" >MAX RATIO</th>
      <th id="T_1214c_level1_row13" class="row_heading level1 row13" ></th>
      <td id="T_1214c_row13_col0" class="data row13 col0" >8.9</td>
      <td id="T_1214c_row13_col1" class="data row13 col1" >8.2</td>
      <td id="T_1214c_row13_col2" class="data row13 col2" >8.9</td>
      <td id="T_1214c_row13_col3" class="data row13 col3" >10.5</td>
    </tr>
  </tbody>
</table>




**Observation**: We observed that F2FS maintains a performance margin parallel disk reads from multiple kdb+ processes (e.g., an HDB pool). The sole exception was with binary reads (`read1`), a pattern not typically encountered in production kdb+ environments.




<style type="text/css">
#T_5f94e th.col_heading.level0 {
  font-size: 1.5em;
}
#T_5f94e_row0_col0, #T_5f94e_row5_col2 {
  background-color: #f7FFf7;
  color: black;
}
#T_5f94e_row0_col1, #T_5f94e_row2_col1, #T_5f94e_row2_col2 {
  background-color: #f9FFf9;
  color: black;
}
#T_5f94e_row0_col2, #T_5f94e_row3_col0 {
  background-color: #f3FFf3;
  color: black;
}
#T_5f94e_row0_col3 {
  background-color: #f5FFf5;
  color: black;
}
#T_5f94e_row1_col0, #T_5f94e_row10_col1 {
  background-color: #FFfefe;
  color: black;
}
#T_5f94e_row1_col1, #T_5f94e_row3_col3 {
  background-color: #feFFfe;
  color: black;
}
#T_5f94e_row1_col2 {
  background-color: #FFfcfc;
  color: black;
}
#T_5f94e_row1_col3 {
  background-color: #c5FFc5;
  color: black;
}
#T_5f94e_row2_col0 {
  background-color: #d0FFd0;
  color: black;
}
#T_5f94e_row2_col3 {
  background-color: #b7FFb7;
  color: black;
}
#T_5f94e_row3_col1, #T_5f94e_row5_col0, #T_5f94e_row5_col3, #T_5f94e_row6_col2, #T_5f94e_row10_col0 {
  background-color: #faFFfa;
  color: black;
}
#T_5f94e_row3_col2 {
  background-color: #f6FFf6;
  color: black;
}
#T_5f94e_row4_col0, #T_5f94e_row4_col1 {
  background-color: #fdFFfd;
  color: black;
}
#T_5f94e_row4_col2 {
  background-color: #FFfdfd;
  color: black;
}
#T_5f94e_row4_col3 {
  background-color: #FFe0e0;
  color: black;
}
#T_5f94e_row5_col1, #T_5f94e_row6_col1, #T_5f94e_row10_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_5f94e_row6_col0 {
  background-color: #fbFFfb;
  color: black;
}
#T_5f94e_row6_col3 {
  background-color: #d5FFd5;
  color: black;
}
#T_5f94e_row7_col0 {
  background-color: #c1FFc1;
  color: black;
}
#T_5f94e_row7_col1 {
  background-color: #c3FFc3;
  color: black;
}
#T_5f94e_row7_col2 {
  background-color: #3dFF3d;
  color: black;
}
#T_5f94e_row7_col3 {
  background-color: #85FF85;
  color: black;
}
#T_5f94e_row8_col0 {
  background-color: #cdFFcd;
  color: black;
}
#T_5f94e_row8_col1, #T_5f94e_row10_col3 {
  background-color: #ccFFcc;
  color: black;
}
#T_5f94e_row8_col2 {
  background-color: #5cFF5c;
  color: black;
}
#T_5f94e_row8_col3 {
  background-color: #c0FFc0;
  color: black;
}
#T_5f94e_row9_col0 {
  background-color: #beFFbe;
  color: black;
}
#T_5f94e_row9_col1 {
  background-color: #baFFba;
  color: black;
}
#T_5f94e_row9_col2 {
  background-color: #bcFFbc;
  color: black;
}
#T_5f94e_row9_col3 {
  background-color: #72FF72;
  color: black;
}
#T_5f94e_row11_col0 {
  background-color: #e6FFe6;
  color: black;
  background: lightblue;
}
#T_5f94e_row11_col1 {
  background-color: #eaFFea;
  color: black;
  background: lightblue;
}
#T_5f94e_row11_col2 {
  background-color: #bdFFbd;
  color: black;
  background: lightblue;
}
#T_5f94e_row11_col3 {
  background-color: #c5FFc5;
  color: black;
  background: lightblue;
}
#T_5f94e_row12_col0 {
  background-color: #beFFbe;
  color: black;
  background: lightblue;
}
#T_5f94e_row12_col1 {
  background-color: #baFFba;
  color: black;
  background: lightblue;
}
#T_5f94e_row12_col2 {
  background-color: #3dFF3d;
  color: black;
  background: lightblue;
}
#T_5f94e_row12_col3 {
  background-color: #72FF72;
  color: black;
  background: lightblue;
}
</style>
<table id="T_5f94e">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="blank level0" >&nbsp;</th>
      <th id="T_5f94e_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_5f94e_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_5f94e_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_5f94e_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >Test Type</th>
      <th class="index_name level1" >Test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_5f94e_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_5f94e_level1_row0" class="row_heading level1 row0" >mmap, random read 1M</th>
      <td id="T_5f94e_row0_col0" class="data row0 col0" >1.1</td>
      <td id="T_5f94e_row0_col1" class="data row0 col1" >1.1</td>
      <td id="T_5f94e_row0_col2" class="data row0 col2" >1.1</td>
      <td id="T_5f94e_row0_col3" class="data row0 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_5f94e_level1_row1" class="row_heading level1 row1" >mmap, random read 4k</th>
      <td id="T_5f94e_row1_col0" class="data row1 col0" >1.0</td>
      <td id="T_5f94e_row1_col1" class="data row1 col1" >1.0</td>
      <td id="T_5f94e_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_5f94e_row1_col3" class="data row1 col3" >1.8</td>
    </tr>
    <tr>
      <th id="T_5f94e_level1_row2" class="row_heading level1 row2" >mmap, random read 64k</th>
      <td id="T_5f94e_row2_col0" class="data row2 col0" >1.6</td>
      <td id="T_5f94e_row2_col1" class="data row2 col1" >1.1</td>
      <td id="T_5f94e_row2_col2" class="data row2 col2" >1.1</td>
      <td id="T_5f94e_row2_col3" class="data row2 col3" >2.2</td>
    </tr>
    <tr>
      <th id="T_5f94e_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_5f94e_row3_col0" class="data row3 col0" >1.1</td>
      <td id="T_5f94e_row3_col1" class="data row3 col1" >1.0</td>
      <td id="T_5f94e_row3_col2" class="data row3 col2" >1.1</td>
      <td id="T_5f94e_row3_col3" class="data row3 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_5f94e_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_5f94e_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_5f94e_row4_col1" class="data row4 col1" >1.0</td>
      <td id="T_5f94e_row4_col2" class="data row4 col2" >1.0</td>
      <td id="T_5f94e_row4_col3" class="data row4 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_5f94e_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_5f94e_row5_col0" class="data row5 col0" >1.0</td>
      <td id="T_5f94e_row5_col1" class="data row5 col1" >1.0</td>
      <td id="T_5f94e_row5_col2" class="data row5 col2" >1.1</td>
      <td id="T_5f94e_row5_col3" class="data row5 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_5f94e_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_5f94e_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_5f94e_row6_col0" class="data row6 col0" >1.0</td>
      <td id="T_5f94e_row6_col1" class="data row6 col1" >1.0</td>
      <td id="T_5f94e_row6_col2" class="data row6 col2" >1.0</td>
      <td id="T_5f94e_row6_col3" class="data row6 col3" >1.5</td>
    </tr>
    <tr>
      <th id="T_5f94e_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_5f94e_row7_col0" class="data row7 col0" >1.9</td>
      <td id="T_5f94e_row7_col1" class="data row7 col1" >1.9</td>
      <td id="T_5f94e_row7_col2" class="data row7 col2" >57.7</td>
      <td id="T_5f94e_row7_col3" class="data row7 col3" >4.8</td>
    </tr>
    <tr>
      <th id="T_5f94e_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_5f94e_row8_col0" class="data row8 col0" >1.6</td>
      <td id="T_5f94e_row8_col1" class="data row8 col1" >1.7</td>
      <td id="T_5f94e_row8_col2" class="data row8 col2" >13.5</td>
      <td id="T_5f94e_row8_col3" class="data row8 col3" >1.9</td>
    </tr>
    <tr>
      <th id="T_5f94e_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_5f94e_row9_col0" class="data row9 col0" >2.0</td>
      <td id="T_5f94e_row9_col1" class="data row9 col1" >2.1</td>
      <td id="T_5f94e_row9_col2" class="data row9 col2" >2.0</td>
      <td id="T_5f94e_row9_col3" class="data row9 col3" >7.4</td>
    </tr>
    <tr>
      <th id="T_5f94e_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_5f94e_row10_col0" class="data row10 col0" >1.0</td>
      <td id="T_5f94e_row10_col1" class="data row10 col1" >1.0</td>
      <td id="T_5f94e_row10_col2" class="data row10 col2" >1.0</td>
      <td id="T_5f94e_row10_col3" class="data row10 col3" >1.7</td>
    </tr>
    <tr>
      <th id="T_5f94e_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_5f94e_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_5f94e_row11_col0" class="data row11 col0" >1.3</td>
      <td id="T_5f94e_row11_col1" class="data row11 col1" >1.2</td>
      <td id="T_5f94e_row11_col2" class="data row11 col2" >2.0</td>
      <td id="T_5f94e_row11_col3" class="data row11 col3" >1.8</td>
    </tr>
    <tr>
      <th id="T_5f94e_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_5f94e_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_5f94e_row12_col0" class="data row12 col0" >2.0</td>
      <td id="T_5f94e_row12_col1" class="data row12 col1" >2.1</td>
      <td id="T_5f94e_row12_col2" class="data row12 col2" >57.7</td>
      <td id="T_5f94e_row12_col3" class="data row12 col3" >7.4</td>
    </tr>
  </tbody>
</table>




**Observation**: The performance advantage of F2FS vanishes entirely when data is served from the page cache. XFS is the clear winner if data is read sequentially by multiple kdb+ processes.
