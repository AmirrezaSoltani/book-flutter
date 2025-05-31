import 'package:flutter/material.dart';

class ReadingSettings {
  final double fontSize;
  final String fontFamily;
  final double lineSpacing;
  final bool isDarkMode;
  final Color backgroundColor;
  final Color textColor;

  const ReadingSettings({
    this.fontSize = 18.0,
    this.fontFamily = 'Roboto',
    this.lineSpacing = 1.5,
    this.isDarkMode = false,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
  });

  ReadingSettings copyWith({
    double? fontSize,
    String? fontFamily,
    double? lineSpacing,
    bool? isDarkMode,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ReadingSettings(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
    );
  }
} 