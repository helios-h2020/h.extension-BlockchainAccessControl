package com.accesscontrol.datasource

import com.accesscontrol.Constants
import com.accesscontrol.domain.Either
import com.accesscontrol.domain.Success
import com.accesscontrol.contract.HeliosAccessControl
import com.accesscontrol.contract.Cipher.sha1
import org.web3j.crypto.Credentials
import org.web3j.protocol.Web3j
import org.web3j.protocol.core.methods.response.TransactionReceipt
import org.web3j.protocol.http.HttpService
import org.web3j.tx.gas.StaticGasProvider
import com.accesscontrol.domain.Error

actual class AccessControl(privateKey: String) {

    private val web3j by lazy { Web3j.build(HttpService(Constants.HELIOS_BLOCKCHAIN_ENDPOINT)) }
    private val gasProvider =
        StaticGasProvider(java.math.BigInteger.ZERO, java.math.BigInteger.valueOf(1000000))
    private val credentials = Credentials.create(privateKey)

    private fun hacLoad(): HeliosAccessControl {
        return HeliosAccessControl.load(
            Constants.HELIOS_ADDRESS,
            web3j,
            credentials,
            gasProvider
        )
    }

    actual suspend fun setupAccessKey(accessKey: String): Either<Error, Success> = execute {
        setAccessKey(accessKey)
        Success
    }

    private fun setAccessKey(accessKey: String): TransactionReceipt? {
        return hacLoad().setAccessKey(accessKey.sha1()).send()
    }

    actual suspend fun createAccessRequest(uri: String): Either<Error, Success> = execute {
        val result = hacLoad().createAccessRequest(uri).send()
        Success
    }

    actual suspend fun checkAccessRequest(
        requester: String,
        owner: String,
        uri: String,
        accessKey: String
    ): Either<Error, Int> = execute {
        setAccessKey(accessKey)
        hacLoad().checkAccessRequest(credentials.address, owner, uri, accessKey.sha1()).send().toInt()
    }

    actual suspend fun acceptAccessRequest(requester: String, uri: String): Either<Error, Success> = execute {
        hacLoad().acceptAccessRequest(requester, uri).send()
        Success
    }

    actual suspend fun rejectAccessRequest(requester: String, uri: String): Either<Error, Success> = execute {
        hacLoad().rejectAccessRequest(requester, uri).send()
        Success
    }

    actual suspend fun resetAccessRequest(uri: String): Either<Error, Success> = execute {
        hacLoad().resetAccessRequest(uri).send()
        Success
    }

    private suspend fun <R> execute(f: suspend () -> R): Either<Error, R> =
        try {
            Either.Right(f())
        } catch (t: Throwable) {
            t.printStackTrace()

            val error = if (t.message?.contains(".") == true)
                t.message?.let { it.substring(it.length - 3, it.length - 2) }
            else
                t.message?.let { it.substring(it.length - 1, it.length) }

            Either.Left(
                when (error) {
                    "0" -> Error.RequestAlreadyExist
                    "1" -> Error.RequestNotExist
                    "2" -> Error.RequestOtherGranter
                    "3" -> Error.RequestAlreadyAccepted
                    "4" -> Error.RequestAlreadyRejected
                    "5" -> Error.RequestAcceptedOtherGranter
                    "6" -> Error.RequestRejectedOtherGranter
                    "7" -> Error.AccessKeyIncorrectKey
                    else -> Error.RequestOtherGranter
                }
            )
        }
}