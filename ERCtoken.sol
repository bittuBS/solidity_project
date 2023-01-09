//SPDX-License-Identifier:GPL-3.0
pragma solidity ^0.8.0;
//.........................................................................
//EIP-20:ERC-20 Token standard
//https://eips.ethereum.org/EIPS/eip-20
//...........................................
interface ERC20Interface{
   // function name() public view returns (string); optional
//function decimals() public view returns (uint8)
function totalSupply() external view returns (uint256);
function balanceOf(address _owner)external view returns (uint256 balance);
function transfer(address _to, uint256 _value) external returns (bool success);
function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
function approve(address _spender, uint256 _value) external returns (bool success);
 function allowance(address _owner, address _spender) external view returns (uint256 remaining);
 event Transfer(address indexed _from, address indexed _to, uint256 _value);
 event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}
 abstract contract  Block is ERC20Interface{
string name="Block";
string public symbol="BLK";
uint public decimal=0;
uint public override totalSupply;//variable for getter function
address public founder;
mapping(address=>uint )public balances;
mapping(address=>mapping(address =>uint))public allowed;
constructor()
{
    totalSupply=1000;
    founder=msg.sender;
    balances[founder]=totalSupply;
} 
function balanceOf(address _owner)external view override returns (uint balance)
{
   return balances[_owner];
}
function transfer(address _to, uint _value) external returns (bool success)
{
    require(balances[msg.sender] >= _value,"you have not sufficient balance");
    balances[_to]+= _value;
    balances[msg.sender]-=_value;
    emit Transfer(msg.sender, _to,_value);
    return true;
}
function allowance(address _owner, address _spender) external view returns (uint256 remaining)
{
   return allowed[_owner][_spender];
}
function approve(address _spender, uint256 _value) external  override returns (bool success)
{ 
require(balances[msg.sender]>=_value,"not enough ether");
require(_value >0,"not approved");
allowed[msg.sender][_spender]=_value;
emit Approval(msg.sender,  _spender, _value);
return true;
}
function transferFrom(address _from, address _to, uint256 _value) external returns (bool success){
    require(allowed[_from][_to]>=_value,"not approved");
    require(balances[_from]>=_value,"you have not insufficeint ether for the contract");
balances[_from]-= _value;
balances[_to]+= _value;
return true;

}



}