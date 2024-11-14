import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/models/weekly_survey_element.dart';

class UserElement {
  String userName;
  int userId;
  String userPassword;
  String type;
  String userDeviceCode;
  List<ChatElement> chatList;
  List<WeeklySurveyElement> weeklySurveyList;
  int experimentWeek;
  bool isCompletedWeeklySurvey;

  UserElement(
      {required this.userName,
      required this.userId,
      required this.userPassword,
      required this.type,
      required this.userDeviceCode,
      required this.chatList,
      required this.weeklySurveyList,
      required this.experimentWeek,
      required this.isCompletedWeeklySurvey});

  String get getUserName => userName;
  int get getUserId => userId;
  String get getUserType => type;
  String get getUserDeviceCode => userDeviceCode;
  List<ChatElement> get getChatList => chatList;
  int get getExperimentWeek => experimentWeek;
  List<WeeklySurveyElement> get getWeeklySurveyList => weeklySurveyList;

  void setUserDeviceCode(String devicecode) {
    userDeviceCode = devicecode;
  }
}
