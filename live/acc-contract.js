a = eth.accounts[0]
web3.eth.defaultAccount = a;

// abi and bytecode generated from simplestorage.sol:
// > solcjs --bin --abi simplestorage.sol
var abi = [{"constant":true,"inputs":[],"name":"storedData","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"inc","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"initVal","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"value","type":"uint256"}],"name":"IncEvent","type":"event"}];

var bytecode = "0x608060405234801561001057600080fd5b506040516020806101a78339810180604052602081101561003057600080fd5b8101908080519060200190929190505050806000819055505061014f806100586000396000f3fe608060405234801561001057600080fd5b506004361061005e576000357c0100000000000000000000000000000000000000000000000000000000900480632a1afcd9146100635780636d4ce63c14610081578063812600df1461009f575b600080fd5b61006b6100cd565b6040518082815260200191505060405180910390f35b6100896100d3565b6040518082815260200191505060405180910390f35b6100cb600480360360208110156100b557600080fd5b81019080803590602001909291905050506100dc565b005b60005481565b60008054905090565b80600054016000819055507fc13aa85405f3616d514cfd2316b12181b047ed7f229bce08ce53c671f6f94f986000546040518082815260200191505060405180910390a15056fea165627a7a72305820a73dae2a37060d514957796c5d3e8ed77a3b8e0a78f9e351c8290c67c73038190029";

var tm1 = "xFKHPnnq5dzJr6ZygHFD7qOyE/tZHPPuMpymsT47DUY=";
var tm2 = "wsfcqtINO3linaBlh4Md19rMlwmXT7GDEuvnPjz9PiY=";
var tm3 = "pcq3MgvkKgQC305pr6pYM5kRhpRpv/xqHWLlORfm/lM=";
var tm4 = "nBQZKghVf+JlhaQ+JuY6BPO/uCmm2cknZNTmbzyv/hQ=";
var A_K1 = "mbW7Y2t3Hblq/xxo4ZnC8tfMIUiTgdjuGvTL2L8EHGA=";
var B_K1 = "SRw9AGCJ7OV3y8AhPH6EPRp+ltAuxXMCBPcH4wNbBnE=";
var B_K2 = "7SsHdJWcBLp4N65EtxpWsWuom/JrF3LcCOjL7DJ22XE=";
var C_K1 = "NyshKkK44YOJF92OI5udcHR9FXmaGglkL1JrPQF8Bjk=";

var accContract = web3.eth.contract(abi);
var acc = accContract.new(1, {from:web3.eth.accounts[0], data: bytecode, gas: 0x47b760, privateFor: [A_K1, B_K1]}, function(e, contract) {
    if (e) {
        console.log("err creating contract", e);
    } else {
        if (!contract.address) {
            console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");
        } else {
            console.log("Contract mined! Address: " + contract.address);
            console.log(contract);
        }
    }
});
