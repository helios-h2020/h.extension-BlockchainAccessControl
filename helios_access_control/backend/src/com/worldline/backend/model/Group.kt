package com.worldline.backend.model

data class Group(
    val id: String,
    val owner: String,
    val datetime: Long,
    val label: String,
)