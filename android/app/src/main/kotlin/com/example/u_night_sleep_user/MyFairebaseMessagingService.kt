package com.example.u_night_sleep_user

import android.content.Intent
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)

        Log.e("FCM", "Message received: ${remoteMessage.notification?.body}")

        // Convert data map to a String for logging
        val dataEntriesAsString = remoteMessage.data.entries.joinToString(", ") { "${it.key}=${it.value}" }
        Log.e("FCM", "Data entries: $dataEntriesAsString")

        // Pass FCM data and route information to MainActivity via Intent extras
        val intent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            putExtra("route", "/alarmPage") // Pass route for AlarmScreen
            remoteMessage.data.forEach { (key, value) -> // Add each data entry as extra
                putExtra(key, value)
            }
        }
        startActivity(intent)
    }
}
