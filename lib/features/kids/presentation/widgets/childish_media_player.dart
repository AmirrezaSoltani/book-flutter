import 'package:flutter/material.dart';

class ChildishMediaPlayer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imagePath;
  final Duration duration;
  final Duration position;
  final void Function()? onPlay;
  final void Function()? onPause;
  final void Function(double)? onSeek;
  final bool isPlaying;

  const ChildishMediaPlayer({
    super.key,
    required this.title,
    this.subtitle,
    this.imagePath,
    required this.duration,
    required this.position,
    this.onPlay,
    this.onPause,
    this.onSeek,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = duration.inMilliseconds == 0
        ? 0.0
        : position.inMilliseconds / duration.inMilliseconds;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade200,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: imagePath != null
                    ? Image.asset(
                        imagePath!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 56,
                          height: 56,
                          color: Colors.yellow.shade400,
                          child: const Icon(Icons.music_note, color: Colors.purple, size: 36),
                        ),
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        color: Colors.yellow.shade400,
                        child: const Icon(Icons.music_note, color: Colors.purple, size: 36),
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
                        color: Colors.purple,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.deepPurple,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: isPlaying ? onPause : onPlay,
                child: CircleAvatar(
                  backgroundColor: Colors.yellow.shade400,
                  radius: 28,
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.purple,
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.yellow.shade700,
              inactiveTrackColor: Colors.yellow.shade200,
              thumbColor: Colors.purple,
              overlayColor: Colors.purple.withOpacity(0.2),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: duration.inMilliseconds == 0 ? null : onSeek,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
              ),
              Text(
                _formatDuration(duration),
                style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
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