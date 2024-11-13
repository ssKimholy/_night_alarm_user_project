import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/utils/date_time_utils.dart';
import 'package:_night_sleep_user/utils/http_util.dart';
import 'package:flutter/material.dart';

class DailySurveyScreen extends StatefulWidget {
  final ChatElement chat;
  final Function onChangeAnswerList;
  List<String> tmpList; // 임시 답변 저장

  DailySurveyScreen({
    super.key,
    required this.chat,
    required this.onChangeAnswerList,
    required this.tmpList,
  });

  @override
  State<DailySurveyScreen> createState() => _DailySurveyScreenState();
}

class _DailySurveyScreenState extends State<DailySurveyScreen> {
  Widget radioButton(String current, int nIndex, int qIndex) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (widget.chat.getIsComplete) {
              // 최초 1회 설문을 제출한 경우 수정 불가
              return;
            }

            setState(() {
              widget.tmpList[qIndex] = nIndex.toString();
            });
          },
          child: Icon(
            current == nIndex.toString()
                ? Icons.radio_button_on
                : Icons.radio_button_off,
            color: Colors.black,
          ),
        ),
        Text(nIndex.toString(),
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Noto_Sans_KR',
                fontSize: 12,
                fontWeight: FontWeight.w400))
      ],
    );
  }

  Widget radioButtons(int qIndex, int qLength) {
    String current = widget.tmpList[qIndex];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(qLength, (index) {
        return radioButton(current, index, qIndex);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text('${widget.chat.chatDay} 설문',
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Noto_Sans_KR',
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // 그림자 색상 및 투명도
                    spreadRadius: 3, // 그림자가 퍼지는 반경
                    blurRadius: 2, // 그림자의 흐림 정도
                    offset: const Offset(1, 2), // 그림자의 위치 (x축, y축)
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('나는 취침할 의향이 있다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Noto_Sans_KR',
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  radioButtons(0, 4)
                ],
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // 그림자 색상 및 투명도
                    spreadRadius: 3, // 그림자가 퍼지는 반경
                    blurRadius: 2, // 그림자의 흐림 정도
                    offset: const Offset(1, 2), // 그림자의 위치 (x축, y축)
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                      '나는 해당 메시지가 유익하다고 생각한다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Noto_Sans_KR',
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  radioButtons(1, 4)
                ],
              ),
            ),
            // Container(
            //   margin:
            //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(25.0),
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.3), // 그림자 색상 및 투명도
            //         spreadRadius: 3, // 그림자가 퍼지는 반경
            //         blurRadius: 2, // 그림자의 흐림 정도
            //         offset: const Offset(1, 2), // 그림자의 위치 (x축, y축)
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     children: [
            //       const Text('현재 감정에 대해 평가해주세요.',
            //           style: TextStyle(
            //               color: Colors.black,
            //               fontFamily: 'Noto_Sans_KR',
            //               fontSize: 14,
            //               fontWeight: FontWeight.w400)),
            //       const SizedBox(
            //         height: 10.0,
            //       ),
            //       Image.asset('assets/valence.png'),
            //       const SizedBox(
            //         height: 20.0,
            //       ),
            //       radioButtons(1, 7),
            //       const SizedBox(
            //         height: 25.0,
            //       ),
            //       Image.asset('assets/arousal.png'),
            //       const SizedBox(
            //         height: 20.0,
            //       ),
            //       radioButtons(2, 7)
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 40.0,
            ),
            GestureDetector(
              onTap: () async {
                // manager는 전송 불가

                // http 설문 결과 전송.
                await HttpUtil.setDailySurveyAnswer(
                    widget.chat.chatId, widget.tmpList[0], widget.tmpList[1]);

                if (widget.tmpList.contains('-1')) {
                  // 100% 설문을 완료한 것이 아니면 다시 하도록
                  const snackBar = SnackBar(
                    content: Text('모든 문항에 답변해주세요.'),
                    duration: Duration(seconds: 2), // 메시지가 표시되는 시간
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                setState(() {
                  widget.onChangeAnswerList(widget.tmpList);
                });
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 80.0, vertical: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xff3ad277),
                ),
                child: const Text('제출',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Noto_Sans_KR',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
