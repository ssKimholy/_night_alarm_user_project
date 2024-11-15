package com.example.u_night_sleep_user

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.PowerManager
import android.util.Log
import android.view.WindowManager
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.SleepSessionRecord
import androidx.lifecycle.lifecycleScope
import androidx.work.Constraints
import androidx.work.NetworkType
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import java.time.Instant
import java.util.concurrent.TimeUnit

class MainActivity : FlutterFragmentActivity() {
    private lateinit var healthConnectClient: HealthConnectClient

    companion object {
        private const val TAG = "MainActivity"
        private const val WORK_MANAGER_TAG = "FetchSleepData"
        private const val CHANNEL = "com.example.alarmcare/channel"

        // Function to turn on the screen for alarm purposes
        fun turnOnScreen(context: Context) {
            val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            val wakeLock = pm.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
                "app:alarmWakeLock"
            )
            wakeLock.acquire(3000) // Acquire for 3 seconds

            val intent = Intent(context, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                putExtra("route", "/alarmPage")
            }
            context.startActivity(intent)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Check Health Connect availability
        if (!isHealthConnectAvailable(this)) {
            Log.e(TAG, "Health Connect is not available on this device.")
            return
        }

        healthConnectClient = HealthConnectClient.getOrCreate(this)

        // Keep screen on for the app
        window.addFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
        )

        // Schedule background task with WorkManager
        scheduleWorkManager()
    }

    // Check if Health Connect is available
    private fun isHealthConnectAvailable(context: Context): Boolean {
        val status = HealthConnectClient.getSdkStatus(context)
        return when (status) {
            HealthConnectClient.SDK_AVAILABLE -> {
                Log.d(TAG, "Health Connect SDK is available.")
                true
            }
            HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED -> {
                Log.e(TAG, "Health Connect provider requires an update.")
                false
            }
            else -> {
                Log.e(TAG, "Health Connect is unavailable.")
                false
            }
        }
    }

    // Schedule periodic work with WorkManager
    private fun scheduleWorkManager() {
        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED) // Requires internet
            .build()

        val periodicWorkRequest = PeriodicWorkRequestBuilder<BackgroundTaskWorker>(
            24, TimeUnit.HOURS // Run every 24 hours
        )
            .setConstraints(constraints)
            .addTag(WORK_MANAGER_TAG)
            .build()

        WorkManager.getInstance(applicationContext).enqueue(periodicWorkRequest)
        Log.d(TAG, "WorkManager task scheduled.")
    }

    // Request permissions for Health Connect
    private suspend fun requestHealthPermissions(): Boolean {
        val permissions = setOf(
            HealthPermission.getReadPermission(SleepSessionRecord::class),
            HealthPermission.getWritePermission(SleepSessionRecord::class)
        )

        Log.d(TAG, "Requesting permissions for: $permissions")

        val grantedPermissions = healthConnectClient.permissionController.getGrantedPermissions()
        Log.d(TAG, "Currently granted permissions: $grantedPermissions")

        if (permissions.all { it in grantedPermissions }) {
            Log.d(TAG, "All permissions are already granted.")
            return true
        }

        try {
            val intent = HealthConnectClient.getHealthConnectManageDataIntent(this)
            startActivity(intent)
        } catch (e: Exception) {
            Log.e(TAG, "Error requesting permissions", e)
            return false
        }

        return false
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getRoute" -> {
                        val route = intent.getStringExtra("route") ?: "/"
                        val data = mutableMapOf<String, String>()
                        intent.extras?.keySet()?.forEach { key ->
                            intent.getStringExtra(key)?.let { value ->
                                data[key] = value
                            }
                        }
                        data["route"] = route
                        result.success(data)
                    }
                    "getSleepData" -> {
                        val start = Instant.now().minusSeconds(86400)
                        val end = Instant.now()

                        Log.d("MainActivity", "Flutter invoked getSleepData")

                        lifecycleScope.launch {
                            try {
                                if (requestHealthPermissions()) {
                                    Log.d("MainActivity", "Health permissions granted")
                                    val manager = HealthConnectManager(this@MainActivity)
                                    val dataJson = manager.fetchAndSaveSleepData()
                                    Log.d("MainActivity", "Sleep data fetched: $dataJson")
                                    result.success(dataJson)
                                } else {
                                    Log.d("MainActivity", "Health permissions not granted")
                                    result.error("PERMISSION_DENIED", "Health permissions not granted", null)
                                }
                            } catch (e: Exception) {
                                Log.e("MainActivity", "Error in getSleepData", e)
                                result.error("ERROR", e.message, null)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }
}
