import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color seed = Color(0xFF2E5AAC);

  // Claim status — light mode
  static const Color pendingLight = Color(0xFFB26A00);
  static const Color approvedLight = Color(0xFF1B7F4A);
  static const Color rejectedLight = Color(0xFFB3261E);

  // Claim status — dark mode
  static const Color pendingDark = Color(0xFFFFB865);
  static const Color approvedDark = Color(0xFF6FD69B);
  static const Color rejectedDark = Color(0xFFFFB4AB);
}