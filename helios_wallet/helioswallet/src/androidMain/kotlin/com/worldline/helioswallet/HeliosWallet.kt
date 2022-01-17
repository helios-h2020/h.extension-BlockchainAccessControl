package com.worldline.helioswallet

import org.web3j.crypto.MnemonicUtils
import org.web3j.crypto.WalletUtils
import java.security.SecureRandom
import java.io.File

actual class HeliosWallet(private val directory: String) {

    actual fun createWallet(pass: String): CreateWalletResponse {
        val initialEntropy: ByteArray = ByteArray(16)
        SecureRandom().nextBytes(initialEntropy)
        val mnemonic: String = MnemonicUtils.generateMnemonic(initialEntropy)

        return CreateWalletResponse(
            mnemonic = mnemonic
        )
    }

    actual fun getWalletCredentials(pass: String, mnemonic: String): WalletCredentials {
        val credentials = WalletUtils.loadBip39Credentials(pass, mnemonic)

        return WalletCredentials(
            address = credentials.address,
            privateKey = credentials.ecKeyPair.privateKey.toString(16)
        )
    }
}