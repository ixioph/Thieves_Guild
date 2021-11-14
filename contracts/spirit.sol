//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@chainlink/contracts/src/v0.6/VRFConsumerBase.sol';

// suits: Wands (Clubs), Cups (Hearts), Swords (Spades), Pentacles (Diamonds)
// values: 2-10 incrementing, Paige, Knight, Queen, King, A
contract Spirit is ERC721, VRFConsumerBase {
    using Counters for Counters.Counter;
    Counters.Counter private tokenId;
    enum Suit {Wands, Cups, Swords, Pentacles}
    string Title;
    //string[] ranks; // suit::value format (10 of Pentacles == 'P::10')
    struct Avatar { // values editable by the token owner
        uint8 face;
        uint8 hair;
        uint8 wear;
    }

    mapping (bytes32 => address) public requestIdToSender;
    mapping (bytes32 => string) public requestIdToTokenURI;
    mapping (uint256 => Suit) public tokenIdToSuit;
    mapping (bytes32 => uint256) public requestIdToTokenId;

    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;


    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyHash) public 
    VRFConsumerBase(_VRFCoordinator, _LinkToken) ERC721('TGC', 'Thieves Guild Card') { 
        keyHash = _keyHash;
        fee = 0.1 * 10**18;
    }

    function createCollectible(string memory tokenURI, uint256 seed) public returns (bytes32) {
        bytes32 requestId = requestRandomness(keyHash, fee, seed);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
    }

    function fulfillRandomness(bytes32 requestId, uint256 num) internal override {
        address cardHolder = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI[requestId];
        //uint256 newItemId = tokenId;
        _safeMint(cardHolder, newItemId);
        _setTokenURI(newItemId, tokenURI);
        Suit suit = Suit(num % 4);
        tokenIdToSuit[newItemId] = suit;
        requestIdToTokenId[requestId] = newItemId;
    }

}