---
title: SSL/TLS – Knowledge Base – kdb+ and q documentation
description: How to use Secure Sockets Layer(SSL)/Transport Layer Security(TLS) to encrypt connections using the OpenSSL libraries.
keywords: kdb+, openssl, q, ssl, tls
---
# SSL/TLS




V3.4t 2016.05.12 can use Secure Sockets Layer (SSL)/Transport Layer Security (TLS) to encrypt connections using the OpenSSL libraries.


## Prerequisites

Ensure that your OS has the latest OpenSSL libraries installed, and that they are in your `LD_LIBRARY_PATH` (Unix), or `PATH` (Windows).

Kdb+ loads the following files

-   Windows: `ssleay32.dll`, `libeay32.dll`
-   macOS: `libssl.dylib`
-   Linux, Solaris: `libssl.so`

The Windows build was tested with the precompiled libs (Win32 OpenSSL v1.0.2h Light, Win64 OpenSSL v1.0.2h Light) from <https://slproweb.com/products/Win32OpenSSL.html>


## Certificates

Since TLS uses certificates, prior to enabling TLS in a kdb+ server, ensure that you have the necessary certificates in place. The minimum for a TLS-enabled server is to provide a certificate and its associated key, both in PEM format. To locate these files, q will use the default path as reported by the `openssl version -d` command as a base, e.g.

```bash
$ openssl version -d
OPENSSLDIR: "/opt/local/etc/openssl"
```

This default can be overridden by setting the environment variables `SSL_CERT_FILE` and `SSL_KEY_FILE` to the full path to your certificate and key files. e.g.

```bash
$ export SSL_CERT_FILE=$HOME/certs/server-crt.pem
$ export SSL_KEY_FILE=$HOME/certs/server-key.pem
```

!!! info "KX first"

    Since V3.6, kdb+ gives preference to the `KX_` prefix for the `SSL_*` environment variables to avoid clashes with other OpenSSL based products. 

    For example, the value for `` getenv`KX_SSL_CERT_FILE`` has a higher precedence than `` getenv`SSL_CERT_FILE`` for determining config.

If you don’t have a certificate, you can create a self-signed certificate using the `openssl` program. An example script to do so follows, which you should customize as necessary

```bash
$ more makeCerts.sh
mkdir -f $HOME/certs && cd $HOME/certs

# Create CA certificate
openssl genrsa 2048 > ca-key.pem
openssl req -new -x509 -nodes -days 3600 \
    -key ca-key.pem -out ca.pem -extensions usr_cert \
    -subj '/C=US/ST=New York/L=Brooklyn/O=Example Brooklyn Company/CN=examplebrooklyn.com'

# Create server certificate, remove passphrase, and sign it
# server-crt.pem = public key, server-key.pem = private key
openssl req -newkey rsa:2048 -days 3600 -nodes \
    -keyout server-key.pem -out server-req.pem -extensions usr_cert \
    -subj '/C=US/ST=New York/L=Brooklyn/O=Example Brooklyn Company/CN=myname.com'
openssl rsa -in server-key.pem -out server-key.pem
openssl x509 -req -in server-req.pem -days 3600 -CA ca.pem -CAkey ca-key.pem \
    -set_serial 01 -out server-crt.pem -extensions usr_cert

# Create client certificate, remove passphrase, and sign it
# client-crt.pem = public key, client-key.pem = private key
openssl req -newkey rsa:2048 -days 3600  -nodes \
    -keyout client-key.pem -out client-req.pem -extensions usr_cert \
    -subj '/C=US/ST=New York/L=Brooklyn/O=Example Brooklyn Company/CN=myname.com'
openssl rsa -in client-key.pem -out client-key.pem
openssl x509 -req -in client-req.pem -days 3600 -CA ca.pem -CAkey ca-key.pem \
    -set_serial 01 -out client-crt.pem -extensions usr_cert
```

!!! warning "Secure your certificates"

    Store your certificates outside of the directories accessible from within kdb+, otherwise remote users can easily steal your server’s key file! 


## TLS cipher List

