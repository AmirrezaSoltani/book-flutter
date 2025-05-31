import 'package:flutter/material.dart';

class ReadingAnnotation {
  final int pageIndex;
  final String text;
  final String? note;
  final Color highlightColor;
  final DateTime createdAt;

  const ReadingAnnotation({
    required this.pageIndex,
    required this.text,
    this.note,
    this.highlightColor = Colors.yellow,
    required this.createdAt,
  });

  ReadingAnnotation copyWith({
    int? pageIndex,
    String? text,
    String? note,
    Color? highlightColor,
    DateTime? createdAt,
  }) {
    return ReadingAnnotation(
      pageIndex: pageIndex ?? this.pageIndex,
      text: text ?? this.text,
      note: note ?? this.note,
      highlightColor: highlightColor ?? this.highlightColor,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 