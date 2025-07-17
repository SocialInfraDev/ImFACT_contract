# ImFACT Token

A simple ERC-20 token implementation using Solidity.

## Overview

This project contains a minimal yet fully functional ERC-20 token smart contract built with Solidity.  
It can be deployed on Ethereum mainnet or compatible EVM networks (e.g., BNB Smart Chain, Polygon, etc.).

## Features

- Fully ERC-20 compliant
- Custom token name, symbol, and initial supply
- OpenZeppelin Contracts for security and standardization
- Written in Solidity ^0.8.x

## Project Structure

.
├── contracts/
│ └── imfact.sol # Main ERC20 contract
├── scripts/
│ └── deploy.js # Deployment script (for Hardhat/Truffle)
├── test/
│ └── imfact.test.js # Tests
└── README.md
