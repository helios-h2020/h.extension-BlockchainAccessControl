package com.helios.access_control
import com.accesscontrol.domain.Error
import io.flutter.plugin.common.MethodChannel.Result

fun Result.success() {
    success(null)
}

fun Result.errorAccessControl(message: String, heliosError: Error) {
    //TODO Add error message instead instead of errorCode
    error(heliosError.code, message, null)
}

fun Result.errorMissingParameter(paramName: String) {
    error("invalidArgs", "Missing parameter $paramName", null)
}
