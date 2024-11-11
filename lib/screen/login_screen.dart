import 'package:_night_sleep_user/screen/register_screen.dart';
import 'package:_night_sleep_user/screen/user_main_screen.dart';
import 'package:_night_sleep_user/utils/http_util.dart';
import 'package:_night_sleep_user/utils/user_service.dart';
import 'package:_night_sleep_user/widget/user_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatefulWidget {
  late String email;
  late String password;

  LoginScreen({super.key, this.email = '', this.password = ''});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  setEmail(String email) {
    setState(() {
      widget.email = email;
    });
  }

  setPassword(String pw) {
    setState(() {
      widget.password = pw;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userService = GetIt.instance<UserService>();

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
                '로그인',
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
                  controller: emailController,
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
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          '이메일 찾기',
                          style: TextStyle(
                            color: Color(0xff898585),
                            fontFamily: 'Noto_Sans_KR',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: 68,
                          height: 1.5,
                          color: const Color(0xff898585),
                          margin: const EdgeInsets.only(top: 3.0),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          '비밀번호 찾기',
                          style: TextStyle(
                            color: Color(0xff898585),
                            fontFamily: 'Noto_Sans_KR',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 1.5,
                          color: const Color(0xff898585),
                          margin: const EdgeInsets.only(top: 3.0),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 50.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const RegisterScreen();
                          },
                        ));
                      },
                      child: Column(
                        children: [
                          const Text(
                            '회원가입 하기',
                            style: TextStyle(
                              color: Color(0xff3AD277),
                              fontFamily: 'Noto_Sans_KR',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 1.5,
                            color: const Color(0xff3AD277),
                            margin: const EdgeInsets.only(top: 3.0),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 265.0,
                ),
                GestureDetector(
                  onTap: () async {
                    // 로그인 logic

                    final userName = emailController.text;
                    final userPw = passwordController.text;

                    print('input : $userName, password: $userPw');

                    Map<String, dynamic> userData =
                        await HttpUtil.loginUser(userName, userPw);

                    final int userId = userData["userId"];

                    userService.setLoggedInfo(userData["userId"], true);
                    // String accessToken = await HttpRequestUtil.loginUser(
                    //     widget.email, widget.password);
                    // if (accessToken != '') {
                    //   final prefs = await SharedPreferences.getInstance();
                    //   await prefs.setBool('isLoggedIn', true);
                    //   global.setDeviceToken(accessToken);

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return UserMainScreen(userId: userId);
                      },
                    ));
                    // }
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
                        '로그인',
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
