// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// forge create Destructive --private-key $PKEY --rpc-url $RPC_URL

contract Destructive {
    function kill() external {
        selfdestruct(payable(address(0)));
    }
}

