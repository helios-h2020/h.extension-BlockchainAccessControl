package com.worldline.backend.routes

import com.accesscontrol.datasource.AccessControl
import com.accesscontrol.model.Response
import com.worldline.backend.datasource.Local
import com.worldline.backend.datasource.SQLiteLocal
import com.worldline.backend.extension.flatMapDb
import com.worldline.backend.model.CreateGroupRequest
import com.worldline.backend.model.DeleteGroupRequest
import com.worldline.backend.model.Group
import com.worldline.backend.model.IdentityPrincipal
import com.worldline.backend.strings.Strings
import io.ktor.application.*
import io.ktor.auth.*
import io.ktor.http.*
import io.ktor.request.*
import io.ktor.response.*
import io.ktor.routing.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.util.*

fun Application.groupRoutes(local: Local = SQLiteLocal(), accessControl: AccessControl) {
    routing {
        authenticate {

            route("/group") {
                post {
                    try {
                        val owner = call.principal<IdentityPrincipal>()!!
                        val label = withContext(Dispatchers.IO) { call.receive<CreateGroupRequest>() }.label
                        val group = Group(
                            id = "",
                            owner = owner.id,
                            datetime = Date().time,
                            label = label
                        )

                        local.createGroup(group)
                            .flatMapDb(call) {
                                call.respond(group.copy(id = it))
                            }
                    } catch (e: Exception) {
                        e.printStackTrace()
                        call.respond(
                            HttpStatusCode.InternalServerError,
                            Response(Strings.SERVER_ERROR)
                        )
                    }

                }

                get {
                    local.getAllGroups().flatMapDb(call) {
                        call.respond(Response(it))
                    }
                }
                delete {
                    try {
                        val owner = call.principal<IdentityPrincipal>()!!
                        val groupId = withContext(Dispatchers.IO) { call.receive<DeleteGroupRequest>() }.groupId

                        local.getGroupById(groupId)
                            .flatMapDb(call) { group ->
                                if (group.owner == owner.id) {
                                    local.deleteGroupById(groupId)
                                        .flatMapDb(call) {
                                            call.respond(Strings.DELETE_GROUP_SUCCESS_RESPONSE)
                                        }
                                } else {
                                    call.respond(
                                        HttpStatusCode.Forbidden,
                                        Response(Strings.DELETE_GROUP_FORBIDDEN)
                                    )
                                }
                            }

                    } catch (e: Exception) {
                        e.printStackTrace()
                        call.respond(
                            HttpStatusCode.InternalServerError,
                            Response(Strings.SERVER_ERROR)
                        )
                    }
                }
            }
        }
    }
}
