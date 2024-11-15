import 'dart:convert';
import 'package:flutter/services.dart';

class SleepService {
  static const MethodChannel _channel =
      MethodChannel('com.example.alarmcare/channel');

  // Fetch sleep data from Health Connect
  static Future<List<Map<String, dynamic>>> getSleepData() async {
    print('getSleepData execute');
    try {
      print('infrontof channel invoke');
      final String jsonData = await _channel.invokeMethod('getSleepData');
      // Parse the JSON string into a list of maps
      List<dynamic> parsedData = json.decode(jsonData);

      print('after channel invoke');

      // Convert each JSON object in the list to Map<String, dynamic>
      List<Map<String, dynamic>> sleepData =
          parsedData.cast<Map<String, dynamic>>();

      print('sleep Data: $sleepData');
      return sleepData;
    } catch (e) {
      print("Error fetching sleep data: $e");
      return [];
    }
  }
}
