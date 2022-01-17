package com.worldline.backend.extension

import com.accesscontrol.domain.Either
import com.accesscontrol.domain.Error
import com.accesscontrol.model.AccessType
import com.accesscontrol.model.Resource
import com.accesscontrol.model.ResourceType
import com.worldline.backend.model.IdentityPrincipal
import com.worldline.backend.strings.Strings
import io.ktor.application.*
import io.ktor.auth.*
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.request.*
import io.ktor.response.*
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.yield
import java.io.File
import java.io.InputStream
import java.io.OutputStream
import java.util.*


suspend fun <R> Either<Error, R>.flatMap(call: ApplicationCall, success: suspend (R) -> Unit) {
    when (this) {
        is Either.Left -> when (this.error) {
            Error.RequestAlreadyExist -> call.respond(
                HttpStatusCode.Conflict,
                "error" to Strings.ERROR_REQUEST_ALREADY_EXISTS
            )
            Error.RequestNotExist -> call.respond(
                HttpStatusCode.NotFound,
                "error" to Strings.ERROR_REQUEST_NOT_FOUND
            )
            Error.RequestOtherGranter -> call.respond(
                HttpStatusCode.SeeOther,
                "error" to Strings.ERROR_OTHER_GRANTED_REQUEST
            )
            Error.RequestAlreadyAccepted -> call.respond(
                HttpStatusCode.Conflict,
                "error" to Strings.ERROR_REQUEST_ALREADY_ACCEPTED
            )
            Error.RequestAlreadyRejected -> call.respond(
                HttpStatusCode.Unauthorized,
                "error" to Strings.ERROR_REQUEST_ALREADY_REJECTED
            )
            Error.RequestAcceptedOtherGranter -> call.respond(
                HttpStatusCode.Conflict,
                "error" to Strings.ERROR_REQUEST_ALREADY_ACCEPTED_BY_OTHER
            )
            Error.RequestRejectedOtherGranter -> call.respond(
                HttpStatusCode.Unauthorized,
                "error" to Strings.ERROR_REQUEST_ALREADY_REJECTED_BY_OTHER
            )
            Error.AccessKeyIncorrectKey -> call.respond(
                HttpStatusCode.BadRequest,
                "error" to Strings.ERROR_REQUEST_INCORRECT_ACCESS_KEY
            )
        }
        is Either.Right -> success(this.success)
    }
}

suspend fun <R> Either<com.accesscontrol.model.Error, R>.flatMapDb(
    call: ApplicationCall,
    success: suspend (R) -> Unit
) {
    when (this) {
        is Either.Left -> call.respond(this.error)
        is Either.Right -> success(this.success)
    }
}

suspend fun ApplicationCall.upload(path: String): Resource {
    val owner = principal<IdentityPrincipal>()!!
    val multipart = receiveMultipart()
    val parts = multipart.readAllParts()
    val filePart = parts.filterIsInstance<PartData.FileItem>().first()
    val inputStream = filePart.streamProvider()
    val extension = File(filePart.originalFileName!!).name.split(".").last()
    val name = "file_${Date().time}.$extension"

    val resourcePath = File(path)
    if (!resourcePath.exists()) {
        resourcePath.mkdir()
    }

    val ownerPath = File("$path/${owner.id}")
    if (!ownerPath.exists()) {
        ownerPath.mkdir()
    }

    val thumbPath = File("$path/${owner.id}/thumb")
    if (!thumbPath.exists()) {
        thumbPath.mkdir()
    }

    val file = File("$path/${owner.id}/$name")
    inputStream.use { input ->
        file.outputStream().buffered().use { output -> input.copyToSuspend(output) }
    }
    return Resource(
        id = "",
        owner = "",
        url = file.absolutePath,
        datetime = Date().time,
        label = parts.filterIsInstance<PartData.FormItem>().first { it.name == "label" }.value,
        type = ResourceType.valueOf(parts.filterIsInstance<PartData.FormItem>().first { it.name == "type" }.value),
        accessType = AccessType.valueOf(parts.filterIsInstance<PartData.FormItem>().first { it.name == "accessType" }.value),
        groupId = parts.filterIsInstance<PartData.FormItem>().first { it.name == "groupId" }.value
    )
}

suspend fun InputStream.copyToSuspend(
    out: OutputStream,
    bufferSize: Int = DEFAULT_BUFFER_SIZE,
    yieldSize: Int = 4 * 1024 * 1024,
    dispatcher: CoroutineDispatcher = Dispatchers.IO
): Long {
    return withContext(dispatcher) {
        val buffer = ByteArray(bufferSize)
        var bytesCopied = 0L
        var bytesAfterYield = 0L
        while (true) {
            val bytes = read(buffer).takeIf { it >= 0 } ?: break
            out.write(buffer, 0, bytes)
            if (bytesAfterYield >= yieldSize) {
                yield()
                bytesAfterYield %= yieldSize
            }
            bytesCopied += bytes
            bytesAfterYield += bytes
        }
        return@withContext bytesCopied
    }
}