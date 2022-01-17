package com.helios.wallet

import android.app.Activity
import androidx.annotation.NonNull
import com.worldline.helioswallet.HeliosWallet
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** WalletPlugin */
class WalletPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    private val wallet by lazy {
        activity?.let {
            HeliosWallet(it.filesDir.absolutePath)
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "wallet")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "createWallet" -> createWallet(call, result)
            "getWalletCredentials" -> getWalletCredentials(call, result)
            else -> result.notImplemented()
        }
    }

    private fun createWallet(call: MethodCall, result: Result) {
        val pass = call.argument<String>("pass")

        if (pass != null) {
            val wallet = wallet?.createWallet(pass)
            result.success(
                mapOf("mnemonic" to wallet?.mnemonic)
            )
        } else {
            result.errorMissingParameter("pass")
        }
    }

    private fun getWalletCredentials(call: MethodCall, result: Result) {
        val pass = call.argument<String>("pass")
        val mnemonic = call.argument<String>("mnemonic")

        if (pass == null) {
            result.errorMissingParameter("pass")
            return
        }
        if (mnemonic == null) {
            result.errorMissingParameter("mnemonic")
            return
        }

        val importWalletResponse = wallet?.getWalletCredentials(pass,mnemonic)
        result.success(
            mapOf("address" to importWalletResponse?.address, "privateKey" to importWalletResponse?.privateKey)
        )
    }
}
