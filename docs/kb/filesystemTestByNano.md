# Choosing the Right File System for kdb+: A Case Study with KX Nano

The performance of a kdb+ system is critically dependent on the throughput and latency of its underlying storage. In a Linux environment, the file system is the foundational layer that enables data management on a given storage partition.

This paper presents a comparative performance analysis of various file systems using the [KX Nano](https://github.com/KxSystems/nano) benchmarking utility. The evaluation was conducted across two distinct test environments, each with different operating systems and storage bandwidth (6500 vs 14000 MB/s) and IOPS (700K vs 2500K).

### Summary

No single file system demonstrated superior performance across all tested metrics; the optimal choice depends on the primary workload characteristics. The optimal choice depends on the specific operations you need to accelerate. Furthermore, the host operating system (e.g., Red Hat Enterprise Linux vs. Ubuntu) constrains the set of available and supported file systems.

Our key recommendations are as follows:

   * For **write-intensive workloads** where **data ingestion rate is the primary driver**, XFS is the recommended file system.
      * XFS consistently demonstrated the highest write throughput, particularly under concurrent write scenarios. For instance, a kdb+ [set](https://code.kx.com/q/ref/get/#set) operation on a large float vector (31 million elements) executed **5.5x faster on XFS than on ext4** and nearly **50x faster than on ZFS**.
      * This superior write performance **translates to significant speedups** in other I/O-heavy operations. Parallel disk sorting was **3.4x faster**, and applying the `p#` (parted) attribute was **6.6x faster** on XFS compared to ext4. Consequently, workloads like end-of-day (EOD) data processing will achieve the best performance with XFS.

   * For **read-intensive workloads** where **query latency is paramount**, the choice is nuanced:
      * On Red Hat Enterprise Linux 9, ext4 holds a slight advantage for queries dominated by **sequential reads**. For random reads, its performance was comparable to XFS.
      * On Ubuntu, **ZFS excelled in random read** scenarios. However, this performance advantage diminished significantly if the requested data was already available in the operating system's page cache.

kdb+ also supports **tiering**. For tiered data architectures (e.g., hot, mid, cold tiers), a hybrid approach is advisable.

   * **Hot tier**: Data is frequently queried and often resides in the page cache. For this tier, a read-optimized file system like ext4 or XFS is effective.
   * **Mid/Cold Tier**: Data is queried less often, meaning reads are more likely to come directly from storage. In this scenario, ZFS's strong random read performance from storage provides a distinct advantage.

**Disclaimer**: These guidelines are specific to the tested hardware and workloads. We strongly encourage readers to perform their own benchmarks that reflect their specific application profiles. To facilitate this, the benchmarking suite used in this study is [included with the KX Nano codebase](https://github.com/KxSystems/nano/tree/master/scripts/fsBenchmark), available on GitHub.

### Details

All benchmarks were executed in September 2025 using kdb+ 4.1 (2025.04.28) and [KX Nano 6.4.0](https://github.com/KxSystems/nano/releases/tag/v6.4.0). Each kdb+ process was configured to use 8 worker threads (`-s 8`).

We used the default vector length of KX Nano, which are:

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
#T_1353d th, #T_1353d td,
#T_7fa11 th, #T_7fa11 td,
#T_2328f th, #T_2328f td,
#T_346b4 th, #T_346b4 td,
#T_ced8e th, #T_ced8e td,
#T_34848 th, #T_34848 td,
#T_0ed45 th, #T_0ed45 td,
#T_bea0d th, #T_bea0d td,
#T_c3265 th, #T_c3265 td,
#T_23da1 th, #T_23da1 td,
#T_887db th, #T_887db td,
#T_ce354 th, #T_ce354 td,
#T_0b5e5 th, #T_0b5e5 td,
#T_44386 th, #T_44386 td,
#T_35aaf th, #T_35aaf td,
#T_f6d05 th, #T_f6d05 td,
#T_75728 th, #T_75728 td{
  padding: 2px 4px;
	font-size: 12px;
	min-width: 30px;
}

</style>

<style type="text/css">
#T_1353d th.col_heading.level0 {
  font-size: 1.5em;
}
#T_1353d_row0_col2 {
  background-color: #f2FFf2;
  color: black;
}
#T_1353d_row1_col2 {
  background-color: #f5FFf5;
  color: black;
}
#T_1353d_row2_col2 {
  background-color: #edFFed;
  color: black;
}
#T_1353d_row3_col2 {
  background-color: #f6FFf6;
  color: black;
}
#T_1353d_row4_col2 {
  background-color: #cfFFcf;
  color: black;
}
#T_1353d_row5_col2 {
  background-color: #d3FFd3;
  color: black;
}
#T_1353d_row6_col2, #T_1353d_row10_col2 {
  background-color: #c6FFc6;
  color: black;
}
#T_1353d_row7_col2 {
  background-color: #e7FFe7;
  color: black;
}
#T_1353d_row8_col2 {
  background-color: #f8FFf8;
  color: black;
}
#T_1353d_row9_col2 {
  background-color: #e5FFe5;
  color: black;
}
</style>
<table id="T_1353d">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_1353d_level0_col0" class="col_heading level0 col0" >XFS</th>
      <th id="T_1353d_level0_col1" class="col_heading level0 col1" >ext4</th>
      <th id="T_1353d_level0_col2" class="col_heading level0 col2" >ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_1353d_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_1353d_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_1353d_row0_col0" class="data row0 col0" >261</td>
      <td id="T_1353d_row0_col1" class="data row0 col1" >233</td>
      <td id="T_1353d_row0_col2" class="data row0 col2" >1.12</td>
    </tr>
    <tr>
      <th id="T_1353d_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_1353d_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_1353d_row1_col0" class="data row1 col0" >106</td>
      <td id="T_1353d_row1_col1" class="data row1 col1" >97</td>
      <td id="T_1353d_row1_col2" class="data row1 col2" >1.09</td>
    </tr>
    <tr>
      <th id="T_1353d_level0_row2" class="row_heading level0 row2" rowspan="7">write disk</th>
      <th id="T_1353d_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_1353d_row2_col0" class="data row2 col0" >1030</td>
      <td id="T_1353d_row2_col1" class="data row2 col1" >877</td>
      <td id="T_1353d_row2_col2" class="data row2 col2" >1.18</td>
    </tr>
    <tr>
      <th id="T_1353d_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_1353d_row3_col0" class="data row3 col0" >924</td>
      <td id="T_1353d_row3_col1" class="data row3 col1" >853</td>
      <td id="T_1353d_row3_col2" class="data row3 col2" >1.08</td>
    </tr>
    <tr>
      <th id="T_1353d_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_1353d_row4_col0" class="data row4 col0" >2098</td>
      <td id="T_1353d_row4_col1" class="data row4 col1" >1304</td>
      <td id="T_1353d_row4_col2" class="data row4 col2" >1.61</td>
    </tr>
    <tr>
      <th id="T_1353d_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_1353d_row5_col0" class="data row5 col0" >3367</td>
      <td id="T_1353d_row5_col1" class="data row5 col1" >2170</td>
      <td id="T_1353d_row5_col2" class="data row5 col2" >1.55</td>
    </tr>
    <tr>
      <th id="T_1353d_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_1353d_row6_col0" class="data row6 col0" >1309</td>
      <td id="T_1353d_row6_col1" class="data row6 col1" >729</td>
      <td id="T_1353d_row6_col2" class="data row6 col2" >1.80</td>
    </tr>
    <tr>
      <th id="T_1353d_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_1353d_row7_col0" class="data row7 col0" >474</td>
      <td id="T_1353d_row7_col1" class="data row7 col1" >380</td>
      <td id="T_1353d_row7_col2" class="data row7 col2" >1.25</td>
    </tr>
    <tr>
      <th id="T_1353d_level1_row8" class="row_heading level1 row8" >write sym large</th>
      <td id="T_1353d_row8_col0" class="data row8 col0" >913</td>
      <td id="T_1353d_row8_col1" class="data row8 col1" >862</td>
      <td id="T_1353d_row8_col2" class="data row8 col2" >1.06</td>
    </tr>
    <tr>
      <th id="T_1353d_level0_row9" class="row_heading level0 row9" >GEOMETRIC MEAN</th>
      <th id="T_1353d_level1_row9" class="row_heading level1 row9" ></th>
      <td id="T_1353d_row9_col0" class="data row9 col0" >779</td>
      <td id="T_1353d_row9_col1" class="data row9 col1" >608</td>
      <td id="T_1353d_row9_col2" class="data row9 col2" >1.28</td>
    </tr>
    <tr>
      <th id="T_1353d_level0_row10" class="row_heading level0 row10" >MAX RATIO</th>
      <th id="T_1353d_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_1353d_row10_col0" class="data row10 col0" >3367</td>
      <td id="T_1353d_row10_col1" class="data row10 col1" >2170</td>
      <td id="T_1353d_row10_col2" class="data row10 col2" >1.80</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS is almost always faster than ext4. **In critical tests, the advantage is almost 30%** on average with a **maximal difference 80%**.

The performance of the less critical write operations are below.




<style type="text/css">
#T_7fa11 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_7fa11_row0_col2, #T_7fa11_row13_col2 {
  background-color: #d2FFd2;
  color: black;
}
#T_7fa11_row1_col2 {
  background-color: #d5FFd5;
  color: black;
}
#T_7fa11_row2_col2 {
  background-color: #f0FFf0;
  color: black;
}
#T_7fa11_row3_col2 {
  background-color: #ebFFeb;
  color: black;
}
#T_7fa11_row4_col2 {
  background-color: #d9FFd9;
  color: black;
}
#T_7fa11_row5_col2 {
  background-color: #FFfbfb;
  color: black;
}
#T_7fa11_row6_col2, #T_7fa11_row7_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_7fa11_row8_col2 {
  background-color: #f6FFf6;
  color: black;
}
#T_7fa11_row9_col2 {
  background-color: #edFFed;
  color: black;
}
#T_7fa11_row10_col2 {
  background-color: #FF2121;
  color: white;
}
#T_7fa11_row11_col2 {
  background-color: #FFebeb;
  color: black;
}
#T_7fa11_row12_col2 {
  background-color: #FFc7c7;
  color: black;
}
</style>
<table id="T_7fa11">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_7fa11_level0_col0" class="col_heading level0 col0" >XFS</th>
      <th id="T_7fa11_level0_col1" class="col_heading level0 col1" >ext4</th>
      <th id="T_7fa11_level0_col2" class="col_heading level0 col2" >ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_7fa11_level0_row0" class="row_heading level0 row0" rowspan="12">write disk</th>
      <th id="T_7fa11_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_7fa11_row0_col0" class="data row0 col0" >750</td>
      <td id="T_7fa11_row0_col1" class="data row0 col1" >482</td>
      <td id="T_7fa11_row0_col2" class="data row0 col2" >1.55</td>
    </tr>
    <tr>
      <th id="T_7fa11_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_7fa11_row1_col0" class="data row1 col0" >554</td>
      <td id="T_7fa11_row1_col1" class="data row1 col1" >366</td>
      <td id="T_7fa11_row1_col2" class="data row1 col2" >1.51</td>
    </tr>
    <tr>
      <th id="T_7fa11_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_7fa11_row2_col0" class="data row2 col0" >931</td>
      <td id="T_7fa11_row2_col1" class="data row2 col1" >813</td>
      <td id="T_7fa11_row2_col2" class="data row2 col2" >1.14</td>
    </tr>
    <tr>
      <th id="T_7fa11_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_7fa11_row3_col0" class="data row3 col0" >253</td>
      <td id="T_7fa11_row3_col1" class="data row3 col1" >211</td>
      <td id="T_7fa11_row3_col2" class="data row3 col2" >1.20</td>
    </tr>
    <tr>
      <th id="T_7fa11_level1_row4" class="row_heading level1 row4" >open replace tiny, sync once</th>
      <td id="T_7fa11_row4_col0" class="data row4 col0" >139</td>
      <td id="T_7fa11_row4_col1" class="data row4 col1" >96</td>
      <td id="T_7fa11_row4_col2" class="data row4 col2" >1.45</td>
    </tr>
    <tr>
      <th id="T_7fa11_level1_row5" class="row_heading level1 row5" >sync float large</th>
      <td id="T_7fa11_row5_col0" class="data row5 col0" >143720</td>
      <td id="T_7fa11_row5_col1" class="data row5 col1" >145828</td>
      <td id="T_7fa11_row5_col2" class="data row5 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_7fa11_level1_row6" class="row_heading level1 row6" >sync int huge</th>
      <td id="T_7fa11_row6_col0" class="data row6 col0" >78917</td>
      <td id="T_7fa11_row6_col1" class="data row6 col1" >77110</td>
      <td id="T_7fa11_row6_col2" class="data row6 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_7fa11_level1_row7" class="row_heading level1 row7" >sync int medium</th>
      <td id="T_7fa11_row7_col0" class="data row7 col0" >40977</td>
      <td id="T_7fa11_row7_col1" class="data row7 col1" >40090</td>
      <td id="T_7fa11_row7_col2" class="data row7 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_7fa11_level1_row8" class="row_heading level1 row8" >sync int small</th>
      <td id="T_7fa11_row8_col0" class="data row8 col0" >6730</td>
      <td id="T_7fa11_row8_col1" class="data row8 col1" >6244</td>
      <td id="T_7fa11_row8_col2" class="data row8 col2" >1.08</td>
    </tr>
    <tr>
      <th id="T_7fa11_level1_row9" class="row_heading level1 row9" >sync sym large</th>
      <td id="T_7fa11_row9_col0" class="data row9 col0" >211642</td>
      <td id="T_7fa11_row9_col1" class="data row9 col1" >180587</td>
      <td id="T_7fa11_row9_col2" class="data row9 col2" >1.17</td>
    </tr>
    <tr>
      <th id="T_7fa11_level1_row10" class="row_heading level1 row10" >sync table after phash</th>
      <td id="T_7fa11_row10_col0" class="data row10 col0" >177163</td>
      <td id="T_7fa11_row10_col1" class="data row10 col1" >30758180</td>
      <td id="T_7fa11_row10_col2" class="data row10 col2" >0.01</td>
    </tr>
    <tr>
      <th id="T_7fa11_level1_row11" class="row_heading level1 row11" >sync table after sort</th>
      <td id="T_7fa11_row11_col0" class="data row11 col0" >54142270</td>
      <td id="T_7fa11_row11_col1" class="data row11 col1" >59348750</td>
      <td id="T_7fa11_row11_col2" class="data row11 col2" >0.91</td>
    </tr>
    <tr>
      <th id="T_7fa11_level0_row12" class="row_heading level0 row12" >GEOMETRIC MEAN</th>
      <th id="T_7fa11_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_7fa11_row12_col0" class="data row12 col0" >14500</td>
      <td id="T_7fa11_row12_col1" class="data row12 col1" >19311</td>
      <td id="T_7fa11_row12_col2" class="data row12 col2" >0.75</td>
    </tr>
    <tr>
      <th id="T_7fa11_level0_row13" class="row_heading level0 row13" >MAX RATIO</th>
      <th id="T_7fa11_level1_row13" class="row_heading level1 row13" ></th>
      <td id="T_7fa11_row13_col0" class="data row13 col0" >54142270</td>
      <td id="T_7fa11_row13_col1" class="data row13 col1" >59348750</td>
      <td id="T_7fa11_row13_col2" class="data row13 col2" >1.55</td>
    </tr>
  </tbody>
