// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdlendingPlatform {
    // Struct to represent a lending campaign
    struct LendingCampaign {
        address borrower;
        uint256 totalAmount;
        uint256 fundedAmount;
        uint256 interestRate;
        uint256 loanTerm;
        uint256 startTime;
        bool isFullyFunded;
        bool isRepaid;
        mapping(address => uint256) lenderContributions;
    }

    // Mapping to store lending campaigns
    mapping(uint256 => LendingCampaign) public lendingCampaigns;
    
    // Counter for campaign IDs
    uint256 public campaignCounter;

    // Minimum and maximum loan amounts
    uint256 public constant MIN_LOAN_AMOUNT = 0.1 ether;
    uint256 public constant MAX_LOAN_AMOUNT = 10 ether;

    // Events to log key actions
    event CampaignCreated(
        uint256 indexed campaignId, 
        address indexed borrower, 
        uint256 totalAmount, 
        uint256 interestRate, 
        uint256 loanTerm
    );

    event FundingContributed(
        uint256 indexed campaignId, 
        address indexed lender, 
        uint256 amount
    );

    event CampaignFullyFunded(
        uint256 indexed campaignId
    );

    event LoanRepaid(
        uint256 indexed campaignId
    );

    // Create a new lending campaign
    function createLendingCampaign(
        uint256 _totalAmount, 
        uint256 _interestRate, 
        uint256 _loanTerm
    ) public {
        // Validate loan parameters
        require(_totalAmount >= MIN_LOAN_AMOUNT, "Loan amount too low");
        require(_totalAmount <= MAX_LOAN_AMOUNT, "Loan amount too high");
        require(_interestRate > 0 && _interestRate <= 20, "Invalid interest rate");
        require(_loanTerm > 0 && _loanTerm <= 365 days, "Invalid loan term");

        // Increment campaign counter
        campaignCounter++;

        // Create new campaign
        LendingCampaign storage newCampaign = lendingCampaigns[campaignCounter];
        newCampaign.borrower = msg.sender;
        newCampaign.totalAmount = _totalAmount;
        newCampaign.interestRate = _interestRate;
        newCampaign.loanTerm = _loanTerm;
        newCampaign.startTime = block.timestamp;

        // Emit campaign creation event
        emit CampaignCreated(
            campaignCounter, 
            msg.sender, 
            _totalAmount, 
            _interestRate, 
            _loanTerm
        );
    }

    // Contribute funds to a lending campaign
    function contributeFunds(uint256 _campaignId) public payable {
        LendingCampaign storage campaign = lendingCampaigns[_campaignId];

        // Validate contribution
        require(!campaign.isFullyFunded, "Campaign is already fully funded");
        require(msg.value > 0, "Contribution must be greater than 0");
        
        // Calculate remaining funding needed
        uint256 remainingFunding = campaign.totalAmount - campaign.fundedAmount;
        uint256 contributionAmount = msg.value;

        // Adjust contribution if it exceeds remaining funding
        if (contributionAmount > remainingFunding) {
            contributionAmount = remainingFunding;
            // Refund excess
            payable(msg.sender).transfer(msg.value - contributionAmount);
        }

        // Update campaign funding
        campaign.fundedAmount += contributionAmount;
        campaign.lenderContributions[msg.sender] += contributionAmount;

        // Emit funding contribution event
        emit FundingContributed(_campaignId, msg.sender, contributionAmount);

        // Check if campaign is fully funded
        if (campaign.fundedAmount >= campaign.totalAmount) {
            campaign.isFullyFunded = true;
            emit CampaignFullyFunded(_campaignId);
        }
    }

    // Repay the loan
    function repayLoan(uint256 _campaignId) public payable {
        LendingCampaign storage campaign = lendingCampaigns[_campaignId];

        // Validate repayment
        require(campaign.isFullyFunded, "Campaign is not fully funded");
        require(msg.sender == campaign.borrower, "Only borrower can repay");
        require(!campaign.isRepaid, "Loan already repaid");

        // Calculate total repayment amount (principal + interest)
        uint256 interestAmount = (campaign.totalAmount * campaign.interestRate) / 100;
        uint256 totalRepaymentAmount = campaign.totalAmount + interestAmount;

        // Validate repayment amount
        require(msg.value >= totalRepaymentAmount, "Insufficient repayment amount");

        // Mark campaign as repaid
        campaign.isRepaid = true;

        // Emit loan repaid event
        emit LoanRepaid(_campaignId);
    }

    // Withdraw funds for lenders
    function withdrawFunds(uint256 _campaignId) public {
        LendingCampaign storage campaign = lendingCampaigns[_campaignId];

        // Validate withdrawal
        require(campaign.isRepaid, "Loan not yet repaid");
        
        // Calculate lender's share
        uint256 lenderContribution = campaign.lenderContributions[msg.sender];
        require(lenderContribution > 0, "No funds to withdraw");

        // Calculate lender's total return (proportional to contribution)
        uint256 interestAmount = (campaign.totalAmount * campaign.interestRate) / 100;
        uint256 lenderShare = lenderContribution + 
            ((lenderContribution * interestAmount) / campaign.totalAmount);

        // Reset lender's contribution
        campaign.lenderContributions[msg.sender] = 0;

        // Transfer funds
        payable(msg.sender).transfer(lenderShare);
    }

    // View function to get campaign details
    function getCampaignDetails(uint256 _campaignId) public view returns (
        address borrower,
        uint256 totalAmount,
        uint256 fundedAmount,
        uint256 interestRate,
        uint256 loanTerm,
        bool isFullyFunded,
        bool isRepaid
    ) {
        LendingCampaign storage campaign = lendingCampaigns[_campaignId];
        return (
            campaign.borrower,
            campaign.totalAmount,
            campaign.fundedAmount,
            campaign.interestRate,
            campaign.loanTerm,
            campaign.isFullyFunded,
            campaign.isRepaid
        );
    }
}