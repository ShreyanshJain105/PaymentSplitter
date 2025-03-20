// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentSplitter {
    // Pre-defined recipient addresses
    address private recipient1 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    address private recipient2 = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
    address private recipient3 = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;

    // Pre-defined shares for each recipient (in percentage)
    uint256 private share1 = 50; // 50%
    uint256 private share2 = 30; // 30%
    uint256 private share3 = 20; // 20%

    // Function to split and send payments to recipients
    function splitPayment() external payable {
        require(msg.value > 0, "No Ether sent");

        uint256 totalValue = msg.value;

        // Calculate amounts for each recipient
        uint256 amount1 = (totalValue * share1) / 100;
        uint256 amount2 = (totalValue * share2) / 100;
        uint256 amount3 = (totalValue * share3) / 100;

        // Ensure no rounding errors by sending the remaining balance to the last recipient
        uint256 totalDistributed = amount1 + amount2 + amount3;
        if (totalDistributed < totalValue) {
            amount3 += totalValue - totalDistributed;
        }

        // Transfer funds to recipients
        (bool success1, ) = recipient1.call{value: amount1}("");
        require(success1, "Transfer to recipient1 failed");

        (bool success2, ) = recipient2.call{value: amount2}("");
        require(success2, "Transfer to recipient2 failed");

        (bool success3, ) = recipient3.call{value: amount3}("");
        require(success3, "Transfer to recipient3 failed");
    }
}
