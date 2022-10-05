#!/bin/bash
echo "Clean previous artifacts"
rm -rf artifacts
echo "Generate new artifacts"
npx quorum-genesis-tool --consensus qbft --chainID 1337 --blockperiod 5 --requestTimeout 10 --epochLength 30000 --difficulty 1 --gasLimit '0xFFFFFF' --coinbase '0x0000000000000000000000000000000000000000' --validators 4 --members 0 --bootnodes 0 --outputPath 'artifacts'
echo "Copy artifacts to config files"
mkdir config
cp -rf artifacts/*/* config/
echo "Generate tessera keys"
tessera -keygen -filename tm1 -filename tm2 -filename tm3 -filename tm4
rm -rf keys
mkdir keys 
mv tm* keys/

