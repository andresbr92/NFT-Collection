// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    //
    string _baseTokenURI;

    uint256 public _price = 0.01 ether;
    bool public _paused;
    uint256 public maxTokensIds = 20;
    uint256 public tokenIds;

    // whitelist contract instance
    IWhitelist whitelist;

    bool public presaleStarted;
    uint256 public presaleEnded;
    modifier onlyWhenNotPaused {
        require(!_paused, "Contract is paused");
            _;
    }

    constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD") {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }

    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale is not started or ended");
        require (whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        require(tokenIds < maxTokensIds, "Exceed maximum Cripto Devs sypply");
        require(msg.value >= _price, "Ether send is not correct");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }


}