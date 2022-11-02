/*
  Try `truffle exec scripts/increment.js`, you should `truffle migrate` first.

  Learn more about Truffle external scripts:
  https://trufflesuite.com/docs/truffle/getting-started/writing-external-scripts
*/

const LTSTicket = artifacts.require("LTSTicket");

module.exports = async function (callback) {
  const deployed = await LTSTicket.deployed();
  callback();
};
