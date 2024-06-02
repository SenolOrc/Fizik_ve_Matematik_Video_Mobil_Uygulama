import 'package:flutter/material.dart';

enum CustomBorders {
  lowBorderRadius(12),
  normalBorderRadius(16),
  highBorderRadius(24);

  final double borderRadius;

  const CustomBorders(this.borderRadius);

  BorderRadius getBorderRadius() {
    return BorderRadius.circular(borderRadius);
  }
}
