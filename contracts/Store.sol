pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./HeartToken.sol";


contract Store is Ownable {

    HeartToken internal token;

    uint public minSell = 10;
    uint public price = 0.005 ether;
    uint public commision = 0.001 ether;

    function buyHeart(uint amount) public payable {
        require(msg.value >= (amount * price));
        require(token.balanceOf(owner) >= amount);
        token.transferFrom(owner, msg.sender, amount);
    }

    function sellHeart(uint amount) public {
        require(minSell <= amount);
        require(token.balanceOf(msg.sender) >= amount);
        require(((price - commision) * amount) <= this.balance);
        token.transfer(owner, amount);
        msg.sender.transfer((price - commision) * amount);
    }

    function setComission(uint value) public onlyOwner {
        commision = value;
    }

    function setPrice(uint value) public onlyOwner {
        price = value;
    }

    function setMinSell(uint value) public onlyOwner {
        minSell = value;
    }

    function setToken(address _addressToken) public onlyOwner {
        token = HeartToken(_addressToken);
    }
}
