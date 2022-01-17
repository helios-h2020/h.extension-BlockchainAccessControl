package com.worldline.auth

import com.auth0.jwt.JWT
import com.auth0.jwt.JWTVerifier
import com.auth0.jwt.algorithms.Algorithm
import com.worldline.backend.model.IdentityPrincipal
import java.util.*

object JwtConfig {

    const val CLAIM_ID = "id"
    const val CLAIM_PASS = "pass"
    const val REALM = "heliosaccesscontrol"

    private const val secret = "zAP5MBA4B4Ijz0MZaS48"
    private const val issuer = REALM
    private const val validityInMs = 36_000_00 * 10 // 10 hours
    private val algorithm = Algorithm.HMAC512(secret)

    val verifier: JWTVerifier = JWT
        .require(algorithm)
        .withIssuer(issuer)
        .build()

    /**
     * Produce a token for this combination of User and Account
     */
    fun makeToken(identity: IdentityPrincipal): String = JWT.create()
        .withSubject("Authentication")
        .withIssuer(issuer)
        .withClaim(CLAIM_ID, identity.id)
        .withClaim(CLAIM_PASS, identity.pass)
        .withExpiresAt(getExpiration())
        .sign(algorithm)

    /**
     * Calculate the expiration Date based on current time + the given validity
     */
    private fun getExpiration() = Date(System.currentTimeMillis() + validityInMs)
}