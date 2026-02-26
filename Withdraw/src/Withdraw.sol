// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract Withdraw {
    mapping(address => uint256) public amountReceived;
    receive() external payable {
        amountReceived[msg.sender] += msg.value;
    }
    // @notice make this contract able to receive ether from anyone and anyone can call withdraw below to withdraw all ether from it
    function withdraw() public {
        uint256 amount = amountReceived[msg.sender];
        require(amount > 0, "No amount received");
        amountReceived[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }
}
