package com.worldline.backend.datasource

import com.accesscontrol.domain.Either
import com.accesscontrol.domain.Success
import com.accesscontrol.model.*
import com.worldline.backend.model.Group
import com.worldline.backend.model.GroupItem
import com.worldline.backend.model.IdentityPrincipal
import com.worldline.backend.model.ResourceItem

interface Local {
    suspend fun login(id: String, pass: String, fcmToken: String = ""): IdentityPrincipal?
    suspend fun register(identity: IdentityPrincipal)
    suspend fun createResource(resource: Resource): Either<Error, String>
    suspend fun getResourceById(id: String): Either<Error, Resource>
    suspend fun createRequest(request: Request): Either<Error, Request>
    suspend fun getUserPass(id: String): Either<Error, String>
    suspend fun getUserToken(id: String): Either<Error, String>
    suspend fun updateRequest(id: Int, status: RequestStatus)
    suspend fun getRequestById(requestId: Int): Either<Error, Request>
    suspend fun getUserRequestsByStatus(userId: String, status: String): Either<Error, List<Request>>
    suspend fun getAllResources(): Either<Error, List<ResourceItem>>
    suspend fun createGroup(group: Group): Either<Error, String>
    suspend fun getAllGroups(): Either<Error, List<GroupItem>>
    suspend fun getGroupById(id: String): Either<Error, Group>
    suspend fun deleteGroupById(id: String): Either<Error, Success>
}