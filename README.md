## BuyBackAndBurn Contract on Arbitrum

**This smart contract automates the Buyback and Burn mechanism using Uniswap V3 on the Arbitrum blockchain.**  
When users make payments in USDT, a portion is used to buy a specified token on Uniswap, which is then burned, reducing its total supply. The remaining amount is transferred to the intended recipient.

---

## Features

- **🔁 Buyback:** Uses Uniswap V3 to swap USDT to the target token.
- **🔥 Burn Mechanism:** Burns 5% of every payment in the target token.
- **📤 Payment Forwarding:** Sends the remaining 95% to the recipient.
- **💼 Mainnet-Ready:** Deployable and tested on Arbitrum One.

---

## Technologies Used

- **Solidity** `0.8.20`
- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [Uniswap V3 Periphery](https://github.com/Uniswap/v3-periphery)
- **Foundry** for testing

---

## Contract Overview

```solidity
address public constant USDT = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
address public constant tokenToBurn = 0xa78d8321B20c4Ef90eCd72f2588AA985A4BDb684;
```

- **BURNPERCENTAGE:** 5% (denoted as 50000 PPM)
- **Swap Path:** USDT → tokenToBurn
- **Router Address:** `0xE592427A0AEce92De3Edee1F18E0157C05861564` (Uniswap V3 Swap Router)

---

## Functionality

### `sendPayment(address receiveAddress, uint256 amount)`

- Accepts USDT from the user.
- Swaps 5% of it for `tokenToBurn` via Uniswap.
- Burns the purchased `tokenToBurn` tokens.
- Sends the remaining 95% to the recipient.

---

## Test Case (Using Foundry)

The test simulates a scenario where:
- A user sends 1000 USDT.
- 950 USDT is transferred to the recipient.
- 50 USDT is used to buy and burn the target token.

```solidity
function testBuyBackAndBurn() public {
    ...
    defaultPaymentContract.sendPayment(receiveAddress, amount);
    ...
    assertLe(IERC20(tokenToBurnAddress).totalSupply(), supplyBefore);
    assertEq(IERC20(usdtAddress).balanceOf(receiveAddress), amountToRecieve);
}
```

---

## Installation & Testing

```bash
git clone https://github.com/your-username/buyback-and-burn-arbitrum.git
cd buyback-and-burn-arbitrum
forge install
forge test
```

---

## Deployment (Arbitrum One)

Make sure you verify the following addresses before deploying:

| Component            | Address                                               |
|----------------------|--------------------------------------------------------|
| **Uniswap V3 Router** | `0xE592427A0AEce92De3Edee1F18E0157C05861564`           |
| **USDT (Arbitrum)**   | `0xaf88d065e77c8cC2239327C5EDb3A432268e5831`           |
| **Token to Burn**     | `0xa78d8321B20c4Ef90eCd72f2588AA985A4BDb684` (example) |

---

## License

This project is licensed under the [MIT License](./LICENSE).

---

## Author

**Saif**  
Feel free to reach out or contribute! PRs are welcome.

---

