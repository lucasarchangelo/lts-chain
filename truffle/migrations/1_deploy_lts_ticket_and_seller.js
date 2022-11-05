const LTSTicket = artifacts.require("LTSTicket");
var LTSTicketSeller = artifacts.require("LTSTicketSeller");
const MINT_ROLE = "0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6"

module.exports = async function (deployer) {
  await deployer.deploy(LTSTicket);
  const _instanceNFT = await LTSTicket.deployed();
  await deployer.deploy(LTSTicketSeller, _instanceNFT.address);
  const _instanceSeller = await LTSTicketSeller.deployed();
  await _instanceNFT.grantRole(MINT_ROLE, _instanceSeller.address);
};
