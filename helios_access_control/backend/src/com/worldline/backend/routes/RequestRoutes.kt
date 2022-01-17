package com.worldline.backend.routes

import com.accesscontrol.datasource.AccessControl
import com.accesscontrol.model.*
import com.worldline.backend.datasource.Local
import com.worldline.backend.extension.flatMap
import com.worldline.backend.extension.flatMapDb
import com.worldline.backend.model.*
import com.worldline.backend.push.PushNotificationsManager
import com.worldline.backend.strings.Strings
import io.ktor.application.*
import io.ktor.auth.*
import io.ktor.http.*
import io.ktor.request.*
import io.ktor.response.*
import io.ktor.routing.*
import io.ktor.util.pipeline.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.util.*

fun Application.requestRoutes(local: Local, accessControl: AccessControl) {
    routing {
        authenticate {
            route("/request") {
                post {
                    val requester = call.principal<IdentityPrincipal>()!!
                    val resourceRequest = withContext(Dispatchers.IO) { call.receive<ResourceRequest>() }
                    val resourceId = resourceRequest.resourceId

                    local.getResourceById(resourceId).flatMapDb(call) {
                        local.createRequest(
                            Request(
                                id = 0,
                                resourceId = it.id,
                                groupId = it.groupId,
                                requester = requester.id,
                                owner = it.owner,
                                status = RequestStatus.PENDING,
                                datetime = Date().time
                            )
                        ).flatMapDb(call) { request ->
                            call.respond(request)
                            // Send push notification to owner
                            local.getUserToken(it.owner)
                                .flatMapDb(call) { userToken ->
                                    PushNotificationsManager.push(
                                        userToken,
                                        Strings.PUSH_NEW_REQUEST_ACCESS_DESCRIPTION
                                    )
                                }
                        }
                    }
                }

                get {
                    val requester = call.principal<IdentityPrincipal>()!!
                    val status: String? = call.request.queryParameters["status"]
                    status?.let {
                        val responseList = mutableListOf<UserRequestsResponseItem>()
                        local.getUserRequestsByStatus(requester.id, status)
                            .flatMapDb(call) { requestList ->
                                requestList.map { request ->
                                    local.getResourceById(request.resourceId)
                                        .flatMapDb(call) { resource ->
                                            responseList.add(
                                                UserRequestsResponseItem(
                                                    request = UserRequestsRequestItem(
                                                        id = request.id,
                                                        datetime = request.datetime,
                                                        status = request.status.toString(),
                                                        requesterId = request.requester
                                                    ),
                                                    resource = UserRequestsResourceItem(
                                                        id = resource.id,
                                                        label = resource.label,
                                                        type = resource.type.toString(),
                                                        accessType = resource.accessType.toString(),
                                                        groupId = resource.groupId
                                                    ),
                                                    isOwner = requester.id == resource.owner
                                                )
                                            )
                                        }
                                }
                                call.respond(responseList)
                            }
                    } ?: run {
                        call.respond(
                            HttpStatusCode.BadRequest,
                            Response(Strings.REQUEST_STATUS_BAD_REQUEST)
                        )
                    }
                }

                put("/{id}/grant") {
                    call.checkRequest(
                        RequestStatus.ACCEPTED,
                        local,
                        accessControl,
                        success = { requester ->
                            call.respond(Strings.GRANT_SUCCESS_RESPONSE)
                            local.getUserToken(requester)
                                .flatMapDb(call) { userToken ->
                                    PushNotificationsManager.push(
                                        userToken,
                                        Strings.PUSH_REQUEST_ACCESS_GRANTED
                                    )
                                }
                        }
                    )
                }

                put("/{id}/deny") {
                    call.checkRequest(
                        RequestStatus.REJECTED,
                        local,
                        accessControl,
                        success = { requester ->
                            call.respond(Strings.DENY_SUCCESS_RESPONSE)
                            local.getUserToken(requester)
                                .flatMapDb(call) { userToken ->
                                    PushNotificationsManager.push(
                                        userToken,
                                        Strings.PUSH_REQUEST_ACCESS_DENIED
                                    )
                                }
                        }
                    )
                }

                put("/revoke") {
                    // 1. Check if the owner has access
                    // 2. Find the request in the database
                    // 3. Check if the request has been denied on the blockchain
                    // 4. Send push to the requester
                }
            }
        }
    }
}

private suspend fun ApplicationCall.checkRequest(
    operation: RequestStatus,
    local: Local,
    accessControl: AccessControl,
    error: suspend () -> Unit = {},
    success: suspend (String) -> Unit = {}
) {
    // 1. Check if the owner has access
    val owner = principal<IdentityPrincipal>()!!
    val requestId = parameters["id"] ?: "0"

    // 2. Find the request in the database
    local.getRequestById(requestId.toInt()).flatMapDb(this) { request ->

        if (request.owner != owner.id) {
            // TODO("Fire exception")
        }
        val requestAccessId = request.groupId.ifEmpty {
            request.resourceId
        }

        local.getUserPass(request.requester).flatMapDb(this) { pass ->
            accessControl.checkAccessRequest(
                requester = request.requester,
                owner = request.owner,
                uri = requestAccessId,
                accessKey = pass
            ).flatMap(this) {
                local.updateRequest(request.id, status = it.toRequestStatus())
                if (it.toRequestStatus() == operation) {
                    success(request.requester)
                } else {
                    error()
                }
            }
        }
    }
}