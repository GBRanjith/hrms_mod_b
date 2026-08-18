abstract final class AppBreakpoints {
  static const double compact = 600; // phones
  static const double medium = 840; // small tablets

  static bool isCompact(double width) => width < compact;
  static bool isMedium(double width) => width >= compact && width < medium;
  static bool isExpanded(double width) => width >= medium;
}
