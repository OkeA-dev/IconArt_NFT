//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    MoodNft moodNft;

    function run() external {}

    function svgToImageUri(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encode = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(svg)
                )
            )
        );
        return
            string(
                abi.encodePacked(
                    baseURI,
                    svgBase64Encode
                )
            );
    }
}
