//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Auction
{ 
 address payable public auctioneer;
 uint public stblock;//start time;
 uint public etblock;//end time;
 enum Auct_state{ stated,running,ended,cancelled} 
Auct_state public auctionstate;
uint public highest_payable_bid;
uint  public bid_inc;
address  payable public  highest_bidder;
mapping(address=>uint )public bids;
constructor(){
 auctioneer = payable( msg.sender);
 auctionstate = Auct_state.running;
 stblock=block.number;
 etblock=stblock+240;
 bid_inc=1 ether;
}
function min(uint a,uint b)private  pure returns(uint)
{
if(a<=b)
return a;
else 
return b;
}
modifier notowner(){
    require(msg.sender != auctioneer,"owner cannot bid");
 _;
 }
 modifier owner(){
    require(msg.sender == auctioneer,"owner cannot bid");
 _;
 }
 
 modifier started(){
    require(block.number>stblock);
 _;
 }
 modifier beforeending(){
    require(block.number<etblock);
 _;
 }
 function Auctcancel()public  owner{
 auctionstate=Auct_state.cancelled;
 }
 function endauction()public  owner{
auctionstate=Auct_state.ended;
 }
function bid()payable public owner started beforeending{
 require (auctionstate ==Auct_state.running);
require(msg.value>1 ether);
uint currentBid=bids[msg.sender]+msg.value;
require(currentBid>highest_payable_bid);
bids[msg.sender]=currentBid;
if(currentBid<bids[highest_bidder])
{
   highest_payable_bid=min(currentBid+bid_inc,bids[highest_bidder]);
}
else {highest_payable_bid=min(currentBid,bids[highest_bidder]+bid_inc);
highest_bidder=payable (msg.sender);
}
}
function finalizeAuc()public 
{
   require(auctionstate==Auct_state.cancelled||auctionstate==Auct_state.ended|| block.number>etblock);
   require(msg.sender==auctioneer|| bids[msg.sender]>0);
   address payable person;
   uint value;
   if(Auct_state.cancelled==auctionstate)
   {person =payable(msg.sender);
   value=bids[msg.sender];
   }
  if(auctionstate == Auct_state.cancelled)
{person=payable (msg.sender);
value=bids[msg.sender];
}
   else 
   {
   if(msg.sender==auctioneer)
   {person=auctioneer;
   value=highest_payable_bid;
   }
   else  if(msg.sender==highest_bidder)
   {person=highest_bidder;
   value=bids[highest_bidder]-highest_payable_bid;
   }
   else {
      person = payable(msg.sender);
      value=bids[msg.sender];

   }
  }
  bids[msg.sender]=0;
  person.transfer(value);

}
}