</table>




#### 64 kdb+ processes:




<style type="text/css">
#T_2328f th.col_heading.level0 {
  font-size: 1.5em;
}
#T_2328f_row0_col2, #T_2328f_row10_col2 {
  background-color: #76FF76;
  color: black;
}
#T_2328f_row1_col2 {
  background-color: #99FF99;
  color: black;
}
#T_2328f_row2_col2 {
  background-color: #dcFFdc;
  color: black;
}
#T_2328f_row3_col2 {
  background-color: #f2FFf2;
  color: black;
}
#T_2328f_row4_col2 {
  background-color: #7cFF7c;
  color: black;
}
#T_2328f_row5_col2 {
  background-color: #FFecec;
  color: black;
}
#T_2328f_row6_col2 {
  background-color: #79FF79;
  color: black;
}
#T_2328f_row7_col2 {
  background-color: #96FF96;
  color: black;
}
#T_2328f_row8_col2 {
  background-color: #8eFF8e;
  color: black;
}
#T_2328f_row9_col2 {
  background-color: #a1FFa1;
  color: black;
}
</style>
<table id="T_2328f">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_2328f_level0_col0" class="col_heading level0 col0" >XFS</th>
      <th id="T_2328f_level0_col1" class="col_heading level0 col1" >ext4</th>
      <th id="T_2328f_level0_col2" class="col_heading level0 col2" >ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_2328f_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_2328f_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_2328f_row0_col0" class="data row0 col0" >12834</td>
      <td id="T_2328f_row0_col1" class="data row0 col1" >1948</td>
      <td id="T_2328f_row0_col2" class="data row0 col2" >6.59</td>
    </tr>
    <tr>
      <th id="T_2328f_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_2328f_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_2328f_row1_col0" class="data row1 col0" >3059</td>
      <td id="T_2328f_row1_col1" class="data row1 col1" >914</td>
      <td id="T_2328f_row1_col2" class="data row1 col2" >3.35</td>
    </tr>
    <tr>
      <th id="T_2328f_level0_row2" class="row_heading level0 row2" rowspan="7">write disk</th>
      <th id="T_2328f_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_2328f_row2_col0" class="data row2 col0" >1933</td>
      <td id="T_2328f_row2_col1" class="data row2 col1" >1378</td>
      <td id="T_2328f_row2_col2" class="data row2 col2" >1.40</td>
    </tr>
    <tr>
      <th id="T_2328f_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_2328f_row3_col0" class="data row3 col0" >2309</td>
      <td id="T_2328f_row3_col1" class="data row3 col1" >2065</td>
      <td id="T_2328f_row3_col2" class="data row3 col2" >1.12</td>
    </tr>
    <tr>
      <th id="T_2328f_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_2328f_row4_col0" class="data row4 col0" >63140</td>
      <td id="T_2328f_row4_col1" class="data row4 col1" >10817</td>
      <td id="T_2328f_row4_col2" class="data row4 col2" >5.84</td>
    </tr>
    <tr>
      <th id="T_2328f_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_2328f_row5_col0" class="data row5 col0" >2449</td>
      <td id="T_2328f_row5_col1" class="data row5 col1" >2665</td>
      <td id="T_2328f_row5_col2" class="data row5 col2" >0.92</td>
    </tr>
    <tr>
      <th id="T_2328f_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_2328f_row6_col0" class="data row6 col0" >40098</td>
      <td id="T_2328f_row6_col1" class="data row6 col1" >6453</td>
      <td id="T_2328f_row6_col2" class="data row6 col2" >6.21</td>
    </tr>
    <tr>
      <th id="T_2328f_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_2328f_row7_col0" class="data row7 col0" >17609</td>
      <td id="T_2328f_row7_col1" class="data row7 col1" >4931</td>
      <td id="T_2328f_row7_col2" class="data row7 col2" >3.57</td>
    </tr>
    <tr>
      <th id="T_2328f_level1_row8" class="row_heading level1 row8" >write sym large</th>
      <td id="T_2328f_row8_col0" class="data row8 col0" >57674</td>
      <td id="T_2328f_row8_col1" class="data row8 col1" >14279</td>
      <td id="T_2328f_row8_col2" class="data row8 col2" >4.04</td>
    </tr>
    <tr>
      <th id="T_2328f_level0_row9" class="row_heading level0 row9" >GEOMETRIC MEAN</th>
      <th id="T_2328f_level1_row9" class="row_heading level1 row9" ></th>
      <td id="T_2328f_row9_col0" class="data row9 col0" >10110</td>
      <td id="T_2328f_row9_col1" class="data row9 col1" >3434</td>
      <td id="T_2328f_row9_col2" class="data row9 col2" >2.94</td>
    </tr>
    <tr>
      <th id="T_2328f_level0_row10" class="row_heading level0 row10" >MAX RATIO</th>
      <th id="T_2328f_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_2328f_row10_col0" class="data row10 col0" >63140</td>
      <td id="T_2328f_row10_col1" class="data row10 col1" >14279</td>
      <td id="T_2328f_row10_col2" class="data row10 col2" >6.59</td>
    </tr>
  </tbody>
</table>




**Observation**: The results show that **XFS consistently and significantly outperformed ext4 in write-intensive operations**. In critical ingestion and EOD tasks, write throughput on XFS was on average **3 times higher**. This advantage peaked in specific operations, such as applying the `p#` attribute, where XFS was a remarkable 6.6x faster than ext4.

The performance of the less critical write operations are below.




<style type="text/css">
#T_346b4 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_346b4_row0_col2 {
  background-color: #FFdcdc;
  color: black;
}
#T_346b4_row1_col2 {
  background-color: #eeFFee;
  color: black;
}
#T_346b4_row2_col2 {
  background-color: #FFf7f7;
  color: black;
}
#T_346b4_row3_col2, #T_346b4_row13_col2 {
  background-color: #c7FFc7;
  color: black;
}
#T_346b4_row4_col2 {
  background-color: #FF9292;
  color: black;
}
#T_346b4_row5_col2 {
  background-color: #FFfcfc;
  color: black;
}
#T_346b4_row6_col2 {
  background-color: #FFfefe;
  color: black;
}
#T_346b4_row7_col2 {
  background-color: #dcFFdc;
  color: black;
}
#T_346b4_row8_col2 {
  background-color: #f7FFf7;
  color: black;
}
#T_346b4_row9_col2 {
  background-color: #FFf9f9;
  color: black;
}
#T_346b4_row10_col2 {
  background-color: #FF2020;
  color: white;
}
#T_346b4_row11_col2 {
  background-color: #FF7474;
  color: white;
}
#T_346b4_row12_col2 {
  background-color: #FF9191;
  color: black;
}
</style>
<table id="T_346b4">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_346b4_level0_col0" class="col_heading level0 col0" >XFS</th>
      <th id="T_346b4_level0_col1" class="col_heading level0 col1" >ext4</th>
      <th id="T_346b4_level0_col2" class="col_heading level0 col2" >ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_346b4_level0_row0" class="row_heading level0 row0" rowspan="12">write disk</th>
      <th id="T_346b4_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_346b4_row0_col0" class="data row0 col0" >1657</td>
      <td id="T_346b4_row0_col1" class="data row0 col1" >1955</td>
      <td id="T_346b4_row0_col2" class="data row0 col2" >0.85</td>
    </tr>
    <tr>
      <th id="T_346b4_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_346b4_row1_col0" class="data row1 col0" >2429</td>
      <td id="T_346b4_row1_col1" class="data row1 col1" >2083</td>
      <td id="T_346b4_row1_col2" class="data row1 col2" >1.17</td>
    </tr>
    <tr>
      <th id="T_346b4_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_346b4_row2_col0" class="data row2 col0" >1384</td>
      <td id="T_346b4_row2_col1" class="data row2 col1" >1432</td>
      <td id="T_346b4_row2_col2" class="data row2 col2" >0.97</td>
    </tr>
    <tr>
      <th id="T_346b4_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_346b4_row3_col0" class="data row3 col0" >2407</td>
      <td id="T_346b4_row3_col1" class="data row3 col1" >1361</td>
      <td id="T_346b4_row3_col2" class="data row3 col2" >1.77</td>
    </tr>
    <tr>
      <th id="T_346b4_level1_row4" class="row_heading level1 row4" >open replace tiny, sync once</th>
      <td id="T_346b4_row4_col0" class="data row4 col0" >531</td>
      <td id="T_346b4_row4_col1" class="data row4 col1" >1035</td>
      <td id="T_346b4_row4_col2" class="data row4 col2" >0.51</td>
    </tr>
    <tr>
      <th id="T_346b4_level1_row5" class="row_heading level1 row5" >sync float large</th>
      <td id="T_346b4_row5_col0" class="data row5 col0" >91966</td>
      <td id="T_346b4_row5_col1" class="data row5 col1" >93039</td>
      <td id="T_346b4_row5_col2" class="data row5 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_346b4_level1_row6" class="row_heading level1 row6" >sync int huge</th>
      <td id="T_346b4_row6_col0" class="data row6 col0" >216302</td>
      <td id="T_346b4_row6_col1" class="data row6 col1" >217269</td>
      <td id="T_346b4_row6_col2" class="data row6 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_346b4_level1_row7" class="row_heading level1 row7" >sync int medium</th>
      <td id="T_346b4_row7_col0" class="data row7 col0" >177815</td>
      <td id="T_346b4_row7_col1" class="data row7 col1" >127043</td>
      <td id="T_346b4_row7_col2" class="data row7 col2" >1.40</td>
    </tr>
    <tr>
      <th id="T_346b4_level1_row8" class="row_heading level1 row8" >sync int small</th>
      <td id="T_346b4_row8_col0" class="data row8 col0" >112098</td>
      <td id="T_346b4_row8_col1" class="data row8 col1" >105078</td>
      <td id="T_346b4_row8_col2" class="data row8 col2" >1.07</td>
    </tr>
    <tr>
      <th id="T_346b4_level1_row9" class="row_heading level1 row9" >sync sym large</th>
      <td id="T_346b4_row9_col0" class="data row9 col0" >137169</td>
      <td id="T_346b4_row9_col1" class="data row9 col1" >140796</td>
      <td id="T_346b4_row9_col2" class="data row9 col2" >0.97</td>
    </tr>
    <tr>
      <th id="T_346b4_level1_row10" class="row_heading level1 row10" >sync table after phash</th>
      <td id="T_346b4_row10_col0" class="data row10 col0" >132748</td>
      <td id="T_346b4_row10_col1" class="data row10 col1" >197769600</td>
      <td id="T_346b4_row10_col2" class="data row10 col2" >0.00</td>
    </tr>
    <tr>
      <th id="T_346b4_level1_row11" class="row_heading level1 row11" >sync table after sort</th>
      <td id="T_346b4_row11_col0" class="data row11 col0" >161152200</td>
      <td id="T_346b4_row11_col1" class="data row11 col1" >423427500</td>
      <td id="T_346b4_row11_col2" class="data row11 col2" >0.38</td>
    </tr>
    <tr>
      <th id="T_346b4_level0_row12" class="row_heading level0 row12" >GEOMETRIC MEAN</th>
      <th id="T_346b4_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_346b4_row12_col0" class="data row12 col0" >37714</td>
      <td id="T_346b4_row12_col1" class="data row12 col1" >73810</td>
      <td id="T_346b4_row12_col2" class="data row12 col2" >0.51</td>
    </tr>
    <tr>
      <th id="T_346b4_level0_row13" class="row_heading level0 row13" >MAX RATIO</th>
      <th id="T_346b4_level1_row13" class="row_heading level1 row13" ></th>
      <td id="T_346b4_row13_col0" class="data row13 col0" >161152200</td>
      <td id="T_346b4_row13_col1" class="data row13 col1" >423427500</td>
      <td id="T_346b4_row13_col2" class="data row13 col2" >1.77</td>
    </tr>
  </tbody>
</table>




There were two minor test cases where ext4 was faster. The first, "`replace tiny`" `(.[ftinyReplace;();:;tinyVec]`), involves overwriting a very small vector. This discrepancy is considered negligible, as the operation is not representative of typical, performance-critical kdb+ workloads. The second, "`sync table after phash/sort`", also showed ext4 ahead. However, the absolute time difference was minimal, making its impact on overall application performance insignificant in most practical scenarios.

### Read

We divide read tests into two categories depending on the source of the data, disk vs page cache (memory).

#### Single kdb+ process:




<style type="text/css">
#T_ced8e th.col_heading.level0 {
  font-size: 1.5em;
}
#T_ced8e_row0_col2 {
  background-color: #FFfbfb;
  color: black;
}
#T_ced8e_row1_col2, #T_ced8e_row2_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_ced8e_row3_col2 {
  background-color: #f6FFf6;
  color: black;
}
#T_ced8e_row4_col2 {
  background-color: #f8FFf8;
  color: black;
}
#T_ced8e_row5_col2 {
  background-color: #f5FFf5;
  color: black;
}
#T_ced8e_row6_col2 {
  background-color: #FFfefe;
  color: black;
}
#T_ced8e_row7_col2, #T_ced8e_row12_col2 {
  background-color: #acFFac;
  color: black;
}
#T_ced8e_row8_col2 {
  background-color: #baFFba;
  color: black;
}
#T_ced8e_row9_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_ced8e_row10_col2 {
  background-color: #ebFFeb;
  color: black;
}
#T_ced8e_row11_col2 {
  background-color: #eaFFea;
  color: black;
}
</style>
<table id="T_ced8e">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_ced8e_level0_col0" class="col_heading level0 col0" >XFS</th>
      <th id="T_ced8e_level0_col1" class="col_heading level0 col1" >ext4</th>
      <th id="T_ced8e_level0_col2" class="col_heading level0 col2" >ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_ced8e_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_ced8e_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_ced8e_row0_col0" class="data row0 col0" >592</td>
      <td id="T_ced8e_row0_col1" class="data row0 col1" >600</td>
      <td id="T_ced8e_row0_col2" class="data row0 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_ced8e_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_ced8e_row1_col0" class="data row1 col0" >19</td>
      <td id="T_ced8e_row1_col1" class="data row1 col1" >19</td>
      <td id="T_ced8e_row1_col2" class="data row1 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_ced8e_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_ced8e_row2_col0" class="data row2 col0" >198</td>
      <td id="T_ced8e_row2_col1" class="data row2 col1" >196</td>
      <td id="T_ced8e_row2_col2" class="data row2 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_ced8e_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_ced8e_row3_col0" class="data row3 col0" >601</td>
      <td id="T_ced8e_row3_col1" class="data row3 col1" >557</td>
      <td id="T_ced8e_row3_col2" class="data row3 col2" >1.08</td>
    </tr>
    <tr>
      <th id="T_ced8e_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_ced8e_row4_col0" class="data row4 col0" >20</td>
      <td id="T_ced8e_row4_col1" class="data row4 col1" >19</td>
      <td id="T_ced8e_row4_col2" class="data row4 col2" >1.06</td>
    </tr>
    <tr>
      <th id="T_ced8e_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_ced8e_row5_col0" class="data row5 col0" >204</td>
      <td id="T_ced8e_row5_col1" class="data row5 col1" >188</td>
      <td id="T_ced8e_row5_col2" class="data row5 col2" >1.09</td>
    </tr>
    <tr>
      <th id="T_ced8e_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_ced8e_row6_col0" class="data row6 col0" >697</td>
      <td id="T_ced8e_row6_col1" class="data row6 col1" >698</td>
      <td id="T_ced8e_row6_col2" class="data row6 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_ced8e_level0_row7" class="row_heading level0 row7" rowspan="4">read disk write mem</th>
      <th id="T_ced8e_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_ced8e_row7_col0" class="data row7 col0" >2012</td>
      <td id="T_ced8e_row7_col1" class="data row7 col1" >799</td>
      <td id="T_ced8e_row7_col2" class="data row7 col2" >2.52</td>
    </tr>
    <tr>
      <th id="T_ced8e_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_ced8e_row8_col0" class="data row8 col0" >2004</td>
      <td id="T_ced8e_row8_col1" class="data row8 col1" >961</td>
      <td id="T_ced8e_row8_col2" class="data row8 col2" >2.09</td>
    </tr>
    <tr>
      <th id="T_ced8e_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_ced8e_row9_col0" class="data row9 col0" >658</td>
      <td id="T_ced8e_row9_col1" class="data row9 col1" >645</td>
      <td id="T_ced8e_row9_col2" class="data row9 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_ced8e_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_ced8e_row10_col0" class="data row10 col0" >295</td>
      <td id="T_ced8e_row10_col1" class="data row10 col1" >246</td>
      <td id="T_ced8e_row10_col2" class="data row10 col2" >1.20</td>
    </tr>
    <tr>
      <th id="T_ced8e_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_ced8e_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_ced8e_row11_col0" class="data row11 col0" >315</td>
      <td id="T_ced8e_row11_col1" class="data row11 col1" >261</td>
      <td id="T_ced8e_row11_col2" class="data row11 col2" >1.21</td>
    </tr>
    <tr>
      <th id="T_ced8e_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_ced8e_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_ced8e_row12_col0" class="data row12 col0" >2012</td>
      <td id="T_ced8e_row12_col1" class="data row12 col1" >961</td>
      <td id="T_ced8e_row12_col2" class="data row12 col2" >2.52</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS reads the data faster from disk sequentially than ext4. Apart from this, the differences are negligible.




