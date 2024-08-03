// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    
    uint256 constant REDEMPTION_RATE = 100;

    mapping(address => uint256) gamePadOwned;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        mintTokens(msg.sender, 10 * (10 ** uint256(decimals())));
    }

    function mintTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to burn");
        _burn(msg.sender, amount);
    }

    function transferTokens(address to, uint256 amount) public {
        require(to != address(0), "Invalid address");
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to transfer");
        _transfer(msg.sender, to, amount);
    }

    function redeemGamePad(uint256 quantity) public {
        uint256 cost = REDEMPTION_RATE * quantity;
        require(balanceOf(msg.sender) >= cost, "Not enough tokens");

        gamePadOwned[msg.sender] += quantity;
        _burn(msg.sender, cost);
    }

    function checkGamePadOwned(address user) public view returns (uint256) {
        return gamePadOwned[user];
    }

    function checkTokenBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }
}
