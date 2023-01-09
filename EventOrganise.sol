// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract EventContract
{ struct Event{
   address organiser;
   string name;
   uint date;
   uint price;
   uint ticketcount;
   uint ticketremain; 
}
mapping(uint=>Event)public events;
mapping(address=>mapping(uint=>uint))public tickets;
uint public nextid;
function createEvent(string memory name,uint date,uint price,uint ticketcount)external 
{
    require(date >block.timestamp,"you can organize event for future date");
    require(ticketcount>0,"you can organize event only if you create more than ticket");
    events[nextid]=Event(msg.sender,name,date,price,ticketcount,ticketcount);
    nextid++;
}

uint  public hi = msg.value;
function buyticket(uint id, uint quantity )external payable 
{ require( events[id].date >block.timestamp,"you can organize event for future date");
  require( events[id].date!= 0,"events does not exist");
 Event storage _event=events[id];
 
 require(msg.value >= (_event.price*quantity),"ether is not enough");
 _event.ticketremain-=quantity;
 tickets[msg.sender][id]+=quantity;
}
function transferticket(uint id,uint quantity,address to)external 
{require(events[id].date!=0,"event");
require(events[id].date>block.timestamp,"event is already occured");
require(tickets[msg.sender][id]>=quantity,"dont have enough money");
tickets[msg.sender][id]-=quantity;
tickets[to][id]+=quantity;}

}