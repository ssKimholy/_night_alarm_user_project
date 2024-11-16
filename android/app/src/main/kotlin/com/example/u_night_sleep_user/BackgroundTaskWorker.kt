package com.example.u_night_sleep_user

import android.content.Context
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters

class BackgroundTaskWorker(
    appContext: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(appContext, workerParams) {

    override suspend fun doWork(): Result {
        return try {
            val manager = HealthConnectManager(applicationContext)
            manager.fetchAndSaveSleepData()
            Log.d("BackgroundTaskWorker", "Sleep data fetch and upload complete.")
            Result.success()
        } catch (e: Exception) {
            Log.e("BackgroundTaskWorker", "Error during background task", e)
            Result.failure()
        }
    }
}
