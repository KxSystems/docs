---
title: Data At Rest Encryption (DARE) | Knowledge Base | Documentation for kdb+ and q
description: Data-at-rest encryption with kdb+, including Transparent Disk Encryption 
author: Charles Skelton
date: March 2020
---
# :fontawesome-solid-lock: Data At Rest Encryption (DARE)

![Encryption](../img/encryption.jpg)
<!-- GettyImages-1084312676 -->

Data security is an ever-evolving domain, especially in recent years as storage-devices become increasingly more portable, or accessible remotely, and the environment they operate within becomes more hostile. 
The increased demand for [BYOD](https://en.wikipedia.org/wiki/Bring_your_own_device "Wikipedia"), remote-working, cloud, and mobile devices increases the possibility of a user-account breach, and/or the theft or loss of physical assets. Ideally, companies will have taken precautions to encrypt their files, so that even in the event that they fall into the wrong hands, they cannot be read without authorization.

Full disk encryption (FDE) has been available on multiple operating systems for several years. Unfortunately, FDE often doesn’t satisfy all requirements for Data At Rest Encryption (DARE), hence there is also demand for Transparent Disk Encryption (TDE). This is now available in kdb+ 4.0.


## Transparent Disk Encryption (TDE)

TDE solves the problem of protecting data at rest, by encrypting database files on the hard drive and consequently also on backup media.

TDE, like file compression, is fully transparent to queries in kdb+; queries require no change to operate on compressed or encrypted data.


## What advantage does TDE have over Full Disk Encryption?

Examples of FDE products are [cryptsetup + LUKS](https://gitlab.com/cryptsetup) on Linux, [BitLocker](https://en.wikipedia.org/wiki/BitLocker "Wikipedia") on Windows, or [FileVault](https://en.wikipedia.org/wiki/FileVault "Wikipedia") on macOS. These encrypt the entire disk with a symmetric cipher, using a key protected by a passphrase.

Enterprises typically employ TDE to solve compliance issues such as [PCI-DSS](https://en.wikipedia.org/wiki/Payment_Card_Industry_Data_Security_Standard), which require the protection of data at rest.

As TDE decrypts the data inside the kdb+ process, rather than at the OS/storage level, data remains encrypted when it comes across the wire from remote storage.

Encryption is selective – encrypt only the files that need encrypting.

Files can be archived, or copied, across environments without going through a decryption and encryption cycle.

Kdb+ is multi-platform, and as the file format is platform-agnostic, the same encrypted files can be accessed from multiple platforms.

Maintain key and process ownership and separation of responsibilities: the DBA holds TDE keys, the server admin holds FDE keys.


## Availability

All editions of kdb+ 4.0 support TDE.


## Prerequisites

Although kdb+ encryption requires at least OpenSSL library v1.0.2, we recommend using the latest available version. The openssl version loaded into kdb+ is reported via 
```q
(-26!)[]`SSLEAY_VERSION
```

However, to generate the master key, OpenSSL 1.1.1 is required due to the additional PBKDF2 functionality. The version is reported at the OS shell command line via 

```bash
$ openssl version
OpenSSL 1.1.1d  10 Sep 2019
```

###AES-NI

The Intel Advanced Encryption Standard (AES) New Instructions [(AES-NI)](https://www.intel.com/content/www/us/en/architecture-and-technology/advanced-encryption-standard-aes/data-protection-aes-general-technology.html) engine is available for certain Intel processors, and allows for extremely fast hardware encryption and decryption using aes. The AES-NI engine in OpenSSL is automatically enabled if the detected processor has AES-NI. The following test reveals whether your processor has AES-NI in its instruction set:

```bash
$ grep -m1 -o aes /proc/cpuinfo
aes
```

To compare the performance of AES-NI versus no AES-NI, run the following commands and compare their outputs. 
(The outputs below have been abbreviated.)

The numbers reported are in 1000s of bytes per second processed.

```bash
$ openssl speed aes-128-cbc
type             16 bytes     64 bytes     256 bytes    1024 bytes   8192 bytes
aes-128 cbc      93572.13k    101100.84k   102865.41k   103882.57k   103697.07k
$ openssl speed -evp aes-128-cbc
type             16 bytes     64 bytes     256 bytes    1024 bytes   8192 bytes
aes-128-cbc      562725.00k   596856.68k   608495.90k   608907.26k   609640.45k
```

A significantly better performance of the `-evp` option indicates that AES-NI is enabled.

Additionally, once you have created a master key, one can verify that the OpenSSL library has support for AES-NI via a benchmark test in q, comparing default to disabled AES-NI support. e.g.
with script `ebench.q` as

```q
-36!(`:testkek.key;"mypassword")
(`:etest;20;16;0)set 100000000?10000
system"ts max get`:etest"
```

Execute the default, AES-NI enabled if detected, as
```bash
$q ebench.q
```

Compare to AES-NI disabled using the OPENSSL_ia32cap environment variable, as

```bash
$OPENSSL_ia32cap="~0x200000200000000" q ebench.q
```

The performance difference between AES and AES-NI was observed to be around 400% for this test.


## Configuration

A password-protected master key is required.
Choose a unique, high-entropy password which would withstand a dictionary attack; a poorly chosen password can become the weakest link in encryption.


!!! tip "Use a cryptographically secure pseudorandom number generator (CSPRNG) to generate a random 256-bit AES key, and password protect it."

OpenSSL uses a CSPRNG for its rand command. The master key can be generated using standard command-line tools using: 

```bash
$ openssl rand 32 | openssl aes-256-cbc -md SHA256 -salt -pbkdf2 -iter 50000 -out testkek.key # Prompts for the new password
```

!!! tip "Back up this key file and the associated password"

    Back up this key file and the password to open it, but keep them separate and in a secure location – perhaps even deposit them in escrow for key recovery. If either of these is lost, any data encrypted using it will become inaccessible.

Place this password-protected key file above or outside of your HDB base directory; it will need to be loaded into kdb+ to enable [de|en]cryption.

Take precautions to restrict remote users from accessing this file directly. This can be done, for example, by ensuring all remote queries execute through `reval` by setting the message handlers. e.g.

```q
.z.pg:{reval(value;enlist x)}
```
Ensure all the other message handlers are initialized accordingly. See:

:fontawesome-solid-graduation-cap:
[Firewalling](firewalling.md)

Then, load the key file using

```q
-36!(`:pathtokeyfile;"passwordforkeyfile")
```


## Encryption

Files can be encrypted using the same command as for file compression, with [AES256CBC](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard "Wikipedia") encryption as algo 16.

The master key must already be loaded, via internal function [`-36!`](../basics/internal.md#-36xy-load-master-key).

Recalling that the left-hand arguments for encoded `set` are
(target filename; logical block size; compression/encryption algorithm; compression level)

Individual files can be encrypted as e.g.

```q
(`:ztest;17;2;6) set asc 10000?`3 / compress to an individual file
(`:ztest;17;2+16;6) set asc 10000?`3 / compress and encrypt to an individual file
(`:ztest;17;16;6) set asc 10000?`3 / encrypt an individual file
```

Or use [`.z.zd`](../ref/dotz.md#zzd-zip-defaults) for a process-wide default setting for all qualifying files.

```q
.z.zd:17  2 6     / zlib compression
.z.zd:17 16 6     / aes256cbc encryption only
.z.zd:(17;2+16;6) / zlib compression, with aes256cbc encryption arguments to set override those from .z.zd.
```

When using the global setting `.z.zd`, files which do not qualify for encryption are filenames with an extension. e.g. `abc.bin`, `.d`.

Encryption adds a small amount of data, depending on the logical block size chosen, amounting to less than 2% of the overall size for typical DB files. The encoded size is reported via the command [`-21!filename`](../basics/internal.md#-21x-compression-stats).

## File locking

Encrypted enumeration domain files are locked for writing during an append, e.g.

```q
q)`:sym?`new`symbols`here
```

!!! warning They must not be read from during the append.

## Decryption

The master key must already be loaded, via the `-36!` command.
Decryption is transparent to a query, just as is decompression.


## Performance

We strongly recommend users of encryption to use AES-NI capable CPUs; this is actually the most likely scenario for modern systems.
Encryption overhead is a few % when already using compression.

## Changing the password for the master key

Sometimes compliance requires passwords to be changed at regular intervals. The password for the master key can be changed as follows:

```bash
# Change password for master key:
# Prompt for existing password
key=`openssl aes-256-cbc -md SHA256 -d -iter 50000 -in testkek.key`  
# Prompt for a new password
echo $key | openssl aes-256-cbc -md SHA256 -salt -pbkdf2 -iter 50000 -out newtestkek.key  
# Remove the raw key from the environment
unset key 
```

Confirm that the `newtestkek.key` works by loading it into kdb+, and decrypting the existing data with it.

Then archive `testkek.key`, rename `newtestkek.key` to `testkek.key`, and update the password to be used in the `-36!` call.

This does not change the encryption key itself. To change that, a more involved process is required, which would then re-encrypt all the data.


## Limitations

The schema in kdb+ is not encrypted, as this is visible in the directory and file names. The column name file for splay, `.d`, is also not encrypted.


## Technical details

Compressed files have the 8-byte header "kxzipped"; encrypted files, which may also be compressed, have the header "kxzippEd".

Kdb+ uses a symmetric cipher, AES256CBC – Advanced Encryption Standard (AES), with a 256-bit key size, in Cipher-Block-Chaining (CBC) mode.

The meta data of a file is encrypted using the master key, contains the encrypted data encryption key, and is authenticated via HMAC-SHA256. It uses [Encrypt then MAC (EtM)](https://en.wikipedia.org/wiki/Authenticated_encryption#Encrypt-then-MAC_(EtM) "Wikipedia").

There is one master key, which is password-protected, and a unique data encryption key is used per file.

The master key is encrypted with a symmetric cipher with a key produced from a passphrase using PBKDF2 (Password-Based Key Derivation Function 2), a key-derivation function with a sliding computational cost, used to reduce vulnerabilities to brute-force attacks. The important factor on the computation complexity of PBKDF2 is key-stretching, here, the number of hash-iterations used. High values increase the time required to brute-force the resulting file. The higher the number of iterations, the fewer the number of challenges that can be performed per second, thereby impeding a brute-force attack.

Choosing high-entropy passwords could significantly extend the amount of time required to crack the password. Remember high entropy is not enough – don’t reuse passwords, or passwords that are easily guessed by dictionary attacks. Human errors, such as choosing a weak password, or storing the key file and password in insecure areas, can leave encryption much weaker than desired, resulting in a false sense of security.

:fontawesome-solid-unlock:
[Password strength test](http://rumkin.com/tools/password/passchk.php)

[Password entropy](https://en.wikipedia.org/wiki/Password_strength) is a measurement of how unpredictable a password is. Aim for an entropy of >80.

[![XKCD: password strength](https://imgs.xkcd.com/comics/password_strength.png)](https://www.xkcd.com/936/)


## Compression with encryption

Due to the nature of encryption, in that the encrypted data must be indistinguishable from random data, there is little to gain from attempting to compress encrypted data. Hence kdb+ offers the combination of ‘compress then encrypt’. 

Depending on your threat model, combining compression and encryption can introduce security issues, and you should be aware that information can be leaked through a compression-ratio side channel. If you’re not sure whether you’re leaking information through compression, do not combine it with encryption.


## Roadmap

These are some of the points of research on our encryption roadmap.

### Authenticated Encryption (AE) Ciphers

Kdb+ presently provides for confidentiality but not integrity beyond the meta block.

:fontawesome-brands-wikipedia-w:
[Authenticated encryption](https://en.wikipedia.org/wiki/Authenticated_encryption "Wikipedia")


### Multiple keys per process

One of the most profound challenges related to encryption is key management due to its associated complexity and cost. Unclear key management function, lack of skilled professionals, and fragmented Key Management Systems (KMS) increase the overheads for enterprises.


### Integration with

-   [Microsoft Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/)
-   [AWS Key Management Service](https://aws.amazon.com/kms/)
-   [Google Cloud Key Management Service](https://cloud.google.com/kms/)
-   [Key Management Interoperability Protocol (KMIP)](https://en.wikipedia.org/wiki/Key_Management_Interoperability_Protocol)


## Further reading

:fontawesome-solid-book:
[_Understanding Cryptography: A Textbook for Students and Practitioners_](https://www.amazon.com/Understanding-Cryptography-Textbook-Students-Practitioners/dp/3642041000)
<br>
:fontawesome-solid-book:
[_An Introduction to Mathematical Cryptography_](https://www.amazon.com/Introduction-Mathematical-Cryptography-Undergraduate-Mathematics/dp/1493917102)
<br>
:fontawesome-solid-book:
[_Cryptography Made Simple_](https://www.amazon.com/Cryptography-Made-Simple-Information-Security/dp/3319219359)
<br>
:fontawesome-solid-book:
[_Serious Cryptography: A Practical Introduction to Modern Encryption_](https://www.amazon.com/Serious-Cryptography-Practical-Introduction-Encryption/dp/1593278268)
<br>
:fontawesome-solid-globe:
[coursera.org](https://www.coursera.org/learn/crypto)

