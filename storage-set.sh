#!/bin/bash

if [ -z "$1" ]
  then
    echo "No trx supplied"
fi
address=$1
value=$2
echo "Set storage to $value for contract $address"

n1=$(geth attach http://localhost:20002 --exec "loadScript('./live/storage.js'); setStorage(\"$address\", $value);" )

echo "Storage has been set. Verify new value..."
sleep 5
./storage-get.sh $address $value
