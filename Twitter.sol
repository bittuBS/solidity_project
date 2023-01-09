//SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;
contract Twitter{
    struct Tweet
    {
        uint id;
        address author;
        string content;
        uint createdAt;
    }
    struct Message{
        uint id;
        string content;
        address from;
        address to;
        uint createAt;
    }
    mapping (uint =>Tweet)public tweets;
    mapping(address=>uint[])public tweetsOf;
    mapping(address=>Message[])public conversation;
    mapping(address=>mapping(address=>bool))public operators;
    mapping(address=>address[])public following;
    uint nextId;
    uint nextMessageId;
    function _tweet(address _from,string memory _content) internal
    { require(msg.sender== _from || operators[_from][msg.sender]==true ,"not allowed");
        tweets[nextId]=Tweet(nextId,_from,_content,block.timestamp);
    tweetsOf[_from].push(nextId);
    nextId++;
    }
    function _sendMessage(address _from, address _to,string memory _content ) internal
    {
        conversation[_from].push(Message(nextMessageId,_content,_from,_to,block.timestamp));
    nextMessageId++;}
    function tweet(string memory _content)public
    {_tweet(msg.sender,_content);
    }
    function tweet(address _from,string memory _content)public
    {_tweet(_from,_content);
    }
    
    function sendMessage(address _to,string memory _content)public{
        _sendMessage(msg.sender,_to,_content);
    }
     function sendMessage(address _from,address _to,string memory _content)public
     {
        _sendMessage(_from,_to,_content);
    }
    function allow(address _operator)public
    {operators[msg.sender][_operator]=true;}
function diallow(address _operator)public
    {operators[msg.sender][_operator]=false;}
    function follow(address _followed)public
    {following[msg.sender].push(_followed);
    }
    function getLatestTweets(uint count)public view returns(Tweet[] memory)
    {
        require(count>0 && count<= nextId,"count is not proper");
        Tweet[]memory _tweets = new Tweet[](count);
        uint j;
        for(uint i= nextId-count;i<nextId;i++)
        { Tweet storage _structure = tweets[i];
        _tweets[j] = Tweet( _structure.id, 
        _structure.author,
         _structure.content, 
         _structure.createdAt);
        j++;}
        return _tweets;
    }
    function getLatestOfUser(address _user, uint count)public view returns(Tweet[]memory)
    { Tweet[] memory _tweets= new Tweet[](count);
        require(count>0&&count<=nextId,"count is not defined");
        uint j;
      uint []memory ids  =tweetsOf[_user];
for(uint i=tweetsOf[_user].length -count;i<tweetsOf[_user].length;i++)
{
    Tweet storage _structure = tweets[ids[i]];
        _tweets[j] = Tweet( _structure.id, 
        _structure.author,
         _structure.content, 
         _structure.createdAt);
        j++;}
        return _tweets;
 }
    }


        