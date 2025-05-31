import 'package:flutter/material.dart';
import '../../../../shared/models/book.dart';
import '../models/reading_settings.dart';
import '../models/reading_annotation.dart';
import '../models/reading_stats.dart';
import '../widgets/reading_settings_dialog.dart';
import '../widgets/table_of_contents.dart';
import 'reading_goals_page.dart';

class BookReaderPage extends StatefulWidget {
  final Book book;

  const BookReaderPage({
    super.key,
    required this.book,
  });

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  int _currentPage = 0;
  bool _showControls = true;
  final PageController _pageController = PageController();
  late ReadingSettings _settings;
  final List<int> _bookmarks = [];
  final List<ReadingAnnotation> _annotations = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _searchResultIndex = -1;
  List<int> _searchResults = [];
  final DateTime _startTime = DateTime.now();
  late ReadingStats _stats;

  // Sample book content - in a real app, this would come from a database or API
  final List<String> _pages = [
    "Chapter 1\n\nThe sun was setting behind the mountains, casting long shadows across the valley. Birds were returning to their nests, and the air was filled with the sweet scent of evening flowers.",
    "The old house stood silent and still, its windows reflecting the last rays of sunlight. Inside, dust motes danced in the golden light, and the wooden floor creaked underfoot.",
    "Sarah had always loved this time of day. It was when the world seemed to pause, taking a deep breath before the night settled in. She sat on the porch swing, a book in her lap, watching the colors change in the sky.",
    "The wind rustled through the trees, carrying with it the promise of rain. Dark clouds gathered on the horizon, moving slowly but steadily toward the valley. Sarah closed her book and stood up, stretching her arms above her head.",
    "As she made her way back inside, the first drops of rain began to fall. They pattered against the roof, a gentle rhythm that would soon grow into a steady downpour. Sarah smiled, knowing that tomorrow the valley would be fresh and new.",
  ];

  final List<Chapter> _chapters = [
    const Chapter(title: 'Chapter 1', subtitle: 'The Beginning'),
    const Chapter(title: 'Chapter 2', subtitle: 'The Old House'),
    const Chapter(title: 'Chapter 3', subtitle: 'Evening Thoughts'),
    const Chapter(title: 'Chapter 4', subtitle: 'The Storm Approaches'),
    const Chapter(title: 'Chapter 5', subtitle: 'The Rain'),
  ];

  @override
  void initState() {
    super.initState();
    _settings = const ReadingSettings();
    _stats = ReadingStats(
      totalPages: _pages.length,
      pagesRead: 0,
      totalTimeMinutes: 0,
      bookmarksCount: 0,
      highlightsCount: 0,
      notesCount: 0,
      lastRead: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => ReadingSettingsDialog(
        initialSettings: _settings,
        onSettingsChanged: (settings) {
          setState(() {
            _settings = settings;
          });
        },
      ),
    );
  }

