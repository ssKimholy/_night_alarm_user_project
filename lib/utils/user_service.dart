// user_service.dart
import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/models/user_element.dart';
import 'package:_night_sleep_user/models/weekly_survey_element.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  UserElement? _user;

  void registerUser(
      String userName,
      int userId,
      String userPassword,
      String type,
      String userDevicecode,
      bool isCompletedWeeklySurvey,
      List<ChatElement> chatList,
      List<WeeklySurveyElement> weeklySurveyList) {
    _user = UserElement(
      userName: userName,
      userId: userId,
      userPassword: userPassword,
      type: type,
      isCompletedWeeklySurvey: isCompletedWeeklySurvey,
      userDeviceCode: userDevicecode,
      chatList: chatList,
      weeklySurveyList: weeklySurveyList,
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
