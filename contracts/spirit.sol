pragma solidity >=0.7.0 <0.9.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

// suits: Wands (Clubs), Cups (Hearts), Swords (Spades), Pentacles (Diamonds)
// values: 2-10 incrementing, Paige, Knight, Queen, King, A
contract Spirit is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private tokenId;
    enum Suit {Wands, Cups, Swords, Pentacles}
    string Title;
    //string[] ranks; // suit::value format (10 of Pentacles == 'P::10')
    struct Avatar { // values editable by the token owner
        uint8 face = 0;
        uint8 hair = 0;
    }

    constructor() public ERC721 { }

}