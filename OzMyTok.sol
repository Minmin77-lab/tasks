// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OzMyTok is ERC20, Ownable {
    constructor() ERC20("MyToken", "MTK") Ownable(msg.sender) {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
        uint256 totalSupply = totalSupply();
        uint256 burnAmount = totalSupply * 5 / 1000; 
        _burn(msg.sender, burnAmount);
    }
}
