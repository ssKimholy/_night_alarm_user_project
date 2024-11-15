import 'package:_night_sleep_user/firebase_options.dart';
import 'package:_night_sleep_user/screen/alarm_screen.dart';
import 'package:_night_sleep_user/screen/splash_screen.dart';
import 'package:_night_sleep_user/utils/firebase_realTime_service.dart';
import 'package:_night_sleep_user/utils/notification_helper.dart';
import 'package:_night_sleep_user/utils/sleep_service.dart';
import 'package:_night_sleep_user/utils/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workmanager/workmanager.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<UserService>(UserService());
}

Future<void> backgroundTask() async {
  print('backGround sleep data');

  try {
    // Fetch sleep data directly
    print('Calling SleepService.getSleepData...');
    final List<Map<String, dynamic>> sleepData =
        await SleepService.getSleepData();
    print('sleepData: $sleepData');

    // Save data to Firebase
    final firebaseService = FirebaseService();
    final userService = GetIt.instance<UserService>();
    int id = await userService.loadUserId();

    if (id != -1) {
      await firebaseService.saveSleepData(id.toString(), sleepData);
    }
  } catch (e) {
    print("Error in backgroundTask: $e");
  }
}

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await initializeLocalNotifications();

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager()
      .registerOneOffTask(
    "fetchSleepData",
    "Fetch Sleep Data",
    constraints: Constraints(networkType: NetworkType.connected),
  )
      .then((_) {
    print("WorkManager 태스크 등록 완료");
  }).catchError((e) {
    print("WorkManager 태스크 등록 실패: $e");
  });

  runApp(const MyApp());
}

void callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((task, inputData) async {
    print("백그라운드 작업 실행: $task");

    if (task == "Fetch Sleep Data") {
      // backgroundTask 호출
      await backgroundTask();
      return Future.value(true);
    }

    return Future.value(false); // 작업이 성공적으로 완료되었음을 알림
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showNotification(message);
}

class MyApp extends StatelessWidget {
  static const MethodChannel _channel =
      MethodChannel('com.example.alarmcare/channel');

  const MyApp({super.key});

  Future<Map<String, String>> getInitialRouteData() async {
    try {
      // Receive the data from Android as a map
      final Map<dynamic, dynamic> routeData =
          await _channel.invokeMethod('getRoute');

      // Cast the dynamic map to Map<String, String> safely
      return routeData
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    } catch (e) {
      print("Error in getting initial route data: $e");
      return {"route": "/"};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: getInitialRouteData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // Use snapshot data as the initial route for SplashScreen
        final routeData = snapshot.data ?? {"route": "/"};
        final initialRoute = routeData["route"] ?? "/";
        final alarmData = routeData; // Pass the full map for additional data

        return MaterialApp(
          title: 'alarmcare',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ko', ''),
          ],
          home: SplashScreen(
            initialRoute: initialRoute,
            alarmData: alarmData,
          ),
        );
      },
    );
  }
}
