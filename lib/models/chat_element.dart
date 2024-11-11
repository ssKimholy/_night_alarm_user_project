import 'package:_night_sleep_user/models/chat_body_element.dart';

class ChatElement {
  final String chatType;
  final String chatDay;
  final ChatBodyElement chatBody;
  List<int> answerList;

  ChatElement({
    required this.chatType,
    required this.chatDay,
    required this.chatBody,
    required this.answerList,
  });

  String get getChatType => chatType;
  String get getChatDay => chatDay;
  ChatBodyElement get getChatBody => chatBody;
  bool get getIsComplete => !answerList.contains(-1);
}
