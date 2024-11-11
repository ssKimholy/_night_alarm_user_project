import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:flutter/material.dart';

class VideoChatWidget extends StatefulWidget {
  ChatElement chat;

  VideoChatWidget({super.key, required this.chat});

  @override
  State<VideoChatWidget> createState() => _VideoChatWidgetState();
}

class _VideoChatWidgetState extends State<VideoChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: const Color(0xffedeeee),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVQfz5alLQyLoEJkvsYTwQJMZh5rSu7rfvuX1d2jeKxqF9KcGDYbOxPrvJeYkO3UWSAq8&usqp=CAU',
                  width: 240,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.chat.chatBody.playVideoMessage();
                },
                child: const Icon(
                  Icons.play_circle_outline,
                  color: Color(0xff3ad277),
                  size: 40,
                ),
              )
            ],
          ),
        ));
  }
}
