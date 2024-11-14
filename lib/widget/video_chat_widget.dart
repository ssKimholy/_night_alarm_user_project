import 'dart:io';

import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/utils/http_util.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoChatWidget extends StatefulWidget {
  final ChatElement chat;

  const VideoChatWidget({super.key, required this.chat});

  @override
  State<VideoChatWidget> createState() => _VideoChatWidgetState();
}

class _VideoChatWidgetState extends State<VideoChatWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final String path =
        await HttpUtil.playVideoMessage(widget.chat.mediaContent['contentId']);
    final File file = File(path);

    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      })
      ..addListener(_videoListener);
  }

  void _videoListener() {
    if (_isInitialized &&
        _controller.value.position >= _controller.value.duration) {
      setState(() {
        _stopVideo();
      });
    }
  }

  void _stopVideo() {
    _controller.pause();
    _controller.seekTo(Duration.zero);
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener); // 리스너 제거
    _controller.dispose();
    super.dispose();
  }

  void _playFullScreenVideo() async {
    if (_isInitialized) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullScreenVideoScreen(controller: _controller),
        ),
      );
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
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
                      'https://www.polytec.com.au/img/products/960-960/mercurio-grey.jpg',
                      width: 240,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : const CircularProgressIndicator(),
            ),
            GestureDetector(
              onTap: () {
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
      ),
    );
  }
}

class FullScreenVideoScreen extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoScreen({super.key, required this.controller});

  @override
  _FullScreenVideoScreenState createState() => _FullScreenVideoScreenState();
}

class _FullScreenVideoScreenState extends State<FullScreenVideoScreen> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Ensure that the video controller is initialized before trying to play
    if (widget.controller.value.isInitialized) {
      setState(() {
        _isPlaying = true;
      });
      widget.controller.play();
    }

    widget.controller.addListener(_videoEndListener);
  }

  void _videoEndListener() {
    if (widget.controller.value.position >= widget.controller.value.duration) {
      setState(() {
        _isPlaying = false;
      });
      _stopVideo();
    }
  }

  void _stopVideo() {
    widget.controller.pause();
    widget.controller.seekTo(Duration.zero);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_videoEndListener);
    _stopVideo();
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
          setState(() {
            if (_isPlaying) {
              widget.controller.pause();
              _isPlaying = false;
            } else {
              widget.controller.play();
              _isPlaying = true;
            }
          });
        },
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
