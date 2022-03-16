# erd.blockchain-academy.ico-dapp

This project provides will be used to demonstrate the creation of a crowdsale application. It is written in Vue (https://vuejs.org/), uses web3 (https://www.npmjs.com/package/web3) and MetaMask (https://metamask.io/) as a means to communicate with a blockchain node and integrates fudge (https://www.npmjs.com/package/fudge-cli) as a simple contract compiler and deployer.

This project has a few assumptions, that if changed will require some modifications to the configuration.
- It expects an RPC client available at http://localhost:8545
- It expects that you are using the configuration of https://github.com/jordan-rddi/erd.blockchain-academy.openethereum-node
- It uses the account `0xa66001530562410Ad370E1C48a04512B9F436512` which is predefined with Ether in https://github.com/jordan-rddi/erd.blockchain-academy.openethereum-node
- It expects that MetaMask is configured in your browser

### Install dependencies
```
npm install
```

### Compile the contract
```
npm run compile
```

### Deploy the contract
```
npm run deploy
```

### Launch the application
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```