  void _showTableOfContents() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: TableOfContents(
          chapters: _chapters,
          onChapterSelected: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      if (_bookmarks.contains(_currentPage)) {
        _bookmarks.remove(_currentPage);
      } else {
        _bookmarks.add(_currentPage);
      }
      _updateStats();
    });
  }

  void _showSearchBar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Enter search term',
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _searchResults = _findSearchResults();
              _searchResultIndex = -1;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<int> _findSearchResults() {
    if (_searchQuery.isEmpty) return [];
    final results = <int>[];
    for (int i = 0; i < _pages.length; i++) {
      if (_pages[i].toLowerCase().contains(_searchQuery.toLowerCase())) {
        results.add(i);
      }
    }
    return results;
  }

  void _navigateToSearchResult(int index) {
    if (index >= 0 && index < _searchResults.length) {
      _pageController.animateToPage(
        _searchResults[index],
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _searchResultIndex = index;
      });
    }
  }

  void _addAnnotation(String text, {String? note, Color? highlightColor}) {
    setState(() {
      _annotations.add(
        ReadingAnnotation(
          pageIndex: _currentPage,
          text: text,
          note: note,
          highlightColor: highlightColor ?? Colors.yellow,
          createdAt: DateTime.now(),
        ),
      );
      _updateStats();
    });
  }

  void _showNoteDialog(String selectedText) {
    final TextEditingController noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Selected text: "$selectedText"'),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: 'Enter your note',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addAnnotation(selectedText, note: noteController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showHighlightColorPicker(String selectedText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Highlight Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.purple,
          ].map((color) {
            return InkWell(
              onTap: () {
                _addAnnotation(selectedText, highlightColor: color);
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _updateStats() {
    setState(() {
      _stats = _stats.copyWith(
        pagesRead: _currentPage + 1,
        totalTimeMinutes: DateTime.now().difference(_startTime).inMinutes,
        bookmarksCount: _bookmarks.length,
        highlightsCount: _annotations.where((a) => a.note == null).length,
        notesCount: _annotations.where((a) => a.note != null).length,
        lastRead: DateTime.now(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            color: _settings.backgroundColor,
          ),
          // Book content
          GestureDetector(
            onTap: _toggleControls,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _updateStats();
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: SelectableText.rich(
                    TextSpan(
                      text: _pages[index],
                      style: TextStyle(
                        fontSize: _settings.fontSize,
                        height: _settings.lineSpacing,
                        color: Colors.black87,
                        fontFamily: _settings.fontFamily,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    onSelectionChanged: (selection, cause) {
                      if (!selection.isCollapsed) {
                        final selectedText = _pages[index].substring(
                          selection.start,
                          selection.end,
                        );
                        _showSelectionMenu(selectedText);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          // Controls overlay
          if (_showControls)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _settings.backgroundColor.withOpacity(0.9),
                    _settings.backgroundColor.withOpacity(0.7),
                    Colors.transparent,
                    Colors.transparent,
                    _settings.backgroundColor.withOpacity(0.7),
                    _settings.backgroundColor.withOpacity(0.9),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                            color: _settings.textColor,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.book.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _settings.textColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget.book.author,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _settings.textColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _showSearchBar,
                            color: _settings.textColor,
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            onPressed: _toggleBookmark,
                            color: _settings.textColor,
                          ),
                          IconButton(
                            icon: const Icon(Icons.menu_book),
                            onPressed: _showTableOfContents,
                            color: _settings.textColor,
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: _showSettings,
                            color: _settings.textColor,
                          ),
                          IconButton(
                            icon: const Icon(Icons.flag),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ReadingGoalsPage(),
                                ),
                              );
                            },
                            color: _settings.textColor,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Bottom bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Progress bar
                          LinearProgressIndicator(
                            value: (_currentPage + 1) / _pages.length,
                            backgroundColor:
                                _settings.backgroundColor.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Navigation controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios),
                                onPressed: _currentPage > 0
                                    ? () => _pageController.previousPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        )
                                    : null,
                                color: _settings.textColor,
                              ),
                              Text(
                                '${_currentPage + 1} / ${_pages.length}',
                                style: TextStyle(
                                  color: _settings.textColor.withOpacity(0.7),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: _currentPage < _pages.length - 1
                                    ? () => _pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        )
                                    : null,
                                color: _settings.textColor,
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
          // Search results overlay
          if (_searchQuery.isNotEmpty && _searchResults.isNotEmpty)
            Positioned(
              top: 100,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _settings.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_searchResultIndex + 1} of ${_searchResults.length}',
                      style: TextStyle(color: _settings.textColor),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: _searchResultIndex > 0
                              ? () => _navigateToSearchResult(
                                  _searchResultIndex - 1)
                              : null,
                          color: _settings.textColor,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          onPressed:
                              _searchResultIndex < _searchResults.length - 1
                                  ? () => _navigateToSearchResult(
                                      _searchResultIndex + 1)
                                  : null,
                          color: _settings.textColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSelectionMenu(String selectedText) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.highlight),
              title: const Text('Highlight'),
              onTap: () {
                Navigator.pop(context);
                _showHighlightColorPicker(selectedText);
              },
            ),
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('Add Note'),
              onTap: () {
                Navigator.pop(context);
                _showNoteDialog(selectedText);
              },
            ),
          ],
        ),
      ),
    );
  }
}
