package com.worldline.helioswallet

data class CreateWalletResponse(
    val mnemonic: String,
)

data class WalletCredentials(
    val address: String,
    val privateKey: String
)