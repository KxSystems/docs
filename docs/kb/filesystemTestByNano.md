# Choosing the Right File System for kdb+: A Case Study with KX Nano

The performance of a kdb+ system is critically dependent on the throughput and latency of its underlying storage. In a Linux environment, the file system is the foundational layer that enables data management on a given storage partition.

This paper presents a comparative performance analysis of various file systems using the [KX Nano](https://github.com/KxSystems/nano) benchmarking utility. The evaluation was conducted across two distinct test environments, each with different operating systems and physical disk types: a low-latency NVMe drive optimized for high random IOPS, and a SATA disk chosen for high sequential bandwidth.

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
   * **Mid/Cold Tier**: Data is queried less often, meaning reads are more likely to come directly from storage. In this scenario, ZFS's strong random read performance from disk provides a distinct advantage.

**Disclaimer**: These guidelines are specific to the tested hardware and workloads. We strongly encourage readers to perform their own benchmarks that reflect their specific application profiles. To facilitate this, the benchmarking suite used in this study is [included with the KX Nano codebase](https://github.com/KxSystems/nano/tree/master/scripts/fsBenchmark), available on GitHub.

### Details

All benchmarks were executed in September 2025 using kdb+ 4.1 (2025.04.28) and [KX Nano 6.4.0](https://github.com/KxSystems/nano/releases/tag/v6.4.0). Each kdb+ process was configured to use 8 worker threads (`-s 8`).

We used the default vector length of KX Nano, which are:

      * small: 63k
      * medium: 127k
      * large: 31m
      * huge: 1000m

## Test 1: Red Hat Enterprise Linux 9 with NVMe Storage

This first test configuration utilized a high-performance NVMe storage array on a server running Red Hat Enterprise Linux (RHEL) 9.3. Following RHEL 9's [official supported](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/managing_file_systems/index) file systems, the comparison was limited to **ext4** and **XFS**.

### Test Setup

| Component	| Specification|
| --- | --- |
| Storage | * **Type**: 3.84 TB [Intel SSD D7-P5510](https://www.solidigmtechnology.com/products/data-center/d7/p5510.html) <br/>    * **Interface**: PCIe 4.0 x4, NVMe <br> * **Sequential R/W**: 6500 MB/s / 3400 MB/s <br/> * **Random Read**: 700000 IOPS (4K) </br> * **Latency**: Random Read: 82 µs (4K), Sequential Read / Write: 10 µs / 13 µs (4K) |
| CPU | Intel(R) Xeon(R) [6747P](https://www.intel.com/content/www/us/en/products/sku/241825/intel-xeon-6747p-processor-288m-cache-2-70-ghz/specifications.html) (2 sockets, 48 cores per socket, 2 threads per core) |
| Memory | 502GiB, DDR5 @ 6400 MT/s |
| OS| RHEL 9.3 (kernel 5.14.0-362.8.1.el9_3.x86_64) |

The values presented in the result tables represent throughput in MB/s, where higher figures indicate better performance. The "Ratio" column quantifies the performance of XFS relative to ext4 (e.g., a value of 2 indicates XFS was twice as fast).

### Write

We split the write results into two tables. The first table contains the "high-impact" tests and should be considered with more weight. These test are related to EOD (write, sort, applying attribute) and EOI (append) works that is often the bottleneck of ingestion.


#### Single kdb+ process:


<style type="text/css">
#T_0b602 th, #T_0b602 td, #T_5ab50 th, #T_5ab50 td, #T_4aa99 th, #T_4aa99 td, #T_d785a th, #T_d785a td, #T_d24f0 th, #T_d24f0 td, #T_b68ba th, #T_b68ba td, #T_0ed45 th, #T_0ed45 td,
#T_e976e th, #T_e976e td, #T_fb345 th, #T_fb345 td, #T_ca527 th, #T_ca527 td, #T_71f5a th, #T_71f5a td, #T_d0e63 th, #T_d0e63 td, #T_8d2d7 th, #T_8d2d7 td, #T_dd131 th, #T_dd131 td, #T_c34df th, #T_c34df td, #T_8e4e7 th, #T_8e4e7 td {
  padding: 2px 4px;
	font-size: 12px;
	min-width: 30px;
}

</style>

<style type="text/css">
#T_0b602 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_0b602_row0_col2 {
  background-color: #f2FFf2;
  color: black;
}
#T_0b602_row1_col2 {
  background-color: #f5FFf5;
  color: black;
}
#T_0b602_row2_col2 {
  background-color: #edFFed;
  color: black;
}
#T_0b602_row3_col2 {
  background-color: #f6FFf6;
  color: black;
}
#T_0b602_row4_col2 {
  background-color: #cfFFcf;
  color: black;
}
#T_0b602_row5_col2 {
  background-color: #d3FFd3;
  color: black;
}
#T_0b602_row6_col2, #T_0b602_row10_col2 {
  background-color: #c6FFc6;
  color: black;
}
#T_0b602_row7_col2 {
  background-color: #e7FFe7;
  color: black;
}
#T_0b602_row8_col2 {
  background-color: #f8FFf8;
  color: black;
}
#T_0b602_row9_col2 {
  background-color: #e5FFe5;
  color: black;
}
</style>
<table id="T_0b602">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_0b602_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_0b602_level0_col1" class="col_heading level0 col1" >XFS</th>
      <th id="T_0b602_level0_col2" class="col_heading level0 col2" >ratio</th>
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
      <th id="T_0b602_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_0b602_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_0b602_row0_col0" class="data row0 col0" >233</td>
      <td id="T_0b602_row0_col1" class="data row0 col1" >261</td>
      <td id="T_0b602_row0_col2" class="data row0 col2" >1.12</td>
    </tr>
    <tr>
      <th id="T_0b602_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_0b602_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_0b602_row1_col0" class="data row1 col0" >97</td>
      <td id="T_0b602_row1_col1" class="data row1 col1" >106</td>
      <td id="T_0b602_row1_col2" class="data row1 col2" >1.09</td>
    </tr>
    <tr>
      <th id="T_0b602_level0_row2" class="row_heading level0 row2" rowspan="7">write disk</th>
      <th id="T_0b602_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_0b602_row2_col0" class="data row2 col0" >877</td>
      <td id="T_0b602_row2_col1" class="data row2 col1" >1030</td>
      <td id="T_0b602_row2_col2" class="data row2 col2" >1.18</td>
    </tr>
    <tr>
      <th id="T_0b602_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_0b602_row3_col0" class="data row3 col0" >853</td>
      <td id="T_0b602_row3_col1" class="data row3 col1" >924</td>
      <td id="T_0b602_row3_col2" class="data row3 col2" >1.08</td>
    </tr>
    <tr>
      <th id="T_0b602_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_0b602_row4_col0" class="data row4 col0" >1304</td>
      <td id="T_0b602_row4_col1" class="data row4 col1" >2098</td>
      <td id="T_0b602_row4_col2" class="data row4 col2" >1.61</td>
    </tr>
    <tr>
      <th id="T_0b602_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_0b602_row5_col0" class="data row5 col0" >2170</td>
      <td id="T_0b602_row5_col1" class="data row5 col1" >3367</td>
      <td id="T_0b602_row5_col2" class="data row5 col2" >1.55</td>
    </tr>
    <tr>
      <th id="T_0b602_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_0b602_row6_col0" class="data row6 col0" >729</td>
      <td id="T_0b602_row6_col1" class="data row6 col1" >1309</td>
      <td id="T_0b602_row6_col2" class="data row6 col2" >1.80</td>
    </tr>
    <tr>
      <th id="T_0b602_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_0b602_row7_col0" class="data row7 col0" >380</td>
      <td id="T_0b602_row7_col1" class="data row7 col1" >474</td>
      <td id="T_0b602_row7_col2" class="data row7 col2" >1.25</td>
    </tr>
    <tr>
      <th id="T_0b602_level1_row8" class="row_heading level1 row8" >write sym large</th>
      <td id="T_0b602_row8_col0" class="data row8 col0" >862</td>
      <td id="T_0b602_row8_col1" class="data row8 col1" >913</td>
      <td id="T_0b602_row8_col2" class="data row8 col2" >1.06</td>
    </tr>
    <tr>
      <th id="T_0b602_level0_row9" class="row_heading level0 row9" >GEOMETRIC MEAN</th>
      <th id="T_0b602_level1_row9" class="row_heading level1 row9" ></th>
      <td id="T_0b602_row9_col0" class="data row9 col0" >608</td>
      <td id="T_0b602_row9_col1" class="data row9 col1" >779</td>
      <td id="T_0b602_row9_col2" class="data row9 col2" >1.28</td>
    </tr>
    <tr>
      <th id="T_0b602_level0_row10" class="row_heading level0 row10" >MAX RATIO</th>
      <th id="T_0b602_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_0b602_row10_col0" class="data row10 col0" >2170</td>
      <td id="T_0b602_row10_col1" class="data row10 col1" >3367</td>
      <td id="T_0b602_row10_col2" class="data row10 col2" >1.80</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS is almost always faster than ext4. **In critical tests, the advantage is almost 30%** on average with a **maximal difference 80%**.

The performance of the less critical write operations are below.




<style type="text/css">
#T_5ab50 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_5ab50_row0_col2, #T_5ab50_row13_col2 {
  background-color: #d2FFd2;
  color: black;
}
#T_5ab50_row1_col2 {
  background-color: #d5FFd5;
  color: black;
}
#T_5ab50_row2_col2 {
  background-color: #f0FFf0;
  color: black;
}
#T_5ab50_row3_col2 {
  background-color: #ebFFeb;
  color: black;
}
#T_5ab50_row4_col2 {
  background-color: #d9FFd9;
  color: black;
}
#T_5ab50_row5_col2 {
  background-color: #FFfbfb;
  color: black;
}
#T_5ab50_row6_col2, #T_5ab50_row7_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_5ab50_row8_col2 {
  background-color: #f6FFf6;
  color: black;
}
#T_5ab50_row9_col2 {
  background-color: #edFFed;
  color: black;
}
#T_5ab50_row10_col2 {
  background-color: #FF2121;
  color: white;
}
#T_5ab50_row11_col2 {
  background-color: #FFebeb;
  color: black;
}
#T_5ab50_row12_col2 {
  background-color: #FFc7c7;
  color: black;
}
</style>
<table id="T_5ab50">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_5ab50_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_5ab50_level0_col1" class="col_heading level0 col1" >XFS</th>
      <th id="T_5ab50_level0_col2" class="col_heading level0 col2" >ratio</th>
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
      <th id="T_5ab50_level0_row0" class="row_heading level0 row0" rowspan="12">write disk</th>
      <th id="T_5ab50_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_5ab50_row0_col0" class="data row0 col0" >482</td>
      <td id="T_5ab50_row0_col1" class="data row0 col1" >750</td>
      <td id="T_5ab50_row0_col2" class="data row0 col2" >1.55</td>
    </tr>
    <tr>
      <th id="T_5ab50_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_5ab50_row1_col0" class="data row1 col0" >366</td>
      <td id="T_5ab50_row1_col1" class="data row1 col1" >554</td>
      <td id="T_5ab50_row1_col2" class="data row1 col2" >1.51</td>
    </tr>
    <tr>
      <th id="T_5ab50_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_5ab50_row2_col0" class="data row2 col0" >813</td>
      <td id="T_5ab50_row2_col1" class="data row2 col1" >931</td>
      <td id="T_5ab50_row2_col2" class="data row2 col2" >1.14</td>
    </tr>
    <tr>
      <th id="T_5ab50_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_5ab50_row3_col0" class="data row3 col0" >211</td>
      <td id="T_5ab50_row3_col1" class="data row3 col1" >253</td>
      <td id="T_5ab50_row3_col2" class="data row3 col2" >1.20</td>
    </tr>
    <tr>
      <th id="T_5ab50_level1_row4" class="row_heading level1 row4" >open replace tiny, sync once</th>
      <td id="T_5ab50_row4_col0" class="data row4 col0" >96</td>
      <td id="T_5ab50_row4_col1" class="data row4 col1" >139</td>
      <td id="T_5ab50_row4_col2" class="data row4 col2" >1.45</td>
    </tr>
    <tr>
      <th id="T_5ab50_level1_row5" class="row_heading level1 row5" >sync float large</th>
      <td id="T_5ab50_row5_col0" class="data row5 col0" >145828</td>
      <td id="T_5ab50_row5_col1" class="data row5 col1" >143720</td>
      <td id="T_5ab50_row5_col2" class="data row5 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_5ab50_level1_row6" class="row_heading level1 row6" >sync int huge</th>
      <td id="T_5ab50_row6_col0" class="data row6 col0" >77110</td>
      <td id="T_5ab50_row6_col1" class="data row6 col1" >78917</td>
      <td id="T_5ab50_row6_col2" class="data row6 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_5ab50_level1_row7" class="row_heading level1 row7" >sync int medium</th>
      <td id="T_5ab50_row7_col0" class="data row7 col0" >40090</td>
      <td id="T_5ab50_row7_col1" class="data row7 col1" >40977</td>
      <td id="T_5ab50_row7_col2" class="data row7 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_5ab50_level1_row8" class="row_heading level1 row8" >sync int small</th>
      <td id="T_5ab50_row8_col0" class="data row8 col0" >6244</td>
      <td id="T_5ab50_row8_col1" class="data row8 col1" >6730</td>
      <td id="T_5ab50_row8_col2" class="data row8 col2" >1.08</td>
    </tr>
    <tr>
      <th id="T_5ab50_level1_row9" class="row_heading level1 row9" >sync sym large</th>
      <td id="T_5ab50_row9_col0" class="data row9 col0" >180587</td>
      <td id="T_5ab50_row9_col1" class="data row9 col1" >211642</td>
      <td id="T_5ab50_row9_col2" class="data row9 col2" >1.17</td>
    </tr>
    <tr>
      <th id="T_5ab50_level1_row10" class="row_heading level1 row10" >sync table after phash</th>
      <td id="T_5ab50_row10_col0" class="data row10 col0" >30758180</td>
      <td id="T_5ab50_row10_col1" class="data row10 col1" >177163</td>
      <td id="T_5ab50_row10_col2" class="data row10 col2" >0.01</td>
    </tr>
    <tr>
      <th id="T_5ab50_level1_row11" class="row_heading level1 row11" >sync table after sort</th>
      <td id="T_5ab50_row11_col0" class="data row11 col0" >59348750</td>
      <td id="T_5ab50_row11_col1" class="data row11 col1" >54142270</td>
      <td id="T_5ab50_row11_col2" class="data row11 col2" >0.91</td>
    </tr>
    <tr>
      <th id="T_5ab50_level0_row12" class="row_heading level0 row12" >GEOMETRIC MEAN</th>
      <th id="T_5ab50_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_5ab50_row12_col0" class="data row12 col0" >19311</td>
      <td id="T_5ab50_row12_col1" class="data row12 col1" >14500</td>
      <td id="T_5ab50_row12_col2" class="data row12 col2" >0.75</td>
    </tr>
    <tr>
      <th id="T_5ab50_level0_row13" class="row_heading level0 row13" >MAX RATIO</th>
      <th id="T_5ab50_level1_row13" class="row_heading level1 row13" ></th>
      <td id="T_5ab50_row13_col0" class="data row13 col0" >59348750</td>
      <td id="T_5ab50_row13_col1" class="data row13 col1" >54142270</td>
      <td id="T_5ab50_row13_col2" class="data row13 col2" >1.55</td>
    </tr>
  </tbody>
</table>




#### 64 kdb+ processes:




