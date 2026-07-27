import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class SoundNotification {
  static final AudioPlayer audioPlayer = AudioPlayer();
  static void playLongSound() {
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    audioPlayer.play(AssetSource('sound/lastSound.mp3'));
    Timer(const Duration(minutes: 1), () => stopSound());
  }

  static void stopSound() => audioPlayer.stop();
}
