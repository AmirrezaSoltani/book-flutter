import 'package:flutter/material.dart';

class AdultMediaPlayerBar extends StatelessWidget {
  final String title;
  final String author;
  final String? coverImagePath;
  final Duration duration;
  final Duration position;
  final bool isPlaying;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final ValueChanged<double>? onSeek;
  final VoidCallback? onClose;
  final VoidCallback? onSkipBack;
  final VoidCallback? onSkipForward;
  final double speed;
  final ValueChanged<double>? onSpeedChange;

  const AdultMediaPlayerBar({
    super.key,
    required this.title,
    required this.author,
    this.coverImagePath,
    required this.duration,
    required this.position,
    required this.isPlaying,
    this.onPlay,
    this.onPause,
    this.onSeek,
    this.onClose,
    this.onSkipBack,
    this.onSkipForward,
    this.speed = 1.0,
    this.onSpeedChange,
  });

  @override
  Widget build(BuildContext context) {
    final progress = duration.inMilliseconds == 0
        ? 0.0
        : position.inMilliseconds / duration.inMilliseconds;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 56,
        maxHeight: 150,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cover Art
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 1.0, end: isPlaying ? 1.05 : 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                builder: (context, scale, child) => Transform.scale(
                  scale: scale,
                  child: child,
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: (coverImagePath != null)
                      ? AssetImage(coverImagePath!)
                      : null,
                  child: coverImagePath == null
                      ? const Icon(Icons.audiotrack, color: Colors.blueAccent, size: 22)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              // Info & Controls
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Author
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDuration(position),
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          '/',
                          style: TextStyle(fontSize: 11, color: Colors.black38),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          _formatDuration(duration),
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ],
                    ),
                    // Slider Row
                    Row(
                      children: [
                        Expanded(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0)),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, value, child) => Slider(
                              value: value,
                              onChanged: duration.inMilliseconds == 0 ? null : onSeek,
                              activeColor: Colors.blueAccent,
                              inactiveColor: Colors.blue[100],
                              min: 0,
                              max: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Controls Row
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.replay_10, color: Colors.blueAccent, size: 20),
                            tooltip: 'Skip Back 15s',
                            onPressed: onSkipBack,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                          IconButton(
                            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.blueAccent, size: 26),
                            onPressed: isPlaying ? onPause : onPlay,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                          IconButton(
                            icon: const Icon(Icons.forward_10, color: Colors.blueAccent, size: 20),
                            tooltip: 'Skip Forward 30s',
                            onPressed: onSkipForward,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                          PopupMenuButton<double>(
                            initialValue: speed,
                            tooltip: 'Playback Speed',
                            icon: const Icon(Icons.speed, color: Colors.blueAccent, size: 18),
                            onSelected: onSpeedChange,
                            itemBuilder: (context) => [
                              for (final s in [0.5, 0.75, 1.0, 1.25, 1.5, 2.0])
                                PopupMenuItem(
                                  value: s,
                                  child: Text('${s}x'),
                                ),
                            ],
                            padding: EdgeInsets.zero,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.black38, size: 20),
                            onPressed: onClose,
                            tooltip: 'Close Player',
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
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

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return '$m:$s';
  }
} 