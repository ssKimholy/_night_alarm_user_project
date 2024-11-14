import 'package:_night_sleep_user/models/user_element.dart';
import 'package:_night_sleep_user/utils/http_util.dart';
import 'package:flutter/material.dart';

class WeeklySurveyScreen extends StatefulWidget {
  List<int> tmpSleepList;
  final UserElement user;
  Function setIsWeeklySurveyCompleted;

  WeeklySurveyScreen({
    super.key,
    required this.tmpSleepList,
    required this.user,
    required this.setIsWeeklySurveyCompleted,
  });

  @override
  State<WeeklySurveyScreen> createState() => _WeeklySurveyScreenState();
}

class _WeeklySurveyScreenState extends State<WeeklySurveyScreen> {
  Widget radioButton(int current, int nIndex, int qIndex, String qType) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // if (widget.user.getWeeklySurvey
            //     .isWeeklySurveyComplete(widget.weekNum)) {
            //   return; // 설문 수정 불가
            // }
            setState(() {
              widget.tmpSleepList[qIndex] = nIndex;
            });
          },
          child: Icon(
            current == nIndex ? Icons.radio_button_on : Icons.radio_button_off,
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

  Widget radioButtons(int qIndex, int qLength, String qType) {
    int current = widget.tmpSleepList[qIndex];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(qLength, (index) {
        return radioButton(current, index, qIndex, qType);
      }),
    );
  }

  Widget questionContainer(String question, String qType, int qIndex) {
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
        children: [
          Text(question,
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Noto_Sans_KR',
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 20.0,
          ),
          radioButtons(qIndex, 4, qType) // qType별 항목 개수
        ],
      ),
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
          children: [
            const SizedBox(
              height: 20.0,
            ),
            const Center(
              child: Text('주간 설문',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Noto_Sans_KR',
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Center(
              child: Text('수면 관련 설문',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Noto_Sans_KR',
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(
              height: 20.0,
            ),
            // 수면 관련 질문들
            ...List.generate(3, (index) {
              String question = "";
              if (index == 0) {
                question = "지난 일주일 간의 수면에 대해 0점부터 4점까지 점수를 매겨주세요.";
              } else if (index == 1) {
                question =
                    "나는 지난 일주일 간 기상을 할 때 편안함을 느꼈다. (0: 전혀 그렇지 않다 ~ 4: 매우 그렇다)";
              } else {
                question =
                    "나는 지난 일주일 간 침대에서 일어나는 것이 쉽다고 느꼈다. (0: 전혀 그렇지 않다 ~ 4: 매우 그렇다)";
              }
              return questionContainer(question, "sleep", index);
            }),

            // const Center(
            //   child: Text('우울 관련 설문',
            //       style: TextStyle(
            //           color: Colors.black,
            //           fontFamily: 'Noto_Sans_KR',
            //           fontSize: 14,
            //           fontWeight: FontWeight.w700)),
            // ),
            // const SizedBox(
            //   height: 20.0,
            // ),
            // const Center(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            //     child: Text(
            //         '아래의 문항을 잘 읽으신 후, 지난 1주 동안 자신을 가장 잘 설명하는 칸에 체크 해 주세요.',
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontFamily: 'Noto_Sans_KR',
            //             fontSize: 14,
            //             fontWeight: FontWeight.w500)),
            //   ),
            // ),
            // const SizedBox(
            //   height: 20.0,
            // ),
            // // 우울 관련 질문들
            // ...List.generate(9, (index) {
            //   String question = "";
            //   switch (index) {
            //     case 0:
            //       question =
            //           "기분이 가라앉거나, 우울하거나, 희망이 없다고 느꼈다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)";
            //       break;
            //     case 1:
            //       question =
            //           "평소 하던 일에 대한 흥미가 없어지거나 즐거움을 느끼지 못했다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)";
            //       break;
            //     case 2:
            //       question =
            //           "잠들기가 어렵거나 자주 깼다/혹은 너무 많이 잤다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)";
            //       break;
            //     case 3:
            //       question =
            //           "평소보다 식욕이 줄었다/혹은 평소보다 많이 먹었다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)";
            //       break;
            //     case 4:
            //       question =
            //           "다른 사람들이 눈치 챌 정도로 평소보다 말과 행동이 느려졌다/혹은 너무 안절부절 못해서 가만히 앉아 있을 수 없었다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)";
            //       break;
            //     case 5:
            //       question = "피곤하고 기운이 없었다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)";
            //       break;
            //     case 6:
            //       question =
            //           "내가 잘못 했거나, 실패했다는 생각이 들었다/혹은 자신과 가족을 실망시켰다고 생각했다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)";
            //       break;
            //     case 7:
            //       question =
            //           "신문을 읽거나 TV를 보는 것과 같은 일상적인 일에도 집중 할 수가 없었다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)";
            //       break;
            //     case 8:
            //       question =
            //           "차라리 죽는 것이 더 낫겠다고 생각했다/혹은 자해할 생각을 했다. (0: 전혀 그렇지 않다 ~ 3: 매우 그렇다)";
            //       break;
            //   }
            //   return questionContainer(question, "depression", index);
            // }),
            const SizedBox(
              height: 40.0,
            ),
            GestureDetector(
              onTap: () async {
                // http 설문 결과 전송.
                if (widget.tmpSleepList.contains(-1)) {
                  // 100% 설문을 완료한 것이 아니면 다시 하도록
                  const snackBar = SnackBar(
                    content: Text('모든 문항에 답변해주세요.'),
                    duration: Duration(seconds: 2), // 메시지가 표시되는 시간
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                // setState(() {
                //   widget.onChangeWeeklySurvey(
                //       widget.tmpSleepList, widget.weekNum);
                // });

                widget.setIsWeeklySurveyCompleted(true);
                await HttpUtil.setWeeklySurveyResult(
                    widget.user.userId, widget.tmpSleepList);
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
            ),
          ],
        ),
      ),
    );
  }
}
