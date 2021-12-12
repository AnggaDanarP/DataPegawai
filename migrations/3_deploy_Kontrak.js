var Kontrak = artifacts.require("./Kontrak.sol");

module.exports = function(deployer) {
  deployer.deploy(Kontrak);
};