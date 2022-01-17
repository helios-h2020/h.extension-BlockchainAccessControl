package com.accesscontrol.ui.error

import com.accesscontrol.domain.Error
import com.accesscontrol.domain.Status

class ErrorHandler() : ErrorHandlerInterface {
    override fun convert(error: Error): String {
        return (
                when (error) {
                    Error.RequestAlreadyExist -> "Request already exists"
                    Error.RequestNotExist -> "Request not exist"
                    Error.RequestOtherGranter -> "Request other granter"
                    Error.RequestAlreadyAccepted -> "Request already accepted"
                    Error.RequestAlreadyRejected -> "Request already rejected<"
                    Error.RequestAcceptedOtherGranter -> "Request accepted other granter"
                    Error.RequestRejectedOtherGranter -> "Request rejected other granter"
                    Error.AccessKeyIncorrectKey -> "Access key incorrect key"
                }
                )
    }
}

class StatusCheckHandler() : StatusCheckHandlerInterface {
    override fun convertStatus(status: Status): String {
        return (
                when (status) {
                    Status.PENDING -> "PENDING"
                    Status.ACCEPTED -> "ACCEPTED"
                    Status.REJECTED -> "REJECTED"
                }
                )
    }
}



