import 'package:flutter/material.dart';

class TableOfContents extends StatelessWidget {
  final List<Chapter> chapters;
  final Function(int) onChapterSelected;

  const TableOfContents({
    super.key,
    required this.chapters,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Table of Contents',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                return ListTile(
                  title: Text(chapter.title),
                  subtitle: Text(chapter.subtitle),
                  onTap: () {
                    onChapterSelected(index);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Chapter {
  final String title;
  final String subtitle;

  const Chapter({
    required this.title,
    required this.subtitle,
  });
} 