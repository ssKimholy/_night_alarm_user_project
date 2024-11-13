import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/utils/http_util.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceChatWidget extends StatefulWidget {
  ChatElement chat;

  VoiceChatWidget({
    super.key,
    required this.chat,
  });

  @override
  State<VoiceChatWidget> createState() => _VoiceChatWidgetState();
}

class _VoiceChatWidgetState extends State<VoiceChatWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration _audioDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listen for the duration of the audio when it’s loaded
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _audioDuration = duration;
      });
    });

    // Load the audio file to get the duration
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      final String path = await HttpUtil.playVoiceMessage(
          widget.chat.mediaContent['contentId']);
      print(path);
      await _audioPlayer.setSourceDeviceFile(path);
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          padding:
              const EdgeInsets.symmetric(horizontal: 120.0, vertical: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            color: const Color(0xffedeeee),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _togglePlayPause();
                },
                child: Icon(
                  isPlaying
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  size: 46,
                  color: const Color(0xff3ad277),
                ),
              ),

              // 음성 길이 설정
              Text(formatDuration(_audioDuration),
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Noto_Sans_KR',
                      fontSize: 14,
                      fontWeight: FontWeight.w500))
            ],
          )),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
