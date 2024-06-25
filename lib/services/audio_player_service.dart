import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Play audio
  Future<void> play(String path) async {
    try {
      await _audioPlayer.play(AssetSource(path)); // Use the path of your audio file
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  // Pause audio
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  // Resume audio
  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      print('Error resuming audio: $e');
    }
  }

  // Stop audio
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  // Seek to a specific position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print('Error seeking audio: $e');
    }
  }

  // Listen to audio completion
  void setCompletionListener(Function onComplete) {
    _audioPlayer.onPlayerComplete.listen((event) {
      onComplete();
    });
  }

  // Stream duration changes
  Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;

  // Stream position changes
  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
}
