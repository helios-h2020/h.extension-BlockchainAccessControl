package com.worldline.backend.strings

object Strings {
    const val SERVER_ERROR = "There was an error, try again later"
    const val WRONG_CREDENTIALS = "Wrong credentials, try again"
    const val REQUEST_STATUS_BAD_REQUEST = "Status should be provided as query parameter"

    const val ERROR_REQUEST_ALREADY_EXISTS = "Request already exists"
    const val ERROR_REQUEST_NOT_FOUND = "Request not found"
    const val ERROR_OTHER_GRANTED_REQUEST = "Other granted this request"
    const val ERROR_REQUEST_ALREADY_ACCEPTED = "Request already accepted"
    const val ERROR_REQUEST_ALREADY_REJECTED = "Request already rejected"
    const val ERROR_REQUEST_ALREADY_ACCEPTED_BY_OTHER = "Request already accepted by other"
    const val ERROR_REQUEST_ALREADY_REJECTED_BY_OTHER = "Request already rejected by other"
    const val ERROR_REQUEST_INCORRECT_ACCESS_KEY = "Access key is incorrect"

    const val GRANT_SUCCESS_RESPONSE = "Granted"
    const val DENY_SUCCESS_RESPONSE = "Denied"

    const val DELETE_GROUP_SUCCESS_RESPONSE = "Group removed"
    const val DELETE_GROUP_FORBIDDEN = "Permission denied"

    const val PUSH_TITLE = "Helios Access Control"
    const val PUSH_NEW_REQUEST_ACCESS_DESCRIPTION = "You have a new request access. Please check the notifications section"
    const val PUSH_REQUEST_ACCESS_GRANTED = "Your request access has been granted. Please check the new content"
    const val PUSH_REQUEST_ACCESS_DENIED = "Your request access has been denied"
}