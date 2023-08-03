// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Level25 {
    function kill() external {
        selfdestruct(payable(address(0)));
    }
}
