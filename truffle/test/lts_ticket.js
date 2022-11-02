const LTSTicket = artifacts.require("LTSTicket");

contract('LTSTicket', () => {
  it('Initialize LTSTicket', async() => {
    const lts_ticket_instance = await LTSTicket.deployed();
    // assert.equal(lts_ticket_instance);
  });
});
