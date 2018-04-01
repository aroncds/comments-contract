var HeartToken = artifacts.require("./contracts/HeartToken.sol");
var Gallery = artifacts.require('./constracts/Gallery.sol');

module.exports = function(deployer){
    deployer.deploy(HeartToken).then(function() {
        return deployer.deploy(Gallery, HeartToken.address);   
    });;
};
