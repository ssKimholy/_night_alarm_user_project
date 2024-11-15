import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Save sleep data to Firebase Realtime Database
  Future<void> saveSleepData(
      String userId, List<Map<String, dynamic>> sleepData) async {
    try {
      final userSleepRef = _database.child('users/$userId/sleepData');
      for (var record in sleepData) {
        await userSleepRef.push().set(record);
      }
      print("Sleep data saved successfully.");
    } catch (e) {
      print("Error saving sleep data: $e");
    }
  }
}
