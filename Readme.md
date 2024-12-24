# CrowdLending Platform Smart Contract

A decentralized crowdlending platform that enables peer-to-peer lending through smart contracts, allowing borrowers to create loan campaigns and lenders to contribute funds.

## Overview

The CrowdLending Platform is a Solidity-based smart contract that facilitates decentralized lending. It allows borrowers to create lending campaigns and lenders to contribute funds, with automated interest calculations and fund distribution.

## Features

### Core Functionality
- Create lending campaigns with customizable parameters
- Contribute funds to active campaigns
- Automated loan repayment processing
- Proportional interest distribution to lenders
- Fund withdrawal system for lenders

### Technical Specifications
- Solidity Version: ^0.8.0
- Minimum Loan Amount: 0.1 ETH
- Maximum Loan Amount: 10 ETH
- Interest Rate Range: 1-20%
- Maximum Loan Term: 365 days

## Smart Contract Functions

### For Borrowers

#### createLendingCampaign
Creates a new lending campaign with specified parameters:
- Total loan amount
- Interest rate
- Loan term

solidity
function createLendingCampaign(
    uint256 _totalAmount, 
    uint256 _interestRate, 
    uint256 _loanTerm
) public


#### repayLoan
Allows borrowers to repay their loan with interest:
solidity
function repayLoan(uint256 _campaignId) public payable


### For Lenders

#### contributeFunds
Enables lenders to contribute to active campaigns:
solidity
function contributeFunds(uint256 _campaignId) public payable


#### withdrawFunds
Allows lenders to withdraw their funds plus interest after loan repayment:
solidity
function withdrawFunds(uint256 _campaignId) public


### View Functions

#### getCampaignDetails
Retrieves detailed information about a specific campaign:
solidity
function getCampaignDetails(uint256 _campaignId) public view returns (
    address borrower,
    uint256 totalAmount,
    uint256 fundedAmount,
    uint256 interestRate,
    uint256 loanTerm,
    bool isFullyFunded,
    bool isRepaid
)


## Events

The contract emits the following events:
- CampaignCreated: When a new lending campaign is created
- FundingContributed: When a lender contributes funds
- CampaignFullyFunded: When a campaign reaches its funding goal
- LoanRepaid: When a loan is successfully repaid

## Security Features

### Built-in Protections
- Minimum and maximum loan amount constraints
- Interest rate limitations (1-20%)
- Maximum loan term restriction (365 days)
- Automatic excess fund refunding
- Access control for loan repayment
- Proportional interest distribution

## Usage Flow

1. *Campaign Creation*
   - Borrower creates a campaign with desired parameters
   - System validates loan amount, interest rate, and term

2. *Funding Process*
   - Lenders can contribute any amount up to the remaining funding needed
   - Excess contributions are automatically refunded
   - Campaign is marked as fully funded when target is reached

3. *Loan Repayment*
   - Borrower repays the loan amount plus interest
   - System verifies repayment amount and borrower identity

4. *Fund Withdrawal*
   - Lenders can withdraw their contribution plus earned interest
   - Interest is distributed proportionally based on contribution

## Future Development Considerations

1. *Potential Enhancements*
   - Collateral integration
   - Variable interest rates
   - Extended loan terms
   - Multiple currency support
   - Credit scoring system

2. *Technical Improvements*
   - Gas optimization
   - Additional security features
   - Enhanced event logging
   - Advanced repayment schedules

## Development and Testing

### Prerequisites
- Solidity ^0.8.0
- Ethereum development environment (Hardhat/Truffle)
- Web3 provider

### Testing
Recommended test scenarios:
1. Campaign creation with various parameters
2. Multiple lender contributions
3. Partial and full funding scenarios
4. Loan repayment and interest calculation
5. Fund withdrawal mechanics

## License

This project is licensed under the MIT License.
