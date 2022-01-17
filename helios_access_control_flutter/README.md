# helios_access_control_ui

Helios access control UI with flutter

## Getting Started

This is a Flutter sample project to test Helios Access Control library.

Inside this project, we can find the following flutter packages:

- access_control: Flutter package to get access to helios access control
- wallet: Flutter package to access to helios wallet

## Development configuration

To make it work, we need to use a backend and a smart contract.

To configure the backend endpoint and the smart contract, configure it in Constants file:

```kotlin
package com.accesscontrol

class Constants {
    companion object {
        const val NETWORK_ID = "5777"
        const val HELIOS_BLOCKCHAIN_ENDPOINT = "http://192.168.1.128:8545"
        const val HELIOS_ADDRESS = "0x1cc75b14F4e2de2F60a8150fc9A9994fA08ffc8e"

    }
}
```

NETWORK_ID: Network id from blockchain network
HELIOS_BLOCKCHAIN_ENDPOINT: blockchain endpoint for Web3j instance
HELIOS_ADDRESS: Smart contract address to be used


