//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721, Ownable {
    error MoodNft__CantFlip();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory _sadSvgImageUri,
        string memory _happySvgImageUri
    ) ERC721("IconArtMood NFT", "IAM") Ownable(msg.sender) {
        s_tokenCounter = 0;
        s_sadSvgImageUri = _sadSvgImageUri;
        s_happySvgImageUri = _happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood() public {
        if(!_isAuthorized(owner(),msg.sender, s_tokenCounter)){
            revert MoodNft__CantFlip();
        }
        if (s_tokenIdToMood[s_tokenCounter] == Mood.HAPPY) {
            s_tokenIdToMood[s_tokenCounter] = Mood.SAD;
        } else {
            s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[_tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                            abi.encodePacked(
                                '{"name":"',
                                name(), // You can add whatever name here
                                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function getMoodNftState() public view returns (Mood) {
        return  s_tokenIdToMood[s_tokenCounter];
    }
}
