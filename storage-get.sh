#!/bin/bash

if [ -z "$1" ]
  then
    echo "No trx supplied"
    exit -1
fi
address=$1
echo "Checking storage for contract $address"

n1=$(geth attach http://localhost:20000 --exec "loadScript('./live/storage.js'); getStorage(\"$address\");" )
n2=$(geth attach http://localhost:20002 --exec "loadScript('./live/storage.js'); getStorage(\"$address\");" )
n3=$(geth attach http://localhost:20004 --exec "loadScript('./live/storage.js'); getStorage(\"$address\");" )
n4=$(geth attach http://localhost:20006 --exec "loadScript('./live/storage.js'); getStorage(\"$address\");" )

echo "Node1: $n1"
echo "Node2: $n2"
echo "Node3: $n3"
echo "Node4: $n4"

