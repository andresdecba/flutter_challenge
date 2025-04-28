//package com.example.flutter_challenge

//import io.flutter.embedding.android.FlutterActivity

//class MainActivity: FlutterActivity()


package com.example.flutter_challenge

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import okhttp3.*
import org.json.JSONArray
import java.io.IOException

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.flutter_challenge/comments"
    private val client = OkHttpClient()

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getComments") {
                val postId = call.argument<Int>("postId") ?: 0
                fetchComments(postId, result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun fetchComments(postId: Int, result: MethodChannel.Result) {
        val url = "https://jsonplaceholder.typicode.com/comments?postId=$postId"

        val request = Request.Builder()
            .url(url)
            .build()

        client.newCall(request).enqueue(object: Callback {
            override fun onFailure(call: Call, e: IOException) {
                result.error("NETWORK_ERROR", "Failed to fetch comments", e.message)
            }

            override fun onResponse(call: Call, response: Response) {
                response.use {
                    if (!it.isSuccessful) {
                        result.error("HTTP_ERROR", "Unexpected response", null)
                        return
                    }

                    val body = it.body?.string()
                    if (body != null) {

                        val jsonArray = JSONArray(body)
                        val comments = mutableListOf<Map<String, Any>>()

                        for (i in 0 until jsonArray.length()) {
                            val item = jsonArray.getJSONObject(i)
                            val comment = mapOf(
                                "id" to item.getInt("id"),
                                "name" to item.getString("name"),
                                "email" to item.getString("email"),
                                "body" to item.getString("body")
                            )
                            comments.add(comment)
                        }

                        runOnUiThread {
                            result.success(body)
                        }
                    } else {
                        result.error("NO_BODY", "Response body is null", null)
                    }
                }
            }
        })
    }
}