<style type="text/css">
#T_34848 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_34848_row0_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_34848_row1_col2, #T_34848_row12_col2 {
  background-color: #f8FFf8;
  color: black;
}
#T_34848_row2_col2 {
  background-color: #FFf9f9;
  color: black;
}
#T_34848_row3_col2, #T_34848_row5_col2, #T_34848_row8_col2 {
  background-color: #FFfefe;
  color: black;
}
#T_34848_row4_col2 {
  background-color: #FFfdfd;
  color: black;
}
#T_34848_row6_col2 {
  background-color: #fdFFfd;
  color: black;
}
#T_34848_row7_col2 {
  background-color: #FFfcfc;
  color: black;
}
#T_34848_row9_col2 {
  background-color: #FFf4f4;
  color: black;
}
#T_34848_row10_col2 {
  background-color: #f9FFf9;
  color: black;
}
#T_34848_row11_col2 {
  background-color: #feFFfe;
  color: black;
}
</style>
<table id="T_34848">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_34848_level0_col0" class="col_heading level0 col0" >XFS</th>
      <th id="T_34848_level0_col1" class="col_heading level0 col1" >ext4</th>
      <th id="T_34848_level0_col2" class="col_heading level0 col2" >ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_34848_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_34848_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_34848_row0_col0" class="data row0 col0" >2519</td>
      <td id="T_34848_row0_col1" class="data row0 col1" >2465</td>
      <td id="T_34848_row0_col2" class="data row0 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_34848_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_34848_row1_col0" class="data row1 col0" >264</td>
      <td id="T_34848_row1_col1" class="data row1 col1" >249</td>
      <td id="T_34848_row1_col2" class="data row1 col2" >1.06</td>
    </tr>
    <tr>
      <th id="T_34848_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_34848_row2_col0" class="data row2 col0" >1713</td>
      <td id="T_34848_row2_col1" class="data row2 col1" >1755</td>
      <td id="T_34848_row2_col2" class="data row2 col2" >0.98</td>
    </tr>
    <tr>
      <th id="T_34848_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_34848_row3_col0" class="data row3 col0" >3021</td>
      <td id="T_34848_row3_col1" class="data row3 col1" >3024</td>
      <td id="T_34848_row3_col2" class="data row3 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_34848_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_34848_row4_col0" class="data row4 col0" >1245</td>
      <td id="T_34848_row4_col1" class="data row4 col1" >1255</td>
      <td id="T_34848_row4_col2" class="data row4 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_34848_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_34848_row5_col0" class="data row5 col0" >3003</td>
      <td id="T_34848_row5_col1" class="data row5 col1" >3011</td>
      <td id="T_34848_row5_col2" class="data row5 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_34848_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_34848_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_34848_row6_col0" class="data row6 col0" >2544</td>
      <td id="T_34848_row6_col1" class="data row6 col1" >2520</td>
      <td id="T_34848_row6_col2" class="data row6 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_34848_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_34848_row7_col0" class="data row7 col0" >14883</td>
      <td id="T_34848_row7_col1" class="data row7 col1" >15071</td>
      <td id="T_34848_row7_col2" class="data row7 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_34848_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_34848_row8_col0" class="data row8 col0" >33797</td>
      <td id="T_34848_row8_col1" class="data row8 col1" >33874</td>
      <td id="T_34848_row8_col2" class="data row8 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_34848_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_34848_row9_col0" class="data row9 col0" >7801</td>
      <td id="T_34848_row9_col1" class="data row9 col1" >8176</td>
      <td id="T_34848_row9_col2" class="data row9 col2" >0.95</td>
    </tr>
    <tr>
      <th id="T_34848_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_34848_row10_col0" class="data row10 col0" >2148</td>
      <td id="T_34848_row10_col1" class="data row10 col1" >2047</td>
      <td id="T_34848_row10_col2" class="data row10 col2" >1.05</td>
    </tr>
    <tr>
      <th id="T_34848_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_34848_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_34848_row11_col0" class="data row11 col0" >3123</td>
      <td id="T_34848_row11_col1" class="data row11 col1" >3112</td>
      <td id="T_34848_row11_col2" class="data row11 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_34848_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_34848_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_34848_row12_col0" class="data row12 col0" >33797</td>
      <td id="T_34848_row12_col1" class="data row12 col1" >33874</td>
      <td id="T_34848_row12_col2" class="data row12 col2" >1.06</td>
    </tr>
  </tbody>
</table>




**Observation**: There is no performance difference between XFS and ext4 with a single kdb+ reader if the data is coming from page cache.

#### 64 kdb+ processes:




<style type="text/css">
#T_bea0d th.col_heading.level0 {
  font-size: 1.5em;
}
#T_bea0d_row0_col2, #T_bea0d_row3_col2 {
  background-color: #FFfefe;
  color: black;
}
#T_bea0d_row1_col2 {
  background-color: #FFf3f3;
  color: black;
}
#T_bea0d_row2_col2, #T_bea0d_row4_col2, #T_bea0d_row5_col2 {
  background-color: #FFfdfd;
  color: black;
}
#T_bea0d_row6_col2, #T_bea0d_row12_col2 {
  background-color: #52FF52;
  color: black;
}
#T_bea0d_row7_col2 {
  background-color: #FFafaf;
  color: black;
}
#T_bea0d_row8_col2 {
  background-color: #FFf6f6;
  color: black;
}
#T_bea0d_row9_col2 {
  background-color: #FF7171;
  color: white;
}
#T_bea0d_row10_col2 {
  background-color: #FF4e4e;
  color: white;
}
#T_bea0d_row11_col2 {
  background-color: #FFfcfc;
  color: black;
}
</style>
<table id="T_bea0d">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_bea0d_level0_col0" class="col_heading level0 col0" >XFS</th>
      <th id="T_bea0d_level0_col1" class="col_heading level0 col1" >ext4</th>
      <th id="T_bea0d_level0_col2" class="col_heading level0 col2" >ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_bea0d_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_bea0d_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_bea0d_row0_col0" class="data row0 col0" >2812</td>
      <td id="T_bea0d_row0_col1" class="data row0 col1" >2819</td>
      <td id="T_bea0d_row0_col2" class="data row0 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_bea0d_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_bea0d_row1_col0" class="data row1 col0" >515</td>
      <td id="T_bea0d_row1_col1" class="data row1 col1" >544</td>
      <td id="T_bea0d_row1_col2" class="data row1 col2" >0.95</td>
    </tr>
    <tr>
      <th id="T_bea0d_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_bea0d_row2_col0" class="data row2 col0" >1068</td>
      <td id="T_bea0d_row2_col1" class="data row2 col1" >1075</td>
      <td id="T_bea0d_row2_col2" class="data row2 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_bea0d_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_bea0d_row3_col0" class="data row3 col0" >2779</td>
      <td id="T_bea0d_row3_col1" class="data row3 col1" >2784</td>
      <td id="T_bea0d_row3_col2" class="data row3 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_bea0d_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_bea0d_row4_col0" class="data row4 col0" >543</td>
      <td id="T_bea0d_row4_col1" class="data row4 col1" >546</td>
      <td id="T_bea0d_row4_col2" class="data row4 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_bea0d_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_bea0d_row5_col0" class="data row5 col0" >1065</td>
      <td id="T_bea0d_row5_col1" class="data row5 col1" >1070</td>
      <td id="T_bea0d_row5_col2" class="data row5 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_bea0d_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_bea0d_row6_col0" class="data row6 col0" >100438</td>
      <td id="T_bea0d_row6_col1" class="data row6 col1" >5067</td>
      <td id="T_bea0d_row6_col2" class="data row6 col2" >19.82</td>
    </tr>
    <tr>
      <th id="T_bea0d_level0_row7" class="row_heading level0 row7" rowspan="4">read disk write mem</th>
      <th id="T_bea0d_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_bea0d_row7_col0" class="data row7 col0" >2124</td>
      <td id="T_bea0d_row7_col1" class="data row7 col1" >3292</td>
      <td id="T_bea0d_row7_col2" class="data row7 col2" >0.65</td>
    </tr>
    <tr>
      <th id="T_bea0d_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_bea0d_row8_col0" class="data row8 col0" >3180</td>
      <td id="T_bea0d_row8_col1" class="data row8 col1" >3300</td>
      <td id="T_bea0d_row8_col2" class="data row8 col2" >0.96</td>
    </tr>
    <tr>
      <th id="T_bea0d_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_bea0d_row9_col0" class="data row9 col0" >2164</td>
      <td id="T_bea0d_row9_col1" class="data row9 col1" >5910</td>
      <td id="T_bea0d_row9_col2" class="data row9 col2" >0.37</td>
    </tr>
    <tr>
      <th id="T_bea0d_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_bea0d_row10_col0" class="data row10 col0" >1456</td>
      <td id="T_bea0d_row10_col1" class="data row10 col1" >6923</td>
      <td id="T_bea0d_row10_col2" class="data row10 col2" >0.21</td>
    </tr>
    <tr>
      <th id="T_bea0d_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_bea0d_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_bea0d_row11_col0" class="data row11 col0" >2181</td>
      <td id="T_bea0d_row11_col1" class="data row11 col1" >2207</td>
      <td id="T_bea0d_row11_col2" class="data row11 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_bea0d_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_bea0d_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_bea0d_row12_col0" class="data row12 col0" >100438</td>
      <td id="T_bea0d_row12_col1" class="data row12 col1" >6923</td>
      <td id="T_bea0d_row12_col2" class="data row12 col2" >19.82</td>
    </tr>
  </tbody>
</table>




**Observation**: Despite the edge of XFS with a single reader, ext4 outperforms XFS sequential read if multiple kdb+ processes are reading various data in parallel. This scenario is common in a pool of HDBs where multiple concurrent queries with non-selective filters result in numerous parallel sequential reads from disk.




<style type="text/css">
#T_f6d05 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_f6d05_row0_col2 {
  background-color: #FFaeae;
  color: black;
}
#T_f6d05_row1_col2 {
  background-color: #FFa9a9;
  color: black;
}
#T_f6d05_row2_col2 {
  background-color: #FFa1a1;
  color: black;
}
#T_f6d05_row3_col2 {
  background-color: #FFf8f8;
  color: black;
}
#T_f6d05_row4_col2, #T_f6d05_row10_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_f6d05_row5_col2 {
  background-color: #FFf6f6;
  color: black;
}
#T_f6d05_row6_col2, #T_f6d05_row12_col2 {
  background-color: #f3FFf3;
  color: black;
}
#T_f6d05_row7_col2 {
  background-color: #FFf4f4;
  color: black;
}
#T_f6d05_row8_col2 {
  background-color: #FFfefe;
  color: black;
}
#T_f6d05_row9_col2 {
  background-color: #FFf1f1;
  color: black;
}
#T_f6d05_row11_col2 {
  background-color: #FFe1e1;
  color: black;
}
</style>
<table id="T_f6d05">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_f6d05_level0_col0" class="col_heading level0 col0" >XFS</th>
      <th id="T_f6d05_level0_col1" class="col_heading level0 col1" >ext4</th>
      <th id="T_f6d05_level0_col2" class="col_heading level0 col2" >ratio</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_f6d05_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_f6d05_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_f6d05_row0_col0" class="data row0 col0" >26736</td>
      <td id="T_f6d05_row0_col1" class="data row0 col1" >41860</td>
      <td id="T_f6d05_row0_col2" class="data row0 col2" >0.64</td>
    </tr>
    <tr>
      <th id="T_f6d05_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_f6d05_row1_col0" class="data row1 col0" >3370</td>
      <td id="T_f6d05_row1_col1" class="data row1 col1" >5458</td>
      <td id="T_f6d05_row1_col2" class="data row1 col2" >0.62</td>
    </tr>
    <tr>
      <th id="T_f6d05_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_f6d05_row2_col0" class="data row2 col0" >13300</td>
      <td id="T_f6d05_row2_col1" class="data row2 col1" >22897</td>
      <td id="T_f6d05_row2_col2" class="data row2 col2" >0.58</td>
    </tr>
    <tr>
      <th id="T_f6d05_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_f6d05_row3_col0" class="data row3 col0" >124141</td>
      <td id="T_f6d05_row3_col1" class="data row3 col1" >127773</td>
      <td id="T_f6d05_row3_col2" class="data row3 col2" >0.97</td>
    </tr>
    <tr>
      <th id="T_f6d05_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_f6d05_row4_col0" class="data row4 col0" >92490</td>
      <td id="T_f6d05_row4_col1" class="data row4 col1" >92293</td>
      <td id="T_f6d05_row4_col2" class="data row4 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_f6d05_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_f6d05_row5_col0" class="data row5 col0" >156725</td>
      <td id="T_f6d05_row5_col1" class="data row5 col1" >162621</td>
      <td id="T_f6d05_row5_col2" class="data row5 col2" >0.96</td>
    </tr>
    <tr>
      <th id="T_f6d05_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_f6d05_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_f6d05_row6_col0" class="data row6 col0" >27670</td>
      <td id="T_f6d05_row6_col1" class="data row6 col1" >24988</td>
      <td id="T_f6d05_row6_col2" class="data row6 col2" >1.11</td>
    </tr>
    <tr>
      <th id="T_f6d05_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_f6d05_row7_col0" class="data row7 col0" >1022969</td>
      <td id="T_f6d05_row7_col1" class="data row7 col1" >1073493</td>
      <td id="T_f6d05_row7_col2" class="data row7 col2" >0.95</td>
    </tr>
    <tr>
      <th id="T_f6d05_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_f6d05_row8_col0" class="data row8 col0" >1358929</td>
      <td id="T_f6d05_row8_col1" class="data row8 col1" >1360467</td>
      <td id="T_f6d05_row8_col2" class="data row8 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_f6d05_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_f6d05_row9_col0" class="data row9 col0" >544712</td>
      <td id="T_f6d05_row9_col1" class="data row9 col1" >581002</td>
      <td id="T_f6d05_row9_col2" class="data row9 col2" >0.94</td>
    </tr>
    <tr>
      <th id="T_f6d05_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_f6d05_row10_col0" class="data row10 col0" >124434</td>
      <td id="T_f6d05_row10_col1" class="data row10 col1" >124221</td>
      <td id="T_f6d05_row10_col2" class="data row10 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_f6d05_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_f6d05_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_f6d05_row11_col0" class="data row11 col0" >94900</td>
      <td id="T_f6d05_row11_col1" class="data row11 col1" >109235</td>
      <td id="T_f6d05_row11_col2" class="data row11 col2" >0.87</td>
    </tr>
    <tr>
      <th id="T_f6d05_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_f6d05_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_f6d05_row12_col0" class="data row12 col0" >1358929</td>
      <td id="T_f6d05_row12_col1" class="data row12 col1" >1360467</td>
      <td id="T_f6d05_row12_col2" class="data row12 col2" >1.11</td>
    </tr>
  </tbody>
