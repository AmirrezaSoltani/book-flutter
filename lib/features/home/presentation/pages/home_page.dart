import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/adult_media_player_bar.dart';
import '../../../../features/books/presentation/pages/books_page.dart';
import '../../../../features/books/presentation/pages/my_library_page.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';
import '../../../../features/reading/presentation/pages/reading_page.dart';
import '../../../../features/kids_zone/presentation/pages/kids_zone_page.dart';
import '../../../../features/ai_book/presentation/pages/ai_book_page.dart';
import '../../../../shared/models/book.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Audiobook state
  bool _showPlayer = false;
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _speed = 1.0;
  Timer? _hidePlayerTimer;

  String? _currentTitle;
  String? _currentAuthor;
  String? _currentCover;
  String? _currentAudio;

  final List<Widget> _pages = [];

  void _startAutoHideTimer() {
    _hidePlayerTimer?.cancel();
    _hidePlayerTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _showPlayer) {
        setState(() {
          _showPlayer = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      BooksPage(onPlayAudiobook: _loadAudiobook),
      KidsZonePage(
        onPlayAudiobook: (book) {
          setState(() {
            _isPlaying = true;
            _showPlayer = true;
          });
          _loadAudiobook(book);
        },
      ),

      const AIBookPage(),
            const MyLibraryPage(),
      const ProfilePage(),
    ]);
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
    _hidePlayerTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _loadAudiobook(Book book) async {
    setState(() {
      _showPlayer = true;
      _isPlaying = true;
      _currentTitle = book.title;
      _currentAuthor = book.author;
      _currentCover =
          book.coverAsset ?? 'assets/images/profile_placeholder.png';
      _currentAudio = book.audioAsset ?? 'audio/sample_story.mp3';
      _speed = 1.0;
    });
    await _audioPlayer.stop();
    await _audioPlayer.setPlaybackRate(_speed);
    await _audioPlayer.play(AssetSource(_currentAudio!));
    _startAutoHideTimer();
  }

  void _play() async {
    setState(() {
      _isPlaying = true;
    });
    if (_currentAudio != null) {
      await _audioPlayer.resume();
    }
    _startAutoHideTimer();
  }

  void _pause() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
    _startAutoHideTimer();
  }

  void _seek(double value) async {
    final newPosition = _duration * value;
    await _audioPlayer.seek(newPosition);
    setState(() {
      _position = newPosition;
    });
    _startAutoHideTimer();
  }

  void _closePlayer() {
    setState(() {
      _showPlayer = false;
    });
    _hidePlayerTimer?.cancel();
    // Audio continues playing in the background
  }

  void _skipBack() async {
    final newPos = _position - const Duration(seconds: 15);
    await _audioPlayer.seek(newPos > Duration.zero ? newPos : Duration.zero);
    setState(() {
      _position = newPos > Duration.zero ? newPos : Duration.zero;
    });
    _startAutoHideTimer();
  }

  void _skipForward() async {
    final newPos = _position + const Duration(seconds: 30);
    await _audioPlayer.seek(newPos < _duration ? newPos : _duration);
    setState(() {
      _position = newPos < _duration ? newPos : _duration;
    });
    _startAutoHideTimer();
  }

  void _changeSpeed(double newSpeed) async {
    setState(() {
      _speed = newSpeed;
    });
    await _audioPlayer.setPlaybackRate(newSpeed);
    _startAutoHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: (_showPlayer &&
                      _currentTitle != null &&
                      _currentAuthor != null)
                  ? 100
                  : 0,
              bottom: 80, // Add padding for floating bottom bar
            ),
            child: _pages[_selectedIndex],
          ),
          AnimatedSlide(
            offset:
                _showPlayer && _currentTitle != null && _currentAuthor != null
                    ? Offset.zero
                    : const Offset(0, -1),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              opacity:
                  _showPlayer && _currentTitle != null && _currentAuthor != null
                      ? 1.0
                      : 0.0,
              duration: const Duration(milliseconds: 400),
              child: SafeArea(
                child: AdultMediaPlayerBar(
                  title: _currentTitle ?? '',
                  author: _currentAuthor ?? '',
                  coverImagePath: _currentCover,
                  duration: _duration,
                  position: _position,
                  isPlaying: _isPlaying,
                  onPlay: _play,
                  onPause: _pause,
                  onSeek: _seek,
                  onClose: _closePlayer,
                  onSkipBack: _skipBack,
                  onSkipForward: _skipForward,
                  speed: _speed,
                  onSpeedChange: _changeSpeed,
                ),
              ),
            ),
          ),
          if (!_showPlayer && _currentTitle != null && _currentAuthor != null)
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 12),
                  child: _AnimatedShowPlayerButton(
                    onPressed: () {
                      setState(() {
                        _showPlayer = true;
                      });
                      _startAutoHideTimer();
                    },
                  ),
                ),
              ),
            ),
          // Custom Floating Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.book, 'Books'),
                  _buildNavItem(1, Icons.child_care, 'Kids'),
                      _buildNavItem(2, Icons.auto_stories, 'AI Book'),
                  _buildNavItem(3, Icons.library_books, 'Library'),
                  _buildNavItem(4, Icons.person, 'Profile'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedShowPlayerButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _AnimatedShowPlayerButton({required this.onPressed});

  @override
  State<_AnimatedShowPlayerButton> createState() =>
      _AnimatedShowPlayerButtonState();
}

class _AnimatedShowPlayerButtonState extends State<_AnimatedShowPlayerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _highlight = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 1.0,
      upperBound: 1.2,
    );
    _scaleAnim = _controller.drive(Tween(begin: 1.0, end: 1.2));
    _controller.repeat(reverse: true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.stop();
        setState(() {
          _highlight = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _highlight ? _scaleAnim : AlwaysStoppedAnimation(1.0),
      child: FloatingActionButton.small(
        heroTag: 'restorePlayer',
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        tooltip: 'Show Player',
        onPressed: widget.onPressed,
        child: const Icon(Icons.music_note),
      ),
    );
  }
}
