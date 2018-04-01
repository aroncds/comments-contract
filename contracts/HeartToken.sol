pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract HeartToken is StandardToken {

    string public name = "Heart";
    string public symbol = "HKR";
    uint public decimals = 8;
    uint public INITIAL_SUPPLY = 21000000 * (10 ** decimals);

    function HeartToken() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = totalSupply_;
    }

}