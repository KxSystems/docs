---
title: Amazon Web Services | Auto Scaling for a kdb+ realtime database | Cloud | kdb+ and q documentation
description: AWS resources used to autoscale a cloud deployment of kdb+ realtime database
author: Jack Stapleton
date: September 2020
---
# Amazon Web Services (AWS)



The solution described here was developed and deployed on Amazon Web Services (AWS).
In this section the AWS resources that were used are described, each of which should be transferable to the other big cloud platforms like Microsoft Azure and Google Cloud.


## Amazon Machine Image (AMI)

In the solution multiple servers are launched, all needing the same code and software packages installed in order to run our kdb+ system.
Instead of launching the servers and then installing the needed software on each one, it is best practice to do it on one server, create an Amazon Machine Image (AMI) of that server and then use that image to launch all of the servers.
This will keep the software and code consistent across the deployment.

To create our AMI a regular EC2 instance was launched using Amazon’s Linux 2 AMI, kdb+ was installed, our code was deployed and an image of the instance was taken.

:fontawesome-brands-github:
[An example script of how to do this](https://github.com/kxcontrib/cloud-autoscaling/blob/master/ami-user-data.sh)

Once available this AMI was used along with Cloudformation to deploy a stack.


## Cloudformation

Using AWS Cloudformation means we can easily deploy and manage our system’s resources with a JSON or YAML file.
The resources needed for our stack are outlined below.

-   AWS Elastic File System (EFS).
-   EC2 launch templates.
-   Auto Scaling groups.

:fontawesome-brands-github:
[An example YAML file to deploy this stack](https://github.com/kxcontrib/cloud-autoscaling/blob/master/cloudformation-template.yml)


### AWS Elastic File System (EFS)

In our system the RDB and tickerplant will be on different servers but both processes will need access to the tickerplant’s logs.
For simplicity we will write the logs to EFS, a network file system which all of our EC2 instances can mount.

In high volume systems EFS will not be fast enough for the tickerplant so it will need to write its logs to local disk.
A separate process will then be needed on the server to read and stream the logs to the RDB in the case RDB replay.
The code snippet below can be used to do so.

```q
.u.stream:{[tplog;start;end]
    .u.i:0;
    .u.start:start;
    -11!(tplog;end);
    delete i, start from `.u; }

upd: {if[.u.start < .u.i+:1; neg[.z.w] @ (`upd;x;y); neg[.z.w][]]};
```


### EC2 launch template

We will use launch templates to configure details for EC2 instances ahead of time (e.g. instance type, root volume size, AMI ID).
Our Auto Scaling groups will then use these templates to launch their servers.


## Auto Scaling group (ASG)

AWS EC2 Auto Scaling groups (ASG) can be used to maintain a given number of EC2 instances in a cluster.


### Recovery

The first Auto Scaling group we deploy will be for the tickerplant.
Even though there will only ever be one instance for the tickerplant we are still putting it in an ASG for recovery purposes.
If it goes down the ASG will automatically start another one.


### Scalability

There are a number of ways an ASG can scale its instances on AWS:

scaling | method
--------|---------
Scheduled | Timeframes are set to scale in and out.
Predictive | Machine learning is used to predict demand.
Dynamic | Cloudwatch metrics are monitored to follow the flow of demand (e.g. CPU and memory usage).
Manual | Adjusting the ASG’s `DesiredCapacity` attribute.


### Dynamic Scaling

We could conceivably publish memory usage statistics as Cloudwatch metrics from our RDBs and allow AWS to manage scaling out.
If the memory across the cluster rises to a certain point the ASG will increment its `DesiredCapacity` attribute and launch a new server.

Sending custom Cloudwatch metrics is relatively simple: 

:fontawesome-brands-github:
Examples using either [Python’s boto3 library](https://github.com/kxcontrib/cloud-autoscaling/blob/master/auto-scaling.py) or the [AWS CLI](https://github.com/kxcontrib/cloud-autoscaling/blob/master/auto-scaling.sh)



### Manual scaling

Another way to scale the instances in an ASG, and the method more suitable for our use case, is to manually adjust the ASG’s `DesiredCapacity`.
This can be done via the AWS console or the AWS CLI.

As it can be done using the CLI we can program the RDBs to scale the cluster in and out.
Managing the Auto Scaling within the application is preferable because we want to be specific when scaling in.

If scaling in was left up to AWS it would choose which instance to terminate based on certain criteria (e.g. instance count per availability zone, time to the next next billing hour).
However, if all of the criteria have been evaluated and there are still multiple instances to choose from, AWS will pick one at random.

Under no circumstance do we want AWS to terminate an instance running an RDB process which is still holding live data.
So we will need to keep control of the Auto Scaling group’s `DesiredCapacity` within the application.

As with publishing Cloudwatch metrics, adjusting the `DesiredCapacity` can be done with Python’s boto3 library or the AWS CLI.

:fontawesome-brands-github:
Examples with [Python](https://github.com/kxcontrib/cloud-autoscaling/blob/master/cloudwatch-metric.py) and the [AWS CLI](https://github.com/kxcontrib/cloud-autoscaling/blob/master/cloudwatch-metric.sh)


### Auto Scaling in q

As the AWS CLI simply uses Unix commands we can run them in `q` using the `system` command.
By default the CLI will return `json` so we can parse the result using `.j.k`.
It will be useful to wrap the `aws` system commands in a retry loop as they may timeout when AWS is under load.

```q
.util.sys.runWithRetry:{[cmd]
    n: 0;
    while[not last res:.util.sys.runSafe cmd;
            system "sleep 1";
            if[10 < n+: 1; 'res 0];
            ];
    res 0 }

.util.sys.runSafe: .Q.trp[{(system x;1b)};;{-1 x,"\n",.Q.sbt[y];(x;0b)}]
```

To adjust the `DesiredCapacity` of an ASG we first need to find the correct group.
To do this we will use the `aws ec2` functions to find the `AutoScalingGroupName` that the RDB server belongs to.

```q
.util.aws.getInstanceId: {last " " vs first system "ec2-metadata -i"};

.util.aws.describeInstance:{[instanceId]
    res: .util.sys.runWithRetry
      "aws ec2 describe-instances --filters  \"Name=instance-id,Values=",instanceId,"\"";
    res: (.j.k "\n" sv res)`Reservations;
    if[() ~ res; 'instanceId," is not an instance"];
    flip first res`Instances }

.util.aws.getGroupName:{[instanceId]
    tags: .util.aws.describeInstance[instanceId]`Tags;
    res: first exec Value from raze[tags] where Key like "aws:autoscaling:groupName";
    if[() ~ res; 'instanceId," is not in an autoscaling group"];
    res }
```

To increment the capacity we can use the `aws autoscaling` functions to find the current `DesiredCapacity`.
Once we have this we can increment it by one and set the attribute.
The ASG will then automatically launch a server.

```q
.util.aws.describeASG:{[groupName]
    res: .util.sys.runWithRetry
      "aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name ",groupName;
    res: flip (.j.k "\n" sv res)`AutoScalingGroups;
    if[() ~ res; 'groupName," is not an autoscaling group"];
    res }

.util.aws.getDesiredCapacity:{[groupName]
    first .util.aws.describeASG[groupName]`DesiredCapacity }

.util.aws.setDesiredCapacity:{[groupName;n]
    .util.sys.runWithRetry
      aws autoscaling set-desired-capacity --auto-scaling-group-name ",
      groupName," --desired-capacity ",string n }

.util.aws.scale:{[groupName]
    .util.aws.setDesiredCapacity[groupName] 1 + .util.aws.getDesiredCapacity groupName; }
```

To scale in, the RDB will terminate its own server.
When doing this it must make an `aws autoscaling` call, the ASG will then know not to launch a new instance in its place.

```q
.util.aws.terminate:{[instanceId]
    .j.k "\n" sv .util.sys.runWithRetry
      "aws autoscaling terminate-instance-in-auto-scaling-group --instance-id ",
      instanceId," --should-decrement-desired-capacity" }
```



