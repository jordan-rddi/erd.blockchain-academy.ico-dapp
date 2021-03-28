const MetaMask = require('@/lib/MetaMask');

class IERC20 {
  constructor(address) {
    const ierc20Data = require('@/fudge/build/contracts/IERC20.json');

    this.abi = ierc20Data.abi;
    this.address = address;
    this.web3 = MetaMask.web3;

    this.contract = new this.web3.eth.Contract(this.abi, this.address);
  }

  getTokenInformation() {
    const promises = [];

    promises.push(this.getName()); // 0
    promises.push(this.getSymbol()); // 1

    return new Promise((resolve, reject) => {
      Promise.all(promises)
        .then((results) => {
          resolve({
            name: results[0],
            symbol: results[1],
          });
        })
        .catch((error) => {
          reject(error);
        });
    });
  }

  getName() {
    return this.contract.methods.name().call();
  }

  getSymbol() {
    return this.contract.methods.symbol().call();
  }

  getBalanceOf(address) {
    return this.contract.methods.balanceOf(address).call();
  }
  
  // setStoredData(data) {
  //   let accounts = [];

  //   return new Promise((resolve, reject) => {
  //     MetaMask.getAccounts()
  //       .then(_accounts => {
  //         accounts = _accounts;

  //         return this.contract.methods.set(data).estimateGas({ from: accounts[0] })
  //       })
  //       .then(gasEstimate => {
  //         console.log(`Gas estimation: ${gasEstimate}`);
          
  //         return this.contract.methods.set(data).send({ from: accounts[0], gas: gasEstimate });
  //       })
  //       .then(receipt => {
  //         console.log(receipt);

  //         resolve(receipt);
  //       })
  //       .catch(error => {
  //         reject(error);
  //       })  
  //   });
  // }

  // getOwner() {
  //   return this.contract.methods.owner().call();
  // }

  // setOwner(address) {
  //   let accounts = [];

  //   return new Promise((resolve, reject) => {
  //     MetaMask.getAccounts()
  //       .then(_accounts => {
  //         accounts = _accounts;

  //         return this.contract.methods.changeOwner(address).estimateGas({ from: accounts[0] })
  //       })
  //       .then(gasEstimate => {
  //         console.log(`Gas estimation: ${gasEstimate}`);
          
  //         return this.contract.methods.changeOwner(address).send({ from: accounts[0], gas: gasEstimate });
  //       })
  //       .then(receipt => {
  //         console.log(receipt);

  //         resolve(receipt);
  //       })
  //       .catch(error => {
  //         reject(error);
  //       })  
  //   });
  // }
}

module.exports = IERC20;