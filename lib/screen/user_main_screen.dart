import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/models/user_element.dart';
import 'package:_night_sleep_user/models/weekly_survey_element.dart';
import 'package:_night_sleep_user/screen/weekly_%20mediation_screen.dart';
import 'package:_night_sleep_user/screen/weekly_survey_screen.dart';
import 'package:_night_sleep_user/utils/http_util.dart';
import 'package:_night_sleep_user/utils/notification_helper.dart';
import 'package:_night_sleep_user/utils/user_service.dart';
import 'package:_night_sleep_user/widget/chat_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../main.dart';

class UserMainScreen extends StatefulWidget {
  final int userId;

  UserMainScreen({super.key, required this.userId});
  final userService = GetIt.instance<UserService>();

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  final ScrollController _scrollController = ScrollController();

  // Future<String> getMyDeviceToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   print("here's token: $token");
  //   return token!;
  // }

  @override
  void initState() {
    super.initState();
    registerUser();
    // getMyDeviceToken();

    // FCM 초기화 및 토큰 수신
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");
    });

    // 앱이 foreground 상태일 때 메시지 수신 처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      showNotification(message); // 로컬 알림 표시
    });

    // 앱이 background 상태에서 클릭하여 열릴 때 메시지 수신 처리
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Background message clicked: ${message.notification?.title}');
      // showNotification(message); // 로컬 알림 표시
    });
  }

  ChatElement _parseJsonToChatElement(Map<String, dynamic> json) {
    return ChatElement(
      chatId: json['chatId'],
      chatType: json['user']['userType'],
      chatDay: json['createdAt'].split('T')[0],
      textContent: json['user']['userType'] == 'text'
          ? json['alarm']['textContent']
          : '',
      mediaContent: json['user']['userType'] == 'text'
          ? {"null": "2"}
          : json['alarm']['alarmContent'],
      answerList: [
        json['answer']['answer1'] ?? '-1',
        json['answer']['answer2'] ?? '-1',
      ],
    );
  }

  void registerUser() async {
    Map<String, dynamic> userData = await HttpUtil.getUserInfo(widget.userId);
    print(userData["userName"]);

    final List chatList = await HttpUtil.getUserChatList(widget.userId);
    final userChatList = chatList
        .map<ChatElement>((json) => _parseJsonToChatElement(json))
        .toList();

    setState(() {
      widget.userService.registerUser(
          userData["userName"],
          userData["userId"],
          userData["password"],
          userData["userType"],
          userData["deviceKey"],
          userChatList);
    });

    // 페이지가 로드될 때 맨 아래로 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userService.user;
    if (user == null) {
      // `user`가 `null`인 경우 로딩 표시나 오류 메시지를 표시합니다.
      return Scaffold(
        backgroundColor: const Color(0xfffefcfc),
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          title: const Text(
            'Loading...',
            style: TextStyle(color: Colors.black, fontFamily: 'Noto_Sans_KR'),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        backgroundColor: const Color(0xfffefcfc),
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          title: const Text(
            'SleepCare',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Noto_Sans_KR',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  // 주간 설문 페이지로 이동
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return WeekyMediationScreen(user: user);
                    },
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      // 실험 주를 세는 속성이 있어야 함.
                      color: Colors.grey),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.edit_document,
                        color: Colors.black,
                        size: 24,
                      ),
                      Text('주간 설문',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Noto_Sans_KR',
                              fontSize: 14,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        body: Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: user.chatList.length,
            itemBuilder: (context, index) {
              return ChatWidget(
                user: user,
                chat: user.chatList[index],
                tmpList: user.chatList[index].answerList.toList(),
              );
            },
          ),
        ));
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 컨트롤러 해제
    super.dispose();
  }
}
