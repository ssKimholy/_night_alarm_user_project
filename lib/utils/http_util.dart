import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
}
