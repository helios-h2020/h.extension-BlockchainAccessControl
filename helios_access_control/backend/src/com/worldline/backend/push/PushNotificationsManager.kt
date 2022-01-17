package com.worldline.backend.push

import com.worldline.backend.model.Message
import com.worldline.backend.model.Notification
import com.worldline.backend.model.Push
import com.worldline.backend.strings.Strings
import io.ktor.client.*
import io.ktor.client.features.json.*
import io.ktor.client.features.logging.*
import io.ktor.client.request.*
import io.ktor.http.*

object PushNotificationsManager {

    private const val FCM_ENDPOINT = "https://fcm.googleapis.com/fcm/send";
    private const val FCM_TOKEN =
        "AAAAdALFH4I:APA91bGSLOuBBw6lqDIZEtaxpXGD25kt3WIEjWlwYVqmt1iGoBOkDQMKuLDegPEq-t-O4Xq8VREYLiL336BuAHW_w_vIha05SA9oNfn4Ah8oYWrx2COnj1SCRrwtyI_9-36_ktkskjjI"

    suspend fun push(to: String, content: String) {
        val client = HttpClient {
            install(JsonFeature) {
                serializer = GsonSerializer()
            }
            install(Logging) {
            }
        }

        val push = Push(Message(to = to, notification = Notification(title = Strings.PUSH_TITLE, body = content)))

        println(push)

        client.post<String>(FCM_ENDPOINT) {
            header(
                HttpHeaders.Authorization,
                "key=$FCM_TOKEN"
            )
            contentType(ContentType.Application.Json)
            body = push.message
        }
    }
}