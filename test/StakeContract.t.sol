// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/StakeContract.sol";
import "./mocks/MockERC20.sol";

contract CounterTest is Test {
    StakeContract public stakeContract;
    MockERC20 public mockToken;

    address A = address(0x1);

    function setUp() public {
        stakeContract = new StakeContract();
        mockToken = new MockERC20();
    }

    function testStaking() public {
        uint amount = 10e18;
        mockToken.mint(A, amount);

        emit log_named_uint(
            "the balance of A before staking is ",
            mockToken.balanceOf(A)
        );

        vm.startPrank(A); // A is calling function

        mockToken.approve(address(stakeContract), amount);
        bool stakePassed = stakeContract.stake(amount, address(mockToken));
        assertTrue(stakePassed);
        assertEq(stakeContract.s_balances(A), 10e18);

        emit log_named_uint(
            "the balance of A after staking is ",
            mockToken.balanceOf(A)
        );
    }

    // this test will check for all the possible value of uint16 for amount
    function testStaking_fuzzling(uint16 amount) public {
        mockToken.mint(A, amount);

        vm.startPrank(A); // A is calling function

        mockToken.approve(address(stakeContract), amount);
        bool stakePassed = stakeContract.stake(amount, address(mockToken));
        assertTrue(stakePassed);
        assertEq(stakeContract.s_balances(A), amount);
    }
}
