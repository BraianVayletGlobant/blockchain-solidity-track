// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// Create a contract that has three functions:
// 1. a receive function.
// 2. a custom payable function named deposit.
// 3. a withdraw function that receives an amount, and transfer that amount to the caller. named withdraw.
// 4. a function to check how much an address still has available, the address is received as a parameter. named balanceOf.

// The contract should track how much each address deposited and allow said address to extract just a much as the address deposited (not more than that).
// The last function should always return the amount deposited by the address minus the amount that was withdrawn.

// The contract should be named "Weth"

contract Weth {

    address owner;    
    mapping(address => uint) balances; 

    constructor() {
        owner = msg.sender;
    }

    receive() external payable ValidMinValue(msg.value) {
        balances[msg.sender] += msg.value;
    }

    fallback() external payable ValidMinValue(msg.value) {
        balances[msg.sender] += msg.value;
    }

    function deposit() external payable ValidMinValue(msg.value) {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) external ValidMinValue(amount) ValidMaxValue(amount, balances[msg.sender]) returns(uint) {        
        balances[msg.sender] -= amount;
        (bool status, ) = msg.sender.call{value: amount}("");
        require(status, "the transaction failed");
        if (!status) {
            balances[msg.sender] += amount;
        }
        return balances[msg.sender];
    } 

    function balanceOf(address _address) external view returns(uint) {
        return balances[_address];
    }

    modifier ValidMinValue(uint value) {
        require(value > 0, "Enter a value greater than 0");
        _;
    }

    modifier ValidMaxValue(uint value, uint balance) {
        require(value <= balance, "Insufficient funds");
        _;
    }
}