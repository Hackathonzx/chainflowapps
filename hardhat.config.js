require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");
require("dotenv").config();

// require("hardhat-arbitrum");

const { ARBITRUM_URL, PRIVATE_KEY } = process.env


module.exports = {
  solidity: "0.8.1",
  networks: {
    UnichainSepoliaTestnet: {
      url: process.env.ARBITRUM_URL,
      chainId: 421614,
      accounts: [process.env.PRIVATE_KEY],
   },
 },
}

