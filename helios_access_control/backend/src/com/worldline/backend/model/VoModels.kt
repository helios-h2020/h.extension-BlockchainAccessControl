package com.worldline.backend.model

import com.accesscontrol.model.*
import org.jetbrains.exposed.sql.ResultRow
import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.insert

object UserVo : Table("userVo") {
    val id = varchar("id", 255)

    val name = varchar("name", 255)

    // val pictureUrl = varchar("pictureUrl", 255)
    val pass = varchar("password", 255)
    val token = varchar("token", 255)

    override val primaryKey = PrimaryKey(id)
}

object ResourceVo : Table("resourceVo") {
    val id = varchar("id", 255)
    val owner = varchar("owner", 255)
    val path = varchar("resourcePath", 255)
    val datetime = long("datetime")
    val type = varchar("type", 255)
    val label = varchar("label", 255)
    val accessType = varchar("accessType", 255)
    val groupId = varchar("groupId", 255)

    override val primaryKey = PrimaryKey(id)
}

object RequestVo : Table("requestVo") {
    val id = integer("id").autoIncrement()
    val owner = varchar("owner", 255)
    val resource = varchar("resource", 255)
    val group = varchar("group", 255)
    val requester = varchar("requester", 255)
    val status = varchar("status", 255)
    val datetime = long("datetime")

    override val primaryKey = PrimaryKey(id)
}

object GroupVo : Table("groupVo") {
    val id = varchar("id", 255)
    val owner = varchar("owner", 255)
    val datetime = long("datetime")
    val label = varchar("label", 255)

    override val primaryKey = PrimaryKey(id)
}

fun ResultRow.toUser() = IdentityPrincipal(
    id = this[UserVo.id],
    pass = this[UserVo.pass],
    token = this[UserVo.token],
    name = this[UserVo.name]
)

fun ResultRow.toResource() = Resource(
    id = this[ResourceVo.id],
    owner = this[ResourceVo.owner],
    url = this[ResourceVo.path],
    type = ResourceType.valueOf(this[ResourceVo.type]),
    datetime = this[ResourceVo.datetime],
    label = this[ResourceVo.label],
    accessType = AccessType.valueOf(this[ResourceVo.accessType]),
    groupId = this[ResourceVo.groupId]
)

fun ResultRow.toResourceItem() = ResourceItem(
    id = this[ResourceVo.id],
    url = "/${this[ResourceVo.id]}",
    label = this[ResourceVo.label],
    type = this[ResourceVo.type],
    accessType = this[ResourceVo.accessType],
    groupId = this[ResourceVo.groupId]
)

fun ResultRow.toRequest() = Request(
    id = this[RequestVo.id],
    resourceId = this[RequestVo.resource],
    groupId = this[RequestVo.group],
    owner = this[RequestVo.owner],
    requester = this[RequestVo.requester],
    status = RequestStatus.valueOf(this[RequestVo.status]),
    datetime = this[RequestVo.datetime],
)

fun ResultRow.toGroup() = Group(
    id = this[GroupVo.id],
    owner = this[GroupVo.owner],
    datetime = this[GroupVo.datetime],
    label = this[GroupVo.label]
)

fun ResultRow.toGroupItem() = GroupItem(
    id = this[GroupVo.id],
    label = this[GroupVo.label]
)

fun IdentityPrincipal.insertMe() {
    val self = this
    UserVo.insert { vo ->
        vo[id] = self.id
        vo[pass] = self.pass
        vo[token] = self.token
        vo[name] = self.name
    }
}

fun Resource.insertMe() {
    val self = this
    ResourceVo.insert { vo ->
        vo[id] = self.id
        vo[owner] = self.owner
        vo[path] = self.url
        vo[datetime] = self.datetime
        vo[label] = self.label
        vo[type] = self.type.toString()
        vo[accessType] = self.accessType.toString()
        vo[groupId] = self.groupId
    }
}

fun Request.insertMe(): Int {
    val self = this
    return RequestVo.insert { vo ->
        vo[owner] = self.owner
        vo[requester] = self.requester
        vo[resource] = self.resourceId
        vo[group] = self.groupId
        vo[status] = self.status.name
        vo[datetime] = self.datetime
    } get RequestVo.id
}

fun Group.insertMe() {
    val self = this
    GroupVo.insert { vo ->
        vo[id] = self.id
        vo[owner] = self.owner
        vo[datetime] = self.datetime
        vo[label] = self.label
    }
}
