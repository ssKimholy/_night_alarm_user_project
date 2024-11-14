import 'package:_night_sleep_user/screen/user_main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AlarmScreen extends StatelessWidget {
  Map<String, dynamic> alarmData;

  AlarmScreen({super.key, required this.alarmData});

  void playAlarmSound() {
    print('in the alarm screen');
    print('this: $alarmData');
    FlutterRingtonePlayer.playAlarm();
  }

  void stopAlarmSound() {
    FlutterRingtonePlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    playAlarmSound();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'PM',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Noto_Sans_KR',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 7.0,
              ),
              Text(
                '09:00',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Noto_Sans_KR',
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 80,
          ),
          const Center(
            child: Text(
              '메시지가 도착했습니다.',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Noto_Sans_KR',
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          GestureDetector(
            onTap: () {
              // 메시지 확인
              stopAlarmSound();
              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
              //   return UserMainScreen(userId: userId)
              // },), (route) => false);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: const Color(0xff3AD277),
              ),
              child: const Text(
                '지금 확인하기',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Noto_Sans_KR',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 200.0,
          ),
          GestureDetector(
            onTap: () {
              // 종료
              stopAlarmSound();
              SystemNavigator.pop();
              return;
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: const Color(0xffCDEBD9).withOpacity(0.40),
              ),
              child: const Text(
                '나중에 확인하기',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Noto_Sans_KR',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
