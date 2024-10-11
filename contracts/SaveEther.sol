// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract SaveEther{
    address public owner;

    struct UserAccount{
        uint256 amount;
        uint256 duration;
    }

    mapping (address user => UserAccount) userInfo;

    event Transfer(address indexed user, uint256 amount);

    constructor(){
        owner = msg.sender;
    }

    function onlyOwner()private view{
        require(msg.sender == owner, "User not allowed");
    }

    function depositEther(uint32 _duration) public payable {
        require(msg.sender != address(0), "not permitted");
        require(msg.value >= 1 ether, "amount is too small");

        UserAccount memory useracct;
        useracct.amount =  msg.value;

        useracct.duration = block.timestamp + _duration;

        userInfo[msg.sender] = useracct;
    }

    function withdrawEther() public {
        require(msg.sender != address(0), "not permitted");

        UserAccount storage useracct = userInfo[msg.sender];

        require(useracct.amount >= 1 ether, "Balance is not enough");
        require(block.timestamp > useracct.duration, "Not yet due");

        uint256 bal = useracct.amount;

        useracct.amount = 0;
        useracct.duration = 0;

        (bool sent,) = payable(msg.sender).call{value: bal}("");

        if (sent) {
            emit Transfer(msg.sender, bal);
        }
    }

    
    function getContractBalance()public view returns(uint256){
        onlyOwner();
        return  address(this).balance;
    }

    function getDepositInfo() public view returns (uint256, uint256){
        UserAccount storage userAcct = userInfo[msg.sender];

        return(userAcct.amount, userAcct.duration);
    }
}