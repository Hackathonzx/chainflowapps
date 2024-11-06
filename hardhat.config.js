require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");

const { UNICHAIN_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.1",
  networks: {
    UnichainSepoliaTestnet: {
      url: UNICHAIN_URL,
      chainId: 1301,
      accounts: [PRIVATE_KEY],
    },
  },

  sourcify: {
    enabled: false,
  },

  etherscan: {
    apiKey: "4CZFJHHXHR9WRAA9J6TWCT4KBWT2NC5W1E", // Leave empty or remove this section
    customChains: [
      {
        network: "UnichainSepoliaTestnet",
        chainId: 1301,
        urls: {
          apiURL: "https://api-sepolia.uniscan.xyz/api",
          browserURL: "https://sepolia.uniscan.xyz",
        },
      },
    ],
  },
};
