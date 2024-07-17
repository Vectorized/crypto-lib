# SmoothCryptoLib (SCL)
A Cryptographic Library for Smooth Blockchain uses.


## Compilation

Clone the repository, then type `forge test`. (Some troubles are solved running `foundryup` and `forge init --force`)

## Deployment

Run deploy.sh to deploy the code on a target chain. 
The values `$RPC` and `$CHAINID` shall be set to the chain ones. 
The toy private and public key shall be replaced and funded (current can be used for testnet). 



## Benchmarks


### Forge results

The benchmarks are performed by averaging forge results over a loop of 100 tests. Be sure to avoid the use of -via-IR and set foundry.toml correctly to reproduce correct measurements.

| curve | Function  | gas | Comment | File| 
|--------:|---------|:--:|:----|:----|
| P256 | SCL_ECDSAB4.verify   | 159K  | ECDSA using RIP7696 (second opcode)  | libSCL_ECDSAb4.sol |
||         |  |         ||



### Onchain results


| PR # | Create2 | Mainnets | Testnets |
|--------:|---------|:--:|:----|
|[N/A](https://github.com/rdubois-crypto/FreshCryptoLib/pull/46)| 0x05eFAC4C53Ec12F11f144d0a0D18Df6dfDf83409    | |  [Sepolia](https://sepolia.etherscan.io/address/0x05eFAC4C53Ec12F11f144d0a0D18Df6dfDf83409#code) ,[Optimism](https://sepolia.etherscan.io/address/0x05eFAC4C53Ec12F11f144d0a0D18Df6dfDf83409#code) |  
||         |  |         |



# Audits 

The results of the completed audits are in the doc/audit folder.


| Team    | branch  | Target |status |
|--------:|---------|:---------|:--:|
| CryptoExperts | CryptoExperts  |P256 | Integration of observations in progress |
| Veridise | Veridise  |P256 | Auditor analysis In Progress |


# Curves implementation status



| curve | status  | branch | Comment | File| 
|--------:|---------|:--:|:----|:----|
| P256 | OK   | main  | ECDSA using RIP7696 (first opcode)  | libSCL_7212.sol |
| P256 | OK   | main  | ECDSA using RIP7696 (second opcode)  | libSCL_ECDSAb4.sol |
| Ed25519|     OK    | main | EDDSA using RIP7696 (first opcode) with isogenies |    libSCL_RIP6565.sol     ||

# Acknowledments

The following work has been half-funded by the Ethereum Fundation grant number FY24-1386:
 * ed25519 solidity (libSCL_RIP6565.sol )

SCL is build by the same team of the previous FCL. As such all previous contributors are credited.

# Our work in Production

Prior to SCL implementation, our experimental library FCL is still in production in various environments:

* Base Smart Wallet: fast onboarding using FCL: https://www.smart-wallet.xyz/, deployed at 0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a (Base main and Sepolia)
* Cometh Connect: https://github.com/cometh-hq/p256-signer/blob/79d58bc619109a069e212d54a18744d3803731bc/contracts/P256Signer.sol
* Metamask Delegation Toolkit https://github.com/MetaMask/delegation-framework/blob/635f717372f58a2b338964ba8e3de4ad285c9a47/src/libraries/P256FCLVerifierLib.sol
* Safe : https://github.com/safe-global/safe-modules/tree/main/modules/passkey/contracts/vendor/FCL


## License 
License: This software is licensed under MIT License (see LICENSE FILE at root directory of project).
