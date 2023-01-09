//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
contract Book{
    uint length;
    uint breadth;
    uint height;
    uint Hello;
    function setDia(uint _len,uint _bre, uint _hei)public
    {
        length=_len;
        breadth=_bre;
        height=_hei;
    }
    function getDia()public view returns(uint ,uint,uint)
    { return(length,breadth,height);
    }
    constructor (uint hi)
    { Hello= hi;

    }
}
contract otherBook{
    Book obj = new Book(5);// give the constructor parameter because it is parameterised
    function get()public view returns(uint,uint,uint)
    {return obj.getDia();
    }
    function set(uint len,uint bre,uint hei)public{
        obj.setDia(len,bre,hei);
    }
}