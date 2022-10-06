#!/usr/bin/env bash

PSI="PS1"
NODE_EOA=0x0
data=""
function getData() {
    PSI=$1
    NODE_EOA=${2:-0x0}
    if [[ "$PSI" == "" ]]; then
        echo "Please specify a private state identifier (PSI)"
        exit 1
    fi

    data="{
        \"grant_types\":[\"client_credentials\"],
        \"token_endpoint_auth_method\":\"client_secret_post\",
        \"audience\":[\"node1\"],
        \"client_id\":\"$PSI\",
        \"client_secret\":\"foofoo\",
        \"scope\":\"rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules psi://$PSI?self.eoa=0x0&node.eoa=$NODE_EOA\"
    }"
}


# Cleanup previous clients
a=$(curl -k -s -q -X DELETE http://localhost:4445/clients/A)
b=$(curl -k -s -q -X DELETE http://localhost:4445/clients/B)
c=$(curl -k -s -q -X DELETE http://localhost:4445/clients/C)

### Create clients 
getData "PSA"
a=$(curl -k -s -X POST http://localhost:4445/clients -H "Content-Type: application/json" --data "$data")
tokenA=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=$PSI" -F "client_secret=foofoo" -F "scope=rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules psi://$PSI?self.eoa=0x0&node.eoa=$NODE_EOA" -F "audience=node1" http://localhost:4444/oauth2/token | jq '.access_token' -r)

getData "PSB"
b=$(curl -k -s -X POST http://localhost:4445/clients -H "Content-Type: application/json" --data "$data") 
tokenB=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=$PSI" -F "client_secret=foofoo" -F "scope=rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules psi://$PSI?self.eoa=0x0&node.eoa=$NODE_EOA" -F "audience=node1" http://localhost:4444/oauth2/token | jq '.access_token' -r)

getData "PSC"
c=$(curl -k -s -X POST http://localhost:4445/clients -H "Content-Type: application/json" --data "$data")
tokenC=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=$PSI" -F "client_secret=foofoo" -F "scope=rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules psi://$PSI?self.eoa=0x0&node.eoa=$NODE_EOA" -F "audience=node1" http://localhost:4444/oauth2/token | jq '.access_token' -r)

echo "{
    \"A\":\"Bearer $tokenA\", 
    \"B\":\"Bearer $tokenB\",
    \"C\":\"Bearer $tokenC\"
}"
# geth attach https://localhost:20000?PSI=A --rpcclitls.insecureskipverify --rpcclitoken "Bearer $tokenA"
