// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICrossChainRouter {
    function sendMessage(
        address targetChain,
        bytes calldata payload
    ) external;
}