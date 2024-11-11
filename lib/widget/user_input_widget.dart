import 'package:flutter/material.dart';

class UserInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String description;
  final String hintText;

  const UserInputWidget(
      {super.key,
      required this.controller,
      required this.description,
      required this.hintText,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Noto_Sans_KR',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 7.0,
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
            // focusedBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(6),
            //     borderSide: BorderSide(
            //         color: const Color(0xff898585).withOpacity(0.2),
            //         style: BorderStyle.solid)),
            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: const Color(0xff898585).withOpacity(0.2),
            //     width: 1.0,
            //   ),
            // ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: const Color(0xff898585).withOpacity(0.1),
            )),
            hintText: hintText,
            hintStyle: TextStyle(
                color: const Color(0xff898585).withOpacity(0.6),
                fontFamily: 'Noto_Sans_KR',
                fontSize: 14,
                fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
