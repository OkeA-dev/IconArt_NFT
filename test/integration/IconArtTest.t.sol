//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployIconArt} from "../../script/DeployIconArt.s.sol";
import {IconArt} from "../../src/IconArt.sol";
import {IERC721Errors} from "lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol";

contract TestIconArt is Test {
    string public constant DOG_ART =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    address public USER = makeAddr("user");
    address public ALICE = makeAddr("Alice");
    address public BOB = makeAddr("Bob");
    address public ZERO_ADDRESS = address(0);
    uint256 public tokenId = 0;

    DeployIconArt deployIconArt;
    IconArt iconArt;

    modifier userMint(){
        vm.prank(USER);
        iconArt._mint(DOG_ART);
        _;
    }

    function setUp() public {
        deployIconArt = new DeployIconArt();
        iconArt = deployIconArt.run();
    }

    function testNameIsCorrect() public view {
        string memory expectName = "IconArt";
        string memory actualName = iconArt.name();
        // assertEq(actualName, expectName);
        assert(
            keccak256(abi.encodePacked(expectName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveABalance() public userMint {

        vm.prank(ZERO_ADDRESS);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC721Errors.ERC721InvalidReceiver.selector,
                address(0)
            )
        );
        iconArt._mint(DOG_ART);

        assertEq(iconArt.balanceOf(USER), 1);
        assert(
            keccak256(abi.encodePacked(DOG_ART)) ==
                keccak256(abi.encodePacked(iconArt.tokenURI(0)))
        );
    }

    function testCanTransferAmongUsers() public userMint{
        vm.prank(USER);
        iconArt.transferFrom(USER, BOB, tokenId);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC721Errors.ERC721InvalidReceiver.selector,
                ZERO_ADDRESS
            )
        );
        iconArt.transferFrom(USER, ZERO_ADDRESS, tokenId);

        // vm.expectRevert(
        //     abi.encodeWithSelector(
        //         IERC721Errors.ERC721IncorrectOwner.selector,
        //         ALICE,
        //         tokenId,
        //         USER
        //     )
        // );
        // iconArt.transferFrom(ALICE, BOB, tokenId);

        assertEq(iconArt.balanceOf(USER), 0);
        assertEq(iconArt.balanceOf(BOB), 1);
    }

    function testApprovalToTransferToken() public userMint{
        vm.startPrank(USER);
        iconArt.approve(BOB, tokenId);

        address approvedAddress = iconArt.getApproved(tokenId);
        vm.stopPrank();

        console.log("The User balance: ", iconArt.balanceOf(USER));
        console.log("The Bob balance: ", iconArt.balanceOf(BOB));
        console.log("The Approved address: ", approvedAddress);
        console.log("The Bob address: ", BOB);

        assertEq(approvedAddress, BOB);
    }

    function testTransferApprovedToken() public userMint {
        vm.startPrank(USER);
        iconArt.approve(BOB, tokenId);
        vm.stopPrank();

        vm.prank(BOB);
        iconArt.transferFrom(USER, BOB, tokenId);

        assertEq(iconArt.balanceOf(BOB), 1);
        assertEq(iconArt.balanceOf(USER), 0);
    }

    function testRevokingUnapprovedAddress() public userMint {

        vm.prank(BOB);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC721Errors.ERC721InsufficientApproval.selector,
                BOB,
                tokenId
            )
        );
        iconArt.transferFrom(USER, BOB, tokenId);
    }
}
