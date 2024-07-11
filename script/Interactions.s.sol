//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {IconArt} from "../src/IconArt.sol";

contract MintIconArt is Script {
    string public  constant DOG_ART = "ipfs://bafybeifzvwqczffvwsjwmmtvnqhfj35ovtwe2m24k27stuii7sqiv74x6y/1771.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "IconArt",
            block.chainid
        );  
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        IconArt(contractAddress)._mint(DOG_ART);
        vm.stopBroadcast();
    }
}
// ipfs://bafybeifzvwqczffvwsjwmmtvnqhfj35ovtwe2m24k27stuii7sqiv74x6y/1771.json