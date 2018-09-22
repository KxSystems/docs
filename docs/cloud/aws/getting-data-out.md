hero: <i class="fa fa-cloud"></i> Cloud

# Getting your data out of EC2


Storing billions and billions of records under kdb+ in EC2 is easily achievable. Pushing the data into EC2 can be easily done and in doing so incurs no data transfer charges from AWS. But AWS will charge you to extract this information from EC2. For example, network charges may apply if you wish to extract data to place into other visualization tools/GUIs, outside the domain of kdb+ toolsets.


## Replication

Or you may be replicating data from one region or availability zone, to another. For this, there is a cost involved. At time of writing, the charges are \$.09/GB (\$92/TB), or \$94,200 for 1&nbsp;PB transferred out to the Internet via EC2 public IP addresses. That is raw throughput measurements, not the raw GBs of kdb+ columnar data itself. This is billed by AWS at a pro-rated monthly rate. The rate declines as the amount of data transferred increases. This rate also applies for all general traffic over a VPN to your own data center. Note that normal Internet connections carry no specific service-level agreements for bandwidth.


## Network Direct

If you use the Network Direct option from EC2, you get a dedicated network with guaranteed bandwidth. You then pay for the dedicated link, plus the same outbound data transfer rates. For example, as of January 2018 the standard charge for a dedicated 1&nbsp;GB/sec link to EC2 would cost $220/month plus $90/month for a transfer fee per TB.

Consider these costs when planning to replicate HDB data between regions, and when exporting your data continually back to your own data center for visualization or other purposes. Consider the migration of these tools to coexist with kdb+ in the AWS estate, and if you do not, consider the time to export the data. 


