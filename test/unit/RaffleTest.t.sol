//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract RaffleTest is Test {
    /* Events */
    event EnteredRaffle(address indexed player);

    Raffle raffle;
    HelperConfig helperConfig;

    uint256 entranceFee;
    uint256 interval;
    address coordinator;
    bytes32 keyHash;
    uint64 subscriptionId;
    uint32 callbackGasLimit;
    address link;

    address public PLAYER = makeAddr("player");
    uint256 public constant VALUE = 10 ether;
    
    function setUp() external {
        DeployRaffle deployRaffle = new DeployRaffle();
        (raffle, helperConfig) = deployRaffle.run();
        ( entranceFee,
        interval,
         coordinator,
        keyHash,
        subscriptionId,
        callbackGasLimit,
        link) = helperConfig.activeNetworkConfig();
        vm.deal(PLAYER, VALUE);
    }

    function testRaffleInitializesInOpenState() public view {
        assert(raffle.getRaffleState() == Raffle.State.Open);
    }

    /**
     * @dev Enter Raffle Test
     */

    function testRaffleReversesWhenYouDoNotPayEnough() public {
        //arrange
        vm.prank(PLAYER); //pretending to be player
        //act / assert
        vm.expectRevert(Raffle.Raffle__NotEnoughEthToEnterRaffle.selector);
        raffle.enterRaffle();
        //assert
    }

    function testRaffleRecordsPlayerWhenTheyEnter() public {
        //arrange
        vm.prank(PLAYER); //pretending to be player
        //act 
        raffle.enterRaffle{value: 10 ether}();
        //assert
        assert(raffle.getNumberOfPlayers() == 1);
    }

    function testRaffleRecordsPlayerIsPlayerWhenTheyEnter() public {
        //arrange
        vm.prank(PLAYER);
         //pretending to be player
        //act
        raffle.enterRaffle{value: 10 ether}();
        address playerRecorded = raffle.getSpecificPlayer(0);
        //assert
        assert(playerRecorded == PLAYER);
    }

    function testEmitsEventOnEntrance() public {
        //arrange
        vm.prank(PLAYER); //pretending to be player
        vm.expectEmit(true, false, false,false, address(raffle));
        emit EnteredRaffle(PLAYER);
        //act 
        raffle.enterRaffle{value: 10 ether}();
        //assert
    }

    function testCantEnterWhenRaffleIsCalculating() public {
        //arrange
        vm.prank(PLAYER); //pretending to be player
        //act
        raffle.enterRaffle{value: 10 ether}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        raffle.performUpKeep("");
        //assert 
        vm.expectRevert(Raffle.Raffle__RaffleNotOpen.selector);
        vm.prank(PLAYER); //pretending to be player
        raffle.enterRaffle{value: 1 ether}();
    }


    function testCheckUpKeepReturnsFalseIfItHasNoBalance() public {
        //arrange
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        //act
        (bool upKeepNeeded, ) = raffle.checkUpKeep("");
        //assert
        assert(!upKeepNeeded);
    }

    function testCheckUpKeepReturnsTrueIfRaffleNotOpen() public {
        //arrnage
        vm.prank(PLAYER); //pretending to be player     
        raffle.enterRaffle{value: 1 ether}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1); 
        raffle.performUpKeep("");   

        //act
        (bool upKeepNeeded, ) = raffle.checkUpKeep("");
        //assert
        assert(upKeepNeeded == false);
    }


 




    }