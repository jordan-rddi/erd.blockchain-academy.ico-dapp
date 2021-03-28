<template>
  <div class="account">
    <h1>Your account</h1>
    <p>{{ ethereumAddress}}</p>
    <h1>EDF Crowdsale Balance</h1>
    <p>{{ crowdsaleBalance }}</p>
  </div>
</template>

<script>
const MetaMask = require('@/lib/MetaMask');
const EDFCrowdsale = require('@/lib/EDFCrowdsale');
const IERC20 = require('@/lib/IERC20');

export default {
  name: 'App',
  components: {},
  data() {
    return {
      ethereumAddress: null,
      crowdsaleBalance: 0,
      token: null,
    }
  },
  created() {
    this.updateAccountStatus();
  },
  methods: {
    updateAccountStatus() {
      MetaMask.getAccounts()
        .then((accounts) => {
          this.ethereumAddress = accounts[0];

          return EDFCrowdsale.getToken();
        })
        .then((_token) => {

          this.tokenContract = new IERC20(_token);

          return this.tokenContract.getBalanceOf(this.ethereumAddress);
        })
        .then((_crowdsaleBalance) => {
          console.log(_crowdsaleBalance);

          this.crowdsaleBalance = _crowdsaleBalance;
        })
        .catch(error => {
          console.log(error);
        });
    },
  }
}
</script>