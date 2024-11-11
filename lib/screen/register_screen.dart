import 'package:_night_sleep_user/main.dart';
import 'package:_night_sleep_user/utils/http_util.dart';
import 'package:_night_sleep_user/utils/user_service.dart';
import 'package:_night_sleep_user/widget/user_input_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  Future<String> getMyDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token!;
  }

  // void setToken(global) async {
  //   String token = await getMyDeviceToken();
  //   global.setDeviceToken(token);
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 30,
        automaticallyImplyLeading: false,
        flexibleSpace: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Icon(
                    Icons.arrow_back,
                    size: 26,
                    color: Colors.black,
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                '회원가입',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Noto_Sans_KR',
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 45.0,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
            child: Column(
              children: [
                UserInputWidget(
                  controller: idController,
                  description: '이메일',
                  hintText: '이메일 입력',
                ),
                const SizedBox(
                  height: 35.0,
                ),
                UserInputWidget(
                  controller: passwordController,
                  description: '비밀번호',
                  hintText: '비밀번호 입력',
                ),
                const SizedBox(
                  height: 35.0,
                ),
                UserInputWidget(
                  controller: nameController,
                  description: '이름',
                  hintText: '이름 입력',
                ),
                const SizedBox(
                  height: 35.0,
                ),
                UserInputWidget(
                  controller: typeController,
                  description: '타입',
                  hintText: '타입 입력',
                ),
                const SizedBox(
                  height: 90.0,
                ),
                GestureDetector(
                  onTap: () async {
                    // final prefs = await SharedPreferences.getInstance();
                    // await prefs.setString(
                    //     'phone-num', global.getUserPhoneNumber);
                    // // 회원가입 logic
                    // HttpRequestUtil.registerUser(
                    //     global.getUserId,
                    //     global.getUserPw,
                    //     global.getUserName,
                    //     global.getUserPhoneNumber,
                    //     global.getDeviceToken);

                    final userId = idController.text;
                    final userpw = passwordController.text;
                    final userName = nameController.text;
                    final userType = typeController.text;
                    final String userDeviceCode = await getMyDeviceToken();
                    print("user device: $userDeviceCode");

                    if (userId.isNotEmpty &&
                        userpw.isNotEmpty &&
                        userName.isNotEmpty &&
                        userType.isNotEmpty &&
                        userDeviceCode.isNotEmpty) {
                      HttpUtil.registerUser(
                          userpw, userName, userType, userDeviceCode);
                    }

                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: double.infinity,
                      height: 42.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: const Color(0xff3AD277),
                      ),
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Noto_Sans_KR',
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
