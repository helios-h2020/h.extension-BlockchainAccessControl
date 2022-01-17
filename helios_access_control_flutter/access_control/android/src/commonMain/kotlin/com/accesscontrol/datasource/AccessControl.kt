package com.accesscontrol.datasource

import com.accesscontrol.domain.Either
import com.accesscontrol.domain.Error
import com.accesscontrol.domain.Success

expect class AccessControl {
    suspend fun setupAccessKey(accessKey: String): Either<Error, Success>
    suspend fun createAccessRequest(uri: String): Either<Error, Success>
    suspend fun checkAccessRequest(
        requester: String,
        owner: String,
        uri: String,
        accessKey: String
    ): Either<Error, Int>

    suspend fun acceptAccessRequest(requester: String, uri: String): Either<Error, Success>
    suspend fun rejectAccessRequest(requester: String, uri: String): Either<Error, Success>
    suspend fun resetAccessRequest(uri: String): Either<Error, Success>
}