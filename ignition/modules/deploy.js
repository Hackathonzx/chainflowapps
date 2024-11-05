const hre = require("hardhat");

async function main() {
    // Get the contract factory
    const CrossChainLiquidityAggregator = await hre.ethers.getContractFactory("CrossChainLiquidityAggregator");

    // Define the addresses for Chainlink CCIP Router and Interest Rate Oracle
    const chainlinkCCIPRouterAddress = "0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59"; // Replace with actual address
    const interestRateOracleAddress = "0xYourInterestRateOracleAddress"; // Replace with actual address

    // Deploy the contract
    const aggregator = await CrossChainLiquidityAggregator.deploy(chainlinkCCIPRouterAddress, interestRateOracleAddress);

    // Wait for the deployment to complete
    await aggregator.waitForDeployment();

    console.log("CrossChainLiquidityAggregator deployed to:", aggregator.address);
}

// Run the deployment script
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
