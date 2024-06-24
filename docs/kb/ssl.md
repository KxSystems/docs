---
title: SSL/TLS – Knowledge Base – kdb+ and q documentation
description: How to use Secure Sockets Layer(SSL)/Transport Layer Security(TLS) to encrypt connections using the OpenSSL libraries.
keywords: kdb+, openssl, q, ssl, tls
---
# SSL/TLS


Since V3.4t 2016.05.12, kdb+ can use Secure Sockets Layer (SSL)/Transport Layer Security (TLS) to encrypt connections using the OpenSSL libraries.


## Configuration

### OpenSSL library

Ensure that your OS has the latest OpenSSL libraries installed, and that they are in your `LD_LIBRARY_PATH` (Unix), `DYLD_LIBRARY_PATH` (MacOS), or `PATH` (Windows).

#### OpenSSL version

Beginning with v4.1t 2022.03.25, kdb+ will try to load versioned shared libraries for OpenSSL.
It will load the first library that it can locate from the lists below:

=== ":fontawesome-brands-linux: Linux"

    `libssl.so libssl.so.3 libssl.1.1 libssl.so.1.0 libssl.so.10 libssl.so.1.0.2 libssl.so.1.0.1 libssl.1.0.0`

=== ":fontawesome-brands-apple: macOS"

    `libssl.3.dylib libssl.1.1.dylib`

=== ":fontawesome-brands-windows: Windows"

    both `libssl` and `libcrypto` are loaded, the library names in priority order are

    |  | libssl | libcrypto |
    | ------- | ------ | ------ |
    | `w64` | `libssl-3-x64.dll`<br>`libssl-1_1-x64.dll` | `libcrypto-3-x64.dll`<br>`libcrypto-1_1.dll` |
    | `w32` | `libssl-3.dll`<br>`libssl-1_1.dll` | `libcrypto-3.dll`<br>`libcrypto-1_1.dll` |


