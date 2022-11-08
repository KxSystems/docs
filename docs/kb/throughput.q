STDOUT: -1

SYMS: -1000?`3
EXCHANGES: 10#.Q.A
getRandomTrades: {[N] ([]sym: N?SYMS; time: N?.z.t; price: N?100e; size: N?1000i; stop:N?0b; cond:N?.Q.A; ex:N?EXCHANGES)}

t1: getRandomTrades 1
t10: getRandomTrades 10
t100: getRandomTrades 100
t1000: getRandomTrades 1000
t10000: getRandomTrades 10000

tradeNew: 0#t1;

tmp:value"\\t do[1000000;tradeNew,:t1]" / prepare space

tradeNew:0#t1
ms:value"\\t do[1000000;tradeNew,:t1]"
tmp:STDOUT(string 0.001*floor 0.5+(count tradeNew)%ms)," million inserts per second (single insert)"

tradeNew:0#t1
ms:value"\\t do[100000;tradeNew,:t10]"
tmp:STDOUT(string 0.001*floor 0.5+(count tradeNew)%ms)," million inserts per second (bulk insert 10)"

tradeNew:0#t1
ms:value"\\t do[10000;tradeNew,:t100]"
tmp:STDOUT(string 0.001*floor 0.5+(count tradeNew)%ms)," million inserts per second (bulk insert 100)"

tradeNew:0#t1
ms:value"\\t do[1000;tradeNew,:t1000]"
tmp:STDOUT(string 0.001*floor 0.5+(count tradeNew)%ms)," million inserts per second (bulk insert 1000)"

tradeNew:0#t1
ms:value"\\t do[100;tradeNew,:t10000]"
tmp:STDOUT(string 0.001*floor 0.5+(count tradeNew)%ms)," million inserts per second (bulk insert 10000)"

exit 0