pragma solidity ^0.6.6;

contract MiContrato{
    
    uint256 contador;
    
    constructor (uint256 _contador) public{
        contador = _contador;
    } 
    
    function setContador(uint256 _contador) public{
        contador = _contador;
    }
    
    function incrementContador() public{
        contador += 1;
    }
    
    function getContador() public view returns(uint256){
        return contador;
    }
    
    function getNumber() public pure returns(uint256){
        return 512;
    }
    
}