<style type="text/css">
#T_4aa99 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_4aa99_row0_col2, #T_4aa99_row10_col2 {
  background-color: #76FF76;
  color: black;
}
#T_4aa99_row1_col2 {
  background-color: #99FF99;
  color: black;
}
#T_4aa99_row2_col2 {
  background-color: #dcFFdc;
  color: black;
}
#T_4aa99_row3_col2 {
  background-color: #f2FFf2;
  color: black;
}
#T_4aa99_row4_col2 {
  background-color: #7cFF7c;
  color: black;
}
#T_4aa99_row5_col2 {
  background-color: #FFecec;
  color: black;
}
#T_4aa99_row6_col2 {
  background-color: #79FF79;
  color: black;
}
#T_4aa99_row7_col2 {
  background-color: #96FF96;
  color: black;
}
#T_4aa99_row8_col2 {
  background-color: #8eFF8e;
  color: black;
}
#T_4aa99_row9_col2 {
  background-color: #a1FFa1;
  color: black;
}
</style>
<table id="T_4aa99">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_4aa99_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_4aa99_level0_col1" class="col_heading level0 col1" >XFS</th>
      <th id="T_4aa99_level0_col2" class="col_heading level0 col2" >ratio</th>
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
      <th id="T_4aa99_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_4aa99_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_4aa99_row0_col0" class="data row0 col0" >1948</td>
      <td id="T_4aa99_row0_col1" class="data row0 col1" >12834</td>
      <td id="T_4aa99_row0_col2" class="data row0 col2" >6.59</td>
    </tr>
    <tr>
      <th id="T_4aa99_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_4aa99_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_4aa99_row1_col0" class="data row1 col0" >914</td>
      <td id="T_4aa99_row1_col1" class="data row1 col1" >3059</td>
      <td id="T_4aa99_row1_col2" class="data row1 col2" >3.35</td>
    </tr>
    <tr>
      <th id="T_4aa99_level0_row2" class="row_heading level0 row2" rowspan="7">write disk</th>
      <th id="T_4aa99_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_4aa99_row2_col0" class="data row2 col0" >1378</td>
      <td id="T_4aa99_row2_col1" class="data row2 col1" >1933</td>
      <td id="T_4aa99_row2_col2" class="data row2 col2" >1.40</td>
    </tr>
    <tr>
      <th id="T_4aa99_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_4aa99_row3_col0" class="data row3 col0" >2065</td>
      <td id="T_4aa99_row3_col1" class="data row3 col1" >2309</td>
      <td id="T_4aa99_row3_col2" class="data row3 col2" >1.12</td>
    </tr>
    <tr>
      <th id="T_4aa99_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_4aa99_row4_col0" class="data row4 col0" >10817</td>
      <td id="T_4aa99_row4_col1" class="data row4 col1" >63140</td>
      <td id="T_4aa99_row4_col2" class="data row4 col2" >5.84</td>
    </tr>
    <tr>
      <th id="T_4aa99_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_4aa99_row5_col0" class="data row5 col0" >2665</td>
      <td id="T_4aa99_row5_col1" class="data row5 col1" >2449</td>
      <td id="T_4aa99_row5_col2" class="data row5 col2" >0.92</td>
    </tr>
    <tr>
      <th id="T_4aa99_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_4aa99_row6_col0" class="data row6 col0" >6453</td>
      <td id="T_4aa99_row6_col1" class="data row6 col1" >40098</td>
      <td id="T_4aa99_row6_col2" class="data row6 col2" >6.21</td>
    </tr>
    <tr>
      <th id="T_4aa99_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_4aa99_row7_col0" class="data row7 col0" >4931</td>
      <td id="T_4aa99_row7_col1" class="data row7 col1" >17609</td>
      <td id="T_4aa99_row7_col2" class="data row7 col2" >3.57</td>
    </tr>
    <tr>
      <th id="T_4aa99_level1_row8" class="row_heading level1 row8" >write sym large</th>
      <td id="T_4aa99_row8_col0" class="data row8 col0" >14279</td>
      <td id="T_4aa99_row8_col1" class="data row8 col1" >57674</td>
      <td id="T_4aa99_row8_col2" class="data row8 col2" >4.04</td>
    </tr>
    <tr>
      <th id="T_4aa99_level0_row9" class="row_heading level0 row9" >GEOMETRIC MEAN</th>
      <th id="T_4aa99_level1_row9" class="row_heading level1 row9" ></th>
      <td id="T_4aa99_row9_col0" class="data row9 col0" >3434</td>
      <td id="T_4aa99_row9_col1" class="data row9 col1" >10110</td>
      <td id="T_4aa99_row9_col2" class="data row9 col2" >2.94</td>
    </tr>
    <tr>
      <th id="T_4aa99_level0_row10" class="row_heading level0 row10" >MAX RATIO</th>
      <th id="T_4aa99_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_4aa99_row10_col0" class="data row10 col0" >14279</td>
      <td id="T_4aa99_row10_col1" class="data row10 col1" >63140</td>
      <td id="T_4aa99_row10_col2" class="data row10 col2" >6.59</td>
    </tr>
  </tbody>
</table>




**Observation**: The results show that **XFS consistently and significantly outperformed ext4 in write-intensive operations**. In critical ingestion and EOD tasks, write throughput on XFS was on average **3 times higher**. This advantage peaked in specific operations, such as applying the `p#` attribute, where XFS was a remarkable 6.6x faster than ext4.

The performance of the less critical write operations are below.




<style type="text/css">
#T_d785a th.col_heading.level0 {
  font-size: 1.5em;
}
#T_d785a_row0_col2 {
  background-color: #FFdcdc;
  color: black;
}
#T_d785a_row1_col2 {
  background-color: #eeFFee;
  color: black;
}
#T_d785a_row2_col2 {
  background-color: #FFf7f7;
  color: black;
}
#T_d785a_row3_col2, #T_d785a_row13_col2 {
  background-color: #c7FFc7;
  color: black;
}
#T_d785a_row4_col2 {
  background-color: #FF9292;
  color: black;
}
#T_d785a_row5_col2 {
  background-color: #FFfcfc;
  color: black;
}
#T_d785a_row6_col2 {
  background-color: #FFfefe;
  color: black;
}
#T_d785a_row7_col2 {
  background-color: #dcFFdc;
  color: black;
}
#T_d785a_row8_col2 {
  background-color: #f7FFf7;
  color: black;
}
#T_d785a_row9_col2 {
  background-color: #FFf9f9;
  color: black;
}
#T_d785a_row10_col2 {
  background-color: #FF2020;
  color: white;
}
#T_d785a_row11_col2 {
  background-color: #FF7474;
  color: white;
}
#T_d785a_row12_col2 {
  background-color: #FF9191;
  color: black;
}
</style>
<table id="T_d785a">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_d785a_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_d785a_level0_col1" class="col_heading level0 col1" >XFS</th>
      <th id="T_d785a_level0_col2" class="col_heading level0 col2" >ratio</th>
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
      <th id="T_d785a_level0_row0" class="row_heading level0 row0" rowspan="12">write disk</th>
      <th id="T_d785a_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_d785a_row0_col0" class="data row0 col0" >1955</td>
      <td id="T_d785a_row0_col1" class="data row0 col1" >1657</td>
      <td id="T_d785a_row0_col2" class="data row0 col2" >0.85</td>
    </tr>
    <tr>
      <th id="T_d785a_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_d785a_row1_col0" class="data row1 col0" >2083</td>
      <td id="T_d785a_row1_col1" class="data row1 col1" >2429</td>
      <td id="T_d785a_row1_col2" class="data row1 col2" >1.17</td>
    </tr>
    <tr>
      <th id="T_d785a_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_d785a_row2_col0" class="data row2 col0" >1432</td>
      <td id="T_d785a_row2_col1" class="data row2 col1" >1384</td>
      <td id="T_d785a_row2_col2" class="data row2 col2" >0.97</td>
    </tr>
    <tr>
      <th id="T_d785a_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_d785a_row3_col0" class="data row3 col0" >1361</td>
      <td id="T_d785a_row3_col1" class="data row3 col1" >2407</td>
      <td id="T_d785a_row3_col2" class="data row3 col2" >1.77</td>
    </tr>
    <tr>
      <th id="T_d785a_level1_row4" class="row_heading level1 row4" >open replace tiny, sync once</th>
      <td id="T_d785a_row4_col0" class="data row4 col0" >1035</td>
      <td id="T_d785a_row4_col1" class="data row4 col1" >531</td>
      <td id="T_d785a_row4_col2" class="data row4 col2" >0.51</td>
    </tr>
    <tr>
      <th id="T_d785a_level1_row5" class="row_heading level1 row5" >sync float large</th>
      <td id="T_d785a_row5_col0" class="data row5 col0" >93039</td>
      <td id="T_d785a_row5_col1" class="data row5 col1" >91966</td>
      <td id="T_d785a_row5_col2" class="data row5 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_d785a_level1_row6" class="row_heading level1 row6" >sync int huge</th>
      <td id="T_d785a_row6_col0" class="data row6 col0" >217269</td>
      <td id="T_d785a_row6_col1" class="data row6 col1" >216302</td>
      <td id="T_d785a_row6_col2" class="data row6 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_d785a_level1_row7" class="row_heading level1 row7" >sync int medium</th>
      <td id="T_d785a_row7_col0" class="data row7 col0" >127043</td>
      <td id="T_d785a_row7_col1" class="data row7 col1" >177815</td>
      <td id="T_d785a_row7_col2" class="data row7 col2" >1.40</td>
    </tr>
    <tr>
      <th id="T_d785a_level1_row8" class="row_heading level1 row8" >sync int small</th>
      <td id="T_d785a_row8_col0" class="data row8 col0" >105078</td>
      <td id="T_d785a_row8_col1" class="data row8 col1" >112098</td>
      <td id="T_d785a_row8_col2" class="data row8 col2" >1.07</td>
    </tr>
    <tr>
      <th id="T_d785a_level1_row9" class="row_heading level1 row9" >sync sym large</th>
      <td id="T_d785a_row9_col0" class="data row9 col0" >140796</td>
      <td id="T_d785a_row9_col1" class="data row9 col1" >137169</td>
      <td id="T_d785a_row9_col2" class="data row9 col2" >0.97</td>
    </tr>
    <tr>
      <th id="T_d785a_level1_row10" class="row_heading level1 row10" >sync table after phash</th>
      <td id="T_d785a_row10_col0" class="data row10 col0" >197769600</td>
      <td id="T_d785a_row10_col1" class="data row10 col1" >132748</td>
      <td id="T_d785a_row10_col2" class="data row10 col2" >0.00</td>
    </tr>
    <tr>
      <th id="T_d785a_level1_row11" class="row_heading level1 row11" >sync table after sort</th>
      <td id="T_d785a_row11_col0" class="data row11 col0" >423427500</td>
      <td id="T_d785a_row11_col1" class="data row11 col1" >161152200</td>
      <td id="T_d785a_row11_col2" class="data row11 col2" >0.38</td>
    </tr>
    <tr>
      <th id="T_d785a_level0_row12" class="row_heading level0 row12" >GEOMETRIC MEAN</th>
      <th id="T_d785a_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_d785a_row12_col0" class="data row12 col0" >73810</td>
      <td id="T_d785a_row12_col1" class="data row12 col1" >37714</td>
      <td id="T_d785a_row12_col2" class="data row12 col2" >0.51</td>
    </tr>
    <tr>
      <th id="T_d785a_level0_row13" class="row_heading level0 row13" >MAX RATIO</th>
      <th id="T_d785a_level1_row13" class="row_heading level1 row13" ></th>
      <td id="T_d785a_row13_col0" class="data row13 col0" >423427500</td>
      <td id="T_d785a_row13_col1" class="data row13 col1" >161152200</td>
      <td id="T_d785a_row13_col2" class="data row13 col2" >1.77</td>
    </tr>
  </tbody>
</table>




There were two minor test cases where ext4 was faster. The first, "`replace tiny`" `(.[ftinyReplace;();:;tinyVec]`), involves overwriting a very small vector. This discrepancy is considered negligible, as the operation is not representative of typical, performance-critical kdb+ workloads. The second, "`sync table after phash/sort`", also showed ext4 ahead. However, the absolute time difference was minimal, making its impact on overall application performance insignificant in most practical scenarios.

### Read

We divide read tests into two categories depending on the source of the data, disk vs page cache (memory).

#### Single kdb+ process:




<style type="text/css">
#T_d24f0 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_d24f0_row0_col2 {
  background-color: #FFfbfb;
  color: black;
}
#T_d24f0_row1_col2, #T_d24f0_row2_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_d24f0_row3_col2 {
  background-color: #f6FFf6;
  color: black;
}
#T_d24f0_row4_col2 {
  background-color: #f8FFf8;
  color: black;
}
#T_d24f0_row5_col2 {
  background-color: #f5FFf5;
  color: black;
}
#T_d24f0_row6_col2 {
  background-color: #FFfefe;
  color: black;
}
#T_d24f0_row7_col2, #T_d24f0_row12_col2 {
  background-color: #acFFac;
  color: black;
}
#T_d24f0_row8_col2 {
  background-color: #baFFba;
  color: black;
}
#T_d24f0_row9_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_d24f0_row10_col2 {
  background-color: #ebFFeb;
  color: black;
}
#T_d24f0_row11_col2 {
  background-color: #eaFFea;
  color: black;
}
</style>
<table id="T_d24f0">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_d24f0_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_d24f0_level0_col1" class="col_heading level0 col1" >XFS</th>
      <th id="T_d24f0_level0_col2" class="col_heading level0 col2" >ratio</th>
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
      <th id="T_d24f0_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_d24f0_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_d24f0_row0_col0" class="data row0 col0" >600</td>
      <td id="T_d24f0_row0_col1" class="data row0 col1" >592</td>
      <td id="T_d24f0_row0_col2" class="data row0 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_d24f0_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_d24f0_row1_col0" class="data row1 col0" >19</td>
      <td id="T_d24f0_row1_col1" class="data row1 col1" >19</td>
      <td id="T_d24f0_row1_col2" class="data row1 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_d24f0_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_d24f0_row2_col0" class="data row2 col0" >196</td>
      <td id="T_d24f0_row2_col1" class="data row2 col1" >198</td>
      <td id="T_d24f0_row2_col2" class="data row2 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_d24f0_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_d24f0_row3_col0" class="data row3 col0" >557</td>
      <td id="T_d24f0_row3_col1" class="data row3 col1" >601</td>
      <td id="T_d24f0_row3_col2" class="data row3 col2" >1.08</td>
    </tr>
    <tr>
      <th id="T_d24f0_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_d24f0_row4_col0" class="data row4 col0" >19</td>
      <td id="T_d24f0_row4_col1" class="data row4 col1" >20</td>
      <td id="T_d24f0_row4_col2" class="data row4 col2" >1.06</td>
    </tr>
    <tr>
      <th id="T_d24f0_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_d24f0_row5_col0" class="data row5 col0" >188</td>
      <td id="T_d24f0_row5_col1" class="data row5 col1" >204</td>
      <td id="T_d24f0_row5_col2" class="data row5 col2" >1.09</td>
    </tr>
    <tr>
      <th id="T_d24f0_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_d24f0_row6_col0" class="data row6 col0" >698</td>
      <td id="T_d24f0_row6_col1" class="data row6 col1" >697</td>
      <td id="T_d24f0_row6_col2" class="data row6 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_d24f0_level0_row7" class="row_heading level0 row7" rowspan="4">read disk write mem</th>
      <th id="T_d24f0_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_d24f0_row7_col0" class="data row7 col0" >799</td>
      <td id="T_d24f0_row7_col1" class="data row7 col1" >2012</td>
      <td id="T_d24f0_row7_col2" class="data row7 col2" >2.52</td>
    </tr>
    <tr>
      <th id="T_d24f0_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_d24f0_row8_col0" class="data row8 col0" >961</td>
      <td id="T_d24f0_row8_col1" class="data row8 col1" >2004</td>
      <td id="T_d24f0_row8_col2" class="data row8 col2" >2.09</td>
    </tr>
    <tr>
      <th id="T_d24f0_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_d24f0_row9_col0" class="data row9 col0" >645</td>
      <td id="T_d24f0_row9_col1" class="data row9 col1" >658</td>
      <td id="T_d24f0_row9_col2" class="data row9 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_d24f0_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_d24f0_row10_col0" class="data row10 col0" >246</td>
      <td id="T_d24f0_row10_col1" class="data row10 col1" >295</td>
      <td id="T_d24f0_row10_col2" class="data row10 col2" >1.20</td>
    </tr>
    <tr>
      <th id="T_d24f0_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_d24f0_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_d24f0_row11_col0" class="data row11 col0" >261</td>
      <td id="T_d24f0_row11_col1" class="data row11 col1" >315</td>
      <td id="T_d24f0_row11_col2" class="data row11 col2" >1.21</td>
    </tr>
    <tr>
      <th id="T_d24f0_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_d24f0_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_d24f0_row12_col0" class="data row12 col0" >961</td>
      <td id="T_d24f0_row12_col1" class="data row12 col1" >2012</td>
      <td id="T_d24f0_row12_col2" class="data row12 col2" >2.52</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS reads the data faster from disk sequentially than ext4. Apart from this, the differences are negligible.




