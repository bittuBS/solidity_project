//SPDX-License-Identifier:UNLICENSED
pragma solidity ^ 0.8.0;
contract wallet{
    address public  owner=msg.sender;
    modifier check()
    {
        require(msg.sender == owner,"not allowed");
        _;

    }
    event Check(string data);
    function sendEth(address payable add  )public payable check
    {add.transfer(msg.value);
    }
    function OtherSend(address payable add) public payable{
 if(add==owner)
 {
     emit Check("it send the ether on the owner address");
       payable(owner).transfer(msg.value);
 }
 else
 {
 add.transfer(msg.value);
 }
 //payable(owner).transfer(msg.value);

    }
function checkBal()public  check returns( uint )
    {
 return  ( address(owner).balance);
    }
}