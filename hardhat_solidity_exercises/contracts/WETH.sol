// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract WETH {
    address public owner;

    mapping(address => uint256) public balances;

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

    function withdraw(uint256 amount)
        external
        ValidMinValue(amount)
        ValidMaxValue(amount, balances[msg.sender])
        returns (uint256)
    {
        balances[msg.sender] -= amount;
        (bool status, ) = msg.sender.call{ value: amount }("");
        require(status, "the transaction failed");
        if (!status) {
            balances[msg.sender] += amount;
        }
        return balances[msg.sender];
    }

    function balanceOf(address _address) external view returns (uint256) {
        return balances[_address];
    }

    modifier ValidMinValue(uint256 value) {
        require(value > 0, "Enter a value greater than 0");
        _;
    }

    modifier ValidMaxValue(uint256 value, uint256 balance) {
        require(value <= balance, "Insufficient funds");
        _;
    }
}