<style type="text/css">
#T_b68ba th.col_heading.level0 {
  font-size: 1.5em;
}
#T_b68ba_row0_col2 {
  background-color: #fcFFfc;
  color: black;
}
#T_b68ba_row1_col2, #T_b68ba_row12_col2 {
  background-color: #f8FFf8;
  color: black;
}
#T_b68ba_row2_col2 {
  background-color: #FFf9f9;
  color: black;
}
#T_b68ba_row3_col2, #T_b68ba_row5_col2, #T_b68ba_row8_col2 {
  background-color: #FFfefe;
  color: black;
}
#T_b68ba_row4_col2 {
  background-color: #FFfdfd;
  color: black;
}
#T_b68ba_row6_col2 {
  background-color: #fdFFfd;
  color: black;
}
#T_b68ba_row7_col2 {
  background-color: #FFfcfc;
  color: black;
}
#T_b68ba_row9_col2 {
  background-color: #FFf4f4;
  color: black;
}
#T_b68ba_row10_col2 {
  background-color: #f9FFf9;
  color: black;
}
#T_b68ba_row11_col2 {
  background-color: #feFFfe;
  color: black;
}
</style>
<table id="T_b68ba">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_b68ba_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_b68ba_level0_col1" class="col_heading level0 col1" >XFS</th>
      <th id="T_b68ba_level0_col2" class="col_heading level0 col2" >ratio</th>
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
      <th id="T_b68ba_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_b68ba_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_b68ba_row0_col0" class="data row0 col0" >2465</td>
      <td id="T_b68ba_row0_col1" class="data row0 col1" >2519</td>
      <td id="T_b68ba_row0_col2" class="data row0 col2" >1.02</td>
    </tr>
    <tr>
      <th id="T_b68ba_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_b68ba_row1_col0" class="data row1 col0" >249</td>
      <td id="T_b68ba_row1_col1" class="data row1 col1" >264</td>
      <td id="T_b68ba_row1_col2" class="data row1 col2" >1.06</td>
    </tr>
    <tr>
      <th id="T_b68ba_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_b68ba_row2_col0" class="data row2 col0" >1755</td>
      <td id="T_b68ba_row2_col1" class="data row2 col1" >1713</td>
      <td id="T_b68ba_row2_col2" class="data row2 col2" >0.98</td>
    </tr>
    <tr>
      <th id="T_b68ba_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_b68ba_row3_col0" class="data row3 col0" >3024</td>
      <td id="T_b68ba_row3_col1" class="data row3 col1" >3021</td>
      <td id="T_b68ba_row3_col2" class="data row3 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_b68ba_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_b68ba_row4_col0" class="data row4 col0" >1255</td>
      <td id="T_b68ba_row4_col1" class="data row4 col1" >1245</td>
      <td id="T_b68ba_row4_col2" class="data row4 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_b68ba_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_b68ba_row5_col0" class="data row5 col0" >3011</td>
      <td id="T_b68ba_row5_col1" class="data row5 col1" >3003</td>
      <td id="T_b68ba_row5_col2" class="data row5 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_b68ba_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_b68ba_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_b68ba_row6_col0" class="data row6 col0" >2520</td>
      <td id="T_b68ba_row6_col1" class="data row6 col1" >2544</td>
      <td id="T_b68ba_row6_col2" class="data row6 col2" >1.01</td>
    </tr>
    <tr>
      <th id="T_b68ba_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_b68ba_row7_col0" class="data row7 col0" >15071</td>
      <td id="T_b68ba_row7_col1" class="data row7 col1" >14883</td>
      <td id="T_b68ba_row7_col2" class="data row7 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_b68ba_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_b68ba_row8_col0" class="data row8 col0" >33874</td>
      <td id="T_b68ba_row8_col1" class="data row8 col1" >33797</td>
      <td id="T_b68ba_row8_col2" class="data row8 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_b68ba_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_b68ba_row9_col0" class="data row9 col0" >8176</td>
      <td id="T_b68ba_row9_col1" class="data row9 col1" >7801</td>
      <td id="T_b68ba_row9_col2" class="data row9 col2" >0.95</td>
    </tr>
    <tr>
      <th id="T_b68ba_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_b68ba_row10_col0" class="data row10 col0" >2047</td>
      <td id="T_b68ba_row10_col1" class="data row10 col1" >2148</td>
      <td id="T_b68ba_row10_col2" class="data row10 col2" >1.05</td>
    </tr>
    <tr>
      <th id="T_b68ba_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_b68ba_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_b68ba_row11_col0" class="data row11 col0" >3112</td>
      <td id="T_b68ba_row11_col1" class="data row11 col1" >3123</td>
      <td id="T_b68ba_row11_col2" class="data row11 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_b68ba_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_b68ba_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_b68ba_row12_col0" class="data row12 col0" >33874</td>
      <td id="T_b68ba_row12_col1" class="data row12 col1" >33797</td>
      <td id="T_b68ba_row12_col2" class="data row12 col2" >1.06</td>
    </tr>
  </tbody>
</table>




**Observation**: There is no performance difference between XFS and ext4 with a single kdb+ reader if the data is coming from page cache.

#### 64 kdb+ processes:




<style type="text/css">
#T_0ed45 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_0ed45_row0_col2, #T_0ed45_row3_col2 {
  background-color: #FFfefe;
  color: black;
}
#T_0ed45_row1_col2 {
  background-color: #FFf3f3;
  color: black;
}
#T_0ed45_row2_col2, #T_0ed45_row4_col2, #T_0ed45_row5_col2 {
  background-color: #FFfdfd;
  color: black;
}
#T_0ed45_row6_col2, #T_0ed45_row12_col2 {
  background-color: #52FF52;
  color: black;
}
#T_0ed45_row7_col2 {
  background-color: #FFafaf;
  color: black;
}
#T_0ed45_row8_col2 {
  background-color: #FFf6f6;
  color: black;
}
#T_0ed45_row9_col2 {
  background-color: #FF7171;
  color: white;
}
#T_0ed45_row10_col2 {
  background-color: #FF4e4e;
  color: white;
}
#T_0ed45_row11_col2 {
  background-color: #FFfcfc;
  color: black;
}
</style>
<table id="T_0ed45">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_0ed45_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_0ed45_level0_col1" class="col_heading level0 col1" >XFS</th>
      <th id="T_0ed45_level0_col2" class="col_heading level0 col2" >ratio</th>
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
      <th id="T_0ed45_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_0ed45_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_0ed45_row0_col0" class="data row0 col0" >2819</td>
      <td id="T_0ed45_row0_col1" class="data row0 col1" >2812</td>
      <td id="T_0ed45_row0_col2" class="data row0 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_0ed45_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_0ed45_row1_col0" class="data row1 col0" >544</td>
      <td id="T_0ed45_row1_col1" class="data row1 col1" >515</td>
      <td id="T_0ed45_row1_col2" class="data row1 col2" >0.95</td>
    </tr>
    <tr>
      <th id="T_0ed45_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_0ed45_row2_col0" class="data row2 col0" >1075</td>
      <td id="T_0ed45_row2_col1" class="data row2 col1" >1068</td>
      <td id="T_0ed45_row2_col2" class="data row2 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_0ed45_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_0ed45_row3_col0" class="data row3 col0" >2784</td>
      <td id="T_0ed45_row3_col1" class="data row3 col1" >2779</td>
      <td id="T_0ed45_row3_col2" class="data row3 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_0ed45_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_0ed45_row4_col0" class="data row4 col0" >546</td>
      <td id="T_0ed45_row4_col1" class="data row4 col1" >543</td>
      <td id="T_0ed45_row4_col2" class="data row4 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_0ed45_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_0ed45_row5_col0" class="data row5 col0" >1070</td>
      <td id="T_0ed45_row5_col1" class="data row5 col1" >1065</td>
      <td id="T_0ed45_row5_col2" class="data row5 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_0ed45_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_0ed45_row6_col0" class="data row6 col0" >5067</td>
      <td id="T_0ed45_row6_col1" class="data row6 col1" >100438</td>
      <td id="T_0ed45_row6_col2" class="data row6 col2" >19.82</td>
    </tr>
    <tr>
      <th id="T_0ed45_level0_row7" class="row_heading level0 row7" rowspan="4">read disk write mem</th>
      <th id="T_0ed45_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_0ed45_row7_col0" class="data row7 col0" >3292</td>
      <td id="T_0ed45_row7_col1" class="data row7 col1" >2124</td>
      <td id="T_0ed45_row7_col2" class="data row7 col2" >0.65</td>
    </tr>
    <tr>
      <th id="T_0ed45_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_0ed45_row8_col0" class="data row8 col0" >3300</td>
      <td id="T_0ed45_row8_col1" class="data row8 col1" >3180</td>
      <td id="T_0ed45_row8_col2" class="data row8 col2" >0.96</td>
    </tr>
    <tr>
      <th id="T_0ed45_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_0ed45_row9_col0" class="data row9 col0" >5910</td>
      <td id="T_0ed45_row9_col1" class="data row9 col1" >2164</td>
      <td id="T_0ed45_row9_col2" class="data row9 col2" >0.37</td>
    </tr>
    <tr>
      <th id="T_0ed45_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_0ed45_row10_col0" class="data row10 col0" >6923</td>
      <td id="T_0ed45_row10_col1" class="data row10 col1" >1456</td>
      <td id="T_0ed45_row10_col2" class="data row10 col2" >0.21</td>
    </tr>
    <tr>
      <th id="T_0ed45_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_0ed45_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_0ed45_row11_col0" class="data row11 col0" >2207</td>
      <td id="T_0ed45_row11_col1" class="data row11 col1" >2181</td>
      <td id="T_0ed45_row11_col2" class="data row11 col2" >0.99</td>
    </tr>
    <tr>
      <th id="T_0ed45_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_0ed45_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_0ed45_row12_col0" class="data row12 col0" >6923</td>
      <td id="T_0ed45_row12_col1" class="data row12 col1" >100438</td>
      <td id="T_0ed45_row12_col2" class="data row12 col2" >19.82</td>
    </tr>
  </tbody>
</table>




**Observation**: Despite the edge of XFS with a single reader, ext4 outperforms XFS sequential read if multiple kdb+ processes are reading various data in parallel. This scenario is common in a pool of HDBs where multiple concurrent queries with non-selective filters result in numerous parallel sequential reads from disk.




<style type="text/css">
#T_e976e th.col_heading.level0 {
  font-size: 1.5em;
}
#T_e976e_row0_col2 {
  background-color: #FFaeae;
  color: black;
}
#T_e976e_row1_col2 {
  background-color: #FFa9a9;
  color: black;
}
#T_e976e_row2_col2 {
  background-color: #FFa1a1;
  color: black;
}
#T_e976e_row3_col2 {
  background-color: #FFf8f8;
  color: black;
}
#T_e976e_row4_col2, #T_e976e_row10_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_e976e_row5_col2 {
  background-color: #FFf6f6;
  color: black;
}
#T_e976e_row6_col2, #T_e976e_row12_col2 {
  background-color: #f3FFf3;
  color: black;
}
#T_e976e_row7_col2 {
  background-color: #FFf4f4;
  color: black;
}
#T_e976e_row8_col2 {
  background-color: #FFfefe;
  color: black;
}
#T_e976e_row9_col2 {
  background-color: #FFf1f1;
  color: black;
}
#T_e976e_row11_col2 {
  background-color: #FFe1e1;
  color: black;
}
</style>
<table id="T_e976e">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_e976e_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_e976e_level0_col1" class="col_heading level0 col1" >XFS</th>
      <th id="T_e976e_level0_col2" class="col_heading level0 col2" >ratio</th>
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
      <th id="T_e976e_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_e976e_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_e976e_row0_col0" class="data row0 col0" >41860</td>
      <td id="T_e976e_row0_col1" class="data row0 col1" >26736</td>
      <td id="T_e976e_row0_col2" class="data row0 col2" >0.64</td>
    </tr>
    <tr>
      <th id="T_e976e_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_e976e_row1_col0" class="data row1 col0" >5458</td>
      <td id="T_e976e_row1_col1" class="data row1 col1" >3370</td>
      <td id="T_e976e_row1_col2" class="data row1 col2" >0.62</td>
    </tr>
    <tr>
      <th id="T_e976e_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_e976e_row2_col0" class="data row2 col0" >22897</td>
      <td id="T_e976e_row2_col1" class="data row2 col1" >13300</td>
      <td id="T_e976e_row2_col2" class="data row2 col2" >0.58</td>
    </tr>
    <tr>
      <th id="T_e976e_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_e976e_row3_col0" class="data row3 col0" >127773</td>
      <td id="T_e976e_row3_col1" class="data row3 col1" >124141</td>
      <td id="T_e976e_row3_col2" class="data row3 col2" >0.97</td>
    </tr>
    <tr>
      <th id="T_e976e_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_e976e_row4_col0" class="data row4 col0" >92293</td>
      <td id="T_e976e_row4_col1" class="data row4 col1" >92490</td>
      <td id="T_e976e_row4_col2" class="data row4 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_e976e_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_e976e_row5_col0" class="data row5 col0" >162621</td>
      <td id="T_e976e_row5_col1" class="data row5 col1" >156725</td>
      <td id="T_e976e_row5_col2" class="data row5 col2" >0.96</td>
    </tr>
    <tr>
      <th id="T_e976e_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_e976e_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_e976e_row6_col0" class="data row6 col0" >24988</td>
      <td id="T_e976e_row6_col1" class="data row6 col1" >27670</td>
      <td id="T_e976e_row6_col2" class="data row6 col2" >1.11</td>
    </tr>
    <tr>
      <th id="T_e976e_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_e976e_row7_col0" class="data row7 col0" >1073493</td>
      <td id="T_e976e_row7_col1" class="data row7 col1" >1022969</td>
      <td id="T_e976e_row7_col2" class="data row7 col2" >0.95</td>
    </tr>
    <tr>
      <th id="T_e976e_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_e976e_row8_col0" class="data row8 col0" >1360467</td>
      <td id="T_e976e_row8_col1" class="data row8 col1" >1358929</td>
      <td id="T_e976e_row8_col2" class="data row8 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_e976e_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_e976e_row9_col0" class="data row9 col0" >581002</td>
      <td id="T_e976e_row9_col1" class="data row9 col1" >544712</td>
      <td id="T_e976e_row9_col2" class="data row9 col2" >0.94</td>
    </tr>
    <tr>
      <th id="T_e976e_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_e976e_row10_col0" class="data row10 col0" >124221</td>
      <td id="T_e976e_row10_col1" class="data row10 col1" >124434</td>
      <td id="T_e976e_row10_col2" class="data row10 col2" >1.00</td>
    </tr>
    <tr>
      <th id="T_e976e_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_e976e_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_e976e_row11_col0" class="data row11 col0" >109235</td>
      <td id="T_e976e_row11_col1" class="data row11 col1" >94900</td>
      <td id="T_e976e_row11_col2" class="data row11 col2" >0.87</td>
    </tr>
    <tr>
      <th id="T_e976e_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_e976e_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_e976e_row12_col0" class="data row12 col0" >1360467</td>
      <td id="T_e976e_row12_col1" class="data row12 col1" >1358929</td>
      <td id="T_e976e_row12_col2" class="data row12 col2" >1.11</td>
    </tr>
  </tbody>
