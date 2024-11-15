package com.example.u_night_sleep_user

import android.content.Context
import android.util.Log
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.records.SleepSessionRecord
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import com.google.firebase.database.FirebaseDatabase
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject
import java.time.Instant

class HealthConnectManager(context: Context) {
    private val healthConnectClient = HealthConnectClient.getOrCreate(context)

    suspend fun fetchAndSaveSleepData() = withContext(Dispatchers.IO) {
        try {
            val start = Instant.now().minusSeconds(86400) // Last 24 hours
            val end = Instant.now()

            val timeRangeFilter = TimeRangeFilter.between(start, end)
            val request = ReadRecordsRequest(
                recordType = SleepSessionRecord::class,
                timeRangeFilter = timeRangeFilter
            )

            val records = healthConnectClient.readRecords(request).records
            Log.d("HealthConnectManager", "Fetched ${records.size} sleep records.")

            val jsonArray = JSONArray()
            records.forEach { record ->
                val jsonObject = JSONObject().apply {
                    put("start", record.startTime.toString())
                    put("end", record.endTime.toString())
                    put("title", record.title ?: "No title")
                    put("notes", record.notes ?: "No notes")
                    put("dataOrigin", record.metadata.dataOrigin.packageName)
                }
                jsonArray.put(jsonObject)
            }

            uploadDataToFirebase(jsonArray)
        } catch (e: Exception) {
            Log.e("HealthConnectManager", "Error fetching sleep data", e)
        }
    }

    private fun uploadDataToFirebase(data: JSONArray) {
        val firebaseDb = FirebaseDatabase.getInstance()
        val ref = firebaseDb.getReference("sleep_data")
        ref.setValue(data.toString()).addOnSuccessListener {
            Log.d("HealthConnectManager", "Sleep data uploaded to Firebase.")
        }.addOnFailureListener { e ->
            Log.e("HealthConnectManager", "Error uploading sleep data", e)
        }
    }
}
