import 'package:_night_sleep_user/screen/alarm_screen.dart';
import 'package:_night_sleep_user/screen/onBoarding_screen.dart';
import 'package:_night_sleep_user/screen/user_main_screen.dart';
import 'package:_night_sleep_user/utils/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SplashScreen extends StatefulWidget {
  final String initialRoute;

  const SplashScreen({super.key, required this.initialRoute});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final userService = GetIt.instance<UserService>();

  @override
  void initState() {
    super.initState();
    // Schedule navigation after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate();
    });
  }

  void _navigate() {
    if (widget.initialRoute == "/alarmPage") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AlarmScreen()),
      );
    } else {
      _checkLoginStatus();
    }
  }

  Future<void> _checkLoginStatus() async {
    int id = await userService.loadUserId();
    if (id != -1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserMainScreen(userId: id),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
