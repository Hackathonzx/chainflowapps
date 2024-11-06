// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./interfaces/ICrossChainRouter.sol";
import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol"; // For interest rate oracle

contract CrossChainLiquidityAggregator is Ownable, ReentrancyGuard {
    ICrossChainRouter public chainlinkCCIPRouter;
    AggregatorV3Interface public interestRateOracle;

    struct Loan {
        address borrower;
        uint256 amount;
        uint256 interestRate; // Annual interest rate in basis points
        uint256 term; // Loan term in seconds
        uint256 dueDate;
        bool isActive;
    }

    struct LiquidityPool {
        uint256 totalLiquidity;
        mapping(address => uint256) userLiquidity;
    }

    mapping(uint256 => Loan) public loans; // Mapping of loan IDs to Loan struct
    mapping(address => LiquidityPool) public liquidityPools; // Mapping of token address to LiquidityPool struct
    uint256 public loanCount; // Count of loans issued

    // Events for tracking major actions
    event LoanIssued(uint256 loanId, address borrower, uint256 amount, uint256 interestRate);
    event LoanRepaid(uint256 loanId, address borrower, uint256 amountPaid);
    event LiquidityAdded(address user, uint256 amount);
    event LiquidityRemoved(address user, uint256 amount);
    event CrossChainTransferInitiated(uint256 amount, address targetChain, address targetAddress);

    // Constructor sets the Chainlink CCIP router and interest rate oracle addresses
    constructor(address _chainlinkCCIPRouter, address _interestRateOracle) {
        chainlinkCCIPRouter = ICrossChainRouter(_chainlinkCCIPRouter);
        interestRateOracle = AggregatorV3Interface(_interestRateOracle);
    }

    // Function to issue a loan to a borrower
    function issueLoan(uint256 amount, uint256 interestRate, uint256 term) external nonReentrant {
        require(amount > 0, "Amount must be greater than zero");
        require(interestRate > 0, "Interest rate must be greater than zero");

        loanCount++;
        loans[loanCount] = Loan({
            borrower: msg.sender,
            amount: amount,
            interestRate: interestRate,
            term: term,
            dueDate: block.timestamp + term,
            isActive: true
        });

        emit LoanIssued(loanCount, msg.sender, amount, interestRate);
    }

    // Function for borrowers to repay loans, including principal + interest
function repayLoan(uint256 loanId, address tokenAddress) external nonReentrant {
    Loan storage loan = loans[loanId];
    require(loan.isActive, "Loan is not active");
    require(loan.borrower == msg.sender, "Only the borrower can repay the loan");
    require(block.timestamp < loan.dueDate, "Loan is overdue");

    // Calculate total amount due (principal + interest)
    uint256 interest = calculateInterest(loan.amount, loan.interestRate, loan.term);
    uint256 totalAmountDue = loan.amount + interest;

    // Transfer funds from borrower to contract
    IERC20 token = IERC20(tokenAddress); // Declare and instantiate the token
    require(token.transferFrom(msg.sender, address(this), totalAmountDue), "Transfer failed");

    loan.isActive = false;
    emit LoanRepaid(loanId, msg.sender, totalAmountDue);
}


    // Calculate interest based on principal, annual interest rate (basis points), and loan term
    function calculateInterest(uint256 principal, uint256 annualRate, uint256 term) internal pure returns (uint256) {
        return (principal * annualRate * term) / (10000 * 365 days);
    }

    // Fetch live interest rates from Chainlink Oracle
    function updateInterestRates() external {
        (, int256 rate,,,) = interestRateOracle.latestRoundData();
        require(rate > 0, "Invalid rate data");
    }

    // Add liquidity to the specified token's liquidity pool
    function addLiquidity(address tokenAddress, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than zero");
        IERC20 token = IERC20(tokenAddress);
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        liquidityPools[tokenAddress].totalLiquidity += amount;
        liquidityPools[tokenAddress].userLiquidity[msg.sender] += amount;

        emit LiquidityAdded(msg.sender, amount);
    }

    // Remove liquidity from the specified token's liquidity pool
    function removeLiquidity(address tokenAddress, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than zero");
        require(liquidityPools[tokenAddress].userLiquidity[msg.sender] >= amount, "Insufficient liquidity");

        liquidityPools[tokenAddress].totalLiquidity -= amount;
        liquidityPools[tokenAddress].userLiquidity[msg.sender] -= amount;

        IERC20 token = IERC20(tokenAddress);
        require(token.transfer(msg.sender, amount), "Transfer failed");

        emit LiquidityRemoved(msg.sender, amount);
    }

    // Cross-chain transfer function using Chainlink CCIP
    function crossChainTransfer(uint256 amount, address targetChain, address targetAddress) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        
        // Construct the message payload for the cross-chain transfer
        bytes memory payload = abi.encode(targetAddress, amount);

        // Initiate the cross-chain transfer via Chainlink CCIP Router
        chainlinkCCIPRouter.sendMessage(
            targetChain,  // Target blockchain identifier
            payload       // Encoded payload containing the target address and amount
        );

        emit CrossChainTransferInitiated(amount, targetChain, targetAddress);
    }

    // Function to retrieve liquidity pool data via an oracle
    function getLiquidityPoolData(address tokenAddress) external view returns (uint256 totalLiquidity, uint256 userLiquidity) {
        totalLiquidity = liquidityPools[tokenAddress].totalLiquidity;
        userLiquidity = liquidityPools[tokenAddress].userLiquidity[msg.sender];
        return (totalLiquidity, userLiquidity);
    }
    
    // Function to get decentralized credit score based on reputation
    function getCreditScore(address user) external view returns (uint256) {
        return calculateReputationScore(user); // Call internal function to calculate credit score
    }

    // Internal function to calculate a basic reputation score
    function calculateReputationScore(address user) internal view returns (uint256) {
        uint256 liquidityContribution = liquidityPools[user].userLiquidity[user];
        uint256 score = liquidityContribution / 1000; // Simplified scoring formula
        return score;
    }
}