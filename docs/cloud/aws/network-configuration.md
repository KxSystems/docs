# Network configuration



The network configuration used in the tests:

The host build was CentOS 7.4, with Kernel 3.10.0-693.el7.x86\_64. The ENS module was installed but not configured. The default instance used in these test reports was `r4.4xlarge`. 

Total network bandwidth on this model is “up-to” 10&nbsp;Gbps. 

For storage, this is documented by AWS as provisioning up to 3,500&nbsp;Mbps, equivalent to 437&nbsp;MB/sec of EBS bandwidth, per node, bi-directional. We met these discrete values as seen in most of our individual kdb+ tests.


