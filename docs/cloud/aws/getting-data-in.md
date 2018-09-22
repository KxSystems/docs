hero: <i class="fa fa-cloud"></i> Cloud

# Getting your data into EC2 

Let’s suppose you already have a lot of data for your historical
database (HDB). You will need to know the achievable bandwidth for data
loading, and note that you will be charged by the amount of data
ingested. The mechanics of loading a large data set from your data
center which hosts the HDB into EC2 involves the use of at least one of
the two methods described below.


## EC2 Virtual Private Cloud 

We would expect kdb+ customers to use the EC2 Virtual Private Cloud
(VPC) network structure. Within the VPC you can use either an anonymous
IP address, using EC2 DHCP address ranges, or a permanently-allocated IP
address range. The anonymous DHCP IP address range is free of charge.
Typically you would deploy both the front and backend domains (subnets)
within the same VPC, provisioned and associated with each new instance
in EC2. Typically, an entire VPC allocates an entire class-C subnet. You
may provision up to 200 class-C subnets in EC2, as one account. Public
IP addresses are reachable from the internet and are either dynamically
allocated on start, or use the same pre-defined elastic IP address on
each start of the instance.

Private IP addresses refer to the locally defined IP addresses only
visible to your cluster (e.g. the front/backend in diagram below).
Private IP addresses are retained by that instance until the instance is
terminated. Public access may be direct to either of these domains, or
you may prefer to set up a classic [‘demilitarized zone’](security.md) for kdb+ access.

An elastic IP address is usually your public IPv4 address, known to your
quants/users/applications, and is reachable from the Internet and
registered permanently in DNS, until you terminate the instance or
elastic IP. AWS has added support for IPv6 in most of their regions. An
elastic IP address can mask the failure of an instance or software by
remapping the address to another instance in your estate. That is handy
for things such as GUIs and dashboards, though you should be aware of
this capability and use it. You are charged for the elastic IP address
if you close down the instance associated with it, otherwise one IP
address is free when associated. As of January 2018 the cost is, $0.12
per Elastic IP address/day when not associated with a running instance.
Additional IP addresses per instance are charged.

Ingesting data can be via the public/elastic IP address. In this case,
routing to that connection is via undefined routers. The ingest rate to
this instance using this elastic IP address would depend on the
availability zone chosen. But in all cases, this would be a shared pubic
routed IP model, so transfer rates may be outside your control.

In theory this uses publicly routed connections, so you may wish to
consider encryption of the data over the wire, prior to decryption.


## Direct Connect 

Direct Connect is a dedicated network connection between an access point
to your existing IP network and one of the AWS Direct Connect locations.
This is a dedicated physical connection offered as a VLAN, using
industry standard 802.1q VLAN protocol. You can use AWS Direct Connect
instead of establishing your own VPN connection over the internet to
VPC. Specifically, it can connect through to a VPC domain using a
private IP space. It also gives a dedicated service level for bandwidth.
There is an additional charge for this service.

