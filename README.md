<<<<<<< HEAD
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
=======
# React App

Hosted by Heroku

Accessible by whitehydrogen.club

See https://github.com/vandenhaak/whitehydrogen
>>>>>>> a7d8c418296b63ec697efeb8fbaf51064641d273
