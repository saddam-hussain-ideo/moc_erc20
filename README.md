## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

## Deployments
Use Foundry’s forge script command to deploy the contract:
```shell
# Load env in you terminal session 
$ export $(grep -v '^#' .env | xargs)

# Deploy Script
$ forge script script/DeployTokens.s.sol:DeployTokens --rpc-url <NETWORK_RPC> --broadcast
```
## Verification
Use Ether scan or a similar service to verify the contract code:
```shell
# Load env in you terminal session 
$ export $(grep -v '^#' .env | xargs)

# Verify Contract
$ forge verify-contract --chain base-sepolia --compiler-version v0.8.20 --etherscan-api-key $ETHERSCAN_API_KEY <CONTRACT_ADDRESS> src/MockERC20.sol:MockERC20 --constructor-args $(cast abi-encode "constructor(string,string,uint8)" "Deca USD" "DUSDC" 6)

```
