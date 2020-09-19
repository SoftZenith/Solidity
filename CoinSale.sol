pragma solidity ^0.6.0;

interface MyCoin{
    function decimals() external view returns(uint8);
    function balanceOf(address _address) external view returns(uint256);
    function transfer(address _to, uint256 _value) external returns (bool success);
}

contract CoinSale{
    
    address owner;
    uint256 price;
    MyCoin myCoinContract;
    uint256 coinsSold;
    
    event Sold(address buyer, uint256 amount);
    
    constructor(uint256 _price, address _addressContract) public{
        owner = msg.sender;
        price = _price;
        myCoinContract = MyCoin(_addressContract);
    }
    
    function mul(uint256 a, uint256 b) internal pure returns(uint256){
        if (a == 0){
            return 0;
        }
        
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
    
    function buy(uint256 _numCoins) public payable{
        require(msg.value == mul(price, _numCoins));
        uint256 scaledAmount = mul(_numCoins, uint256(10)** myCoinContract.decimals());
        require(myCoinContract.balanceOf(address(this)) >= scaledAmount);
        coinsSold += _numCoins;
        require(myCoinContract.transfer(msg.sender, scaledAmount));
        emit Sold(msg.sender, _numCoins);
    }
    
    function endSold() public {
        require(msg.sender == owner);
        require(myCoinContract.transfer(owner, myCoinContract.balanceOf(address(this))));
        msg.sender.transfer(address(this).balance);
    }
    
}