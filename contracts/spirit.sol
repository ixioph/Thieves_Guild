//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/ownership/Ownable.sol';
import '@chainlink/contracts/src/v0.6/VRFConsumerBase.sol';


contract Spirit is ERC721, Ownable, VRFConsumerBase {
    using Counters for Counters.Counter;
    Counters.Counter private tokenId;
    enum Suit {Wands, Cups, Swords, Pentacles, Major_Arcana}
    enum Value {Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Page, Knight, Queen, King,
                The_Fool, The_Magician, The_High_Priestess, The_Empress, The_Emperor, The_Heirophant, 
                The_Lovers, The_Chariot, Strength, The_Hermit, Wheel_of_Fortune,Justice, The_Hanged_man, 
                Death, Temperance, The_Devil, The_Tower, The_Star, The_Moon, The_Sun, Judgement, The_World}
    struct Avatar { // values editable by the token owner
        uint8 face;
        uint8 hair;
        uint8 wear;
    }

    mapping (bytes32 => address) public requestIdToSender;
    mapping (bytes32 => string) public requestIdToTokenURI;
    mapping (Counters.Counter => Suit) public tokenIdToSuit;
    mapping (bytes32 => uint256) public requestIdToTokenId;
    mapping (Counters.Counter => Value) public tokenIdToCardValue;
    mapping (address => string) public cardHolderToTitle;
    mapping (address => Avatar) public cardHolderToAvatar;

    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;


    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyHash) public 
    VRFConsumerBase(_VRFCoordinator, _LinkToken) ERC721('Thieves Guild Card', 'CARD') { 
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
        uint256 newItemId = tokenId.current();
        _safeMint(cardHolder, newItemId);
        _setTokenURI(newItemId, tokenURI);
        if (num % 333 != 33) {
            Suit suit = Suit(num % 4);
            Value value = Value(num % 14);
        }
        else {
            Suit suit = Suit(4);
            Value value = Value((num % 22) + 14);
        }
        
        tokenIdToSuit[newItemId] = suit;
        tokenIdToCardValue[newItemId] = value;
        requestIdToTokenId[requestId] = newItemId;
        tokenId.increment();
    }

    function setTitle(string memory _title, address _target) public onlyOwner{
        cardHolderToTitle[_target] = _title;
    }

    function setAvatar(uint8 _face, uint8 _hair, uint8 _wear) public {
        // require that sender holds a token
        Avatar avatar = Avatar(_face, _hair, _wear);
        cardHolderToAvatar[msg.sender] = avatar;
    }

    function invitePerson(address _target) public {
        // clone token and send to recipient
        // how do we time lock access?
    }

    function setRank(Rank rank, address _target) public onlyOwner {
        //
    }

}