import 'package:_night_sleep_user/firebase_options.dart';
import 'package:_night_sleep_user/utils/date_time_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://alarmcare-3eb10-default-rtdb.asia-southeast1.firebasedatabase.app/')
      .ref();

  // Save sleep data to Firebase Realtime Database
  Future<void> saveSleepData(
      String userId, List<Map<String, dynamic>> sleepData) async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      print('im here');
      final userSleepRef = _database.child('users/$userId/sleep_data');
      print('Firebase reference: $userSleepRef');
      for (var record in sleepData) {
        await userSleepRef.child(DateTimeUtils.formatCurrentTime()).set(record);
      }
      print("Sleep data saved successfully to Firebase.");
    } catch (e) {
      print("Error saving sleep data to Firebase: $e");
    }
  }
}
