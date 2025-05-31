import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/childish_media_player.dart';

class KidsZonePage extends StatefulWidget {
  const KidsZonePage({super.key});

  @override
  State<KidsZonePage> createState() => _KidsZonePageState();
}

class _KidsZonePageState extends State<KidsZonePage> {
  String? _currentTitle;
  String? _currentSubtitle;
  String? _currentImagePath;
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playStory(String title, String? subtitle, String imagePath) async {
    setState(() {
      _currentTitle = title;
      _currentSubtitle = subtitle;
      _currentImagePath = imagePath;
      _isPlaying = true;
      _position = Duration.zero;
    });
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('audio/sample_story.mp3'));
  }

  void _pauseStory() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _resumeStory() async {
    await _audioPlayer.resume();
    setState(() {
      _isPlaying = true;
    });
  }

  void _seekStory(double value) async {
    final newPosition = _duration * value;
    await _audioPlayer.seek(newPosition);
    setState(() {
      _position = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.purple.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentTitle != null)
                ChildishMediaPlayer(
                  title: _currentTitle!,
                  subtitle: _currentSubtitle,
                  imagePath: _currentImagePath,
                  duration: _duration,
                  position: _position,
                  isPlaying: _isPlaying,
                  onPlay: _resumeStory,
                  onPause: _pauseStory,
                  onSeek: _seekStory,
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Kids Zone',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.purple.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildStoryCard(
                      context,
                      'The Magic Garden',
                      'A magical adventure in a garden full of talking flowers',
                      'assets/images/magic_garden.png',
                      Colors.green.shade200,
                    ),
                    const SizedBox(height: 16),
                    _buildStoryCard(
                      context,
                      'Space Adventure',
                      'Join Captain Star on an exciting journey through space',
                      'assets/images/space_adventure.png',
                      Colors.blue.shade200,
                    ),
                    const SizedBox(height: 16),
                    _buildStoryCard(
                      context,
                      'Ocean Friends',
                      'Meet friendly sea creatures in this underwater tale',
                      'assets/images/ocean_friends.png',
                      Colors.cyan.shade200,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryCard(
    BuildContext context,
    String title,
    String description,
    String imagePath,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.7)],
          ),
        ),
        child: InkWell(
          onTap: () {
            _playStory(title, description, imagePath);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.auto_stories,
                      size: 50,
                      color: Colors.purple,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.play_circle_filled,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () {
                              _playStory(title, description, imagePath);
                            },
                          ),
                          const Text(
                            'Play Story',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 