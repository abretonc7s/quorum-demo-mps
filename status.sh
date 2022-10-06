#!/bin/bash

n1=$(geth attach http://localhost:20000 --exec eth.blockNumber)
n2=$(geth attach http://localhost:20002 --exec eth.blockNumber)
n3=$(geth attach http://localhost:20004 --exec eth.blockNumber)
n4=$(geth attach http://localhost:20006 --exec eth.blockNumber)

echo "Node1: $n1"
echo "Node2: $n2"
echo "Node3: $n3"
echo "Node4: $n4"