/ calls.q
/ Generate some random computer statistics (CPU usage only)
/ You can modify n (number of unique computers), timerange (how long the data is for)
/ freq (how often a computer publishes a statistic) 
/ and calls (the number of logged calls)
n:1000; timerange:5D; freq:0D00:01; calls:3000
depts:`finance`packing`logistics`management`hoopjumping`trading`telesales
startcpu:(til n)!25+n?20 
fcn:n*fc:`long$timerange%freq

computer:([]
    time:(-0D00:00:10 + fcn?0D00:00:20)+fcn#(.z.p - timerange)+freq*til fc; 
    id:raze fc#'key startcpu
    )
computer:update `g#id from `time xasc update cpu:{
    100&3|startcpu[first x]+sums(count x)?-2 -1 -1 0 0 1 1 2
    }[id] by id from computer

/ Generate some random logged calls
calls:([] 
    time:(.z.p - timerange)+asc calls?timerange; 
    id:calls?key startcpu; 
    severity:calls?1 2 3
    )

/ Create a lookup table of computer information
computerlookup:([id:key startcpu] dept:n?depts; os:n?`win7`win8`osx`vista)
