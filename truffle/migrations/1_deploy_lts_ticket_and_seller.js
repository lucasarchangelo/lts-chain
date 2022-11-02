const LTSTicket = artifacts.require("LTSTicket");
var LTSTicketSeller = artifacts.require("LTSTicketSeller");

module.exports = async function (deployer) {
  deployer.deploy(LTSTicket);
  const _instance = await LTSTicket.deployed();
  await deployer.deploy(LTSTicketSeller, _instance.address);
};
