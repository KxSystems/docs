hero: <i class="fa fa-cloud"></i> Cloud

# Licensing kdb+ in the Cloud


Existing kdb+ users have a couple of options for supporting their kdb+
licenses in the Cloud:


## Existing license

You can use your existing license entitlement but must transfer or register coverage in the Cloud service. This would consume the specified number of cores from your license pool. An enterprise license can be freely used in EC2 instance(s). This might apply in the situation where the Cloud environment is intended to be a permanent static instance. Typically, this will be associated with a virtual private cloud (VPC) service. For example, AWS lets you provision a logically isolated section of the Cloud where you can launch AWS resources in a virtual network. The virtual network is controlled by your business, including the choice of IP, subnet, DNS, names, security, access, etc.


## On-demand licensing

You can sign up for an on-demand license, and use it to enable kdb+ on each of the on-demand EC2 nodes. Kdb+ on-demand usage registers by core and by minutes of execution.


