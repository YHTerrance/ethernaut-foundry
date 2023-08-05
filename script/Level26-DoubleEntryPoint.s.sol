// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

interface IDEP {
    function cryptoVault() external view returns (address);
    function delegatedFrom() external view returns (address);
    function forta() external view returns (address);
}

interface ICryptoVault {
    function underlying() external view returns (address);
    function sweptTokensRecipient() external view returns (address);
    function sweepToken(address token) external;
}

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
    function notify(address user, bytes calldata msgData) external;
    function raiseAlert(address user) external;
}

interface IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external;

    event handleTransactionEvent(address user, address origSender, bytes msgData);
    event raiseAlertEvent(address user);
}

contract DetectionBot is IDetectionBot {

    address cryptoVault;

    constructor(address cryptoVault_) {
        cryptoVault = cryptoVault_;
    }

    function handleTransaction(address user, bytes calldata msgData) external override {

        // the first 4 bytes is thefunction signature (we should skip them)
        (, , address origSender) = abi.decode(msgData[4:], (address, uint256, address));
        emit handleTransactionEvent(user, origSender, msgData);

        if (origSender == cryptoVault) {
            IForta(msg.sender).raiseAlert(user);
            emit raiseAlertEvent(user);
        }
    }
}

contract DEPScript is Script {

    IDEP DEP = IDEP(0x495A644d724f46010D72eF9D033F8BAb9dF75451);

    function run() public {
        vm.startBroadcast();

        address forta_ = DEP.forta();
        address cryptoVault_ = DEP.cryptoVault();


        // 1. Deploy and Register own detection bot
        address detectionBot_ = address(new DetectionBot(cryptoVault_));
        IForta(forta_).setDetectionBot(detectionBot_);

        // 2. Sweep legacy tokens (Check if this reverts)
        address LGT_ = DEP.delegatedFrom();
        ICryptoVault(cryptoVault_).sweepToken(LGT_);

        vm.stopBroadcast();
    }
}
