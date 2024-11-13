import 'dart:io';

import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/utils/http_util.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoChatWidget extends StatefulWidget {
  ChatElement chat;

  VideoChatWidget({super.key, required this.chat});

  @override
  State<VideoChatWidget> createState() => _VideoChatWidgetState();
}

class _VideoChatWidgetState extends State<VideoChatWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    // _controller =
    //     VideoPlayerController.networkUrl(Uri.parse(widget.chat.content))
    //       ..initialize().then((_) => setState(() {}));
  }

  Future<void> _initializeVideo() async {
    final String path =
        await HttpUtil.playVideoMessage(widget.chat.mediaContent['contentId']);
    final File file = File(path);

    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playFullScreenVideo() {
    _controller.play();
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => FullScreenVideoScreen(controller: _controller),
      ),
    )
        .then((_) {
      // Pause the video when returning from fullscreen
      _controller.pause();
    });
  }

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
                child: _isInitialized
                    ? Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVQfz5alLQyLoEJkvsYTwQJMZh5rSu7rfvuX1d2jeKxqF9KcGDYbOxPrvJeYkO3UWSAq8&usqp=CAU',
                        width: 240,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : const CircularProgressIndicator(),
              ),
              GestureDetector(
                onTap: () {
                  // video 재생
                  _playFullScreenVideo();
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

class FullScreenVideoScreen extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoScreen({super.key, required this.controller});

  @override
  _FullScreenVideoScreenState createState() => _FullScreenVideoScreenState();
}

class _FullScreenVideoScreenState extends State<FullScreenVideoScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.play(); // Automatically start playing when in fullscreen
  }

  @override
  void dispose() {
    widget.controller.pause(); // Pause when exiting fullscreen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: widget.controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Toggle play/pause
          widget.controller.value.isPlaying
              ? widget.controller.pause()
              : widget.controller.play();
        },
        child: Icon(
          widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
