import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatCurrentTime() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  static String convertToChatTime(String rawTime) {
    // 입력 rawTime dateTime 객체 파싱
    DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(rawTime);
    // 현재 날짜
    DateTime now = DateTime.now();

    // 날짜 비교위해 새로운 DateTime 객체 생성
    DateTime inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    DateTime today = DateTime(now.year, now.month, now.day);

    // 날짜 비교
    if (inputDate == today) {
      // 날짜가 오늘이라면 time 파싱
      return DateFormat("a h:mm", "ko-KR").format(dateTime);
    } else {
      // 오늘이 아니라면 날짜만 return
      return DateFormat("yyyy-MM-dd").format(dateTime);
    }
  }

  static String dateTimeToString(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
  }

  static String convertKorTime(String time) {
    DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm').parse(time);

    return DateFormat('a h:mm', "ko-KR").format(dateTime);
  }

  static String convertDateToWeek(String dateString) {
    DateTime datetime = DateFormat('yyyy-MM-dd').parse(dateString);

    List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];

    return weekdays[datetime.weekday - 1];
  }
}
