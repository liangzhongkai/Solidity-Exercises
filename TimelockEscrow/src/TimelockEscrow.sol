// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract TimelockEscrow {
    address public seller;

    struct Escrow {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Escrow) public deposits;

    uint256 public constant LOCK_PERIOD = 3 days;

    /**
     * The goal of this exercise is to create a Time lock escrow.
     * A buyer deposits ether into a contract, and the seller cannot withdraw it until 3 days passes. Before that, the buyer can take it back
     * Assume the owner is the seller
     */

    constructor() {
        seller = msg.sender;
    }

    
    /**
     * creates a buy order between msg.sender and seller
     * escrows msg.value for 3 days which buyer can withdraw at anytime before 3 days but afterwhich only seller can withdraw
     * should revert if an active escrow still exist or last escrow hasn't been withdrawn
     */
    function createBuyOrder() external payable {
        require(msg.value > 0, "must deposit ether");
        require(deposits[msg.sender].amount == 0, "active escrow exists or last escrow not withdrawn");
        deposits[msg.sender] = Escrow({amount: msg.value, timestamp: block.timestamp});
    }

    /**
     * allows seller to withdraw after 3 days of the escrow with @param buyer has passed
     */
    function sellerWithdraw(address buyer) external {
        require(msg.sender == seller, "only seller");
        Escrow storage escrow = deposits[buyer];
        require(escrow.amount > 0, "no escrow");
        require(block.timestamp >= escrow.timestamp + LOCK_PERIOD, "lock period not passed");
        uint256 amount = escrow.amount;
        delete deposits[buyer];
        (bool success,) = seller.call{value: amount}("");
        require(success, "transfer failed");
    }

    /**
     * allows buyer to withdraw at anytime before the end of the escrow (3 days)
     */
    function buyerWithdraw() external {
        Escrow storage escrow = deposits[msg.sender];
        require(escrow.amount > 0, "no escrow");
        require(block.timestamp < escrow.timestamp + LOCK_PERIOD, "lock period passed, only seller can withdraw");
        uint256 amount = escrow.amount;
        delete deposits[msg.sender];
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "transfer failed");
    }

    // returns the escrowed amount of @param buyer
    function buyerDeposit(address buyer) external view returns (uint256) {
        return deposits[buyer].amount;
    }
}
