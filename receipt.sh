#!/bin/bash

if [ -z "$1" ]
  then
    echo "No trx supplied"
fi
address=$1
echo "Checking receipt for trx $address"

n1=$(geth attach http://localhost:20000 --exec "eth.getTransactionReceipt(\"$address\");" )
n2=$(geth attach http://localhost:20002 --exec "eth.getTransactionReceipt(\"$address\");" )
n3=$(geth attach http://localhost:20004 --exec "eth.getTransactionReceipt(\"$address\");" )
n4=$(geth attach http://localhost:20006 --exec "eth.getTransactionReceipt(\"$address\");" )

echo "Node1: $n1"
echo "Node2: $n2"
echo "Node3: $n3"
echo "Node4: $n4"

