import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../presentation/models/reading_annotation.dart';
import '../../presentation/models/reading_stats.dart';

class ReadingPersistenceService {
  final SharedPreferences _prefs;
  static const String _annotationsKey = 'reading_annotations';
  static const String _bookmarksKey = 'reading_bookmarks';
  static const String _statsKey = 'reading_stats';

  ReadingPersistenceService(this._prefs);

  Future<void> saveAnnotations(
      String bookId, List<ReadingAnnotation> annotations) async {
    final annotationsJson = annotations
        .map((a) => {
              'pageIndex': a.pageIndex,
              'text': a.text,
              'note': a.note,
              'highlightColor': a.highlightColor.value,
              'createdAt': a.createdAt.toIso8601String(),
            })
        .toList();
    await _prefs.setString(
        '${_annotationsKey}_$bookId', jsonEncode(annotationsJson));
  }

  Future<List<ReadingAnnotation>> loadAnnotations(String bookId) async {
    final annotationsJson = _prefs.getString('${_annotationsKey}_$bookId');
    if (annotationsJson == null) return [];

    final List<dynamic> decoded = jsonDecode(annotationsJson);
    return decoded
        .map((item) => ReadingAnnotation(
              pageIndex: item['pageIndex'],
              text: item['text'],
              note: item['note'],
              highlightColor: Color(item['highlightColor']),
              createdAt: DateTime.parse(item['createdAt']),
            ))
        .toList();
  }

  Future<void> saveBookmarks(String bookId, List<int> bookmarks) async {
    await _prefs.setStringList('${_bookmarksKey}_$bookId',
        bookmarks.map((e) => e.toString()).toList());
  }

  Future<List<int>> loadBookmarks(String bookId) async {
    final bookmarks = _prefs.getStringList('${_bookmarksKey}_$bookId');
    if (bookmarks == null) return [];
    return bookmarks.map((e) => int.parse(e)).toList();
  }

  Future<void> saveStats(String bookId, ReadingStats stats) async {
    final statsJson = {
      'totalPages': stats.totalPages,
      'pagesRead': stats.pagesRead,
      'totalTimeMinutes': stats.totalTimeMinutes,
      'bookmarksCount': stats.bookmarksCount,
      'highlightsCount': stats.highlightsCount,
      'notesCount': stats.notesCount,
      'lastRead': stats.lastRead.toIso8601String(),
    };
    await _prefs.setString('${_statsKey}_$bookId', jsonEncode(statsJson));
  }

  Future<ReadingStats?> loadStats(String bookId) async {
    final statsJson = _prefs.getString('${_statsKey}_$bookId');
    if (statsJson == null) return null;

    final Map<String, dynamic> decoded = jsonDecode(statsJson);
    return ReadingStats(
      totalPages: decoded['totalPages'],
      pagesRead: decoded['pagesRead'],
      totalTimeMinutes: decoded['totalTimeMinutes'],
      bookmarksCount: decoded['bookmarksCount'],
      highlightsCount: decoded['highlightsCount'],
      notesCount: decoded['notesCount'],
      lastRead: DateTime.parse(decoded['lastRead']),
    );
  }
}
