// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract OneWeekLockup {
    /**
     * In this exercise you are expected to create functions that let users deposit ether
     * Users can also withdraw their ether (not more than their deposit) but should only be able to do a week after their last deposit
     * Consider edge cases by which users might utilize to deposit ether
     *
     * Required function
     * - depositEther()
     * - withdrawEther(uint256 )
     * - balanceOf(address )
     */

    mapping(address => uint256) public balances;
    mapping(address => uint256) public lastDepositTime;

    function balanceOf(address user) public view returns (uint256) {
        // return the user's balance in the contract
        return balances[user];
    }

    function depositEther() external payable {
        /// add code here
        require(msg.value > 0, "Must deposit some ether");
        balances[msg.sender] += msg.value;
        lastDepositTime[msg.sender] = block.timestamp;
    }

    function withdrawEther(uint256 amount) external {
        /// add code here
        require(amount > 0, "Must withdraw some ether");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(block.timestamp - lastDepositTime[msg.sender] >= 1 weeks, "Not enough time has passed since last deposit");
        balances[msg.sender] -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }
}
