// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {TransferHelper} from "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";

contract DefaultPayment {
    ISwapRouter public constant swapRouter =
        ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564); //confirm for arbiscan
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant USDT = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address public constant tokenToBurn =
        0xa78d8321B20c4Ef90eCd72f2588AA985A4BDb684;
    uint256 public constant BURNPERCENTAGE = 50000; // 5% in PPM
    uint256 public constant PPM = 1000000;
    uint24 public constant poolFee = 10000; // 0.3% fee

    event Amount(uint256 amount);

    //this function will burn the 5% of the payment and send the rest to the reciever wallet
    function sendPayment(address recieveAddress, uint256 amount) external {
        uint256 burnableAmount = (amount * BURNPERCENTAGE) / PPM;
        uint256 transferAmount = amount - burnableAmount;

        // Transfer GEMS from user to this contract
        TransferHelper.safeTransferFrom(
            USDT,
            msg.sender,
            address(this),
            burnableAmount
        );

        TransferHelper.safeTransferFrom(
            USDT,
            msg.sender,
            recieveAddress,
            transferAmount
        );

        // Approve Uniswap router to spend USDT
        TransferHelper.safeApprove(USDT, address(swapRouter), burnableAmount);

        // Swap USDT for tokenToBurn
        ISwapRouter.ExactInputParams memory params = ISwapRouter
            .ExactInputParams({
                path: abi.encodePacked(USDT, poolFee, tokenToBurn),
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: burnableAmount,
                amountOutMinimum: 0
            });

        // Execute the swap
        uint256 amountOut = swapRouter.exactInput(params);

        // Burn the received tokens
        ERC20Burnable(tokenToBurn).burn(amountOut);
    }
}
