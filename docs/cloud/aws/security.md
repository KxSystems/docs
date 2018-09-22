---
hero: Cloud
---

# Security of your data and secure access

The EC2 application machine image model (AMI) has tight security models in place. 
You would have to work very hard to remove these.

The following diagram is a typical scenario for authenticating access to
kdb+ and restricting networking access. The frontend and backend private
subnets are provisioned by default with one Virtual Private Cloud (VPC)
managed by EC2. Typically, this allocates an entire class-C subnet. You
may provision up to 200 class-C subnets in EC2. The public access may be
direct to either of these domains, or you may prefer to setup a classic
‘demilitarized zone’:

![Typical scenario for authenticating access](img/media/image6.png)

Amazon has spent a lot of time developing [security features for EC2](https://aws.amazon.com/security/).
Key issues:

-   A newly-provisioned node comes from a trusted build image, for example, one found in the AWS Marketplace.
-   The Amazon Linux AMI Security Center provides patch and fix lists, and these can be automatically inlaid by the AMI. The Amazon Linux AMI is a supported and maintained Linux image provided by AWS for use on EC2.
-   Encryption at rest is offered by many of the storage interfaces covered in this report.

<i class="far fa-hand-point-right"></i> [Amazon Security](https://aws.amazon.com/blogs/security/)


