pragma solidity ^0.5.0;

import "./Token.sol";

contract Ethswap {
    string public name = "EthSwap Instant Exchange";
    Token public token;
    uint public rate = 100;

    constructor(Token _token) public {
        token = _token;
    }

    event TokensPurchased(
        address account,
        address token,
        uint amount,
        uint rate
    );

    function buyTokens() public payable {
        uint tokenAmount = msg.value * rate;
        require(token.balanceOf(address(this)) >= tokenAmount);
        token.transfer(msg.sender, tokenAmount);

        emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
    }
}
