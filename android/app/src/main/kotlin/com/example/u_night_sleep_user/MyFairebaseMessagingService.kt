package com.example.u_night_sleep_user

import android.content.Intent
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)

        Log.e("FCM", "Message received: ${remoteMessage.notification?.title}")

        // Directly start the MainActivity with a route to AlarmScreen
        val intent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            putExtra("route", "/alarmPage") // Pass route for AlarmScreen
        }
        startActivity(intent)
    }
}