</table>




**Observation**: ext4 outperforms XFS in random reads if the data is coming from page cache.

## Test 2: Ubuntu with SATA disk

### Summary

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
#T_fb345 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_fb345_row0_col0 {
  background-color: #f1FFf1;
  color: black;
}
#T_fb345_row0_col1 {
  background-color: #f3FFf3;
  color: black;
}
#T_fb345_row0_col2, #T_fb345_row8_col0 {
  background-color: #feFFfe;
  color: black;
}
#T_fb345_row0_col3 {
  background-color: #FFfefe;
  color: black;
}
#T_fb345_row1_col0, #T_fb345_row1_col3 {
  background-color: #faFFfa;
  color: black;
}
#T_fb345_row1_col1 {
  background-color: #f9FFf9;
  color: black;
}
#T_fb345_row1_col2, #T_fb345_row3_col3 {
  background-color: #fcFFfc;
  color: black;
}
#T_fb345_row2_col0 {
  background-color: #c9FFc9;
  color: black;
}
#T_fb345_row2_col1 {
  background-color: #cdFFcd;
  color: black;
}
#T_fb345_row2_col2 {
  background-color: #bdFFbd;
  color: black;
}
#T_fb345_row2_col3 {
  background-color: #FFf9f9;
  color: black;
}
#T_fb345_row3_col0 {
  background-color: #eeFFee;
  color: black;
}
#T_fb345_row3_col1 {
  background-color: #f0FFf0;
  color: black;
}
#T_fb345_row3_col2 {
  background-color: #e7FFe7;
  color: black;
}
#T_fb345_row4_col0 {
  background-color: #a8FFa8;
  color: black;
}
#T_fb345_row4_col1 {
  background-color: #c6FFc6;
  color: black;
}
#T_fb345_row4_col2 {
  background-color: #abFFab;
  color: black;
}
#T_fb345_row4_col3 {
  background-color: #b2FFb2;
  color: black;
}
#T_fb345_row5_col0 {
  background-color: #a2FFa2;
  color: black;
}
#T_fb345_row5_col1 {
  background-color: #c2FFc2;
  color: black;
}
#T_fb345_row5_col2 {
  background-color: #a9FFa9;
  color: black;
}
#T_fb345_row5_col3 {
  background-color: #b6FFb6;
  color: black;
}
#T_fb345_row6_col0 {
  background-color: #aaFFaa;
  color: black;
}
#T_fb345_row6_col1 {
  background-color: #c7FFc7;
  color: black;
}
#T_fb345_row6_col2 {
  background-color: #c8FFc8;
  color: black;
}
#T_fb345_row6_col3 {
  background-color: #e1FFe1;
  color: black;
}
#T_fb345_row7_col0 {
  background-color: #FFa8a8;
  color: black;
}
#T_fb345_row7_col1 {
  background-color: #FFa3a3;
  color: black;
}
#T_fb345_row7_col2 {
  background-color: #FFa7a7;
  color: black;
}
#T_fb345_row7_col3 {
  background-color: #FFfafa;
  color: black;
}
#T_fb345_row8_col1 {
  background-color: #FFf0f0;
  color: black;
}
#T_fb345_row8_col2 {
  background-color: #FFf1f1;
  color: black;
}
#T_fb345_row8_col3 {
  background-color: #ccFFcc;
  color: black;
}
#T_fb345_row9_col0 {
  background-color: #d8FFd8;
  color: black;
  background: lightblue;
}
#T_fb345_row9_col1 {
  background-color: #e7FFe7;
  color: black;
  background: lightblue;
}
#T_fb345_row9_col2 {
  background-color: #deFFde;
  color: black;
  background: lightblue;
}
#T_fb345_row9_col3 {
  background-color: #e2FFe2;
  color: black;
  background: lightblue;
}
#T_fb345_row10_col0 {
  background-color: #a2FFa2;
  color: black;
  background: lightblue;
}
#T_fb345_row10_col1 {
  background-color: #c2FFc2;
  color: black;
  background: lightblue;
}
#T_fb345_row10_col2 {
  background-color: #a9FFa9;
  color: black;
  background: lightblue;
}
#T_fb345_row10_col3 {
  background-color: #b2FFb2;
  color: black;
  background: lightblue;
}
</style>
<table id="T_fb345">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_fb345_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_fb345_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_fb345_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_fb345_level0_col3" class="col_heading level0 col3" >ZFS</th>
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
      <th id="T_fb345_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_fb345_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_fb345_row0_col0" class="data row0 col0" >1.1</td>
      <td id="T_fb345_row0_col1" class="data row0 col1" >1.1</td>
      <td id="T_fb345_row0_col2" class="data row0 col2" >1.0</td>
      <td id="T_fb345_row0_col3" class="data row0 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_fb345_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_fb345_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_fb345_row1_col0" class="data row1 col0" >1.0</td>
      <td id="T_fb345_row1_col1" class="data row1 col1" >1.1</td>
      <td id="T_fb345_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_fb345_row1_col3" class="data row1 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_fb345_level0_row2" class="row_heading level0 row2" rowspan="7">write disk</th>
      <th id="T_fb345_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_fb345_row2_col0" class="data row2 col0" >1.7</td>
      <td id="T_fb345_row2_col1" class="data row2 col1" >1.7</td>
      <td id="T_fb345_row2_col2" class="data row2 col2" >2.0</td>
      <td id="T_fb345_row2_col3" class="data row2 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_fb345_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_fb345_row3_col0" class="data row3 col0" >1.2</td>
      <td id="T_fb345_row3_col1" class="data row3 col1" >1.1</td>
      <td id="T_fb345_row3_col2" class="data row3 col2" >1.2</td>
      <td id="T_fb345_row3_col3" class="data row3 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_fb345_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_fb345_row4_col0" class="data row4 col0" >2.7</td>
      <td id="T_fb345_row4_col1" class="data row4 col1" >1.8</td>
      <td id="T_fb345_row4_col2" class="data row4 col2" >2.5</td>
      <td id="T_fb345_row4_col3" class="data row4 col3" >2.3</td>
    </tr>
    <tr>
      <th id="T_fb345_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_fb345_row5_col0" class="data row5 col0" >2.9</td>
      <td id="T_fb345_row5_col1" class="data row5 col1" >1.9</td>
      <td id="T_fb345_row5_col2" class="data row5 col2" >2.6</td>
      <td id="T_fb345_row5_col3" class="data row5 col3" >2.2</td>
    </tr>
    <tr>
      <th id="T_fb345_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_fb345_row6_col0" class="data row6 col0" >2.6</td>
      <td id="T_fb345_row6_col1" class="data row6 col1" >1.8</td>
      <td id="T_fb345_row6_col2" class="data row6 col2" >1.8</td>
      <td id="T_fb345_row6_col3" class="data row6 col3" >1.3</td>
    </tr>
    <tr>
      <th id="T_fb345_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_fb345_row7_col0" class="data row7 col0" >0.6</td>
      <td id="T_fb345_row7_col1" class="data row7 col1" >0.6</td>
      <td id="T_fb345_row7_col2" class="data row7 col2" >0.6</td>
      <td id="T_fb345_row7_col3" class="data row7 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_fb345_level1_row8" class="row_heading level1 row8" >write sym large</th>
      <td id="T_fb345_row8_col0" class="data row8 col0" >1.0</td>
      <td id="T_fb345_row8_col1" class="data row8 col1" >0.9</td>
      <td id="T_fb345_row8_col2" class="data row8 col2" >0.9</td>
      <td id="T_fb345_row8_col3" class="data row8 col3" >1.7</td>
    </tr>
    <tr>
      <th id="T_fb345_level0_row9" class="row_heading level0 row9" >GEOMETRIC MEAN</th>
      <th id="T_fb345_level1_row9" class="row_heading level1 row9" ></th>
      <td id="T_fb345_row9_col0" class="data row9 col0" >1.5</td>
      <td id="T_fb345_row9_col1" class="data row9 col1" >1.2</td>
      <td id="T_fb345_row9_col2" class="data row9 col2" >1.4</td>
      <td id="T_fb345_row9_col3" class="data row9 col3" >1.3</td>
    </tr>
    <tr>
      <th id="T_fb345_level0_row10" class="row_heading level0 row10" >MAX RATIO</th>
      <th id="T_fb345_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_fb345_row10_col0" class="data row10 col0" >2.9</td>
      <td id="T_fb345_row10_col1" class="data row10 col1" >1.9</td>
      <td id="T_fb345_row10_col2" class="data row10 col2" >2.6</td>
      <td id="T_fb345_row10_col3" class="data row10 col3" >2.3</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS outperforms all other file systems if a single kdb+ process writes the data. The only notable weakness for XFS was in writing small files.

The performance of the less critical write operations are below.




<style type="text/css">
#T_ca527 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_ca527_row0_col0 {
  background-color: #b6FFb6;
  color: black;
}
#T_ca527_row0_col1 {
  background-color: #bfFFbf;
  color: black;
}
#T_ca527_row0_col2 {
  background-color: #deFFde;
  color: black;
}
#T_ca527_row0_col3 {
  background-color: #b5FFb5;
  color: black;
}
#T_ca527_row1_col0, #T_ca527_row7_col1 {
  background-color: #dfFFdf;
  color: black;
}
#T_ca527_row1_col1, #T_ca527_row6_col1 {
  background-color: #eeFFee;
  color: black;
}
#T_ca527_row1_col2, #T_ca527_row10_col1 {
  background-color: #feFFfe;
  color: black;
}
#T_ca527_row1_col3, #T_ca527_row6_col2 {
  background-color: #caFFca;
  color: black;
}
#T_ca527_row2_col0 {
  background-color: #d6FFd6;
  color: black;
}
#T_ca527_row2_col1 {
  background-color: #ccFFcc;
  color: black;
}
#T_ca527_row2_col2 {
  background-color: #bdFFbd;
  color: black;
}
#T_ca527_row2_col3 {
  background-color: #FF9090;
  color: black;
}
#T_ca527_row3_col0 {
  background-color: #FFe3e3;
  color: black;
}
#T_ca527_row3_col1 {
  background-color: #FFb7b7;
  color: black;
}
#T_ca527_row3_col2 {
  background-color: #FFdbdb;
  color: black;
}
#T_ca527_row3_col3, #T_ca527_row5_col3 {
  background-color: #ceFFce;
  color: black;
}
#T_ca527_row4_col0 {
  background-color: #b9FFb9;
  color: black;
}
#T_ca527_row4_col1 {
  background-color: #b8FFb8;
  color: black;
}
#T_ca527_row4_col2 {
  background-color: #e8FFe8;
  color: black;
}
#T_ca527_row4_col3 {
  background-color: #a5FFa5;
  color: black;
}
#T_ca527_row5_col0 {
  background-color: #ecFFec;
  color: black;
}
#T_ca527_row5_col1 {
  background-color: #ddFFdd;
  color: black;
}
#T_ca527_row5_col2 {
  background-color: #edFFed;
  color: black;
}
#T_ca527_row6_col0 {
  background-color: #f9FFf9;
  color: black;
}
#T_ca527_row6_col3 {
  background-color: #FF6868;
  color: white;
}
#T_ca527_row7_col0 {
  background-color: #d8FFd8;
  color: black;
}
#T_ca527_row7_col2 {
  background-color: #e3FFe3;
  color: black;
}
#T_ca527_row7_col3 {
  background-color: #bcFFbc;
  color: black;
}
#T_ca527_row8_col0 {
  background-color: #FFd6d6;
  color: black;
}
#T_ca527_row8_col1 {
  background-color: #c5FFc5;
  color: black;
}
#T_ca527_row8_col2 {
  background-color: #FFdede;
  color: black;
}
#T_ca527_row8_col3 {
  background-color: #FFe0e0;
  color: black;
}
#T_ca527_row9_col0 {
  background-color: #e5FFe5;
  color: black;
}
#T_ca527_row9_col1 {
  background-color: #d3FFd3;
  color: black;
}
#T_ca527_row9_col2 {
  background-color: #e2FFe2;
  color: black;
}
#T_ca527_row9_col3 {
  background-color: #89FF89;
  color: black;
}
#T_ca527_row10_col0 {
  background-color: #FFf6f6;
  color: black;
}
#T_ca527_row10_col2 {
  background-color: #9eFF9e;
  color: black;
}
#T_ca527_row10_col3 {
  background-color: #7aFF7a;
  color: black;
}
#T_ca527_row11_col0 {
  background-color: #e5FFe5;
  color: black;
  background: lightblue;
}
#T_ca527_row11_col1 {
  background-color: #ddFFdd;
  color: black;
  background: lightblue;
}
#T_ca527_row11_col2 {
  background-color: #e0FFe0;
  color: black;
  background: lightblue;
}
#T_ca527_row11_col3 {
  background-color: #ceFFce;
  color: black;
  background: lightblue;
}
#T_ca527_row12_col0 {
  background-color: #b6FFb6;
  color: black;
  background: lightblue;
}
#T_ca527_row12_col1 {
  background-color: #b8FFb8;
  color: black;
  background: lightblue;
}
#T_ca527_row12_col2 {
  background-color: #9eFF9e;
  color: black;
  background: lightblue;
}
#T_ca527_row12_col3 {
  background-color: #7aFF7a;
  color: black;
  background: lightblue;
}
</style>
<table id="T_ca527">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_ca527_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_ca527_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_ca527_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_ca527_level0_col3" class="col_heading level0 col3" >ZFS</th>
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
      <th id="T_ca527_level0_row0" class="row_heading level0 row0" rowspan="11">write disk</th>
      <th id="T_ca527_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_ca527_row0_col0" class="data row0 col0" >2.2</td>
      <td id="T_ca527_row0_col1" class="data row0 col1" >2.0</td>
      <td id="T_ca527_row0_col2" class="data row0 col2" >1.4</td>
      <td id="T_ca527_row0_col3" class="data row0 col3" >2.2</td>
    </tr>
    <tr>
      <th id="T_ca527_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_ca527_row1_col0" class="data row1 col0" >1.4</td>
      <td id="T_ca527_row1_col1" class="data row1 col1" >1.2</td>
      <td id="T_ca527_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_ca527_row1_col3" class="data row1 col3" >1.7</td>
    </tr>
    <tr>
      <th id="T_ca527_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_ca527_row2_col0" class="data row2 col0" >1.5</td>
      <td id="T_ca527_row2_col1" class="data row2 col1" >1.7</td>
      <td id="T_ca527_row2_col2" class="data row2 col2" >2.0</td>
      <td id="T_ca527_row2_col3" class="data row2 col3" >0.5</td>
    </tr>
    <tr>
      <th id="T_ca527_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_ca527_row3_col0" class="data row3 col0" >0.9</td>
      <td id="T_ca527_row3_col1" class="data row3 col1" >0.7</td>
      <td id="T_ca527_row3_col2" class="data row3 col2" >0.8</td>
      <td id="T_ca527_row3_col3" class="data row3 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_ca527_level1_row4" class="row_heading level1 row4" >open replace tiny, sync once</th>
      <td id="T_ca527_row4_col0" class="data row4 col0" >2.1</td>
      <td id="T_ca527_row4_col1" class="data row4 col1" >2.1</td>
      <td id="T_ca527_row4_col2" class="data row4 col2" >1.2</td>
      <td id="T_ca527_row4_col3" class="data row4 col3" >2.8</td>
    </tr>
    <tr>
      <th id="T_ca527_level1_row5" class="row_heading level1 row5" >sync float large</th>
      <td id="T_ca527_row5_col0" class="data row5 col0" >1.2</td>
      <td id="T_ca527_row5_col1" class="data row5 col1" >1.4</td>
      <td id="T_ca527_row5_col2" class="data row5 col2" >1.2</td>
      <td id="T_ca527_row5_col3" class="data row5 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_ca527_level1_row6" class="row_heading level1 row6" >sync int huge</th>
      <td id="T_ca527_row6_col0" class="data row6 col0" >1.1</td>
      <td id="T_ca527_row6_col1" class="data row6 col1" >1.2</td>
      <td id="T_ca527_row6_col2" class="data row6 col2" >1.7</td>
      <td id="T_ca527_row6_col3" class="data row6 col3" >0.3</td>
    </tr>
    <tr>
      <th id="T_ca527_level1_row7" class="row_heading level1 row7" >sync int medium</th>
      <td id="T_ca527_row7_col0" class="data row7 col0" >1.5</td>
      <td id="T_ca527_row7_col1" class="data row7 col1" >1.4</td>
      <td id="T_ca527_row7_col2" class="data row7 col2" >1.3</td>
      <td id="T_ca527_row7_col3" class="data row7 col3" >2.0</td>
    </tr>
    <tr>
      <th id="T_ca527_level1_row8" class="row_heading level1 row8" >sync int small</th>
      <td id="T_ca527_row8_col0" class="data row8 col0" >0.8</td>
      <td id="T_ca527_row8_col1" class="data row8 col1" >1.8</td>
      <td id="T_ca527_row8_col2" class="data row8 col2" >0.9</td>
      <td id="T_ca527_row8_col3" class="data row8 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_ca527_level1_row9" class="row_heading level1 row9" >sync sym large</th>
      <td id="T_ca527_row9_col0" class="data row9 col0" >1.3</td>
      <td id="T_ca527_row9_col1" class="data row9 col1" >1.5</td>
      <td id="T_ca527_row9_col2" class="data row9 col2" >1.3</td>
      <td id="T_ca527_row9_col3" class="data row9 col3" >4.5</td>
    </tr>
    <tr>
      <th id="T_ca527_level1_row10" class="row_heading level1 row10" >sync table after sort</th>
      <td id="T_ca527_row10_col0" class="data row10 col0" >1.0</td>
      <td id="T_ca527_row10_col1" class="data row10 col1" >1.0</td>
      <td id="T_ca527_row10_col2" class="data row10 col2" >3.1</td>
      <td id="T_ca527_row10_col3" class="data row10 col3" >6.1</td>
    </tr>
    <tr>
      <th id="T_ca527_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_ca527_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_ca527_row11_col0" class="data row11 col0" >1.3</td>
      <td id="T_ca527_row11_col1" class="data row11 col1" >1.4</td>
      <td id="T_ca527_row11_col2" class="data row11 col2" >1.3</td>
      <td id="T_ca527_row11_col3" class="data row11 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_ca527_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_ca527_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_ca527_row12_col0" class="data row12 col0" >2.2</td>
      <td id="T_ca527_row12_col1" class="data row12 col1" >2.1</td>
      <td id="T_ca527_row12_col2" class="data row12 col2" >3.1</td>
      <td id="T_ca527_row12_col3" class="data row12 col3" >6.1</td>
    </tr>
  </tbody>
