package com.worldline.backend

import com.accesscontrol.Constants
import com.accesscontrol.datasource.AccessControl
import com.worldline.auth.JwtConfig.CLAIM_ID
import com.worldline.auth.JwtConfig.CLAIM_PASS
import com.worldline.auth.JwtConfig.REALM
import com.worldline.auth.JwtConfig.verifier
import com.worldline.backend.datasource.SQLiteLocal
import com.worldline.backend.routes.authRoutes
import com.worldline.backend.routes.groupRoutes
import com.worldline.backend.routes.requestRoutes
import com.worldline.backend.routes.resourceRoutes
import io.ktor.application.*
import io.ktor.auth.*
import io.ktor.auth.jwt.*
import io.ktor.features.*
import io.ktor.gson.*
import org.jetbrains.exposed.sql.Database

fun main(args: Array<String>): Unit = io.ktor.server.netty.EngineMain.main(args)

@Suppress("unused") // Referenced in application.conf
@kotlin.jvm.JvmOverloads
fun Application.module(testing: Boolean = false) {
    Database.connect("jdbc:sqlite:helios.db", "org.sqlite.JDBC")

    val local = SQLiteLocal()
    val accessControl = AccessControl(
        privateKey = "c77584fe49869e0b11ebafbb3e6f56cc3cbc472879e7a39d60fcd8eb76ce53bb"
    )

    install(Authentication) {
        jwt {
            verifier(verifier)
            realm = REALM
            validate {
                val id = it.payload.getClaim(CLAIM_ID).asString() ?: ""
                val pass = it.payload.getClaim(CLAIM_PASS).asString() ?: ""

                local.login(id, pass)
            }
        }

    }

    install(ContentNegotiation) {
        gson {
        }
    }

    println(Constants.HELIOS_ADDRESS)

    authRoutes(local)
    requestRoutes(local, accessControl)
    resourceRoutes(local, accessControl)
    groupRoutes(local, accessControl)
}

