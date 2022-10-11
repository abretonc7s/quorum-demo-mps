a = eth.accounts[0]
web3.eth.defaultAccount = a;

// abi and bytecode generated from simplestorage.sol:
// > solcjs --bin --abi simplestorage.sol
var abi = [{"constant":true,"inputs":[],"name":"storedData","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"set","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"initVal","type":"uint256"}],"payable":false,"type":"constructor"}];

var bytecode = "0x6060604052341561000f57600080fd5b604051602080610149833981016040528080519060200190919050505b806000819055505b505b610104806100456000396000f30060606040526000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680632a1afcd914605157806360fe47b11460775780636d4ce63c146097575b600080fd5b3415605b57600080fd5b606160bd565b6040518082815260200191505060405180910390f35b3415608157600080fd5b6095600480803590602001909190505060c3565b005b341560a157600080fd5b60a760ce565b6040518082815260200191505060405180910390f35b60005481565b806000819055505b50565b6000805490505b905600a165627a7a72305820d5851baab720bba574474de3d09dbeaabc674a15f4dd93b974908476542c23f00029";
// Lisiting tessera public keys
var tm1 = "xFKHPnnq5dzJr6ZygHFD7qOyE/tZHPPuMpymsT47DUY=";
var tm2 = "wsfcqtINO3linaBlh4Md19rMlwmXT7GDEuvnPjz9PiY=";
var tm3 = "pcq3MgvkKgQC305pr6pYM5kRhpRpv/xqHWLlORfm/lM=";
var tm4 = "nBQZKghVf+JlhaQ+JuY6BPO/uCmm2cknZNTmbzyv/hQ=";
var A_K1 = "mbW7Y2t3Hblq/xxo4ZnC8tfMIUiTgdjuGvTL2L8EHGA=";
var B_K1 = "SRw9AGCJ7OV3y8AhPH6EPRp+ltAuxXMCBPcH4wNbBnE=";
var B_K2 = "7SsHdJWcBLp4N65EtxpWsWuom/JrF3LcCOjL7DJ22XE=";
var C_K1 = "NyshKkK44YOJF92OI5udcHR9FXmaGglkL1JrPQF8Bjk=";

var simpleContract = web3.eth.contract(abi);
var simple = simpleContract.new(42, {from:web3.eth.accounts[0], data: bytecode, gas: 0x47b760, privateFor: [tm2]}, function(e, contract) {
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