</table>




#### 64 kdb+ processes:




<style type="text/css">
#T_71f5a th.col_heading.level0 {
  font-size: 1.5em;
}
#T_71f5a_row0_col0, #T_71f5a_row0_col1, #T_71f5a_row0_col2, #T_71f5a_row4_col1 {
  background-color: #a2FFa2;
  color: black;
}
#T_71f5a_row0_col3 {
  background-color: #c5FFc5;
  color: black;
}
#T_71f5a_row1_col0, #T_71f5a_row7_col3 {
  background-color: #b8FFb8;
  color: black;
}
#T_71f5a_row1_col1 {
  background-color: #b6FFb6;
  color: black;
}
#T_71f5a_row1_col2 {
  background-color: #bdFFbd;
  color: black;
}
#T_71f5a_row1_col3, #T_71f5a_row3_col3 {
  background-color: #ccFFcc;
  color: black;
}
#T_71f5a_row2_col0, #T_71f5a_row3_col1 {
  background-color: #f9FFf9;
  color: black;
}
#T_71f5a_row2_col1 {
  background-color: #f6FFf6;
  color: black;
}
#T_71f5a_row2_col2 {
  background-color: #a7FFa7;
  color: black;
}
#T_71f5a_row2_col3 {
  background-color: #faFFfa;
  color: black;
}
#T_71f5a_row3_col0, #T_71f5a_row8_col1 {
  background-color: #f0FFf0;
  color: black;
}
#T_71f5a_row3_col2 {
  background-color: #b9FFb9;
  color: black;
}
#T_71f5a_row4_col0 {
  background-color: #a1FFa1;
  color: black;
}
#T_71f5a_row4_col2 {
  background-color: #43FF43;
  color: black;
}
#T_71f5a_row4_col3 {
  background-color: #4bFF4b;
  color: black;
}
#T_71f5a_row5_col0 {
  background-color: #fdFFfd;
  color: black;
}
#T_71f5a_row5_col1 {
  background-color: #bfFFbf;
  color: black;
}
#T_71f5a_row5_col2 {
  background-color: #8dFF8d;
  color: black;
}
#T_71f5a_row5_col3 {
  background-color: #d4FFd4;
  color: black;
}
#T_71f5a_row6_col0 {
  background-color: #9dFF9d;
  color: black;
}
#T_71f5a_row6_col1 {
  background-color: #a3FFa3;
  color: black;
}
#T_71f5a_row6_col2 {
  background-color: #40FF40;
  color: black;
}
#T_71f5a_row6_col3 {
  background-color: #92FF92;
  color: black;
}
#T_71f5a_row7_col0 {
  background-color: #ddFFdd;
  color: black;
}
#T_71f5a_row7_col1 {
  background-color: #81FF81;
  color: black;
}
#T_71f5a_row7_col2 {
  background-color: #57FF57;
  color: black;
}
#T_71f5a_row8_col0 {
  background-color: #ecFFec;
  color: black;
}
#T_71f5a_row8_col2 {
  background-color: #67FF67;
  color: black;
}
#T_71f5a_row8_col3 {
  background-color: #68FF68;
  color: black;
}
#T_71f5a_row9_col0 {
  background-color: #cbFFcb;
  color: black;
  background: lightblue;
}
#T_71f5a_row9_col1 {
  background-color: #baFFba;
  color: black;
  background: lightblue;
}
#T_71f5a_row9_col2 {
  background-color: #74FF74;
  color: black;
  background: lightblue;
}
#T_71f5a_row9_col3 {
  background-color: #a2FFa2;
  color: black;
  background: lightblue;
}
#T_71f5a_row10_col0 {
  background-color: #9dFF9d;
  color: black;
  background: lightblue;
}
#T_71f5a_row10_col1 {
  background-color: #81FF81;
  color: black;
  background: lightblue;
}
#T_71f5a_row10_col2 {
  background-color: #40FF40;
  color: black;
  background: lightblue;
}
#T_71f5a_row10_col3 {
  background-color: #4bFF4b;
  color: black;
  background: lightblue;
}
</style>
<table id="T_71f5a">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_71f5a_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_71f5a_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_71f5a_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_71f5a_level0_col3" class="col_heading level0 col3" >ZFS</th>
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
      <th id="T_71f5a_level0_row0" class="row_heading level0 row0" >read mem write disk</th>
      <th id="T_71f5a_level1_row0" class="row_heading level1 row0" >add attribute</th>
      <td id="T_71f5a_row0_col0" class="data row0 col0" >2.9</td>
      <td id="T_71f5a_row0_col1" class="data row0 col1" >2.9</td>
      <td id="T_71f5a_row0_col2" class="data row0 col2" >2.9</td>
      <td id="T_71f5a_row0_col3" class="data row0 col3" >1.8</td>
    </tr>
    <tr>
      <th id="T_71f5a_level0_row1" class="row_heading level0 row1" >read write disk</th>
      <th id="T_71f5a_level1_row1" class="row_heading level1 row1" >disk sort</th>
      <td id="T_71f5a_row1_col0" class="data row1 col0" >2.1</td>
      <td id="T_71f5a_row1_col1" class="data row1 col1" >2.2</td>
      <td id="T_71f5a_row1_col2" class="data row1 col2" >2.0</td>
      <td id="T_71f5a_row1_col3" class="data row1 col3" >1.7</td>
    </tr>
    <tr>
      <th id="T_71f5a_level0_row2" class="row_heading level0 row2" rowspan="7">write disk</th>
      <th id="T_71f5a_level1_row2" class="row_heading level1 row2" >open append mid float, sync once</th>
      <td id="T_71f5a_row2_col0" class="data row2 col0" >1.1</td>
      <td id="T_71f5a_row2_col1" class="data row2 col1" >1.1</td>
      <td id="T_71f5a_row2_col2" class="data row2 col2" >2.7</td>
      <td id="T_71f5a_row2_col3" class="data row2 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_71f5a_level1_row3" class="row_heading level1 row3" >open append mid sym, sync once</th>
      <td id="T_71f5a_row3_col0" class="data row3 col0" >1.1</td>
      <td id="T_71f5a_row3_col1" class="data row3 col1" >1.1</td>
      <td id="T_71f5a_row3_col2" class="data row3 col2" >2.1</td>
      <td id="T_71f5a_row3_col3" class="data row3 col3" >1.7</td>
    </tr>
    <tr>
      <th id="T_71f5a_level1_row4" class="row_heading level1 row4" >write float large</th>
      <td id="T_71f5a_row4_col0" class="data row4 col0" >3.0</td>
      <td id="T_71f5a_row4_col1" class="data row4 col1" >2.9</td>
      <td id="T_71f5a_row4_col2" class="data row4 col2" >40.3</td>
      <td id="T_71f5a_row4_col3" class="data row4 col3" >26.8</td>
    </tr>
    <tr>
      <th id="T_71f5a_level1_row5" class="row_heading level1 row5" >write int huge</th>
      <td id="T_71f5a_row5_col0" class="data row5 col0" >1.0</td>
      <td id="T_71f5a_row5_col1" class="data row5 col1" >2.0</td>
      <td id="T_71f5a_row5_col2" class="data row5 col2" >4.1</td>
      <td id="T_71f5a_row5_col3" class="data row5 col3" >1.5</td>
    </tr>
    <tr>
      <th id="T_71f5a_level1_row6" class="row_heading level1 row6" >write int medium</th>
      <td id="T_71f5a_row6_col0" class="data row6 col0" >3.2</td>
      <td id="T_71f5a_row6_col1" class="data row6 col1" >2.9</td>
      <td id="T_71f5a_row6_col2" class="data row6 col2" >47.1</td>
      <td id="T_71f5a_row6_col3" class="data row6 col3" >3.8</td>
    </tr>
    <tr>
      <th id="T_71f5a_level1_row7" class="row_heading level1 row7" >write int small</th>
      <td id="T_71f5a_row7_col0" class="data row7 col0" >1.4</td>
      <td id="T_71f5a_row7_col1" class="data row7 col1" >5.3</td>
      <td id="T_71f5a_row7_col2" class="data row7 col2" >16.4</td>
      <td id="T_71f5a_row7_col3" class="data row7 col3" >2.1</td>
    </tr>
    <tr>
      <th id="T_71f5a_level1_row8" class="row_heading level1 row8" >write sym large</th>
      <td id="T_71f5a_row8_col0" class="data row8 col0" >1.2</td>
      <td id="T_71f5a_row8_col1" class="data row8 col1" >1.1</td>
      <td id="T_71f5a_row8_col2" class="data row8 col2" >9.7</td>
      <td id="T_71f5a_row8_col3" class="data row8 col3" >9.5</td>
    </tr>
    <tr>
      <th id="T_71f5a_level0_row9" class="row_heading level0 row9" >GEOMETRIC MEAN</th>
      <th id="T_71f5a_level1_row9" class="row_heading level1 row9" ></th>
      <td id="T_71f5a_row9_col0" class="data row9 col0" >1.7</td>
      <td id="T_71f5a_row9_col1" class="data row9 col1" >2.1</td>
      <td id="T_71f5a_row9_col2" class="data row9 col2" >7.0</td>
      <td id="T_71f5a_row9_col3" class="data row9 col3" >2.9</td>
    </tr>
    <tr>
      <th id="T_71f5a_level0_row10" class="row_heading level0 row10" >MAX RATIO</th>
      <th id="T_71f5a_level1_row10" class="row_heading level1 row10" ></th>
      <td id="T_71f5a_row10_col0" class="data row10 col0" >3.2</td>
      <td id="T_71f5a_row10_col1" class="data row10 col1" >5.3</td>
      <td id="T_71f5a_row10_col2" class="data row10 col2" >47.1</td>
      <td id="T_71f5a_row10_col3" class="data row10 col3" >26.8</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS significantly outperforms all other file systems. Its margin can be significant, for example persisting a large float vector (the `set` operation) is **over 27 times faster on XFS than on ZFS**.




