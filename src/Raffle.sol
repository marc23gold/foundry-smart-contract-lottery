//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

/**
 * @title Raffle contract
 * @author Marcxime Prosper
 * @notice This contract is used to create a raffle
 * @dev Implements Chainlink VRFv2 for random number generation
 */


contract Raffle {
    uint256 private immutable i_entranceFee;
    //what are some functions we need?
    //1. buy tickets
    //2. pick winner
    //3. get balance

    //Constructor
    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {

    }

    function pickWinner() public {

    }

    //View/Pure Getter Functions

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}