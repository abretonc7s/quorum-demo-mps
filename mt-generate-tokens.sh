#!/usr/bin/env bash

PSI="PS1"
NODE_EOA=0x0
data=""
scope=""
access=""
client_id=""
wallet=$(cat ./keys/wallet.pub)

function getData() {
    PSI=$1
    NODE_EOA=${2:-0x0}
    SELF_EOA=${3:-0x0}
    client_id=$PSI # Can be overwritten with $5

    if [[ "$PSI" == "" ]]; then
        echo "Please specify a private state identifier (PSI)"
        exit 1
    fi

    access="psi://$PSI?self.eoa=$SELF_EOA&node.eoa=$NODE_EOA"
    scope="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules rpc://admin_* rpc://personal_* $access"


    if [[ "$4" != "" ]]; then
        client_id=$4
    fi

    if [[ "$5" != "" ]]; then
        scope="$5"
    fi


    data="{
        \"grant_types\":[\"client_credentials\"],
        \"token_endpoint_auth_method\":\"client_secret_post\",
        \"audience\":[\"node1\"],
        \"client_id\":\"$client_id\",
        \"client_secret\":\"foofoo\",
        \"scope\":\"$scope\"
    }"
}


# getData "PSA" 0x0 $wallet "rpc://eth_blockNumber" "limited"
# echo "wallet: $wallet"
# echo "data: $data"
# echo "scope: $scope"

# Cleanup previous clients
a=$(curl -k -s -q -X DELETE http://localhost:4445/clients/PSA)
b=$(curl -k -s -q -X DELETE http://localhost:4445/clients/PSB)
c=$(curl -k -s -q -X DELETE http://localhost:4445/clients/PSC)
limited=$(curl -k -s -q -X DELETE http://localhost:4445/clients/limited)
limited2=$(curl -k -s -q -X DELETE http://localhost:4445/clients/limited2)

### Create clients 
getData "PSA" 
a=$(curl -k -s -X POST http://localhost:4445/clients -H "Content-Type: application/json" --data "$data")
tokenA=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=$client_id" -F "client_secret=foofoo" -F "scope=$scope" -F "audience=node1" http://localhost:4444/oauth2/token | jq '.access_token' -r)

getData "PSB"
b=$(curl -k -s -X POST http://localhost:4445/clients -H "Content-Type: application/json" --data "$data") 
tokenB=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=$client_id" -F "client_secret=foofoo" -F "scope=$scope" -F "audience=node1" http://localhost:4444/oauth2/token | jq '.access_token' -r)

getData "PSC"
c=$(curl -k -s -X POST http://localhost:4445/clients -H "Content-Type: application/json" --data "$data")
tokenC=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=$client_id" -F "client_secret=foofoo" -F "scope=$scope" -F "audience=node1" http://localhost:4444/oauth2/token | jq '.access_token' -r)

getData "PSA" 0x0 $wallet "limited" "rpc://eth_getBalance rpc://eth_getPSI rpc://rpc_modules psi://PSA?node.eoe=0x0&self.eoa=0x0" 
limited=$(curl -k -s -X POST http://localhost:4445/clients -H "Content-Type: application/json" --data "$data")
tokenLimited=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=$client_id" -F "client_secret=foofoo" -F "scope=$scope" -F "audience=node1" http://localhost:4444/oauth2/token | jq '.access_token' -r)

getData "PSA" 0x0 $wallet "limited2" "rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules psi://PSA?node.eoa=$wallet" 
limited2=$(curl -k -s -X POST http://localhost:4445/clients -H "Content-Type: application/json" --data "$data")
tokenLimited2=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=$client_id" -F "client_secret=foofoo" -F "scope=$scope" -F "audience=node1" http://localhost:4444/oauth2/token | jq '.access_token' -r)

echo "{
    \"A\":\"Bearer $tokenA\", 
    \"B\":\"Bearer $tokenB\",
    \"C\":\"Bearer $tokenC\",
    \"limited\":\"Bearer $tokenLimited\",
    \"limited2\":\"Bearer $tokenLimited2\",
    \"limited-scope\":\"$scope\",
    \"limited-data\":$data
}"
# geth attach https://localhost:20000?PSI=PSA --rpcclitls.insecureskipverify --rpcclitoken "$tokenA"
# export token=$(./mt-generate-tokens.sh | jq -r .limited )
# geth attach https://localhost:20000?PSI=PSA --rpcclitls.insecureskipverify --rpcclitoken "$token" --exec eth.blockNumber
# geth attach https://localhost:20000?PSI=PSA --rpcclitls.insecureskipverify --rpcclitoken "$token" --exec eth.getBalance "0x43f18d5acfaf81a866082b9c68a785154d56b16c"
