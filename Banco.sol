pragma solidity ^0.6.0;

contract banco{
    
    address owner;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _; //
    }
    
    function newOwner(address _newOwner) public onlyOwner{
        owner = _newOwner;
    }
    
    function getOwner() view public returns (address){
        return owner;
    }
    
    function getBalance() view public returns (uint256){
        return address(this).balance;
    }
    
    constructor() payable public{ //payable indica que recibe dinero/valor
        owner = msg.sender;
    } 
    
    function incrementBalance(uint256 amount) payable public{
        require(msg.value == amount);
    }
    
    function withdrawBalance() public onlyOwner{
        //require(msg.sender == owner); se cambio a un modifier
        //Verifica que quien invoca el contrato sea el owner, si no, lanza excepción y regresa el contrato al estado inicial
        msg.sender.transfer(address(this).balance);
        //msg "objeto" con propiedades por ejemplo msg.sender, hace referencia a quien llama al contrato
        //utilizar transfer en lugar de send 
        
        /*Explicación: Al usuario que llamo al contrato (sender) se le tranfiere el balance del contrato*/
    }
    
}