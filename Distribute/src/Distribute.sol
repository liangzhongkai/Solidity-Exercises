// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract Distribute {
    /*
        This exercise assumes you know how to send Ether.
        1. This contract has some ether in it, distribute it equally among the
           array of addresses that is passed as argument.
        2. Write your code in the `distributeEther` function.
    */

    constructor() payable {}

    function distributeEther(address[] memory addresses) public {
        // your code here
        require(addresses.length > 0, "Addresses array cannot be empty");

        uint256 totalAmount = address(this).balance;
        uint256 amountPerAddress = totalAmount / addresses.length;
        for (uint256 i = 0; i < addresses.length; i++) {
            require(addresses[i] != address(this), "Cannot send to self");
            (bool success, ) = payable(addresses[i]).call{value: amountPerAddress}("");
            require(success, "Transfer failed");
        }
    }
}
