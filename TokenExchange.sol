// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract TokenExchange {
    IERC20 public tokenA; 
    IERC20 public tokenB; 

    constructor(IERC20 _tokenA, IERC20 _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function exchangeAtoB(uint256 amountA) external {
        require(amountA > 0, "Amount must be greater than 0");
        require(tokenA.balanceOf(msg.sender) >= amountA, "Insufficient balance of token A");

        tokenA.transferFrom(msg.sender, address(this), amountA);

        tokenB.transfer(msg.sender, amountA);
    }

        function exchangeBtoA(uint256 amountB) external {
        require(amountB > 0, "Amount must be greater than 0");
        require(tokenB.balanceOf(msg.sender) >= amountB, "Insufficient balance of token B");

        tokenB.transferFrom(msg.sender, address(this), amountB);
        
        tokenA.transfer(msg.sender, amountB);
    }

        function buyTokenA(uint256 _amount) public payable {
        require(msg.value > 0, "Ether value must be greater than 0");

        uint256 amountA = _amount * 1 ether; 

        require(msg.value >= amountA, "Insufficient Ether sent");

        tokenA.transfer(msg.sender, amountA);

        if (msg.value > amountA) {
            payable(msg.sender).transfer(msg.value - amountA);
        }
    }

        function buyTokenB(uint256 _amount) public payable {
        require(msg.value > 0, "Ether value must be greater than 0");

        uint256 amountB =_amount * 1 ether; 

        require(msg.value >= amountB, "Insufficient Ether sent");

        tokenB.transfer(msg.sender, amountB);

        if (msg.value > amountB) {
            payable(msg.sender).transfer(msg.value - amountB);
        }
    }


    function withdrawEther() external {
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawTokens(IERC20 token, uint256 amount) external {
        token.transfer(msg.sender, amount);
    }
    function balanceOfTokenA() external view returns (uint256) {
        return tokenA.balanceOf(msg.sender);
    }

    function balanceOfTokenB() external view returns (uint256) {
        return tokenB.balanceOf(msg.sender);
    }
}
