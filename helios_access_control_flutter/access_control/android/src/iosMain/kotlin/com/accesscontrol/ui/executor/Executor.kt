package com.accesscontrol.ui.executor

actual class Executor {
    actual val main: kotlinx.coroutines.CoroutineDispatcher
        get() = TODO("Not yet implemented")
    actual val io: kotlinx.coroutines.CoroutineDispatcher
        get() = TODO("Not yet implemented")
}