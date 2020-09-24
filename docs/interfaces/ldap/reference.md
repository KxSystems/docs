---
title: LDAP function reference | Interfaces Documentation for kdb+ and q
author: Simon Shanks
description: List all functionality and options for the kdb+ interface to LDAP
date: September 2020
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
keywords: ldap, interface, fusion , q
---
# LDAP function reference

:fontawesome-brands-github:
[KxSystems/ldap](https://github.com/KxSystems/ldap)

<pre markdown="1" class="language-txt">
.ldap   **LDAP interface**

Functions
  [bind](#ldapbind)             Synchronous bind operations are used to authenticate clients
  [err2string](#ldaperr2string)       Returns a string description of an LDAP error code
  [getOption](#ldapgetoption)        Gets session options that affect LDAP operating procedures
  [getGlobalOption](#ldapgetglobaloption)  Gets options globally that affect LDAP operating procedures
  [init](#ldapinit)             Initializes the session with LDAP server connection details
  [search](#ldapsearch)           Synchronous search for partial or complete copies of entries based on a search criteria
  [setGlobalOption](#ldapsetglobaloption)  Sets options globally that affect LDAP operating procedures
  [setOption](#ldapsetoption)        Sets options per session that affect LDAP operating procedures
  [unbind](#ldapunbind)           Synchronous unbind from the directory
</pre>

## `Callable Functions`

### `.ldap.bind`

_Synchronous bind operations are used to authenticate clients (and the users or applications behind them) to the directory server, to establish an authorization identity that will be used for subsequent operations processed on that connection, and to specify the LDAP protocol version that the client will use. See [here](https://ldap.com/the-ldap-bind-operation/) for reference documentation._

Syntax: `.ldap.bind[sess;opts]`

Where

- `sess` is an int/long that represents the session previously created via `.ldap.init`
- `opts` is a dictionary/generic null defining any non default options which should be considered when performing a bind operation. The following are the possible options (keys) and their associated defaults (values) called using a generic null.
	- `dn` is a string/symbol. This denotes the user to authenticate. The default behaviour is to operate anonymous simple authentication, this is typical for SASL authentication as most SASL mechanisms identify the target account within the encoded credentials. This should be non-default for non-anonymous simple authentication.
	- `cred` is a char/byte array or symbol. This denotes the LDAP credentials (e.g. password) to be used. The default behaviour is to assume that no password is required for connection.
	- `mech` is a string/symbol. This denotes the SASL mechanism which is to be used for authentication. The default mechanism used for this is `LDAP_SASL_SIMPLE`. Query the attribute 'supportedSASLMechanisms' from the  server's rootDSE for the list of SASL mechanisms the server supports.

Returns a dict consisting of

key           | type       | explanation
--------------|------------|-----------------
`ReturnCode`  | integer    | error code returned from function invocation
`Credentials` | byte array | the credentials returned by the server. Contents are empty for LDAP_SASL_SIMPLE, though for other SASL mechanisms, the credentials may need to be used with other security related functions (which may be external to LDAP). See [here](#security-mechanisms) for more information.

```q
// Complete a default bind to the server
q).ldap.bind[0i;::]
ReturnCode | 0i
Credentials| `byte$()

// Complete a bind to the server with non default parameters
q).ldap.bind[0i;enlist[`dn]!enlist `Tom]
ReturnCode | 0i
Credentials| `byte$()
```

### `.ldap.err2string`

_Returns a string description of an LDAP error code. The error codes are negative for an API error, 0 for success, and positive for a LDAP result code._

Syntax: `.ldap.err2string[err]`

Where

- `err` is an LDAP error code. See [here](#error-code-reference) for further information.

Return the string representation of the LDAP error code

```q
q).ldap.err2string[0]
"Success"
q).ldap.err2string[-9]
"Bad parameter to an ldap routine"
q).ldap.err2string[5]
"Compare False"
```

### `.ldap.getOption`

_Gets session options that affect LDAP operating procedures. Reference [ldap_set_option](https://www.openldap.org/software/man.cgi?query=ldap_set_option&sektion=3&apropos=0&manpath=OpenLDAP+2.4-Release)._

Syntax: `.ldap.getOption[sess;option]`

Where

- `sess` is an int/long that represents the session previously created via .ldap.init
- `option` is a symbol for the option you wish to get. See supported options [here](#get-option-reference)

Value returned from function depends on options used. See [here](#get-option-reference) for type reference.

```q
q).ldap.getOption[0i;`LDAP_OPT_PROTOCOL_VERSION]
,3
q).ldap.getOption[0i;`LDAP_OPT_NETWORK_TIMEOUT]
30000
```

### .ldap.getGlobalOption

_Gets options globally that affect LDAP operating procedures._

Syntax: `.ldap.getGlobalOption[option]`

Where

- `option` is a symbol for the option you wish to get. See supported options [here](#get-option-reference)

Value returned from function depends on options used. See [here](#get-option-reference) for type reference.

```q
q).ldap.getGlobalOption[`LDAP_OPT_PROTOCOL_VERSION]
,3
q).ldap.getGlobalOption[`LDAP_OPT_X_TLS_REQUIRE_CERT]
,3
```

### `.ldap.init`

_Initializes the session with LDAP server connection details. Connection will occur on first operation. Does not create a connection. Use unbind to free the session. Reference [ldap_initialize](https://www.openldap.org/software/man.cgi?query=ldap_init&sektion=3&apropos=0&manpath=OpenLDAP+2.4-Release)._

Syntax: `.ldap.init[sess;uris]`

Where

- `sess` is an int/long that you will use to track the session in subsequent calls. Should be a unique number for each session you wish to initialize. The number can only be reused to refer to a session after a `.ldap.unbind`.
- `uris` is a symbol list. Each URI in the list must follow the format of `schema://host:port` , where schema is `'ldap'`, `'ldaps'`, `'ldapi'` or `'cldap'`.

Returns 0i if successful, otherwise returns an LDAP error code.

```q
// successfully execute initialization
q).ldap.init[0i;enlist `$"ldap://0.0.0.0:389"]
0i

// attempt to initialize with an incorrect 'schema'
q).ldap.init[1i;enlist `$"noldap://0.0.0.0:389"]
-9i

// retrieve error message for above error code
q).ldap.err2string[-9i]
"Bad parameter to an ldap routine"
```

### `.ldap.search`

_Synchronous search for partial or complete copies of entries based on a search criteria._

Syntax: `.ldap.search[sess;scope;filter;opts]`

Where

- `sess` is an int/long that represents the session previously created via .ldap.init
- `scope`  is an int/long. The scope value defining the search logic are outlined [here](#scope-reference).
- `filter` is a string/symbol. The filter to be applied to the search ([reference](https://ldap.com/ldap-filters/))
- `opts` is a dictionary/generic null defining any non default options which should be considered when performing a search operation. The following are the possible options (keys) and their associated defaults (values) called using a generic null.
	- `baseDn` is a string/symbol. The base of the subtree to search from. The default behaviour is to search from the root (or when a DN is not known).
	- `attr` is a symbol list. The set of attributes to include in the result. The default behaviour is to assume that `“*”` was specified and all user attributes are to be included in entries that are returned. If a specific set of attribute descriptions are listed, then only those attributes should be included in matching entries. The following special characters and patterns can be used in searches.
		- The special value `“*”` indicates that all user attributes should be included in matching entries.
		- The special value `“+”` indicates that all operational attributes should be included in matching entries.
		- The special value `“1.1”` indicates that no attributes should be included in matching entries.
		- Some servers may also support the ability to use the `“@”` symbol followed by an object class name (e.g., `“@inetOrgPerson”`) to request all attributes associated with that object class.
	- `attrsOnly` is an int/long. Denotes if both attributes descriptions and attribute values are to be returned. The default behaviour is to return both attributes descriptions and attribute values. If only attribute descriptions are required then this should be set such that ``` dict[`attrsOnly]>0````
	- `timeLimit` is an int/long. Max number of microseconds to wait for a result. The default behaviour is to set no time limit i.e. `timeLimit = 0`. Note that the server may impose its own limit.
	- `sizeLimit` is an int/long. Max number of entries to use in the result. The default behaviour is to set no size limit i.e. `sizeLimit = 0`. Note that the server may impose its own limit.

Returns a dict consisting of

key         | type    | explanation
------------|---------|-----------------
`ReturnCode`| integer | error code returned from function invocation
`Entries`   | table   | DNs and Attributes, where the Attributes form a dictionary with each attribute having one or more values.
`Referrals` | list    | list of strings providing the referrals that can be searched to gain access to the required info (if server supports referrals)

```q
// Run a blind/default search at base level
q)session:0i
q)scope  :.ldap.LDAP_SCOPE_BASE
q)filter :"(objectClass=*)"
q).ldap.search[session;scope;filter;::]
ReturnCode| 0i
Entries   | +`DN`Attributes!(,"";,(,`objectClass)!,("top";"OpenLDAProotDSE"))
Referrals | ()

// Run a non default search
q)session:0i
q)scope  :.ldap.LDAP_SCOPE_SUBTREE
q)filter :"(cn=Amy Wong)"
q)options:`baseDN`attr!(`$"ou=people,dc=planetexpress,dc=com";`mail`givenName)
q).ldap.search[session;scope;filter;options]
ReturnCode| 0i
Entries   | +`DN`Attributes!(,"cn=Amy Wong+sn=Kroker,ou=people,dc=planetexpress,dc=com";,`givenName`mail!(,"Amy";,"amy@planetexpress.com"))
Referrals | ()
```

### `.ldap.setOption`

_Sets options per session that affect LDAP operating procedures. Reference [ldap_set_option](https://www.openldap.org/software/man.cgi?query=ldap_set_option&sektion=3&apropos=0&manpath=OpenLDAP+2.4-Release)._

Syntax: `.ldap.setOption[sess;option;value]`

Where

- `sess` is an int/long that represents the session previously created via `.ldap.init`
- `option` is a symbol for the option you wish to set. See supported [here](#set-option-reference).
- `value` is the value relating to the option. The data type depends on the option selected, see [here](#set-option-reference)

Returns 0i if successful, otherwise returns an LDAP error code.

```q
q).ldap.setOption[0i;`LDAP_OPT_PROTOCOL_VERSION;3]
0i
q).ldap.setOption[0i;`LDAP_OPT_NETWORK_TIMEOUT ;30000]
0i
```

### `.ldap.setGlobalOption`

_Sets options globally that affect LDAP operating procedures. LDAP handles inherit their default settings from the global options in effect at the time the handle is created (i.e. if a global setting is made, all sessions initialized after that will inherit those settings but not any sessions created prior)._

Syntax: `.ldap.setGlobalOption[option;value]`

Where

- `option` is a symbol for the option you wish to set. See supported [here](#set-option-reference).
- `value` is the value relating to the option. The data type depends on the option selected, see [here](#set-option-reference)

Returns 0i if successful, otherwise returns an LDAP error code.

```q
q).ldap.setGlobalOption[0i;`LDAP_OPT_X_TLS_REQUIRE_CERT;3]
0i
q).ldap.setGlobalOption[0i;`LDAP_OPT_NETWORK_TIMEOUT ;30000]
0i
```

### `.ldap.unbind`

_Synchronous unbind from the directory, terminate the current association, and free resources. Should be called even if a session did not bind (or failed to bind), but initialized its session._

Syntax: `.ldap.unbind[sess]`

Where 

- `sess` is an int/long that represents the session previously created via `.ldap.init`. The number should no longer be used unless `.ldap.init` and `.ldap.bind` has been used to create a new session.

Returns the LDAP error code returned when attempting to unbind a session.

```q
q).ldap.unbind[0i]
0i
```

## Scope Reference

When applying a search, the scope outlines the how this search is to take place. In this interface the scope is defined by an integer mapping. This integer mapping and the associated scope definition are outlined below.

| Scope              | Integer Representation  | Definition |
|--------------------|-------------------------|------------|
|LDAP_SCOPE_BASE     | 0   | Only the entry specified will be considered in the search & no subordinates used.
|LDAP_SCOPE_ONELEVEL | 1   | Only search the immediate children of entry specified. Will not use the entry specified or further subordinates from the children.
|LDAP_SCOPE_SUBTREE  | 2   | To search the entry and all subordinates.
|LDAP_SCOPE_CHILDREN | 3   | To search all of the subordinates.

## Option Reference

### Get Option Reference

The supported options outlined here relate to the supported callable 'get' options supported within this API. The supported options are protocol specific `LDAP`/`SASL`/`TCP`/`TLS` and as such are outlined here separately. For further information on each of the options see [here](https://www.openldap.org/software/man.cgi?query=ldap_get_option&apropos=0&sektion=3&manpath=OpenLDAP+2.4-Release&arch=default&format=html)

#### `LDAP`

| Option                      | Return Type   | Info        |
|-----------------------------|---------------|-------------|
| LDAP_OPT_API_FEATURE_INFO   | Dictionary    |  |
| LDAP_OPT_API_INFO           | Dictionary    |  |
| LDAP_OPT_CONNECT_ASYNC      | Integer       |  |
| LDAP_OPT_DEBUG_LEVEL        | Integer       |  |
| LDAP_OPT_DEREF              | Integer       |  |
| LDAP_OPT_DESC               | Integer       |  |
| LDAP_OPT_DIAGNOSTIC_MESSAGE | String        |  |
| LDAP_OPT_MATCHED_DN         | String        |  |
| LDAP_OPT_NETWORK_TIMEOUT    | Integer       | timeout in microseconds |
| LDAP_OPT_PROTOCOL_VERSION   | Integer       |  |
| LDAP_OPT_REFERRALS          | Integer       |  |
| LDAP_OPT_RESULT_CODE        | Integer       |  |
| LDAP_OPT_SIZELIMIT          | Integer       |  |
| LDAP_OPT_TIMELIMIT          | Integer       |  |
| LDAP_OPT_TIMEOUT            | Integer       | timeout in microseconds |

#### `SASL`

| Option                      | Return Type   |
|-----------------------------|---------------|
| LDAP_OPT_X_SASL_AUTHCID     | String        |
| LDAP_OPT_X_SASL_AUTHZID     | String        |
| LDAP_OPT_X_SASL_MAXBUFSIZE  | Long          |
| LDAP_OPT_X_SASL_MECH        | String        |
| LDAP_OPT_X_SASL_MECHLIST    | String        |
| LDAP_OPT_X_SASL_NOCANON     | Integer       |
| LDAP_OPT_X_SASL_REALM       | String        |
| LDAP_OPT_X_SASL_SSF         | Long          |
| LDAP_OPT_X_SASL_SSF_MAX     | Long          |
| LDAP_OPT_X_SASL_SSF_MIN     | Long          |
| LDAP_OPT_X_SASL_USERNAME    | String        |

#### `TCP`

| Option                        | Return Type   | 
|-------------------------------|---------------|
| LDAP_OPT_X_KEEPALIVE_IDLE     | Integer       |
| LDAP_OPT_X_KEEPALIVE_PROBES   | Integer       |
| LDAP_OPT_X_KEEPALIVE_INTERVAL | Integer       |

#### `TLS`

| Option                      | Return Type   |
|-----------------------------|---------------|
| LDAP_OPT_X_TLS_CACERTDIR    | String        |
| LDAP_OPT_X_TLS_CACERTFILE   | String        |
| LDAP_OPT_X_TLS_CERTFILE     | String        |
| LDAP_OPT_X_TLS_CIPHER_SUITE | String        |
| LDAP_OPT_X_TLS_CRLCHECK     | Integer       |
| LDAP_OPT_X_TLS_CRLFILE      | String        |
| LDAP_OPT_X_TLS_DHFILE       | String        |
| LDAP_OPT_X_TLS_KEYFILE      | String        |
| LDAP_OPT_X_TLS_PROTOCOL_MIN | Integer       |
| LDAP_OPT_X_TLS_RANDOM_FILE  | String        |
| LDAP_OPT_X_TLS_REQUIRE_CERT | Integer       |

### Set Option Reference

The supported options outlined here relate to the supported callable 'set' options supported within this API. The supported options are protocol specific `LDAP`/`SASL`/`TCP`/`TLS` and as such are outlined here separately. For further information on each of the options see [here](https://www.openldap.org/software/man.cgi?query=ldap_set_option&sektion=3&apropos=0&manpath=OpenLDAP+2.4-Release)

#### `LDAP`

| Option                      | Type          | Info        |
|-----------------------------|---------------|-------------|
| LDAP_OPT_CONNECT_ASYNC      | Integer/Long  | |
| LDAP_OPT_DEBUG_LEVEL        | Integer/Long  | |
| LDAP_OPT_DEREF              | Integer/Long  | Value can be one of `.ldap.LDAP_DEREF_NEVER`, `.ldap.LDAP_DEREF_SEARCHING`, `.ldap.LDAP_DEREF_FINDING` or `.ldap.LDAP_DEREF_ALWAYS`
| LDAP_OPT_DIAGNOSTIC_MESSAGE | String/Symbol | |
| LDAP_OPT_NETWORK_TIMEOUT    | Integer/Long  | Number of microseconds for timeout |
| LDAP_OPT_MATCHED_DN         | String/Symbol | |
| LDAP_OPT_PROTOCOL_VERSION   | Integer/Long  | |
| LDAP_OPT_REFERRALS          | Integer/Long  | Value can be one of `.ldap.LDAP_OPT_ON` or `.ldap.LDAP_OPT_OFF` |
| LDAP_OPT_RESULT_CODE        | Integer/Long  | |
| LDAP_OPT_SIZELIMIT          | Integer/Long  | |
| LDAP_OPT_TIMELIMIT          | Integer/Long  | |
| LDAP_OPT_TIMEOUT            | Integer/Long  | Number of microseconds for timeout |

#### `SASL`

| Option                       | Type          |
|------------------------------|---------------|
| LDAP_OPT_X_SASL_MAXBUFSIZE   | Long          |
| LDAP_OPT_X_SASL_NOCANON      | Integer/Long  |
| LDAP_OPT_X_SASL_SECPROPS     | String/Symbol |
| LDAP_OPT_X_SASL_SSF_EXTERNAL | Long          |
| LDAP_OPT_X_SASL_SSF_MAX      | Long          |
| LDAP_OPT_X_SASL_SSF_MIN      | Long          |

#### `TCP`

| Option                        | Type          | 
|-------------------------------|---------------|
| LDAP_OPT_X_KEEPALIVE_IDLE     | Integer/Long  |
| LDAP_OPT_X_KEEPALIVE_PROBES   | Integer/Long  |
| LDAP_OPT_X_KEEPALIVE_INTERVAL | Integer/Long  |

#### `TLS`

| Option                      | Type          |
|-----------------------------|---------------|
| LDAP_OPT_X_TLS_CACERTDIR    | String/Symbol |
| LDAP_OPT_X_TLS_CACERTFILE   | String/Symbol |
| LDAP_OPT_X_TLS_CERTFILE     | String/Symbol |
| LDAP_OPT_X_TLS_CIPHER_SUITE | String/Symbol |
| LDAP_OPT_X_TLS_CRLCHECK     | Integer/Long  |
| LDAP_OPT_X_TLS_CRLFILE      | String/Symbol |
| LDAP_OPT_X_TLS_DHFILE       | String/Symbol |
| LDAP_OPT_X_TLS_KEYFILE      | String/Symbol |
| LDAP_OPT_X_TLS_NEWCTX       | Integer/Long  |
| LDAP_OPT_X_TLS_PROTOCOL_MIN | Integer/Long  |
| LDAP_OPT_X_TLS_RANDOM_FILE  | String/Symbol |
| LDAP_OPT_X_TLS_REQUIRE_CERT | Integer/Long  |


## Error Code Reference

### Success Code

On successful execution of a function returning an LDAP error code the integer 0i will be returned. When passed to the function `.ldap.err2string` this will return `"Success"`

### Protocol Codes

These are all positive values. Reference IANA registered result codes [here](https://www.iana.org/assignments/ldap-parameters/ldap-parameters.xhtml#ldap-parameters-6)

### Error Codes

These are all negative values.

| Code | Name                         | Details                                                      |
| ---- | ---------------------------- | ------------------------------------------------------------ |
| -1   | LDAP_SERVER_DOWN             | The LDAP library can't contact the LDAP server.              |
| -2   | LDAP_LOCAL_ERROR             | Some local  error  occurred.   This  is  usually  a failed dynamic memory allocation. |
| -3   | LDAP_ENCODING_ERROR          | An  error  was  encountered  encoding parameters to send to the LDAP server. |
| -4   | LDAP_DECODING_ERROR          | An error was encountered decoding a result from the LDAP server. |
| -5   | LDAP_TIMEOUT                 | A  timelimit  was  exceeded  while  waiting  for  a result.  |
| -6   | LDAP_AUTH_UNKNOWN            | The authentication method specified to  ldap_bind()  is not known. |
| -7   | LDAP_FILTER_ERROR            | An  invalid  filter  was  supplied to ldap_search() (e.g., unbalanced parentheses). |
| -8   | LDAP_USER_CANCELLED          | Indicates the user cancelled the operation.                  |
| -9   | LDAP_PARAM_ERROR             | An ldap routine was called with a bad parameter.             |
| -10  | LDAP_NO_MEMORY               | An memory  allocation  (e.g.,  [malloc(3)](https://www.openldap.org/software/man.cgi?query=malloc&sektion=3&apropos=0&manpath=OpenLDAP+2.4-Release)  or  other  dynamic  memory  allocator)  call failed in an ldap library routine. |
| -11  | LDAP_CONNECT_ERROR           | Indicates a connection problem.                              |
| -12  | LDAP_NOT_SUPPORTED           | Indicates the routine was called in  a  manner  not supported by the library. |
| -13  | LDAP_CONTROL_NOT_FOUND       | Indicates  the  control  provided is unknown to the client library. |
| -14  | LDAP_NO_RESULTS_RETURNED     | Indicates no results returned.                               |
| -16  | LDAP_CLIENT_LOOP             | Indicates the library has detected a  loop  in  its processing. |
| -17  | LDAP_REFERRAL_LIMIT_EXCEEDED | Indicates the referral limit has been exceeded.              |
| -18  | LDAP_X_CONNECTING            | Indicates that an async connect attempt is ongoing.          |


## Security Mechanisms

LDAP supports a range of security mechanisms as part of the bind call. Check with your LDAP server/admin what is supported for your system (often found in the root attribute named 'supportedSASLMechanisms').

Most of these security mechanisms are performed externally, in separate code related to your security mechanism.

For example,  

* DIGEST_MD5 is initially performed by calling bind with no credentials, mech set to "DIGEST-MD5" and capturing the returned credential values from the server. Using the returned credentials to MD5 encode the user details, a second bind call is then made with the MD5 encoded details as the 'cred' parameter. This requires an additional MD5 library that is outside the scope of this interface (Ref: [example code](https://github.com/zheolong/melody-lib/blob/master/libldap5/sources/ldap/common/digest_md5.c)). 

Other security mechanisms may operate in a similar manner

* [GSSAPI](https://en.wikipedia.org/wiki/Generic_Security_Services_Application_Program_Interface) example [here](https://github.com/hajuuk/R7000/blob/master/ap/gpl/samba-3.0.13/source/libads/sasl.c).
* [CRAM-MD5](https://en.wikipedia.org/wiki/CRAM-MD5) example [here](https://github.com/illumos/illumos-gate/blob/master/usr/src/lib/libldap5/sources/ldap/common/cram_md5.c).
