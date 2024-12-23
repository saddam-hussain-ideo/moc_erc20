// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../src/MockERC20.sol";

contract MockERC20Test is Test {
    MockERC20 internal token;
    address internal alice = address(0x1);
    address internal bob = address(0x2);

    function setUp() public {
        token = new MockERC20("MyToken", "MTK", 18);
    }

    // Marked "view" to remove the warning
    function testConstructor() public view {
        // Check name, symbol, decimals
        assertEq(token.name(), "MyToken");
        assertEq(token.symbol(), "MTK");
        assertEq(token.decimals(), 18);

        // Initial total supply should be 0
        assertEq(token.totalSupply(), 0);
    }

    function testMint() public {
        // Mint tokens to Alice
        uint256 mintAmount = 1000 ether;
        token.mint(alice, mintAmount);

        assertEq(token.balanceOf(alice), mintAmount);
        assertEq(token.totalSupply(), mintAmount);
    }

    function testMintFromNonOwner() public {
        vm.startPrank(bob);
        token.mint(bob, 1234 ether);
        assertEq(token.balanceOf(bob), 1234 ether);
        vm.stopPrank();
    }
}
