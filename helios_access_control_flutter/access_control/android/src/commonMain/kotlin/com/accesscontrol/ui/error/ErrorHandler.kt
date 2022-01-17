package com.accesscontrol.ui.error

import com.accesscontrol.domain.Error
import com.accesscontrol.domain.Status

interface ErrorHandlerInterface {
    fun convert(error: Error): String
}

interface StatusCheckHandlerInterface {
    fun convertStatus(status: Status) : String
}
