hero: <i class="fa fa-cloud"></i> Cloud

# Data locality

Data locality is the basic architectural decision.

You will get the best storage performance in EC2 by localizing the data
to be as close to the compute workload as is possible.

EC2 is divided into various zones. Compute, storage and support software
can all be placed in pre-defined availability zones. Typically these
reflect the timezone location of the data center, as well as a further
subdivision into a physical instance of the data center within one
region or time zone. Kdb+ will achieve the lowest latency and highest
bandwidth in the network by using nodes and storage hosted in the same
availability zone.


