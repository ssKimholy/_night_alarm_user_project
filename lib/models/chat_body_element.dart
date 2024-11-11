class ChatBodyElement {
  String textBody;
  String voiceId;
  String videoId;

  ChatBodyElement({
    required this.textBody,
    required this.voiceId,
    required this.videoId,
  });

  String get getTextBody => textBody;

  void playVoiceMessage() {
    // Voice play logic
  }

  void stopVoiceMessage() {
    // Voice stop logic
  }

  int getVoiceLength() {
    // http get voice length
    return 15;
  }

  void playVideoMessage() {
    // Vidoe play logic
  }

  void stopVideoMessage() {
    // Vidoe stop logic
  }

  int getVideoLength() {
    // http get video length
    return 15;
  }
}
