import 'package:_night_sleep_user/models/user_element.dart';
import 'package:_night_sleep_user/screen/weekly_survey_screen.dart';
import 'package:flutter/material.dart';

class WeekyMediationScreen extends StatefulWidget {
  UserElement user;
  WeekyMediationScreen({super.key, required this.user});

  @override
  State<WeekyMediationScreen> createState() => _WeekyMediationScreenState();
}

class _WeekyMediationScreenState extends State<WeekyMediationScreen> {
  void onChangeWeeklySurvey(List<int> sl, int weekNum) {
    setState(() {
      widget.user.getWeeklySurvey.setAnswer(weekNum, sl);
    });

    // http post
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
        title: const Text('주간 설문',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Noto_Sans_KR',
                fontSize: 20,
                fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // 주간 설문 페이지로 이동
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return WeeklySurveyScreen(
                      tmpSleepList:
                          widget.user.getWeeklySurvey.getAnswer(1).toList(),
                      user: widget.user,
                      onChangeWeeklySurvey: onChangeWeeklySurvey,
                      weekNum: 1,
                    );
                  },
                ));
              },
              child: Container(
                padding: const EdgeInsets.all(6.0),
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  // 실험 주를 세는 속성이 있어야 함.
                  color: widget.user.getWeeklySurvey.isWeeklySurveyComplete(1)
                      ? const Color(0xff9decd1).withOpacity(0.7)
                      : const Color(0xffef696b).withOpacity(0.7),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.edit_document,
                      color: Colors.black,
                      size: 24,
                    ),
                    Text('1주차 설문',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Noto_Sans_KR',
                            fontSize: 11,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // 주간 설문 페이지로 이동
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return WeeklySurveyScreen(
                      tmpSleepList:
                          widget.user.getWeeklySurvey.getAnswer(2).toList(),
                      user: widget.user,
                      onChangeWeeklySurvey: onChangeWeeklySurvey,
                      weekNum: 2,
                    );
                  },
                ));
              },
              child: Container(
                padding: const EdgeInsets.all(6.0),
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  // 실험 주를 세는 속성이 있어야 함.
                  color: widget.user.getWeeklySurvey.isWeeklySurveyComplete(2)
                      ? const Color(0xff9decd1).withOpacity(0.7)
                      : const Color(0xffef696b).withOpacity(0.7),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.edit_document,
                      color: Colors.black,
                      size: 24,
                    ),
                    Text('2주차 설문',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Noto_Sans_KR',
                            fontSize: 11,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // 주간 설문 페이지로 이동
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return WeeklySurveyScreen(
                      tmpSleepList:
                          widget.user.getWeeklySurvey.getAnswer(3).toList(),
                      user: widget.user,
                      onChangeWeeklySurvey: onChangeWeeklySurvey,
                      weekNum: 3,
                    );
                  },
                ));
              },
              child: Container(
                padding: const EdgeInsets.all(6.0),
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  // 실험 주를 세는 속성이 있어야 함.
                  color: widget.user.getWeeklySurvey.isWeeklySurveyComplete(3)
                      ? const Color(0xff9decd1).withOpacity(0.7)
                      : const Color(0xffef696b).withOpacity(0.7),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.edit_document,
                      color: Colors.black,
                      size: 24,
                    ),
                    Text('3주차 설문',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Noto_Sans_KR',
                            fontSize: 11,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // 주간 설문 페이지로 이동
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return WeeklySurveyScreen(
                      tmpSleepList:
                          widget.user.getWeeklySurvey.getAnswer(4).toList(),
                      user: widget.user,
                      onChangeWeeklySurvey: onChangeWeeklySurvey,
                      weekNum: 4,
                    );
                  },
                ));
              },
              child: Container(
                padding: const EdgeInsets.all(6.0),
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  // 실험 주를 세는 속성이 있어야 함.
                  color: widget.user.getWeeklySurvey.isWeeklySurveyComplete(4)
                      ? const Color(0xff9decd1).withOpacity(0.7)
                      : const Color(0xffef696b).withOpacity(0.7),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.edit_document,
                      color: Colors.black,
                      size: 24,
                    ),
                    Text('4주차 설문',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Noto_Sans_KR',
                            fontSize: 11,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // 주간 설문 페이지로 이동
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return WeeklySurveyScreen(
                      tmpSleepList:
                          widget.user.getWeeklySurvey.getAnswer(5).toList(),
                      user: widget.user,
                      onChangeWeeklySurvey: onChangeWeeklySurvey,
                      weekNum: 5,
                    );
                  },
                ));
              },
              child: Container(
                padding: const EdgeInsets.all(6.0),
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  // 실험 주를 세는 속성이 있어야 함.
                  color: widget.user.getWeeklySurvey.isWeeklySurveyComplete(5)
                      ? const Color(0xff9decd1).withOpacity(0.7)
                      : const Color(0xffef696b).withOpacity(0.7),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.edit_document,
                      color: Colors.black,
                      size: 24,
                    ),
                    Text('5주차 설문',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Noto_Sans_KR',
                            fontSize: 11,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
