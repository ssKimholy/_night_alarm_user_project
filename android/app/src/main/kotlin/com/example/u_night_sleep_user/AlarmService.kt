package com.example.u_night_sleep_user

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.util.Log
import androidx.core.app.NotificationCompat

class AlarmService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("AlarmService", "Starting AlarmService in Foreground")

        // 포어그라운드 서비스로 실행하여 알림 표시
        val channelId = "alarm_service_channel"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationChannel = NotificationChannel(
                channelId, "Alarm Service Channel", NotificationManager.IMPORTANCE_HIGH
            )
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(notificationChannel)
        }

        val notification: Notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Alarm Active")
            .setContentText("Tap to open the alarm screen")
            .build()

        startForeground(1, notification)

        // WakeLock을 사용하여 화면을 깨우고 유지
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
            "app:alarmWakeLock"
        )
        wakeLock.acquire(5000) // 5초 동안 유지

        // MainActivity를 호출하여 화면 활성화
        val mainActivityIntent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            putExtra("route", "/alarmPage")
        }
        startActivity(mainActivityIntent)

        stopForeground(true)
        stopSelf()

        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
