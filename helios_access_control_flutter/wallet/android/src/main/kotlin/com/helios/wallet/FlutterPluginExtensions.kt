package com.helios.wallet

import io.flutter.plugin.common.MethodChannel.Result

fun Result.success() {
    success(null)
}

fun Result.errorMissingParameter(paramName: String) {
    error("invalidArgs", "Missing parameter $paramName", null)
}
