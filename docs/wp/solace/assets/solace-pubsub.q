// Load sol_init.q which has all the PubSub+ configurations
\l sol_init.q
  
// Market Data queue to subscribe to
subQueue:`market_data
topicToMap:`$"EQ/marketData/v1/US/>"
  
-1"### Creating endpoint";
.solace.createEndpoint[;1i]
  `ENDPOINT_ID`ENDPOINT_PERMISSION`ENDPOINT_ACCESSTYPE`ENDPOINT_NAME!`2`c`1,subQueue
  
-1"### Mapping topic: ", (string topicToMap), " to queue";
.solace.endpointTopicSubscribe[;2i;topicToMap]`ENDPOINT_ID`ENDPOINT_NAME!`2,subQueue
  
// Create a global table for capturing L1 quotes and trades
prices:flip
  `date`time`sym`exchange`currency`askPrice`askSize`bidPrice`bidSize`tradePrice`tradeSize!
  `date`time`symbol`symbol`symbol`float`float`float`float`float`float$\:()

// Global table for stats
stats:flip 
  (`date`sym`time,
    `lowAskSize`highAskSize,
    `lowBidPrice`highBidPrice,
    `lowBidSize`highBidSize,
    `lowTradePrice`highTradePrice,
    `lowTradeSize`highTradeSize,
    `lowAskPrice`highAskPrice`vwap)!
  (`date`symbol`minute,
    `float`float,
    `float`float,
    `float`float,
    `float`float,
    `float`float,
    `float`float`float) $\:()
  
-1"### Registering queue message callback";

// Callback function for when a new message is received
subUpdate:{[dest;payload;dict]
  // Convert binary payload
  a:"c"$payload;   
  
  // Load JSON to kdb table
  b:.j.k "[",a,"]";
  
  // Send ack back to Solace broker
  .solace.sendAck[dest;dict`msgId];
  
  // Update types of some of the columns
  b:select "D"$date,"T"$time,sym:`$symbol,`$exchange,`$currency,askPrice,
    askSize,bidPrice,bidSize,tradePrice,tradeSize from b;
  // Insert into our global prices table
  `prices insert b; }

// Assign callback function
.solace.setQueueMsgCallback`subUpdate
.solace.bindQueue
  `FLOW_BIND_BLOCKING`FLOW_BIND_ENTITY_ID`FLOW_ACKMODE`FLOW_BIND_NAME!`1`2`2,subQueue

updateStats:{[rawTable]
  // Generate minutely stats on data from last minute
  `prices set rawTable:select  from rawTable where time>.z.T-00:01;
  
  min_stats:0!select 
    lowAskSize:    min askSize,     highAskSize:    max askSize,
    lowBidPrice:   min bidPrice,    highBidPrice:   max bidPrice,
    lowBidSize:    min bidSize,     highBidSize:    max bidSize,
    lowTradePrice: min tradePrice,  highTradePrice: max tradePrice,
    lowTradeSize:  min tradeSize,   highTradeSize:  max tradeSize,
    lowAskPrice:   min askPrice,    highAskPrice:   max askPrice,
    vwap:tradePrice wavg tradeSize 
    by date, sym, time:1 xbar time.minute
    from rawTable;
  
  min_stats:select from min_stats where time=max time;  
  
  // Inserts newly generated stats to global stats table
  `stats  insert min_stats;
  
  // Get all the unique syms
  s:exec  distinct sym from min_stats;
  
  // Generate topic we will publish to for each sym
  t:s!{"EQ/stats/v1/",string(x)} each s; 
  
  // Generate JSON payload from the table for each sym
  a:{[x;y] .j.j select  from x where sym=y}[min_stats;];
  p:s!a each s;
  
  // Send the payload
  l:{[x;y;z] .solace.sendDirect[`$x[z];y[z]]}[t;p];
  l each s; }
  
// Send generated stats every minute
\t 60000
.z.ts:{updateStats[prices]}
