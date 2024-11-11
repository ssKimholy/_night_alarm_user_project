import 'package:_night_sleep_user/firebase_options.dart';
import 'package:_night_sleep_user/screen/alarm_screen.dart';
import 'package:_night_sleep_user/screen/splash_screen.dart';
import 'package:_night_sleep_user/utils/notification_helper.dart';
import 'package:_night_sleep_user/utils/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<UserService>(UserService());
}

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await initializeLocalNotifications();

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showNotification(message);
}

class MyApp extends StatelessWidget {
  static const MethodChannel _channel =
      MethodChannel('com.example.alarmcare/channel');

  const MyApp({super.key});

  Future<String> getInitialRoute() async {
    try {
      final String? route = await _channel.invokeMethod('getRoute');
      return route ?? "/";
    } catch (e) {
      print("Error in getting initial route: $e");
      return "/";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // Use snapshot data as the initial route for SplashScreen
        final initialRoute = snapshot.data ?? "/";
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
          home: SplashScreen(initialRoute: initialRoute),
        );
      },
    );
  }
}
