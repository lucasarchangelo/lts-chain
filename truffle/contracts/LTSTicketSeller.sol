// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC721LTSTicket {
    function safeMint(address to, string memory uri) external;
}

contract LTSTicketSeller is Ownable {
    mapping(address => bool) buyers;
    uint256 nftPurchased;
    uint256 maxNft;
    IERC721LTSTicket public token;

    uint256 public nftCommonPrice;
    uint256 public nftUncommonPrice;
    uint256 public nftRarePrice;
    uint256 public nftEpicPrice;

    string uriCommon;
    string uriUncommon;
    string uriRare;
    string uriEpic;

    constructor(address _token) {
        token = IERC721LTSTicket(_token);
        uriCommon = "common.mp4";
        uriUncommon = "uncommon.mp4";
        uriRare = "rare.mp4";
        uriEpic = "epic.mp4";

        maxNft = 1000;
        nftCommonPrice =   4000000000000000;
        nftUncommonPrice = 9000000000000000;
        nftRarePrice =     12000000000000000;
        nftEpicPrice =     50000000000000000;
    }

    function purchasecommon() public payable {
        require(
            msg.value == nftCommonPrice,
            "You need to specify the right price."
        );
        mintAndTransfer(msg.sender, msg.value, uriCommon);
    }

    function purchaseUncommon() public payable {
        require(
            msg.value == nftUncommonPrice,
            "You need to specify the right price."
        );
        mintAndTransfer(msg.sender, msg.value, uriUncommon);
    }

    function purchaseRare() public payable {
        require(
            msg.value == nftRarePrice,
            "You need to specify the right price."
        );
        mintAndTransfer(msg.sender, msg.value, uriRare);
    }

    function purchaseEpic() public payable {
        require(
            msg.value == nftEpicPrice,
            "You need to specify the right price."
        );
        mintAndTransfer(msg.sender, msg.value, uriEpic);
    }

    function mintAndTransfer(
        address _buyer,
        uint256 _value,
        string memory _uri
    ) private {
        require(maxNft > nftPurchased, "Sold out.");
        buyers[_buyer] = true;
        nftPurchased++;
        payable(owner()).transfer(_value);
        token.safeMint(_buyer, _uri);
    }

    function setcommonPrice(uint256 _price) public onlyOwner {
        nftCommonPrice = _price;
    }

    function setUncommonPrice(uint256 _price) public onlyOwner {
        nftUncommonPrice = _price;
    }

    function setRarePrice(uint256 _price) public onlyOwner {
        nftRarePrice = _price;
    }

    function setEpicPrice(uint256 _price) public onlyOwner {
        nftEpicPrice = _price;
    }

    function getAllPrices() public view returns (uint256, uint256, uint256, uint256) {
        return (nftCommonPrice, nftUncommonPrice, nftRarePrice, nftEpicPrice);
    }

    function setAllPrices(
        uint256 _price1,
        uint256 _price2,
        uint256 _price3,
        uint256 _price4
    ) public onlyOwner {
        nftCommonPrice = _price1;
        nftUncommonPrice = _price2;
        nftRarePrice = _price3;
        nftEpicPrice = _price4;
    }

    function setMaxNFT(uint256 _value) public onlyOwner {
        maxNft = _value;
    }

    function withdraw(uint256 _amount) public onlyOwner {
        require(address(this).balance > _amount, "Insuficient founds.");
        payable(owner()).transfer(_amount);
    }

    function withdrawAll() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
