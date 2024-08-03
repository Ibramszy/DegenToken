# Degen Gaming Token 🎮

Welcome to the Degen Gaming Token project! This document provides an overview of the token's functionality and deployment instructions for Degen Gaming, a renowned game studio looking to enhance player engagement with a unique `ERC20` token on the Avalanche blockchain.

## Overview

The DegenToken contract is designed for Degen Gaming to enhance player engagement by allowing players to earn, transfer, redeem, and burn tokens within the Avalanche blockchain ecosystem.

## Key Features and Code Functionality

`Minting New Tokens`: Only the owner can mint new tokens to reward players.
`Transferring Tokens`: Players can transfer their tokens to other players.
`Redeeming Tokens`: Players can redeem tokens for in-game items.
`Checking Token Balance`: Players can view their current token balance.
`Burning Tokens`: Players can burn their own tokens when they are no longer needed.

## Technical Details

The token is an ERC20 compliant token deployed on the Avalanche blockchain. Below are the core functionalities of the token smart contract:

1. Minting New Tokens
   ```solidity
   function mintTokens(address to, uint256 amount) public onlyOwner {
     _mint(to, amount);
   }
   ```
   The mintTokens function lets only the owner mint new tokens. This is enforced by the onlyOwner modifier from the Ownable contract.

2. Transferring Tokens
   ```solidity
    function transferTokens(address to, uint256 amount) public {
        require(to != address(0), "Invalid address");
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to transfer");
        _transfer(msg.sender, to, amount);
    }
   ```
   The transferTokens function allows players to transfer tokens to other addresses. It checks for sufficient balance and valid recipient address.

3. Redeeming Tokens
   ```solidity
    function redeemGamePad(uint256 quantity) public {
        uint256 cost = REDEMPTION_RATE * quantity;
        require(balanceOf(msg.sender) >= cost, "Not enough tokens");

        gamePadOwned[msg.sender] += quantity;
        _burn(msg.sender, cost);
    }
   ```
   The redeemGamePad function allows players to redeem tokens for in-game items, tracked by the gamePadOwned mapping. The cost of redemption is calculated using a constant REDEMPTION_RATE.

4. Checking Token Balance
   ```solidity
    function checkTokenBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }
   ```
   The checkTokenBalance function allows players to view their token balance.

5. Burning Tokens
   ```solidity
    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to burn");
        _burn(msg.sender, amount);
    }
   ```
   The burnTokens function allows players to burn their own tokens.

### Constructor
The constructor sets the token name and symbol and mints 10 tokens to the deployer’s address.
```solidity
constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
    mintTokens(msg.sender, 10 * (10 ** uint256(decimals())));
}
```




   

To successfully deploy the contract to snowtrace:

.open vs code
.enter: cd (your-project)
.enter: npm init -y
.enter: npm install --save-dev hardhat
.enter: npm install @openzeppelin/contracts
.Delete the existing module.exports code and add the following code to your hardhat.config.js file. This will enable us to test our smart contracts on the local network with data from Avalanche Mainnet.

```
const FORK_FUJI = false
const FORK_MAINNET = false
let forkingData = undefined;

if (FORK_MAINNET) {
  forkingData = {
    url: 'https://api.avax.network/ext/bc/C/rpcc',
  }
}
if (FORK_FUJI) {
  forkingData = {
    url: 'https://api.avax-test.network/ext/bc/C/rpc',
  }
}
```
replace the hardhat.config.js code with this code:

```
require("@nomicfoundation/hardhat-toolbox");

const FORK_FUJI = false;
const FORK_MAINNET = false;
let forkingData = undefined;

if (FORK_MAINNET) {
  forkingData = {
    url: "https://api.avax.network/ext/bc/C/rpcc",
  };
}
if (FORK_FUJI) {
  forkingData = {
    url: "https://api.avax-test.network/ext/bc/C/rpc",
  };
}

/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
  solidity: "0.8.18",

  
  etherscan: {
    apiKey: "your snowtrace api key here",
  },

  networks: {
    hardhat: {
      gasPrice: 225000000000,
      chainId: !forkingData ? 43112 : undefined, //Only specify a chainId if we are not forking
      forking: forkingData
    },

    fuji: {
      url: 'https://api.avax-test.network/ext/bc/C/rpc',
      gasPrice: 225000000000,
      chainId: 43113,
      accounts: [

        "private key from metamask here"

      ]
    },

    mainnet: {
      url: 'https://api.avax.network/ext/bc/C/rpc',
      gasPrice: 225000000000,
      chainId: 43114,
      accounts: [

        "private key from metamask here"

      ]
    }
  }

};
```

The project is licensed under MIT.