<style type="text/css">
#T_d0e63 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_d0e63_row0_col0 {
  background-color: #dcFFdc;
  color: black;
}
#T_d0e63_row0_col1 {
  background-color: #d4FFd4;
  color: black;
}
#T_d0e63_row0_col2 {
  background-color: #92FF92;
  color: black;
}
#T_d0e63_row0_col3 {
  background-color: #aeFFae;
  color: black;
}
#T_d0e63_row1_col0 {
  background-color: #FFd4d4;
  color: black;
}
#T_d0e63_row1_col1 {
  background-color: #e2FFe2;
  color: black;
}
#T_d0e63_row1_col2 {
  background-color: #72FF72;
  color: black;
}
#T_d0e63_row1_col3 {
  background-color: #efFFef;
  color: black;
}
#T_d0e63_row2_col0, #T_d0e63_row2_col1, #T_d0e63_row6_col0 {
  background-color: #feFFfe;
  color: black;
}
#T_d0e63_row2_col2 {
  background-color: #98FF98;
  color: black;
}
#T_d0e63_row2_col3 {
  background-color: #FFc8c8;
  color: black;
}
#T_d0e63_row3_col0 {
  background-color: #FFdbdb;
  color: black;
}
#T_d0e63_row3_col1 {
  background-color: #d8FFd8;
  color: black;
}
#T_d0e63_row3_col2 {
  background-color: #61FF61;
  color: black;
}
#T_d0e63_row3_col3, #T_d0e63_row8_col1 {
  background-color: #ecFFec;
  color: black;
}
#T_d0e63_row4_col0 {
  background-color: #9cFF9c;
  color: black;
}
#T_d0e63_row4_col1 {
  background-color: #4dFF4d;
  color: black;
}
#T_d0e63_row4_col2 {
  background-color: #85FF85;
  color: black;
}
#T_d0e63_row4_col3 {
  background-color: #79FF79;
  color: black;
}
#T_d0e63_row5_col0, #T_d0e63_row9_col0 {
  background-color: #fdFFfd;
  color: black;
}
#T_d0e63_row5_col1 {
  background-color: #FFf8f8;
  color: black;
}
#T_d0e63_row5_col2 {
  background-color: #FF9b9b;
  color: black;
}
#T_d0e63_row5_col3 {
  background-color: #FF8e8e;
  color: white;
}
#T_d0e63_row6_col1 {
  background-color: #e6FFe6;
  color: black;
}
#T_d0e63_row6_col2 {
  background-color: #FF9191;
  color: black;
}
#T_d0e63_row6_col3 {
  background-color: #FF2424;
  color: white;
}
#T_d0e63_row7_col0 {
  background-color: #fcFFfc;
  color: black;
}
#T_d0e63_row7_col1 {
  background-color: #FFc2c2;
  color: black;
}
#T_d0e63_row7_col2, #T_d0e63_row8_col2 {
  background-color: #a0FFa0;
  color: black;
}
#T_d0e63_row7_col3 {
  background-color: #e4FFe4;
  color: black;
}
#T_d0e63_row8_col0 {
  background-color: #FFd9d9;
  color: black;
}
#T_d0e63_row8_col3 {
  background-color: #f7FFf7;
  color: black;
}
#T_d0e63_row9_col1 {
  background-color: #FFe5e5;
  color: black;
}
#T_d0e63_row9_col2 {
  background-color: #FFa6a6;
  color: black;
}
#T_d0e63_row9_col3 {
  background-color: #e8FFe8;
  color: black;
}
#T_d0e63_row10_col0 {
  background-color: #FFa0a0;
  color: black;
}
#T_d0e63_row10_col1 {
  background-color: #41FF41;
  color: black;
}
#T_d0e63_row10_col2, #T_d0e63_row10_col3 {
  background-color: #62FF62;
  color: black;
}
#T_d0e63_row11_col0 {
  background-color: #faFFfa;
  color: black;
  background: lightblue;
}
#T_d0e63_row11_col1 {
  background-color: #bbFFbb;
  color: black;
  background: lightblue;
}
#T_d0e63_row11_col2 {
  background-color: #a4FFa4;
  color: black;
  background: lightblue;
}
#T_d0e63_row11_col3 {
  background-color: #f3FFf3;
  color: black;
  background: lightblue;
}
#T_d0e63_row12_col0 {
  background-color: #9cFF9c;
  color: black;
  background: lightblue;
}
#T_d0e63_row12_col1 {
  background-color: #41FF41;
  color: black;
  background: lightblue;
}
#T_d0e63_row12_col2 {
  background-color: #61FF61;
  color: black;
  background: lightblue;
}
#T_d0e63_row12_col3 {
  background-color: #62FF62;
  color: black;
  background: lightblue;
}
</style>
<table id="T_d0e63">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_d0e63_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_d0e63_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_d0e63_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_d0e63_level0_col3" class="col_heading level0 col3" >ZFS</th>
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
      <th id="T_d0e63_level0_row0" class="row_heading level0 row0" rowspan="11">write disk</th>
      <th id="T_d0e63_level1_row0" class="row_heading level1 row0" >append small, sync once</th>
      <td id="T_d0e63_row0_col0" class="data row0 col0" >1.4</td>
      <td id="T_d0e63_row0_col1" class="data row0 col1" >1.5</td>
      <td id="T_d0e63_row0_col2" class="data row0 col2" >3.8</td>
      <td id="T_d0e63_row0_col3" class="data row0 col3" >2.5</td>
    </tr>
    <tr>
      <th id="T_d0e63_level1_row1" class="row_heading level1 row1" >append tiny, sync once</th>
      <td id="T_d0e63_row1_col0" class="data row1 col0" >0.8</td>
      <td id="T_d0e63_row1_col1" class="data row1 col1" >1.3</td>
      <td id="T_d0e63_row1_col2" class="data row1 col2" >7.3</td>
      <td id="T_d0e63_row1_col3" class="data row1 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_d0e63_level1_row2" class="row_heading level1 row2" >open append small, sync once</th>
      <td id="T_d0e63_row2_col0" class="data row2 col0" >1.0</td>
      <td id="T_d0e63_row2_col1" class="data row2 col1" >1.0</td>
      <td id="T_d0e63_row2_col2" class="data row2 col2" >3.4</td>
      <td id="T_d0e63_row2_col3" class="data row2 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_d0e63_level1_row3" class="row_heading level1 row3" >open append tiny, sync once</th>
      <td id="T_d0e63_row3_col0" class="data row3 col0" >0.8</td>
      <td id="T_d0e63_row3_col1" class="data row3 col1" >1.5</td>
      <td id="T_d0e63_row3_col2" class="data row3 col2" >11.5</td>
      <td id="T_d0e63_row3_col3" class="data row3 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_d0e63_level1_row4" class="row_heading level1 row4" >open replace tiny, sync once</th>
      <td id="T_d0e63_row4_col0" class="data row4 col0" >3.2</td>
      <td id="T_d0e63_row4_col1" class="data row4 col1" >24.0</td>
      <td id="T_d0e63_row4_col2" class="data row4 col2" >4.8</td>
      <td id="T_d0e63_row4_col3" class="data row4 col3" >6.2</td>
    </tr>
    <tr>
      <th id="T_d0e63_level1_row5" class="row_heading level1 row5" >sync float large</th>
      <td id="T_d0e63_row5_col0" class="data row5 col0" >1.0</td>
      <td id="T_d0e63_row5_col1" class="data row5 col1" >1.0</td>
      <td id="T_d0e63_row5_col2" class="data row5 col2" >0.6</td>
      <td id="T_d0e63_row5_col3" class="data row5 col3" >0.5</td>
    </tr>
    <tr>
      <th id="T_d0e63_level1_row6" class="row_heading level1 row6" >sync int huge</th>
      <td id="T_d0e63_row6_col0" class="data row6 col0" >1.0</td>
      <td id="T_d0e63_row6_col1" class="data row6 col1" >1.3</td>
      <td id="T_d0e63_row6_col2" class="data row6 col2" >0.5</td>
      <td id="T_d0e63_row6_col3" class="data row6 col3" >0.0</td>
    </tr>
    <tr>
      <th id="T_d0e63_level1_row7" class="row_heading level1 row7" >sync int medium</th>
      <td id="T_d0e63_row7_col0" class="data row7 col0" >1.0</td>
      <td id="T_d0e63_row7_col1" class="data row7 col1" >0.7</td>
      <td id="T_d0e63_row7_col2" class="data row7 col2" >3.0</td>
      <td id="T_d0e63_row7_col3" class="data row7 col3" >1.3</td>
    </tr>
    <tr>
      <th id="T_d0e63_level1_row8" class="row_heading level1 row8" >sync int small</th>
      <td id="T_d0e63_row8_col0" class="data row8 col0" >0.8</td>
      <td id="T_d0e63_row8_col1" class="data row8 col1" >1.2</td>
      <td id="T_d0e63_row8_col2" class="data row8 col2" >3.0</td>
      <td id="T_d0e63_row8_col3" class="data row8 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_d0e63_level1_row9" class="row_heading level1 row9" >sync sym large</th>
      <td id="T_d0e63_row9_col0" class="data row9 col0" >1.0</td>
      <td id="T_d0e63_row9_col1" class="data row9 col1" >0.9</td>
      <td id="T_d0e63_row9_col2" class="data row9 col2" >0.6</td>
      <td id="T_d0e63_row9_col3" class="data row9 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_d0e63_level1_row10" class="row_heading level1 row10" >sync table after sort</th>
      <td id="T_d0e63_row10_col0" class="data row10 col0" >0.6</td>
      <td id="T_d0e63_row10_col1" class="data row10 col1" >44.7</td>
      <td id="T_d0e63_row10_col2" class="data row10 col2" >11.3</td>
      <td id="T_d0e63_row10_col3" class="data row10 col3" >11.1</td>
    </tr>
    <tr>
      <th id="T_d0e63_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_d0e63_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_d0e63_row11_col0" class="data row11 col0" >1.0</td>
      <td id="T_d0e63_row11_col1" class="data row11 col1" >2.1</td>
      <td id="T_d0e63_row11_col2" class="data row11 col2" >2.8</td>
      <td id="T_d0e63_row11_col3" class="data row11 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_d0e63_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_d0e63_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_d0e63_row12_col0" class="data row12 col0" >3.2</td>
      <td id="T_d0e63_row12_col1" class="data row12 col1" >44.7</td>
      <td id="T_d0e63_row12_col2" class="data row12 col2" >11.5</td>
      <td id="T_d0e63_row12_col3" class="data row12 col3" >11.1</td>
    </tr>
  </tbody>
</table>




### Read

#### Single kdb+ process:




<style type="text/css">
#T_8d2d7 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_8d2d7_row0_col0, #T_8d2d7_row4_col2 {
  background-color: #f8FFf8;
  color: black;
}
#T_8d2d7_row0_col1, #T_8d2d7_row3_col1 {
  background-color: #8aFF8a;
  color: black;
}
#T_8d2d7_row0_col2, #T_8d2d7_row3_col2 {
  background-color: #f1FFf1;
  color: black;
}
#T_8d2d7_row0_col3 {
  background-color: #b9FFb9;
  color: black;
}
#T_8d2d7_row1_col0, #T_8d2d7_row4_col0 {
  background-color: #fdFFfd;
  color: black;
}
#T_8d2d7_row1_col1 {
  background-color: #f2FFf2;
  color: black;
}
#T_8d2d7_row1_col2, #T_8d2d7_row3_col0 {
  background-color: #fbFFfb;
  color: black;
}
#T_8d2d7_row1_col3 {
  background-color: #FFe1e1;
  color: black;
}
#T_8d2d7_row2_col0 {
  background-color: #FFefef;
  color: black;
}
#T_8d2d7_row2_col1, #T_8d2d7_row6_col1 {
  background-color: #78FF78;
  color: black;
}
#T_8d2d7_row2_col2 {
  background-color: #FFfcfc;
  color: black;
}
#T_8d2d7_row2_col3 {
  background-color: #FFd6d6;
  color: black;
}
#T_8d2d7_row3_col3 {
  background-color: #b4FFb4;
  color: black;
}
#T_8d2d7_row4_col1, #T_8d2d7_row9_col0 {
  background-color: #e7FFe7;
  color: black;
}
#T_8d2d7_row4_col3 {
  background-color: #FFdddd;
  color: black;
}
#T_8d2d7_row5_col0 {
  background-color: #FFf2f2;
  color: black;
}
#T_8d2d7_row5_col1 {
  background-color: #76FF76;
  color: black;
}
#T_8d2d7_row5_col2 {
  background-color: #feFFfe;
  color: black;
}
#T_8d2d7_row5_col3 {
  background-color: #FFdbdb;
  color: black;
}
#T_8d2d7_row6_col0 {
  background-color: #baFFba;
  color: black;
}
#T_8d2d7_row6_col2 {
  background-color: #bbFFbb;
  color: black;
}
#T_8d2d7_row6_col3 {
  background-color: #b5FFb5;
  color: black;
}
#T_8d2d7_row7_col0 {
  background-color: #f0FFf0;
  color: black;
}
#T_8d2d7_row7_col1 {
  background-color: #FFcdcd;
  color: black;
}
#T_8d2d7_row7_col2 {
  background-color: #e1FFe1;
  color: black;
}
#T_8d2d7_row7_col3 {
  background-color: #9aFF9a;
  color: black;
}
#T_8d2d7_row8_col0 {
  background-color: #efFFef;
  color: black;
}
#T_8d2d7_row8_col1 {
  background-color: #FFcece;
  color: black;
}
#T_8d2d7_row8_col2 {
  background-color: #e8FFe8;
  color: black;
}
#T_8d2d7_row8_col3 {
  background-color: #86FF86;
  color: black;
}
#T_8d2d7_row9_col1 {
  background-color: #caFFca;
  color: black;
}
#T_8d2d7_row9_col2 {
  background-color: #e9FFe9;
  color: black;
}
#T_8d2d7_row9_col3 {
  background-color: #7cFF7c;
  color: black;
}
#T_8d2d7_row10_col0 {
  background-color: #FFc5c5;
  color: black;
}
#T_8d2d7_row10_col1 {
  background-color: #FFe6e6;
  color: black;
}
#T_8d2d7_row10_col2 {
  background-color: #e0FFe0;
  color: black;
}
#T_8d2d7_row10_col3 {
  background-color: #cfFFcf;
  color: black;
}
#T_8d2d7_row11_col0 {
  background-color: #f5FFf5;
  color: black;
  background: lightblue;
}
#T_8d2d7_row11_col1 {
  background-color: #b5FFb5;
  color: black;
  background: lightblue;
}
#T_8d2d7_row11_col2 {
  background-color: #ebFFeb;
  color: black;
  background: lightblue;
}
#T_8d2d7_row11_col3 {
  background-color: #c4FFc4;
  color: black;
  background: lightblue;
}
#T_8d2d7_row12_col0 {
  background-color: #baFFba;
  color: black;
  background: lightblue;
}
#T_8d2d7_row12_col1 {
  background-color: #76FF76;
  color: black;
  background: lightblue;
}
#T_8d2d7_row12_col2 {
  background-color: #bbFFbb;
  color: black;
  background: lightblue;
}
#T_8d2d7_row12_col3 {
  background-color: #7cFF7c;
  color: black;
  background: lightblue;
}
</style>
<table id="T_8d2d7">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_8d2d7_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_8d2d7_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_8d2d7_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_8d2d7_level0_col3" class="col_heading level0 col3" >ZFS</th>
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
      <th id="T_8d2d7_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_8d2d7_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_8d2d7_row0_col0" class="data row0 col0" >1.1</td>
      <td id="T_8d2d7_row0_col1" class="data row0 col1" >4.4</td>
      <td id="T_8d2d7_row0_col2" class="data row0 col2" >1.1</td>
      <td id="T_8d2d7_row0_col3" class="data row0 col3" >2.1</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_8d2d7_row1_col0" class="data row1 col0" >1.0</td>
      <td id="T_8d2d7_row1_col1" class="data row1 col1" >1.1</td>
      <td id="T_8d2d7_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_8d2d7_row1_col3" class="data row1 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_8d2d7_row2_col0" class="data row2 col0" >0.9</td>
      <td id="T_8d2d7_row2_col1" class="data row2 col1" >6.4</td>
      <td id="T_8d2d7_row2_col2" class="data row2 col2" >1.0</td>
      <td id="T_8d2d7_row2_col3" class="data row2 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_8d2d7_row3_col0" class="data row3 col0" >1.0</td>
      <td id="T_8d2d7_row3_col1" class="data row3 col1" >4.4</td>
      <td id="T_8d2d7_row3_col2" class="data row3 col2" >1.1</td>
      <td id="T_8d2d7_row3_col3" class="data row3 col3" >2.3</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_8d2d7_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_8d2d7_row4_col1" class="data row4 col1" >1.2</td>
      <td id="T_8d2d7_row4_col2" class="data row4 col2" >1.1</td>
      <td id="T_8d2d7_row4_col3" class="data row4 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_8d2d7_row5_col0" class="data row5 col0" >0.9</td>
      <td id="T_8d2d7_row5_col1" class="data row5 col1" >6.7</td>
      <td id="T_8d2d7_row5_col2" class="data row5 col2" >1.0</td>
      <td id="T_8d2d7_row5_col3" class="data row5 col3" >0.8</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_8d2d7_row6_col0" class="data row6 col0" >2.1</td>
      <td id="T_8d2d7_row6_col1" class="data row6 col1" >6.4</td>
      <td id="T_8d2d7_row6_col2" class="data row6 col2" >2.0</td>
      <td id="T_8d2d7_row6_col3" class="data row6 col3" >2.2</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level0_row7" class="row_heading level0 row7" rowspan="4">read disk write mem</th>
      <th id="T_8d2d7_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_8d2d7_row7_col0" class="data row7 col0" >1.1</td>
      <td id="T_8d2d7_row7_col1" class="data row7 col1" >0.8</td>
      <td id="T_8d2d7_row7_col2" class="data row7 col2" >1.3</td>
      <td id="T_8d2d7_row7_col3" class="data row7 col3" >3.3</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_8d2d7_row8_col0" class="data row8 col0" >1.2</td>
      <td id="T_8d2d7_row8_col1" class="data row8 col1" >0.8</td>
      <td id="T_8d2d7_row8_col2" class="data row8 col2" >1.2</td>
      <td id="T_8d2d7_row8_col3" class="data row8 col3" >4.7</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_8d2d7_row9_col0" class="data row9 col0" >1.2</td>
      <td id="T_8d2d7_row9_col1" class="data row9 col1" >1.7</td>
      <td id="T_8d2d7_row9_col2" class="data row9 col2" >1.2</td>
      <td id="T_8d2d7_row9_col3" class="data row9 col3" >5.8</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_8d2d7_row10_col0" class="data row10 col0" >0.7</td>
      <td id="T_8d2d7_row10_col1" class="data row10 col1" >0.9</td>
      <td id="T_8d2d7_row10_col2" class="data row10 col2" >1.3</td>
      <td id="T_8d2d7_row10_col3" class="data row10 col3" >1.6</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_8d2d7_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_8d2d7_row11_col0" class="data row11 col0" >1.1</td>
      <td id="T_8d2d7_row11_col1" class="data row11 col1" >2.2</td>
      <td id="T_8d2d7_row11_col2" class="data row11 col2" >1.2</td>
      <td id="T_8d2d7_row11_col3" class="data row11 col3" >1.8</td>
    </tr>
    <tr>
      <th id="T_8d2d7_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_8d2d7_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_8d2d7_row12_col0" class="data row12 col0" >2.1</td>
      <td id="T_8d2d7_row12_col1" class="data row12 col1" >6.7</td>
      <td id="T_8d2d7_row12_col2" class="data row12 col2" >2.0</td>
      <td id="T_8d2d7_row12_col3" class="data row12 col3" >5.8</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS excels in reading from disk if there is a single kdb+ reader.




