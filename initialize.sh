#!/bin/bash

set -e

NETWORK="testnet"
SOROBAN_RPC_HOST="https://soroban-testnet.stellar.org:443"
SOROBAN_RPC_URL=$SOROBAN_RPC_HOST
SOROBAN_NETWORK_PASSPHRASE="Test SDF Network ; September 2015"
USER="hydro-admin"



echo "Using $NETWORK network"
echo "  RPC URL: $SOROBAN_RPC_URL"

echo Add the $NETWORK network to cli client
soroban network add --global testnet --rpc-url $SOROBAN_RPC_HOST --network-passphrase "$SOROBAN_NETWORK_PASSPHRASE"
soroban keys generate $USER --network testnet

echo Add $NETWORK to .hydro-config for use with npm scripts
mkdir -p .hydro-config
echo $NETWORK >./.hydro-config/network
echo $SOROBAN_RPC_URL >./.hydro-config/rpc-url
echo "$SOROBAN_NETWORK_PASSPHRASE" >./.hydro-config/passphrase

soroban config identity generate $USER --network $NETWORK
ABUNDANCE_ADMIN_ADDRESS="$(soroban config identity address $USER)"
echo -n "$ABUNDANCE_ADMIN_ADDRESS" >.hydro-config/abundance_admin_address

ARGS="--network testnet --source $USER"

echo Build contracts
make build

echo Deploy the abundance token contract
ABUNDANCE_ID="$(
  soroban contract deploy $ARGS \
    --wasm target/wasm32-unknown-unknown/release/abundance_token.wasm
)"
echo "Contract deployed succesfully with ID: $ABUNDANCE_ID"
echo -n "$ABUNDANCE_ID" >.hydro-config/abundance_token_id

echo Deploy the crowdfund contract
CROWDFUND_ID="$(
  soroban contract deploy $ARGS \
    --wasm target/wasm32-unknown-unknown/release/soroban_crowdfund_contract.wasm
)"
echo "Contract deployed succesfully with ID: $CROWDFUND_ID"
echo "$CROWDFUND_ID" >.hydro-config/crowdfund_id

# echo "Initialize the abundance token contract"
# soroban contract invoke \
#   $ARGS \
#   --id "$ABUNDANCE_ID" \
#   -- \
#   initialize \
#   --symbol ABND \
#   --decimal 7 \
#   --name abundance \
#   --admin "$ABUNDANCE_ADMIN_ADDRESS"

# echo "Initialize the crowdfund contract"
# deadline="$(($(date +"%s") + 86400))"
# soroban contract invoke \
#   $ARGS \
#   --id "$CROWDFUND_ID" \
#   -- \
#   initialize \
#   --recipient "$ABUNDANCE_ADMIN_ADDRESS" \
#   --deadline "$deadline" \
#   --target_amount "10000000000" \
#   --token "$ABUNDANCE_ID"
echo "Done"
