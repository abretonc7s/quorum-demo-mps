
The demo provides configuration for 4 validators node network using QBFT consensus algorithm.
- node1
- node2
- node3
- node4

We provide 3 differents configuration setup:
- `docker-compose.yml`: 4 single tenant nodes with private transaction manager.
- `docker-compose-mps.yml`: 1 node using multiple private states on the transaction manager (`enableMultiplePrivateStates=true`)
- `docker-compose-mt.yml`: Enable security plugin + multitenancy to secure RCP endpoints.


For this demo we focus on 2 nodes, node1 is multi-tenant (isMPS=true) and has 3 tenants:  tenant A, tenant B, tenant C
- A has a single member A_K1
- B has has 2 members B_K1, B_K2
- C has a single member C_K1
```json
"residentGroups":[
    {
        "name":"PSA",
        "description":"Tenant A [A_k1]",
        "members":["mbW7Y2t3Hblq/xxo4ZnC8tfMIUiTgdjuGvTL2L8EHGA="]
        },
        {
        "name":"PSB",
        "description":"Tenant B [B_k1, B_k2]",
        "members":["SRw9AGCJ7OV3y8AhPH6EPRp+ltAuxXMCBPcH4wNbBnE=","7SsHdJWcBLp4N65EtxpWsWuom/JrF3LcCOjL7DJ22XE="]
        },
        {
        "name":"PSC",
        "description":"Tenant C [C_k1]",
        "members":["NyshKkK44YOJF92OI5udcHR9FXmaGglkL1JrPQF8Bjk="]
    }
]
```
The second node node2 is single-tenant (isMPS=false) and contains C_K1.

`A_K1,B_K1,B_K2,C_K1` are all references to public keys to use in the `privateFor` field in order to create private transactions.

# Setup1: Private Transactions
```bash
docker compose up -d

# Check that all nodes are working
./status.sh

# Check that public contract is available on all nodes
geth attach http://localhost:20002 --exec 'loadScript("live/public-contract.js")'
./receipt.sh 0x291b4d4d1589212d9dc707fd8328b8d06cbef93d66b7be4974fffe5d2185da4b
./storage-get.sh 0xdd79a0ef8250ebc98af4890745147a554990bfc6
./storage-set.sh 0xdd79a0ef8250ebc98af4890745147a554990bfc6 15
./storage-get.sh 0xdd79a0ef8250ebc98af4890745147a554990bfc6

# Deploy private contract between node1 and node2
geth attach http://localhost:20000 --exec 'loadScript("live/private-contract.js")'
./receipt.sh 0x57bbfd1b7f9bcd4d235ffeb929827d4aaba948b700844d03481a4ba179d1def0
./storage-get.sh  0xeeca75f56c09f566d1092849b7e0b26d68d799a4

docker compose down
```

# Setup2: MPS
```bash
docker compose -f docker-compose-mps.yml up -d --no-deps --build --force-recreate   

# Verify that we now have 6 private states
 ./status-mps.sh

# Attach to node2 and deploy private accumulator contract with [A_K1,B_K1]
geth attach http://localhost:20002 --exec 'loadScript("live/acc-contract.js")' 
./receipt.sh 0x17c9e1b419e7f26a5d90c794fad229df1d43e6cbfd3c19adbbfdc4cf7318ea39
```

```js
var address = "0xdd79a0ef8250ebc98af4890745147a554990bfc6";
var abi = [{"constant":true,"inputs":[],"name":"storedData","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"inc","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"initVal","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"value","type":"uint256"}],"name":"IncEvent","type":"event"}];
var acc = eth.contract(abi).at(address)
acc.IncEvent().watch( function (error, log) {
    console.log("\nIncEvent details:")
    console.log("    NewValue:", log.args.value)
});
acc.get()
eth.getPSI()
```

```bash
# Connect to each node to visualize changes
./tmux-connect.sh
```

```js
// Increment from Node2 with privateFor[ A_K1 ]
acc.inc(1,{from:eth.accounts[0],privateFor:["mbW7Y2t3Hblq/xxo4ZnC8tfMIUiTgdjuGvTL2L8EHGA="]});
// Increment from Node2 with privateFor[ B_K1 ]
acc.inc(1,{from:eth.accounts[0],privateFor:["SRw9AGCJ7OV3y8AhPH6EPRp+ltAuxXMCBPcH4wNbBnE="]});
```

