import 'package:flutter/material.dart';

class TextChatWidget extends StatelessWidget {
  String textBody;

  TextChatWidget({super.key, required this.textBody});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: const Color(0xffedeeee),
      ),
      child: Text(textBody,
          style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Noto_Sans_KR',
              fontSize: 14,
              fontWeight: FontWeight.w400)),
    );
  }
}
