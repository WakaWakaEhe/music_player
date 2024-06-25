import 'package:flutter/material.dart';
import 'package:music_player/components/neu_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:music_player/services/audio_player_service.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _audioPlayerService.onDurationChanged.listen((newDuration) {
      setState(() {
        _totalDuration = newDuration;
      });
    });

    _audioPlayerService.onPositionChanged.listen((newPosition) {
      setState(() {
        _currentDuration = newPosition;
      });
    });

    _audioPlayerService.setCompletionListener(_playNextSong);
  }

  void _playSong(String audioPath) async {
    await _audioPlayerService.stop();
    await _audioPlayerService.play(audioPath);
    setState(() {
      _isPlaying = true;
    });
  }

  void _pauseSong() async {
    await _audioPlayerService.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _resumeSong() async {
    await _audioPlayerService.resume();
    setState(() {
      _isPlaying = true;
    });
  }

  void _playNextSong() {
    final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);
    playlistProvider.playNextSong();
    final nextSong =
        playlistProvider.playlist[playlistProvider.currentSongIndex ?? 0];
    _playSong(nextSong.audioPath);
  }

  void _playPreviousSong() {
    final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);
    playlistProvider.playPreviousSong();
    final previousSong =
        playlistProvider.playlist[playlistProvider.currentSongIndex ?? 0];
    _playSong(previousSong.audioPath);
  }

  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${duration.inMinutes}:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _audioPlayerService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, child) {
        final playlist = playlistProvider.playlist;
        final currentSong = playlist[playlistProvider.currentSongIndex ?? 0];

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),

                      // Title
                      const Text("P L A Y L I S T"),

                      // Menu button
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Album artwork
                  NeuBox(
                    child: Column(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),

                        // Song and artist name
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              // Song and artist name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(currentSong.artistName),
                                ],
                              ),

                              const Spacer(),

                              // Heart icon
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Song duration progress
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Start time
                            Text(formatTime(_currentDuration)),

                            // Shuffle icon
                            const Icon(Icons.shuffle),

                            // Repeat icon
                            const Icon(Icons.repeat),

                            // End time
                            Text(formatTime(_totalDuration)),
                          ],
                        ),
                      ),

                      // Song duration progress slider
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8),
                        ),
                        child: Slider(
                          min: 0,
                          max: _totalDuration.inSeconds.toDouble(),
                          value: _currentDuration.inSeconds.toDouble(),
                          activeColor: Colors.green,
                          onChanged: (value) {
                            _audioPlayerService
                                .seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Playback controls
                  Row(
                    children: [
                      // Skip previous
                      Expanded(
                        child: GestureDetector(
                          onTap: _playPreviousSong,
                          child: const NeuBox(
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Play/pause
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            if (_isPlaying) {
                              _pauseSong();
                            } else {
                              _resumeSong();
                            }
                          },
                          child: NeuBox(
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                        ),
                      ),

                      // Skip next
                      Expanded(
                        child: GestureDetector(
                          onTap: _playNextSong,
                          child: const NeuBox(
                            child: Icon(Icons.skip_next),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}