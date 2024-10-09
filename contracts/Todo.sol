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

    modifier validAddress(){
        require(msg.sender != address(0), "Zero address not allowed");
        _;
    }

    event TodoCreated(string title, Status status);

    function createTodo(string memory _title, string memory _desc) external onlyOwner  validAddress returns(bool){

        Todo memory mytodo;

        mytodo.title = _title;

        mytodo.description = _desc;

        mytodo.status = Status.Created;

        todos.push(mytodo);

        emit TodoCreated(_title, Status.Created);

        return true;

    }


    function updateTodo(uint _index, string memory _title, string memory _desc) external onlyOwner validAddress {
        require(_index < todos.length, "Index is out of bound");

        Todo storage mytodo = todos[_index];
        mytodo.title = _title;
        mytodo.description = _desc;
    }
}