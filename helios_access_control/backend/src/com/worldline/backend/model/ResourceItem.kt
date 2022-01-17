package com.worldline.backend.model

data class ResourceItem(
    val id: String,
    val url: String,
    val label: String,
    val type: String,
    val accessType: String,
    val groupId: String
)