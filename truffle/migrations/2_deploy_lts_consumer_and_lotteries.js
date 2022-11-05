const LTSConsumer = artifacts.require("LTSConsumer");
const LTSLotteries = artifacts.require("LTSLotteries");

const REQUEST_RANDOM = "0xbeae89bf8d1683e68a5a858eedebc5d526df1f91a37b9514d88631e7892f4fa2";
const SUBSCRIPTION_ID = "4901";

module.exports = async function (deployer) {
  // Deploy Consumer ChainLink contract.
  await deployer.deploy(LTSConsumer, SUBSCRIPTION_ID);
  // Gets Instance of Consumer.
  const _consumerInstance = await LTSConsumer.deployed();
  // Deploy lotteries contract passing by Consumer address
  await deployer.deploy(LTSLotteries, _consumerInstance.address);
  // Get Instance of lotteries
  const _lotteriesInstance = await LTSLotteries.deployed();
  // Grant role for lotteries on Consumer Chainlink contract
  await _consumerInstance.grantRole(REQUEST_RANDOM, _lotteriesInstance.address);
};
