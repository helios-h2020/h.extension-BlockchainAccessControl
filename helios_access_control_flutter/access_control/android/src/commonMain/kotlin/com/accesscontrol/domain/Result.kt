package com.accesscontrol.domain

sealed class Error (val code: String){
    object RequestAlreadyExist : Error("0")
    object RequestNotExist : Error("1")
    object RequestOtherGranter : Error("2")
    object RequestAlreadyAccepted : Error("3")
    object RequestAlreadyRejected : Error("4")
    object RequestAcceptedOtherGranter : Error("5")
    object RequestRejectedOtherGranter : Error("6")
    object AccessKeyIncorrectKey : Error("7")
}

sealed class Status(val code: Int) {
    object PENDING : Status(0)
    object ACCEPTED : Status(1)
    object REJECTED : Status(2)
}

object Success