<style type="text/css">
#T_dd131 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_dd131_row0_col0 {
  background-color: #e7FFe7;
  color: black;
}
#T_dd131_row0_col1 {
  background-color: #e0FFe0;
  color: black;
}
#T_dd131_row0_col2 {
  background-color: #ddFFdd;
  color: black;
}
#T_dd131_row0_col3 {
  background-color: #dbFFdb;
  color: black;
}
#T_dd131_row1_col0 {
  background-color: #f4FFf4;
  color: black;
}
#T_dd131_row1_col1 {
  background-color: #f2FFf2;
  color: black;
}
#T_dd131_row1_col2, #T_dd131_row3_col0 {
  background-color: #fdFFfd;
  color: black;
}
#T_dd131_row1_col3 {
  background-color: #FFfbfb;
  color: black;
}
#T_dd131_row2_col0, #T_dd131_row5_col3 {
  background-color: #f3FFf3;
  color: black;
}
#T_dd131_row2_col1, #T_dd131_row3_col2 {
  background-color: #f0FFf0;
  color: black;
}
#T_dd131_row2_col2, #T_dd131_row2_col3 {
  background-color: #f1FFf1;
  color: black;
}
#T_dd131_row3_col1 {
  background-color: #eeFFee;
  color: black;
}
#T_dd131_row3_col3 {
  background-color: #ecFFec;
  color: black;
}
#T_dd131_row4_col0 {
  background-color: #FFf7f7;
  color: black;
}
#T_dd131_row4_col1 {
  background-color: #f8FFf8;
  color: black;
}
#T_dd131_row4_col2 {
  background-color: #f7FFf7;
  color: black;
}
#T_dd131_row4_col3 {
  background-color: #FFf1f1;
  color: black;
}
#T_dd131_row5_col0 {
  background-color: #feFFfe;
  color: black;
}
#T_dd131_row5_col1, #T_dd131_row10_col3 {
  background-color: #f6FFf6;
  color: black;
}
#T_dd131_row5_col2 {
  background-color: #e9FFe9;
  color: black;
}
#T_dd131_row6_col0 {
  background-color: #FFe0e0;
  color: black;
}
#T_dd131_row6_col1 {
  background-color: #FFeeee;
  color: black;
}
#T_dd131_row6_col2 {
  background-color: #FFf2f2;
  color: black;
}
#T_dd131_row6_col3 {
  background-color: #f5FFf5;
  color: black;
}
#T_dd131_row7_col0 {
  background-color: #cbFFcb;
  color: black;
}
#T_dd131_row7_col1 {
  background-color: #b9FFb9;
  color: black;
}
#T_dd131_row7_col2, #T_dd131_row7_col3 {
  background-color: #acFFac;
  color: black;
}
#T_dd131_row8_col0 {
  background-color: #bfFFbf;
  color: black;
}
#T_dd131_row8_col1 {
  background-color: #b5FFb5;
  color: black;
}
#T_dd131_row8_col2 {
  background-color: #c1FFc1;
  color: black;
}
#T_dd131_row8_col3 {
  background-color: #b3FFb3;
  color: black;
}
#T_dd131_row9_col0 {
  background-color: #cfFFcf;
  color: black;
}
#T_dd131_row9_col1 {
  background-color: #a7FFa7;
  color: black;
}
#T_dd131_row9_col2 {
  background-color: #d4FFd4;
  color: black;
}
#T_dd131_row9_col3 {
  background-color: #b0FFb0;
  color: black;
}
#T_dd131_row10_col0 {
  background-color: #FFb2b2;
  color: black;
}
#T_dd131_row10_col1 {
  background-color: #FFb3b3;
  color: black;
}
#T_dd131_row10_col2 {
  background-color: #FF9f9f;
  color: black;
}
#T_dd131_row11_col0 {
  background-color: #f0FFf0;
  color: black;
  background: lightblue;
}
#T_dd131_row11_col1 {
  background-color: #e3FFe3;
  color: black;
  background: lightblue;
}
#T_dd131_row11_col2 {
  background-color: #e9FFe9;
  color: black;
  background: lightblue;
}
#T_dd131_row11_col3 {
  background-color: #deFFde;
  color: black;
  background: lightblue;
}
#T_dd131_row12_col0 {
  background-color: #bfFFbf;
  color: black;
  background: lightblue;
}
#T_dd131_row12_col1 {
  background-color: #a7FFa7;
  color: black;
  background: lightblue;
}
#T_dd131_row12_col2, #T_dd131_row12_col3 {
  background-color: #acFFac;
  color: black;
  background: lightblue;
}
</style>
<table id="T_dd131">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_dd131_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_dd131_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_dd131_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_dd131_level0_col3" class="col_heading level0 col3" >ZFS</th>
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
      <th id="T_dd131_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_dd131_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_dd131_row0_col0" class="data row0 col0" >1.2</td>
      <td id="T_dd131_row0_col1" class="data row0 col1" >1.3</td>
      <td id="T_dd131_row0_col2" class="data row0 col2" >1.4</td>
      <td id="T_dd131_row0_col3" class="data row0 col3" >1.4</td>
    </tr>
    <tr>
      <th id="T_dd131_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_dd131_row1_col0" class="data row1 col0" >1.1</td>
      <td id="T_dd131_row1_col1" class="data row1 col1" >1.1</td>
      <td id="T_dd131_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_dd131_row1_col3" class="data row1 col3" >1.0</td>
    </tr>
    <tr>
      <th id="T_dd131_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_dd131_row2_col0" class="data row2 col0" >1.1</td>
      <td id="T_dd131_row2_col1" class="data row2 col1" >1.1</td>
      <td id="T_dd131_row2_col2" class="data row2 col2" >1.1</td>
      <td id="T_dd131_row2_col3" class="data row2 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_dd131_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_dd131_row3_col0" class="data row3 col0" >1.0</td>
      <td id="T_dd131_row3_col1" class="data row3 col1" >1.2</td>
      <td id="T_dd131_row3_col2" class="data row3 col2" >1.1</td>
      <td id="T_dd131_row3_col3" class="data row3 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_dd131_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_dd131_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_dd131_row4_col1" class="data row4 col1" >1.1</td>
      <td id="T_dd131_row4_col2" class="data row4 col2" >1.1</td>
      <td id="T_dd131_row4_col3" class="data row4 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_dd131_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_dd131_row5_col0" class="data row5 col0" >1.0</td>
      <td id="T_dd131_row5_col1" class="data row5 col1" >1.1</td>
      <td id="T_dd131_row5_col2" class="data row5 col2" >1.2</td>
      <td id="T_dd131_row5_col3" class="data row5 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_dd131_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_dd131_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_dd131_row6_col0" class="data row6 col0" >0.9</td>
      <td id="T_dd131_row6_col1" class="data row6 col1" >0.9</td>
      <td id="T_dd131_row6_col2" class="data row6 col2" >0.9</td>
      <td id="T_dd131_row6_col3" class="data row6 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_dd131_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_dd131_row7_col0" class="data row7 col0" >1.7</td>
      <td id="T_dd131_row7_col1" class="data row7 col1" >2.1</td>
      <td id="T_dd131_row7_col2" class="data row7 col2" >2.5</td>
      <td id="T_dd131_row7_col3" class="data row7 col3" >2.5</td>
    </tr>
    <tr>
      <th id="T_dd131_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_dd131_row8_col0" class="data row8 col0" >2.0</td>
      <td id="T_dd131_row8_col1" class="data row8 col1" >2.2</td>
      <td id="T_dd131_row8_col2" class="data row8 col2" >1.9</td>
      <td id="T_dd131_row8_col3" class="data row8 col3" >2.3</td>
    </tr>
    <tr>
      <th id="T_dd131_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_dd131_row9_col0" class="data row9 col0" >1.6</td>
      <td id="T_dd131_row9_col1" class="data row9 col1" >2.7</td>
      <td id="T_dd131_row9_col2" class="data row9 col2" >1.5</td>
      <td id="T_dd131_row9_col3" class="data row9 col3" >2.4</td>
    </tr>
    <tr>
      <th id="T_dd131_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_dd131_row10_col0" class="data row10 col0" >0.7</td>
      <td id="T_dd131_row10_col1" class="data row10 col1" >0.7</td>
      <td id="T_dd131_row10_col2" class="data row10 col2" >0.6</td>
      <td id="T_dd131_row10_col3" class="data row10 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_dd131_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_dd131_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_dd131_row11_col0" class="data row11 col0" >1.1</td>
      <td id="T_dd131_row11_col1" class="data row11 col1" >1.3</td>
      <td id="T_dd131_row11_col2" class="data row11 col2" >1.2</td>
      <td id="T_dd131_row11_col3" class="data row11 col3" >1.4</td>
    </tr>
    <tr>
      <th id="T_dd131_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_dd131_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_dd131_row12_col0" class="data row12 col0" >2.0</td>
      <td id="T_dd131_row12_col1" class="data row12 col1" >2.7</td>
      <td id="T_dd131_row12_col2" class="data row12 col2" >2.5</td>
      <td id="T_dd131_row12_col3" class="data row12 col3" >2.5</td>
    </tr>
  </tbody>
</table>




**Observation**: XFS excels in reading from page cache if there is a single kdb+ reader.

#### 64 kdb+ processes:




<style type="text/css">
#T_c34df th.col_heading.level0 {
  font-size: 1.5em;
}
#T_c34df_row0_col0, #T_c34df_row3_col0, #T_c34df_row4_col0, #T_c34df_row4_col1 {
  background-color: #feFFfe;
  color: black;
}
#T_c34df_row0_col1 {
  background-color: #b4FFb4;
  color: black;
}
#T_c34df_row0_col2 {
  background-color: #FFeeee;
  color: black;
}
#T_c34df_row0_col3 {
  background-color: #FF8181;
  color: white;
}
#T_c34df_row1_col0 {
  background-color: #FFfdfd;
  color: black;
}
#T_c34df_row1_col1, #T_c34df_row9_col3 {
  background-color: #f4FFf4;
  color: black;
}
#T_c34df_row1_col2 {
  background-color: #FFf2f2;
  color: black;
}
#T_c34df_row1_col3 {
  background-color: #FFbaba;
  color: black;
}
#T_c34df_row2_col0 {
  background-color: #FFd2d2;
  color: black;
}
#T_c34df_row2_col1 {
  background-color: #d5FFd5;
  color: black;
}
#T_c34df_row2_col2, #T_c34df_row5_col2 {
  background-color: #FFc7c7;
  color: black;
}
#T_c34df_row2_col3 {
  background-color: #FF5252;
  color: white;
}
#T_c34df_row3_col1 {
  background-color: #b6FFb6;
  color: black;
}
#T_c34df_row3_col2 {
  background-color: #FFefef;
  color: black;
}
#T_c34df_row3_col3 {
  background-color: #FF8585;
  color: white;
}
#T_c34df_row4_col2 {
  background-color: #FFf1f1;
  color: black;
}
#T_c34df_row4_col3 {
  background-color: #FF9a9a;
  color: black;
}
#T_c34df_row5_col0 {
  background-color: #FFd3d3;
  color: black;
}
#T_c34df_row5_col1 {
  background-color: #d6FFd6;
  color: black;
}
#T_c34df_row5_col3 {
  background-color: #FF4d4d;
  color: white;
}
#T_c34df_row6_col0 {
  background-color: #69FF69;
  color: black;
}
#T_c34df_row6_col1 {
  background-color: #6cFF6c;
  color: black;
}
#T_c34df_row6_col2 {
  background-color: #6aFF6a;
  color: black;
}
#T_c34df_row6_col3 {
  background-color: #77FF77;
  color: black;
}
#T_c34df_row7_col0, #T_c34df_row7_col2 {
  background-color: #FFcbcb;
  color: black;
}
#T_c34df_row7_col1 {
  background-color: #FFbdbd;
  color: black;
}
#T_c34df_row7_col3 {
  background-color: #FF8f8f;
  color: black;
}
#T_c34df_row8_col0 {
  background-color: #FFe0e0;
  color: black;
}
#T_c34df_row8_col1 {
  background-color: #FFcccc;
  color: black;
}
#T_c34df_row8_col2 {
  background-color: #FFe4e4;
  color: black;
}
#T_c34df_row8_col3 {
  background-color: #FFa0a0;
  color: black;
}
#T_c34df_row9_col0 {
  background-color: #FFf9f9;
  color: black;
}
#T_c34df_row9_col1 {
  background-color: #FFd0d0;
  color: black;
}
#T_c34df_row9_col2 {
  background-color: #FFecec;
  color: black;
}
#T_c34df_row10_col0 {
  background-color: #efFFef;
  color: black;
}
#T_c34df_row10_col1 {
  background-color: #FF9393;
  color: black;
}
#T_c34df_row10_col2 {
  background-color: #beFFbe;
  color: black;
}
#T_c34df_row10_col3 {
  background-color: #f9FFf9;
  color: black;
}
#T_c34df_row11_col0 {
  background-color: #f0FFf0;
  color: black;
  background: lightblue;
}
#T_c34df_row11_col1 {
  background-color: #e1FFe1;
  color: black;
  background: lightblue;
}
#T_c34df_row11_col2 {
  background-color: #efFFef;
  color: black;
  background: lightblue;
}
#T_c34df_row11_col3 {
  background-color: #FFafaf;
  color: black;
  background: lightblue;
}
#T_c34df_row12_col0 {
  background-color: #69FF69;
  color: black;
  background: lightblue;
}
#T_c34df_row12_col1 {
  background-color: #6cFF6c;
  color: black;
  background: lightblue;
}
#T_c34df_row12_col2 {
  background-color: #6aFF6a;
  color: black;
  background: lightblue;
}
#T_c34df_row12_col3 {
  background-color: #77FF77;
  color: black;
  background: lightblue;
}
</style>
<table id="T_c34df">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_c34df_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_c34df_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_c34df_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_c34df_level0_col3" class="col_heading level0 col3" >ZFS</th>
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
      <th id="T_c34df_level0_row0" class="row_heading level0 row0" rowspan="7">read disk</th>
      <th id="T_c34df_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_c34df_row0_col0" class="data row0 col0" >1.0</td>
      <td id="T_c34df_row0_col1" class="data row0 col1" >2.3</td>
      <td id="T_c34df_row0_col2" class="data row0 col2" >0.9</td>
      <td id="T_c34df_row0_col3" class="data row0 col3" >0.4</td>
    </tr>
    <tr>
      <th id="T_c34df_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_c34df_row1_col0" class="data row1 col0" >1.0</td>
      <td id="T_c34df_row1_col1" class="data row1 col1" >1.1</td>
      <td id="T_c34df_row1_col2" class="data row1 col2" >0.9</td>
      <td id="T_c34df_row1_col3" class="data row1 col3" >0.7</td>
    </tr>
    <tr>
      <th id="T_c34df_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_c34df_row2_col0" class="data row2 col0" >0.8</td>
      <td id="T_c34df_row2_col1" class="data row2 col1" >1.5</td>
      <td id="T_c34df_row2_col2" class="data row2 col2" >0.7</td>
      <td id="T_c34df_row2_col3" class="data row2 col3" >0.2</td>
    </tr>
    <tr>
      <th id="T_c34df_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_c34df_row3_col0" class="data row3 col0" >1.0</td>
      <td id="T_c34df_row3_col1" class="data row3 col1" >2.2</td>
      <td id="T_c34df_row3_col2" class="data row3 col2" >0.9</td>
      <td id="T_c34df_row3_col3" class="data row3 col3" >0.5</td>
    </tr>
    <tr>
      <th id="T_c34df_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_c34df_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_c34df_row4_col1" class="data row4 col1" >1.0</td>
      <td id="T_c34df_row4_col2" class="data row4 col2" >0.9</td>
      <td id="T_c34df_row4_col3" class="data row4 col3" >0.5</td>
    </tr>
    <tr>
      <th id="T_c34df_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_c34df_row5_col0" class="data row5 col0" >0.8</td>
      <td id="T_c34df_row5_col1" class="data row5 col1" >1.5</td>
      <td id="T_c34df_row5_col2" class="data row5 col2" >0.8</td>
      <td id="T_c34df_row5_col3" class="data row5 col3" >0.2</td>
    </tr>
    <tr>
      <th id="T_c34df_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_c34df_row6_col0" class="data row6 col0" >9.1</td>
      <td id="T_c34df_row6_col1" class="data row6 col1" >8.6</td>
      <td id="T_c34df_row6_col2" class="data row6 col2" >9.0</td>
      <td id="T_c34df_row6_col3" class="data row6 col3" >6.5</td>
    </tr>
    <tr>
      <th id="T_c34df_level0_row7" class="row_heading level0 row7" rowspan="4">read disk write mem</th>
      <th id="T_c34df_level1_row7" class="row_heading level1 row7" >sequential read float large</th>
      <td id="T_c34df_row7_col0" class="data row7 col0" >0.8</td>
      <td id="T_c34df_row7_col1" class="data row7 col1" >0.7</td>
      <td id="T_c34df_row7_col2" class="data row7 col2" >0.8</td>
      <td id="T_c34df_row7_col3" class="data row7 col3" >0.5</td>
    </tr>
    <tr>
      <th id="T_c34df_level1_row8" class="row_heading level1 row8" >sequential read int huge</th>
      <td id="T_c34df_row8_col0" class="data row8 col0" >0.9</td>
      <td id="T_c34df_row8_col1" class="data row8 col1" >0.8</td>
      <td id="T_c34df_row8_col2" class="data row8 col2" >0.9</td>
      <td id="T_c34df_row8_col3" class="data row8 col3" >0.6</td>
    </tr>
    <tr>
      <th id="T_c34df_level1_row9" class="row_heading level1 row9" >sequential read int medium</th>
      <td id="T_c34df_row9_col0" class="data row9 col0" >1.0</td>
      <td id="T_c34df_row9_col1" class="data row9 col1" >0.8</td>
      <td id="T_c34df_row9_col2" class="data row9 col2" >0.9</td>
      <td id="T_c34df_row9_col3" class="data row9 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_c34df_level1_row10" class="row_heading level1 row10" >sequential read int small</th>
      <td id="T_c34df_row10_col0" class="data row10 col0" >1.2</td>
      <td id="T_c34df_row10_col1" class="data row10 col1" >0.5</td>
      <td id="T_c34df_row10_col2" class="data row10 col2" >2.0</td>
      <td id="T_c34df_row10_col3" class="data row10 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_c34df_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_c34df_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_c34df_row11_col0" class="data row11 col0" >1.1</td>
      <td id="T_c34df_row11_col1" class="data row11 col1" >1.3</td>
      <td id="T_c34df_row11_col2" class="data row11 col2" >1.2</td>
      <td id="T_c34df_row11_col3" class="data row11 col3" >0.6</td>
    </tr>
    <tr>
      <th id="T_c34df_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_c34df_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_c34df_row12_col0" class="data row12 col0" >9.1</td>
      <td id="T_c34df_row12_col1" class="data row12 col1" >8.6</td>
      <td id="T_c34df_row12_col2" class="data row12 col2" >9.0</td>
      <td id="T_c34df_row12_col3" class="data row12 col3" >6.5</td>
    </tr>
  </tbody>
