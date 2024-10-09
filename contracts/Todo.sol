// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract TodoList{

    address public owner;

    enum Status {None, Created, Edited, Done}

    struct Todo{
        string title;
        string description;
        Status status;
    }

    Todo[] public todos;

    constructor(){
        owner = msg.sender;    
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You're not allowed");
        _;
    }
}