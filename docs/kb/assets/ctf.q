/ copy a text file
USAGE: "q ctf.q -src file [-tgt file] [-log file] [-test 0|1]"

/ environment
.env.parms:first each .Q.opt .z.x

/ exit codes: 0 for OK; 3000 and up for errors
.env.ec:{flip `code`msg`rc!flip x,'0,3000+til count[x]-1}(
  (`OK;                 "");
  (`INVALID_PARM;       "Invalid parameter/s specified");
  (`NO_INPUT;           "No input file specified");
  (`INPUT_NOT_FOUND;    "No input file found");
  (`OUTPUT_EXISTS;      "Output file exists");
  (`LOGFILE_EXISTS;     "Logfile exists");
  (`INPUT_READ;         "Unable to read input file");
  (`OUTPUT_WRITE;       "Unable to write output file") )

.env.valid:{[p]
  p[`tgt]:{$[count x;x;"copy.txt"]}p`tgt; 				/ default target
  p[`log]:{$[count x;x;"ctf.log"]}p`log;  				/ default log

  p[`SRC`TGT`LOG]:`$":",'p`src`tgt`log;					/ file symbols
  
  err:();
  err,:$[count key[p]except`SRC`TGT`LOG`src`tgt`log`test;`INVALID_PARM;()];
  err,:$[`src in key p; (); `NO_INPUT];
  err,:`INPUT_NOT_FOUND`OUTPUT_EXISTS`LOGFILE_EXISTS 
    where 011b={x~key x}each p`SRC`TGT`LOG;
  err:$[`NO_INPUT in err;err except`INPUT_NOT_FOUND;err];
  
  (err;p) }

/ file copying
.copy.file:{[src;tgt]
  $[`fail~s:@[read0;src;`fail]; `INPUT_READ;
    not tgt~tgt 0:s;            `OUTPUT_WRITE;
                                `OK] }
/ start work
.env.parms:first each .Q.opt .z.x						/ command-line parameters

TEST:"1"=first first .env.parms`test 					/ test mode, default 0b
1 ("PRODUCTION";"TEST")[TEST]," MODE\n";

result:{x,$[count x; (); .copy.file . y`SRC`TGT]}. .env.valid .env.parms 

/ report errors
if[first[result]=`OK; 1 "Copied ",sv[" to ";.env.parms`src`tgt],"\n"]
if[first[result]<>`OK;
  -1 (exec msg from .env.ec where code in result),enlist "usage: ",USAGE]

/ exit script
if[not TEST; 
  exit .[!;.env.ec`code`rc]first result]