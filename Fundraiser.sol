// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Fundraiser {
    string public title;
    string public description;
    uint256 public goal;
    uint256 public deadline;
    uint256 public totalRaised;
    bool public withdrawn;
    address public owner;

    mapping(address => uint256) public donations;

    event Donated(address indexed donor, uint256 amount, uint256 newTotal);
    event FundsWithdrawn(address indexed owner, uint256 amount);
    event Refunded(address indexed donor, uint256 amount);

    constructor(
        string memory _title,
        string memory _description,
        uint256 _goalInWei,
        uint256 _durationSeconds
    ) {
        require(_goalInWei > 0, "Goal must be more than zero");
        require(_durationSeconds > 0, "Duration must be more than zero");

        title = _title;
        description = _description;
        goal = _goalInWei;
        deadline = block.timestamp + _durationSeconds;
        owner = msg.sender;
    }

    function donate() public payable {
        require(block.timestamp < deadline, "Campaign has ended");
        require(msg.value > 0, "Donation must be more than zero");
        require(totalRaised < goal, "Goal already reached");

        donations[msg.sender] += msg.value;
        totalRaised += msg.value;

        emit Donated(msg.sender, msg.value, totalRaised);
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalRaised >= goal, "Goal was not reached");
        require(!withdrawn, "Already withdrawn");

        uint256 amount = address(this).balance;
        withdrawn = true;

        (bool sent, ) = payable(owner).call{value: amount}("");
        require(sent, "Withdraw failed");

        emit FundsWithdrawn(owner, amount);
    }

    function refund() public {
        require(block.timestamp >= deadline, "Campaign is still active");
        require(totalRaised < goal, "Goal was reached");

        uint256 amount = donations[msg.sender];
        require(amount > 0, "No donation to refund");

        donations[msg.sender] = 0;
        totalRaised -= amount;

        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Refund failed");

        emit Refunded(msg.sender, amount);
    }

    function getStatus()
        public
        view
        returns (
            bool isActive,
            bool goalReached,
            uint256 remaining,
            uint256 timeLeft
        )
    {
        isActive = block.timestamp < deadline && totalRaised < goal;
        goalReached = totalRaised >= goal;

        if (totalRaised >= goal) {
            remaining = 0;
        } else {
            remaining = goal - totalRaised;
        }

        if (block.timestamp >= deadline) {
            timeLeft = 0;
        } else {
            timeLeft = deadline - block.timestamp;
        }
    }
}
