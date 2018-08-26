These functions engage with the operating system.  
<i class="far fa-hand-point-right"></i> [system commands](syscmds)


## `getenv`

Syntax: `getenv x`

where `x` is a symbol atom naming an environment variable, returns its value.
```q
q)getenv `SHELL
"/bin/bash"
q)getenv `UNKNOWN      / returns empty if variable not defined
""
```


## `gtime`

Syntax: `gtime ts`

where `ts` is a datetime/timestamp, returns the UTC datetime/timestamp. 
Recall that the UTC and local datetime/timestamps are available as [`.z.z`](dotz/#zz-utc-datetime)/[`.z.p`](dotz/#zp-utc-timestamp) and [`.z.Z`](dotz/#zz-local-datetime)/[`.z.P`](dotz/#zp-local-timestamp) respectively.
```q
q).z.p
2009.10.20D10:52:17.782138000
q)gtime .z.P                      / same timezone as .z.p
2009.10.20D10:52:17.783660000
```


## `ltime`

Syntax: `ltime ts`

where `ts` is a datetime/timestamp, returns the local datetime/timestamp. 
Recall that the UTC and local datetime/timestamps are available as [`.z.z`](dotz/#zz-utc-datetime)/[`.z.p`](dotz/#zp-utc-timestamp) and [`.z.Z`](dotz/#zz-local-datetime)/[`.z.P`](dotz/#zp-local-timestamp) respectively.
```q
q).z.P
2009.11.05D15:21:10.040666000
q)ltime .z.p                  / same timezone as .z.P
2009.11.05D15:21:10.043235000
```


## `setenv`

Syntax: `x setenv y`

where `x` is a symbol atom and `y` is a string, sets the environment variable `x` names.
```q
q)`RTMP setenv "/home/user/temp"
q)getenv `RTMP
"/home/user/temp"
q)\echo $RTMP
"/home/user/temp"
```


## `.Q.gc` (garbage collect)

Amount of memory returned to the OS.  
<i class="far fa-hand-point-right"></i> [`.Q.gc`](dotq/#qgc-garbage-collect)