The Windows build was tested with the pre-compiled libs [Win32 OpenSSL v1.1.1L Light, Win64 OpenSSL v1.1.1L Light](https://slproweb.com/products/Win32OpenSSL.html).

Prior to V4.1t 2022.03.25, kdb+ would load the following files:

=== ":fontawesome-brands-linux: Linux, Solaris"

    `libssl.so`

=== ":fontawesome-brands-apple: macOS" 

    `libssl.dylib`

=== ":fontawesome-brands-windows: Windows"
    
    ```txt
    libssl-1_1-x64.dll   libcrypto-1_1-x64.dll    w64 build
    libssl-1_1.dll       libcrypto-1_1.dll        w32 build
    ```

### Keys/Certificates

Since TLS uses certificates, prior to enabling TLS in a kdb+ server, ensure that you have the necessary certificates in place. 

The minimum for a TLS-enabled server is to provide a certificate and its associated key, both in PEM format. 

To locate these files, q uses the default path as reported by the `openssl version -d` command as a base, e.g.

```bash
$ openssl version -d
OPENSSLDIR: "/opt/local/etc/openssl"
```

Configuration of keys/certificates and checks performed is controlled by the following [environment variables](https://en.wikipedia.org/wiki/Environment_variable)

!!! info "KX first"

    Since V3.6, kdb+ gives preference to the `KX_` prefix for the `SSL_*` environment variables to avoid clashes with other OpenSSL based products.

    For example, the value for `` getenv`KX_SSL_CERT_FILE`` has a higher precedence than `` getenv`SSL_CERT_FILE`` for determining config.

#### SSL_CERT_FILE

The certificate file. This must be in PEM format and must be sorted starting with the subject's certificate (actual client or server certificate), followed by intermediate CA certificates if applicable, and ending at the highest level (root).

Default value is `<OPENSSLDIR>/server-crt.pem`

#### SSL_CA_CERT_FILE

A file containing certificate authority (CA) certificates in PEM format. The file can contain several CA certificates identified by

```
-----BEGIN CERTIFICATE-----
... (CA certificate in base64 encoding) ...
-----END CERTIFICATE-----
```
sequences. Text is allowed before, between, and after the certificates; it can be used, for example, for descriptions of the certificates.

Default value is `<OPENSSLDIR>/cacert.pem`

#### SSL_CA_CERT_PATH

A directory containing certificate authority (CA) certificates in PEM format.

Default value is `<OPENSSLDIR>`

#### SSL_KEY_FILE

Private key in PEM format.

Default value is `<OPENSSLDIR>/server-key.pem`

#### SSL_CIPHER_LIST

The default cipher list is set to the `Intermediate compatibility (default)`
[as recommended by Mozilla.org](https://wiki.mozilla.org/Security/Server_Side_TLS#Intermediate_compatibility_.28default.29). You may override this, to reduce the list to whatever your IT security policy requires.

Default value is
```
ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-
AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-
SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-
AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:
ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:
ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:
DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-
RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-
RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:
AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS
```

A good source for what is generally recommended can be found at [Ciphersuites](https://wiki.mozilla.org/Security/Server_Side_TLS).

If you select a set which is not compatible with the peer process, you’ll observe a message at the q console similar to the following.

```txt
140735201689680:error:1408A0C1:SSL routines:ssl3_get_client_hello:no
shared cipher:s3_srvr.c:1417:
```

#### SSL_VERIFY_CLIENT

Controls the processing of certificates from a client. Uses the certificates from `SSL_CA_CERT_FILE` or `SSL_CA_CERT_PATH` to verify the client’s certificate.

Can be set to one of the following values:

-   `NO` (default) kdb+ does not request nor validate the certificate from a client
-   `YES` server requests a client certificate and disconnects the client if the provided certificate is missing or invalid
-   `REQUESTONLY` (since 4.1t 2024.02.07) server requests a client certificate but allows the connection if the client certificate is missing or invalid
-   `IFPRESENT` (since 4.1t 2024.02.07) server requests a client certificate and terminates the connection if an invalid certificate is provided; the server continues if the certificate is missing or valid

#### SSL_VERIFY_SERVER

Controls the processing of certificates from a server. Checks the X509 certificate the peer presented by verifying the server’s certificate against a trusted source, using the certificates from `SSL_CA_CERT_FILE` or `SSL_CA_CERT_PATH` to verify the server’s certificate.
In the interests of not interrupting service, verification of certificates accepts expired certificates.

If the verification process fails, the TLS/SSL handshake is immediately terminated with an alert message containing the reason for the verification failure. 
If no server certificate is sent, because an anonymous cipher is used, processing is ignored.

Default value is `YES`.

### Checking Configuration

Configured TLS settings for a kdb+ process can be viewed with [`(-26!)[]`](../basics/internal.md#-26x-ssl).


## Certificates

If you don’t have a certificate, you can create a self-signed certificate using the `openssl` program. An example script to do so follows; customize as necessary.

```bash
$ more makeCerts.sh
mkdir -f $HOME/certs && cd $HOME/certs

# create private key for CA (certificate authority)
openssl genrsa -out ca-private-key.pem 2048
# create X509 certificate for CA (certificate authority)
openssl req -x509 -new -nodes -key ca-private-key.pem -sha256 -days 365 -out ca-cert.pem -subj /C=US/ST=CA/L=Somewhere/O=Someone/CN=FoobarCA

# create server private key
openssl genrsa -out server-private-key.pem 2048
# create servers certificate signing request (CSR)
# CSR contains the common name(s) you want your certificate to secure, information about your company, and your public key (taken from provided private key)
openssl req -new -sha256 -key server-private-key.pem -subj /C=US/ST=CA/L=Somewhere/O=Someone/CN=Foobar -out server.csr
# create X509 certificate for the server (signed by CA)
openssl x509 -req -in server.csr -CA ca-cert.pem -CAkey ca-private-key.pem -CAcreateserial -out server-cert.pem -days 365 -sha256

# create client private key
openssl genrsa -out client-private-key.pem 2048
# create clients certificate signing request (CSR)
# CSR contains the common name(s) you want your certificate to secure, information about your company, and your public key (taken from provided private key)
openssl req -new -sha256 -key client-private-key.pem -subj /C=US/ST=CA/L=Somewhere/O=Someone/CN=Foobar -out client.csr
# create X509 certificate for the client (signed by CA)
openssl x509 -req -in client.csr -CA ca-cert.pem -CAkey ca-private-key.pem -CAcreateserial -out client-cert.pem -days 365 -sha256
```

Using this script the server settings can be configured as:
```bash
$ export SSL_CERT_FILE=$HOME/certs/server-cert.pem
$ export SSL_KEY_FILE=$HOME/certs/server-private-key.pem
$ export KX_SSL_CA_CERT_FILE=$HOME/certs/ca-cert.pem 
```
with the client as:
```bash
$ export SSL_CERT_FILE=$HOME/certs/client-cert.pem 
$ export SSL_KEY_FILE=$HOME/certs/client-private-key.pep
$ export KX_SSL_CA_CERT_FILE=/tmp/new/ca-cert.pem
```

:fontawesome-brands-github:
[mkcert](https://github.com/FiloSottile/mkcert) is a simple tool for making locally-trusted development certificates.

!!! warning "Secure your certificates"

    Store your certificates outside of the directories accessible from within kdb+, otherwise remote users can easily steal your server’s key file! 


## TLS Server Mode

When the certificates are in place, and the environment variables are set, TLS Server Mode can be enabled through the [command-line option -E](../basics/cmdline.md#-e-tls-server-mode).


## TLS Client Mode

TLS connections can be [opened](../ref/hopen.md) to TLS-enabled servers with

```q
q)h:hopen`:tcps://hostname:port[:username:password]
```

Clients can also request [secure HTTP (HTTPS)](http.md) and [WebSockets (WSS)](websockets.md) connections.

If you don't wish to verify a server’s certificate, set

```bash
$ export SSL_VERIFY_SERVER=NO
```

To allow verification of certificates which were not issued by you, you can import the CA bundle from reputable sources, e.g.

```bash
$ curl https://curl.se/ca/cacert.pem > $HOME/certs/cabundle.pem
$ export SSL_CA_CERT_FILE=$HOME/certs/cabundle.pem
```

If you open the downloaded `cabundle.pem` with a text editor you’ll see a list of certificates, and you can append your own self-signed `ca.pem` to this file if you wish.

If there is an issue in loading the CA certificate, an error similar to the following will be printed at the q console

```q
q).Q.hg`$":https://www.kx.com"
140735201689680:error:02001002:system library:fopen:No such file or directory:bss_file.c:175:fopen('/opt/local/etc/openssl/cacert.pem','r')
140735201689680:error:2006D080:BIO routines:BIO_new_file:no such file:bss_file.c:178:
140735201689680:error:0B084002:x509 certificate routines:X509_load_cert_crl_file:system lib:by_file.c:253:
'conn. OS reports: Protocol not available
```

## Connection Info

Extra protocol details for a connection handle are available via [`.z.e`](../ref/dotz.md#ze-tls-connection-status), including information about whether the current handle's TLS certificate was successfully verified.


## Suitability and restrictions

Currently we would recommend TLS be considered only for long-standing, latency-insensitive, low-throughput connections. The overhead of `hopen` on localhost appears to be 40-50× that of a plain connection, and once handshaking is complete, the overhead is \~1.5× assuming your OpenSSL library can utilize AES-NI.

OpenSSL 1.1 is supported since V4.0 2020.03.17.


### Thread Support

The following associated features are not implemented for TLS

-   multithreaded input mode
-   use within secondary threads
-   `hopen` timeout (implemented in V3.5)

Since 4.1t 2023.11.10 this was altered to allow use on any thread where messaging was previously supported: i.e.

-   incoming connections in multithreaded input queue mode (mtiqm)
-   one-shot sync requests within peach or mtiqm socket thread
-   https client requests within peach or mtiqm socket thread


