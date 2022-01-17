package com.worldline.androidSample

import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.worldline.helioswallet.CreateWalletResponse
import com.worldline.helioswallet.WalletCredentials
import com.worldline.helioswallet.HeliosWallet

class MainActivity : AppCompatActivity() {

    private val heliosWallet by lazy { HeliosWallet(filesDir.absolutePath) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<Button>(R.id.create).setOnClickListener { createWalletAndAddresses() }
        findViewById<Button>(R.id.importWallet).setOnClickListener { importWalletAddress() }
    }

    private fun createWalletAndAddresses() {
        val pass = findViewById<EditText>(R.id.pass).text.toString()

        val walletInfo = heliosWallet.createWallet(pass)
        val credentials = heliosWallet.getWalletCredentials(pass, walletInfo.mnemonic)

        showWallet(pass, walletInfo, credentials)
    }

    private fun importWalletAddress() {
        val pass = findViewById<EditText>(R.id.pass).text.toString()
        val pnemonic = findViewById<EditText>(R.id.pnemonic).text.toString()

        val credentials = heliosWallet.getWalletCredentials(pass, pnemonic)

        showAddress(credentials)
    }

    private fun showWallet(
        pass: String,
        createWalletResponse: CreateWalletResponse,
        credentials: WalletCredentials
    ) {
        val mnemonic = createWalletResponse.mnemonic
        val address = credentials.address
        val privateKey = credentials.privateKey
        val result = """
                Password: $pass
                Mnemonic: $mnemonic
                
                Account:
                address: $address
                private key: $privateKey
            """.trimIndent()

        findViewById<TextView>(R.id.stacktrace).text = result
        findViewById<TextView>(R.id.pnemonic).text = mnemonic
    }

    private fun showAddress(
        credentials: WalletCredentials
    ) {
        val result = """
                Account:
                address: ${credentials.address}
                private key: ${credentials.privateKey}
            """.trimIndent()

        findViewById<TextView>(R.id.stacktrace).text = result
    }
}
