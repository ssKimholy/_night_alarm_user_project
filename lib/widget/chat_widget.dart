import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/models/user_element.dart';
import 'package:_night_sleep_user/screen/daily_survey_screen.dart';
import 'package:_night_sleep_user/utils/date_time_utils.dart';
import 'package:_night_sleep_user/widget/text_chat_widget.dart';
import 'package:_night_sleep_user/widget/video_chat_widget.dart';
import 'package:_night_sleep_user/widget/voice_chat_widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  UserElement user;
  ChatElement chat;

  ChatWidget({super.key, required this.user, required this.chat});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  void onChangeAnswerList(List<String> newList) {
    setState(() {
      widget.chat.answerList = newList;
    });
  }

  @override
  void initState() {
    super.initState();
    // http get answerList
    // 현재는 리스트 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: widget.chat.getIsComplete
                    ? const Color(0xff9decd1).withOpacity(0.7)
                    : const Color(0xffef696b).withOpacity(0.7),
              ),
              child: Text(widget.chat.chatDay,
                  // (${DateTimeUtils.convertDateToWeek(widget.chat.chatDay)})',
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Noto_Sans_KR',
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          widget.user.getUserType == 'text'
              ? TextChatWidget(textBody: widget.chat.content)
              : widget.user.getUserType == 'voice'
                  ? VoiceChatWidget(chat: widget.chat)
                  : VideoChatWidget(chat: widget.chat),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GestureDetector(
              onTap: () {
                // go to survey page
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return DailySurveyScreen(
                      chat: widget.chat,
                      onChangeAnswerList: onChangeAnswerList,
                      tmpList: widget.chat.answerList.toList(),
                    );
                  },
                ));
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: widget.chat.getIsComplete
                        ? const Color(0xff9decd1).withOpacity(0.7)
                        : const Color(0xffef696b).withOpacity(0.7),
                  ),
                  child: widget.chat.getIsComplete
                      ? const Text('설문 완료',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Noto_Sans_KR',
                              fontSize: 14,
                              fontWeight: FontWeight.w500))
                      : const Text('설문 시작',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Noto_Sans_KR',
                              fontSize: 14,
                              fontWeight: FontWeight.w500))),
            ),
          )
        ],
      ),
    );
  }
}
