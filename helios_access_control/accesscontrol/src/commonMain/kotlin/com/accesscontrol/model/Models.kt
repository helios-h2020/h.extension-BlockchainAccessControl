package com.accesscontrol.model

data class Resource(
    val id: String,
    val owner: String,
    val url: String,
    val datetime: Long,
    val label: String,
    val type: ResourceType,
    val accessType: AccessType,
    val groupId: String
)

enum class ResourceType {
    IMAGE, VIDEO, AUDIO, DOCUMENT
}

enum class AccessType {
    INDIVIDUAL, GROUP
}

data class Identity(
    val id: String,
    val pass: String,
    val token: String
)

data class Request(
    val id: Int,
    val resourceId: String,
    val groupId: String,
    val owner: String,
    val requester: String,
    val status: RequestStatus,
    val datetime: Long
)

data class Response<T>(val content: T)

data class Error(
    val code: Int,
    val message: String
)

enum class RequestStatus(val code: Int) {
    PENDING(0),  // 0
    ACCEPTED(1), // 1
    REJECTED(2) // 2
}

fun Int.toRequestStatus() = RequestStatus.values().first { this == it.code }