#!/bin/bash

if [ -z "$1" ]
  then
    echo "No address provided"
    exit -1
fi
address=$1
echo "Checking storage for contract $address"

bearers=$(./mt-generate-tokens.sh)
#echo "bearers: $bearers"
tokenA=$(echo $bearers | jq -r .A)
tokenB=$(echo $bearers | jq -r .B)
tokenC=$(echo $bearers | jq -r .C)

n1=$(geth attach "https://localhost:20000?PSI=PSA" --rpcclitls.insecureskipverify --rpcclitoken "$tokenA" --exec "loadScript('./live/storage.js'); getStorage(\"$address\");" )
n1_ps1=$(geth attach "https://localhost:20000?PSI=PSB" --rpcclitls.insecureskipverify --rpcclitoken "$tokenB" --exec "loadScript('./live/storage.js'); getStorage(\"$address\");" )
n1_ps2=$(geth attach "https://localhost:20000?PSI=PSC" --rpcclitls.insecureskipverify --rpcclitoken "$tokenC" --exec "loadScript('./live/storage.js'); getStorage(\"$address\");" )
n2=$(geth attach http://localhost:20002 --exec "loadScript('./live/storage.js'); getStorage(\"$address\");" )
n3=$(geth attach http://localhost:20004 --exec "loadScript('./live/storage.js'); getStorage(\"$address\");" )
n4=$(geth attach http://localhost:20006 --exec "loadScript('./live/storage.js'); getStorage(\"$address\");" )

echo "Node1: $n1"
echo "Node1_ps1: $n1_ps1"
echo "Node1_ps2: $n1_ps2"
echo "Node2: $n2"
echo "Node3: $n3"
echo "Node4: $n4"

