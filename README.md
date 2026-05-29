# Decentralised Fundraiser

This is a small Remix + Sepolia crowdfunding project. Donors send ETH to a campaign goal. If the campaign reaches the goal, the owner can withdraw once. If the deadline passes without reaching the goal, each donor can claim a refund.

## Files

- `contracts/Fundraiser.sol` - Solidity smart contract.
- `frontend/fundraiser-dapp.html` - simple ethers.js frontend.
- `task.txt` - original assignment text.

## Contract details

The contract uses Solidity `^0.8.10` and has no OpenZeppelin imports.

Public values used by the frontend:

- `title`
- `description`
- `goal`
- `deadline`
- `totalRaised`
- `withdrawn`
- `owner`
- `donations(address)`

Main functions:

- `donate() payable`
- `withdraw()`
- `refund()`
- `getStatus()`

`withdraw()` and `refund()` update contract state before sending ETH, following Checks-Effects-Interactions.

## Deploy in Remix

1. Open Remix and create `Fundraiser.sol` with the code from `contracts/Fundraiser.sol`.
2. Compile with Solidity `0.8.10` or higher.
3. For a quick local test, deploy in Remix VM with:
   - `_title`: `Test Campaign`
   - `_description`: `Testing`
   - `_goalInWei`: `10000000000000000`
   - `_durationSeconds`: `3600`
4. To deploy on Sepolia, switch Remix to `Injected Provider - MetaMask` and make sure MetaMask is on Sepolia.
5. Deploy with the assignment values:
   - `_title`: `My Fundraiser`
   - `_description`: `Building a blockchain lab`
   - `_goalInWei`: `10000000000000000`
   - `_durationSeconds`: `3600`
6. Copy the deployed contract address.

## Frontend setup

1. Open `frontend/fundraiser-dapp.html` in a text editor.
2. Replace this line with your real Sepolia contract address:

```js
const CONTRACT_ADDRESS = "0xYOUR_FUNDRAISER_CONTRACT_ADDRESS";
```

3. Open the HTML file in a browser with MetaMask installed.
4. Connect MetaMask on Sepolia.
5. Donate, claim a refund after a failed campaign, or withdraw as the owner after the goal is reached.

## Testing the refund path

For a faster refund test, deploy a new contract with `_durationSeconds` set to `60`, donate less than the goal, wait 60 seconds, then click `Claim Refund` in the frontend.
