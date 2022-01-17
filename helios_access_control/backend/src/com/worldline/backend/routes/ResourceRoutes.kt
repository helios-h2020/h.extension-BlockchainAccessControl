package com.worldline.backend.routes

import com.accesscontrol.datasource.AccessControl
import com.accesscontrol.model.AccessType
import com.accesscontrol.model.RequestStatus.*
import com.accesscontrol.model.Resource
import com.accesscontrol.model.Response
import com.accesscontrol.model.toRequestStatus
import com.worldline.backend.datasource.Local
import com.worldline.backend.datasource.SQLiteLocal
import com.worldline.backend.extension.flatMap
import com.worldline.backend.extension.flatMapDb
import com.worldline.backend.extension.upload
import com.worldline.backend.model.IdentityPrincipal
import com.worldline.backend.strings.Strings
import io.ktor.application.*
import io.ktor.auth.*
import io.ktor.http.*
import io.ktor.response.*
import io.ktor.routing.*
import io.ktor.util.pipeline.*
import java.io.File

fun Application.resourceRoutes(local: Local = SQLiteLocal(), accessControl: AccessControl) {
    routing {
        authenticate {

            route("/resource") {
                post {
                    try {
                        val owner = call.principal<IdentityPrincipal>()!!
                        val resource = call.upload("resource")
                        local.createResource(resource.copy(owner = owner.id)).flatMapDb(call) {
                            call.respond(resource.copy(id = it, url = "/$it"))
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                        call.respond(
                            HttpStatusCode.InternalServerError,
                            Response(Strings.SERVER_ERROR)
                        )
                    }

                }

                get("/{id}") {
                    val requester = call.principal<IdentityPrincipal>()!!

                    println(requester.token)

                    val resourceUri = call.parameters["id"] ?: ""

                    local.getResourceById(resourceUri)
                        .flatMapDb(call) { resource ->
                            if (requester.id == resource.owner) {
                                respondWithUrl(resource.url)
                            } else {
                                println(requester.id)
                                println(resource.owner)
                                println(resourceUri)
                                println(requester.pass)
                                when (resource.accessType) {
                                    AccessType.INDIVIDUAL -> {
                                        checkAccessRequestForResource(accessControl, requester, resource)
                                    }
                                    AccessType.GROUP -> {
                                        checkAccessRequestForGroup(local, accessControl, requester, resource)
                                    }
                                }
                            }
                        }
                }

                get {
                    local.getAllResources().flatMapDb(call) {
                        call.respond(Response(it))
                    }
                }
            }
        }
    }
}

private suspend fun PipelineContext<Unit, ApplicationCall>.respondWithUrl(
    url: String
) {
    call.respondFile(File(url))
}

private suspend fun PipelineContext<Unit, ApplicationCall>.checkAccessRequestForResource(
    accessControl: AccessControl,
    requester: IdentityPrincipal,
    resource: Resource
) {
    checkAccessRequest(
        accessControl = accessControl,
        requester = requester,
        owner = resource.owner,
        resourceId = resource.id,
        resourceUrl = resource.url
    )
}

private suspend fun PipelineContext<Unit, ApplicationCall>.checkAccessRequestForGroup(
    local: Local,
    accessControl: AccessControl,
    requester: IdentityPrincipal,
    resource: Resource,
) {
    local.getGroupById(resource.groupId)
        .flatMapDb(call) { group ->
            if (requester.id == group.owner) {
                respondWithUrl(resource.url)
            } else {
                checkAccessRequest(
                    accessControl = accessControl,
                    requester = requester,
                    owner = group.owner,
                    resourceId = group.id,
                    resourceUrl = resource.url
                )
            }
        }
}

private suspend fun PipelineContext<Unit, ApplicationCall>.checkAccessRequest(
    accessControl: AccessControl,
    requester: IdentityPrincipal,
    owner: String,
    resourceId: String,
    resourceUrl: String
) {
    accessControl.checkAccessRequest(
        requester = requester.id,
        owner = owner,
        uri = resourceId,
        accessKey = requester.pass
    ).flatMap(call) { code ->
        when (code.toRequestStatus()) {
            PENDING -> call.respond(HttpStatusCode.NotFound)
            ACCEPTED -> respondWithUrl(resourceUrl)
            REJECTED -> call.respond(HttpStatusCode.NotFound)
        }
    }
}
