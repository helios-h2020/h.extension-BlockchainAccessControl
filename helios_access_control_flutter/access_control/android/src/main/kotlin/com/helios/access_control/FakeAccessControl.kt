package com.helios.access_control

import com.accesscontrol.domain.Either
import com.accesscontrol.domain.Error
import com.accesscontrol.domain.Success

class FakeAccessControl {
    fun createAccessRequest(uri: String): Either<Error, Success> {
        return Either.Right(Success)
    }

    fun checkAccessRequest(owner: String, uri: String, accessKey: String): Either<Error, Int> {
        return Either.Right(0)
    }

    fun acceptAccessRequest(requester: String, uri: String): Either<Error, Success> {
        return Either.Right(Success)
    }

    fun rejectAccessRequest(requester: String, uri: String): Either<Error, Success> {
        return Either.Right(Success)
    }

    fun resetAccessRequest(uri: String): Either<Error, Success> {
        return Either.Right(Success)
    }
}