</table>




**Observation**: ZFS excels in reading from disk if many kdb+ processes (HDB pool) reading the data in parallel. The only exception is read binary (`read1`) but this is not considered a typical query pattern in a production kdb+ environment




<style type="text/css">
#T_8e4e7 th.col_heading.level0 {
  font-size: 1.5em;
}
#T_8e4e7_row0_col0, #T_8e4e7_row0_col2, #T_8e4e7_row3_col0 {
  background-color: #f2FFf2;
  color: black;
}
#T_8e4e7_row0_col1 {
  background-color: #f4FFf4;
  color: black;
}
#T_8e4e7_row0_col3 {
  background-color: #eaFFea;
  color: black;
}
#T_8e4e7_row1_col0, #T_8e4e7_row1_col2, #T_8e4e7_row4_col2, #T_8e4e7_row6_col0, #T_8e4e7_row6_col1 {
  background-color: #feFFfe;
  color: black;
}
#T_8e4e7_row1_col1, #T_8e4e7_row2_col2, #T_8e4e7_row6_col2 {
  background-color: #fdFFfd;
  color: black;
}
#T_8e4e7_row1_col3 {
  background-color: #b6FFb6;
  color: black;
}
#T_8e4e7_row2_col0 {
  background-color: #FFfefe;
  color: black;
}
#T_8e4e7_row2_col1, #T_8e4e7_row4_col0 {
  background-color: #FFfbfb;
  color: black;
}
#T_8e4e7_row2_col3 {
  background-color: #b8FFb8;
  color: black;
}
#T_8e4e7_row3_col1 {
  background-color: #f8FFf8;
  color: black;
}
#T_8e4e7_row3_col2, #T_8e4e7_row5_col0 {
  background-color: #f6FFf6;
  color: black;
}
#T_8e4e7_row3_col3, #T_8e4e7_row10_col1 {
  background-color: #f3FFf3;
  color: black;
}
#T_8e4e7_row4_col1 {
  background-color: #FFfdfd;
  color: black;
}
#T_8e4e7_row4_col3 {
  background-color: #FFe1e1;
  color: black;
}
#T_8e4e7_row5_col1, #T_8e4e7_row6_col3 {
  background-color: #f1FFf1;
  color: black;
}
#T_8e4e7_row5_col2, #T_8e4e7_row5_col3 {
  background-color: #f9FFf9;
  color: black;
}
#T_8e4e7_row7_col0 {
  background-color: #c1FFc1;
  color: black;
}
#T_8e4e7_row7_col1 {
  background-color: #c0FFc0;
  color: black;
}
#T_8e4e7_row7_col2, #T_8e4e7_row8_col2 {
  background-color: #b4FFb4;
  color: black;
}
#T_8e4e7_row7_col3 {
  background-color: #7fFF7f;
  color: black;
}
#T_8e4e7_row8_col0, #T_8e4e7_row8_col1 {
  background-color: #c7FFc7;
  color: black;
}
#T_8e4e7_row8_col3 {
  background-color: #bbFFbb;
  color: black;
}
#T_8e4e7_row9_col0 {
  background-color: #bdFFbd;
  color: black;
}
#T_8e4e7_row9_col1 {
  background-color: #b7FFb7;
  color: black;
}
#T_8e4e7_row9_col2 {
  background-color: #beFFbe;
  color: black;
}
#T_8e4e7_row9_col3 {
  background-color: #6dFF6d;
  color: black;
}
#T_8e4e7_row10_col0 {
  background-color: #f0FFf0;
  color: black;
}
#T_8e4e7_row10_col2 {
  background-color: #75FF75;
  color: black;
}
#T_8e4e7_row10_col3 {
  background-color: #c5FFc5;
  color: black;
}
#T_8e4e7_row11_col0, #T_8e4e7_row11_col1 {
  background-color: #e8FFe8;
  color: black;
  background: lightblue;
}
#T_8e4e7_row11_col2 {
  background-color: #d5FFd5;
  color: black;
  background: lightblue;
}
#T_8e4e7_row11_col3 {
  background-color: #c2FFc2;
  color: black;
  background: lightblue;
}
#T_8e4e7_row12_col0 {
  background-color: #bdFFbd;
  color: black;
  background: lightblue;
}
#T_8e4e7_row12_col1 {
  background-color: #b7FFb7;
  color: black;
  background: lightblue;
}
#T_8e4e7_row12_col2 {
  background-color: #75FF75;
  color: black;
  background: lightblue;
}
#T_8e4e7_row12_col3 {
  background-color: #6dFF6d;
  color: black;
  background: lightblue;
}
</style>
<table id="T_8e4e7">
  <thead>
    <tr>
      <th class="blank" >&nbsp;</th>
      <th class="index_name level0" >filesystem</th>
      <th id="T_8e4e7_level0_col0" class="col_heading level0 col0" >ext4</th>
      <th id="T_8e4e7_level0_col1" class="col_heading level0 col1" >Btrfs</th>
      <th id="T_8e4e7_level0_col2" class="col_heading level0 col2" >F2FS</th>
      <th id="T_8e4e7_level0_col3" class="col_heading level0 col3" >ZFS</th>
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
      <th id="T_8e4e7_level0_row0" class="row_heading level0 row0" rowspan="6">read mem</th>
      <th id="T_8e4e7_level1_row0" class="row_heading level1 row0" >mmap,random read 1M</th>
      <td id="T_8e4e7_row0_col0" class="data row0 col0" >1.1</td>
      <td id="T_8e4e7_row0_col1" class="data row0 col1" >1.1</td>
      <td id="T_8e4e7_row0_col2" class="data row0 col2" >1.1</td>
      <td id="T_8e4e7_row0_col3" class="data row0 col3" >1.2</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level1_row1" class="row_heading level1 row1" >mmap,random read 4k</th>
      <td id="T_8e4e7_row1_col0" class="data row1 col0" >1.0</td>
      <td id="T_8e4e7_row1_col1" class="data row1 col1" >1.0</td>
      <td id="T_8e4e7_row1_col2" class="data row1 col2" >1.0</td>
      <td id="T_8e4e7_row1_col3" class="data row1 col3" >2.2</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level1_row2" class="row_heading level1 row2" >mmap,random read 64k</th>
      <td id="T_8e4e7_row2_col0" class="data row2 col0" >1.0</td>
      <td id="T_8e4e7_row2_col1" class="data row2 col1" >1.0</td>
      <td id="T_8e4e7_row2_col2" class="data row2 col2" >1.0</td>
      <td id="T_8e4e7_row2_col3" class="data row2 col3" >2.1</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level1_row3" class="row_heading level1 row3" >random read 1M</th>
      <td id="T_8e4e7_row3_col0" class="data row3 col0" >1.1</td>
      <td id="T_8e4e7_row3_col1" class="data row3 col1" >1.1</td>
      <td id="T_8e4e7_row3_col2" class="data row3 col2" >1.1</td>
      <td id="T_8e4e7_row3_col3" class="data row3 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level1_row4" class="row_heading level1 row4" >random read 4k</th>
      <td id="T_8e4e7_row4_col0" class="data row4 col0" >1.0</td>
      <td id="T_8e4e7_row4_col1" class="data row4 col1" >1.0</td>
      <td id="T_8e4e7_row4_col2" class="data row4 col2" >1.0</td>
      <td id="T_8e4e7_row4_col3" class="data row4 col3" >0.9</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level1_row5" class="row_heading level1 row5" >random read 64k</th>
      <td id="T_8e4e7_row5_col0" class="data row5 col0" >1.1</td>
      <td id="T_8e4e7_row5_col1" class="data row5 col1" >1.1</td>
      <td id="T_8e4e7_row5_col2" class="data row5 col2" >1.1</td>
      <td id="T_8e4e7_row5_col3" class="data row5 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level0_row6" class="row_heading level0 row6" rowspan="5">read mem write mem</th>
      <th id="T_8e4e7_level1_row6" class="row_heading level1 row6" >sequential read binary</th>
      <td id="T_8e4e7_row6_col0" class="data row6 col0" >1.0</td>
      <td id="T_8e4e7_row6_col1" class="data row6 col1" >1.0</td>
      <td id="T_8e4e7_row6_col2" class="data row6 col2" >1.0</td>
      <td id="T_8e4e7_row6_col3" class="data row6 col3" >1.1</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level1_row7" class="row_heading level1 row7" >sequential reread float large</th>
      <td id="T_8e4e7_row7_col0" class="data row7 col0" >1.9</td>
      <td id="T_8e4e7_row7_col1" class="data row7 col1" >1.9</td>
      <td id="T_8e4e7_row7_col2" class="data row7 col2" >2.3</td>
      <td id="T_8e4e7_row7_col3" class="data row7 col3" >5.4</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level1_row8" class="row_heading level1 row8" >sequential reread int huge</th>
      <td id="T_8e4e7_row8_col0" class="data row8 col0" >1.8</td>
      <td id="T_8e4e7_row8_col1" class="data row8 col1" >1.8</td>
      <td id="T_8e4e7_row8_col2" class="data row8 col2" >2.2</td>
      <td id="T_8e4e7_row8_col3" class="data row8 col3" >2.1</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level1_row9" class="row_heading level1 row9" >sequential reread int medium</th>
      <td id="T_8e4e7_row9_col0" class="data row9 col0" >2.0</td>
      <td id="T_8e4e7_row9_col1" class="data row9 col1" >2.2</td>
      <td id="T_8e4e7_row9_col2" class="data row9 col2" >2.0</td>
      <td id="T_8e4e7_row9_col3" class="data row9 col3" >8.3</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level1_row10" class="row_heading level1 row10" >sequential reread int small</th>
      <td id="T_8e4e7_row10_col0" class="data row10 col0" >1.1</td>
      <td id="T_8e4e7_row10_col1" class="data row10 col1" >1.1</td>
      <td id="T_8e4e7_row10_col2" class="data row10 col2" >6.8</td>
      <td id="T_8e4e7_row10_col3" class="data row10 col3" >1.8</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level0_row11" class="row_heading level0 row11" >GEOMETRIC MEAN</th>
      <th id="T_8e4e7_level1_row11" class="row_heading level1 row11" ></th>
      <td id="T_8e4e7_row11_col0" class="data row11 col0" >1.2</td>
      <td id="T_8e4e7_row11_col1" class="data row11 col1" >1.2</td>
      <td id="T_8e4e7_row11_col2" class="data row11 col2" >1.5</td>
      <td id="T_8e4e7_row11_col3" class="data row11 col3" >1.9</td>
    </tr>
    <tr>
      <th id="T_8e4e7_level0_row12" class="row_heading level0 row12" >MAX RATIO</th>
      <th id="T_8e4e7_level1_row12" class="row_heading level1 row12" ></th>
      <td id="T_8e4e7_row12_col0" class="data row12 col0" >2.0</td>
      <td id="T_8e4e7_row12_col1" class="data row12 col1" >2.2</td>
      <td id="T_8e4e7_row12_col2" class="data row12 col2" >6.8</td>
      <td id="T_8e4e7_row12_col3" class="data row12 col3" >8.3</td>
    </tr>
  </tbody>
</table>




**Observation**: The performance advantage of ZFS vanishes entirely when data is served from the page cache.