</table>




**Observation**: ext4 outperforms XFS in random reads if the data is coming from page cache.

## Test 2: Ubuntu with Samsung NVMe SSD (PCIe 5.0)

### Test setup

| Component	| Specification|
| --- | --- |
| Storage | * **Type**: 3.84 TB [SAMSUNG MZWLO3T8HCLS-00A07](https://semiconductor.samsung.com/ssd/enterprise-ssd/pm1743/mzwlo3t8hcls-00a07-00b07/) </br> * **Interface**: PCIe 5.0 x4 <br/> * **Sequential R/W**: 14000 MB/s / 6000 MB/s <br/> * **Random Read**: 2500K IOPS (4K) <br/> * **Latency**: Random Read: 215 µs (4K Blocks), Sequential Read /Write: 436 µs / 1350 µs (4K)
| CPU | [AMD EPYC 9575F (Turin)](https://www.amd.com/en/products/processors/server/epyc/9005-series/amd-epyc-9575f.html), 2 sockets, 64 cores per socket, 2 threads per core, 256 MB L3 cache, [SMT](https://en.wikipedia.org/wiki/Simultaneous_multithreading) off |
| Memory | 2.2 TB, DDR5@6400 MT/s (12 channels per socket) |
| OS| Ubuntu 24.04.3 LTS (kernel: 6.8.0-83-generic) |

The values presented in the result tables represent throughput ratios to XFS throughput (e.g., a value of 2 indicates XFS was twice as fast).

### Write

#### Single kdb+ process:




<style type="text/css">
#T_c3265 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_c3265_row0_col0 {
  background-color: #f1FFf1;
  color: black;
}
#T_c3265_row0_col1 {
  background-color: #f3FFf3;
  color: black;
}
#T_c3265_row0_col2, #T_c3265_row8_col0 {
  background-color: #feFFfe;
  color: black;
}
#T_c3265_row0_col3 {
  background-color: #FFfefe;
  color: black;
}
#T_c3265_row1_col0, #T_c3265_row1_col3 {
  background-color: #faFFfa;
  color: black;
}
#T_c3265_row1_col1 {
  background-color: #f9FFf9;
  color: black;
}
#T_c3265_row1_col2, #T_c3265_row3_col3 {
  background-color: #fcFFfc;
  color: black;
}
#T_c3265_row2_col0 {
  background-color: #c9FFc9;
  color: black;
}
#T_c3265_row2_col1 {
  background-color: #cdFFcd;
  color: black;
}
#T_c3265_row2_col2 {
  background-color: #bdFFbd;
  color: black;
}
#T_c3265_row2_col3 {
  background-color: #FFf9f9;
  color: black;
}
#T_c3265_row3_col0 {
  background-color: #eeFFee;
  color: black;
}
#T_c3265_row3_col1 {
  background-color: #f0FFf0;
  color: black;
}
#T_c3265_row3_col2 {
  background-color: #e7FFe7;
  color: black;
}
#T_c3265_row4_col0 {
  background-color: #a8FFa8;
  color: black;
}
#T_c3265_row4_col1 {
  background-color: #c6FFc6;
  color: black;
}
#T_c3265_row4_col2 {
  background-color: #abFFab;
  color: black;
}
#T_c3265_row4_col3 {
  background-color: #b2FFb2;
  color: black;
}
#T_c3265_row5_col0 {
  background-color: #a2FFa2;
  color: black;
}
#T_c3265_row5_col1 {
  background-color: #c2FFc2;
  color: black;
}
#T_c3265_row5_col2 {
  background-color: #a9FFa9;
  color: black;
}
#T_c3265_row5_col3 {
  background-color: #b6FFb6;
  color: black;
}
#T_c3265_row6_col0 {
  background-color: #aaFFaa;
  color: black;
}
#T_c3265_row6_col1 {
  background-color: #c7FFc7;
  color: black;
}
#T_c3265_row6_col2 {
  background-color: #c8FFc8;
  color: black;
}
#T_c3265_row6_col3 {
  background-color: #e1FFe1;
  color: black;
}
#T_c3265_row7_col0 {
  background-color: #FFa8a8;
  color: black;
}
#T_c3265_row7_col1 {
  background-color: #FFa3a3;
  color: black;
}
#T_c3265_row7_col2 {
  background-color: #FFa7a7;
  color: black;
}
#T_c3265_row7_col3 {
  background-color: #FFfafa;
  color: black;
}
#T_c3265_row8_col1 {
  background-color: #FFf0f0;
  color: black;
}
#T_c3265_row8_col2 {
  background-color: #FFf1f1;
  color: black;
}
#T_c3265_row8_col3 {
  background-color: #ccFFcc;
  color: black;
}
#T_c3265_row9_col0 {
  background-color: #d8FFd8;
  color: black;
  background: lightblue;
}
#T_c3265_row9_col1 {
  background-color: #e7FFe7;
  color: black;
  background: lightblue;
}
#T_c3265_row9_col2 {
  background-color: #deFFde;
  color: black;
  background: lightblue;
}
#T_c3265_row9_col3 {
  background-color: #e2FFe2;
  color: black;
  background: lightblue;
}
#T_c3265_row10_col0 {
  background-color: #a2FFa2;
  color: black;
  background: lightblue;
}
#T_c3265_row10_col1 {
  background-color: #c2FFc2;
  color: black;
  background: lightblue;
}
#T_c3265_row10_col2 {
  background-color: #a9FFa9;
  color: black;
  background: lightblue;
}
#T_c3265_row10_col3 {
  background-color: #b2FFb2;
  color: black;
  background: lightblue;
}
</style>
<table id="T_c3265">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_c3265_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_c3265_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_c3265_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_c3265_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_c3265_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_c3265_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_c3265_row0_col0" class="data row0 col0" >1.1</td>
      <td id="T_c3265_row0_col1" class="data row0 col1" >1.1</td>
      <td id="T_c3265_row0_col2" class="data row0 col2" >1.0</td>
      <td id="T_c3265_row0_col3" class="data row0 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_c3265_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_c3265_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_c3265_row1_col0" class="data row1 col0" >1.0</td>
      <td id="T_c3265_row1_col1" class="data row1 col1" >1.1</td>
      <td id="T_c3265_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_c3265_row1_col3" class="data row1 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_c3265_level0_row2" class="row_heading level0 row2" rowspan="7">write disk</th>
      <th id="T_c3265_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_c3265_row2_col0" class="data row2 col0" >1.7</td>
      <td id="T_c3265_row2_col1" class="data row2 col1" >1.7</td>
      <td id="T_c3265_row2_col2" class="data row2 col2" >2.0</td>
      <td id="T_c3265_row2_col3" class="data row2 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_c3265_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_c3265_row3_col0" class="data row3 col0" >1.2</td>
      <td id="T_c3265_row3_col1" class="data row3 col1" >1.1</td>
      <td id="T_c3265_row3_col2" class="data row3 col2" >1.2</td>
      <td id="T_c3265_row3_col3" class="data row3 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_c3265_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_c3265_row4_col0" class="data row4 col0" >2.7</td>
      <td id="T_c3265_row4_col1" class="data row4 col1" >1.8</td>
      <td id="T_c3265_row4_col2" class="data row4 col2" >2.5</td>
      <td id="T_c3265_row4_col3" class="data row4 col3" >2.3</td>
    </tr>
    <tr>
      <th id="T_c3265_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_c3265_row5_col0" class="data row5 col0" >2.9</td>
      <td id="T_c3265_row5_col1" class="data row5 col1" >1.9</td>
      <td id="T_c3265_row5_col2" class="data row5 col2" >2.6</td>
      <td id="T_c3265_row5_col3" class="data row5 col3" >2.2</td>
    </tr>
    <tr>
      <th id="T_c3265_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_c3265_row6_col0" class="data row6 col0" >2.6</td>
      <td id="T_c3265_row6_col1" class="data row6 col1" >1.8</td>
      <td id="T_c3265_row6_col2" class="data row6 col2" >1.8</td>
      <td id="T_c3265_row6_col3" class="data row6 col3" >1.3</td>
    </tr>
    <tr>
      <th id="T_c3265_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_c3265_row7_col0" class="data row7 col0" >0.6</td>
      <td id="T_c3265_row7_col1" class="data row7 col1" >0.6</td>
      <td id="T_c3265_row7_col2" class="data row7 col2" >0.6</td>
      <td id="T_c3265_row7_col3" class="data row7 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_c3265_level1_row8" class="row_heading level1 row8" >write sym large</th>
      <td id="T_c3265_row8_col0" class="data row8 col0" >1.0</td>
      <td id="T_c3265_row8_col1" class="data row8 col1" >0.9</td>
      <td id="T_c3265_row8_col2" class="data row8 col2" >0.9</td>
      <td id="T_c3265_row8_col3" class="data row8 col3" >1.7</td>
    </tr>
    <tr>
      <th id="T_c3265_level0_row9" class="row_heading level0 row9" >GEOMETRIC MEAN</th>
      <th id="T_c3265_level1_row9" class="row_heading level1 row9" ></th>
      <td id="T_c3265_row9_col0" class="data row9 col0" >1.5</td>
      <td id="T_c3265_row9_col1" class="data row9 col1" >1.2</td>
      <td id="T_c3265_row9_col2" class="data row9 col2" >1.4</td>
      <td id="T_c3265_row9_col3" class="data row9 col3" >1.3</td>
    </tr>
    <tr>
      <th id="T_c3265_level0_row10" class="row_heading level0 row10" >MAX RATIO</th>
      <th id="T_c3265_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_c3265_row10_col0" class="data row10 col0" >2.9</td>
      <td id="T_c3265_row10_col1" class="data row10 col1" >1.9</td>
      <td id="T_c3265_row10_col2" class="data row10 col2" >2.6</td>
      <td id="T_c3265_row10_col3" class="data row10 col3" >2.3</td>
    </tr>
  </tbody>
</table>




**Observation**: xfs outperforms all other file systems if a single kdb+ process writes the data. The only notable weakness for XFS was in writing small files.

The performance of the less critical write operations are below.




