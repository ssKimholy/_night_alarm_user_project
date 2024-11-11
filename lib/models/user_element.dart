import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/models/weekly_survey_element.dart';

class UserElement {
  String userName;
  int userId;
  String userPassword;
  String type;
  String userDeviceCode;
  List<ChatElement> chatList;
  WeeklySurveyElement weeklySurvey;
  int experimentWeek;

  UserElement({
    required this.userName,
    required this.userId,
    required this.userPassword,
    required this.type,
    required this.userDeviceCode,
    required this.chatList,
    required this.weeklySurvey,
    required this.experimentWeek,
  });

  String get getUserName => userName;
  int get getUserId => userId;
  String get getUserType => type;
  String get getUserDeviceCode => userDeviceCode;
  List<ChatElement> get getChatList => chatList;
  int get getExperimentWeek => experimentWeek;
  WeeklySurveyElement get getWeeklySurvey => weeklySurvey;

  List<int> getWeeklySurveyList(int week) {
    return weeklySurvey.getAnswer(week);
  }

  void setUserDeviceCode(String devicecode) {
    userDeviceCode = devicecode;
  }
}
