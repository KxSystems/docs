system"l ." /load the HDB - can change this if you don't start Q from your hdb root
allpaths:{[dbdir;table] / from dbmaint.q + an extra check for paths that exist (to support .Q.bv)
 files:key dbdir;
 if[any files like"par.txt";:raze allpaths[;table]each hsym each`$read0(`)sv dbdir,`par.txt];
 files@:where files like"[0-9]*";
 files:(`)sv'dbdir,'files,'table;
 files where 0<>(count key@)each files}
sym:oldSym:get`:sym /to unenumerate
symFiles:raze` sv/:/:raze{allpaths[`:.;x],/:\:exec c from meta[x] where t in "s"}peach tables[] where {1b~.Q.qp value x}each tables[] /sym files from parted tables
symFiles,:raze{` sv/: hsym[x],/:exec c from meta x where t in "s"}each tables[] where {0b~.Q.qp value x}each tables[] /sym files from splayed tables
allsyms:distinct raze{[file] :distinct @[value get@;file;`symbol$()] } peach symFiles; /symbol files we're dealing with - memory intensive
.Q.gc[] /memory intensive so gc
/*** the part above this line doesn't make changes to the HDB. You can estimate the savings with
/count[allsyms]%count sym
/*** the rest of the script makes changes so there is no going back once you start. There shouldn't be anything writing to the HDB while the script is in progress
system"mv sym zym" /make backup of sym file
`:sym set `symbol$() /reset sym file - scary part
`sym set get`:sym 
.Q.en[`:.;([]allsyms)] /enumerate all syms at once
{[file]
  s:get file; /file contents
  a:first `p`s inter attr s; /attributes - due to no`g# error in threads - this can be just a:attr s if your version of kdb+ does support setting `g# in threads
  s:oldSym`int$s; /unenumerate against old sym file
  file set a#`sym$s; /enumerate against new sym file & add attrib & write to disk
  0N!"re-enumerated ", string file;
  } peach symFiles