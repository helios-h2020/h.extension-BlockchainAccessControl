package com.worldline.androidsample

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.Spinner
import androidx.appcompat.app.AppCompatActivity
import com.accesscontrol.ui.presenter.HeliosView
import com.accesscontrol.ui.presenter.Presenter
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity<out V : Presenter.View> : AppCompatActivity(), HeliosView {

    companion object {
        fun intent(context: Context) = Intent(context, MainActivity::class.java)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        val owner: String = owner.text.toString()

        // GlobalScope.launch {
        //     val request = AccessControl().checkAccessRequest(
        //         owner = "0x339913B110126030D636FFeA4D9a70DE42F7D559",
        //         uri = "fdfdfd",
        //         accessKey = "0x339913B110126030D636FFeA4D9a70DE42F7D559"
        //     )
        //     print("result: $request")
        // }


        createRequest.setOnClickListener {
            val spinner: String = spinnerToken().toString()
            val id: String = id.text.toString()
            val url: String = url.text.toString()

            createRequest(spinner, id, url)
        }
    }

    private fun spinnerToken(): Spinner {
        val spinner: Spinner = findViewById(R.id.spinnerToken)
        ArrayAdapter.createFromResource(
            this,
            R.array.spinnerToken,
            android.R.layout.simple_spinner_item
        ).also { adapter ->
            adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
            spinner.adapter = adapter
        }
        return spinner
    }

    override fun showError(error: String) {
        TODO("Not yet implemented")
    }

    override fun createRequest(token: String, id: String, url: String) {
        TODO("Not yet implemented")
    }

    override fun showRetry(error: String, f: () -> Unit) {
        TODO("Not yet implemented")
    }
}
