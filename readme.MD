# matrixDemo

Matrix AI Network local test block chain and demo contracts with default config and man address support
## Init man contract
    cd {yourcontractdir}
    truffle unbox matrixDemo
## install Docker
    sudo yum makecache fast
    sudo yum -y install docker-ce
## invoke truffle-matrix
    truffle-matrix
## contract migrate
    truffle migrate
## truffle-config
##### Each network properties add type,dryRun,skipDryRun setting like this:
    development: {
        type = "matrix",
        skipDryRun: true,
    }
#### Add manUtils.sol support
###### Convert address to man address(string)
    function toMan(address _addr)  public pure returns (string)
###### Convert man address(string) to address
    function toAddress(string _manAddr) public pure returns(address)