```bash
docker compose -f docker-compose-mps.yml down
```

# Setup3: Multi Tenancy with Security Plugins

```bash
docker compose -f docker-compose-mt.yml up -d --no-deps --build --force-recreate   

# notice we now connect to the node via https because of the security plugin
docker exec node1 geth attach https://localhost:8545 --rpcclitls.insecureskipverify

# Use the `mtAttachWithPSI.sh` script to connect to node1 as any of the 3 tenants ( PSA, PSB, PSC).
# The script configures the relevant access for the tenant on the OAUTH2 server and then requests a token. 
# It then uses the token to attach (`geth attach`) to node1. 
./mtAttachWithPSI.sh PSA
```

Scopes:
- rpc://eth_* 
- rpc://quorumExtension_* 
- rpc://rpc_modules 
- psi://$PSI?self.eoa=0x0&node.eoa=$NODE_EOA

```bash
# Use utility script to generate Token for each private states.
./mt-generate-tokens.sh

export token=$(./mt-generate-tokens.sh | jq -r .A)
docker exec -it node1 geth attach https://localhost:8545 --rpcclitls.insecureskipverify  --rpcclitoken "$token"

# try the token with different private states
## Able to access PSA
curl -k -X POST https://localhost:20000?PSI=PSA -H "Content-type: application/json" \
         -H "Authorization: $token" \
       --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
## Not Authorized - Unable to access PSB
curl -k -X POST https://localhost:20000?PSI=PSB -H "Content-type: application/json" \
         -H "Authorization: $token" \
       --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'


# Verify that we can use a bearer for each private state 
./status-mt.sh

# Verify that limited scope permissions are working
export token=$(./mt-generate-tokens.sh | jq -r .limited )
geth attach https://localhost:20000?PSI=PSA --rpcclitls.insecureskipverify --rpcclitoken "$token" --exec eth.blockNumber
geth attach https://localhost:20000?PSI=PSA --rpcclitls.insecureskipverify --rpcclitoken "$token" --exec "eth.getBalance(\"0x43f18d5acfaf81a866082b9c68a785154d56b16c\")"


### From PSA, Import 2 nodes managed wallet -> wallet1 , wallet2
# 1- import wallets
personal.importRawKey("87f8c55e037ddb6dbbe454c7500f7c3d4232892aa19405a47bc75786f0882ff9", "") 
personal.unlockAccount("0x50b09ec167697863f5f8fbc124022d8c893b73c5", "", 1500)
personal.importRawKey("ebcb6cddfbb2c5b6293de38a92a7dbe974888ce0061863d4e4784d6bdc3561c7", "") 
personal.unlockAccount("0x1fE7E194edB898864FF7B6b09b91a93076FaAF4B", "", 1500)
# 2- Make sure the accounts are funded. 10eth each
eth.sendTransaction({from: "0x339a6e3a8d47882c5be9b0e901360649600d1868", to: "0x50b09ec167697863f5f8fbc124022d8c893b73c5", value: "10000000000000000000"})
eth.sendTransaction({from: "0x339a6e3a8d47882c5be9b0e901360649600d1868", to: "0x1fE7E194edB898864FF7B6b09b91a93076FaAF4B", value: "10000000000000000000"})

# Check token 
export bearer=$(./mt-generate-tokens.sh | jq -r .limited2 | awk '{print $2}')
curl -X POST -d "token=$bearer" http://localhost:4445/oauth2/introspect

# Verify that self-managed accounts permissions are working
# deploy accumulator contract 
geth attach http://localhost:20002 --exec 'loadScript("live/acc-contract.js")' 
./receipt.sh 0x7313748616a5e33547191a0ae07126c053de2c26aeb3a95b40e8aa25852ddd84
# WARNING - remember to change contract address address in permissions.js 
node permissions.js node1 $bearer
node permissions.js wallet1 $bearer
node permissions.js wallet2 $bearer

docker compose -f docker-compose-mt.yml down
```

