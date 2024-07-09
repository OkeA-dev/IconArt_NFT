//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {IconArt} from "../src/IconArt.sol";

contract DeployIconArt is Script {
    function run() external returns (IconArt) {
        vm.startBroadcast();
        IconArt iconArt = new IconArt();
        vm.stopBroadcast();
        return iconArt;
    }
}