class ChatElement {
  final int chatId;
  final String chatType;
  final String chatDay;
  final String textContent;
  final Map<String, dynamic> mediaContent;
  List<String> answerList;

  ChatElement({
    required this.chatId,
    required this.chatType,
    required this.chatDay,
    required this.textContent,
    required this.mediaContent,
    required this.answerList,
  });

  String get getChatType => chatType;
  String get getChatDay => chatDay;
  String get getTextContent => textContent;
  Map<String, dynamic> get getMediaContent => mediaContent;
  bool get getIsComplete => !answerList.contains("-1");
}
