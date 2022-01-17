package com.accesscontrol.datasource

import com.accesscontrol.domain.Either
import com.accesscontrol.domain.Error
import com.accesscontrol.domain.Success

expect class AccessControl {
    suspend fun createAccessRequest(uri: String): Either<Error, Success>
    suspend fun checkAccessRequest(requester: String, owner: String, uri: String, accessKey: String): Either<Error, Int>
    suspend fun acceptAccessRequest(uri: String): Either<Error, Success>
    suspend fun rejectAccessRequest(uri: String): Either<Error, Success>
    suspend fun resetAccessRequest(uri: String): Either<Error, Success>
}