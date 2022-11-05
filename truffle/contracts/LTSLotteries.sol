// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./LTSLottery.sol";

interface ILTSLottery {
    function finalizeLottery() external;

    function setChainLinkID(uint256 _index) external;

    function setUpWinner() external;

    function verifyFinalizeLottery()
        external
        view
        returns (bool, uint256[] memory);
}

interface ILTSConsumer {
    function requestRandomWords() external returns (uint256 requestId);

    function getRequestStatus(uint256 _requestId)
        external
        view
        returns (bool fulfilled, uint256[] memory randomWords);
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
            new LTSLottery(
                chainLinkConsumer,
                _name,
                _ticketPrice,
                _minTicket,
                msg.sender
            )
        );
        lotteries.push(_newLotteryAddress);
    }

    function finalizeLottery(uint64 _index) public onlyOwner {
        ILTSLottery lottery = ILTSLottery(lotteries[_index]);
        lottery.finalizeLottery();
        uint256 _chainLinkIndex = ILTSConsumer(chainLinkConsumer)
            .requestRandomWords();
        lottery.setChainLinkID(_chainLinkIndex);
    }

    function setUpWinner(uint64 _index) public onlyOwner {
        ILTSLottery lottery = ILTSLottery(lotteries[_index]);
        lottery.setUpWinner();
    }

    function verifyFinalizeLottery(uint64 _index)
        public
        view
        returns (bool, uint256[] memory)
    {
        ILTSLottery lottery = ILTSLottery(lotteries[_index]);
        return lottery.verifyFinalizeLottery();
    }

    function returnLotteries() public view returns (address[] memory) {
        return lotteries;
    }
}
