# Deployment

```soroban config network add \
  --rpc-url https://soroban-testnet.stellar.org \
  --network-passphrase "Test SDF Network ; September 2015" testnet 
```

```soroban config identity generate token-admin --network testnet 
```

  Save ID via

```
  soroban config identity address token-admin 
```

```
soroban contract deploy --network testnet --source token-admin \
    --wasm target/wasm32-unknown-unknown/release/abundance_token.wasm 
```

```
soroban contract deploy --network testnet --source token-admin \
    --wasm target/wasm32-unknown-unknown/release/soroban_crowdfund_contract.wasm
)
```