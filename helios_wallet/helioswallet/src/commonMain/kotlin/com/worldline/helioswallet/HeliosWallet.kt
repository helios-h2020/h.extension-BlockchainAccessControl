package com.worldline.helioswallet

expect class HeliosWallet {
    fun createWallet(pass: String): CreateWalletResponse

    fun getWalletCredentials(pass: String, mnemonic: String): WalletCredentials
}