// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

interface VRFv2ConsumerChainLink {
    function requestRandomWords() external returns (uint256 requestId);

    function getRequestStatus(uint256 _requestId)
        external
        view
        returns (bool fulfilled, uint256[] memory randomWords);
}

contract LTSLottery is Ownable {
    VRFv2ConsumerChainLink private chainLinkConsumer;

    struct User {
        bool hasTicket;
        bool claimed;
    }
    struct LotteryStruct {
        string name;
        uint256 ticketPrice;
        uint32 minTicket;
        mapping(address => User) ticketOwners;
        mapping(uint256 => address) tickets;
        uint256 ticketsCount;
        uint256 balance;
        bool finalized;
        uint256 indexChainLink;
        address winner;
        bool claimed;
    }

    LotteryStruct lottery;

    constructor(
        address _consumer,
        string memory _name,
        uint256 _ticketPrice,
        uint32 _minTicket
    ) {
        chainLinkConsumer = VRFv2ConsumerChainLink(_consumer);

        lottery.name = _name;
        lottery.ticketPrice = _ticketPrice;
        lottery.minTicket = _minTicket;

        lottery.balance = 0;
        lottery.finalized = false;
        lottery.winner = 0x0000000000000000000000000000000000000000;
    }

    function buyTicket() public payable {
        require(
            !lottery.finalized,
            "This lottery has already finalized, wait for results!"
        );
        require(
            lottery.ticketPrice == msg.value,
            "You need to pay the exactly ticket price."
        );
        require(
            !lottery.ticketOwners[msg.sender].hasTicket,
            "This address already buy a ticket."
        );

        // Input the sender to Ticket Owners
        lottery.ticketOwners[msg.sender].hasTicket = true;
        lottery.ticketOwners[msg.sender].claimed = false;

        // Input sender to ticket numbers
        lottery.tickets[lottery.ticketsCount++] = msg.sender;

        // Input de balance plus msg.value
        lottery.balance += msg.value;
    }

    function finalizeLottery() public onlyOwner {
        require(!lottery.finalized, "Lottery already finalized.");
        require(
            lottery.ticketsCount >= lottery.minTicket,
            "The Lottery didnt get the minimum required yet."
        );
        lottery.finalized = true;
        requestRandomWord();
    }

    function setUpWinner() public onlyOwner {
        bool fulfilled;
        uint256[] memory randomWords;

        require(lottery.finalized);
        (fulfilled, randomWords) = chainLinkConsumer.getRequestStatus(
            lottery.indexChainLink
        );
        require(fulfilled);
        lottery.winner = lottery.tickets[randomWords[0] % lottery.ticketsCount];
    }

    function claim() public {
        require(!lottery.claimed, "The winner already claimed his prize.");
        require(lottery.finalized, "This lottery isn't finalized yet.");
        require(
            lottery.winner != 0x0000000000000000000000000000000000000000,
            "This lottery didnt get a winner yet."
        );
        require(
            lottery.ticketOwners[msg.sender].hasTicket,
            "You dont have any ticket to claim here."
        );
        require(
            !lottery.ticketOwners[msg.sender].claimed,
            "You have alread claimed your prize."
        );
        lottery.ticketOwners[msg.sender].claimed = true;
        lottery.ticketOwners[msg.sender].hasTicket = false;
        require(lottery.winner == msg.sender, "You're not the winner, sorry");
        lottery.claimed = true;
        uint256 _prize = (lottery.balance / 10) * 7;
        uint256 _onwerValue = lottery.balance - ((lottery.balance / 10) * 7);
        payable(msg.sender).transfer(_prize);
        payable(owner()).transfer(_onwerValue);
    }

    function verifyFinalizeLottery()
        public
        view
        returns (bool, uint256[] memory)
    {
        bool fulfilled;
        uint256[] memory randomWords;
        (fulfilled, randomWords) = chainLinkConsumer.getRequestStatus(
            lottery.indexChainLink
        );

        return (fulfilled, randomWords);
    }

    function requestRandomWord() private {
        lottery.indexChainLink = chainLinkConsumer.requestRandomWords();
    }

    function getLotteryProperties()
        public
        view
        returns (
            string memory,
            uint256,
            uint32,
            uint256,
            bool,
            address,
            bool
        )
    {
        return (
            lottery.name,
            lottery.ticketPrice,
            lottery.minTicket,
            lottery.balance,
            lottery.finalized,
            lottery.winner,
            lottery.claimed
        );
    }
}
