// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external;

    event handleTransactionEvent(address user, address origSender, bytes msgData);
    event raiseAlertEvent(address user);
}

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
    function notify(address user, bytes calldata msgData) external;
    function raiseAlert(address user) external;
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
