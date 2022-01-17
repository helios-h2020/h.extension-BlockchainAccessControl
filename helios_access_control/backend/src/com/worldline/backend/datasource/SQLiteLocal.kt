package com.worldline.backend.datasource

import com.accesscontrol.domain.Either
import com.accesscontrol.domain.Success
import com.accesscontrol.model.*
import com.worldline.backend.model.*
import com.worldline.backend.model.IdentityPrincipal
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
import java.util.Random
import kotlin.streams.asSequence

class SQLiteLocal : Local {

    init {
        transaction { SchemaUtils.create(UserVo, ResourceVo, RequestVo, GroupVo) }
    }

    override suspend fun login(id: String, pass: String, fcmToken: String): IdentityPrincipal? {
        return transaction {
            if (fcmToken.isNotEmpty()) {
                    UserVo.update({ UserVo.id eq id and (UserVo.pass eq pass) }) {
                        it[token] = fcmToken
                    }
            }
            UserVo.select { UserVo.id eq id and (UserVo.pass eq pass) }.first().toUser()
        }
    }

    override suspend fun register(identity: IdentityPrincipal) {
        transaction { identity.insertMe() }
    }

    override suspend fun createResource(resource: Resource): Either<Error, String> {
        return try {
            transaction {
                val id = random()
                resource.copy(id = id).insertMe()
                Either.Right(id)
            }
        } catch (e: Exception) {
            e.printStackTrace()
            Either.Left(Error(0, ""))
        }
    }

    override suspend fun getResourceById(id: String): Either<Error, Resource> {
        return try {
            Either.Right(transaction { ResourceVo.select { ResourceVo.id eq id }.first().toResource() })
        } catch (e: Exception) {
            Either.Left(Error(0, ""))
        }
    }

    override suspend fun createRequest(request: Request): Either<Error, Request> {
        return try {
            Either.Right(transaction {
                val id = request.insertMe()
                request.copy(id = id)
            })
        } catch (e: Exception) {
            Either.Left(Error(0, ""))
        }
    }

    override suspend fun getUserToken(id: String): Either<Error, String> {
        return Either.Right(transaction { UserVo.select { UserVo.id eq id }.first().toUser().token })
    }

    override suspend fun getUserPass(id: String): Either<Error, String> {
        return Either.Right(transaction { UserVo.select { UserVo.id eq id }.first().toUser().pass })
    }

    override suspend fun updateRequest(id: Int, status: RequestStatus) {
        transaction {
            RequestVo.update({ RequestVo.id eq id }) {
                it[RequestVo.status] = status.toString()
            }
        }
    }

    override suspend fun getRequestById(requestId: Int): Either<Error, Request> {
        return try {
            Either.Right(transaction { RequestVo.select { RequestVo.id eq requestId }.first().toRequest() })
        } catch (e: Exception) {
            Either.Left(Error(0, ""))
        }
    }

    override suspend fun getUserRequestsByStatus(userId: String, status: String): Either<Error, List<Request>> {
        return try {
            Either.Right(transaction {
                RequestVo.select {
                    (RequestVo.requester.eq(userId) or RequestVo.owner.eq(userId)) and
                            RequestVo.status.eq(status)
                }
                    .toList()
                    .map { it.toRequest() }
            })
        } catch (e: Exception) {
            Either.Left(Error(0, ""))
        }
    }

    override suspend fun getAllResources(): Either<Error, List<ResourceItem>> {
        return try {
            Either.Right(transaction { ResourceVo.selectAll().toList().map { it.toResourceItem() } })
        } catch (e: Exception) {
            Either.Left(Error(0, ""))
        }
    }

    override suspend fun createGroup(group: Group): Either<Error, String> {
        return try {
            transaction {
                val id = random()
                group.copy(id = id).insertMe()
                Either.Right(id)
            }
        } catch (e: Exception) {
            e.printStackTrace()
            Either.Left(Error(0, ""))
        }
    }

    override suspend fun getAllGroups(): Either<Error, List<GroupItem>> {
        return try {
            Either.Right(transaction { GroupVo.selectAll().toList().map { it.toGroupItem() } })
        } catch (e: Exception) {
            Either.Left(Error(0, ""))
        }
    }

    override suspend fun getGroupById(id: String): Either<Error, Group> {
        return try {
            Either.Right(transaction { GroupVo.select { GroupVo.id eq id }.first().toGroup() })
        } catch (e: Exception) {
            Either.Left(Error(0, ""))
        }
    }

    override suspend fun deleteGroupById(id: String): Either<Error, Success> {
        return try {
            Either.Right(transaction {
                GroupVo.deleteWhere { GroupVo.id eq id }
                ResourceVo.deleteWhere { ResourceVo.groupId eq id }
                Success
            })
        } catch (e: Exception) {
            Either.Left(Error(0, ""))
        }
    }

    private fun random(length: Long = 20): String {
        val source = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return Random().ints(length, 0, source.length)
            .asSequence()
            .map(source::get)
            .joinToString("")
    }
}