import 'package:flutter/services.dart';
import 'dart:convert';

class SleepService {
  static const platform = MethodChannel('com.example.alarmcare/channel');

  static Future<List<Map<String, dynamic>>> getSleepData() async {
    try {
      final String jsonData = await platform.invokeMethod('getSleepData');
      final List<dynamic> parsedData = json.decode(jsonData);
      print('data: $parsedData');

      // Convert each JSON object into a Map<String, dynamic>
      return parsedData.cast<Map<String, dynamic>>();
    } on PlatformException catch (e) {
      print('Failed to fetch sleep data: ${e.message}');
      return [];
    }
  }
}
