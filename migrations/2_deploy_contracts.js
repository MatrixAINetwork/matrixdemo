var DemoCoin = artifacts.require("./DemoCoin.sol");
var manUtils = artifacts.require("./manUtils.sol");
module.exports = async function(deployer) {
  await deployer.deploy(manUtils);
  await deployer.link(manUtils,DemoCoin);
  await deployer.deploy(DemoCoin);
};
