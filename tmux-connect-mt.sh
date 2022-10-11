#!/bin/bash

set -x

bearers=$(./mt-generate-tokens.sh)
#echo "bearers: $bearers"
tokenA=$(echo $bearers | jq -r .A)
tokenB=$(echo $bearers | jq -r .B)
tokenC=$(echo $bearers | jq -r .C)

tmux splitw -v "geth attach 'https://localhost:20000?PSI=PSA' --rpcclitls.insecureskipverify --rpcclitoken \"$tokenA\" ; bash"\; \
    splitw -h "geth attach 'https://localhost:20000?PSI=PSB' --rpcclitls.insecureskipverify --rpcclitoken \"$tokenB\" ; bash"\; \
    selectp -t 1\; \
    splitw -h "geth attach 'https://localhost:20000?PSI=PSC' --rpcclitls.insecureskipverify --rpcclitoken \"$tokenC\" ; bash"\; \
    selectp -t 1\; ;
geth attach http://localhost:20002
