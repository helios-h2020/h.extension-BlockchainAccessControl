package com.helios.access_control

import android.app.Activity
import android.os.Build
import androidx.annotation.NonNull
import com.accesscontrol.datasource.AccessControl
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.*
import com.accesscontrol.Constants

/** AccessControlPlugin */
class AccessControlPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private val uiCoroutineScope: CoroutineScope = CoroutineScope(Dispatchers.Main)

    private fun accessControl(privateKey: String) = AccessControl(privateKey)

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "access_control")
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
            "getPlatformVersion" -> getPlatformVersion(result)
            "setupAccessKey" -> setupAccessKey(call, result)
            "createAccessRequest" -> createAccessRequest(call, result)
            "checkAccessRequest" -> checkAccessRequest(call, result)
            "acceptAccessRequest" -> acceptAccessRequest(call, result)
            "rejectAccessRequest" -> rejectAccessRequest(call, result)
            "resetAccessRequest" -> resetAccessRequest(call, result)
            else -> result.notImplemented()
        }
    }

    private fun setupAccessKey(call: MethodCall, result: Result) {
        val privateKey = call.argument<String>("privateKey")
        val accessKey = call.argument<String>("accessKey")

        if (privateKey != null && accessKey != null) {
            uiCoroutineScope.launch {
                val response =
                    withContext(Dispatchers.IO) {
                        accessControl(privateKey).setupAccessKey(
                            accessKey
                        )
                    }
                response.fold(
                    error = {
                        result.errorAccessControl("setupAccessKey", it)
                    },
                    success = {
                        result.success(it)
                    })
            }
        } else {
            privateKey ?: result.errorMissingParameter("privateKey")
            accessKey ?: result.errorMissingParameter("accessKey")
        }
    }

    private fun createAccessRequest(call: MethodCall, result: Result) {
        val uri = call.argument<String>("uri")
        val privateKey = call.argument<String>("privateKey")
        println(Constants.HELIOS_ADDRESS)
        println(Constants.HELIOS_BLOCKCHAIN_ENDPOINT)
        println(uri)
        println(privateKey)

        if (uri != null && privateKey != null) {
            uiCoroutineScope.launch {
                val response = withContext(Dispatchers.IO) { accessControl(privateKey).createAccessRequest(uri) }
                println(response)
                response.fold(
                    error = {
                        result.errorAccessControl("createAccessRequest", it)
                    },
                    success = {
                        result.success()
                    })
            }

        } else {
            result.errorMissingParameter("uri")
        }
    }


    private fun checkAccessRequest(call: MethodCall, result: Result) {
        val requester = call.argument<String>("requester")
        val owner = call.argument<String>("owner")
        val uri = call.argument<String>("uri")
        val accessKey = call.argument<String>("accessKey")
        val privateKey = call.argument<String>("privateKey")

        if (owner != null && uri != null && accessKey != null && privateKey != null && requester != null) {
            uiCoroutineScope.launch {
                val response =
                    withContext(Dispatchers.IO) {
                        accessControl(privateKey).checkAccessRequest(
                            requester,
                            owner,
                            uri,
                            accessKey
                        )
                    }
                response.fold(
                    error = {
                        result.errorAccessControl("checkAccessRequest", it)
                    },
                    success = {
                        result.success(it)
                    })
            }
        } else {
            owner ?: result.errorMissingParameter("owner")
            uri ?: result.errorMissingParameter("uri")
            accessKey ?: result.errorMissingParameter("accessKey")
        }
    }


    private fun acceptAccessRequest(call: MethodCall, result: Result) {
        val uri = call.argument<String>("uri")
        val privateKey = call.argument<String>("privateKey")
        val requester = call.argument<String>("requester")

        if (uri != null && privateKey != null && requester != null) {
            uiCoroutineScope.launch {
                val response =
                    withContext(Dispatchers.IO) { accessControl(privateKey).acceptAccessRequest(requester, uri) }
                response.fold(
                    error = {
                        result.errorAccessControl("acceptAccessRequest", it)
                    },
                    success = {
                        result.success()
                    })
            }
        } else {
            result.errorMissingParameter("uri")
        }
    }

    private fun rejectAccessRequest(call: MethodCall, result: Result) {
        val uri = call.argument<String>("uri")
        val privateKey = call.argument<String>("privateKey")
        val requester = call.argument<String>("requester")

        if (uri != null && privateKey != null && requester != null) {
            uiCoroutineScope.launch {
                val response = withContext(Dispatchers.IO) { accessControl(privateKey).rejectAccessRequest(requester, uri) }
                response.fold(
                    error = {
                        result.errorAccessControl("rejectAccessRequest", it)
                    },
                    success = {
                        result.success()
                    })
            }
        } else {
            result.errorMissingParameter("uri")
        }
    }

    private fun resetAccessRequest(call: MethodCall, result: Result) {
        val uri = call.argument<String>("uri")
        val privateKey = call.argument<String>("privateKey")

        if (uri != null && privateKey != null) {
            uiCoroutineScope.launch {
                val response = withContext(Dispatchers.IO) { accessControl(privateKey).resetAccessRequest(uri) }
                response.fold(
                    error = {
                        result.errorAccessControl("resetAccessRequest", it)
                    },
                    success = {
                        result.success()
                    })
            }
        } else {
            result.errorMissingParameter("uri")
        }
    }

    private fun getPlatformVersion(result: Result) {
        result.success("Android ${Build.VERSION.RELEASE}")
    }

}
