// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract crowdfunding{
    mapping(address=>uint)public contributors;
    address public manager;
    uint public minimumcontribution;
    uint public deadline;
    uint public raisedAmount;
    uint public noOfContributors;
    uint public target;
    
    struct Request
    {string description;
    address payable recipient;
    uint value;
    bool completed;
    uint noOfVoters;
    mapping(address=>bool) voters;
    }
    mapping(uint=>Request)public requests;
    uint public numRequests;
    constructor(uint _target,uint _deadline)
    {
         target = _target;
   deadline=block.timestamp +_deadline;
   manager=msg.sender;
   minimumcontribution =100 wei;

    }
    function sendEth()public payable
    {require(block.timestamp<deadline,"deadline has passed");
    require(msg.value>=minimumcontribution,"minimum contribution is not enough");
    if(contributors[msg.sender]==0)
    {noOfContributors++;}
    contributors[msg.sender]+=msg.value;
    raisedAmount+=msg.value;}
    function getContractBalace()public view returns(uint)
    {
        return address (this).balance;

    }
    function refund()public 
    {
        require(block.timestamp>deadline&& raisedAmount<target,"you are not eligible");

require(contributors[msg.sender]>0,"you have not enough money");
 address payable  user=payable (msg.sender);
 user.transfer(contributors[msg.sender]);
 contributors[msg.sender]=0;    }
 modifier onlyManager ()
 {require(manager==msg.sender,"only manager can not call");
 _;}
 function createRequests(string memory _description,address payable  _recipient,uint _value)public onlyManager
 {
     Request storage newReq=requests[numRequests];
     numRequests++;

     newReq.description= _description;
     newReq.recipient=_recipient;
     newReq.value=_value;
     newReq.completed= false;
     newReq.noOfVoters =0;

 }
 function voterequest (uint _requersNo)public 
 {require(contributors[msg.sender]>0,"you must be contributor");
 Request storage thisReq=requests[_requersNo];
 require(thisReq.voters[msg.sender]==false,"you have already vote");
 thisReq.voters[msg.sender]=true;
 thisReq.noOfVoters++;}
 function makePayment(uint _reqno)public onlyManager
 { require(raisedAmount>=target);
     Request storage thisReq=requests[_reqno];
 require(thisReq.completed==false,"this req has ben completed");
 require(thisReq.noOfVoters> noOfContributors /2); 
 thisReq.recipient.transfer(thisReq.value);
 thisReq.completed=true;}
}