<style type="text/css">
#T_23da1 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_23da1_row0_col0 {
  background-color: #b6FFb6;
  color: black;
}
#T_23da1_row0_col1 {
  background-color: #bfFFbf;
  color: black;
}
#T_23da1_row0_col2 {
  background-color: #deFFde;
  color: black;
}
#T_23da1_row0_col3 {
  background-color: #b5FFb5;
  color: black;
}
#T_23da1_row1_col0, #T_23da1_row7_col1 {
  background-color: #dfFFdf;
  color: black;
}
#T_23da1_row1_col1, #T_23da1_row6_col1 {
  background-color: #eeFFee;
  color: black;
}
#T_23da1_row1_col2, #T_23da1_row10_col1 {
  background-color: #feFFfe;
  color: black;
}
#T_23da1_row1_col3, #T_23da1_row6_col2 {
  background-color: #caFFca;
  color: black;
}
#T_23da1_row2_col0 {
  background-color: #d6FFd6;
  color: black;
}
#T_23da1_row2_col1 {
  background-color: #ccFFcc;
  color: black;
}
#T_23da1_row2_col2 {
  background-color: #bdFFbd;
  color: black;
}
#T_23da1_row2_col3 {
  background-color: #FF9090;
  color: black;
}
#T_23da1_row3_col0 {
  background-color: #FFe3e3;
  color: black;
}
#T_23da1_row3_col1 {
  background-color: #FFb7b7;
  color: black;
}
#T_23da1_row3_col2 {
  background-color: #FFdbdb;
  color: black;
}
#T_23da1_row3_col3, #T_23da1_row5_col3 {
  background-color: #ceFFce;
  color: black;
}
#T_23da1_row4_col0 {
  background-color: #b9FFb9;
  color: black;
}
#T_23da1_row4_col1 {
  background-color: #b8FFb8;
  color: black;
}
#T_23da1_row4_col2 {
  background-color: #e8FFe8;
  color: black;
}
#T_23da1_row4_col3 {
  background-color: #a5FFa5;
  color: black;
}
#T_23da1_row5_col0 {
  background-color: #ecFFec;
  color: black;
}
#T_23da1_row5_col1 {
  background-color: #ddFFdd;
  color: black;
}
#T_23da1_row5_col2 {
  background-color: #edFFed;
  color: black;
}
#T_23da1_row6_col0 {
  background-color: #f9FFf9;
  color: black;
}
#T_23da1_row6_col3 {
  background-color: #FF6868;
  color: white;
}
#T_23da1_row7_col0 {
  background-color: #d8FFd8;
  color: black;
}
#T_23da1_row7_col2 {
  background-color: #e3FFe3;
  color: black;
}
#T_23da1_row7_col3 {
  background-color: #bcFFbc;
  color: black;
}
#T_23da1_row8_col0 {
  background-color: #FFd6d6;
  color: black;
}
#T_23da1_row8_col1 {
  background-color: #c5FFc5;
  color: black;
}
#T_23da1_row8_col2 {
  background-color: #FFdede;
  color: black;
}
#T_23da1_row8_col3 {
  background-color: #FFe0e0;
  color: black;
}
#T_23da1_row9_col0 {
  background-color: #e5FFe5;
  color: black;
}
#T_23da1_row9_col1 {
  background-color: #d3FFd3;
  color: black;
}
#T_23da1_row9_col2 {
  background-color: #e2FFe2;
  color: black;
}
#T_23da1_row9_col3 {
  background-color: #89FF89;
  color: black;
}
#T_23da1_row10_col0 {
  background-color: #FFf6f6;
  color: black;
}
#T_23da1_row10_col2 {
  background-color: #9eFF9e;
  color: black;
}
#T_23da1_row10_col3 {
  background-color: #7aFF7a;
  color: black;
}
#T_23da1_row11_col0 {
  background-color: #e5FFe5;
  color: black;
  background: lightblue;
}
#T_23da1_row11_col1 {
  background-color: #ddFFdd;
  color: black;
  background: lightblue;
}
#T_23da1_row11_col2 {
  background-color: #e0FFe0;
  color: black;
  background: lightblue;
}
#T_23da1_row11_col3 {
  background-color: #ceFFce;
  color: black;
  background: lightblue;
}
#T_23da1_row12_col0 {
  background-color: #b6FFb6;
  color: black;
  background: lightblue;
}
#T_23da1_row12_col1 {
  background-color: #b8FFb8;
  color: black;
  background: lightblue;
}
#T_23da1_row12_col2 {
  background-color: #9eFF9e;
  color: black;
  background: lightblue;
}
#T_23da1_row12_col3 {
  background-color: #7aFF7a;
  color: black;
  background: lightblue;
}
</style>
<table id="T_23da1">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_23da1_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_23da1_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_23da1_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_23da1_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_23da1_level0_row0" class="row_heading level0 row0" rowspan="11">write disk</th>
      <th id="T_23da1_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_23da1_row0_col0" class="data row0 col0" >2.2</td>
      <td id="T_23da1_row0_col1" class="data row0 col1" >2.0</td>
      <td id="T_23da1_row0_col2" class="data row0 col2" >1.4</td>
      <td id="T_23da1_row0_col3" class="data row0 col3" >2.2</td>
    </tr>
    <tr>
      <th id="T_23da1_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_23da1_row1_col0" class="data row1 col0" >1.4</td>
      <td id="T_23da1_row1_col1" class="data row1 col1" >1.2</td>
      <td id="T_23da1_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_23da1_row1_col3" class="data row1 col3" >1.7</td>
    </tr>
    <tr>
      <th id="T_23da1_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_23da1_row2_col0" class="data row2 col0" >1.5</td>
      <td id="T_23da1_row2_col1" class="data row2 col1" >1.7</td>
      <td id="T_23da1_row2_col2" class="data row2 col2" >2.0</td>
      <td id="T_23da1_row2_col3" class="data row2 col3" >0.5</td>
    </tr>
    <tr>
      <th id="T_23da1_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_23da1_row3_col0" class="data row3 col0" >0.9</td>
      <td id="T_23da1_row3_col1" class="data row3 col1" >0.7</td>
      <td id="T_23da1_row3_col2" class="data row3 col2" >0.8</td>
      <td id="T_23da1_row3_col3" class="data row3 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_23da1_level1_row4" class="row_heading level1 row4" >open replace tiny, sync once</th>
      <td id="T_23da1_row4_col0" class="data row4 col0" >2.1</td>
      <td id="T_23da1_row4_col1" class="data row4 col1" >2.1</td>
      <td id="T_23da1_row4_col2" class="data row4 col2" >1.2</td>
      <td id="T_23da1_row4_col3" class="data row4 col3" >2.8</td>
    </tr>
    <tr>
      <th id="T_23da1_level1_row5" class="row_heading level1 row5" >sync float large</th>
      <td id="T_23da1_row5_col0" class="data row5 col0" >1.2</td>
      <td id="T_23da1_row5_col1" class="data row5 col1" >1.4</td>
      <td id="T_23da1_row5_col2" class="data row5 col2" >1.2</td>
      <td id="T_23da1_row5_col3" class="data row5 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_23da1_level1_row6" class="row_heading level1 row6" >sync int huge</th>
      <td id="T_23da1_row6_col0" class="data row6 col0" >1.1</td>
      <td id="T_23da1_row6_col1" class="data row6 col1" >1.2</td>
      <td id="T_23da1_row6_col2" class="data row6 col2" >1.7</td>
      <td id="T_23da1_row6_col3" class="data row6 col3" >0.3</td>
    </tr>
    <tr>
      <th id="T_23da1_level1_row7" class="row_heading level1 row7" >sync int medium</th>
      <td id="T_23da1_row7_col0" class="data row7 col0" >1.5</td>
      <td id="T_23da1_row7_col1" class="data row7 col1" >1.4</td>
      <td id="T_23da1_row7_col2" class="data row7 col2" >1.3</td>
      <td id="T_23da1_row7_col3" class="data row7 col3" >2.0</td>
    </tr>
    <tr>
      <th id="T_23da1_level1_row8" class="row_heading level1 row8" >sync int small</th>
      <td id="T_23da1_row8_col0" class="data row8 col0" >0.8</td>
      <td id="T_23da1_row8_col1" class="data row8 col1" >1.8</td>
      <td id="T_23da1_row8_col2" class="data row8 col2" >0.9</td>
      <td id="T_23da1_row8_col3" class="data row8 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_23da1_level1_row9" class="row_heading level1 row9" >sync sym large</th>
      <td id="T_23da1_row9_col0" class="data row9 col0" >1.3</td>
      <td id="T_23da1_row9_col1" class="data row9 col1" >1.5</td>
      <td id="T_23da1_row9_col2" class="data row9 col2" >1.3</td>
      <td id="T_23da1_row9_col3" class="data row9 col3" >4.5</td>
    </tr>
    <tr>
      <th id="T_23da1_level1_row10" class="row_heading level1 row10" >sync table after sort</th>
      <td id="T_23da1_row10_col0" class="data row10 col0" >1.0</td>
      <td id="T_23da1_row10_col1" class="data row10 col1" >1.0</td>
      <td id="T_23da1_row10_col2" class="data row10 col2" >3.1</td>
      <td id="T_23da1_row10_col3" class="data row10 col3" >6.1</td>
    </tr>
    <tr>
      <th id="T_23da1_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_23da1_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_23da1_row11_col0" class="data row11 col0" >1.3</td>
      <td id="T_23da1_row11_col1" class="data row11 col1" >1.4</td>
      <td id="T_23da1_row11_col2" class="data row11 col2" >1.3</td>
      <td id="T_23da1_row11_col3" class="data row11 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_23da1_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_23da1_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_23da1_row12_col0" class="data row12 col0" >2.2</td>
      <td id="T_23da1_row12_col1" class="data row12 col1" >2.1</td>
      <td id="T_23da1_row12_col2" class="data row12 col2" >3.1</td>
      <td id="T_23da1_row12_col3" class="data row12 col3" >6.1</td>
    </tr>
  </tbody>
</table>




#### 64 kdb+ processes:




<style type="text/css">
#T_887db th.col_heading.level0 {
  font-size: 1.5em;
}
#T_887db_row0_col0, #T_887db_row0_col1, #T_887db_row0_col2, #T_887db_row4_col1 {
  background-color: #a2FFa2;
  color: black;
}
#T_887db_row0_col3 {
  background-color: #c5FFc5;
  color: black;
}
#T_887db_row1_col0, #T_887db_row7_col3 {
  background-color: #b8FFb8;
  color: black;
}
#T_887db_row1_col1 {
  background-color: #b6FFb6;
  color: black;
}
#T_887db_row1_col2 {
  background-color: #bdFFbd;
  color: black;
}
#T_887db_row1_col3, #T_887db_row3_col3 {
  background-color: #ccFFcc;
  color: black;
}
#T_887db_row2_col0, #T_887db_row3_col1 {
  background-color: #f9FFf9;
  color: black;
}
#T_887db_row2_col1 {
  background-color: #f6FFf6;
  color: black;
}
#T_887db_row2_col2 {
  background-color: #a7FFa7;
  color: black;
}
#T_887db_row2_col3 {
  background-color: #faFFfa;
  color: black;
}
#T_887db_row3_col0, #T_887db_row8_col1 {
  background-color: #f0FFf0;
  color: black;
}
#T_887db_row3_col2 {
  background-color: #b9FFb9;
  color: black;
}
#T_887db_row4_col0 {
  background-color: #a1FFa1;
  color: black;
}
#T_887db_row4_col2 {
  background-color: #43FF43;
  color: black;
}
#T_887db_row4_col3 {
  background-color: #4bFF4b;
  color: black;
}
#T_887db_row5_col0 {
  background-color: #fdFFfd;
  color: black;
}
#T_887db_row5_col1 {
  background-color: #bfFFbf;
  color: black;
}
#T_887db_row5_col2 {
  background-color: #8dFF8d;
  color: black;
}
#T_887db_row5_col3 {
  background-color: #d4FFd4;
  color: black;
}
#T_887db_row6_col0 {
  background-color: #9dFF9d;
  color: black;
}
#T_887db_row6_col1 {
  background-color: #a3FFa3;
  color: black;
}
#T_887db_row6_col2 {
  background-color: #40FF40;
  color: black;
}
#T_887db_row6_col3 {
  background-color: #92FF92;
  color: black;
}
#T_887db_row7_col0 {
  background-color: #ddFFdd;
  color: black;
}
#T_887db_row7_col1 {
  background-color: #81FF81;
  color: black;
}
#T_887db_row7_col2 {
  background-color: #57FF57;
  color: black;
}
#T_887db_row8_col0 {
  background-color: #ecFFec;
  color: black;
}
#T_887db_row8_col2 {
  background-color: #67FF67;
  color: black;
}
#T_887db_row8_col3 {
  background-color: #68FF68;
  color: black;
}
#T_887db_row9_col0 {
  background-color: #cbFFcb;
  color: black;
  background: lightblue;
}
#T_887db_row9_col1 {
  background-color: #baFFba;
  color: black;
  background: lightblue;
}
#T_887db_row9_col2 {
  background-color: #74FF74;
  color: black;
  background: lightblue;
}
#T_887db_row9_col3 {
  background-color: #a2FFa2;
  color: black;
  background: lightblue;
}
#T_887db_row10_col0 {
  background-color: #9dFF9d;
  color: black;
  background: lightblue;
}
#T_887db_row10_col1 {
  background-color: #81FF81;
  color: black;
  background: lightblue;
}
#T_887db_row10_col2 {
  background-color: #40FF40;
  color: black;
  background: lightblue;
}
#T_887db_row10_col3 {
  background-color: #4bFF4b;
  color: black;
  background: lightblue;
}
</style>
<table id="T_887db">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_887db_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_887db_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_887db_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_887db_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_887db_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_887db_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_887db_row0_col0" class="data row0 col0" >2.9</td>
      <td id="T_887db_row0_col1" class="data row0 col1" >2.9</td>
      <td id="T_887db_row0_col2" class="data row0 col2" >2.9</td>
      <td id="T_887db_row0_col3" class="data row0 col3" >1.8</td>
    </tr>
    <tr>
      <th id="T_887db_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_887db_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_887db_row1_col0" class="data row1 col0" >2.1</td>
      <td id="T_887db_row1_col1" class="data row1 col1" >2.2</td>
      <td id="T_887db_row1_col2" class="data row1 col2" >2.0</td>
      <td id="T_887db_row1_col3" class="data row1 col3" >1.7</td>
    </tr>
    <tr>
      <th id="T_887db_level0_row2" class="row_heading level0 row2" rowspan="7">write disk</th>
      <th id="T_887db_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_887db_row2_col0" class="data row2 col0" >1.1</td>
      <td id="T_887db_row2_col1" class="data row2 col1" >1.1</td>
      <td id="T_887db_row2_col2" class="data row2 col2" >2.7</td>
      <td id="T_887db_row2_col3" class="data row2 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_887db_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_887db_row3_col0" class="data row3 col0" >1.1</td>
      <td id="T_887db_row3_col1" class="data row3 col1" >1.1</td>
      <td id="T_887db_row3_col2" class="data row3 col2" >2.1</td>
      <td id="T_887db_row3_col3" class="data row3 col3" >1.7</td>
    </tr>
    <tr>
      <th id="T_887db_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_887db_row4_col0" class="data row4 col0" >3.0</td>
      <td id="T_887db_row4_col1" class="data row4 col1" >2.9</td>
      <td id="T_887db_row4_col2" class="data row4 col2" >40.3</td>
      <td id="T_887db_row4_col3" class="data row4 col3" >26.8</td>
    </tr>
    <tr>
      <th id="T_887db_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_887db_row5_col0" class="data row5 col0" >1.0</td>
      <td id="T_887db_row5_col1" class="data row5 col1" >2.0</td>
      <td id="T_887db_row5_col2" class="data row5 col2" >4.1</td>
      <td id="T_887db_row5_col3" class="data row5 col3" >1.5</td>
    </tr>
    <tr>
      <th id="T_887db_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_887db_row6_col0" class="data row6 col0" >3.2</td>
      <td id="T_887db_row6_col1" class="data row6 col1" >2.9</td>
      <td id="T_887db_row6_col2" class="data row6 col2" >47.1</td>
      <td id="T_887db_row6_col3" class="data row6 col3" >3.8</td>
    </tr>
    <tr>
      <th id="T_887db_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_887db_row7_col0" class="data row7 col0" >1.4</td>
      <td id="T_887db_row7_col1" class="data row7 col1" >5.3</td>
      <td id="T_887db_row7_col2" class="data row7 col2" >16.4</td>
      <td id="T_887db_row7_col3" class="data row7 col3" >2.1</td>
    </tr>
    <tr>
      <th id="T_887db_level1_row8" class="row_heading level1 row8" >write sym large</th>
      <td id="T_887db_row8_col0" class="data row8 col0" >1.2</td>
      <td id="T_887db_row8_col1" class="data row8 col1" >1.1</td>
      <td id="T_887db_row8_col2" class="data row8 col2" >9.7</td>
      <td id="T_887db_row8_col3" class="data row8 col3" >9.5</td>
    </tr>
    <tr>
      <th id="T_887db_level0_row9" class="row_heading level0 row9" >GEOMETRIC MEAN</th>
      <th id="T_887db_level1_row9" class="row_heading level1 row9" ></th>
      <td id="T_887db_row9_col0" class="data row9 col0" >1.7</td>
      <td id="T_887db_row9_col1" class="data row9 col1" >2.1</td>
      <td id="T_887db_row9_col2" class="data row9 col2" >7.0</td>
      <td id="T_887db_row9_col3" class="data row9 col3" >2.9</td>
    </tr>
    <tr>
      <th id="T_887db_level0_row10" class="row_heading level0 row10" >MAX RATIO</th>
      <th id="T_887db_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_887db_row10_col0" class="data row10 col0" >3.2</td>
      <td id="T_887db_row10_col1" class="data row10 col1" >5.3</td>
      <td id="T_887db_row10_col2" class="data row10 col2" >47.1</td>
      <td id="T_887db_row10_col3" class="data row10 col3" >26.8</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS significantly outperforms all other file systems. Its margin can be significant, for example persisting a large float vector (the `set` operation) is **over 27 times faster on XFS than on ZFS**.




