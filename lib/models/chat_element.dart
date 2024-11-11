class ChatElement {
  final int chatId;
  final String chatType;
  final String chatDay;
  final String content;
  List<String> answerList;

  ChatElement({
    required this.chatId,
    required this.chatType,
    required this.chatDay,
    required this.content,
    required this.answerList,
  });

  String get getChatType => chatType;
  String get getChatDay => chatDay;
  String get getContent => content;
  bool get getIsComplete => !answerList.contains("-1");
}
