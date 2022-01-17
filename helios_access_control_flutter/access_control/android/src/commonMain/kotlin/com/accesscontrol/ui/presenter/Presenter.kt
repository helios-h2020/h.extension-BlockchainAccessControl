package com.accesscontrol.ui.presenter

import com.accesscontrol.domain.Either
import com.accesscontrol.ui.executor.Executor
import com.accesscontrol.domain.Error
import com.accesscontrol.ui.error.ErrorHandlerInterface
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.withContext

/**
 * Presenter
 */
abstract class Presenter<out V : Presenter.View>(
    protected val errorHandler: ErrorHandlerInterface,
    protected val executor: Executor,
    val view: V
) {

    private val job = SupervisorJob()

    protected val scope = CoroutineScope(job + executor.main)

    // protected fun onRetry(error: Error, retry: () -> Unit) {
    //     view.showRetry(errorHandler.convert(error)) { retry() }
    // }
//
    // protected fun onError(error: Error) {
    //     view.showError(errorHandler.convert(error))
    // }

    protected suspend fun <R> execute(f: suspend () -> Either<Error, R>): Either<Error, R> =
        withContext(executor.io) { f() }

    protected suspend fun <R> executeFlow(f: suspend () -> Flow<Either<Error, R>>): Flow<Either<Error, R>> =
        withContext(executor.io) { f() }

    abstract fun attach()

    fun detach() = job.cancel()

    abstract fun createAccessRequest(f: Any)

    interface View {
        fun showRetry(error: String, f: () -> Unit)
        fun showError(error: String)
    }
}
