package com.accesscontrol.datasource

import com.accesscontrol.domain.Either
import com.accesscontrol.domain.Success

actual class AccessControl {

    actual suspend fun setupAccessKey(accessKey: String): Either<Error, Success> {
        TODO("Not yet implemented")
    }

    actual suspend fun createAccessRequest(uri: String): Either<Error, Success> {
        TODO("Not yet implemented")
    }

    actual suspend fun acceptAccessRequest(requester: String, uri: String): Either<Error, Success> {
        TODO("Not yet implemented")
    }

    actual suspend fun rejectAccessRequest(requester: String, uri: String): Either<Error, Success> {
        TODO("Not yet implemented")
    }

    actual suspend fun resetAccessRequest(uri: String): Either<Error, Success> {
        TODO("Not yet implemented")
    }

    actual suspend fun checkAccessRequest(
        owner: String,
        uri: String,
        accessKey: String
    ): Either<Error, Int> {
        TODO("Not yet implemented")
    }
}