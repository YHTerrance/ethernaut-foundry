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

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```


### Utils

```shell
export $(cat .env | xargs)
```

### Past executions

```shell
# Level 27
forge script ./script/Level27-GoodSamaritan.s.sol --tc GoodSamaritanScript --private-key $PKEY --broadcast --rpc-url $SEPOLIA_RPC_URL -vvvv
# Level 28
forge script ./script/Level28-GatekeeperThree.s.sol --tc GatekeeperThreeScript --private-key $PKEY --broadcast --rpc-url $SEPOLIA_RPC_URL -vvvv
# Level 29
forge script ./script/Level29-Switch.s.sol  --private-key $PKEY --broadcast --rpc-url $SEPOLIA_RPC_URL -vvvv
```
