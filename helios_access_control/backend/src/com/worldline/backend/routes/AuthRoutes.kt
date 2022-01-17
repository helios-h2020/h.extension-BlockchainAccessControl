package com.worldline.backend.routes

import com.accesscontrol.model.Response
import com.worldline.auth.JwtConfig
import com.worldline.backend.datasource.Local
import com.worldline.backend.model.IdentityLogin
import com.worldline.backend.model.IdentityPrincipal
import com.worldline.backend.strings.Strings
import io.ktor.application.*
import io.ktor.http.*
import io.ktor.request.*
import io.ktor.response.*
import io.ktor.routing.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

fun Application.authRoutes(local: Local) {
    routing {
        post("/login") {
            try {
                val identity = withContext(Dispatchers.IO) { call.receive<IdentityLogin>() }
                val user = local.login(identity.id, identity.pass, identity.fcmToken)
                val token = JwtConfig.makeToken(user!!)

                call.respond(Response(token))
            } catch (e: Exception) {
                e.printStackTrace()
                call.respond(HttpStatusCode.Unauthorized, Response(Strings.WRONG_CREDENTIALS))
            }
        }
        post("/register") {
            try {
                val identity = withContext(Dispatchers.IO) { call.receive<IdentityPrincipal>() }
                local.register(identity)

                val token =
                    JwtConfig.makeToken(IdentityPrincipal(identity.id, identity.pass, identity.token, identity.name))

                call.respond(Response(token))
            } catch (e: Exception) {
                e.printStackTrace()
                call.respond(HttpStatusCode.InternalServerError, Response(Strings.SERVER_ERROR))
            }
        }
    }
}