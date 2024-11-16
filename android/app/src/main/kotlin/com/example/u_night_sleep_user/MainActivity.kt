package com.example.u_night_sleep_user

import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.PowerManager
import android.util.Log
import android.view.WindowManager
import androidx.activity.result.contract.ActivityResultContracts
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
import java.util.concurrent.TimeUnit

class MainActivity : FlutterFragmentActivity() {
    private lateinit var healthConnectClient: HealthConnectClient
    private var sleepDataJson: String? = null // Cached sleep data

    companion object {
        private const val TAG = "MainActivity"
        private const val CHANNEL = "com.example.alarmcare/channel"
        private const val WORK_MANAGER_TAG = "FetchSleepData"

        fun turnOnScreen(context: Context) {
            val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            val wakeLock = pm.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
                "app:alarmWakeLock"
            )
            wakeLock.acquire(3000)

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

        lifecycleScope.launch {
            if (requestHealthPermissions()) {
                fetchSleepData()
//                scheduleWorkManager()
            } else {
                Log.e(TAG, "Health Connect permissions not granted.")
            }
        }
    }

    private val permissionLauncher = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->
        if (result.resultCode == RESULT_OK) {
            Log.d(TAG, "Permissions granted.")
            lifecycleScope.launch {
                val grantedPermissions = healthConnectClient.permissionController.getGrantedPermissions()
                Log.d(TAG, "Granted permissions: $grantedPermissions")
                fetchSleepData()
            }
        } else {
            Log.e(TAG, "Permissions denied by the user.")
            showPermissionDeniedDialog()
        }
    }

    private fun showPermissionDeniedDialog() {
        AlertDialog.Builder(this)
            .setTitle("권한 필요")
            .setMessage("수면 데이터를 동기화하려면 Health Connect 권한이 필요합니다. 설정에서 권한을 활성화하세요.")
            .setPositiveButton("설정으로 이동") { _, _ ->
                try {
                    val intent = HealthConnectClient.getHealthConnectManageDataIntent(this)
                    startActivity(intent)
                } catch (e: Exception) {
                    Log.e(TAG, "Error opening Health Connect settings", e)
                }
            }
            .setNegativeButton("취소", null)
            .show()
    }

    private fun isHealthConnectAvailable(context: Context): Boolean {
        val status = HealthConnectClient.getSdkStatus(context)
        return when (status) {
            HealthConnectClient.SDK_AVAILABLE -> true
            else -> false
        }
    }

//    private fun scheduleWorkManager() {
//        val constraints = Constraints.Builder()
//            .setRequiredNetworkType(NetworkType.CONNECTED)
//            .build()
//
//        val periodicWorkRequest = PeriodicWorkRequestBuilder<BackgroundTaskWorker>(
//            24, TimeUnit.HOURS
//        )
//            .setConstraints(constraints)
//            .addTag(WORK_MANAGER_TAG)
//            .build()
//
//        WorkManager.getInstance(applicationContext).enqueue(periodicWorkRequest)
//        Log.d(TAG, "WorkManager task scheduled.")
//    }

    private suspend fun requestHealthPermissions(): Boolean {
        val permissions = setOf(
            HealthPermission.getReadPermission(SleepSessionRecord::class),
            HealthPermission.getWritePermission(SleepSessionRecord::class)
        )

        val grantedPermissions = healthConnectClient.permissionController.getGrantedPermissions()
        if (permissions.all { it in grantedPermissions }) return true

        try {
            val intent = HealthConnectClient.getHealthConnectManageDataIntent(this)
            permissionLauncher.launch(intent)
        } catch (e: Exception) {
            Log.e(TAG, "Error requesting permissions", e)
            return false
        }
        return false
    }

    private suspend fun fetchSleepData() {
        try {
            val manager = HealthConnectManager(this)
            val sleepDataArray = manager.fetchSleepDataAsJsonArray()
            sleepDataJson = sleepDataArray.toString()
            Log.d(TAG, "Fetched sleep data: $sleepDataJson")
        } catch (e: Exception) {
            Log.e(TAG, "Error fetching sleep data", e)
        }
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
                        if (sleepDataJson != null) {
                            result.success(sleepDataJson)
                        } else {
                            result.error("NO_DATA", "No sleep data available", null)
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
