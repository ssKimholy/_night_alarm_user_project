// user_service.dart
import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/models/user_element.dart';
import 'package:_night_sleep_user/models/weekly_survey_element.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  UserElement? _user;

  void registerUser(String userName, int userId, String userPassword,
      String type, String userDevicecode, List<ChatElement> chatList) {
    _user = UserElement(
      userName: userName,
      userId: userId,
      userPassword: userPassword,
      type: type,
      userDeviceCode: userDevicecode,
      chatList: chatList, // 초기화된 채팅 목록
      weeklySurvey: WeeklySurveyElement(answer: {
        1: [-1, -1, -1],
        2: [-1, -1, -1],
        3: [-1, -1, -1],
        4: [-1, -1, -1],
        5: [-1, -1, -1]
      }),
      // 초기화된 설문 목록
      experimentWeek: 1, // 초기 주차
    );
  }

  Future<void> setLoggedInfo(int userId, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("userId", userId);
    await prefs.setBool("isLoggedIn", value);
  }

  Future<int> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn") == null) {
      return -1;
    }

    if (prefs.getBool("isLoggedIn")!) {
      return prefs.getInt("userId")!;
    } else {
      return -1;
    }
  }

  UserElement? get user => _user;

  bool isRegistered() {
    return _user != null;
  }
}
