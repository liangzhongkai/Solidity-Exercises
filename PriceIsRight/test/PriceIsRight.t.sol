// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PriceIsRight.sol";

contract PriceIsRightTest is Test {
    PriceIsRight public priceIsRight;

    function setUp() public {
        priceIsRight = new PriceIsRight();
    }

    function testBuy(uint256 amount) external {
        amount = amount == 1 ether ? 2 ether : amount;
        amount = bound(amount, 0, 10 ether);  // 限制范围，避免超大 amount 导致 OutOfFunds
        vm.deal(address(this), 1 ether);
        priceIsRight.buy{value: 1 ether}();

        vm.deal(address(this), amount);  // 确保有足够资金发送 amount，让 revert 来自合约的 require 而非 OutOfFunds
        vm.expectRevert();
        priceIsRight.buy{value: amount}();
    }
}
