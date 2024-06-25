import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';
import 'package:audioplayers/audioplayers.dart';

class PlaylistProvider extends ChangeNotifier {
  // Playlist of songs
  final List<Song> _playlist = [
    // Song 1
    Song(
      songName: "The Underworld",
      artistName: "Jorge Rivera-Herrans",
      albumArtImagePath: "assets/images/Underworld_Saga_Album_Image.webp",
      audioPath: "assets/audio/The_Underworld.mp3",
    ),
    // Song 2
    Song(
      songName: "No Longer You",
      artistName: "Jorge Rivera-Herrans",
      albumArtImagePath: "assets/images/Underworld_Saga_Album_Image.webp",
      audioPath: "assets/audio/No_Longer_You.mp3",
    ),
    // Song 3
    Song(
      songName: "Monster",
      artistName: "Jorge Rivera-Herrans",
      albumArtImagePath: "assets/images/Underworld_Saga_Album_Image.webp",
      audioPath: "assets/audio/Monster.mp3",
    ),
  ];

  // Current song playing index
  int? _currentSongIndex;

  /* A U D I O P L A Y E R S */

  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // Initially not playing
  bool _isPlaying = false;

  // Play the song
  void play() async {
    if (_currentSongIndex != null) {
      final String path = _playlist[_currentSongIndex!].audioPath;
      await _audioPlayer.stop(); // Stop current song
      await _audioPlayer.play(AssetSource(path)); // Play the new song
      _isPlaying = true;
      notifyListeners();
    }
  }

  // Pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume playing
  void resume() async {
    await _audioPlayer.resume(); // Fixed from pause to resume
    _isPlaying = true;
    notifyListeners();
  }

  // Pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  // Seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners(); // Added notifyListeners to update UI
  }

  // Play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // Go to the next song if it's not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        // If it's the last song, loop back to the first song
        currentSongIndex = 0;
      }
    }
  }

  // Play previous song
  void playPreviousSong() async {
    // If more than 2 seconds have passed, restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    // If it's within the first 2 seconds of the song, go to the previous song
    else {
      if (_currentSongIndex != null && _currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // If it's the first song, loop to the last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // Listen to duration
  void listenToDuration() {
    // Listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // Listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // Listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // Dispose audio player
  @override
  void dispose() {
    _audioPlayer.dispose(); // Added to release resources
    super.dispose();
  }

  /* G E T T E R S */
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /* S E T T E R S */
  set currentSongIndex(int? newIndex) {
    // Update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); // Play the song at the new index
    }

    // Update UI
    notifyListeners();
  }
}
