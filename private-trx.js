const Web3 = require("web3");
const HttpHeaderProvider = require('httpheaderprovider');
const Web3Quorum = require("web3js-quorum");

const usage = async () => {
    console.error(`Invalid arguments!
        usage:
            ${process.argv[0]} ${process.argv[1]} bearerToken
    `);
    process.exit(-1);
}

if(process.argv.length < 3) {
    usage();
}
const TOKEN = process.argv[2];

// obtain the preauthenticated bearer token
// by authenticating with the authorization server
const headers = { "Authorization": `Bearer ${TOKEN}` };
const provider = new HttpHeaderProvider('https://localhost:20000?PSI=PSA', headers);

// Ignore TLS errors from self-signed certificates
process.env["NODE_TLS_REJECT_UNAUTHORIZED"] = 0;

// https://consensys.net/docs/goquorum/en/22.4.0/configure-and-manage/manage/json-rpc-api-security/
const web3 = new Web3Quorum(new Web3(provider));


// Node1 is a node managed account
const node1 = {
    privateKey: '0xc5148ef48a47a72575b234e25486edc2f4f3f184ef7c879a31a4b300ff52d3e7',
    address: '0x339a6e3a8d47882c5be9b0e901360649600d1868',
    name: 'node1'
}
// Wallet1 is a self managed account (eg: generated by metamask)
const wallet1 = {
    privateKey: '87f8c55e037ddb6dbbe454c7500f7c3d4232892aa19405a47bc75786f0882ff9',
    address: '0x50B09EC167697863f5f8FBc124022D8C893b73C5',
    name: 'wallet1'
}
const wallet2 = {
    privateKey: 'ebcb6cddfbb2c5b6293de38a92a7dbe974888ce0061863d4e4784d6bdc3561c7',
    address: '0x1fE7E194edB898864FF7B6b09b91a93076FaAF4B',
    name: 'wallet2'
}

const main = async () => {
    const acc1 = await web3.eth.accounts.privateKeyToAccount(wallet2.privateKey);
    const bal1 = web3.utils.fromWei(await web3.eth.getBalance(acc1.address),'ether');

    // await web3.eth.accounts.wallet.add("87f8c55e037ddb6dbbe454c7500f7c3d4232892aa19405a47bc75786f0882ff9")
    // const wallet = web3.eth.accounts.wallet;
    console.log(`accounts`, acc1);
    const receipt = await acc1.signTransaction({
        to: node1.address,
        value: web3.utils.toWei('1', 'ether'),
        privateFor: 'mbW7Y2t3Hblq/xxo4ZnC8tfMIUiTgdjuGvTL2L8EHGA=',
        gas: 21000
    });
    console.log(`receipt`, receipt)
    // await web3.eth.distributePrivateTransaction(receipt.rawTransaction, {
    //     privateFrom: wallet1.address,
    //     privateFor: []
    // })
    //Send tx and wait for receipt
    const createReceipt = await web3.eth.sendSignedTransaction(receipt.rawTransaction);
    console.log(`Transaction successful with hash: ${createReceipt.transactionHash}`);

    const bal2 = web3.utils.fromWei(await web3.eth.getBalance(acc1.address),'ether');
    console.log(`before=${bal1} after=${bal2}`);
}


main();