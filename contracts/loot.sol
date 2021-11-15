//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Loot is ERC20 {
    constructor() public ERC20('Thieves Guild Loot', 'LOOT') { }
    //mint require sender owns a card
    //fee set by vote from card holders
}