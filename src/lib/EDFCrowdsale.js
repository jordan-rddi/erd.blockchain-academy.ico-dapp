const MetaMask = require('@/lib/MetaMask');

class edfCrowdsale {
  constructor() {
    const edfCrowdsaleData = require('@/fudge/build/contracts/EDFCrowdsale.json');

    this.abi = edfCrowdsaleData.abi;
    this.address = edfCrowdsaleData.deployment.address;
    this.web3 = MetaMask.web3;

    this.contract = new this.web3.eth.Contract(this.abi, this.address);
  }

  getCrowdsaleInformation() {
    const promises = [];

    promises.push(this.getTokenPrice()); // 0
    promises.push(this.getTokensSold()); // 1
    promises.push(this.getToken()); // 2

    return new Promise((resolve, reject) => {
      Promise.all(promises)
        .then((results) => {
          resolve({
            tokenPrice: results[0],
            tokensSold: results[1],
            token: results[2],
          });
        })
        .catch((error) => {
          reject(error);
        });
    });
  }

  getTokensSold() {
    return this.contract.methods.tokensSold().call();
  }

  getTokenPrice() {
    return this.contract.methods.tokenPrice().call();
  }

  getToken() {
    return this.contract.methods.token().call();
  }

  buyTokens(value) {
    let accounts = [];

    return new Promise((resolve, reject) => {
      MetaMask.getAccounts()
        .then(_accounts => {
          accounts = _accounts;

          return this.contract.methods.buyTokens().estimateGas({ from: accounts[0], value: value })
        })
        .then(gasEstimate => {
          console.log(`Gas estimation: ${gasEstimate}`);
          
          return this.contract.methods.buyTokens().send({ from: accounts[0], gas: gasEstimate, value: value });
        })
        .then(receipt => {
          console.log(receipt);

          resolve(receipt);
        })
        .catch(error => {
          reject(error);
        })  
    });
  }
}

const EDFCrowdsale = new edfCrowdsale();
module.exports = EDFCrowdsale;