<style type="text/css">
#T_ce354 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_ce354_row0_col0 {
  background-color: #dcFFdc;
  color: black;
}
#T_ce354_row0_col1 {
  background-color: #d4FFd4;
  color: black;
}
#T_ce354_row0_col2 {
  background-color: #92FF92;
  color: black;
}
#T_ce354_row0_col3 {
  background-color: #aeFFae;
  color: black;
}
#T_ce354_row1_col0 {
  background-color: #FFd4d4;
  color: black;
}
#T_ce354_row1_col1 {
  background-color: #e2FFe2;
  color: black;
}
#T_ce354_row1_col2 {
  background-color: #72FF72;
  color: black;
}
#T_ce354_row1_col3 {
  background-color: #efFFef;
  color: black;
}
#T_ce354_row2_col0, #T_ce354_row2_col1, #T_ce354_row6_col0 {
  background-color: #feFFfe;
  color: black;
}
#T_ce354_row2_col2 {
  background-color: #98FF98;
  color: black;
}
#T_ce354_row2_col3 {
  background-color: #FFc8c8;
  color: black;
}
#T_ce354_row3_col0 {
  background-color: #FFdbdb;
  color: black;
}
#T_ce354_row3_col1 {
  background-color: #d8FFd8;
  color: black;
}
#T_ce354_row3_col2 {
  background-color: #61FF61;
  color: black;
}
#T_ce354_row3_col3, #T_ce354_row8_col1 {
  background-color: #ecFFec;
  color: black;
}
#T_ce354_row4_col0 {
  background-color: #9cFF9c;
  color: black;
}
#T_ce354_row4_col1 {
  background-color: #4dFF4d;
  color: black;
}
#T_ce354_row4_col2 {
  background-color: #85FF85;
  color: black;
}
#T_ce354_row4_col3 {
  background-color: #79FF79;
  color: black;
}
#T_ce354_row5_col0, #T_ce354_row9_col0 {
  background-color: #fdFFfd;
  color: black;
}
#T_ce354_row5_col1 {
  background-color: #FFf8f8;
  color: black;
}
#T_ce354_row5_col2 {
  background-color: #FF9b9b;
  color: black;
}
#T_ce354_row5_col3 {
  background-color: #FF8e8e;
  color: white;
}
#T_ce354_row6_col1 {
  background-color: #e6FFe6;
  color: black;
}
#T_ce354_row6_col2 {
  background-color: #FF9191;
  color: black;
}
#T_ce354_row6_col3 {
  background-color: #FF2424;
  color: white;
}
#T_ce354_row7_col0 {
  background-color: #fcFFfc;
  color: black;
}
#T_ce354_row7_col1 {
  background-color: #FFc2c2;
  color: black;
}
#T_ce354_row7_col2, #T_ce354_row8_col2 {
  background-color: #a0FFa0;
  color: black;
}
#T_ce354_row7_col3 {
  background-color: #e4FFe4;
  color: black;
}
#T_ce354_row8_col0 {
  background-color: #FFd9d9;
  color: black;
}
#T_ce354_row8_col3 {
  background-color: #f7FFf7;
  color: black;
}
#T_ce354_row9_col1 {
  background-color: #FFe5e5;
  color: black;
}
#T_ce354_row9_col2 {
  background-color: #FFa6a6;
  color: black;
}
#T_ce354_row9_col3 {
  background-color: #e8FFe8;
  color: black;
}
#T_ce354_row10_col0 {
  background-color: #FFa0a0;
  color: black;
}
#T_ce354_row10_col1 {
  background-color: #41FF41;
  color: black;
}
#T_ce354_row10_col2, #T_ce354_row10_col3 {
  background-color: #62FF62;
  color: black;
}
#T_ce354_row11_col0 {
  background-color: #faFFfa;
  color: black;
  background: lightblue;
}
#T_ce354_row11_col1 {
  background-color: #bbFFbb;
  color: black;
  background: lightblue;
}
#T_ce354_row11_col2 {
  background-color: #a4FFa4;
  color: black;
  background: lightblue;
}
#T_ce354_row11_col3 {
  background-color: #f3FFf3;
  color: black;
  background: lightblue;
}
#T_ce354_row12_col0 {
  background-color: #9cFF9c;
  color: black;
  background: lightblue;
}
#T_ce354_row12_col1 {
  background-color: #41FF41;
  color: black;
  background: lightblue;
}
#T_ce354_row12_col2 {
  background-color: #61FF61;
  color: black;
  background: lightblue;
}
#T_ce354_row12_col3 {
  background-color: #62FF62;
  color: black;
  background: lightblue;
}
</style>
<table id="T_ce354">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_ce354_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_ce354_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_ce354_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_ce354_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_ce354_level0_row0" class="row_heading level0 row0" rowspan="11">write disk</th>
      <th id="T_ce354_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_ce354_row0_col0" class="data row0 col0" >1.4</td>
      <td id="T_ce354_row0_col1" class="data row0 col1" >1.5</td>
      <td id="T_ce354_row0_col2" class="data row0 col2" >3.8</td>
      <td id="T_ce354_row0_col3" class="data row0 col3" >2.5</td>
    </tr>
    <tr>
      <th id="T_ce354_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_ce354_row1_col0" class="data row1 col0" >0.8</td>
      <td id="T_ce354_row1_col1" class="data row1 col1" >1.3</td>
      <td id="T_ce354_row1_col2" class="data row1 col2" >7.3</td>
      <td id="T_ce354_row1_col3" class="data row1 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_ce354_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_ce354_row2_col0" class="data row2 col0" >1.0</td>
      <td id="T_ce354_row2_col1" class="data row2 col1" >1.0</td>
      <td id="T_ce354_row2_col2" class="data row2 col2" >3.4</td>
      <td id="T_ce354_row2_col3" class="data row2 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_ce354_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_ce354_row3_col0" class="data row3 col0" >0.8</td>
      <td id="T_ce354_row3_col1" class="data row3 col1" >1.5</td>
      <td id="T_ce354_row3_col2" class="data row3 col2" >11.5</td>
      <td id="T_ce354_row3_col3" class="data row3 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_ce354_level1_row4" class="row_heading level1 row4" >open replace tiny, sync once</th>
      <td id="T_ce354_row4_col0" class="data row4 col0" >3.2</td>
      <td id="T_ce354_row4_col1" class="data row4 col1" >24.0</td>
      <td id="T_ce354_row4_col2" class="data row4 col2" >4.8</td>
      <td id="T_ce354_row4_col3" class="data row4 col3" >6.2</td>
    </tr>
    <tr>
      <th id="T_ce354_level1_row5" class="row_heading level1 row5" >sync float large</th>
      <td id="T_ce354_row5_col0" class="data row5 col0" >1.0</td>
      <td id="T_ce354_row5_col1" class="data row5 col1" >1.0</td>
      <td id="T_ce354_row5_col2" class="data row5 col2" >0.6</td>
      <td id="T_ce354_row5_col3" class="data row5 col3" >0.5</td>
    </tr>
    <tr>
      <th id="T_ce354_level1_row6" class="row_heading level1 row6" >sync int huge</th>
      <td id="T_ce354_row6_col0" class="data row6 col0" >1.0</td>
      <td id="T_ce354_row6_col1" class="data row6 col1" >1.3</td>
      <td id="T_ce354_row6_col2" class="data row6 col2" >0.5</td>
      <td id="T_ce354_row6_col3" class="data row6 col3" >0.0</td>
    </tr>
    <tr>
      <th id="T_ce354_level1_row7" class="row_heading level1 row7" >sync int medium</th>
      <td id="T_ce354_row7_col0" class="data row7 col0" >1.0</td>
      <td id="T_ce354_row7_col1" class="data row7 col1" >0.7</td>
      <td id="T_ce354_row7_col2" class="data row7 col2" >3.0</td>
      <td id="T_ce354_row7_col3" class="data row7 col3" >1.3</td>
    </tr>
    <tr>
      <th id="T_ce354_level1_row8" class="row_heading level1 row8" >sync int small</th>
      <td id="T_ce354_row8_col0" class="data row8 col0" >0.8</td>
      <td id="T_ce354_row8_col1" class="data row8 col1" >1.2</td>
      <td id="T_ce354_row8_col2" class="data row8 col2" >3.0</td>
      <td id="T_ce354_row8_col3" class="data row8 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_ce354_level1_row9" class="row_heading level1 row9" >sync sym large</th>
      <td id="T_ce354_row9_col0" class="data row9 col0" >1.0</td>
      <td id="T_ce354_row9_col1" class="data row9 col1" >0.9</td>
      <td id="T_ce354_row9_col2" class="data row9 col2" >0.6</td>
      <td id="T_ce354_row9_col3" class="data row9 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_ce354_level1_row10" class="row_heading level1 row10" >sync table after sort</th>
      <td id="T_ce354_row10_col0" class="data row10 col0" >0.6</td>
      <td id="T_ce354_row10_col1" class="data row10 col1" >44.7</td>
      <td id="T_ce354_row10_col2" class="data row10 col2" >11.3</td>
      <td id="T_ce354_row10_col3" class="data row10 col3" >11.1</td>
    </tr>
    <tr>
      <th id="T_ce354_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_ce354_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_ce354_row11_col0" class="data row11 col0" >1.0</td>
      <td id="T_ce354_row11_col1" class="data row11 col1" >2.1</td>
      <td id="T_ce354_row11_col2" class="data row11 col2" >2.8</td>
      <td id="T_ce354_row11_col3" class="data row11 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_ce354_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_ce354_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_ce354_row12_col0" class="data row12 col0" >3.2</td>
      <td id="T_ce354_row12_col1" class="data row12 col1" >44.7</td>
      <td id="T_ce354_row12_col2" class="data row12 col2" >11.5</td>
      <td id="T_ce354_row12_col3" class="data row12 col3" >11.1</td>
    </tr>
  </tbody>
</table>




### Read

#### Single kdb+ process:




<style type="text/css">
#T_0b5e5 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_0b5e5_row0_col0, #T_0b5e5_row4_col2 {
  background-color: #f8FFf8;
  color: black;
}
#T_0b5e5_row0_col1, #T_0b5e5_row3_col1 {
  background-color: #8aFF8a;
  color: black;
}
#T_0b5e5_row0_col2, #T_0b5e5_row3_col2 {
  background-color: #f1FFf1;
  color: black;
}
#T_0b5e5_row0_col3 {
  background-color: #b9FFb9;
  color: black;
}
#T_0b5e5_row1_col0, #T_0b5e5_row4_col0 {
  background-color: #fdFFfd;
  color: black;
}
#T_0b5e5_row1_col1 {
  background-color: #f2FFf2;
  color: black;
}
#T_0b5e5_row1_col2, #T_0b5e5_row3_col0 {
  background-color: #fbFFfb;
  color: black;
}
#T_0b5e5_row1_col3 {
  background-color: #FFe1e1;
  color: black;
}
#T_0b5e5_row2_col0 {
  background-color: #FFefef;
  color: black;
}
#T_0b5e5_row2_col1, #T_0b5e5_row6_col1 {
  background-color: #78FF78;
  color: black;
}
#T_0b5e5_row2_col2 {
  background-color: #FFfcfc;
  color: black;
}
#T_0b5e5_row2_col3 {
  background-color: #FFd6d6;
  color: black;
}
#T_0b5e5_row3_col3 {
  background-color: #b4FFb4;
  color: black;
}
#T_0b5e5_row4_col1, #T_0b5e5_row9_col0 {
  background-color: #e7FFe7;
  color: black;
}
#T_0b5e5_row4_col3 {
  background-color: #FFdddd;
  color: black;
}
#T_0b5e5_row5_col0 {
  background-color: #FFf2f2;
  color: black;
}
#T_0b5e5_row5_col1 {
  background-color: #76FF76;
  color: black;
}
#T_0b5e5_row5_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_0b5e5_row5_col3 {
  background-color: #FFdbdb;
  color: black;
}
#T_0b5e5_row6_col0 {
  background-color: #baFFba;
  color: black;
}
#T_0b5e5_row6_col2 {
  background-color: #bbFFbb;
  color: black;
}
#T_0b5e5_row6_col3 {
  background-color: #b5FFb5;
  color: black;
}
#T_0b5e5_row7_col0 {
  background-color: #f0FFf0;
  color: black;
}
#T_0b5e5_row7_col1 {
  background-color: #FFcdcd;
  color: black;
}
#T_0b5e5_row7_col2 {
  background-color: #e1FFe1;
  color: black;
}
#T_0b5e5_row7_col3 {
  background-color: #9aFF9a;
  color: black;
}
#T_0b5e5_row8_col0 {
  background-color: #efFFef;
  color: black;
}
#T_0b5e5_row8_col1 {
  background-color: #FFcece;
  color: black;
}
#T_0b5e5_row8_col2 {
  background-color: #e8FFe8;
  color: black;
}
#T_0b5e5_row8_col3 {
  background-color: #86FF86;
  color: black;
}
#T_0b5e5_row9_col1 {
  background-color: #caFFca;
  color: black;
}
#T_0b5e5_row9_col2 {
  background-color: #e9FFe9;
  color: black;
}
#T_0b5e5_row9_col3 {
  background-color: #7cFF7c;
  color: black;
}
#T_0b5e5_row10_col0 {
  background-color: #FFc5c5;
  color: black;
}
#T_0b5e5_row10_col1 {
  background-color: #FFe6e6;
  color: black;
}
#T_0b5e5_row10_col2 {
  background-color: #e0FFe0;
  color: black;
}
#T_0b5e5_row10_col3 {
  background-color: #cfFFcf;
  color: black;
}
#T_0b5e5_row11_col0 {
  background-color: #f5FFf5;
  color: black;
  background: lightblue;
}
#T_0b5e5_row11_col1 {
  background-color: #b5FFb5;
  color: black;
  background: lightblue;
}
#T_0b5e5_row11_col2 {
  background-color: #ebFFeb;
  color: black;
  background: lightblue;
}
#T_0b5e5_row11_col3 {
  background-color: #c4FFc4;
  color: black;
  background: lightblue;
}
#T_0b5e5_row12_col0 {
  background-color: #baFFba;
  color: black;
  background: lightblue;
}
#T_0b5e5_row12_col1 {
  background-color: #76FF76;
  color: black;
  background: lightblue;
}
#T_0b5e5_row12_col2 {
  background-color: #bbFFbb;
  color: black;
  background: lightblue;
}
#T_0b5e5_row12_col3 {
  background-color: #7cFF7c;
  color: black;
  background: lightblue;
}
</style>
<table id="T_0b5e5">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_0b5e5_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_0b5e5_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_0b5e5_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_0b5e5_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_0b5e5_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_0b5e5_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_0b5e5_row0_col0" class="data row0 col0" >1.1</td>
      <td id="T_0b5e5_row0_col1" class="data row0 col1" >4.4</td>
      <td id="T_0b5e5_row0_col2" class="data row0 col2" >1.1</td>
      <td id="T_0b5e5_row0_col3" class="data row0 col3" >2.1</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_0b5e5_row1_col0" class="data row1 col0" >1.0</td>
      <td id="T_0b5e5_row1_col1" class="data row1 col1" >1.1</td>
      <td id="T_0b5e5_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_0b5e5_row1_col3" class="data row1 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_0b5e5_row2_col0" class="data row2 col0" >0.9</td>
      <td id="T_0b5e5_row2_col1" class="data row2 col1" >6.4</td>
      <td id="T_0b5e5_row2_col2" class="data row2 col2" >1.0</td>
      <td id="T_0b5e5_row2_col3" class="data row2 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_0b5e5_row3_col0" class="data row3 col0" >1.0</td>
      <td id="T_0b5e5_row3_col1" class="data row3 col1" >4.4</td>
      <td id="T_0b5e5_row3_col2" class="data row3 col2" >1.1</td>
      <td id="T_0b5e5_row3_col3" class="data row3 col3" >2.3</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_0b5e5_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_0b5e5_row4_col1" class="data row4 col1" >1.2</td>
      <td id="T_0b5e5_row4_col2" class="data row4 col2" >1.1</td>
      <td id="T_0b5e5_row4_col3" class="data row4 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_0b5e5_row5_col0" class="data row5 col0" >0.9</td>
      <td id="T_0b5e5_row5_col1" class="data row5 col1" >6.7</td>
      <td id="T_0b5e5_row5_col2" class="data row5 col2" >1.0</td>
      <td id="T_0b5e5_row5_col3" class="data row5 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_0b5e5_row6_col0" class="data row6 col0" >2.1</td>
      <td id="T_0b5e5_row6_col1" class="data row6 col1" >6.4</td>
      <td id="T_0b5e5_row6_col2" class="data row6 col2" >2.0</td>
      <td id="T_0b5e5_row6_col3" class="data row6 col3" >2.2</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level0_row7" class="row_heading level0 row7" rowspan="4">read disk write mem</th>
      <th id="T_0b5e5_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_0b5e5_row7_col0" class="data row7 col0" >1.1</td>
      <td id="T_0b5e5_row7_col1" class="data row7 col1" >0.8</td>
      <td id="T_0b5e5_row7_col2" class="data row7 col2" >1.3</td>
      <td id="T_0b5e5_row7_col3" class="data row7 col3" >3.3</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_0b5e5_row8_col0" class="data row8 col0" >1.2</td>
      <td id="T_0b5e5_row8_col1" class="data row8 col1" >0.8</td>
      <td id="T_0b5e5_row8_col2" class="data row8 col2" >1.2</td>
      <td id="T_0b5e5_row8_col3" class="data row8 col3" >4.7</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_0b5e5_row9_col0" class="data row9 col0" >1.2</td>
      <td id="T_0b5e5_row9_col1" class="data row9 col1" >1.7</td>
      <td id="T_0b5e5_row9_col2" class="data row9 col2" >1.2</td>
      <td id="T_0b5e5_row9_col3" class="data row9 col3" >5.8</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_0b5e5_row10_col0" class="data row10 col0" >0.7</td>
      <td id="T_0b5e5_row10_col1" class="data row10 col1" >0.9</td>
      <td id="T_0b5e5_row10_col2" class="data row10 col2" >1.3</td>
      <td id="T_0b5e5_row10_col3" class="data row10 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_0b5e5_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_0b5e5_row11_col0" class="data row11 col0" >1.1</td>
      <td id="T_0b5e5_row11_col1" class="data row11 col1" >2.2</td>
      <td id="T_0b5e5_row11_col2" class="data row11 col2" >1.2</td>
      <td id="T_0b5e5_row11_col3" class="data row11 col3" >1.8</td>
    </tr>
    <tr>
      <th id="T_0b5e5_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_0b5e5_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_0b5e5_row12_col0" class="data row12 col0" >2.1</td>
      <td id="T_0b5e5_row12_col1" class="data row12 col1" >6.7</td>
      <td id="T_0b5e5_row12_col2" class="data row12 col2" >2.0</td>
      <td id="T_0b5e5_row12_col3" class="data row12 col3" >5.8</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS excels in reading from disk if there is a single kdb+ reader.




