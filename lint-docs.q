/
title: Test a MkDocs instance for conformity to code.kx.com/authors
usage: q lint-docs.q [-cfg xxx.yml] [-debug 1] [-http 0] [-public 0]
exit: 0: OK; 1: warnings; 2: errors; 99: no config file found
notes: uses proper names defined in proper_names.txt, if found
\
/ Script parameters
DEF:`cfg`debug`http`public!("mkdocs.yml";0b;1b;1b)   /defaults
OPTS:.Q.opt .z.x / Command-line options
opts:DEF,@[OPTS;`debug`http`public inter key OPTS;("B"$first@)]
/ CONFIG:{$[count x; x; "mkdocs.yml"]}OPTS`cfg
/ DEBUG:`debug in key OPTS
/ MODE:`public`private `private in key OPTS
/ HTTP:not `nohttp in key OPTS
/ Error log
msg:{[lvl;err;z] / z is (a) list of file paths or (b) filepaths!lists of strings
  if[ec:count z; / error count
    `LOG upsert update lvl:lvl,issue:err from $[type[z]=98; z; ([]path:z;str:count[z]#enlist"")];
    show(3#(`ERROR`WARNING!"*!")lvl)," ",(string ec)," ",(lower string lvl),((ec>1)#"s")," of ",string err
  ]; }
ERROR:msg[`ERROR;;]
WARN:msg[`WARNING;;]
LOG:([]lvl:0#`;issue:0#`;path:0#enlist"";str:0#enlist"")

yml:@[read0;hsym`$opts`cfg;()]
if[0=count yml;show"CONFIGURATION FILE mkdocs.yml NOT FOUND"; exit 99]
yml:(read0`$":base-config.yml"),yml
dq:{$["''"~(first;last)@\:x;1_-1_x;x]}  / dequote
fc:{dq trim{(1+x?":")_x}x first where x like y,":*"}[yml;] / from configuration
docsdir:{neg[last x="/"]_x}fc"docs_dir"
siteurl:fc"site_url"

show "Testing source for ",siteurl," as ",("private";"public")[opts`public]," with HTTP ",("off";"on")opts`http

/ list documents
DOCS:{ky:key hxy:`$":",p:x,string y;
  $[ky~hxy;enlist p;raze(p,"/").z.s/:ky]}[""]`$docsdir
show(string count DOCS)," files found"

ERROR[`UC_FILE_NAME;]
  {x where any each x in .Q.A} {x where not (count ss[;"/."]@)each x}
  DOCS where 00b~/:DOCS like/:\: docsdir,/:("/scripts/*";"/stylesheets/*")

/ Markdown contents
MD:{x!read0 each `$":",'x} DOCS where DOCS like "*.md" / Markdown contents
show(string count MD)," Markdown files found"

YamlFromMd:{[lns] / YAML metadata from lines
  if[not first[lns]~"---"; :()!()]; / no metadata
  {i:x?'":";(`$i#'x)!(i+2)_'x}1_#[;lns](1_lns)?enlist"---" }

metadata:YamlFromMd each value MD
msg[`WARNING`ERROR opts`public;`YAML_METADATA_MISSING;]
  key[MD] where not all `title`description in/:key each metadata

msg[`WARNING`ERROR opts`public;`YAML_META_DESCRIPTION_LENGTH;]
  key[MD] where {x and x within 200 300}count each metadata@\:`description

/ headings
fwds:{(x?'" ")#'x} / first words
hdgs:{x where min(count;all)@/:\:"#"=fwds x}each value MD
hdgs:{trim x where{x|next x}" "<>x}''[hdgs]  / collapse multiple spaces
lvls:(count'')fwds each hdgs  / heading levels
ERROR[`NOT_SINGLE_H1]
  key[MD] where 1<>raze sum each lvls=1
WARN[`HEADINGS_DEEPER_THAN_H4]
  key[MD] where 0<raze sum each lvls>4

/ Capitalized words commonly found in headings
CWCFIH,:"KX ",/:CWCFIH:string`Analyst`Analytics`Connect`Control`Dashboards`Developer`Insights`Microservices`Monitoring`Platform`Refinery`Stream
CWCFIH,:("KX Data Refinery";"Delta Control")
CWCFIH,:string`AWS`Amazon`Azure`Docker`Google`KX`Linux`Microsoft`Tomcat`Windows
CWCFIH,:string`API`APIs`CLI`CPU`CSV`EOD`Git`GUI`HDB`HTML`HTTP`HTTPS`ID`Java`JRE`JS`JSON`JRXML`JRXMLs`JVM`Kafka`LDAP`MD5
CWCFIH,:string`ODBC`OS`PDF`Python`RAM`RDB`REST`RTE`SAML`SFTP`SNMP`SSL`SSO`TLS`UI`UTC`URL`WebSocket`Web`XML`ZIP
CWCFIH,:(".NET";"C#";"C++";"Java Runtime Environment";"Java Virtual Machine";"Red Hat";"Visual Studio")
if[{not x~key x}`:proper_names.txt; show"!!! WARNING: no proper_names.txt list found"]
toa:@[read0;`:proper_names.txt;()]  / terms of art for these socuments
PUNCTUATION:",;:()"
mask:{$[.[<]c:count each(x;y);x;x where{y&(x#1b),neg[x]_y}[c 1;]not(<>\)(til c 0)in x ss y]}
rce:mask/[;3 2 1#'"`"]  / remove code elements from Markdown string
notSentenceCase:{[ignore;str]
  s:rce str;
  s:(in[;"#:"]first@){(1+x?" ")_x}/s;       / drop leading ##s and icon
  s:@[s;where s in PUNCTUATION;:;" "];      / words: all but first after heading level
  w:" "vs ssr/[s;ignore;" "];               / remove proper names
  any(first each 1_w)in .Q.A }[{x idesc count each x}CWCFIH,toa;]
/ NB separate test for words that begin with a dot

insc:where any each nsc:notSentenceCase''[hdgs]
tabul8:{([]path:x where count each y; str:raze y)}
ERROR[`HEADING_NOT_SENTENCE_CASE;]
  tabul8[key[MD] insc; hdgs[insc]@'where each nsc insc]

/ code fences
cf:"```"~/:/:3#''value MD / flag code fences
ERROR[`UNBALANCED_CODE_FENCES]
  key[MD] where mod[;2] sum each cf
/ flag unlabelled opening code fences
uocf:0=(count'')3_''value[MD]@'{x where mod[;2]1+til count x}each where each cf
/ Watch Out: unbalanced code fences cause erroneous results
ERROR[`UNLABELLED_OPENING_CODE_FENCE]
  key[MD] where any each uocf

bdy:" "sv'value[MD]{x where y}'not{x|prev each x}<>\'[cf] / body text as strings
ubt:mod[;2]sum each bdy="`"  / flag unmatched back ticks
ERROR[`UNMATCHED_BACKTICKS]
  key[MD] where ubt

@[`bdy;where not ubt;rce];
/ unmatched backticks in the body text cause false results in following tests

wds:(" "vs'bdy)except\:("";".)";".\"";".NET"),1#'",.;:"  / body text as words, sans punctuation
aeisc:where 0<count each isc:where each"."=(first'')wds / flag code words, e.g. .api.fn
ERROR[`CODE_AS_PLAIN_TEXT]
  tabul8[key[MD] aeisc; distinct each wds[aeisc]@'isc aeisc]

/ Non-US spellings
STEMS:string`analyse`analysing`authoris`behaviour`colour`customis`deserialis`initialis`serialis`summaris
isi:where any each si:0<(count'')lower[bdy] ss/:\:STEMS / find files with spelling issues
ERROR[`NON_US_SPELLING]
  tabul8[key[MD]isi; STEMS where each si isi]

/ LINKS .......................................................................
lfm:{min[x?" )"]#x}each 1_ "]("vs ::  / links from Markdown string
ll:`path`href xcol tabul8[key MD;lfm each bdy]  / list of links

/ ERROR[`LINK_TO_SITE_ROOT]
/   select path,str:href from ll where "/"=first each href

ERROR[`INTERNAL_HTTP_LINK]
  select path,str:href from ll where href like{x,"*"}siteurl

update typ:`rel`eml`abs``abs 2 sv'href like/:\:("http://*";"https://*";"mailto:*") from `ll;  / href type

ERROR[`LINK_TO_V2]
  select path,str:href from ll where typ=`abs, any href like/:{("http";"https"),\:x}"://code.kx.com/v2*"

lvl:{$["../"~3#y;.z.s[x+1;3_y];(x;y)]}[0;] {(2*"./"~2#x)_x}@
fullurl:{
  $[(x`typ)in`abs`eml; x`href; / absolute URL or email href
    "#"=first x`href; x[`path],x`href; / bookmark
    "/"sv{((neg y+1)_"/"vs x),enlist z}[x`path;;]. lvl x`href ] }
update url:fullurl each ll from `ll;

db:{(x?"#")#x}  / drop bookmark
ERROR[`LINK_TO_BOOKMARK_NAMES_FILE]
  select path,str:href from ll where path~'db each url,0<(count db@)each href

/ return-code lists
update rc:enlist each 404 200((url?'"#")#'url)in DOCS from `ll where typ=`rel;
ERROR[`BROKEN_INTERNAL_LINK]
  select path,str:href from ll where typ=`rel,last'[rc]=404

/ External links
external_http:select distinct url from ll where typ=`abs  / distinct absolute URLs
show("Skipped testing ";"Testing ")[opts`http],(string count external_http)," external links"
if[opts`http;
  hrc:{[url]"J"$@[;1]each" "vs'{x where x like\:"HTTP/[12]*"}system"curl -ILs ",url};
  update rc:hrc each url from `external_http; / lists of HTTP return codes
  update rc:((!). external_http`url`rc)url from `ll where typ=`abs;  
  ERROR[`BROKEN_LINK]
    select path,str:url from ll where typ=`abs,last'[rc]=404;
  WARN[`AUTHENTICATION_FAILED]
    select path,str:url from ll where typ=`abs,last'[rc]within 400 403;
  WARN[`HTTP_REDIRECTION]
    select path,str:url from ll where typ=`abs,first'[rc]in 301 302,last'[rc]=200; ]

save `LOG.csv
save `external_http.csv
cnt:(`ERROR`WARNING!0 0),count each group LOG`lvl
show string[cnt`ERROR]," errors found; ",string[cnt`WARNING]," warnings"
if[not opts`debug; exit "j"$2&2 sv 0<value cnt]  / 0: OK; 1: warnings; 2: errors

/
ERROR
- [x]   upper case in file name
- [x]   No YAML metadata (warning if private)
- [x]   Not exactly one H1
- [x]   unbalanced code fence
- [x]   unlabelled code fence
- [x]   Non-US spellings
- [x]   configuration file missing
- [x]   Broken external link
- [x]   Broken internal link
- [x]   Internal link as HTTP/S
- [x]   Link to bookmark names file

WARNING
- [x]   Heading not in sentence case
- [x]   Authentication failed on external link
- [x]   HTTP redirection on external link
- [x]   Heading depth > 4

WISHLIST
- [ ]  Orphaned closing brace on function
- [ ]  HTML icons (i.e. not Markdown emojis)
