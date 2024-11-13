import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/models/user_element.dart';
import 'package:_night_sleep_user/utils/date_time_utils.dart';
import 'package:_night_sleep_user/utils/http_util.dart';
import 'package:_night_sleep_user/widget/text_chat_widget.dart';
import 'package:_night_sleep_user/widget/video_chat_widget.dart';
import 'package:_night_sleep_user/widget/voice_chat_widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  final UserElement user;
  final ChatElement chat;
  List<String> tmpList;

  ChatWidget(
      {super.key,
      required this.user,
      required this.chat,
      required this.tmpList});

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
              child: Text(
                  '${widget.chat.chatDay} (${DateTimeUtils.convertDateToWeek(widget.chat.chatDay)})',
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Noto_Sans_KR',
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          widget.user.getUserType == 'text'
              ? TextChatWidget(textBody: widget.chat.textContent)
              : widget.user.getUserType == 'voice'
                  ? VoiceChatWidget(chat: widget.chat)
                  : VideoChatWidget(chat: widget.chat),

          // Expanded survey within an ExpansionTile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.chat.getIsComplete ? '설문 완료' : '설문 시작',
                      style: TextStyle(
                        color: widget.chat.getIsComplete
                            ? const Color(0xff9decd1).withOpacity(0.7)
                            : const Color(0xffef696b).withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                initiallyExpanded:
                    !widget.chat.getIsComplete, // Expand if incomplete
                children: [
                  const SizedBox(height: 10),
                  _buildSurveyQuestion(
                    question: '나는 취침할 의향이 있다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)',
                    qIndex: 0,
                  ),
                  const SizedBox(height: 10),
                  _buildSurveyQuestion(
                    question:
                        '나는 해당 메시지가 유익하다고 생각한다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)',
                    qIndex: 1,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      // Submit survey answers
                      if (widget.tmpList.contains('-1')) {
                        const snackBar = SnackBar(
                          content: Text('모든 문항에 답변해주세요.'),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      if (!widget.chat.answerList.contains('-1')) {
                        const snackBar = SnackBar(
                          content: Text('이미 제출한 설문입니다.'),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      setState(() {
                        onChangeAnswerList(widget.tmpList);
                      });

                      await HttpUtil.setDailySurveyAnswer(
                        widget.chat.chatId,
                        widget.chat.answerList[0],
                        widget.chat.answerList[1],
                      );

                      const snackBar = SnackBar(
                        content: Text('응답이 제출되었습니다.'),
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xff3ad277),
                      ),
                      child: const Text('제출',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Noto_Sans_KR',
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSurveyQuestion({required String question, required int qIndex}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 2,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Noto_Sans_KR',
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20.0),
          _buildRadioButtons(qIndex, 4),
        ],
      ),
    );
  }

  Widget _buildRadioButtons(int qIndex, int qLength) {
    String currentAnswer = widget.tmpList[qIndex];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(qLength, (index) {
        return GestureDetector(
          onTap: () {
            if (widget.chat.getIsComplete) return;

            setState(() {
              widget.tmpList[qIndex] = index.toString();
            });
          },
          child: Column(
            children: [
              Icon(
                currentAnswer == index.toString()
                    ? Icons.radio_button_on
                    : Icons.radio_button_off,
                color: Colors.black,
              ),
              Text(
                index.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Noto_Sans_KR',
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        );
      }),
    );
  }
}
