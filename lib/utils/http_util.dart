import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class HttpUtil {
  static final String URL = dotenv.env['SERVER_IP']!;

  static Future<void> registerUser(String userPw, String userName,
      String userType, String userDeviceKey) async {
    final response = await http.post(
      Uri.parse('$URL/user/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "userName": userName,
        "userType": userType,
        "password": userPw,
        "deviceKey": userDeviceKey,
      }),
    );

    if (response.statusCode == 200) {
      print('success!!');
      return;
    } else {
      print(response.statusCode);
      throw Exception('Fail to register');
    }
  }

  static Future<Map<String, dynamic>> loginUser(
      String userName, String userPw) async {
    final response = await http.get(
      Uri.parse('$URL/login?userName=$userName&password=$userPw'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Fail to login');
    }
  }

  static Future<Map<String, dynamic>> getUserInfo(int id) async {
    final response = await http.get(
      Uri.parse('$URL/user/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Fail to login');
    }
  }

  static Future<List<dynamic>> getUserChatList(int id) async {
    final response =
        await http.get(Uri.parse('$URL/chat/$id'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Fail to login');
    }
  }

  static Future<void> setFirstWatching(int chatId) async {
    final response = await http.post(
        Uri.parse('$URL/chat/play/${chatId.toString()}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Fail to login');
    }
  }

  static Future<void> setDailySurveyAnswer(
      int chatId, String a_1, String a_2) async {
    final response = await http.post(
      Uri.parse('$URL/answer/$chatId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "answer1": a_1.toString(),
        "answer2": a_2.toString(),
      }),
    );

    if (response.statusCode == 200) {
      print('success!!');
      return;
    } else {
      print(response.statusCode);
      throw Exception('Fail to register');
    }
  }

  static Future<void> setImmediatelyChecked(int chatId) async {
    final response = await http.post(
      Uri.parse('$URL/chat/${chatId.toString()}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('success immeduatelyChecked!!');
      return;
    } else {
      print(response.statusCode);
      throw Exception('Fail to immediatelyChecked!');
    }
  }

  static Future<String> playVoiceMessage(int contentId) async {
    Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/${contentId.toString()}.mp3';
    final File file = File(filePath);

    if (!await file.exists()) {
      try {
        var dio = Dio();

        final response = await dio.download(
            '$URL/chat/content/${contentId.toString()}', filePath);

        print('status: ${response.statusCode}');
      } catch (e) {
        print('Failed to download file: $e');
      }
    }

    return filePath;
  }

  static Future<String> playVideoMessage(int contentId) async {
    Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/${contentId.toString()}.mp4';
    final File file = File(filePath);

    if (!await file.exists()) {
      try {
        var dio = Dio();

        final response = await dio.download(
            '$URL/chat/content/${contentId.toString()}', filePath);

        print('status: ${response.statusCode}');
      } catch (e) {
        print('Failed to download file: $e');
      }
    }

    return filePath;
  }

  static Future<void> setWeeklySurveyResult(
      int userId, List<int> answerList) async {
    final response = await http.post(
        Uri.parse('$URL/weekSurvey/complete/${userId.toString()}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "survey1": answerList[0].toString(),
          "survey2": answerList[1].toString(),
          "survey3": answerList[2].toString(),
        }));

    if (response.statusCode == 200) {
      print('success weeklySurveyResult!!');
      return;
    } else {
      print(response.statusCode);
      throw Exception('Fail to weeklySurveyResult!!');
    }
  }
}
