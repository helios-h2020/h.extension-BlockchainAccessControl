var HeliosAccessControl = artifacts.require("HeliosAccessControl");

module.exports = function(deployer) {
  deployer.deploy(HeliosAccessControl);
};
