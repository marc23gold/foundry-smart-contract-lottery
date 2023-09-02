//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";

contract CreateSubscription is Script{

    function createSubscriptionUsingConfig() public returns(uint64) {
        HelperConfig helperConfig = new HelperConfig();
         ( ,
         ,
        address coordinator,
         ,
         ,
         ,
         address link
         ) = helperConfig.activeNetworkConfig();
         return createSubscription(coordinator);
    }

    function createSubscription (address coordinator) public returns(uint64){
        console.log("Creating subscription on chain id: %s", block.chainid);
        vm.startBroadcast();
        uint64 subId = VRFCoordinatorV2Mock(coordinator).createSubscription();
        vm.stopBroadcast();
        console.log("Subscription id: %s", subId);
        console.log("Please update subscription id in HelperConfig.s.sol");
        return subId;
    }

    function run() external returns(uint64) {
        return createSubscriptionUsingConfig();
    }
    
}

contract FundSubscription is Script {
    uint96 public constant FUND_AMOUNT = 1 ether;

    function fundSubscriptionUsingConfig() public {
         HelperConfig helperConfig = new HelperConfig();
         ( ,
         ,
        address coordinator,
         ,
         uint64 subscriptionId
         ,
         ,
         address link 
         ) = helperConfig.activeNetworkConfig();
         
    }

    function fundSubscription(address coordinator, uint64 subscriptionId, address link) public {
        console.log("Funding subscription on chain id: %s", block.chainid);
        if(block.chainId == 31337) {
            vm.startBroadcast();
            VRFCoordinatorV2Mock(coordinator).fundSubscription(subscriptionId,FUND_AMOUNT, link);
            vm.stopBroadcast();
        } else {
            vm.startBroadcast();
            vm.stopBroadcast();     
        }
        vm.startBroadcast();
        Coordinator(coordinator).fundSubscription(subscriptionId, FUND_AMOUNT, link);
        vm.stopBroadcast();
        console.log("Funded subscription id: %s", subscriptionId);
    }

    function run() external {
        fundSubscriptionUsingConfig();
    }
}