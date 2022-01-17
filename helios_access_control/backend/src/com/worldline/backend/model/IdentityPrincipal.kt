package com.worldline.backend.model

import io.ktor.auth.*

data class IdentityPrincipal(
    val id: String,
    val pass: String,
    val token: String,
    val name: String
) : Principal