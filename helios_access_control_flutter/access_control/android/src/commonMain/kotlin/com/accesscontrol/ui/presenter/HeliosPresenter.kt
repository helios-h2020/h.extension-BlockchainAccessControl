package com.accesscontrol.ui.presenter


import com.accesscontrol.datasource.AccessControl
import com.accesscontrol.ui.error.ErrorHandlerInterface
import com.accesscontrol.ui.executor.Executor

class HeliosPresenter(
    private val accessControl: AccessControl,
    errorHandler: ErrorHandlerInterface,
    executor: Executor,
    view: HeliosView
) : Presenter<HeliosView>(errorHandler, executor, view) {

    override fun attach() {
        TODO("Not yet implemented")
    }

    override fun createAccessRequest(f: Any) {
        TODO("Not yet implemented")
    }


    /*
    private var user: User? = null

    override fun attach() {
        getUser {
            getIssues()

        }
    }

    private fun getUser(f: () -> Unit) {
        scope.launch {
            execute { repository.getUser() }.fold(
                error = { onRetry(it) { getUser(f) } },
                success = {
                    user = it
                    f()
                }
            )
        }
    }

    private fun getIssues() {
        view.showProgress()
        scope.launch {
            val issueStatuses = when (view.getBidStatus()) {
                Bid.Status.APPLIED -> listOf(Issue.Status.BID)
                else -> listOf(Issue.Status.IN_PROGRESS, Issue.Status.DONE, Issue.Status.USER_REPAIRED)
            }

            withContext(executor.io) {
                when (view.getBidStatus() != Bid.Status.LOST) {
                    true -> getActiveBids(issueStatuses)
                    false -> getLostBids()
                }
            }
        }
    }

    private suspend fun getActiveBids(statuses: List<Issue.Status>) {
        repository.getIssues(statuses, currentUser = false).collect {
            withContext(executor.main) {
                if (it is Either.Right) {
                    view.clearList()
                    it.success.forEach { getIssueBids(it) }
                }
                view.hideProgress()
            }
        }
    }

    private suspend fun getLostBids() {
        repository.getBids(view.getBidStatus(), currentUser = true).collect {
            withContext(executor.main) {
                if (it is Either.Right) {
                    view.clearList()
                    it.success.forEach { view.showIssue(it.issue, listOf(it)) }
                }
                view.hideProgress()
            }
        }
    }

    private fun getIssueBids(issue: Issue) {
        scope.launch {
            view.showProgress()
            withContext(executor.io) {
                repository.getIssueBids(issue, view.getBidStatus()).collect {
                    withContext(executor.main) {
                        if (it is Either.Right) {
                            view.showIssue(issue, it.success.map { it.copy(currentUser = user?.id == it.user.id) })
                        }
                        view.hideProgress()
                    }
                }
            }
        }
    }

    fun onApplyBidClick(issue: Issue, bid: Bid?) {
        view.showAddBid(issue, bid)
    }



    private fun createRequest(token: String, id: String, url: String){
        scope.launch {
            execute { accessControl.createAccessRequest(url) }.fold(
                error = { onRetry(it) { createAccessRequest(url) } },
                success = {
                    createAccessRequest(url)
                }
            )
        }
    }
*/
}

interface HeliosView : Presenter.View {
    fun createRequest(token: String, id: String, url: String)
}
