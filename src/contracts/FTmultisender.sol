/**
 *Submitted for verification at polygonscan.com on 2024-01-17
 */

// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Multisender {
    event Multisend(address tokenAddress, uint256 total);

    function multisendToken(
        address tokenAddress,
        address[] calldata targets,
        uint256[] calldata amounts
    ) external payable {
        if (tokenAddress == address(0)) {
            multisendEther(targets, amounts);
        } else {
            require(
                targets.length == amounts.length,
                "V1: Length Incompatible"
            );
            IERC20 token = IERC20(tokenAddress);
            uint256 total = 0;

            for (uint256 i = 0; i < targets.length; i++) {
                total += amounts[i];
                require(
                    token.transferFrom(msg.sender, targets[i], amounts[i]),
                    "V1: Insufficie"
                );
            }

            emit Multisend(tokenAddress, total);
        }
    }

    function multisendEther(
        address[] calldata targets,
        uint256[] calldata amounts
    ) public payable {
        require(targets.length == amounts.length, "V1: Length Incompatible");

        uint256 total;
        for (uint256 i = 0; i < targets.length; i++) {
            total += amounts[i];
            bool transferSuccessful = payable(targets[i]).send(amounts[i]);
            require(transferSuccessful, "V1: Invalid Address");
        }

        require(total == msg.value, "V1: Value Incompatible");

        emit Multisend(address(0), total);
    }
}
