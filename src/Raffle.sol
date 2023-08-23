//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;


/**
 * @title Raffle contract
 * @author Marcxime Prosper
 * @notice This contract is used to create a raffle
 * @dev Implements Chainlink VRFv2 for random number generation
 */

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";


contract Raffle {
    error Raffle__NotEnoughEthToEnterRaffle();
    error Raffle__NotEnoughTimePassed();

    //state variables
    uint256 private constant REQUEST_CONFIRMATIONS = 3;
    uint256 private constant NUMWORDS = 1; //number of random words to return

    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    /**@dev duration of the lottery in seconds */
    uint256 private immutable i_interval;
    uint256 private s_lastTimeStamp;
    address private immutable i_COORDINATOR;
    bytes32 private immutable i_keyHash;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    

    event EnteredRaffle(
        address indexed player
    );
    //what are some functions we need?
    //1. buy tickets
    //2. pick winner
    //3. get balance

    //Constructor
    constructor(uint256 entranceFee, uint256 interval, address coordinator, bytes32 keyHash, uint64 subscriptionId, uint32 callbackGasLimit) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_COORDINATOR = coordinator;
        i_keyHash = keyHash;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterRaffle() external payable {
        if(msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthToEnterRaffle();
        }
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }


    //get random number 
    //use random number to get a winner
    //be automatically called   
    function pickWinner() external {
        if((block.timestamp - s_lastTimeStamp) <= i_interval) {
            revert Raffle__NotEnoughTimePassed();
        }
        /**@dev get random number */
           uint256 requestId = i_COORDINATOR.requestRandomWords(
            i_keyHash,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUMWORDS
        );
    }

    //View/Pure Getter Functions

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}