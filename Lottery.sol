// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract lottery{
  address  public manager; 
  address payable [] public players;
 constructor()
{  
    manager = msg.sender;
}
function alreadyEntered()view private returns(bool) {
    for(uint i=0;i<players.length;i++)
    {   if(msg.sender==players[i])
{return true;}
    }
    return false;

}

function enter()payable public{
 require(msg.sender!=manager,"manager cannot enter");
 require (alreadyEntered() ==false,"player already entered");
 require(msg.value>=1 ether,"minimum amount must be payed");
 players.push(payable (msg.sender));

}
function random() view private  returns(uint)
{ return uint(sha256(abi.encodePacked  ( block.difficulty,block.number,players)));}

function pickwin() public 
{ require(msg.sender==manager,"you can not access");

uint index =random()%players.length;//winer index
 uint contractAddress=uint(address(this).balance);
players[index].transfer(contractAddress);
players=new address payable [](0);
}
function getplayers()view public returns(address payable []memory)
{return players;}
}