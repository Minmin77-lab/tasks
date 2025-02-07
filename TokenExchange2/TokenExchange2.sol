// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract TokenExchange {
    IERC20 public tokenA; 
    IERC20 public tokenB; 

    event TokensPurchased(address indexed buyer, address indexed token, uint256 amount, uint256 value);
    event TokensExchanged(address indexed user, uint256 amountA, uint256 amountB);
    event EtherWithdrawn(address indexed user, uint256 amount);
    event TokensWithdrawn(address indexed user, address indexed token, uint256 amount);

    constructor(IERC20 _tokenA, IERC20 _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function buyTokens(IERC20 token, uint256 _amount) public payable {
        require(msg.value > 0, "Ether value must be greater than 0");

        uint256 amount = _amount * 1 ether; 

        require(msg.value >= amount, "Insufficient Ether sent");

        token.transfer(msg.sender, amount);

        if (msg.value > amount) {
            payable(msg.sender).transfer(msg.value - amount);
        }

        emit TokensPurchased(msg.sender, address(token), amount, msg.value);
    }

    function exchangeAtoB(uint256 amountA) external {
        require(amountA > 0, "Amount must be greater than 0");
        require(tokenA.balanceOf(msg.sender) >= amountA, "Insufficient balance of token A");

        tokenA.transferFrom(msg.sender, address(this), amountA);

        tokenB.transfer(msg.sender, amountA);

        emit TokensExchanged(msg.sender, amountA, amountA);
    }

    function exchangeBtoA(uint256 amountB) external {
        require(amountB > 0, "Amount must be greater than 0");
        require(tokenB.balanceOf(msg.sender) >= amountB, "Insufficient balance of token B");

        tokenB.transferFrom(msg.sender, address(this), amountB);
        
        tokenA.transfer(msg.sender, amountB);

        emit TokensExchanged(msg.sender, amountB, amountB);
    }

    function withdrawEther() external {
        uint256 balance = address(this).balance;
        require(balance > 0, "No Ether to withdraw");
        payable(msg.sender).transfer(balance);
        emit EtherWithdrawn(msg.sender, balance);
    }

    function withdrawTokens(IERC20 token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(token.balanceOf(address(this)) >= amount, "Insufficient token balance in contract");
        token.transfer(msg.sender, amount);
        emit TokensWithdrawn(msg.sender, address(token), amount);
    }

    function balanceOfTokenA() external view returns (uint256) {
        return tokenA.balanceOf(msg.sender);
    }

    function balanceOfTokenB() external view returns (uint256) {
        return tokenB.balanceOf(msg.sender);
    }
}
