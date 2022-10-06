#!/bin/bash

n1_PSA=$(geth attach http://localhost:20000?PSI=PSA --exec eth.blockNumber)
n1_PSB=$(geth attach http://localhost:20000?PSI=PSB --exec eth.blockNumber)
n1_PSC=$(geth attach http://localhost:20000?PSI=PSC --exec eth.blockNumber)
n2=$(geth attach http://localhost:20002 --exec eth.blockNumber)
n3=$(geth attach http://localhost:20004 --exec eth.blockNumber)
n4=$(geth attach http://localhost:20006 --exec eth.blockNumber)

echo "Node1_PSA: $n1_PSA"
echo "Node1_PSB: $n1_PSB"
echo "Node1_PSC: $n1_PSC"
echo "Node2: $n2"
echo "Node3: $n3"
echo "Node4: $n4"