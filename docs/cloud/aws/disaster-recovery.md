hero: <i class="fa fa-cloud"></i> Cloud

# Disaster recovery

In addition to EC2’s built-in disaster-recovery features, when you use
kdb+ on EC2, your disaster recovery process is eased by kdb+’s simple,
elegant design.

Kdb+ databases are stored as a series of files and directories on disk.
This makes administering databases extremely easy because database files
can be manipulated as operating-system files. Backing up a kdb+ database
can be implemented using any standard file-system backup utility. This
is a key difference from traditional databases, which have to have their
own cumbersome backup utilities and do not allow direct access to the
database files and structure.

Kdb+’s use of the native file system is also reflected in the way it
uses standard operating-system features for accessing data
(memory-mapped files), whereas traditional databases use proprietary
techniques in an effort to speed up the reading and writing processes.
The typical kdb+ database layout for time-series data is to partition by
date.


