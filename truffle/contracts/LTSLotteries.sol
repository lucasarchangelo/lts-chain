// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./LTSLottery.sol";

interface ILTSLottery {
    function finalizeLottery() external;

    function setUpWinner() external;

    function verifyFinalizeLottery()
        external
        view
        returns (bool, uint256[] memory);
}

contract LTSLotteries is Ownable {
    address[] lotteries;
    uint64 lotteriesCount;
    address private chainLinkConsumer;

    constructor(address _chainLinkConsumer) {
        chainLinkConsumer = _chainLinkConsumer;
    }

    function newLottery(
        string memory _name,
        uint256 _ticketPrice,
        uint32 _minTicket
    ) public onlyOwner {
        address _newLotteryAddress = address(
            new LTSLottery(chainLinkConsumer, _name, _ticketPrice, _minTicket)
        );
        lotteries.push(_newLotteryAddress);
    }

    function finalizeLottery(uint64 _index) public onlyOwner {
        ILTSLottery lottery = ILTSLottery(lotteries[_index]);
        lottery.finalizeLottery();
    }

    function setUpWinner(uint64 _index) public onlyOwner {
        ILTSLottery lottery = ILTSLottery(lotteries[_index]);
        lottery.setUpWinner();
    }

    function verifyFinalizeLottery(uint64 _index) public view returns (bool, uint256[] memory) {
        ILTSLottery lottery = ILTSLottery(lotteries[_index]);
        return lottery.verifyFinalizeLottery();
    }

    function returnLotteries() public view returns (address[] memory) {
        return lotteries;
    }
}
