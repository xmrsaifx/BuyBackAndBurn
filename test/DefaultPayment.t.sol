// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DefaultPayment} from "../src/DefaultPayment.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DefaultPaymentTest is Test {
    DefaultPayment public defaultPaymentContract;
    address burnerAddress;
    address receiveAddress;
    address senderAddress = 0x25681Ab599B4E2CEea31F8B498052c53FC2D74db;
    address usdtAddress = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address tokenToBurnAddress = 0xa78d8321B20c4Ef90eCd72f2588AA985A4BDb684;

    function setUp() public {
        receiveAddress = makeAddr("receiveAddress");
        defaultPaymentContract = new DefaultPayment();
    }

    function testBuyBackAndBurn() public {
        vm.startPrank(senderAddress);
        uint256 amount = 1000000000; // 1000 USDT
        uint256 amountToRecieve = (amount * (1000000 - 50000)) / 1000000; // 950 USDT
        uint256 supplyBefore = IERC20(tokenToBurnAddress).totalSupply();
        IERC20(usdtAddress).approve(address(defaultPaymentContract), amount);
        defaultPaymentContract.sendPayment(receiveAddress, amount);
        assertLe(IERC20(tokenToBurnAddress).totalSupply(), supplyBefore);
        assertEq(
            IERC20(usdtAddress).balanceOf(receiveAddress),
            amountToRecieve
        );
        vm.stopPrank();
    }
}