The default cipher list is set to the `Intermediate compatibility (default)` 
[as recommended by Mozilla.org](https://wiki.mozilla.org/Security/Server_Side_TLS#Intermediate_compatibility_.28default.29), 
and you may override this via the environment variable `SSL_CIPHER_LIST`, to reduce the list to whatever your IT security policy requires. A good source for what is generally recommended can be found at 
[Ciphersuites](https://wiki.mozilla.org/Security/Server_Side_TLS).

e.g.

```bash
$ export SSL_CIPHER_LIST='ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY
1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES2
56-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES
256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AE
S128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384
:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES1
28-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-
RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES12
8-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS'
```

If you select a set which is not compatible with the peer process, you’ll observe a message at the q console similar to the following.

```txt
140735201689680:error:1408A0C1:SSL routines:ssl3_get_client_hello:no 
shared cipher:s3_srvr.c:1417:
```


## TLS Server Mode

Once the certificates are in place, and the environment variables set, TLS Server Mode can be enabled through the [command-line option](../basics/cmdline.md#-e-tls-server-mode) `-E 0` (plain), `1` (plain & TLS), `2` (TLS only). e.g.

```bash
$ q -u 1 -E 1 -p 5000
```

starts a server which will listen for plain and TLS connections on port 5000, restricting remote access to the pwd and below.

General TLS settings for a kdb+ process can be viewed with `(-26!)[]`.

```q
q)(-26!)[]
SSLEAY_VERSION   | OpenSSL 1.0.2g  1 Mar 2016
SSL_CERT_FILE    | /Users/kdb/certs/server-crt.pem
SSL_CA_CERT_FILE | /Users/kdb/certs/ca.pem
SSL_CA_CERT_PATH | /Users/kdb/certs/
SSL_KEY_FILE     | /Users/kdb/certs/server-key.pem
SSL_CIPHER_LIST  | ALL
SSL_VERIFY_CLIENT| NO
SSL_VERIFY_SERVER| YES
```

All keys except `SSLEAY_VERSION` in the result from `(-26!)[]` are initialized from environment variables.

By default, kdb+ does not request nor validate the certificate from a client. If the environment variable `SSL_VERIFY_CLIENT` is set to `YES`, it will try to use the certificates from `SSL_CA_CERT_FILE` or `SSL_CA_CERT_PATH` to verify the client’s certificate.

Extra protocol details for a handle `h` are available via `.z.e`

```q
q)h".z.e"
CURRENT_CIPHER   | AES128-GCM-SHA256
CURRENT_PROTOCOL | TLSv1.2
```


## TLS Client Mode

TLS client mode is always enabled, and TLS Connections can be opened to TLS-enabled servers with

```q
q)h:hopen`:tcps://hostname:port[:username:password]
```

Clients can also request secure HTTP (HTTPS) and WebSockets (WSS) connections via

```q
q)(`$":https://127.0.0.1:5000")"GET /login.html http/1.1\r\nhost:www.kx.com\r\n\r\n"
and for websockets
q) r:(`$":wss://127.0.0.1:5000")"GET / HTTP/1.1\r\nHost: 127.0.0.1:5000\r\n\r\n"
```

By default, kdb+ will try to verify the server’s certificate against a trusted source, using the certificates from `SSL_CA_CERT_FILE` or `SSL_CA_CERT_PATH` to verify the server’s certificate. If you don't wish to verify a server’s certificate, set

```bash
$ export SSL_VERIFY_SERVER=NO
```

To allow verification of certificates which were not issued by you, you can import the CA bundle from reputable sources, e.g.

```bash
$ curl https://curl.haxx.se/ca/cacert.pem > $HOME/certs/cabundle.pem
$ export SSL_CA_CERT_FILE=$HOME/certs/cabundle.pem
```

If you open the downloaded `cabundle.pem` with a text editor you’ll see a list of certificates, and you can append your own self-signed `ca.pem` to this file if you wish.

In the interests of not interrupting service, verification of certificates accepts expired certificates.

If there is an issue in loading the CA certificate, an error similar to the following will be printed at the q console

```q
q).Q.hg`$":https://www.kx.com"
140735201689680:error:02001002:system library:fopen:No such file or directory:bss_file.c:175:fopen('/opt/local/etc/openssl/cacert.pem','r')
140735201689680:error:2006D080:BIO routines:BIO_new_file:no such file:bss_file.c:178:
140735201689680:error:0B084002:x509 certificate routines:X509_load_cert_crl_file:system lib:by_file.c:253:
'conn. OS reports: Protocol not available
```


### Testing your client configuration

You can test your client configuration with

```q
q)(`$":howsmyssl.html")0:enlist .Q.hg`$":https://www.howsmyssl.com";
```

And then open the resulting file with your browser, e.g. on macOS use the `open` command

```q
q)\open howsmyssl.html
```


## Suitability and restrictions

Currently we would recommend TLS be considered only for long-standing, latency-insensitive, low-throughput connections. The overhead of `hopen` on localhost appears to be 40-50× that of a plain connection, and once handshaking is complete, the overhead is ~1.5× assuming your OpenSSL library can utilize AES-NI.

The following associated features are not yet implemented for TLS:

1.   multithreaded input mode
1.   use within secondary threads
1.   `hopen` timeout (implemented in V3.5)

OpenSSL 1.1 is supported since V4.0 2020.03.17.
