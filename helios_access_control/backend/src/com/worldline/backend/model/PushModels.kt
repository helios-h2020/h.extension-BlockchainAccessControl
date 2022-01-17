package com.worldline.backend.model

data class Push(val message: Message)

data class Message(val to: String, val notification: Notification)

data class Notification(val body: String, val title: String)