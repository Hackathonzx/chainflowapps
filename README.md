# AstroPet: Decentralized NFT and Community Event Platform

# Overview

AstroPet is an Ethereum-based NFT and event management platform where users can mint unique pets, participate in community events, and earn rewards. The platform includes ETH-based rewards for users and a customizable NFT experience with unique properties for each minted pet.

# Features

**NFT Minting**: 
Only the contract owner can mint unique NFT pets for users with configurable metadata and origins.

**Community Events**:
The owner can create events that users can join to earn rewards.

**Rewards System**: 
Participants in events can earn ETH rewards, which they can later claim.

**User Preferences**: 
Users can set and retrieve their preferences within the system.

# Contract Functions

**mintAstroPe**t: Mints a new NFT pet to a specific address with metadata and origin details.

**createEvent**: Allows the contract owner to create an event with a start and end time.

**participateInEvent**: Allows users to join an event if it is active.

**distributeRewards**: The contract owner can distribute ETH rewards to participants.

**claimRewards**: Users can claim their accumulated rewards.

**depositETH**: The contract owner can deposit ETH into the contract to fund rewards.

**getContractBalance**: Returns the contract’s ETH balance.

# Security Considerations

**Reentrancy Guard**: Protects against reentrancy attacks in critical functions like minting and rewards claiming.

**Ownable**: Restricts certain functions to the contract owner.

# Getting Started

# Prerequisites

- Node.js and npm installed
- Hardhat installed globally or locally in the project
- An Ethereum wallet with testnet ETH if deploying on a test network(metamask use in this contract)

**Installation**

Clone this repository.

git clone 

cd

**Install dependencies**:

- npm install

# Testing

Run tests to ensure the contract functions as expected:

npx hardhat test

AstroPet Contract

    Minting AstroPets

      ✔ Should allow the owner to mint a new AstroPet

      ✔ Should not allow non-owner to mint a new AstroPet (72ms)

      ✔ Should enforce mint limit per address (49ms)

    Event Management

      ✔ Should allow the owner to create a new event

      ✔ Should allow users to participate in an event

    Reward Management

      ✔ Should allow the owner to distribute rewards

      ✔ Should allow users to claim their rewards

    ETH Deposits

      ✔ Should allow the owner to deposit ETH into the contract

      ✔ Should fail if non-owner tries to deposit ETH


  9 passing (5s)

  # Deployment

- Run npx hardhat compile to compile the contract.

- Run npx hardhat run ignition/modules/deploy.js --network arbitrumSepolia to deploy the contract.

Deploy the contract by running:

Here is the deployed contract address:

AstroPet deployed to: 0xA0BF7F60ec762cc7b88dEc415D46F12cFF130a55

And here is the Etherscan link address:

etherscan link: https://sepolia.arbiscan.io/address/0xA0BF7F60ec762cc7b88dEc415D46F12cFF130a55

# Contributing
- Fork the Repository:
- Create a New Branch:
git checkout -b feature/your-feature
- Make Changes and Commit:
git add .
git commit -m "Add feature"
Push Changes:
git push origin feature/your-feature

# License
AstroPet is licensed under the MIT License.