<style type="text/css">
#T_44386 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_44386_row0_col0 {
  background-color: #e7FFe7;
  color: black;
}
#T_44386_row0_col1 {
  background-color: #e0FFe0;
  color: black;
}
#T_44386_row0_col2 {
  background-color: #ddFFdd;
  color: black;
}
#T_44386_row0_col3 {
  background-color: #dbFFdb;
  color: black;
}
#T_44386_row1_col0 {
  background-color: #f4FFf4;
  color: black;
}
#T_44386_row1_col1 {
  background-color: #f2FFf2;
  color: black;
}
#T_44386_row1_col2, #T_44386_row3_col0 {
  background-color: #fdFFfd;
  color: black;
}
#T_44386_row1_col3 {
  background-color: #FFfbfb;
  color: black;
}
#T_44386_row2_col0, #T_44386_row5_col3 {
  background-color: #f3FFf3;
  color: black;
}
#T_44386_row2_col1, #T_44386_row3_col2 {
  background-color: #f0FFf0;
  color: black;
}
#T_44386_row2_col2, #T_44386_row2_col3 {
  background-color: #f1FFf1;
  color: black;
}
#T_44386_row3_col1 {
  background-color: #eeFFee;
  color: black;
}
#T_44386_row3_col3 {
  background-color: #ecFFec;
  color: black;
}
#T_44386_row4_col0 {
  background-color: #FFf7f7;
  color: black;
}
#T_44386_row4_col1 {
  background-color: #f8FFf8;
  color: black;
}
#T_44386_row4_col2 {
  background-color: #f7FFf7;
  color: black;
}
#T_44386_row4_col3 {
  background-color: #FFf1f1;
  color: black;
}
#T_44386_row5_col0 {
  background-color: #feFFfe;
  color: black;
}
#T_44386_row5_col1, #T_44386_row10_col3 {
  background-color: #f6FFf6;
  color: black;
}
#T_44386_row5_col2 {
  background-color: #e9FFe9;
  color: black;
}
#T_44386_row6_col0 {
  background-color: #FFe0e0;
  color: black;
}
#T_44386_row6_col1 {
  background-color: #FFeeee;
  color: black;
}
#T_44386_row6_col2 {
  background-color: #FFf2f2;
  color: black;
}
#T_44386_row6_col3 {
  background-color: #f5FFf5;
  color: black;
}
#T_44386_row7_col0 {
  background-color: #cbFFcb;
  color: black;
}
#T_44386_row7_col1 {
  background-color: #b9FFb9;
  color: black;
}
#T_44386_row7_col2, #T_44386_row7_col3 {
  background-color: #acFFac;
  color: black;
}
#T_44386_row8_col0 {
  background-color: #bfFFbf;
  color: black;
}
#T_44386_row8_col1 {
  background-color: #b5FFb5;
  color: black;
}
#T_44386_row8_col2 {
  background-color: #c1FFc1;
  color: black;
}
#T_44386_row8_col3 {
  background-color: #b3FFb3;
  color: black;
}
#T_44386_row9_col0 {
  background-color: #cfFFcf;
  color: black;
}
#T_44386_row9_col1 {
  background-color: #a7FFa7;
  color: black;
}
#T_44386_row9_col2 {
  background-color: #d4FFd4;
  color: black;
}
#T_44386_row9_col3 {
  background-color: #b0FFb0;
  color: black;
}
#T_44386_row10_col0 {
  background-color: #FFb2b2;
  color: black;
}
#T_44386_row10_col1 {
  background-color: #FFb3b3;
  color: black;
}
#T_44386_row10_col2 {
  background-color: #FF9f9f;
  color: black;
}
#T_44386_row11_col0 {
  background-color: #f0FFf0;
  color: black;
  background: lightblue;
}
#T_44386_row11_col1 {
  background-color: #e3FFe3;
  color: black;
  background: lightblue;
}
#T_44386_row11_col2 {
  background-color: #e9FFe9;
  color: black;
  background: lightblue;
}
#T_44386_row11_col3 {
  background-color: #deFFde;
  color: black;
  background: lightblue;
}
#T_44386_row12_col0 {
  background-color: #bfFFbf;
  color: black;
  background: lightblue;
}
#T_44386_row12_col1 {
  background-color: #a7FFa7;
  color: black;
  background: lightblue;
}
#T_44386_row12_col2, #T_44386_row12_col3 {
  background-color: #acFFac;
  color: black;
  background: lightblue;
}
</style>
<table id="T_44386">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_44386_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_44386_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_44386_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_44386_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_44386_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_44386_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_44386_row0_col0" class="data row0 col0" >1.2</td>
      <td id="T_44386_row0_col1" class="data row0 col1" >1.3</td>
      <td id="T_44386_row0_col2" class="data row0 col2" >1.4</td>
      <td id="T_44386_row0_col3" class="data row0 col3" >1.4</td>
    </tr>
    <tr>
      <th id="T_44386_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_44386_row1_col0" class="data row1 col0" >1.1</td>
      <td id="T_44386_row1_col1" class="data row1 col1" >1.1</td>
      <td id="T_44386_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_44386_row1_col3" class="data row1 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_44386_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_44386_row2_col0" class="data row2 col0" >1.1</td>
      <td id="T_44386_row2_col1" class="data row2 col1" >1.1</td>
      <td id="T_44386_row2_col2" class="data row2 col2" >1.1</td>
      <td id="T_44386_row2_col3" class="data row2 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_44386_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_44386_row3_col0" class="data row3 col0" >1.0</td>
      <td id="T_44386_row3_col1" class="data row3 col1" >1.2</td>
      <td id="T_44386_row3_col2" class="data row3 col2" >1.1</td>
      <td id="T_44386_row3_col3" class="data row3 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_44386_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_44386_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_44386_row4_col1" class="data row4 col1" >1.1</td>
      <td id="T_44386_row4_col2" class="data row4 col2" >1.1</td>
      <td id="T_44386_row4_col3" class="data row4 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_44386_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_44386_row5_col0" class="data row5 col0" >1.0</td>
      <td id="T_44386_row5_col1" class="data row5 col1" >1.1</td>
      <td id="T_44386_row5_col2" class="data row5 col2" >1.2</td>
      <td id="T_44386_row5_col3" class="data row5 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_44386_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_44386_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_44386_row6_col0" class="data row6 col0" >0.9</td>
      <td id="T_44386_row6_col1" class="data row6 col1" >0.9</td>
      <td id="T_44386_row6_col2" class="data row6 col2" >0.9</td>
      <td id="T_44386_row6_col3" class="data row6 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_44386_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_44386_row7_col0" class="data row7 col0" >1.7</td>
      <td id="T_44386_row7_col1" class="data row7 col1" >2.1</td>
      <td id="T_44386_row7_col2" class="data row7 col2" >2.5</td>
      <td id="T_44386_row7_col3" class="data row7 col3" >2.5</td>
    </tr>
    <tr>
      <th id="T_44386_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_44386_row8_col0" class="data row8 col0" >2.0</td>
      <td id="T_44386_row8_col1" class="data row8 col1" >2.2</td>
      <td id="T_44386_row8_col2" class="data row8 col2" >1.9</td>
      <td id="T_44386_row8_col3" class="data row8 col3" >2.3</td>
    </tr>
    <tr>
      <th id="T_44386_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_44386_row9_col0" class="data row9 col0" >1.6</td>
      <td id="T_44386_row9_col1" class="data row9 col1" >2.7</td>
      <td id="T_44386_row9_col2" class="data row9 col2" >1.5</td>
      <td id="T_44386_row9_col3" class="data row9 col3" >2.4</td>
    </tr>
    <tr>
      <th id="T_44386_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_44386_row10_col0" class="data row10 col0" >0.7</td>
      <td id="T_44386_row10_col1" class="data row10 col1" >0.7</td>
      <td id="T_44386_row10_col2" class="data row10 col2" >0.6</td>
      <td id="T_44386_row10_col3" class="data row10 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_44386_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_44386_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_44386_row11_col0" class="data row11 col0" >1.1</td>
      <td id="T_44386_row11_col1" class="data row11 col1" >1.3</td>
      <td id="T_44386_row11_col2" class="data row11 col2" >1.2</td>
      <td id="T_44386_row11_col3" class="data row11 col3" >1.4</td>
    </tr>
    <tr>
      <th id="T_44386_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_44386_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_44386_row12_col0" class="data row12 col0" >2.0</td>
      <td id="T_44386_row12_col1" class="data row12 col1" >2.7</td>
      <td id="T_44386_row12_col2" class="data row12 col2" >2.5</td>
      <td id="T_44386_row12_col3" class="data row12 col3" >2.5</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS excels in reading from page cache if there is a single kdb+ reader.

#### 64 kdb+ processes:




