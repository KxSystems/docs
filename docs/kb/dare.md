---
title: Data At Rest Encryption (DARE) | Knowledge Base | Documentation for kdb+ and q
description: Data-at-rest encryption with kdb+, including Transparent Disk Encryption 
author: Charles Skelton
date: March 2020
---
# <i class="fas fa-lock"></i> Data At Rest Encryption (DARE)



![Encryption](../img/encryption.jpg)
<!-- GettyImages-1084312676 -->

Data security is an ever-evolving domain, especially in recent years. 
With the increased connectivity of [BYOD](https://en.wikipedia.org/wiki/Bring_your_own_device "Wikipedia"), remote-working, cloud, mobile-devices resulting in user-account breaches, and theft or loss of physical assets, companies are obliged to continuously review their security requirements. 

On-the-wire communications have long been encrypted, with Google switching to TLS by default, not only to provide confidentiality, but also to inhibit code injection. Full disk encryption (FDE) has been available on multiple operating systems for several years, the performance overhead of both markedly reduced when Intel baked in AES new instructions [(AES-NI)](https://www.intel.com/content/www/us/en/architecture-and-technology/advanced-encryption-standard-aes/data-protection-aes-general-technology.html) into their chips. 

Unfortunately, FDE often doesn’t satisfy all requirements for Data At Rest Encryption (DARE), hence there is also demand for Transparent Disk Encryption (TDE). This is now available within kdb+.


## Transparent Disk Encryption (TDE)

TDE solves the problem of protecting data at rest, encrypting databases both on the hard drive and consequently on backup media. 

Data over the wire, in-memory, and on clients are not encrypted. Use SSL/TLS for encryption over the wire.

TDE is transparent to queries in kdb+.


## What advantage does TDE have over Full Disk Encryption?

Examples of FDE products are [cryptsetup + LUKS](https://gitlab.com/cryptsetup) on Linux, [BitLocker](https://en.wikipedia.org/wiki/BitLocker "Wikipedia") on Windows, or [FileVault](https://en.wikipedia.org/wiki/FileVault "Wikipedia") on macOS. These encrypt the entire disk with a symmetric cipher, with a key protected by a passphrase.

Enterprises typically employ TDE to solve compliance issues such as PCI-DSS, which require the protection of data at rest.

TDE is built-in to kdb+, at no additional cost to a kdb+ licence. As it decrypts the data inside the kdb+ process, rather than at the OS/storage level, data remains encrypted when it comes across the wire from remote storage.

Encryption is selective – one can encrypt only the files that need encrypting.

Files can be archived, or copied, across environments without cycling through decryption and encryption again.

Kdb+ is multi-platform, and as the file format is platform-agnostic, the same encrypted files can be accessed from multiple platforms.

Key and process ownership and separation of responsibilities: the DBA holds TDE keys; the server admin holds FDE keys.


## Availability

All editions of kdb+ 4.0 support TDE.


## Prerequisites

Kdb+ requires at least OpenSSL library v1.0.2 upwards, as reported via 
```q
(-26!)[]`SSLEAY_VERSION
```

To generate the master key, OpenSSL 1.1.1 is required, reported at the OS shell command line via OpenSSL version.

```bash
$ openssl version
OpenSSL 1.1.1d  10 Sep 2019
```

The Intel Advanced Encryption Standard (AES) New Instructions (AES-NI) engine is available for certain Intel processors, and allows for extremely fast hardware encryption and decryption.

The AES-NI engine is automatically enabled if the detected processor is among the supported ones. To check that the processor is supported, follow the steps below:

Ensure that the processor has the AES instruction set.

```bash
$ grep -m1 -o aes /proc/cpuinfo
aes
```

As root, run the following commands and compare their outputs. 
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

The significantly better performance of the `-evp` option indicates that AES-NI is enabled.

Alternatively, one can verify that the OpenSSL library has support for AES-NI via a benchmark test in q, comparing default to disabled AES-NI support. e.g.
with `ebench.q` as

```q
-36!(`:testkek.key;"mypassword");(`:etest;20;16;0)set 100000000?10000;system"ts max get`:etest"
```

Execute the default, AES-NI enabled if detected as
```bash
$q ebench.q
```

Compare to AES-NI disabled via

```bash
$OPENSSL_ia32cap="~0x200000200000000" q ebench.q
```

The performance difference between AES and AES-NI was observed to be around 400% for this test.


## Configuration

A password-protected master key is required.
Choose a unique, high-entropy password which would withstand a dictionary attack; a poorly chosen password can become the weakest link in encryption.

The master key can be generated using standard command-line tools.

!!! tip "Use a cryptographically secure pseudorandom number generator (CSPRNG) to generate a random 256-bit AES key, and password protect it."

```bash
$ openssl rand 32 | openssl aes-256-cbc -md SHA256 -salt -pbkdf2 -iter 10000 -out testkek.key # Prompts for a new password
```

!!! tip "Back up this keyfile and the password"

    Back up this key file and the password to open it – perhaps even deposit them in escrow for key recovery. If either of these is lost, any data encrypted using it will become inaccessible.

Place this password-protected key file above or outside of your HDB base directory.

To restrict remote users from accessing this file directly, ensure all remote queries execute through `reval` by setting the message handlers. e.g.

```q
.z.pg:{reval(value;enlist x)}
```

<i class="fas fa-graduation-cap"></i>
[Firewalling](firewalling.md)

Then, load the key file using

```q
-36!(`:pathtokeyfile;"passwordforkeyfile")
```


## Encryption

Files can be encrypted using the same command as for file compression, with [AES256CBC](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard "Wikipedia") encryption as algo 16.

The master key must already be loaded, via the [`-36!` command](../basics/internal.md). ==FIXME==
<!-- Documentation for -36! -->

Recalling that the left-hand arguments for `set` are
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

Encryption adds a small amount of data (initialization vector, data encryption key, HMAC) such that, depending on the logical block size chosen, less than 2% of the overall size for typical DB files. This is reported via the command [`-21!filename`](../basics/internal.md#-21x-compression-stats).

## File locking

Encrypted enumeration domain files are locked for writing during an append, e.g.

```q
q)`:sym?`new`symbols`here
```

They must not be read from during the append.

## Decryption

The master key must already be loaded, via the `-36!` command.
Decryption is transparent to a query, just as is decompression.


## Performance

We strongly recommend users of encryption to have AES-NI enabled; this is the most likely scenario for modern systems.
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

Confirm that the `newtestkek.key` works by loading it into kdb+, and decrypting existing data with it.

Then archive `testkek.key`, rename `newtestkek.key` to `testkek.key` and update the password used in the `-36!` call.

This does not change the encryption key itself. To change that, a more involved process is required, which would then re-encrypt all the data.


## Limitations

The schema in kdb+ is not encrypted, as this is visible in the directory and file names. The column name file for splay, `.d`, is also not encrypted.


## Technical details

Kdb+ uses a symmetric cipher, AES256CBC – Advanced Encryption Standard (AES), with a 256-bit key size, in Cipher-Block-Chaining (CBC) mode.

The meta data of a file is encrypted using the master key, contains the encrypted data encryption key, and is authenticated via HMAC-SHA256. It uses [Encrypt then MAC (EtM)](https://en.wikipedia.org/wiki/Authenticated_encryption#Encrypt-then-MAC_(EtM) "Wikipedia").

There is one master key, which is password-protected, and a unique data encryption key is used per file.

Compressed files have the 8-byte header kxzipped; encrypted files, which may also be compressed, have the header kxzipped.

Human errors, such as choosing a weak password, or storing the key file and password in insecure areas, can leave encryption much weaker than desired, resulting in a false sense of security.

The master key is encrypted with a symmetric cipher with a key produced from a passphrase using PBKDF2 (Password-Based Key Derivation Function 2), a key-derivation function with a sliding computational cost, used to reduce vulnerabilities to brute-force attacks. The important factor on the computation complexity of PBKDF2 is key-stretching, here, the number of hash-iterations used. High values increase the time required to brute-force the resulting file. The number of iterations, fixed at 50,000 for kdb+, reduces the number of challenges that can be performed per second, thereby impeding a brute-force attack.

Choosing high-entropy passwords could significantly extend the amount of time required to crack the password. Remember high entropy is not enough – don’t reuse passwords, or passwords that are easily guessed by dictionary attacks.

<i class="fas fa-unlock"></i>
[Password strength test](http://rumkin.com/tools/password/passchk.php)

Password entropy is a measurement of how unpredictable a password is. Aim for an entropy of >80.

$$ E=log_{2}(R)\times L $$

```txt
E: entropy
R: number of available characters
L: the length of the password
```

[![XKCD: password strength](https://imgs.xkcd.com/comics/password_strength.png)](https://www.xkcd.com/936/)


## Compression with encryption

Due to the nature of encryption, in that the encrypted data must be indistinguishable from random data, there is little to gain from attempting to compress encrypted data. Hence kdb+ offers the combination of ‘compress then encrypt’. 

Depending on your threat model, combining compression and encryption can introduce security issues, and you should be aware that information can be leaked through a compression-ratio side channel. If you’re not sure whether you’re leaking information through compression, do not combine it with encryption.


## Roadmap

### Authenticated encryption ciphers

Presently provides for confidentiality but not integrity beyond the meta block.

<i class="fab fa-wikipedia-w"></i>
[Authenticated encryption](https://en.wikipedia.org/wiki/Authenticated_encryption "Wikipedia")


### Multiple keys per process

One of the most profound challenges related to encryption is key management due to its associated complexity and cost. Unclear key management function, lack of skilled professionals, and fragmented Key Management Systems (KMS) increase the overheads for enterprises.


### Integration with

-   [Microsoft Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/)
-   [AWS Key Management Service](https://aws.amazon.com/kms/)
-   [Google Cloud Key Management Service](https://cloud.google.com/kms/)
-   [Key Management Interoperability Protocol (KMIP)](https://en.wikipedia.org/wiki/Key_Management_Interoperability_Protocol)


## Further reading

<i class="fas fa-book"></i>
[_Understanding Cryptography: A Textbook for Students and Practitioners_](https://www.amazon.com/Understanding-Cryptography-Textbook-Students-Practitioners/dp/3642041000)
<br>
<i class="fas fa-book"></i>
[_An Introduction to Mathematical Cryptography_](https://www.amazon.com/Introduction-Mathematical-Cryptography-Undergraduate-Mathematics/dp/1493917102)
<br>
<i class="fas fa-book"></i>
[_Cryptography Made Simple_](https://www.amazon.com/Cryptography-Made-Simple-Information-Security/dp/3319219359)
<br>
<i class="fas fa-book"></i>
[_Serious Cryptography: A Practical Introduction to Modern Encryption_](https://www.amazon.com/Serious-Cryptography-Practical-Introduction-Encryption/dp/1593278268)
<br>
<i class="fas fa-globe"></i>
[coursera.org](https://www.coursera.org/learn/crypto)
