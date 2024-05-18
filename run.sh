#!/bin/bash

# Set the RPC endpoints
ETH_RPC_ENDPOINT="https://eth1.lava.build/lava-referer-d539f780-dd64-4b49-8417-8a54211bdff5/"
NEAR_RPC_ENDPOINT="https://near.lava.build/lava-referer-d539f780-dd64-4b49-8417-8a54211bdff5/"

# Define the wallet addresses
ETH_WALLETS=("" "0x31afD2Df9C514da21d8Ab2D7322A17B20f10EA03"  ""  "")
NEAR_WALLETS=("" )

# Function to get Ethereum balance
function get_eth_balance() {
    local wallet_address=$1
    local response=$(curl -H "Content-type: application/json" -X POST --data "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"$wallet_address\",\"latest\"],\"id\":1}" "$ETH_RPC_ENDPOINT")
    echo "$response"
}

# Function to get NEAR account balance
function get_near_balance() {
    local account_id=$1
    local response=$(curl -H "Content-type: application/json" -X POST --data "{\"jsonrpc\":\"2.0\",\"method\":\"query\",\"params\":{\"request_type\":\"view_account\",\"finality\":\"final\",\"account_id\":\"$account_id\"},\"id\":1}" "$NEAR_RPC_ENDPOINT")
    echo "$response"
}

# Function to get Ethereum block number
function get_eth_block_number() {
    local response=$(curl -H "Content-type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":3}' "$ETH_RPC_ENDPOINT")
    echo "$response"
}

# Function to get NEAR status
function get_near_status() {
    local response=$(curl -H "Content-type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"status","params":{},"id":2}' "$NEAR_RPC_ENDPOINT")
    echo "$response"
}

# Iterate over Ethereum wallets and get balances
ETH_BALANCES=()
for wallet in "${ETH_WALLETS[@]}"; do
    balance=$(get_eth_balance "$wallet")
    ETH_BALANCES+=("$balance")
done

# Iterate over NEAR wallets and get balances
NEAR_BALANCES=()
for wallet in "${NEAR_WALLETS[@]}"; do
    balance=$(get_near_balance "$wallet")
    NEAR_BALANCES+=("$balance")
done

# Get Ethereum block number
eth_block_number=$(get_eth_block_number)

# Get NEAR status
near_status=$(get_near_status)

# Combine all the data into a single object
data="{\"ethBalances\":$ETH_BALANCES,\"nearBalances\":$NEAR_BALANCES,\"ethBlockNumber\":$eth_block_number,\"nearStatus\":$near_status}"

# Write the data to the Update.tsx file
echo "$data" >> Update.tsx
echo "Check Update.tsx."
