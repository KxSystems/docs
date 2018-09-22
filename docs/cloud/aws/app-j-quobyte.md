hero: <i class="fa fa-cloud"></i> Cloud

# Appendix J – Quobyte 



!!! info "Quobyte is functionally qualified with kdb+."

Quobyte offers a shared namespace solution based on either locally-provisioned or EBS-style storage. 
It leverages an erasure-coding model around nodes of a Quobyte cluster.

test | result
-----|-------
throughput | Multiple thread read saturated the ingest bandwidth of each `r4.4xlarge` instance running kdb+.
fileops attributes | _Test results to follow, please check back at code.kx.com for full results._

