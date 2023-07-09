import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData getTheme({bool isDark = false}) {
    return ThemeData(
      scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
      useMaterial3: true,
    );
  }

  static ThemeData get lightTheme => getTheme();

  static ThemeData get darkTheme => getTheme(isDark: true);
}
