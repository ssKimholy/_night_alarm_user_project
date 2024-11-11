import 'package:_night_sleep_user/screen/login_screen.dart';
import 'package:_night_sleep_user/screen/register_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80.0,
            ),
            const Text(
              '안녕하세요,',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Noto_Sans_KR',
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Text(
              '회원가입 또는 로그인을 해주세요.',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Noto_Sans_KR',
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 75.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const RegisterScreen();
                  },
                ));
              },
              child: Container(
                width: double.infinity,
                height: 43.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: const Color(0xff3AD277),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Noto_Sans_KR',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ));
              },
              child: Container(
                width: double.infinity,
                height: 43.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: const Color(0xff3AD277),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '로그인으로 시작하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Noto_Sans_KR',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
