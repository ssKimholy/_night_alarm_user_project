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
import java.time.ZoneId
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter

class HealthConnectManager(context: Context) {
    private val healthConnectClient = HealthConnectClient.getOrCreate(context)

    suspend fun fetchSleepDataAsJsonArray(): JSONArray = withContext(Dispatchers.IO) {
        val jsonArray = JSONArray()
        try {
            val start = Instant.now().minusSeconds(86400) // Last 24 hours
            val end = Instant.now()
            val request = ReadRecordsRequest(
                recordType = SleepSessionRecord::class,
                timeRangeFilter = TimeRangeFilter.between(start, end)
            )
            val records = healthConnectClient.readRecords(request).records

            records.forEach { record ->
                val jsonObject = JSONObject().apply {
                    // Format time in KST (UTC+9)
                    val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                    val startTimeKST = ZonedDateTime.ofInstant(record.startTime, ZoneId.of("Asia/Seoul"))
                    val endTimeKST = ZonedDateTime.ofInstant(record.endTime, ZoneId.of("Asia/Seoul"))

                    put("start", formatter.format(startTimeKST))
                    put("end", formatter.format(endTimeKST))
                    put("title", record.title ?: "No title")
                    put("notes", record.notes ?: "No notes")
                    put("dataOrigin", record.metadata.dataOrigin.packageName)

                    // Calculate sleep duration in hours
                    val sleepDuration = record.endTime.epochSecond - record.startTime.epochSecond
                    put("duration_hours", sleepDuration / 3600)

                    // Add sleep stages if available
                    val stagesArray = JSONArray()
                    record.stages.forEach { stage ->
                        val stageJson = JSONObject().apply {
                            put("stage", stage.stage.toString())
                            put(
                                "start",
                                formatter.format(ZonedDateTime.ofInstant(stage.startTime, ZoneId.of("Asia/Seoul")))
                            )
                            put(
                                "end",
                                formatter.format(ZonedDateTime.ofInstant(stage.endTime, ZoneId.of("Asia/Seoul")))
                            )
                        }
                        stagesArray.put(stageJson)
                    }
                    put("stages", stagesArray)

                    // Infer sleep quality based on deep sleep percentage
                    val deepSleepDuration = record.stages
                        .filter { it.stage == SleepSessionRecord.STAGE_TYPE_DEEP }
                        .sumOf { it.endTime.epochSecond - it.startTime.epochSecond }
                    put("deep_sleep_hours", deepSleepDuration / 3600)

                    val quality = when {
                        deepSleepDuration / sleepDuration > 0.2 -> "Good"
                        else -> "Poor"
                    }
                    put("sleep_quality", quality)
                }
                jsonArray.put(jsonObject)
            }
        } catch (e: Exception) {
            Log.e("HealthConnectManager", "Error fetching sleep data", e)
        }
        jsonArray
    }

    suspend fun fetchAndSaveSleepData() = withContext(Dispatchers.IO) {
        val sleepData = fetchSleepDataAsJsonArray()
        uploadDataToFirebase(sleepData)
    }

    private fun uploadDataToFirebase(data: JSONArray) {
        val firebaseDb = FirebaseDatabase.getInstance()
        val ref = firebaseDb.getReference("sleep_data")

        val dataList = mutableListOf<Map<String, Any?>>()
        for (i in 0 until data.length()) {
            val jsonObject = data.getJSONObject(i)
            val map = jsonObject.keys().asSequence().associateWith { jsonObject[it] }
            dataList.add(map)
        }

        ref.setValue(dataList).addOnSuccessListener {
            Log.d("HealthConnectManager", "Data successfully uploaded to Firebase.")
        }.addOnFailureListener { e ->
            Log.e("HealthConnectManager", "Error uploading data to Firebase", e)
        }
    }
}
