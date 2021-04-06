<template>
  <div class="home">
    <h1>The EDF token sale has started!</h1>
    <p>Contribute today to receive your tokens. These tokens will give you a say in the future of EDF.</p>
    <progress id="tokensSoldProgress" max="100" v-bind:value="getPercentageSold()"> {{ getPercentageSold() }}%</progress>
    <p>So far {{ crowdsaleInformation.tokensSold }} have been sold! There are still {{ tokensAvailable }} tokens left to purchase!</p>
    <p>Each token costs {{ convertWeiToEther(crowdsaleInformation.tokenPrice) }} Ether.</p>

    <h2>Token</h2>
    <p>Name: {{ tokenInformation.name }}</p>
    <p>Symbol: {{ tokenInformation.symbol }}</p>

    <h2>Buy tokens</h2>
    <form @submit.prevent="buyTokens">
      Tokens to purchase
      <input v-model="tokensToPurchase" />
      <button type="submit">Buy</button>
      <p>This purchase will cost {{ getWeiTokenCost(tokensToPurchase) }} wei ({{ getEtherTokenCost(tokensToPurchase) }} Ether)</p>
    </form>

    <h2>Sales</h2>
    <table>
      <tr>
        <th>
          Buyer
        </th>
        <th>
          Quantity
        </th>
      </tr>
      <tr v-for="(sale, index) in tokenSales" v-bind:key="index">
        <td>{{ sale.to }}</td>
        <td>{{ sale.value }}</td>
      </tr>
    </table>
  </div>
</template>

<script>
const web3 = require('web3');
const EDFCrowdsale = require('@/lib/EDFCrowdsale');
const IERC20 = require('@/lib/IERC20');

export default {
  name: 'Home',
  components: {},
  data() {
    return {
      crowdsaleInformation: {
        tokenPrice: 0,
        tokensSold: 0,
        token: "",
      },
      tokenContract: null,
      tokensAvailable: 0,
      tokenInformation: {
        name: "",
        symbol: "",
      },
      tokensToPurchase: 0,
      tokenSales: []
    }
  },
  created() {
    /**
     * Get the crowdsale details
     */
    this.updateCrowdsaleInformation();
  },
  methods: {
    updateCrowdsaleInformation() {
      EDFCrowdsale.getCrowdsaleInformation()
      .then((_crowdsaleInformation) => {
        console.log(_crowdsaleInformation);

        this.crowdsaleInformation = _crowdsaleInformation;

        this.tokenContract = new IERC20(this.crowdsaleInformation.token);

        return this.tokenContract.getTokenInformation();
      })
      .then((_tokenInformation) => {
        console.log(_tokenInformation);

        this.tokenInformation = _tokenInformation;

        return this.tokenContract.getBalanceOf(EDFCrowdsale.address);
      })
      .then((_crowdsaleBalance) => {
        console.log(_crowdsaleBalance);

        this.tokensAvailable = _crowdsaleBalance;

        return this.tokenContract.getPastTransferEvents({ fromBlock: 0, filter: { from: EDFCrowdsale.address }});
      })
      .then((events) => {
        this.tokenSales = events.map(event => {
          return {
            from: event.returnValues.from,
            to: event.returnValues.to,
            value: event.returnValues.value,
          };
        })
      })
      .catch(error => {
        console.log(error);
      });
    },
    getPercentageSold() {
      const totalAvailableTokens = Number(this.tokensAvailable) + Number(this.crowdsaleInformation.tokensSold);

      return (Number(this.crowdsaleInformation.tokensSold) / totalAvailableTokens) * 100 || 0;
    },
    getWeiTokenCost(tokens) {
      const tokensBN = web3.utils.toBN(tokens);
      const tokenPriceBN = web3.utils.toBN(this.crowdsaleInformation.tokenPrice);

      return tokensBN.mul(tokenPriceBN).toString();
    },
    getEtherTokenCost(tokens) {
      return this.convertWeiToEther(this.getWeiTokenCost(tokens));
    },
    convertWeiToEther(wei) {
      const weiBN = web3.utils.toBN(wei);
      return web3.utils.fromWei(weiBN);

    },
    buyTokens(event) {
      EDFCrowdsale.buyTokens(this.getWeiTokenCost(this.tokensToPurchase))
        .then((receipt) => {
          console.log(receipt);

          this.tokensToPurchase = 0;
          this.updateCrowdsaleInformation();
        })
        .catch(error => {
          console.log(error);
        })
    },
  }
}
</script>

<style>
#tokensSoldProgress {
  width: 100%;
  height: 40px;
}
</style>