<style type="text/css">
#T_75728 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_75728_row0_col0, #T_75728_row3_col0, #T_75728_row4_col0, #T_75728_row4_col1 {
  background-color: #feFFfe;
  color: black;
}
#T_75728_row0_col1 {
  background-color: #b4FFb4;
  color: black;
}
#T_75728_row0_col2 {
  background-color: #FFeeee;
  color: black;
}
#T_75728_row0_col3 {
  background-color: #FF8181;
  color: white;
}
#T_75728_row1_col0 {
  background-color: #FFfdfd;
  color: black;
}
#T_75728_row1_col1, #T_75728_row9_col3 {
  background-color: #f4FFf4;
  color: black;
}
#T_75728_row1_col2 {
  background-color: #FFf2f2;
  color: black;
}
#T_75728_row1_col3 {
  background-color: #FFbaba;
  color: black;
}
#T_75728_row2_col0 {
  background-color: #FFd2d2;
  color: black;
}
#T_75728_row2_col1 {
  background-color: #d5FFd5;
  color: black;
}
#T_75728_row2_col2, #T_75728_row5_col2 {
  background-color: #FFc7c7;
  color: black;
}
#T_75728_row2_col3 {
  background-color: #FF5252;
  color: white;
}
#T_75728_row3_col1 {
  background-color: #b6FFb6;
  color: black;
}
#T_75728_row3_col2 {
  background-color: #FFefef;
  color: black;
}
#T_75728_row3_col3 {
  background-color: #FF8585;
  color: white;
}
#T_75728_row4_col2 {
  background-color: #FFf1f1;
  color: black;
}
#T_75728_row4_col3 {
  background-color: #FF9a9a;
  color: black;
}
#T_75728_row5_col0 {
  background-color: #FFd3d3;
  color: black;
}
#T_75728_row5_col1 {
  background-color: #d6FFd6;
  color: black;
}
#T_75728_row5_col3 {
  background-color: #FF4d4d;
  color: white;
}
#T_75728_row6_col0 {
  background-color: #69FF69;
  color: black;
}
#T_75728_row6_col1 {
  background-color: #6cFF6c;
  color: black;
}
#T_75728_row6_col2 {
  background-color: #6aFF6a;
  color: black;
}
#T_75728_row6_col3 {
  background-color: #77FF77;
  color: black;
}
#T_75728_row7_col0, #T_75728_row7_col2 {
  background-color: #FFcbcb;
  color: black;
}
#T_75728_row7_col1 {
  background-color: #FFbdbd;
  color: black;
}
#T_75728_row7_col3 {
  background-color: #FF8f8f;
  color: black;
}
#T_75728_row8_col0 {
  background-color: #FFe0e0;
  color: black;
}
#T_75728_row8_col1 {
  background-color: #FFcccc;
  color: black;
}
#T_75728_row8_col2 {
  background-color: #FFe4e4;
  color: black;
}
#T_75728_row8_col3 {
  background-color: #FFa0a0;
  color: black;
}
#T_75728_row9_col0 {
  background-color: #FFf9f9;
  color: black;
}
#T_75728_row9_col1 {
  background-color: #FFd0d0;
  color: black;
}
#T_75728_row9_col2 {
  background-color: #FFecec;
  color: black;
}
#T_75728_row10_col0 {
  background-color: #efFFef;
  color: black;
}
#T_75728_row10_col1 {
  background-color: #FF9393;
  color: black;
}
#T_75728_row10_col2 {
  background-color: #beFFbe;
  color: black;
}
#T_75728_row10_col3 {
  background-color: #f9FFf9;
  color: black;
}
#T_75728_row11_col0 {
  background-color: #f0FFf0;
  color: black;
  background: lightblue;
}
#T_75728_row11_col1 {
  background-color: #e1FFe1;
  color: black;
  background: lightblue;
}
#T_75728_row11_col2 {
  background-color: #efFFef;
  color: black;
  background: lightblue;
}
#T_75728_row11_col3 {
  background-color: #FFafaf;
  color: black;
  background: lightblue;
}
#T_75728_row12_col0 {
  background-color: #69FF69;
  color: black;
  background: lightblue;
}
#T_75728_row12_col1 {
  background-color: #6cFF6c;
  color: black;
  background: lightblue;
}
#T_75728_row12_col2 {
  background-color: #6aFF6a;
  color: black;
  background: lightblue;
}
#T_75728_row12_col3 {
  background-color: #77FF77;
  color: black;
  background: lightblue;
}
</style>
<table id="T_75728">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_75728_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_75728_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_75728_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_75728_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_75728_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_75728_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_75728_row0_col0" class="data row0 col0" >1.0</td>
      <td id="T_75728_row0_col1" class="data row0 col1" >2.3</td>
      <td id="T_75728_row0_col2" class="data row0 col2" >0.9</td>
      <td id="T_75728_row0_col3" class="data row0 col3" >0.4</td>
    </tr>
    <tr>
      <th id="T_75728_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_75728_row1_col0" class="data row1 col0" >1.0</td>
      <td id="T_75728_row1_col1" class="data row1 col1" >1.1</td>
      <td id="T_75728_row1_col2" class="data row1 col2" >0.9</td>
      <td id="T_75728_row1_col3" class="data row1 col3" >0.7</td>
    </tr>
    <tr>
      <th id="T_75728_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_75728_row2_col0" class="data row2 col0" >0.8</td>
      <td id="T_75728_row2_col1" class="data row2 col1" >1.5</td>
      <td id="T_75728_row2_col2" class="data row2 col2" >0.7</td>
      <td id="T_75728_row2_col3" class="data row2 col3" >0.2</td>
    </tr>
    <tr>
      <th id="T_75728_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_75728_row3_col0" class="data row3 col0" >1.0</td>
      <td id="T_75728_row3_col1" class="data row3 col1" >2.2</td>
      <td id="T_75728_row3_col2" class="data row3 col2" >0.9</td>
      <td id="T_75728_row3_col3" class="data row3 col3" >0.5</td>
    </tr>
    <tr>
      <th id="T_75728_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_75728_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_75728_row4_col1" class="data row4 col1" >1.0</td>
      <td id="T_75728_row4_col2" class="data row4 col2" >0.9</td>
      <td id="T_75728_row4_col3" class="data row4 col3" >0.5</td>
    </tr>
    <tr>
      <th id="T_75728_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_75728_row5_col0" class="data row5 col0" >0.8</td>
      <td id="T_75728_row5_col1" class="data row5 col1" >1.5</td>
      <td id="T_75728_row5_col2" class="data row5 col2" >0.8</td>
      <td id="T_75728_row5_col3" class="data row5 col3" >0.2</td>
    </tr>
    <tr>
      <th id="T_75728_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_75728_row6_col0" class="data row6 col0" >9.1</td>
      <td id="T_75728_row6_col1" class="data row6 col1" >8.6</td>
      <td id="T_75728_row6_col2" class="data row6 col2" >9.0</td>
      <td id="T_75728_row6_col3" class="data row6 col3" >6.5</td>
    </tr>
    <tr>
      <th id="T_75728_level0_row7" class="row_heading level0 row7" rowspan="4">read disk write mem</th>
      <th id="T_75728_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_75728_row7_col0" class="data row7 col0" >0.8</td>
      <td id="T_75728_row7_col1" class="data row7 col1" >0.7</td>
      <td id="T_75728_row7_col2" class="data row7 col2" >0.8</td>
      <td id="T_75728_row7_col3" class="data row7 col3" >0.5</td>
    </tr>
    <tr>
      <th id="T_75728_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_75728_row8_col0" class="data row8 col0" >0.9</td>
      <td id="T_75728_row8_col1" class="data row8 col1" >0.8</td>
      <td id="T_75728_row8_col2" class="data row8 col2" >0.9</td>
      <td id="T_75728_row8_col3" class="data row8 col3" >0.6</td>
    </tr>
    <tr>
      <th id="T_75728_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_75728_row9_col0" class="data row9 col0" >1.0</td>
      <td id="T_75728_row9_col1" class="data row9 col1" >0.8</td>
      <td id="T_75728_row9_col2" class="data row9 col2" >0.9</td>
      <td id="T_75728_row9_col3" class="data row9 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_75728_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_75728_row10_col0" class="data row10 col0" >1.2</td>
      <td id="T_75728_row10_col1" class="data row10 col1" >0.5</td>
      <td id="T_75728_row10_col2" class="data row10 col2" >2.0</td>
      <td id="T_75728_row10_col3" class="data row10 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_75728_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_75728_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_75728_row11_col0" class="data row11 col0" >1.1</td>
      <td id="T_75728_row11_col1" class="data row11 col1" >1.3</td>
      <td id="T_75728_row11_col2" class="data row11 col2" >1.2</td>
      <td id="T_75728_row11_col3" class="data row11 col3" >0.6</td>
    </tr>
    <tr>
      <th id="T_75728_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_75728_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_75728_row12_col0" class="data row12 col0" >9.1</td>
      <td id="T_75728_row12_col1" class="data row12 col1" >8.6</td>
      <td id="T_75728_row12_col2" class="data row12 col2" >9.0</td>
      <td id="T_75728_row12_col3" class="data row12 col3" >6.5</td>
    </tr>
  </tbody>
</table>




**Observation**: ZFS excels in reading from disk if many kdb+ processes (HDB pool) reading the data in parallel. The only exception is read binary (`read1`) but this is not considered a typical query pattern in a production kdb+ environment




<style type="text/css">
#T_35aaf th.col_heading.level0 {
  font-size: 1.5em;
}
#T_35aaf_row0_col0, #T_35aaf_row0_col2, #T_35aaf_row3_col0 {
  background-color: #f2FFf2;
  color: black;
}
#T_35aaf_row0_col1 {
  background-color: #f4FFf4;
  color: black;
}
#T_35aaf_row0_col3 {
  background-color: #eaFFea;
  color: black;
}
#T_35aaf_row1_col0, #T_35aaf_row1_col2, #T_35aaf_row4_col2, #T_35aaf_row6_col0, #T_35aaf_row6_col1 {
  background-color: #feFFfe;
  color: black;
}
#T_35aaf_row1_col1, #T_35aaf_row2_col2, #T_35aaf_row6_col2 {
  background-color: #fdFFfd;
  color: black;
}
#T_35aaf_row1_col3 {
  background-color: #b6FFb6;
  color: black;
}
#T_35aaf_row2_col0 {
  background-color: #FFfefe;
  color: black;
}
#T_35aaf_row2_col1, #T_35aaf_row4_col0 {
  background-color: #FFfbfb;
  color: black;
}
#T_35aaf_row2_col3 {
  background-color: #b8FFb8;
  color: black;
}
#T_35aaf_row3_col1 {
  background-color: #f8FFf8;
  color: black;
}
#T_35aaf_row3_col2, #T_35aaf_row5_col0 {
  background-color: #f6FFf6;
  color: black;
}
#T_35aaf_row3_col3, #T_35aaf_row10_col1 {
  background-color: #f3FFf3;
  color: black;
}
#T_35aaf_row4_col1 {
  background-color: #FFfdfd;
  color: black;
}
#T_35aaf_row4_col3 {
  background-color: #FFe1e1;
  color: black;
}
#T_35aaf_row5_col1, #T_35aaf_row6_col3 {
  background-color: #f1FFf1;
  color: black;
}
#T_35aaf_row5_col2, #T_35aaf_row5_col3 {
  background-color: #f9FFf9;
  color: black;
}
#T_35aaf_row7_col0 {
  background-color: #c1FFc1;
  color: black;
}
#T_35aaf_row7_col1 {
  background-color: #c0FFc0;
  color: black;
}
#T_35aaf_row7_col2, #T_35aaf_row8_col2 {
  background-color: #b4FFb4;
  color: black;
}
#T_35aaf_row7_col3 {
  background-color: #7fFF7f;
  color: black;
}
#T_35aaf_row8_col0, #T_35aaf_row8_col1 {
  background-color: #c7FFc7;
  color: black;
}
#T_35aaf_row8_col3 {
  background-color: #bbFFbb;
  color: black;
}
#T_35aaf_row9_col0 {
  background-color: #bdFFbd;
  color: black;
}
#T_35aaf_row9_col1 {
  background-color: #b7FFb7;
  color: black;
}
#T_35aaf_row9_col2 {
  background-color: #beFFbe;
  color: black;
}
#T_35aaf_row9_col3 {
  background-color: #6dFF6d;
  color: black;
}
#T_35aaf_row10_col0 {
  background-color: #f0FFf0;
  color: black;
}
#T_35aaf_row10_col2 {
  background-color: #75FF75;
  color: black;
}
#T_35aaf_row10_col3 {
  background-color: #c5FFc5;
  color: black;
}
#T_35aaf_row11_col0, #T_35aaf_row11_col1 {
  background-color: #e8FFe8;
  color: black;
  background: lightblue;
}
#T_35aaf_row11_col2 {
  background-color: #d5FFd5;
  color: black;
  background: lightblue;
}
#T_35aaf_row11_col3 {
  background-color: #c2FFc2;
  color: black;
  background: lightblue;
}
#T_35aaf_row12_col0 {
  background-color: #bdFFbd;
  color: black;
  background: lightblue;
}
#T_35aaf_row12_col1 {
  background-color: #b7FFb7;
  color: black;
  background: lightblue;
}
#T_35aaf_row12_col2 {
  background-color: #75FF75;
  color: black;
  background: lightblue;
}
#T_35aaf_row12_col3 {
  background-color: #6dFF6d;
  color: black;
  background: lightblue;
}
</style>
<table id="T_35aaf">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_35aaf_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_35aaf_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_35aaf_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_35aaf_level0_col3" class="col_heading level0 col3" >ZFS</th>
    </tr>
    <tr>
      <th class="index_name level0" >testtype</th>
      <th class="index_name level1" >test</th>
      <th class="blank col0" >&nbsp;</th>
      <th class="blank col1" >&nbsp;</th>
      <th class="blank col2" >&nbsp;</th>
      <th class="blank col3" >&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th id="T_35aaf_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_35aaf_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_35aaf_row0_col0" class="data row0 col0" >1.1</td>
      <td id="T_35aaf_row0_col1" class="data row0 col1" >1.1</td>
      <td id="T_35aaf_row0_col2" class="data row0 col2" >1.1</td>
      <td id="T_35aaf_row0_col3" class="data row0 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_35aaf_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_35aaf_row1_col0" class="data row1 col0" >1.0</td>
      <td id="T_35aaf_row1_col1" class="data row1 col1" >1.0</td>
      <td id="T_35aaf_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_35aaf_row1_col3" class="data row1 col3" >2.2</td>
    </tr>
    <tr>
      <th id="T_35aaf_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_35aaf_row2_col0" class="data row2 col0" >1.0</td>
      <td id="T_35aaf_row2_col1" class="data row2 col1" >1.0</td>
      <td id="T_35aaf_row2_col2" class="data row2 col2" >1.0</td>
      <td id="T_35aaf_row2_col3" class="data row2 col3" >2.1</td>
    </tr>
    <tr>
      <th id="T_35aaf_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_35aaf_row3_col0" class="data row3 col0" >1.1</td>
      <td id="T_35aaf_row3_col1" class="data row3 col1" >1.1</td>
      <td id="T_35aaf_row3_col2" class="data row3 col2" >1.1</td>
      <td id="T_35aaf_row3_col3" class="data row3 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_35aaf_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_35aaf_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_35aaf_row4_col1" class="data row4 col1" >1.0</td>
      <td id="T_35aaf_row4_col2" class="data row4 col2" >1.0</td>
      <td id="T_35aaf_row4_col3" class="data row4 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_35aaf_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_35aaf_row5_col0" class="data row5 col0" >1.1</td>
      <td id="T_35aaf_row5_col1" class="data row5 col1" >1.1</td>
      <td id="T_35aaf_row5_col2" class="data row5 col2" >1.1</td>
      <td id="T_35aaf_row5_col3" class="data row5 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_35aaf_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_35aaf_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_35aaf_row6_col0" class="data row6 col0" >1.0</td>
      <td id="T_35aaf_row6_col1" class="data row6 col1" >1.0</td>
      <td id="T_35aaf_row6_col2" class="data row6 col2" >1.0</td>
      <td id="T_35aaf_row6_col3" class="data row6 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_35aaf_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_35aaf_row7_col0" class="data row7 col0" >1.9</td>
      <td id="T_35aaf_row7_col1" class="data row7 col1" >1.9</td>
      <td id="T_35aaf_row7_col2" class="data row7 col2" >2.3</td>
      <td id="T_35aaf_row7_col3" class="data row7 col3" >5.4</td>
    </tr>
    <tr>
      <th id="T_35aaf_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_35aaf_row8_col0" class="data row8 col0" >1.8</td>
      <td id="T_35aaf_row8_col1" class="data row8 col1" >1.8</td>
      <td id="T_35aaf_row8_col2" class="data row8 col2" >2.2</td>
      <td id="T_35aaf_row8_col3" class="data row8 col3" >2.1</td>
    </tr>
    <tr>
      <th id="T_35aaf_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_35aaf_row9_col0" class="data row9 col0" >2.0</td>
      <td id="T_35aaf_row9_col1" class="data row9 col1" >2.2</td>
      <td id="T_35aaf_row9_col2" class="data row9 col2" >2.0</td>
      <td id="T_35aaf_row9_col3" class="data row9 col3" >8.3</td>
    </tr>
    <tr>
      <th id="T_35aaf_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_35aaf_row10_col0" class="data row10 col0" >1.1</td>
      <td id="T_35aaf_row10_col1" class="data row10 col1" >1.1</td>
      <td id="T_35aaf_row10_col2" class="data row10 col2" >6.8</td>
      <td id="T_35aaf_row10_col3" class="data row10 col3" >1.8</td>
    </tr>
    <tr>
      <th id="T_35aaf_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_35aaf_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_35aaf_row11_col0" class="data row11 col0" >1.2</td>
      <td id="T_35aaf_row11_col1" class="data row11 col1" >1.2</td>
      <td id="T_35aaf_row11_col2" class="data row11 col2" >1.5</td>
      <td id="T_35aaf_row11_col3" class="data row11 col3" >1.9</td>
    </tr>
    <tr>
      <th id="T_35aaf_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_35aaf_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_35aaf_row12_col0" class="data row12 col0" >2.0</td>
      <td id="T_35aaf_row12_col1" class="data row12 col1" >2.2</td>
      <td id="T_35aaf_row12_col2" class="data row12 col2" >6.8</td>
      <td id="T_35aaf_row12_col3" class="data row12 col3" >8.3</td>
    </tr>
  </tbody>
</table>




**Observation**: The performance advantage of ZFS vanishes entirely when data is served from the page cache.
