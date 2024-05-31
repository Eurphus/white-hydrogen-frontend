
$NETWORK = "testnet"

# Exit on error
$ErrorActionPreference = "Stop"

$SOROBAN_RPC_HOST = "https://soroban-testnet.stellar.org"
$SOROBAN_RPC_URL = $SOROBAN_RPC_HOST

$SOROBAN_NETWORK_PASSPHRASE = "Test SDF Network ; September 2015"

soroban keys generate hydro --network testnet

Write-Host "Using $NETWORK network"
Write-Host "  RPC URL: $SOROBAN_RPC_URL"

Write-Host "Add the $NETWORK network to cli client"
soroban network add `
  --global testnet `
  --rpc-url https://soroban-testnet.stellar.org:443 `
  --network-passphrase "Test SDF Network ; September 2015"

Write-Host "Add $NETWORK to .hydro-config for use with npm scripts"
New-Item -ItemType Directory -Force -Path .hydro-config
$NETWORK | Out-File -FilePath .hydro-config/network -Force
$SOROBAN_RPC_URL | Out-File -FilePath .hydro-config/rpc-url -Force
$SOROBAN_NETWORK_PASSPHRASE | Out-File -FilePath .hydro-config/passphrase -Force
@"
{ "network": "$NETWORK", "rpcUrl": "$SOROBAN_RPC_URL", "networkPassphrase": "$SOROBAN_NETWORK_PASSPHRASE" }
"@ | Out-File -FilePath .hydro-config/config.json -Force

if (-not (soroban config identity ls | Select-String -Pattern "token-admin")) {
    Write-Host "Create the token-admin identity"
    soroban config identity generate hydro --network testnet
}
$ABUNDANCE_ADMIN_ADDRESS = soroban config identity address hydro
Write-Host "ABUND: $ABUNDANCE_ADMIN_ADDRESS"

Write-Host "Build contracts"
& npm run build:contracts

Write-Host "Deploy the abundance token contract"
$ABUNDANCE_ID = & soroban contract deploy --network testnet --source hydro --wasm target/wasm32-unknown-unknown/release/abundance_token.wasm
Write-Host "Contract deployed successfully with ID: $ABUNDANCE_ID"
$ABUNDANCE_ID | Out-File -FilePath .hydro-config/abundance_token_id -Force

Write-Host "Deploy the crowdfund contract"
$CROWDFUND_ID = & soroban contract deploy --network testnet --source hydro --wasm target/wasm32-unknown-unknown/release/soroban_crowdfund_contract.wasm
Write-Host "Contract deployed successfully with ID: $CROWDFUND_ID"
$CROWDFUND_ID | Out-File -FilePath .hydro-config/crowdfund_id -Force

#Write-Host "Initialize the abundance token contract"
#& soroban contract invoke --network testnet --source hydro --id $ABUNDANCE_ID -- initialize --symbol ABND --decimal 7 --name abundance --admin $ABUNDANCE_ADMIN_ADDRESS

#Write-Host "Initialize the crowdfund contract"
#& soroban contract invoke ---network testnet --source hydro --id $CROWDFUND_ID -- initialize --recipient $ABUNDANCE_ADMIN_ADDRESS --deadline 1 --target_amount 10000000000 --token $ABUNDANCE_ID

Write-Host "Done"
# soroban contract invoke --source hydro --network testnet --id CASVQ32TZYNCMRQDOBZFYQM5WXAJB5XWXTXC5QPVOSCKAIH5K7ATN3PL -- initialize --recipient GB4XLZMHU7JLEGZ7WCSYBH6NC5IBH27KXQUSK627XFYNYSP3KT6PTSLU --deadline $deadline --target_amount 10000000000 --token CCIYWGRMQIA5BZVJBA5V7GC54U6R2TH7PVLESNJ3Z7XCNTUKX6MAL4NK