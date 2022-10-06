#!/bin/bash

bearers=$(./mt-generate-tokens.sh)
tokenA=$(echo $bearers | jq -r .A)
tokenB=$(echo $bearers | jq -r .B)
tokenC=$(echo $bearers | jq -r .C)

n1_PSA=$(geth attach https://localhost:20000?PSI=PSA --rpcclitls.insecureskipverify --rpcclitoken "$tokenA" --exec eth.blockNumber)
n1_PSB=$(geth attach https://localhost:20000?PSI=PSB --rpcclitls.insecureskipverify --rpcclitoken "$tokenB"  --exec eth.blockNumber)
n1_PSC=$(geth attach https://localhost:20000?PSI=PSC --rpcclitls.insecureskipverify --rpcclitoken "$tokenC" --exec eth.blockNumber)
n2=$(geth attach http://localhost:20002 --exec eth.blockNumber)
n3=$(geth attach http://localhost:20004 --exec eth.blockNumber)
n4=$(geth attach http://localhost:20006 --exec eth.blockNumber)

echo "Node1 PSA: $n1_PSA"
echo "Node1 PSB: $n1_PSB"
echo "Node1 PSC: $n1_PSC"
echo "Node2: $n2"
echo "Node3: $n3"
echo "Node4: $n4"