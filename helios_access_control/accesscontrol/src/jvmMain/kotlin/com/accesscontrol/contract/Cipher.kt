package com.accesscontrol.contract

import java.security.MessageDigest

object Cipher {
    fun String.sha1(): String {
        return this.hashWithAlgorithm("SHA-1")
    }

    private fun String.hashWithAlgorithm(algorithm: String): String {
        val digest = MessageDigest.getInstance(algorithm)
        val bytes = digest.digest(this.toByteArray(Charsets.UTF_8))
        return bytes.fold("", { str, it -> str + "%02x".format(it) })
    }
}