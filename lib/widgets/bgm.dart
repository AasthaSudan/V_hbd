import 'package:just_audio/just_audio.dart';

class BackgroundMusic {
  static final BackgroundMusic _instance = BackgroundMusic._internal();
  factory BackgroundMusic() => _instance;
  BackgroundMusic._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> init() async {
    try {
      await _player.setAsset('assets/audio/happy-birthday-254480.mp3');
      _player.setLoopMode(LoopMode.all);
      _player.play();
    } catch (e) {
      print('Audio error: $e');
    }
  }

  void pause() => _player.pause();
  void resume() => _player.play();
  void stop() => _player.stop();
}