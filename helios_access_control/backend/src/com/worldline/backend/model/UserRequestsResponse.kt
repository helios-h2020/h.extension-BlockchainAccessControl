package com.worldline.backend.model

data class UserRequestsResponseItem(
    val request: UserRequestsRequestItem,
    val resource: UserRequestsResourceItem,
    val isOwner: Boolean
)

data class UserRequestsRequestItem(
    val id: Int,
    val datetime: Long,
    val status: String,
    val requesterId: String
)

data class UserRequestsResourceItem(
    val id: String,
    val label: String,
    val type: String,
    val accessType: String,
    val groupId: String
)