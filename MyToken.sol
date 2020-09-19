pragma solidity ^0.6.0;

contract MXCoin{
    
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    //Se utiliza para la relación de una dirección con su saldo.
    mapping(address => uint256) public balanceOf; 
    //Se utiliza para la relación de a que direcciones aprovamos y que cantidad de token se le autorizan
    mapping(address => mapping(address => uint256)) public allowance; 
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    uint256 dividendPerToken;
    mapping(address => uint256) dividendBalanceOf;
    mapping(address => uint256) dividendCreditedTo;
    
    function update(address _address) internal {
        uint256 debit = dividendPerToken - dividendCreditedTo[_address];
        dividendBalanceOf[_address] += balanceOf[_address] * debit;
        dividendCreditedTo[_address] = dividendPerToken;
    }
    
    function withdraw() public {
        update(msg.sender);
        uint256 amount = dividendBalanceOf[msg.sender];
        dividendBalanceOf[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
    
    function deposit() public payable{
        dividendPerToken += msg.value / totalSupply;
        
    }
    
    constructor() public{
        name = "MXCoin";
        symbol = "MXC";
        decimals = 8;
        totalSupply = 21000000 * (uint256(10) ** decimals);
        balanceOf[msg.sender] = totalSupply;
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender] >= _value);
        update(msg.sender);
        update(_to);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(balanceOf[_from] >= _value); //Valida que el dueño de los token, tiene la cantidad de token o más
        //Valida que la cantidad de tokens que aprovo el dueño a msg.sender es mayor o igual a _value
        require(allowance[_from][msg.sender] >= _value); 
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    

}