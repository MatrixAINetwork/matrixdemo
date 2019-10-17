var DemoCoin = artifacts.require("./DemoCoin.sol");
const web3 = global.web3;
contract('DemoCoin', function() {

//    console.log()
    var owner ="MAN.2CE2zkLMgs2Pk2Y42nu8PgpVDDjMg";
    var to ="MAN.5ZUUYf8QQcPizuqCQMVQam5zmJZj";
    var value = 100000000000;

    var balanceOwer = 0;
    var balanceTo = 0;
    it("Initial DemoCoin settings should match", async () => {
        instance = await DemoCoin.deployed();
        assert.equal(await instance.owner(), owner, `DemoCoin's Owner isn't set properly`)
        balanceOwer = (await instance.balanceOf(owner));
        balanceTo = (await instance.balanceOf(to));
        await instance.transfer(to,value,{from:owner,gas: 1000000});
        var balance = (await instance.balanceOf(to)).toNumber();
        assert.equal(balance-balanceTo, value, "Transaction value doesn't match!");

    });

});
