require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");
require("dotenv").config();

const { UNICHAIN_URL, PRIVATE_KEY } = process.env


module.exports = {
  solidity: "0.8.1",
  networks: {
    UnichainSepoliaTestnet: {
      url: process.env.UNICHAIN_URL,
      chainId: 1301,
      accounts: [process.env.PRIVATE_KEY],
   },
 },
}

