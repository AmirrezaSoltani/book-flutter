class ReadingStats {
  final int totalPages;
  final int pagesRead;
  final int totalTimeMinutes;
  final int bookmarksCount;
  final int highlightsCount;
  final int notesCount;
  final DateTime lastRead;

  const ReadingStats({
    required this.totalPages,
    required this.pagesRead,
    required this.totalTimeMinutes,
    required this.bookmarksCount,
    required this.highlightsCount,
    required this.notesCount,
    required this.lastRead,
  });

  double get progress => pagesRead / totalPages;
  int get remainingPages => totalPages - pagesRead;
  int get averageTimePerPage => totalTimeMinutes ~/ pagesRead;

  ReadingStats copyWith({
    int? totalPages,
    int? pagesRead,
    int? totalTimeMinutes,
    int? bookmarksCount,
    int? highlightsCount,
    int? notesCount,
    DateTime? lastRead,
  }) {
    return ReadingStats(
      totalPages: totalPages ?? this.totalPages,
      pagesRead: pagesRead ?? this.pagesRead,
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      highlightsCount: highlightsCount ?? this.highlightsCount,
      notesCount: notesCount ?? this.notesCount,
      lastRead: lastRead ?? this.lastRead,
    );
  }
} 