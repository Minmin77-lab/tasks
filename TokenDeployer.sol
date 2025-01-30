// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol"; 

contract TokenDeployer {
    MyToken public token;

    constructor() {
        token = new MyToken(1000000); 
    }

    function getTokenAddress() public view returns (address) {
        return address(token);
    }
}
