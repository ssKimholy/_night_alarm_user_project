import 'package:_night_sleep_user/models/chat_element.dart';
import 'package:_night_sleep_user/utils/http_util.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceChatWidget extends StatefulWidget {
  final ChatElement chat;

  const VoiceChatWidget({
    super.key,
    required this.chat,
  });

  @override
  State<VoiceChatWidget> createState() => _VoiceChatWidgetState();
}

class _VoiceChatWidgetState extends State<VoiceChatWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isLoaded = false;
  Duration _audioDuration = Duration.zero;
  String? audioPath;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listen for the duration of the audio when it’s loaded
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _audioDuration = duration;
        });
      }
    });

    // Listen for audio completion to reset play icon and seek to start
    _audioPlayer.onPlayerComplete.listen((event) async {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
      await _resetAudioSource(); // Reload the source after playback completes
    });

    // Load the audio file to prepare it for playback
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      audioPath = await HttpUtil.playVoiceMessage(
          widget.chat.mediaContent['contentId']);
      print("Audio path received: $audioPath"); // Debugging output

      if (audioPath != null && audioPath!.isNotEmpty) {
        await _audioPlayer.setSourceDeviceFile(audioPath!);
        setState(() {
          isLoaded = true; // Indicate that the audio has loaded successfully
        });
      } else {
        print("Audio path is empty or null.");
      }
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  Future<void> _resetAudioSource() async {
    if (audioPath != null && audioPath!.isNotEmpty) {
      try {
        await _audioPlayer.setSourceDeviceFile(audioPath!);
      } catch (e) {
        print("Error resetting audio source: $e");
      }
    } else {
      print("Audio path is empty or null in _resetAudioSource.");
    }
  }

  Future<void> _togglePlayPause() async {
    if (!isLoaded) {
      // Prevent playback if audio hasn't loaded yet
      print("Audio not loaded yet.");
      return;
    }

    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      final position = await _audioPlayer.getCurrentPosition();
      print("Current position: $position"); // Debugging output

      if (position == null || position >= _audioDuration) {
        // If the audio is at the end or position is null, reset to the start
        await _audioPlayer.seek(Duration.zero);
        await _resetAudioSource(); // Ensure the source is set for replay
      }
      await _audioPlayer.resume();
    }
    if (mounted) {
      setState(() {
        isPlaying = !isPlaying;
      });
    }
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
                onTap: () async {
                  await _togglePlayPause();
                  if (!widget.chat.firstWatching) {
                    print('first');
                    await HttpUtil.setFirstWatching(widget.chat.chatId);
                  }
                },
                child: Icon(
                  isPlaying
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  size: 46,
                  color: const Color(0xff3ad277),
                ),
              ),
              Text(
                formatDuration(_audioDuration),
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Noto_Sans_KR',
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
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
