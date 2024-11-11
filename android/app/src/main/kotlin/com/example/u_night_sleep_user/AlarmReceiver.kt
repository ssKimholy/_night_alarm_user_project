package com.example.u_night_sleep_user

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class AlarmReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        Log.e("AlarmReceiver", "Alarm received!")

        // 화면을 깨우고 MainActivity를 호출
        MainActivity.turnOnScreen(context)
    }
}
