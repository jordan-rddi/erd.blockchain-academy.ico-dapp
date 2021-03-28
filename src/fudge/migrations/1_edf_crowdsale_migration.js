
const EDFCrowdsale = require('../build/contracts/EDFCrowdsale.json');

module.exports = deployer => {
  return deployer.deploy(EDFCrowdsale, ["1000000", "20000000000000000"]);
}
