import 'package:flutter/material.dart';
import '../../../../shared/models/book.dart';

class KidsZonePage extends StatelessWidget {
  final void Function(Book book)? onPlayAudiobook;

  const KidsZonePage({
    super.key,
    this.onPlayAudiobook,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[100]!,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Kids Zone',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
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
                      'A magical adventure in a garden full of talking flowers.',
                      'assets/images/magic_garden.png',
                      onPlay: () {
                        if (onPlayAudiobook != null) {
                          onPlayAudiobook!(Book(
                            id: '3',
                            title: 'The Magic Garden',
                            author: 'Kids Collection',
                            description: 'A magical adventure in a garden full of talking flowers.',
                            coverUrl: 'https://example.com/magic_garden.jpg',
                            price: 14.99,
                            rating: 4.9,
                            categories: ['Children', 'Fiction'],
                            coverAsset: 'assets/images/magic_garden.png',
                            audioAsset: 'audio/sample_story.mp3',
                          ));
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildStoryCard(
                      context,
                      'Space Adventure',
                      'Join Captain Star on an exciting journey through space.',
                      'assets/images/space_adventure.png',
                      onPlay: () {
                        if (onPlayAudiobook != null) {
                          onPlayAudiobook!(Book(
                            id: '4',
                            title: 'Space Adventure',
                            author: 'Captain Star',
                            description: 'Join Captain Star on an exciting journey through space.',
                            coverUrl: 'https://example.com/space.jpg',
                            price: 11.99,
                            rating: 4.7,
                            categories: ['Children', 'Science'],
                            coverAsset: 'assets/images/space_adventure.png',
                            audioAsset: 'audio/sample_story.mp3',
                          ));
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildStoryCard(
                      context,
                      'Ocean Explorers',
                      'Discover the wonders of the deep sea with friendly sea creatures.',
                      'assets/images/ocean_explorers.png',
                      onPlay: () {
                        if (onPlayAudiobook != null) {
                          onPlayAudiobook!(Book(
                            id: '5',
                            title: 'Ocean Explorers',
                            author: 'Marine Adventures',
                            description: 'Discover the wonders of the deep sea with friendly sea creatures.',
                            coverUrl: 'https://example.com/ocean.jpg',
                            price: 13.99,
                            rating: 4.6,
                            categories: ['Children', 'Adventure'],
                            coverAsset: 'assets/images/ocean_explorers.png',
                            audioAsset: 'audio/sample_story.mp3',
                          ));
                        }
                      },
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
    String imagePath, {
    required VoidCallback onPlay,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onPlay,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.book,
                    size: 40,
                    color: Colors.purple[800],
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: onPlay,
                icon: const Icon(Icons.play_circle_filled),
                color: Colors.purple[800],
                iconSize: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 