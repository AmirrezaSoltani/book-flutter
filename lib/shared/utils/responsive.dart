import 'package:flutter/material.dart';

double responsiveFont(BuildContext context, double baseSize) {
  double width = MediaQuery.of(context).size.width;
  return (baseSize * (width / 375.0)).clamp(baseSize * 0.85, baseSize * 1.3);
} 