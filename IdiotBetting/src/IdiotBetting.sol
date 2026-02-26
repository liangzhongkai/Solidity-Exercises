// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract IdiotBettingGame {
    /*
        This exercise assumes you know how block.timestamp works.
        - Whoever deposits the most ether into a contract wins all the ether if no-one 
          else deposits after an hour.
        1. `bet` function allows users to deposit ether into the contract. 
           If the deposit is higher than the previous highest deposit, the endTime is 
           updated by current time + 1 hour, the highest deposit and winner are updated.
        2. `claimPrize` function can only be called by the winner after the betting 
           period has ended. It transfers the entire balance of the contract to the winner.
    */

    uint256 public highestDeposit;
    address public winner;
    uint256 public endTime;

    function bet() public payable {
        // your code here
        require(msg.value > 0, "Must deposit some ether");
        if ((endTime == 0 || block.timestamp < endTime) && msg.value > highestDeposit) {
            winner = msg.sender;
            highestDeposit = msg.value;
            endTime = block.timestamp + 1 hours;
        }
    }

    function claimPrize() public {
        // your code here
        require(msg.sender == winner, "Not the winner");
        require(block.timestamp > endTime, "Betting period has not ended");
        uint256 prize = address(this).balance; // get the entire balance of the contract
        highestDeposit = 0;
        winner = address(0);
        endTime = 0;
        (bool success, ) = payable(msg.sender).call{value: prize}("");
        require(success, "Transfer failed");
    }
}
